#' Methods for Objects of Class `manmetavar.naive`
#'
#' This page documents the available methods for objects of class
#' `manmetavar.naive`.
#'
#' @name manmetavar-metavar-methods
#' @keywords methods
NULL

#' Parameter Estimates (FitNaive)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar.naive`.
#'
#' @inheritParams Template
#'
#' @rdname manmetavar-metavar-methods
#' @method coef manmetavar.naive
#' @keywords methods
#' @export
coef.manmetavar.naive <- function(object,
                                  ...) {
  coef(
    object$output,
    ...
  )
}

#' Sampling Covariance Matrix of the Parameter Estimates (FitNaive)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar.naive`.
#'
#' @inheritParams Template
#'
#' @rdname manmetavar-metavar-methods
#' @method vcov manmetavar.naive
#' @keywords methods
#' @export
vcov.manmetavar.naive <- function(object,
                                  ...) {
  vcov(
    object$output,
    ...
  )
}

#' Print Method (FitNaive)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param x Object of class `manmetavar.naive`.
#'
#' @inheritParams Template
#'
#' @rdname manmetavar-metavar-methods
#' @method print manmetavar.naive
#' @keywords methods
#' @export
print.manmetavar.naive <- function(x,
                                   ...) {
  print(
    x$output,
    ...
  )
}

#' Summary Method (FitNaive)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar.naive`.
#'
#' @inheritParams Template
#' @inheritParams summary.manmetavar.dtvar
#'
#' @rdname manmetavar-metavar-methods
#' @method summary manmetavar.naive
#' @keywords methods
#' @export
summary.manmetavar.naive <- function(object,
                                     alpha = 0.05,
                                     digits = 4,
                                     ...) {
  est <- coef(
    object$output
  )

  sampling_cov <- vcov(
    object$output
  )

  original_names <- names(est)

  valid_names <- function(x) {
    !is.null(x) &&
      !anyNA(x) &&
      all(nzchar(x)) &&
      !anyDuplicated(x)
  }

  if (!valid_names(original_names)) {
    stop(
      paste(
        "Naive coefficient names must be present",
        "and unique."
      ),
      call. = FALSE
    )
  }

  if (
    !is.matrix(sampling_cov) ||
      !identical(
        dim(sampling_cov),
        rep(
          length(est),
          2L
        )
      ) ||
      !valid_names(
        rownames(sampling_cov)
      ) ||
      !valid_names(
        colnames(sampling_cov)
      ) ||
      !setequal(
        rownames(sampling_cov),
        original_names
      ) ||
      !setequal(
        colnames(sampling_cov),
        original_names
      )
  ) {
    stop(
      paste(
        "Naive sampling covariance names must match",
        "the coefficient names."
      ),
      call. = FALSE
    )
  }

  # OpenMx's free-parameter order is not the population's
  # vech order. Translate actual names first, then reorder
  # estimates and uncertainty.
  is_mean <- grepl(
    "^mu_[1-6]$",
    original_names
  )

  is_covariance <- grepl(
    "^sigma_[1-6]_[1-6]$",
    original_names
  )

  if (any(!(is_mean | is_covariance))) {
    stop(
      "Unexpected naive coefficient names.",
      call. = FALSE
    )
  }

  mapped_names <- original_names

  mapped_names[is_mean] <- sub(
    "^mu_([1-6])$",
    "alpha[\\1,1]",
    original_names[is_mean]
  )

  indices <- strsplit(
    sub(
      "^sigma_",
      "",
      original_names[is_covariance]
    ),
    split = "_",
    fixed = TRUE
  )

  mapped_names[is_covariance] <- vapply(
    indices,
    FUN = function(x) {
      x <- as.integer(x)

      paste0(
        "tau_sqr[",
        max(x),
        ",",
        min(x),
        "]"
      )
    },
    FUN.VALUE = character(1)
  )

  parameter_names <- c(
    "alpha[1,1]",
    "alpha[2,1]",
    "alpha[3,1]",
    "alpha[4,1]",
    "alpha[5,1]",
    "alpha[6,1]",
    "tau_sqr[1,1]",
    "tau_sqr[2,1]",
    "tau_sqr[2,2]",
    "tau_sqr[3,3]",
    "tau_sqr[4,3]",
    "tau_sqr[5,3]",
    "tau_sqr[6,3]",
    "tau_sqr[4,4]",
    "tau_sqr[5,4]",
    "tau_sqr[6,4]",
    "tau_sqr[5,5]",
    "tau_sqr[6,5]",
    "tau_sqr[6,6]"
  )

  if (
    anyDuplicated(mapped_names) ||
      !setequal(
        mapped_names,
        parameter_names
      )
  ) {
    stop(
      paste(
        "Naive coefficients must match the six means",
        "and 13 covariance components."
      ),
      call. = FALSE
    )
  }

  parameter_order <- match(
    parameter_names,
    mapped_names
  )

  source_names <- original_names[
    parameter_order
  ]

  est <- est[
    parameter_order
  ]

  names(est) <- parameter_names

  se <- sqrt(
    diag(
      sampling_cov[
        source_names,
        source_names,
        drop = FALSE
      ]
    )
  )

  names(se) <- parameter_names

  out <- .CIWald(
    est = est,
    se = se,
    theta = 0,
    alpha = alpha,
    z = TRUE
  )

  print_summary <- round(
    x = out,
    digits = digits
  )

  class(out) <- c(
    "summary.manmetavar.naive",
    class(out)
  )

  attr(
    out,
    "fit"
  ) <- object

  attr(
    out,
    "alpha"
  ) <- alpha

  attr(
    out,
    "digits"
  ) <- digits

  attr(
    out,
    "print_summary"
  ) <- print_summary

  out
}

#' @noRd
#' @keywords internal
.PrintNaiveSummary <- function(x,
                               ...) {
  print_summary <- attr(
    x = x,
    which = "print_summary"
  )

  object <- attr(
    x = x,
    which = "fit"
  )

  print(print_summary)

  invisible(object)
}
