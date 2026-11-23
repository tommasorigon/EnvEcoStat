"""Unit K - Least squares: how the line and the sum of squared residuals change
with the coefficients, for the black cherry trees (cherry.csv, from export_un_K.R).
"""

import numpy as np
from manim import *

from common import HIGHLIGHT, MAIN, read_col

X = np.array(read_col("cherry.csv", "diameter"))
Y = np.array(read_col("cherry.csv", "volume"))
N = len(X)
X_BAR, Y_BAR = X.mean(), Y.mean()
BETA_HAT = np.sum((X - X_BAR) * (Y - Y_BAR)) / np.sum((X - X_BAR) ** 2)
ALPHA_HAT = Y_BAR - BETA_HAT * X_BAR
SST = np.sum((Y - Y_BAR) ** 2)

RES_COL = RED_C
RIGHT_X = 0.9      # left edge of the right column
X_RANGE = [20, 55, 5]
Y_RANGE = [0, 2.5, 0.5]
B_RANGE = [0, 0.08, 0.02]


def sse(alpha, beta):
    return float(np.sum((Y - alpha - beta * X) ** 2))


def pivot_alpha(beta):
    """Intercept of the line with slope beta through (x_bar, y_bar)."""
    return Y_BAR - beta * X_BAR


class LeastSquares(Scene):
    def construct(self):
        # ---- Scatterplot ----------------------------------------------------------
        ax = Axes(
            x_range=X_RANGE, y_range=Y_RANGE, x_length=6.4, y_length=5.2,
            axis_config={"include_tip": False, "font_size": 24},
            x_axis_config={"numbers_to_include": list(range(20, 56, 5))},
            y_axis_config={"numbers_to_include": [0.5, 1.0, 1.5, 2.0, 2.5],
                           "decimal_number_config": {"num_decimal_places": 1}},
        ).move_to([-3.2, -0.25, 0])
        x_lab = Tex("Diameter (cm)", font_size=28).next_to(ax.x_axis, DOWN, buff=0.3)
        y_lab = Tex("Volume (m$^3$)", font_size=28).next_to(ax.y_axis, UP, buff=0.2)
        y_lab.align_to(ax.get_left(), LEFT)
        title = Tex("Black cherry trees, $n = 31$", font_size=36).to_edge(UP, buff=0.3)
        title.set_x(ax.get_center()[0])
        dots = VGroup(*[Dot(ax.c2p(x, y), radius=0.06, color=MAIN) for x, y in zip(X, Y)]).set_z_index(3)

        self.play(Create(ax), FadeIn(x_lab), FadeIn(y_lab), Write(title))
        self.play(LaggedStart(*[FadeIn(d, scale=0.5) for d in dots], lag_ratio=0.05), run_time=2)
        self.wait(2)

        # ---- Line, residuals and the formulas ---------------------------------------
        alpha = ValueTracker(0.3)
        beta = ValueTracker(0.0)

        def clipped_line():
            a, b = alpha.get_value(), beta.get_value()
            x0, x1 = X_RANGE[0], X_RANGE[1]
            pts = []
            for x in np.linspace(x0, x1, 400):
                y = a + b * x
                if Y_RANGE[0] <= y <= Y_RANGE[1]:
                    pts.append(ax.c2p(x, y))
            if len(pts) < 2:
                return Line(ax.c2p(x0, 0), ax.c2p(x0, 0), stroke_opacity=0)
            return Line(pts[0], pts[-1], color=HIGHLIGHT, stroke_width=5).set_z_index(2)

        def residuals():
            a, b = alpha.get_value(), beta.get_value()
            g = VGroup()
            for x, y in zip(X, Y):
                yh = min(max(a + b * x, Y_RANGE[0]), Y_RANGE[1])
                g.add(Line(ax.c2p(x, y), ax.c2p(x, yh), color=RES_COL, stroke_width=2.5))
            return g.set_z_index(1)

        line = always_redraw(clipped_line)
        res = always_redraw(residuals)

        model = MathTex(r"y = \beta_0 + \beta_1 x", font_size=38)
        resid = MathTex(r"e_i = y_i - \beta_0 - \beta_1 x_i", font_size=34)
        a_num = DecimalNumber(alpha.get_value(), num_decimal_places=3, font_size=36)
        b_num = DecimalNumber(beta.get_value(), num_decimal_places=4, font_size=36)
        a_lab = MathTex(r"\beta_0 =", font_size=36)
        b_lab = MathTex(r"\beta_1 =", font_size=36)
        a_row = VGroup(a_lab, a_num).arrange(RIGHT, buff=0.15)
        b_row = VGroup(b_lab, b_num).arrange(RIGHT, buff=0.15)
        s_num = DecimalNumber(sse(0.3, 0.0), num_decimal_places=3, font_size=36)
        s_row = VGroup(MathTex(r"\textstyle\sum_{i=1}^n e_i^2 =", font_size=36), s_num).arrange(RIGHT, buff=0.15)
        right = VGroup(model, resid, a_row, b_row, s_row).arrange(DOWN, buff=0.25, aligned_edge=LEFT)
        right.to_corner(UR, buff=0.35).set_x(RIGHT_X + right.width / 2)

        a_num.add_updater(lambda m: m.set_value(alpha.get_value()))
        b_num.add_updater(lambda m: m.set_value(beta.get_value()))
        s_num.add_updater(lambda m: m.set_value(sse(alpha.get_value(), beta.get_value())))

        self.play(Write(model))
        self.play(Create(line), FadeIn(a_row), FadeIn(b_row))
        self.wait(1)
        self.play(Create(res), Write(resid), run_time=2)
        self.play(FadeIn(s_row))
        self.wait(3)

        # ---- Phase 1: horizontal lines, beta = 0 ------------------------------------
        note1 = Tex(r"Horizontal lines: $\beta_1 = 0$", font_size=30, color=GREY_A)
        note1.next_to(right, DOWN, buff=0.4).align_to(right, LEFT)
        self.play(FadeIn(note1))
        self.play(alpha.animate.set_value(1.5), run_time=4)
        self.wait(1)
        self.play(alpha.animate.set_value(Y_BAR), run_time=3)
        self.wait(1)
        ybar_txt = MathTex(r"\text{best: } \beta_0 = \bar{y} = 0.854", font_size=30, color=GREY_A)
        ybar_txt.next_to(note1, DOWN, buff=0.2).align_to(note1, LEFT)
        self.play(Write(ybar_txt))
        self.wait(3)

        # ---- Phase 2: rotate around (x_bar, y_bar) ----------------------------------
        centre = Dot(ax.c2p(X_BAR, Y_BAR), radius=0.08, color=WHITE).set_z_index(4)
        centre_lab = MathTex(r"(\bar{x}, \bar{y})", font_size=28).move_to(ax.c2p(30.8, 1.3))
        centre_arrow = Arrow(centre_lab.get_bottom(), centre.get_center(), buff=0.12,
                             stroke_width=2, max_tip_length_to_length_ratio=0.2, color=WHITE)
        centre_lab = VGroup(centre_lab, centre_arrow)
        note2 = VGroup(
            Tex(r"Lines through $(\bar{x}, \bar{y})$:", font_size=30, color=GREY_A),
            MathTex(r"\beta_0 = \bar{y} - \beta_1 \bar{x}", font_size=32, color=GREY_A),
        ).arrange(DOWN, buff=0.15, aligned_edge=LEFT)
        note2.next_to(right, DOWN, buff=0.4).align_to(right, LEFT)
        self.play(FadeIn(centre), Write(centre_lab), FadeOut(ybar_txt),
                  ReplacementTransform(note1, note2))
        self.wait(2)

        # Panel: sum of squared residuals as a function of beta
        s_max = sse(pivot_alpha(B_RANGE[1]), B_RANGE[1])
        top = max(SST, s_max) * 1.05
        pan = Axes(
            x_range=B_RANGE, y_range=[0, top, 2], x_length=4.4, y_length=2.1,
            axis_config={"include_tip": False, "font_size": 22},
            x_axis_config={"numbers_to_include": [0, 0.02, 0.04, 0.06, 0.08],
                           "decimal_number_config": {"num_decimal_places": 2}},
            y_axis_config={"numbers_to_include": [2, 4, 6]},
        )
        pan.shift(np.array([RIGHT_X + 0.55, -3.45, 0]) - pan.c2p(0, 0))
        pan_x = MathTex(r"\beta_1", font_size=30).next_to(pan.x_axis, RIGHT, buff=0.15)
        pan_y = MathTex(r"\textstyle\sum_{i=1}^n e_i^2", font_size=28).move_to(pan.c2p(0.066, 5.2))
        self.play(Create(pan), FadeIn(pan_x), FadeIn(pan_y))

        trace = TracedPath(lambda: pan.c2p(beta.get_value(),
                                           sse(alpha.get_value(), beta.get_value())),
                           stroke_color=RES_COL, stroke_width=3)
        marker = always_redraw(lambda: Dot(pan.c2p(beta.get_value(),
                                                   sse(alpha.get_value(), beta.get_value())),
                                           radius=0.07, color=HIGHLIGHT))
        self.add(trace, marker)

        # alpha must follow beta at every frame, not only at the end
        alpha.add_updater(lambda m: m.set_value(pivot_alpha(beta.get_value())))
        self.play(beta.animate.set_value(B_RANGE[1]), run_time=7, rate_func=linear)
        self.wait(1)
        self.play(beta.animate.set_value(0.03), run_time=4)
        self.wait(1)
        self.play(beta.animate.set_value(BETA_HAT), run_time=3)
        alpha.clear_updaters()
        self.wait(2)

        # ---- The minimum ------------------------------------------------------------
        best = MathTex(
            r"\hat{\beta}_1 = \frac{\text{cov}(x,y)}{\text{var}(x)}, \quad "
            r"\hat{\beta}_0 = \bar{y} - \hat{\beta}_1 \bar{x}",
            font_size=30, color=HIGHLIGHT,
        ).next_to(right, DOWN, buff=0.35).align_to(right, LEFT)
        drop = DashedLine(pan.c2p(BETA_HAT, sse(ALPHA_HAT, BETA_HAT)), pan.c2p(BETA_HAT, 0),
                          color=HIGHLIGHT)
        a_hat = MathTex(r"\hat{\beta}_0 =", font_size=36, color=HIGHLIGHT).move_to(a_lab, aligned_edge=RIGHT)
        b_hat = MathTex(r"\hat{\beta}_1 =", font_size=36, color=HIGHLIGHT).move_to(b_lab, aligned_edge=RIGHT)
        self.play(Create(drop), ReplacementTransform(note2, best),
                  ReplacementTransform(a_lab, a_hat), ReplacementTransform(b_lab, b_hat),
                  Indicate(s_row, color=HIGHLIGHT, scale_factor=1.1), run_time=2)
        self.wait(3)
        r2 = MathTex(
            r"R^2 = 1 - \frac{\sum_{i=1}^n e_i^2}{\sum_{i=1}^n (y_i - \bar{y})^2}"
            r" = 1 - \frac{0.420}{6.497} = 0.935",
            font_size=26,
        ).move_to(best, aligned_edge=LEFT)
        self.play(FadeOut(best), run_time=0.8)
        self.play(Write(r2), run_time=2)
        self.wait(8)
