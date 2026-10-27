"""Unit J - What does 95% confidence mean? Coverage of the interval for a proportion."""

import random

from manim import *

from common import HIGHLIGHT, MAIN, geometric_rate, read_col

N = 173            # horseshoe crabs
PI = 0.65          # true proportion of the simulation
Z = 1.959964       # qnorm(0.975)
PI_HAT = read_col("intervals.csv", "pi_hat")
LOWER = read_col("intervals.csv", "lower")
UPPER = read_col("intervals.csv", "upper")
R = len(PI_HAT)
YES = [round(p * N) for p in PI_HAT]
HIT = [lo < PI < up for lo, up in zip(LOWER, UPPER)]
NO_COL = GREY_D

# Layout of the right panel: stacked intervals above a pi axis
X_RANGE = [0.45, 0.85, 0.05]
ROW0 = -2.55               # y of the first interval
TOP = 2.95                 # y available for the last interval
SLOW_ROWS = 50             # rows shown before compressing the stack
SPACING_SLOW = (TOP - ROW0) / (SLOW_ROWS - 1)
SPACING_FAST = (TOP - ROW0) / (R - 1)

COL_CORNER = np.array([-6.75, 0.05, 0])
COL_BUFF = 0.4


def column(items):
    g = VGroup(*[m.copy() for m in items]).arrange(DOWN, buff=COL_BUFF, aligned_edge=LEFT)
    g.shift(COL_CORNER - np.array([g.get_left()[0], g.get_top()[1], 0]))
    for m, c in zip(items, g):
        m.move_to(c)
    return items


class Confidence(Scene):
    def construct(self):
        rng = random.Random(173)

        # ---- Crabs: one dot per female ----------------------------------------
        crabs = VGroup(*[Dot(radius=0.06, color=NO_COL) for _ in range(N)])
        crabs.arrange_in_grid(cols=15, buff=0.11, flow_order="rd")
        crabs.move_to([-4.6, 1.75, 0])
        state = [False] * N

        def recolor_anims(k):
            yes = set(rng.sample(range(N), k))
            anims = []
            for j, d in enumerate(crabs):
                new = j in yes
                if new != state[j]:
                    anims.append(d.animate.set_color(MAIN if new else NO_COL))
                    state[j] = new
            return anims

        head = MathTex(r"\pi = 0.65, \qquad n = 173", font_size=38).next_to(crabs, UP, buff=0.3)
        self.play(FadeIn(crabs, lag_ratio=0.01), run_time=2)
        self.play(Write(head))
        self.wait(3)

        # ---- pi axis and the true value -----------------------------------------
        ax = NumberLine(
            x_range=X_RANGE, length=8.0, include_tip=False, font_size=24,
            include_numbers=True, decimal_number_config={"num_decimal_places": 2},
        )
        ax.shift(np.array([-1.2, -3.0, 0]) - ax.n2p(X_RANGE[0]))
        pi_line = DashedLine(ax.n2p(PI), ax.n2p(PI) + UP * (TOP - ax.n2p(PI)[1] + 0.2), color=WHITE).set_z_index(2)
        pi_lab = MathTex(r"\pi", font_size=36).next_to(pi_line, UP, buff=0.1)
        self.play(Create(ax))
        self.play(Create(pi_line), FadeIn(pi_lab))
        self.wait(2)

        # ---- Formulas under the grid ---------------------------------------------
        formula = MathTex(r"\hat{\pi} \pm z_{0.975}\sqrt{\frac{\hat{\pi}(1-\hat{\pi})}{n}}",
                          font_size=38)
        p_num = DecimalNumber(PI_HAT[0], num_decimal_places=4, font_size=36)
        p_row = VGroup(MathTex(r"\hat{\pi} =", font_size=36), p_num).arrange(RIGHT, buff=0.15)
        lo_num = DecimalNumber(LOWER[0], num_decimal_places=4, font_size=36)
        up_num = DecimalNumber(UPPER[0], num_decimal_places=4, font_size=36)
        ci_open = MathTex(r"\mathrm{CI} = \big(", font_size=36)
        comma = MathTex(r",", font_size=36)
        ci_close = MathTex(r"\big)", font_size=36)
        lo_num.next_to(ci_open, RIGHT, buff=0.1)
        comma.next_to(lo_num, RIGHT, buff=0.06).align_to(lo_num, DOWN).shift(DOWN * 0.1)
        up_num.next_to(comma, RIGHT, buff=0.18).align_to(lo_num, DOWN)
        ci_close.next_to(up_num, RIGHT, buff=0.1)
        ci_row = VGroup(ci_open, lo_num, comma, up_num, ci_close)
        column([formula, p_row, ci_row])
        self.play(Write(formula))
        self.wait(3)

        # ---- Interval lines (created once, positions updated) ------------------
        def row_y(j, spacing):
            return ROW0 + j * spacing

        lines = VGroup(*[
            Line(ax.n2p(LOWER[j]), ax.n2p(UPPER[j]), stroke_width=4,
                 color=MAIN if HIT[j] else HIGHLIGHT).set_z_index(0 if HIT[j] else 1)
            for j in range(R)
        ])
        for j, ln in enumerate(lines):
            ln.shift(UP * (row_y(j, SPACING_SLOW) - ln.get_y()))

        r_num = Integer(0, font_size=34, group_with_commas=False)
        r_row = VGroup(MathTex(r"R =", font_size=34), r_num).arrange(RIGHT, buff=0.15)
        r_row.move_to([5.4, 3.3, 0])

        # ---- First studies one by one --------------------------------------------
        first = 6
        for r in range(first):
            slow = r < 3
            anims = recolor_anims(YES[r])
            if r == 0:
                self.play(*anims, FadeIn(p_row), FadeIn(r_row), run_time=1.5)
            else:
                self.play(*anims, ChangeDecimalToValue(p_num, PI_HAT[r]),
                          run_time=1.3 if slow else 0.8)
            self.wait(0.5 if slow else 0.15)
            centre = np.array([ax.n2p(PI_HAT[r])[0], row_y(r, SPACING_SLOW), 0])
            dot = Dot(p_num.get_center(), radius=0.07, color=WHITE)
            self.play(MoveAlongPath(dot, ArcBetweenPoints(dot.get_center(), centre, angle=-PI / 4)),
                      run_time=1.4 if slow else 0.8)
            if r == 0:
                lo_num.set_value(LOWER[r])
                up_num.set_value(UPPER[r])
                ci_anim = FadeIn(ci_row)
            else:
                ci_anim = AnimationGroup(ChangeDecimalToValue(lo_num, LOWER[r]),
                                         ChangeDecimalToValue(up_num, UPPER[r]))
            self.play(GrowFromPoint(lines[r], centre), ci_anim, run_time=1.2 if slow else 0.7)
            self.remove(dot)
            r_num.set_value(r + 1)
            if not HIT[r]:
                self.play(Indicate(lines[r], color=HIGHLIGHT, scale_factor=1.15), run_time=1.2)
                self.wait(2.5)
            else:
                self.wait(1.2 if slow else 0.3)
        self.wait(1.5)

        # ---- Coverage counter ---------------------------------------------------
        hits_num = Integer(sum(HIT[:first]), font_size=36, group_with_commas=False)
        tot_num = Integer(first, font_size=36, group_with_commas=False)
        cov_num = DecimalNumber(sum(HIT[:first]) / first, num_decimal_places=3, font_size=36)
        bar = Line(LEFT * 0.42, RIGHT * 0.42, stroke_width=2)
        frac = VGroup(hits_num, bar, tot_num).arrange(DOWN, buff=0.1)
        cov_row = VGroup(
            MathTex(r"\frac{\#\{\pi \in \mathrm{CI}\}}{R} =", font_size=36),
            frac, MathTex(r"=", font_size=36), cov_num,
        ).arrange(RIGHT, buff=0.2)
        column([formula, p_row, ci_row, cov_row])
        self.play(Write(cov_row))
        self.wait(3)

        # ---- Continuous phase: m studies drawn, spacing of the stack ----------
        m = ValueTracker(first)
        spacing = ValueTracker(SPACING_SLOW)
        w_hit = ValueTracker(4.0)
        w_miss = ValueTracker(4.0)
        op_hit = ValueTracker(1.0)
        level = np.array([1.0 if s else 0.0 for s in state])
        target = level.copy()
        seen = {"m": first}

        def cur_m():
            return max(1, min(R, int(m.get_value())))

        def draw_lines(mob):
            mv = m.get_value()
            sp = spacing.get_value()
            wh, wm, oh = w_hit.get_value(), w_miss.get_value(), op_hit.get_value()
            for j, ln in enumerate(mob):
                if j < first:
                    g = 1.0
                else:
                    g = min(max(mv - j, 0.0), 1.0)   # the newest interval grows in
                if g <= 0:
                    ln.set_stroke(opacity=0)
                    continue
                c = PI_HAT[j]
                a = c + (LOWER[j] - c) * g
                b = c + (UPPER[j] - c) * g
                y = row_y(j, sp)
                ln.put_start_and_end_on([ax.n2p(a)[0], y, 0], [ax.n2p(b)[0], y, 0])
                ln.set_stroke(width=wh if HIT[j] else wm, opacity=oh if HIT[j] else 1.0)

        def follow(mob, dt):
            cur = cur_m()
            if cur != seen["m"]:
                seen["m"] = cur
                target[:] = 0.0
                target[rng.sample(range(N), YES[cur - 1])] = 1.0
            level[:] = level + (target - level) * min(1.0, 12.0 * dt)
            for j, d in enumerate(mob):
                d.set_color(interpolate_color(NO_COL, MAIN, float(level[j])))

        def update_numbers():
            cur = cur_m()
            p_num.set_value(PI_HAT[cur - 1])
            lo_num.set_value(LOWER[cur - 1])
            up_num.set_value(UPPER[cur - 1])
            h = sum(HIT[:cur])
            hits_num.set_value(h)
            tot_num.set_value(cur)
            hits_num.next_to(bar, UP, buff=0.1)
            tot_num.next_to(bar, DOWN, buff=0.1)
            cov_num.set_value(h / cur)
            r_num.set_value(cur)

        self.remove(*lines[:first])
        self.add(lines)
        lines.add_updater(draw_lines)
        self.remove(*crabs)
        self.add(crabs)
        crabs.add_updater(follow)
        p_num.add_updater(lambda d: update_numbers())

        # up to 50 intervals at the slow spacing
        self.play(m.animate.set_value(SLOW_ROWS), run_time=12, rate_func=linear)
        self.wait(3)
        # compress the stack to make room for all R intervals
        self.play(spacing.animate.set_value(SPACING_FAST), w_hit.animate.set_value(1.2),
                  w_miss.animate.set_value(2.6), op_hit.animate.set_value(0.55), run_time=3)
        self.wait(1)
        self.play(m.animate.set_value(R + 1), run_time=16, rate_func=geometric_rate(SLOW_ROWS, R + 1))
        for mob in (lines, crabs, p_num):
            mob.clear_updaters()
        update_numbers()
        self.wait(3)

        # ---- The misses ----------------------------------------------------------
        misses = VGroup(*[lines[j] for j in range(R) if not HIT[j]])
        self.play(Indicate(misses, color=HIGHLIGHT, scale_factor=1.0), run_time=2)
        self.play(Indicate(cov_row, color=WHITE, scale_factor=1.08), run_time=1.5)
        self.wait(8)
