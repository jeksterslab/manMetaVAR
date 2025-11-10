#' Simulation Parameters
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @docType data
#' @name params
#' @usage data(params)
#' @format A dataframe with 27 rows and 4 columns:
#'
#' \describe{
#'   \item{taskid}{
#'     Simulation Task ID.
#'   }
#'   \item{n}{
#'     Sample size.
#'   }
#'   \item{time}{
#'     Number of measurement occassions.
#'   }
#'   \item{dynamics}{
#'     Process dynamics.
#'     `1` for stable reciprocal regulation,
#'     `2` for escalating co-activation, and
#'     `3` for adaptive recovery.
#'   }
#' }
#'
#' @keywords data parameters
"params"
