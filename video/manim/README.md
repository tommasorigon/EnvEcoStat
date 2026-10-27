# Unit I videos (Manim)

Sources of the two animations embedded in `un_I.qmd`:

- `un_I_survey.mp4` (`v1_survey.py`): a survey on climate change, the sampling
  distribution of the sample proportion and the standard error.
- `un_I_pm25.mp4` (`v2_pm25.py`): air pollution in a city, repeated campaigns,
  the sampling distribution of the sample mean and the central limit theorem.

`common.py` holds the shared parts (data, histogram classes as in `hist()`,
smooth growth of the simulation).

## Regenerate

1. `Rscript export.R` reruns the simulations of the notes (same seeds, `R = 5000`)
   and writes `pi_hat.csv`, `y_bar.csv`, `campaigns.csv.gz` (the 64 days of every
   campaign) and `breaks.json` (the classes of `hist(..., breaks = 30)`).
2. Render with Manim Community (>= 0.19):

   ```
   manim -r 1920,1080 --fps 30 v1_survey.py SurveyClimate
   manim -r 1920,1080 --fps 30 v2_pm25.py AirPollution
   ```

3. Compress and copy to `video/`:

   ```
   ffmpeg -i <rendered>.mp4 -c:v libx264 -preset veryfast -crf 23 \
     -pix_fmt yuv420p -movflags +faststart -an ../un_I_<name>.mp4
   ```
