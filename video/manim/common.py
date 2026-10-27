"""Shared helpers for the Unit I videos (Manim Community, default 3b1b look).

The simulated values come from R (export.R) with the same seeds as the notes.
"""

import csv
import json
from math import exp, log, pi
from pathlib import Path

import numpy as np
from manim import BLACK, BLUE, DL, UP, YELLOW, Axes, Rectangle, Tex, VGroup, smooth

HERE = Path(__file__).parent
BREAKS = json.loads((HERE / "breaks.json").read_text())

MAIN = BLUE         # histograms, population
HIGHLIGHT = YELLOW  # observed value, tails


def read_col(name, col):
    with open(HERE / name) as f:
        return [float(r[col]) for r in csv.DictReader(f)]


def bin_index(x, breaks):
    """Right-closed classes as in R's hist(): (b_i, b_{i+1}], the first one closed."""
    for i in range(len(breaks) - 1):
        if x <= breaks[i + 1] + 1e-9:
            return i
    raise ValueError(x)


def normal_density(x, mu, sd):
    return exp(-0.5 * ((x - mu) / sd) ** 2) / (sd * (2 * pi) ** 0.5)


def geometric_rate(start, end):
    """Rate function for m: start -> end growing geometrically, with smooth start and stop."""
    def f(t):
        m = start * (end / start) ** smooth(t)
        return (m - start) / (end - start)
    return f


class HistPanel:
    """Histogram of R simulated values on fixed screen axes, with a zoomable y range."""

    def __init__(self, values, breaks, x_range, x_numbers, x_dec, origin, x_length,
                 y_length=4.6, step=0.05):
        self.values = values
        self.B = breaks
        self.NB = len(breaks) - 1
        self.idx = [bin_index(v, breaks) for v in values]
        self.R = len(values)
        self.x_range = x_range
        self.x_numbers = x_numbers
        self.x_dec = x_dec
        self.origin = np.array(origin)
        self.x_length = x_length
        self.y_length = y_length
        self.step = step
        self.width = breaks[1] - breaks[0]
        # upper envelope of the tallest relative frequency, from m onwards
        env = [0.0] * (self.R + 1)
        counts = [0] * self.NB
        tallest = [0.0] * (self.R + 1)
        for m in range(1, self.R + 1):
            counts[self.idx[m - 1]] += 1
            tallest[m] = max(counts) / m
        env[self.R] = tallest[self.R]
        for m in range(self.R - 1, 0, -1):
            env[m] = max(tallest[m], env[m + 1])
        self.env = env

    # -- axes ----------------------------------------------------------------
    def axes(self, ymax, step=None, nums=None, dec=2, fade=False):
        step = step or self.step
        if nums is None:
            nums = [round(k * step, 4) for k in range(1, 40) if k * step <= ymax + 1e-9]
        ax = Axes(
            x_range=self.x_range,
            y_range=[0, ymax, step],
            x_length=self.x_length,
            y_length=self.y_length,
            axis_config={"include_tip": False, "font_size": 24},
            x_axis_config={
                "numbers_to_include": self.x_numbers,
                "decimal_number_config": {"num_decimal_places": self.x_dec},
            },
            y_axis_config={
                "numbers_to_include": nums,
                "decimal_number_config": {"num_decimal_places": dec},
            },
        )
        ax.shift(self.origin - ax.c2p(self.x_range[0], 0))
        if fade:
            # labels close to the top of a shrinking axis fade out instead of popping
            for v, lab in zip(nums, ax.y_axis.numbers):
                lab.set_opacity(min(max((ymax - v) / (0.25 * step), 0.0), 1.0))
        return ax

    def density_axes(self, ymax_rel, step, nums, dec):
        """Same screen geometry, y measured as density = relative frequency / class width."""
        return self.axes(ymax_rel / self.width, step=step, nums=nums, dec=dec)

    def y_label(self, ax, text):
        return Tex(text, font_size=26).next_to(ax.y_axis, UP, buff=0.15)

    # -- heights ---------------------------------------------------------------
    def counts(self, m):
        c = [0] * self.NB
        for i in self.idx[:m]:
            c[i] += 1
        return c

    def rel(self, m):
        return [c / m for c in self.counts(m)] if m > 0 else [0.0] * self.NB

    def bars(self, ax, heights, color=MAIN):
        g = VGroup()
        for i, h in enumerate(heights):
            p0 = ax.c2p(self.B[i], 0)
            p1 = ax.c2p(self.B[i + 1], max(h, 1e-6))
            bar = Rectangle(
                width=p1[0] - p0[0], height=p1[1] - p0[1],
                fill_color=color, fill_opacity=0.75, stroke_color=BLACK, stroke_width=1.5,
            ).move_to(p0, aligned_edge=DL)
            if h <= 1e-9:
                bar.set_opacity(0)
            g.add(bar)
        return g

    def tail(self, bars, threshold):
        return VGroup(*[bars[i] for i in range(self.NB) if self.B[i] >= threshold - 1e-9])

    # -- the fast phase ----------------------------------------------------------
    def grow(self, scene, m, ymax, y_axis, y_lab, hist, run_time, extra=()):
        """Animate m -> R: smoothed bar heights and a smooth zoom of the y axis.

        m, ymax: ValueTrackers. y_axis, y_lab, hist: mobjects redrawn in place.
        extra: further animations to play at the same time.
        """
        start = int(round(m.get_value()))
        disp = np.array(self.rel(start), dtype=float)
        floor = self.env[self.R] * 1.12

        def cur_m():
            return max(1, int(round(m.get_value())))

        def zoom(mob, dt):
            target = max(self.env[cur_m()] * 1.08, floor)
            v = mob.get_value()
            mob.set_value(max(target, v + (target - v) * min(1.0, 3.0 * dt)))

        def redraw(mob, dt):
            target = np.array(self.rel(cur_m()))
            disp[:] = disp + (target - disp) * min(1.0, 10.0 * dt)
            ax = self.axes(ymax.get_value(), fade=True)
            hist.become(self.bars(ax, disp))
            y_axis.become(ax.y_axis)
            y_lab.become(self.y_label(ax, "relative frequency"))

        ymax.add_updater(zoom)
        hist.add_updater(redraw)
        scene.add(ymax)
        scene.play(m.animate.set_value(self.R), *extra, run_time=run_time,
                   rate_func=geometric_rate(start, self.R))
        ymax.clear_updaters()
        hist.clear_updaters()
        # settle exactly on the final relative frequencies and the final axis
        final_ax = self.axes(floor)
        scene.play(
            hist.animate.become(self.bars(final_ax, self.rel(self.R))),
            y_axis.animate.become(final_ax.y_axis),
            y_lab.animate.become(self.y_label(final_ax, "relative frequency")),
            run_time=1.0,
        )
        return final_ax, floor
