#' @param dynamics `1`, `2`, or `3`.
#'   `1` for stable reciprocal regulation,
#'   `2` for escalating co-activation, and
#'   `3` for adaptive recovery.
#' @param data R object.
#'   Output of the [GenData()] function.
#' @param fit R object.
#'   Output of the [FitDTVAR()] function.
#' @param output_type Character string.
#'   Output type.
#'   Valid values include
#'   `"data"`,
#'   `"fit-dt-var-mx"`,
#'   `"fit-meta-var-mx"`, and
#'   `"fit-ml-var"`.
#' @param suffix Character string.
#'   Output of `manCTMed:::.SimSuffix()`.
#' @param output_folder Character string.
#'   Output folder.
#' @param overwrite Logical.
#'   Overwrite existing output in `output_folder`.
#' @param integrity Logical.
#'   If `integrity = TRUE`,
#'   check for the output file integrity when `overwrite = FALSE`.
#' @param seed Integer.
#'   Random seed.
#' @param taskid Positive integer.
#'   Task ID.
#' @param repid Positive integer.
#'   Replication ID.
#' @param reps Positive integer.
#'   Number of replications.
#' @param ncores Positive integer.
#'   Number of cores to use.
#' @param alpha Numeric vector.
#'   Significance level \eqn{\alpha}.
#' @param digits Integer indicating the number of decimal places to display.
#' @param show	Tables to show.
#' @param ... additional arguments.
#' @name Template
NULL
