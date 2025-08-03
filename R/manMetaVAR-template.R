#' @param data R object.
#'   Output of the [GenData()] function.
#' @param fit R object.
#'   Output of the [FitDTVARMx()] function.
#' @param max_iter Positive integer.
#'   Maximum number of reruns.
#' @param output_type Character string.
#'   Output type.
#'   Valid values include
#'   `"data"`,
#'   `"fit-dt-var-mx"`,
#'   `"fit-meta-var-mx"`,
#'   `"fit-ml-var"`, and
#'   `"fit-jags"`.
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
#'
#' @name Template
NULL
