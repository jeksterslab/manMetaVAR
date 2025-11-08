#' Summary: Likelihood-Based (FitMetaVAR)
#'
#' @details This function is executed via the `Sum` function.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @return The output is saved as an external file in `output_folder`.
#'
#' @inheritParams Template
#' @export
#' @keywords manMetaVAR summary simulation
SumFitMetaVARLB <- function(taskid,
                            reps,
                            output_folder,
                            overwrite,
                            integrity) {
  # Do not include default arguments here.
  # Do not run on its own. Use the `Sum` function.
  fn_output <- SimFN(
    output_type = "summary-fit-meta-var-mx-lb",
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
      dynamics <- param$dynamics
      suffix <- .SimSuffix(
        taskid = taskid,
        repid = repid
      )
      fn_input <- SimFN(
        output_type = "fit-meta-var-mx",
        output_folder = output_folder,
        suffix = suffix
      )
      input <- readRDS(fn_input)
      raw <- summary(
        input
      )
      ci <- confint(
        input,
        lb = TRUE
      )
      parameter <- c(
        c(
          input$data$ma_fixed
        ),
        .Vech(
          input$data$ma_random
        )
      )
      df <- data.frame(
        est = raw[1:27, "est"],
        se = raw[1:27, "se"],
        z = raw[1:27, "z"],
        p = raw[1:27, "p"],
        ll = ci[1:27, "2.5 %"],
        ul = ci[1:27, "97.5 %"],
        sig = as.integer(
          raw[1:27, "p"] < 0.05
        ),
        zero_hit = as.integer(
          (
            ci[1:27, "2.5 %"] <= 0
          ) & (
            0 <= ci[1:27, "97.5 %"]
          )
        ),
        theta_hit = as.integer(
          (
            ci[1:27, "2.5 %"] <= parameter
          ) & (
            parameter <= ci[1:27, "97.5 %"]
          )
        ),
        sq_error = (parameter - raw[1:27, "est"])^2
      )
      attr(df, "taskid") <- taskid
      attr(df, "n") <- n
      attr(df, "time") <- time
      attr(df, "dynamics") <- dynamics
      attr(df, "parnames") <- rownames(raw)[1:27]
      attr(df, "parameter") <- parameter
      attr(df, "ci") <- "lb"
      attr(df, "method") <- "metavar"
      df
    }
    i <- lapply(
      X = seq_len(reps),
      FUN = replication,
      taskid = taskid
    )
    means <- (
      1 / reps
    ) * Reduce(
      f = `+`,
      x = i
    )
    sq_errors <- lapply(
      X = i,
      FUN = function(x, means) {
        (means - x)^2
      },
      means = means
    )
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
      dynamics = attr(i[[1]], "dynamics"),
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
      sq_error = means$sq_error
    )
    vars <- data.frame(
      taskid = attr(i[[1]], "taskid"),
      replications = reps,
      parnames = attr(i[[1]], "parnames"),
      parameter = attr(i[[1]], "parameter"),
      method = attr(i[[1]], "method"),
      n = attr(i[[1]], "n"),
      time = attr(i[[1]], "time"),
      dynamics = attr(i[[1]], "dynamics"),
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
      sq_error = vars$sq_error
    )
    sds <- data.frame(
      taskid = attr(i[[1]], "taskid"),
      replications = reps,
      parnames = attr(i[[1]], "parnames"),
      parameter = attr(i[[1]], "parameter"),
      method = attr(i[[1]], "method"),
      n = attr(i[[1]], "n"),
      time = attr(i[[1]], "time"),
      dynamics = attr(i[[1]], "dynamics"),
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
      sq_error = sds$sq_error
    )
    means$se_bias <- sds$est - means$se
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
