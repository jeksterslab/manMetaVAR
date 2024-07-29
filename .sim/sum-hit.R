#!/usr/bin/env Rscript

# SIMULATION ARGUMENTS ---------------------------------------------------------
suppressMessages(
  suppressWarnings(
    library(manMetaVAR)
  )
)
source(
  file.path(
    "/scratch/ibp5092/manMetaVAR/.sim/",
    "sim-args.R"
  )
)
# ------------------------------------------------------------------------------

# RUN --------------------------------------------------------------------------
sum_hit <- lapply(
  X = seq_len(tasks),
  FUN = function(taskid,
                 reps,
                 output_folder,
                 ncores) {
    return(
      do.call(
        what = "rbind",
        args = lapply(
          X = c(
            "dynr-delta-xmy",
            "dynr-delta-ymx",
            "dynr-mc-xmy",
            "dynr-mc-ymx"
          ),
          FUN = function(output_type,
                         taskid,
                         reps,
                         output_folder,
                         ncores) {
            SumHit(
              taskid = taskid,
              reps = reps,
              output_folder = output_folder,
              output_type = output_type,
              params_taskid = params[which(params$taskid == taskid), ],
              ncores = ncores
            )
          },
          taskid = taskid,
          reps = reps,
          output_folder = output_folder,
          ncores = ncores
        )
      )
    )
  },
  reps = reps,
  output_folder = output_folder,
  ncores = parallel::detectCores()
)
sum_hit <- do.call(
  what = "rbind",
  args = sum_hit
)
sum_hit$effect <- c(
  "total",
  "direct",
  "indirect"
)
saveRDS(
  sum_hit,
  file = file.path(
    output_folder,
    paste0(
      "sum-hit-",
      manMetaVAR:::.SimSuffix(
        taskid = tasks,
        repid = reps
      )
    )
  ),
  compress = "xz"
)
