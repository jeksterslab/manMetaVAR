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
#'   `"fit-mplus"`.
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
#' @param wd Character string.
#'   Working directory.
#' @param mplus_bin Character string.
#'   Path to Mplus binary.
#'   If `mplus_bin = NULL`,
#'   the function will try to find
#'   the appropriate binary.
#' @param fn_data Character string.
#'   Filename for data file.
#' @param fn_estimates Character string.
#'   Filename for estimates output.
#' @param fn_results Character string.
#'   Filename for results output.
#' @param fn_posterior Character string.
#'   Filename for posterior output.
#' @param fn_factorscores Character string.
#'   Filename for factor scores output.
#' @param chains Integer.
#'   Number of chains.
#' @param iter Integer.
#'   Number of iterations.
#' @param fscores Integer.
#'   Number of iterations for factor scores.
#' @param naive Logical.
#'   If `naive = TRUE`, fit the naive approach.
#' @param mplus Logical.
#'   If `mplus = TRUE`, fit the model using DSEM in `Mplus`.
#' @param metavar Logical.
#'   If `metavar = TRUE`, fit the model using the `metaDyn` package.
#' @param plot Logical.
#'   If `plot = TRUE`, add `PLOT: TYPE = PLOT3;`
#'   to `Mplus` input file.
#' @param ... additional arguments.
#' @name Template
NULL
