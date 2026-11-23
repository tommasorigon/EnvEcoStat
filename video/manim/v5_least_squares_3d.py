"""Unit K - Least squares with two explanatory variables: how the plane and the
sum of squared residuals change with the coefficients, for the black cherry
trees (cherry.csv, from export_un_K.R).
"""

import numpy as np
from manim import *

from common import HIGHLIGHT, MAIN, read_col

X1 = np.array(read_col("cherry.csv", "diameter"))
X2 = np.array(read_col("cherry.csv", "height"))
Y = np.array(read_col("cherry.csv", "volume"))
N = len(Y)
X1_BAR, X2_BAR, Y_BAR = X1.mean(), X2.mean(), Y.mean()

# Least squares estimates, simple (diameter only) and multiple
B_SIMPLE = np.sum((X1 - X1_BAR) * (Y - Y_BAR)) / np.sum((X1 - X1_BAR) ** 2)
DESIGN = np.column_stack([np.ones(N), X1, X2])
A_HAT, B1_HAT, B2_HAT = np.linalg.lstsq(DESIGN, Y, rcond=None)[0]
SST = np.sum((Y - Y_BAR) ** 2)

RES_COL = RED_C
X1_RANGE = [20, 55, 5]
X2_RANGE = [18, 28, 2]
Y_RANGE = [0, 2.5, 0.5]
LEFT_X = 1.4       # left edge of the text column, in frame coordinates
SHIFT = np.array([1.4, 0, 0])   # camera frame centre: the axes appear on the left


def sse(a, b1, b2):
    return float(np.sum((Y - a - b1 * X1 - b2 * X2) ** 2))


def pivot_alpha(b1, b2):
    """Intercept of the plane through (x1_bar, x2_bar, y_bar)."""
    return Y_BAR - b1 * X1_BAR - b2 * X2_BAR


class LeastSquares3D(ThreeDScene):
    def fix(self, mob, shift=False):
        """Fixed-in-frame mobjects are drawn relative to the frame centre: the ones
        placed in absolute screen coordinates are moved back by the frame shift."""
        if shift:
            mob.shift(SHIFT)
        self.add_fixed_in_frame_mobjects(mob)

    def construct(self):
        # ---- Axes and points ----------------------------------------------------------
        ax = ThreeDAxes(
            x_range=X1_RANGE, y_range=X2_RANGE, z_range=Y_RANGE,
            x_length=6.0, y_length=3.6, z_length=4.2,
            axis_config={"include_tip": False},
        )
        # the origin of the axes is the corner (20, 18, 0)
        ax.shift(-ax.c2p(37.5, 23, 1.25))
        # axis labels standing up in 3D space, readable from the camera
        x_lab = Tex("Diameter", font_size=34).rotate(PI / 2, RIGHT)
        x_lab.move_to(ax.c2p(37.5, X2_RANGE[0], 0) + np.array([0, -0.6, -0.3]))
        y_lab = Tex("Height", font_size=34).rotate(PI / 2, RIGHT)
        y_lab.move_to(ax.c2p(X1_RANGE[0], X2_RANGE[1], 0) + np.array([-0.7, 0.2, -0.45]))
        z_lab = Tex("Volume", font_size=34).rotate(PI / 2, RIGHT)
        z_lab.move_to(ax.c2p(X1_RANGE[0], X2_RANGE[0], Y_RANGE[1]) + np.array([0, 0, 0.35]))
        labels = VGroup(x_lab, y_lab, z_lab)
        dots = VGroup(*[Dot3D(ax.c2p(a, b, c), radius=0.06, color=MAIN)
                        for a, b, c in zip(X1, X2, Y)])

        self.set_camera_orientation(phi=66 * DEGREES, theta=-105 * DEGREES, zoom=0.9,
                                    frame_center=SHIFT)
        title = Tex("Black cherry trees, $n = 31$", font_size=36).to_corner(UL, buff=0.35)
        self.fix(title, shift=True)
        self.play(Create(ax), FadeIn(labels), Write(title))
        self.play(LaggedStart(*[FadeIn(d, scale=0.5) for d in dots], lag_ratio=0.05), run_time=2)
        self.wait(1)

        # ---- Plane, residuals and formulas -----------------------------------------------
        b1 = ValueTracker(0.0)
        b2 = ValueTracker(0.0)

        def alpha():
            return pivot_alpha(b1.get_value(), b2.get_value())

        def plane():
            a, c1, c2 = alpha(), b1.get_value(), b2.get_value()
            return Surface(
                lambda u, v: ax.c2p(u, v, a + c1 * u + c2 * v),
                u_range=[X1_RANGE[0], X1_RANGE[1]], v_range=[X2_RANGE[0], X2_RANGE[1]],
                resolution=(6, 4), fill_color=HIGHLIGHT, fill_opacity=0.35,
                checkerboard_colors=False, stroke_color=HIGHLIGHT, stroke_width=0.6,
                stroke_opacity=0.6,
            )

        def residuals():
            a, c1, c2 = alpha(), b1.get_value(), b2.get_value()
            return VGroup(*[
                Line(ax.c2p(u, v, w), ax.c2p(u, v, a + c1 * u + c2 * v),
                     color=RES_COL, stroke_width=2.5)
                for u, v, w in zip(X1, X2, Y)
            ])

        surf = always_redraw(plane)
        res = always_redraw(residuals)

        model = MathTex(r"y = \alpha + \beta_1 x_1 + \beta_2 x_2", font_size=36)
        resid = MathTex(r"e_i = y_i - \alpha - \beta_1 x_{i1} - \beta_2 x_{i2}", font_size=30)
        a_lab = MathTex(r"\alpha =", font_size=34)
        b1_lab = MathTex(r"\beta_1 =", font_size=34)
        b2_lab = MathTex(r"\beta_2 =", font_size=34)
        a_num = DecimalNumber(alpha(), num_decimal_places=3, font_size=34)
        b1_num = DecimalNumber(0, num_decimal_places=4, font_size=34)
        b2_num = DecimalNumber(0, num_decimal_places=4, font_size=34)
        s_num = DecimalNumber(sse(alpha(), 0, 0), num_decimal_places=3, font_size=34)
        a_row = VGroup(a_lab, a_num).arrange(RIGHT, buff=0.15)
        b1_row = VGroup(b1_lab, b1_num).arrange(RIGHT, buff=0.15)
        b2_row = VGroup(b2_lab, b2_num).arrange(RIGHT, buff=0.15)
        s_row = VGroup(MathTex(r"\textstyle\sum_{i=1}^n e_i^2 =", font_size=34), s_num).arrange(RIGHT, buff=0.15)
        right = VGroup(model, resid, a_row, b1_row, b2_row, s_row).arrange(DOWN, buff=0.25, aligned_edge=LEFT)
        right.to_edge(UP, buff=0.35).set_x(LEFT_X + right.width / 2)
        self.fix(right, shift=True)
        self.remove(right)

        def follow(value):
            def upd(m):
                m.set_value(value())
                self.add_fixed_in_frame_mobjects(m)   # the new digits must stay fixed too
            return upd

        a_num.add_updater(follow(alpha))
        b1_num.add_updater(follow(b1.get_value))
        b2_num.add_updater(follow(b2.get_value))
        s_num.add_updater(follow(lambda: sse(alpha(), b1.get_value(), b2.get_value())))

        self.play(Write(model))
        self.play(Create(surf), FadeIn(a_row), FadeIn(b1_row), FadeIn(b2_row))
        self.play(Create(res), Write(resid), run_time=2)
        self.play(FadeIn(s_row))
        note0 = Tex(r"Horizontal plane: $\alpha = \bar{y}$", font_size=28, color=GREY_A)
        note0.next_to(right, DOWN, buff=0.35).align_to(right, LEFT)
        self.fix(note0)
        self.remove(note0)
        self.play(FadeIn(note0))
        self.begin_ambient_camera_rotation(rate=0.012)
        self.wait(3)

        # ---- Phase 1: the diameter only ------------------------------------------------
        note1 = VGroup(
            Tex(r"Diameter only: $\beta_2 = 0$", font_size=28, color=GREY_A),
            MathTex(r"\text{best: } \hat{\beta}_1 = 0.0565, \ \textstyle\sum e_i^2 = 0.420",
                    font_size=28, color=GREY_A),
        ).arrange(DOWN, buff=0.15, aligned_edge=LEFT).move_to(note0, aligned_edge=UL)
        self.fix(note1[0])
        self.remove(note1[0])
        self.play(FadeOut(note0), FadeIn(note1[0]))
        self.play(b1.animate.set_value(0.08), run_time=4)
        self.play(b1.animate.set_value(B_SIMPLE), run_time=3)
        self.fix(note1[1])
        self.remove(note1[1])
        self.play(Write(note1[1]))
        self.wait(3)

        # ---- Phase 2: adding the height --------------------------------------------------
        note2 = Tex(r"Adding the height: $\beta_2$ moves", font_size=28, color=GREY_A)
        note2.move_to(note0, aligned_edge=UL)
        self.fix(note2)
        self.remove(note2)
        self.play(FadeOut(note1), FadeIn(note2))
        self.play(b2.animate.set_value(0.08), b1.animate.set_value(0.045), run_time=4)
        self.wait(1)
        self.play(b2.animate.set_value(B2_HAT), b1.animate.set_value(B1_HAT), run_time=4)
        self.wait(1)

        # ---- The minimum ------------------------------------------------------------------
        a_hat = MathTex(r"\hat{\alpha} =", font_size=34, color=HIGHLIGHT).move_to(a_lab, aligned_edge=RIGHT)
        b1_hat = MathTex(r"\hat{\beta}_1 =", font_size=34, color=HIGHLIGHT).move_to(b1_lab, aligned_edge=RIGHT)
        b2_hat = MathTex(r"\hat{\beta}_2 =", font_size=34, color=HIGHLIGHT).move_to(b2_lab, aligned_edge=RIGHT)
        r2 = MathTex(
            r"R^2 = 1 - \frac{\sum_{i=1}^n e_i^2}{\sum_{i=1}^n (y_i - \bar{y})^2}"
            r" = 1 - \frac{0.340}{6.497} = 0.948",
            font_size=26,
        ).move_to(note0, aligned_edge=UL)
        for m in (a_hat, b1_hat, b2_hat, r2):
            self.fix(m)
            self.remove(m)
        self.play(FadeOut(note2), ReplacementTransform(a_lab, a_hat),
                  ReplacementTransform(b1_lab, b1_hat), ReplacementTransform(b2_lab, b2_hat),
                  run_time=2)
        self.play(Write(r2), run_time=2)
        self.wait(6)
        self.stop_ambient_camera_rotation()
        self.wait(2)
