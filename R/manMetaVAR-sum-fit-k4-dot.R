#' Summarize Four-Variable Model Fits
#'
#' @keywords manMetaVAR summary simulation internal
#' @noRd
.SumFitK4 <- function(taskid,
                      reps,
                      output_folder,
                      overwrite,
                      integrity,
                      ncores,
                      input_type,
                      output_type,
                      method,
                      ci,
                      mplus = FALSE,
                      robust = NULL) {
  reps <- .SumValidateReps(reps)
  fn_output <- SimFN(
    output_type = output_type,
    output_folder = output_folder,
    suffix = paste0(
      sprintf("%05d", taskid),
      "-",
      sprintf("%05d", reps),
      ".Rds"
    )
  )
  run <- .SimCheck(
    fn = fn_output,
    overwrite = overwrite,
    integrity = integrity
  )
  if (!run) {
    return(invisible(NULL))
  }
  repids <- .SumValidRepids(
    taskid = taskid,
    reps = reps,
    output_folder = output_folder,
    output_type = input_type,
    k4 = TRUE
  )
  reps_used <- length(repids)
  if (reps_used < 2L) {
    stop(
      paste0(
        "At least two admissible replications are required for ",
        input_type,
        "; found ",
        reps_used,
        "."
      ),
      call. = FALSE
    )
  }
  replication <- function(repid,
                          taskid) {
    param <- params[taskid, ]
    n <- param$n
    time <- param$time
    heterogeneity <- param$heterogeneity
    suffix <- .SimSuffix(
      taskid = taskid,
      repid = repid
    )
    fn_input <- SimFN(
      output_type = input_type,
      output_folder = output_folder,
      suffix = suffix
    )
    input <- readRDS(fn_input)
    if (mplus) {
      raw <- summary(input)
      aligned <- .SumFitMplusPopulationK4(
        raw = raw,
        heterogeneity = heterogeneity
      )
    } else {
      if (is.null(robust)) {
        raw <- summary(input)
      } else {
        raw <- summary(
          input,
          robust = robust
        )
      }
      aligned <- .SumAlignPopulationK4(
        raw = raw,
        heterogeneity = heterogeneity
      )
    }
    raw <- aligned$raw
    parameter <- aligned$parameter
    if (mplus) {
      z <- rep(NA_real_, nrow(raw))
      p <- rep(NA_real_, nrow(raw))
      sig <- rep(NA_real_, nrow(raw))
    } else {
      z <- raw[, "z"]
      p <- raw[, "p"]
      sig <- as.integer(raw[, "p"] < 0.05)
    }
    df <- data.frame(
      est = raw[, "est"],
      se = raw[, "se"],
      z = z,
      p = p,
      ll = raw[, "2.5%"],
      ul = raw[, "97.5%"],
      sig = sig,
      zero_hit = as.integer(
        raw[, "2.5%"] <= 0 &
          0 <= raw[, "97.5%"]
      ),
      theta_hit = as.integer(
        raw[, "2.5%"] <= parameter &
          parameter <= raw[, "97.5%"]
      ),
      sq_error = (parameter - raw[, "est"])^2,
      bias = raw[, "est"] - parameter,
      rel_bias = .SimRelBias(
        thetahat = raw[, "est"],
        theta = parameter
      ),
      row.names = rownames(raw),
      check.names = FALSE
    )
    attr(df, "taskid") <- taskid
    attr(df, "n") <- n
    attr(df, "time") <- time
    attr(df, "heterogeneity") <- heterogeneity
    attr(df, "parnames") <- rownames(raw)
    attr(df, "parameter") <- parameter
    attr(df, "ci") <- ci
    attr(df, "method") <- method
    df
  }
  if (is.null(ncores)) {
    parallel_run <- FALSE
  } else {
    ncores <- min(
      as.integer(ncores),
      parallel::detectCores(),
      reps_used
    )
    parallel_run <- ncores > 1L
  }
  if (parallel_run) {
    replication_results <- parallel::mclapply(
      X = repids,
      FUN = replication,
      taskid = taskid,
      mc.cores = ncores
    )
  } else {
    replication_results <- lapply(
      X = repids,
      FUN = replication,
      taskid = taskid
    )
  }
  means <- (
    1 / reps_used
  ) * Reduce(
    f = `+`,
    x = replication_results
  )
  if (parallel_run) {
    sq_errors <- parallel::mclapply(
      X = replication_results,
      FUN = function(x, means) {
        (means - x)^2
      },
      means = means,
      mc.cores = ncores
    )
  } else {
    sq_errors <- lapply(
      X = replication_results,
      FUN = function(x, means) {
        (means - x)^2
      },
      means = means
    )
  }
  vars <- (
    1 / (reps_used - 1)
  ) * Reduce(
    f = `+`,
    x = sq_errors
  )
  sds <- sqrt(vars)
  means <- data.frame(
    taskid = attr(replication_results[[1]], "taskid"),
    replications = reps,
    replications_used = reps_used,
    parnames = attr(replication_results[[1]], "parnames"),
    parameter = attr(replication_results[[1]], "parameter"),
    method = attr(replication_results[[1]], "method"),
    n = attr(replication_results[[1]], "n"),
    time = attr(replication_results[[1]], "time"),
    heterogeneity = attr(replication_results[[1]], "heterogeneity"),
    ci = attr(replication_results[[1]], "ci"),
    est = means$est,
    se = means$se,
    z = means$z,
    p = means$p,
    ll = means$ll,
    ul = means$ul,
    sig = means$sig,
    zero_hit = means$zero_hit,
    theta_hit = means$theta_hit,
    sq_error = means$sq_error,
    bias = means$bias,
    rel_bias = means$rel_bias
  )
  vars <- data.frame(
    taskid = attr(replication_results[[1]], "taskid"),
    replications = reps,
    replications_used = reps_used,
    parnames = attr(replication_results[[1]], "parnames"),
    parameter = attr(replication_results[[1]], "parameter"),
    method = attr(replication_results[[1]], "method"),
    n = attr(replication_results[[1]], "n"),
    time = attr(replication_results[[1]], "time"),
    heterogeneity = attr(replication_results[[1]], "heterogeneity"),
    ci = attr(replication_results[[1]], "ci"),
    est = vars$est,
    se = vars$se,
    z = vars$z,
    p = vars$p,
    ll = vars$ll,
    ul = vars$ul,
    sig = vars$sig,
    zero_hit = vars$zero_hit,
    theta_hit = vars$theta_hit,
    sq_error = vars$sq_error,
    bias = vars$bias,
    rel_bias = vars$rel_bias
  )
  sds <- data.frame(
    taskid = attr(replication_results[[1]], "taskid"),
    replications = reps,
    replications_used = reps_used,
    parnames = attr(replication_results[[1]], "parnames"),
    parameter = attr(replication_results[[1]], "parameter"),
    method = attr(replication_results[[1]], "method"),
    n = attr(replication_results[[1]], "n"),
    time = attr(replication_results[[1]], "time"),
    heterogeneity = attr(replication_results[[1]], "heterogeneity"),
    ci = attr(replication_results[[1]], "ci"),
    est = sds$est,
    se = sds$se,
    z = sds$z,
    p = sds$p,
    ll = sds$ll,
    ul = sds$ul,
    sig = sds$sig,
    zero_hit = sds$zero_hit,
    theta_hit = sds$theta_hit,
    sq_error = sds$sq_error,
    bias = sds$bias,
    rel_bias = sds$rel_bias
  )
  means$se_bias <- means$se - sds$est
  means$rel_se_bias <- (means$se - sds$est) / sds$est
  means$rmse <- sqrt(means$sq_error)
  means$coverage <- means$theta_hit
  means$rejection_rate <- 1 - means$zero_hit
  zero_truth <- means$parameter == 0
  means$power <- ifelse(
    test = zero_truth,
    yes = NA_real_,
    no = means$rejection_rate
  )
  means$type1_error <- ifelse(
    test = zero_truth,
    yes = means$rejection_rate,
    no = NA_real_
  )
  means$success_rate <- reps_used / reps
  means <- .SumMCSE(
    replications = replication_results,
    means = means
  )
  output <- list(
    repids = repids,
    replications = replication_results,
    means = means,
    vars = vars,
    sds = sds
  )
  saveRDS(
    object = output,
    file = fn_output,
    compress = "xz"
  )
  .SimChMod(fn_output)
  invisible(output)
}
