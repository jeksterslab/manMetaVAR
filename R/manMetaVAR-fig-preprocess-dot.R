.FigPreprocessWithHet <- function(results) {
  required <- c(
    "taskid",
    "parnames",
    "parameter",
    "method",
    "n",
    "time",
    "heterogeneity",
    "ci",
    "bias",
    "rel_bias"
  )
  missing <- setdiff(
    required,
    names(results)
  )
  if (length(missing) > 0L) {
    stop(
      paste0(
        "`results` is missing: ",
        paste(missing, collapse = ", "),
        "."
      ),
      call. = FALSE
    )
  }
  parameter_dictionary <- data.frame(
    parnames = c(
      paste0("alpha[", seq_len(6L), ",1]"),
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
    ),
    parameter_label = c(
      "SP 1",
      "SP 2",
      "AR 1->1",
      "CL 1->2",
      "CL 2->1",
      "AR 2->2",
      "Var(SP 1)",
      "Cov(SP 1, SP 2)",
      "Var(SP 2)",
      "Var(AR 1->1)",
      "Cov(AR 1->1, CL 1->2)",
      "Cov(AR 1->1, CL 2->1)",
      "Cov(AR 1->1, AR 2->2)",
      "Var(CL 1->2)",
      "Cov(CL 1->2, CL 2->1)",
      "Cov(CL 1->2, AR 2->2)",
      "Var(CL 2->1)",
      "Cov(CL 2->1, AR 2->2)",
      "Var(AR 2->2)"
    ),
    target = c(
      rep("FE", 6L),
      rep("RE", 13L)
    ),
    stringsAsFactors = FALSE
  )
  condition_dictionary <- unique(
    results[
      c(
        "taskid",
        "n",
        "time",
        "heterogeneity"
      )
    ]
  )
  condition_dictionary <- condition_dictionary[
    order(
      condition_dictionary$heterogeneity,
      condition_dictionary$taskid
    ),
  ]
  if (anyDuplicated(condition_dictionary$taskid)) {
    stop(
      "Each task ID should identify one simulation design condition.",
      call. = FALSE
    )
  }
  condition_dictionary$condition_label <- ifelse(
    is.na(condition_dictionary$time),
    paste0(
      "N = ",
      condition_dictionary$n,
      ", T = Unbalanced"
    ),
    paste0(
      "N = ",
      condition_dictionary$n,
      ", T = ",
      as.integer(condition_dictionary$time)
    )
  )
  condition_dictionary$heterogeneity_label <- paste0(
    "Het = ",
    format(
      condition_dictionary$heterogeneity,
      trim = TRUE,
      scientific = FALSE
    )
  )
  condition_dictionary <- condition_dictionary[
    c(
      "taskid",
      "condition_label",
      "heterogeneity_label"
    )
  ]
  condition_levels <- unique(
    condition_dictionary$condition_label
  )
  heterogeneity_levels <- unique(
    condition_dictionary$heterogeneity_label
  )
  fixed_levels <- parameter_dictionary$parameter_label[
    parameter_dictionary$target == "FE"
  ]
  random_levels <- parameter_dictionary$parameter_label[
    parameter_dictionary$target == "RE"
  ]
  parameter_levels <- rev(
    c(
      random_levels,
      fixed_levels
    )
  )
  results <- results[
    results$method != "MetaVAR" | results$ci == "Normal", ,
    drop = FALSE
  ]
  results$method[results$method == "Naive"] <- "Uncorr"
  results$method[results$method == "BMLVAR"] <- "BMLVAR-Default"
  parameter_location <- match(
    results$parnames,
    parameter_dictionary$parnames
  )
  if (anyNA(parameter_location)) {
    stop(
      paste0(
        "Unknown parameters were found: ",
        paste(
          unique(results$parnames[is.na(parameter_location)]),
          collapse = ", "
        ),
        "."
      ),
      call. = FALSE
    )
  }
  results <- cbind(
    results,
    parameter_dictionary[
      parameter_location,
      setdiff(
        names(parameter_dictionary),
        "parnames"
      ),
      drop = FALSE
    ]
  )
  condition_location <- match(
    results$taskid,
    condition_dictionary$taskid
  )
  if (anyNA(condition_location)) {
    stop(
      paste0(
        "Unknown task IDs were found: ",
        paste(
          unique(results$taskid[is.na(condition_location)]),
          collapse = ", "
        ),
        "."
      ),
      call. = FALSE
    )
  }
  results <- cbind(
    results,
    condition_dictionary[
      condition_location,
      setdiff(
        names(condition_dictionary),
        "taskid"
      ),
      drop = FALSE
    ]
  )
  results$method <- factor(
    results$method,
    levels = c(
      "MetaVAR",
      "BMLVAR-Default",
      "BMLVAR-Priors",
      "Uncorr"
    )
  )
  if (anyNA(results$method)) {
    stop(
      "Unknown methods were found in `results`.",
      call. = FALSE
    )
  }
  results$target <- factor(
    results$target,
    levels = c(
      "FE",
      "RE"
    )
  )
  results$condition_label <- factor(
    results$condition_label,
    levels = condition_levels
  )
  results$heterogeneity_label <- factor(
    results$heterogeneity_label,
    levels = heterogeneity_levels
  )
  results$parameter_label <- factor(
    results$parameter_label,
    levels = parameter_levels
  )
  results$abs_rel_bias <- ifelse(
    test = results$parameter == 0,
    yes = abs(results$bias),
    no = abs(results$rel_bias)
  )
  results
}

.FigPreprocess <- function(results) {
  if (!"heterogeneity" %in% names(results)) {
    location <- match(
      results$taskid,
      params$taskid
    )
    if (anyNA(location)) {
      stop(
        "Heterogeneity could not be inferred for one or more task IDs.",
        call. = FALSE
      )
    }
    results$heterogeneity <- params$heterogeneity[location]
  }
  .FigPreprocessWithHet(results)
}
