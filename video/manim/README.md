# Videos of the course (Manim)

Sources of the animations embedded in `un_I.qmd`, `un_J.qmd` and `un_K.qmd`:

- `un_I_survey.mp4` (`v1_survey.py`): a survey on climate change, the sampling
  distribution of the sample proportion and the standard error.
- `un_I_pm25.mp4` (`v2_pm25.py`): air pollution in a city, repeated campaigns,
  the sampling distribution of the sample mean and the central limit theorem.
- `un_J_confidence.mp4` (`v3_confidence.py`): what 95% confidence means, with the
  interval for a proportion (horseshoe crabs, `n = 173`, `pi = 0.65`).
- `un_K_least_squares.mp4` (`v4_least_squares.py`): black cherry trees, how the
  line and the sum of squared residuals change with the coefficients.
- `un_K_least_squares_3d.mp4` (`v5_least_squares_3d.py`): the same with diameter
  and height, a plane instead of a line.

`common.py` holds the shared parts (data, histogram classes as in `hist()`,
smooth growth of the simulation).

## Regenerate

1. `Rscript export.R` reruns the simulations of the notes (same seeds, `R = 5000`)
   and writes `pi_hat.csv`, `y_bar.csv`, `campaigns.csv.gz` (the 64 days of every
   campaign) and `breaks.json` (the classes of `hist(..., breaks = 30)`).
   `Rscript export_un_J.R` does the same for Unit J (`intervals.csv`).
   `Rscript export_un_K.R` writes the data of Unit K (`cherry.csv`).
2. Render with Manim Community (>= 0.19):

   ```
   manim -r 1920,1080 --fps 30 v1_survey.py SurveyClimate
   manim -r 1920,1080 --fps 30 v2_pm25.py AirPollution
   manim -r 1920,1080 --fps 30 v3_confidence.py Confidence
   manim -r 1920,1080 --fps 30 v4_least_squares.py LeastSquares
   manim -r 1920,1080 --fps 30 v5_least_squares_3d.py LeastSquares3D
   ```

3. Compress and copy to `video/`:

   ```
   ffmpeg -i <rendered>.mp4 -c:v libx264 -preset veryfast -crf 23 \
     -pix_fmt yuv420p -movflags +faststart -an ../<name>.mp4
   ```
