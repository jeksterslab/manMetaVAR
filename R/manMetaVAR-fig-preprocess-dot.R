.FigPreprocess <- function(results) {
  parameter_dictionary <- data.frame(
    parnames = c(
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
      rep("Fixed effects", 6L),
      rep("Random effects", 13L)
    ),
    stringsAsFactors = FALSE
  )
  condition_dictionary <- unique(
    results[
      c(
        "taskid",
        "n",
        "time"
      )
    ]
  )
  condition_dictionary <- condition_dictionary[
    order(
      condition_dictionary$taskid
    ),
  ]
  condition_dictionary$condition_label <- ifelse(
    is.na(condition_dictionary$time),
    paste0(
      "N = ",
      condition_dictionary$n,
      "\nT = Unbalanced"
    ),
    paste0(
      "N = ",
      condition_dictionary$n,
      "\nT = ",
      as.integer(condition_dictionary$time)
    )
  )
  condition_dictionary <- condition_dictionary[
    c(
      "taskid",
      "condition_label"
    )
  ]
  condition_levels <- condition_dictionary$condition_label
  fixed_levels <- parameter_dictionary$parameter_label[
    parameter_dictionary$target == "Fixed effects"
  ]
  random_levels <- parameter_dictionary$parameter_label[
    parameter_dictionary$target == "Random effects"
  ]
  parameter_levels <- rev(
    c(
      random_levels,
      fixed_levels
    )
  )
  results <- results[
    results$method != "MetaVAR" | results$ci == "Normal",
  ]
  i <- match(
    results$parnames,
    parameter_dictionary$parnames
  )
  results <- cbind(
    results,
    parameter_dictionary[
      i,
      setdiff(
        names(parameter_dictionary),
        "parnames"
      ),
      drop = FALSE
    ]
  )
  i <- match(
    results$taskid,
    condition_dictionary$taskid
  )
  results <- cbind(
    results,
    condition_dictionary[
      i,
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
      "BMLVAR",
      "Uncorr"
    )
  )
  results$target <- factor(
    results$target,
    levels = c(
      "Fixed effects",
      "Random effects"
    )
  )
  results$condition_label <- factor(
    results$condition_label,
    levels = condition_levels
  )
  results$parameter_label <- factor(
    results$parameter_label,
    levels = parameter_levels
  )
  results$abs_rel_bias <- abs(
    results$rel_bias
  )
  results
}
