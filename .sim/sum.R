# AVOID OVER SUBSCRIPTION ------------------------------------------------------
Sys.setenv(
  OMP_NUM_THREADS = "1",
  MKL_NUM_THREADS = "1",
  OPENBLAS_NUM_THREADS = "1"
)

# SIMULATION ARGUMENTS ---------------------------------------------------------
suppressMessages(
  suppressWarnings(
    library(OpenMx)
  )
)
suppressMessages(
  suppressWarnings(
    library(fitVARMxID)
  )
)
suppressMessages(
  suppressWarnings(
    library(metaDyn)
  )
)
suppressMessages(
  suppressWarnings(
    library(manMetaVAR)
  )
)
source(
  file.path(
    "/scratch",
    Sys.getenv("USER"),
    "manMetaVAR",
    ".sim",
    "sim-args.R"
  )
)
# ------------------------------------------------------------------------------
ncores <- parallel::detectCores()
summary_errors <- lapply(
  X = seq_len(tasks),
  FUN = function(taskid) {
    tryCatch(
      {
        Sum(
          taskid = taskid,
          reps = reps,
          output_folder = output_folder,
          overwrite = overwrite,
          integrity = TRUE,
          naive = naive,
          metavar_normal = metavar_normal,
          metavar_robust = metavar_robust,
          mplus = mplus,
          ncores = ncores
        )
        NULL
      },
      error = function(e) {
        list(
          taskid = taskid,
          message = conditionMessage(e)
        )
      }
    )
  }
)

summary_errors <- Filter(
  f = Negate(is.null),
  x = summary_errors
)

if (length(summary_errors) > 0L) {
  message("\nSummary errors:")
  for (x in summary_errors) {
    message(
      "taskid = ",
      x$taskid,
      ": ",
      x$message
    )
  }
  stop(
    "One or more simulation tasks could not be summarized.",
    call. = FALSE
  )
}
