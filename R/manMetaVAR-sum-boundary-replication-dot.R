.SumBoundaryReplication <- function(taskid,
                                    repid,
                                    output_folder,
                                    output_type,
                                    method,
                                    heterogeneity,
                                    variance_tol,
                                    eigen_tol,
                                    k4 = FALSE) {
  suffix <- .SimSuffix(
    taskid = taskid,
    repid = repid
  )
  fn_input <- SimFN(
    output_type = output_type,
    output_folder = output_folder,
    suffix = suffix
  )
  object <- readRDS(fn_input)
  aligned <- .SumBoundaryAligned(
    object = object,
    output_type = output_type,
    heterogeneity = heterogeneity,
    k4 = k4
  )
  raw <- aligned$raw
  parameter <- aligned$parameter
  tau_names <- grep(
    pattern = "^tau_sqr\\[",
    x = rownames(raw),
    value = TRUE
  )
  if (length(tau_names) < 1L) {
    return(NULL)
  }
  index <- .ParseTauSqr(tau_names)
  estimates <- raw[tau_names, "est"]
  names(estimates) <- tau_names
  truth <- parameter[tau_names]
  p <- max(
    c(
      index$row,
      index$col
    )
  )
  tau_matrix <- matrix(
    data = 0,
    nrow = p,
    ncol = p
  )
  for (j in seq_len(nrow(index))) {
    tau_matrix[
      index$row[j],
      index$col[j]
    ] <- estimates[j]
    tau_matrix[
      index$col[j],
      index$row[j]
    ] <- estimates[j]
  }
  eigenvalues <- eigen(
    x = tau_matrix,
    symmetric = TRUE,
    only.values = TRUE
  )$values
  diagonal <- index$row == index$col
  is_bayesian <- output_type %in% c(
    "fit-mplus",
    "fit-mplus-priors",
    "fit-mplus-k4",
    "fit-mplus-k4-priors"
  )
  parameter_output <- data.frame(
    taskid = taskid,
    repid = repid,
    output_type = output_type,
    method = method,
    parnames = tau_names[diagonal],
    parameter = as.numeric(truth[diagonal]),
    estimate = as.numeric(estimates[diagonal]),
    near_zero = as.numeric(estimates[diagonal]) <= variance_tol,
    boundary = if (is_bayesian) {
      NA
    } else {
      as.numeric(estimates[diagonal]) <= variance_tol
    },
    classification = if (is_bayesian) {
      "bayesian_near_zero"
    } else {
      "ml_boundary"
    },
    stringsAsFactors = FALSE
  )
  replication_output <- data.frame(
    taskid = taskid,
    repid = repid,
    output_type = output_type,
    method = method,
    min_eigenvalue = if (is_bayesian) {
      NA_real_
    } else {
      min(eigenvalues)
    },
    near_singular = if (is_bayesian) {
      NA
    } else {
      min(eigenvalues) <= eigen_tol
    },
    positive_semidefinite = if (is_bayesian) {
      NA
    } else {
      min(eigenvalues) >= -eigen_tol
    },
    any_near_zero_variance = any(parameter_output$near_zero),
    any_boundary_variance = if (is_bayesian) {
      NA
    } else {
      any(parameter_output$boundary)
    },
    stringsAsFactors = FALSE
  )
  list(
    parameter = parameter_output,
    replication = replication_output
  )
}
