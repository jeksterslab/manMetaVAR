#' Summary: Naive
#'
#' @details This function is executed via the `Sum` function.
#'
#' @author Anonymous
#'
#' @return The output is saved as an external file in `output_folder`.
#'
#' @inheritParams Template
#' @export
#' @keywords manMetaVAR summary simulation
SumFitNaive <- function(taskid,
                        reps,
                        output_folder,
                        overwrite,
                        integrity,
                        ncores) {
  # Do not include default arguments here.
  # Do not run on its own. Use the `Sum` function.
  fn_output <- SimFN(
    output_type = "summary-fit-meta-var-mx-naive",
    output_folder = output_folder,
    suffix = paste0(
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
  )
  run <- .SimCheck(
    fn = fn_output,
    overwrite = overwrite,
    integrity = integrity
  )
  if (run) {
    replication <- function(repid,
                            taskid) {
      param <- params[taskid, ]
      n <- param$n
      time <- param$time
      suffix <- .SimSuffix(
        taskid = taskid,
        repid = repid
      )
      fn_input <- SimFN(
        output_type = "fit-naive",
        output_folder = output_folder,
        suffix = suffix
      )
      input <- readRDS(fn_input)
      raw <- summary(
        input
      )
      random_effect <- .Vech(
        model$ma_random
      )
      random_effect <- random_effect[
        random_effect != 0
      ]
      parameter <- c(
        c(
          model$ma_fixed
        ),
        random_effect
      )
      df <- data.frame(
        est = raw[, "est"],
        se = raw[, "se"],
        z = raw[, "z"],
        p = raw[, "p"],
        ll = raw[, "2.5%"],
        ul = raw[, "97.5%"],
        sig = as.integer(
          raw[, "p"] < 0.05
        ),
        zero_hit = as.integer(
          (
            raw[, "2.5%"] <= 0
          ) & (
            0 <= raw[, "97.5%"]
          )
        ),
        theta_hit = as.integer(
          (
            raw[, "2.5%"] <= parameter
          ) & (
            parameter <= raw[, "97.5%"]
          )
        ),
        sq_error = (parameter - raw[, "est"])^2,
        bias = raw[, "est"] - parameter,
        rel_bias = .SimRelBias(
          thetahat = raw[, "est"],
          theta = parameter
        )
      )
      attr(df, "taskid") <- taskid
      attr(df, "n") <- n
      attr(df, "time") <- time
      attr(df, "parnames") <- rownames(raw)
      attr(df, "parameter") <- parameter
      attr(df, "ci") <- "Normal"
      attr(df, "method") <- "Naive"
      df
    }
    if (is.null(ncores)) {
      par <- FALSE
    } else {
      ncores <- min(
        as.integer(ncores),
        parallel::detectCores(),
        reps
      )
      if (ncores > 1) {
        par <- TRUE
      } else {
        par <- FALSE
      }
    }
    if (par) {
      i <- parallel::mclapply(
        X = seq_len(reps),
        FUN = replication,
        taskid = taskid,
        mc.cores = ncores
      )
    } else {
      i <- lapply(
        X = seq_len(reps),
        FUN = replication,
        taskid = taskid
      )
    }
    means <- (
      1 / reps
    ) * Reduce(
      f = `+`,
      x = i
    )
    if (par) {
      sq_errors <- parallel::mclapply(
        X = i,
        FUN = function(x, means) {
          (means - x)^2
        },
        means = means,
        mc.cores = ncores
      )
    } else {
      sq_errors <- lapply(
        X = i,
        FUN = function(x, means) {
          (means - x)^2
        },
        means = means
      )
    }
    vars <- (
      1 / (reps - 1)
    ) * Reduce(
      f = `+`,
      x = sq_errors
    )
    sds <- sqrt(vars)
    means <- data.frame(
      taskid = attr(i[[1]], "taskid"),
      replications = reps,
      parnames = attr(i[[1]], "parnames"),
      parameter = attr(i[[1]], "parameter"),
      method = attr(i[[1]], "method"),
      n = attr(i[[1]], "n"),
      time = attr(i[[1]], "time"),
      ci = attr(i[[1]], "ci"),
      est = means$est,
      se = means$se,
      t = means$t,
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
      taskid = attr(i[[1]], "taskid"),
      replications = reps,
      parnames = attr(i[[1]], "parnames"),
      parameter = attr(i[[1]], "parameter"),
      method = attr(i[[1]], "method"),
      n = attr(i[[1]], "n"),
      time = attr(i[[1]], "time"),
      ci = attr(i[[1]], "ci"),
      est = vars$est,
      se = vars$se,
      t = vars$t,
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
      taskid = attr(i[[1]], "taskid"),
      replications = reps,
      parnames = attr(i[[1]], "parnames"),
      parameter = attr(i[[1]], "parameter"),
      method = attr(i[[1]], "method"),
      n = attr(i[[1]], "n"),
      time = attr(i[[1]], "time"),
      ci = attr(i[[1]], "ci"),
      est = sds$est,
      se = sds$se,
      t = sds$t,
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
    means$power <- 1 - means$zero_hit
    output <- list(
      replications = i,
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
  }
}
