"""Unit I - A survey on climate change: the sampling distribution of the sample proportion."""

import random
from math import pi, sin

from manim import *

from common import BREAKS, HIGHLIGHT, MAIN, HistPanel, normal_density, read_col

N = 1008
PI_HAT = read_col("pi_hat.csv", "pi_hat")
YES = [round(p * N) for p in PI_HAT]
SE = (0.5 * 0.5 / N) ** 0.5  # 0.01574852

ROWS, COLS = 28, 36  # 28 * 36 = 1008 people
NO_COL = GREY_D

PANEL = HistPanel(
    PI_HAT, BREAKS["b1"],
    x_range=[0.44, 0.57, 0.01], x_numbers=[0.46, 0.48, 0.50, 0.52, 0.54, 0.56], x_dec=2,
    origin=[-1.6, -2.45, 0], x_length=8.3,
)


class SurveyClimate(Scene):
    def construct(self):
        rng = random.Random(2019)
        P = PANEL

        # ---- People: one dot per respondent --------------------------------
        people = VGroup(*[Dot(radius=0.032, color=NO_COL) for _ in range(N)])
        people.arrange_in_grid(rows=ROWS, cols=COLS, buff=0.046)
        people.move_to([-4.6, 0.35, 0])
        state = [False] * N  # current answer of each dot

        def recolor_anims(k):
            """Animations turning the grid into a new survey with k yes."""
            yes = set(rng.sample(range(N), k))
            anims = []
            for j, d in enumerate(people):
                new = j in yes
                if new != state[j]:
                    anims.append(d.animate.set_color(MAIN if new else NO_COL))
                    state[j] = new
            return anims

        n_lab = MathTex(r"n = 1008", font_size=36).next_to(people, UP, buff=0.3)
        self.play(FadeIn(people, lag_ratio=0.002), run_time=2.5)
        self.play(Write(n_lab))
        self.wait(2)

        # ---- The observed survey -----------------------------------------
        self.play(LaggedStart(*recolor_anims(524), lag_ratio=0.004), run_time=3)
        obs = MathTex(r"\hat{\pi} = \frac{524}{1008} \approx 0.52", font_size=40)
        obs.next_to(people, DOWN, buff=0.35)
        self.play(Write(obs))
        self.wait(4)

        # ---- Hypothesis pi = 0.5 and simulated surveys ---------------------
        hyp = MathTex(r"\pi = 0.5", font_size=40).move_to(n_lab)
        ax0 = P.axes(0.16)
        x_axis = ax0.x_axis
        x_lab = MathTex(r"\hat{\pi}", font_size=36).next_to(x_axis, DOWN, buff=0.5)
        self.play(Transform(n_lab, hyp), FadeOut(obs), run_time=1.5)
        self.wait(2)
        self.play(Create(x_axis), FadeIn(x_lab))
        self.wait(1.5)

        k_num = Integer(YES[0], font_size=40, group_with_commas=False)
        p_num = DecimalNumber(PI_HAT[0], num_decimal_places=4, font_size=40)
        readout = VGroup(MathTex(r"\hat{\pi} =", font_size=40), k_num,
                         MathTex(r"/\,1008 =", font_size=40), p_num).arrange(RIGHT, buff=0.15)
        readout.next_to(people, DOWN, buff=0.35)

        r_num = Integer(0, font_size=34, group_with_commas=False)
        r_row = VGroup(MathTex(r"R =", font_size=34), r_num).arrange(RIGHT, buff=0.15)
        r_row.move_to(ax0.c2p(0.452, 0.16), aligned_edge=UL)

        # First surveys one by one: each pi_hat is a dot stacked on the x axis
        first = 8
        stacks = [VGroup() for _ in range(P.NB)]
        dot_r = 0.075
        for r in range(first):
            anims = recolor_anims(YES[r])
            if r == 0:
                self.play(*anims, FadeIn(readout), FadeIn(r_row), run_time=1.2)
            else:
                self.play(*anims, ChangeDecimalToValue(k_num, YES[r]),
                          ChangeDecimalToValue(p_num, PI_HAT[r]), run_time=1.2 if r < 3 else 0.7)
            i = P.idx[r]
            xc = (P.B[i] + P.B[i + 1]) / 2
            target = ax0.c2p(xc, 0) + UP * (dot_r * (2 * len(stacks[i]) + 1) + 0.02)
            dot = Dot(p_num.get_center(), radius=dot_r, color=WHITE)
            self.play(MoveAlongPath(dot, ArcBetweenPoints(dot.get_center(), target, angle=-PI / 3)),
                      run_time=1.5 if r < 3 else 0.8)
            stacks[i].add(dot)
            r_num.set_value(r + 1)
            self.wait(1.0 if r < 3 else 0.25)

        # The dots become a relative-frequency histogram
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

        # Then fast: no flying dots. The grid follows the surveys: at every new
        # pi_hat it fades towards a sample with exactly that number of yes.
        level = np.array([1.0 if s else 0.0 for s in state])
        target = level.copy()
        seen = {"m": first}

        def cur_m():
            return max(1, int(round(m.get_value())))

        def follow(mob, dt):
            cur = cur_m()
            if cur != seen["m"]:
                seen["m"] = cur
                target[:] = 0.0
                target[rng.sample(range(N), YES[cur - 1])] = 1.0
            level[:] = level + (target - level) * min(1.0, 12.0 * dt)
            for j, d in enumerate(mob):
                d.set_color(interpolate_color(NO_COL, MAIN, float(level[j])))

        # the dots were animated one by one: put the grid back as a single mobject
        self.remove(*people)
        self.add(people)
        people.add_updater(follow)
        k_num.add_updater(lambda d: d.set_value(YES[cur_m() - 1]))
        p_num.add_updater(lambda d: d.set_value(PI_HAT[cur_m() - 1]))
        r_num.add_updater(lambda d: d.set_value(cur_m()))
        ax, top = P.grow(self, m, ymax, y_axis, y_lab, hist, run_time=16)
        for mob in (people, k_num, p_num, r_num):
            mob.clear_updaters()
        for j, d in enumerate(people):
            d.set_color(MAIN if target[j] > 0.5 else NO_COL)
        self.wait(2)

        # ---- Observed value and tail ---------------------------------------
        self.play(FadeOut(readout))
        line = DashedLine(ax.c2p(0.52, 0), ax.c2p(0.52, top * 1.05), color=HIGHLIGHT)
        line_lab = MathTex(r"0.52", font_size=32, color=HIGHLIGHT).next_to(line, UP, buff=0.1)
        self.play(Create(line), FadeIn(line_lab))
        self.wait(2)
        self.play(P.tail(hist, 0.52).animate.set_fill(HIGHLIGHT, opacity=0.85), run_time=1.2)
        n_tail = sum(v >= 0.52 for v in PI_HAT)  # 482
        tail = MathTex(r"\frac{\#\{\hat{\pi} \geq 0.52\}}{R} = \frac{" + str(n_tail) + "}{" + str(P.R)
                       + r"} \approx " + f"{n_tail / P.R:.3f}", font_size=32, color=HIGHLIGHT)
        tail.next_to(people, DOWN, buff=0.35)
        self.play(Write(tail))
        self.wait(5)

        # ---- Standard error -----------------------------------------------
        arr = DoubleArrow(ax.c2p(0.5 - SE, top * 0.99), ax.c2p(0.5 + SE, top * 0.99), buff=0,
                          color=WHITE, stroke_width=4, tip_length=0.18)
        arr_lab = MathTex(r"\pm\,\sigma_{\hat{\pi}}", font_size=30).next_to(arr, UP, buff=0.08)
        se_tex = MathTex(r"\sigma_{\hat{\pi}} = \sqrt{\frac{\pi(1-\pi)}{n}} \approx 0.0157", font_size=36)
        se_tex.next_to(people, DOWN, buff=0.35)
        self.play(FadeOut(tail), GrowFromCenter(arr), FadeIn(arr_lab), Write(se_tex), run_time=1.5)
        self.wait(5)

        # ---- Normal approximation (density scale, as freq = FALSE) --------
        # relative frequency / class width = density: the bars do not move
        axd = P.density_axes(top, 10, [10, 20, 30], dec=0)
        self.play(FadeOut(arr), FadeOut(arr_lab), hist.animate.set_fill(MAIN, opacity=0.75),
                  Transform(y_axis, axd.y_axis), Transform(y_lab, P.y_label(axd, "density")),
                  run_time=1.5)
        self.wait(2.5)
        clt = MathTex(r"\hat{\pi} \;\dot{\sim}\; \mathrm{N}\!\left(\pi,\ \frac{\pi(1-\pi)}{n}\right)",
                      font_size=38)
        clt.next_to(se_tex, DOWN, buff=0.4)
        g1 = axd.plot(lambda x: normal_density(x, 0.5, SE), x_range=[0.44, 0.57],
                      color=WHITE, stroke_width=4)
        self.play(Write(clt), Create(g1), run_time=2.5)
        self.wait(5)

        # ---- n = 1008 vs n = 10000 ----------------------------------------
        ax2 = P.axes(90, step=20, nums=[20, 40, 60, 80], dec=0)
        line2 = DashedLine(ax2.c2p(0.52, 0), ax2.c2p(0.52, 95), color=HIGHLIGHT)
        g1b = ax2.plot(lambda x: normal_density(x, 0.5, SE), x_range=[0.44, 0.57],
                       color=MAIN, stroke_width=4)
        g2 = ax2.plot(lambda x: normal_density(x, 0.5, 0.005), x_range=[0.44, 0.57],
                      color=WHITE, stroke_width=4)
        se1 = MathTex(r"n = 1008: \ \sigma_{\hat{\pi}} \approx 0.0157", font_size=36, color=MAIN)
        se2 = MathTex(r"n = 10000: \ \sigma_{\hat{\pi}} = 0.005", font_size=36)
        left = VGroup(clt.copy(), se1, se2).arrange(DOWN, buff=0.55, aligned_edge=LEFT)
        left.move_to(people)
        lab1 = MathTex(r"n = 1008", font_size=32, color=MAIN).next_to(ax2.c2p(0.53, 22), RIGHT, buff=0.1)
        lab2 = MathTex(r"n = 10000", font_size=32).next_to(ax2.c2p(0.494, 70), LEFT, buff=0.15)
        self.play(
            FadeOut(hist), FadeOut(r_row), FadeOut(people), FadeOut(n_lab),
            Transform(y_axis, ax2.y_axis), Transform(y_lab, P.y_label(ax2, "density")),
            ReplacementTransform(line, line2), line_lab.animate.next_to(line2, UP, buff=0.1),
            ReplacementTransform(g1, g1b), FadeIn(lab1),
            ReplacementTransform(se_tex, se1), clt.animate.move_to(left[0]),
            run_time=2.5,
        )
        self.wait(3)
        self.play(Create(g2), FadeIn(lab2), Write(se2), run_time=2.5)
        self.wait(2)
        self.play(Indicate(line_lab, color=HIGHLIGHT, scale_factor=1.3))
        self.wait(6)
