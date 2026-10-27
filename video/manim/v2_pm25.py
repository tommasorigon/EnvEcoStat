"""Unit I - Air pollution in a city: repeated campaigns, the sampling distribution of
the sample mean and the central limit theorem."""

import csv
import gzip
import random
from math import erf, exp, lgamma, log, sqrt

from manim import *

from common import BREAKS, HERE, HIGHLIGHT, MAIN, HistPanel, normal_density, read_col

MU, SIGMA, N = 28, 12, 64
K = MU**2 / SIGMA**2      # shape
LAM = MU / SIGMA**2       # rate
SE = SIGMA / sqrt(N)      # 1.5
Y_BAR = read_col("y_bar.csv", "y_bar")
with gzip.open(HERE / "campaigns.csv.gz", "rt") as f:
    DAYS = [[float(v) for v in row] for row in list(csv.reader(f))[1:]]

PANEL = HistPanel(
    Y_BAR, BREAKS["b2"],
    x_range=[22, 34, 1], x_numbers=[22, 24, 26, 28, 30, 32, 34], x_dec=0,
    origin=[-1.0, -2.45, 0], x_length=7.7,
)

LEFT_X = -4.45                              # centre of the left column
SLOTS = [-1.2, -1.95, -2.75, -3.5]         # rows for formulas under the population


def dgamma(x):
    if x <= 0:
        return 0.0
    return exp(K * log(LAM) + (K - 1) * log(x) - LAM * x - lgamma(K))


def slot(mob, i):
    return mob.move_to([LEFT_X, SLOTS[i], 0])


class AirPollution(Scene):
    def construct(self):
        rng = random.Random(64)
        P = PANEL

        # ---- Population of daily PM2.5 ------------------------------------
        pop = Axes(
            x_range=[0, 100, 10], y_range=[0, 0.04, 0.01], x_length=4.6, y_length=2.3,
            axis_config={"include_tip": False, "font_size": 22},
            x_axis_config={"numbers_to_include": [0, 20, 40, 60, 80, 100]},
        )
        pop.shift(np.array([-6.75, -0.35, 0]) - pop.c2p(0, 0))
        dens = pop.plot(dgamma, x_range=[0.05, 100], color=MAIN, stroke_width=4)
        y_lab_pop = MathTex("y", font_size=32).next_to(pop.x_axis, RIGHT, buff=0.15)
        mu_line = DashedLine(pop.c2p(MU, 0), pop.c2p(MU, 0.04), color=GREY_B, stroke_width=2)
        params = slot(MathTex(r"\mu = 28, \qquad \sigma = 12", font_size=36), 0)
        self.play(Create(pop.x_axis), FadeIn(y_lab_pop))
        self.play(Create(dens), run_time=2)
        self.play(Create(mu_line), Write(params))
        self.wait(4)

        n_lab = MathTex(r"n = 64", font_size=40).move_to([LEFT_X, 3.0, 0])
        self.play(Write(n_lab))
        self.wait(1.5)

        # ---- Sample-mean axis -----------------------------------------------
        ax0 = P.axes(0.16)
        x_lab = MathTex(r"\bar{y}", font_size=36).next_to(ax0.x_axis, DOWN, buff=0.5)
        self.play(Create(ax0.x_axis), FadeIn(x_lab))
        self.wait(1.5)

        r_num = Integer(0, font_size=34, group_with_commas=False)
        r_row = VGroup(MathTex(r"R =", font_size=34), r_num).arrange(RIGHT, buff=0.15)
        r_row.move_to(ax0.c2p(22.8, 0.16), aligned_edge=UL)
        ybar_num = DecimalNumber(Y_BAR[0], num_decimal_places=2, font_size=40)
        readout = slot(VGroup(MathTex(r"\bar{y} =", font_size=40), ybar_num)
                       .arrange(RIGHT, buff=0.15), 1)

        # the 64 days of a campaign: a rug of dots under the density
        base_y = pop.c2p(0, 0)[1]
        rug_y = [base_y + rng.uniform(0.1, 0.42) for _ in range(N)]

        def day_dot(j, x):
            return Dot([pop.c2p(x, 0)[0], rug_y[j], 0], radius=0.04, color=WHITE)

        # ---- First campaigns one by one --------------------------------------
        first = 8
        stacks = [VGroup() for _ in range(P.NB)]
        dot_r = 0.075
        for r in range(first):
            slow = r < 3
            days = VGroup(*[day_dot(j, x) for j, x in enumerate(DAYS[r])])
            for d in days:
                d.save_state()
                d.shift(UP * 1.2).set_opacity(0)
            anims = [LaggedStart(*[Restore(d) for d in days], lag_ratio=0.03)]
            if r == 0:
                anims.append(FadeIn(r_row))
            self.play(*anims, run_time=1.8 if slow else 1.0)
            self.wait(0.6 if slow else 0.1)

            # the days collapse into their mean
            v = Y_BAR[r]
            centre = [pop.c2p(v, 0)[0], base_y + 0.26, 0]
            mean_dot = Dot(centre, radius=dot_r, color=WHITE)
            mean_anims = [
                *[d.animate.move_to(centre).set_opacity(0.3) for d in days],
                FadeIn(mean_dot),
                FadeIn(readout) if r == 0 else ChangeDecimalToValue(ybar_num, v),
            ]
            if r == 0:
                ybar_num.set_value(v)
            self.play(*mean_anims, run_time=1.4 if slow else 0.7)
            self.remove(days, *days)

            # and the mean flies to the histogram
            i = P.idx[r]
            xc = (P.B[i] + P.B[i + 1]) / 2
            target = ax0.c2p(xc, 0) + UP * (dot_r * (2 * len(stacks[i]) + 1) + 0.02)
            self.play(MoveAlongPath(mean_dot, ArcBetweenPoints(centre, target, angle=-PI / 4)),
                      run_time=1.6 if slow else 0.8)
            stacks[i].add(mean_dot)
            r_num.set_value(r + 1)
            self.wait(1.0 if slow else 0.25)

        # ---- The dots become a relative-frequency histogram -----------------
        m = ValueTracker(first)
        ymax = ValueTracker(P.env[first] * 1.08)
        ax_start = P.axes(ymax.get_value(), fade=True)
        y_axis = ax_start.y_axis.copy()
        y_lab = P.y_label(ax_start, "relative frequency")
        hist = P.bars(ax_start, P.rel(first))
        self.play(
            Create(y_axis), FadeIn(y_lab),
            *[ReplacementTransform(stacks[i], hist[i]) for i in range(P.NB) if len(stacks[i])],
            run_time=2,
        )
        self.add(hist)
        self.wait(2)

        # ---- Fast: every new campaign moves the 64 days to their new values --
        days = VGroup(*[day_dot(j, x) for j, x in enumerate(DAYS[first])])
        pos = np.array(DAYS[first], dtype=float)
        target = pos.copy()
        seen = {"m": first + 1}

        def cur_m():
            return max(1, int(round(m.get_value())))

        def follow(mob, dt):
            cur = cur_m()
            if cur != seen["m"]:
                seen["m"] = cur
                target[:] = DAYS[cur - 1]
            pos[:] = pos + (target - pos) * min(1.0, 12.0 * dt)
            for j, d in enumerate(mob):
                d.move_to([pop.c2p(pos[j], 0)[0], rug_y[j], 0])

        self.play(FadeIn(days, lag_ratio=0.01), ChangeDecimalToValue(ybar_num, Y_BAR[first]),
                  run_time=1)
        days.add_updater(follow)
        ybar_num.add_updater(lambda d: d.set_value(Y_BAR[cur_m() - 1]))
        r_num.add_updater(lambda d: d.set_value(cur_m()))
        ax, top = P.grow(self, m, ymax, y_axis, y_lab, hist, run_time=16)
        for mob in (days, ybar_num, r_num):
            mob.clear_updaters()
        self.wait(2)

        # ---- Mean and standard error of the sample mean ----------------------
        e_tex = slot(MathTex(r"\mathbb{E}[\bar{Y}] = \mu = 28", font_size=36), 1)
        s_tex = slot(MathTex(r"\sigma_{\bar{Y}} = \frac{\sigma}{\sqrt{n}} = \frac{12}{\sqrt{64}} = 1.5",
                             font_size=36), 2)
        arr_pop = DoubleArrow(pop.c2p(MU - SIGMA, 0.04), pop.c2p(MU + SIGMA, 0.04), buff=0,
                              color=WHITE, stroke_width=4, tip_length=0.16)
        arr_pop_lab = MathTex(r"\pm\,\sigma", font_size=28).next_to(arr_pop, RIGHT, buff=0.1)
        arr = DoubleArrow(ax.c2p(MU - SE, top * 0.99), ax.c2p(MU + SE, top * 0.99), buff=0,
                          color=WHITE, stroke_width=4, tip_length=0.18)
        arr_lab = MathTex(r"\pm\,\sigma_{\bar{Y}}", font_size=30).next_to(arr, UP, buff=0.08)
        self.play(FadeOut(days), FadeOut(readout), run_time=1)
        self.remove(days, *days)
        self.play(Write(e_tex))
        self.wait(3)
        self.play(GrowFromCenter(arr_pop), FadeIn(arr_pop_lab))
        self.wait(1.5)
        self.play(GrowFromCenter(arr), FadeIn(arr_lab), Write(s_tex), run_time=1.5)
        self.wait(6)

        # ---- Central limit theorem (density scale, as freq = FALSE) --------
        axd = P.density_axes(top, 0.1, [0.1, 0.2, 0.3], dec=1)
        self.play(FadeOut(arr), FadeOut(arr_lab), FadeOut(arr_pop), FadeOut(arr_pop_lab),
                  Transform(y_axis, axd.y_axis), Transform(y_lab, P.y_label(axd, "density")),
                  FadeOut(e_tex), s_tex.animate.move_to([LEFT_X, SLOTS[1], 0]),
                  run_time=1.5)
        self.wait(2.5)
        clt = slot(MathTex(r"\bar{Y} \;\dot{\sim}\; \mathrm{N}\!\left(\mu,\ \frac{\sigma^2}{n}\right)",
                           font_size=38), 2)
        g = axd.plot(lambda x: normal_density(x, MU, SE), x_range=[22, 34], color=WHITE,
                     stroke_width=4)
        self.play(Write(clt), Create(g), run_time=2.5)
        self.wait(4)
        self.play(Indicate(dens, color=MAIN, scale_factor=1.05), run_time=1.5)
        self.wait(4)

        # ---- P(Ybar > 31): central limit theorem and simulation --------------
        line = DashedLine(axd.c2p(31, 0), axd.c2p(31, top / P.width * 1.05), color=HIGHLIGHT)
        line_lab = MathTex(r"31", font_size=32, color=HIGHLIGHT).next_to(line, UP, buff=0.1)
        self.play(
            FadeOut(s_tex),
            clt.animate.move_to([LEFT_X, SLOTS[1], 0]),
            Create(line), FadeIn(line_lab), run_time=1.5,
        )
        self.wait(2)

        p_clt = 0.5 * (1 - erf(2 / sqrt(2)))  # 1 - pnorm(2) = 0.02275
        area = axd.get_area(g, x_range=[31, 34], color=WHITE, opacity=0.45)
        prob = slot(MathTex(r"\mathbb{P}(\bar{Y} > 31) \approx 1 - \Phi(2) \approx " + f"{p_clt:.4f}",
                            font_size=34), 2)
        self.play(FadeIn(area), Write(prob), run_time=2)
        self.wait(5)

        n_tail = sum(v > 31 for v in Y_BAR)  # 140
        self.play(P.tail(hist, 31).animate.set_fill(HIGHLIGHT, opacity=0.85), run_time=1.2)
        sim = slot(MathTex(r"\frac{\#\{\bar{y} > 31\}}{R} = \frac{" + str(n_tail) + "}{" + str(P.R)
                           + r"} = " + f"{n_tail / P.R:.3f}", font_size=30, color=HIGHLIGHT), 3)
        self.play(Write(sim))
        self.wait(8)
