#' Summary: Tolerance Rates for Transition Heterogeneity
#'
#' Reads the replication-level summaries of one task
#' (MetaVAR with normal and robust intervals, the uncertainty-uncorrected
#' method, and DSEM with default and user-specified priors)
#' and computes, for each tolerance, the proportions of replications
#' returned by [Tolerance()] for the between-person variances and
#' covariances of the transition parameters.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param folder Character string.
#'   Folder with the summary files of the task.
#' @param delta Numeric vector. Tolerances.
#'
#' @return A data frame with one row per method, interval type, parameter,
#'   and tolerance.
#'
#' @inheritParams Template
#' @keywords manMetaVAR summary simulation
#' @export
SumTolerance <- function(taskid,
                         reps,
                         folder,
                         delta = c(
                           0, 1e-04, 2.5e-04, 4e-04, 5e-04,
                           9e-04, 0.001, 0.0025, 0.005, 0.01
                         )) {
  output_types <- c(
    "summary-fit-meta-var-mx-normal",
    "summary-fit-meta-var-mx-robust",
    "summary-fit-meta-var-mx-naive",
    "summary-fit-mplus",
    "summary-fit-mplus-priors"
  )
  suffix <- paste0(
    sprintf(
      "%05d",
      taskid
    ),
    "-",
    sprintf(
      "%05d",
      reps
    ),
    ".Rds"
  )
  out <- lapply(
    X = output_types,
    FUN = function(output_type) {
      fn <- SimFN(
        output_type = output_type,
        output_folder = folder,
        suffix = suffix
      )
      if (!file.exists(fn)) {
        return(NULL)
      }
      replications <- readRDS(fn)$replications
      first <- replications[[1]]
      parnames <- attr(first, "parnames")
      pos <- regmatches(
        x = parnames,
        m = regexec(
          pattern = "^tau_sqr\\[([0-9]+),([0-9]+)\\]$",
          text = parnames
        )
      )
      i <- vapply(
        X = pos,
        FUN = function(x) {
          if (length(x) == 3L) as.integer(x[2]) else NA_integer_
        },
        FUN.VALUE = integer(1)
      )
      j <- vapply(
        X = pos,
        FUN = function(x) {
          if (length(x) == 3L) as.integer(x[3]) else NA_integer_
        },
        FUN.VALUE = integer(1)
      )
      keep <- which(!is.na(i) & i >= 3L & j >= 3L)
      variance <- i[keep] == j[keep]
      est <- do.call(
        what = "cbind",
        args = lapply(replications, function(x) x$est[keep])
      )
      ll <- do.call(
        what = "cbind",
        args = lapply(replications, function(x) x$ll[keep])
      )
      ul <- do.call(
        what = "cbind",
        args = lapply(replications, function(x) x$ul[keep])
      )
      do.call(
        what = "rbind",
        args = lapply(
          X = delta,
          FUN = function(d) {
            decision <- Tolerance(
              est = c(est),
              ll = c(ll),
              ul = c(ul),
              variance = rep(variance, times = ncol(est)),
              delta = d
            )
            rate <- function(x) {
              rowMeans(
                matrix(
                  data = x,
                  nrow = length(keep)
                )
              )
            }
            data.frame(
              taskid = taskid,
              replications = reps,
              replications_used = ncol(est),
              method = attr(first, "method"),
              ci = attr(first, "ci"),
              n = attr(first, "n"),
              time = attr(first, "time"),
              heterogeneity = attr(first, "heterogeneity"),
              parnames = parnames[keep],
              parameter = unname(attr(first, "parameter")[keep]),
              type = ifelse(variance, "variance", "covariance"),
              delta = d,
              est_within = rate(decision$est_within),
              equivalent = rate(decision$equivalent),
              exceed = rate(decision$exceed)
            )
          }
        )
      )
    }
  )
  out <- do.call(
    what = "rbind",
    args = out
  )
  rownames(out) <- NULL
  out
}
