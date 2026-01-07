data_process_fisher2017_between <- function(overwrite = FALSE) {
  cat("\ndata_process_fisher2017_between\n")
  set.seed(42)
  # find root directory
  root <- rprojroot::is_rstudio_project
  output <- root$find_file(
    ".setup",
    "data-raw",
    "fisher2017-between.Rds"
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
    fisher2017_between <- read.csv(
      file = root$find_file(
        ".setup",
        "data-raw",
        "fisher2017_between.txt"
      )
    )
    # Male = 1
    # Female = 0
    fisher2017_between$gender <- ifelse(
      test = fisher2017_between$gender == "Male",
      yes = 1,
      no = 0
    )
    # MDD = 1
    # GAD = 0
    fisher2017_between$diagnosis <- ifelse(
      test = fisher2017_between$diagnosis == "MDD",
      yes = 1,
      no = 0
    )
    age <- c(
      "18-24" = 1,
      "25-30" = 2,
      "31-40" = 3,
      "41-50" = 4,
      "51-60" = 5
    )
    fisher2017_between$age <- unname(age[fisher2017_between$age])
    ethnicity <- c(
      "White" = 1,
      "Latino" = 2,
      "Black" = 3,
      "Asian American" = 4,
      "Other" = 5
    )
    fisher2017_between$ethnicity <- unname(ethnicity[fisher2017_between$ethnicity])
    saveRDS(
      object = fisher2017_between,
      file = output
    )
  }
}
data_process_fisher2017_between()
rm(data_process_fisher2017_between)
