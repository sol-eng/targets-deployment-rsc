library(targets)
options(tidyverse.quiet = TRUE)
source("R/connect_helpers.R")
tar_option_set(packages = c("tidymodels", "tidyverse", "connectapi",
                            "tarchetypes", "aws.s3"),
               resources = list(bucket = Sys.getenv("AWS_BUCKET_NAME")),
               format = "aws_qs")
list(
  tar_target(
    raw_data_url,
    "https://tidymodels.org/start/models/urchins.csv",
    format = "url"
  ),
  tar_target(
    raw_data,
    read_csv(raw_data_url, col_types = cols())
  ),
  tar_target(
    urchins,
    raw_data %>%
      setNames(c("food_regime", "initial_volume", "width")) %>%
      mutate(food_regime = factor(food_regime,
                                  levels = c("Initial", "Low", "High")))
  ),
  tar_target(
    visualization,
    ggplot(urchins,
           aes(x = initial_volume,
               y = width,
               group = food_regime,
               col = food_regime)) +
      geom_point() +
      geom_smooth(method = lm, se = FALSE) +
      scale_color_viridis_d(option = "plasma", end = .7)
  ),
  tar_target(
    set_model,
    linear_reg() %>%
      set_engine("lm")
  ),
  tar_target(
    fit_model,
    set_model %>%
      fit(width ~ initial_volume * food_regime, data = urchins)
  ),
  tar_target(
    tidy_model,
    tidy(fit_model)
  ),
  tarchetypes::tar_render(
    rmarkdown_report,
    "report/report.Rmd",
    output_file = "report.html",
    quiet = TRUE
  ),
  tar_target(
    upload_report,
    {
      tar_load(rmarkdown_report)
      file_to_upload <- rmarkdown_report[grepl("*.html", rmarkdown_report)]
      upload_to_connect(file_to_upload, "targets-rmd-report")}
  )
)
