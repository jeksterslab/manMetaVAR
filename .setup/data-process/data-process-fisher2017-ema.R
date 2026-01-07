data_process_fisher2017_ema <- function(overwrite = FALSE) {
  cat("\ndata_process_fisher2017_ema\n")
  set.seed(42)
  # find root directory
  root <- rprojroot::is_rstudio_project
  output <- root$find_file(
    ".setup",
    "data-raw",
    "fisher2017-ema.Rds"
  )
  if (!file.exists(output)) {
    write <- TRUE
  } else {
    if (overwrite) {
      write <- TRUE
    } else {
      write <- FALSE
    }
  }
  if (write) {
    input <- root$find_file(
      ".setup",
      "notes",
      "EmotionTimeSeries",
      "DataClean",
      "Fisher2017",
      "data_Fisher2017.RDS"
    )
    wd <- getwd()
    on.exit(
      setwd(wd),
      add = TRUE
    )
    data_wd <- root$find_file(
      ".setup",
      "notes"
    )
    unlink(
      x = file.path(
        data_wd,
        "EmotionTimeSeries"
      ),
      recursive = TRUE
    )
    dest <- data_wd
    dir.create(
      path = data_wd,
      recursive = TRUE,
      showWarnings = FALSE
    )
    cmd <- sprintf(
      "git -C %s clone %s",
      shQuote(dest),
      shQuote("https://github.com/jmbh/EmotionTimeSeries.git")
    )
    system(cmd)
    unlink(
      file.path(
        data_wd,
        "EmotionTimeSeries",
        "EmotionTimeSeries.Rproj"
      )
    )
    fisher2017_ema <- readRDS(input)
    id <- fisher2017_ema$subj_id
    na <- rowMeans(
      fisher2017_ema[
        ,
        c(
          "down",
          "hopeless",
          "anhedonia",
          "guilty",
          "worried",
          "irritable"
        )
      ],
      na.rm = TRUE
    )
    na[is.nan(na)] <- NA

    pa <- rowMeans(
      fisher2017_ema[
        ,
        c(
          "positive",
          "content",
          "enthusiastic",
          "energetic"
        )
      ],
      na.rm = TRUE
    )
    pa[is.nan(pa)] <- NA
    fisher2017_ema <- data.frame(
      id = id,
      na = na,
      pa = pa
    )
    saveRDS(
      object = fisher2017_ema,
      file = output
    )
  }
}
data_process_fisher2017_ema()
rm(data_process_fisher2017_ema)
