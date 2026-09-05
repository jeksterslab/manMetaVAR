.SumFitMplusDiagnostics <- function(taskid,
                                    reps,
                                    output_folder,
                                    overwrite,
                                    integrity,
                                    ncores,
                                    input_type,
                                    output_type,
                                    default_priors,
                                    diagnostics_class =
                                      "manmetavar.mplus.diagnostics",
                                    fit_function =
                                      "FitMplusDiagnostics()",
                                    method = "BMLVAR",
                                    summary_class =
                                      "manmetavar.mplus.diagnostics.summary",
                                    fit_input_type = NULL,
                                    diagnostics_function = NULL) {
  if (
    length(reps) != 1L ||
      !is.numeric(reps) ||
      reps < 1 ||
      reps != floor(reps)
  ) {
    stop(
      "`reps` should be a positive integer.",
      call. = FALSE
    )
  }
  reps <- as.integer(reps)
  if (xor(is.null(fit_input_type), is.null(diagnostics_function))) {
    stop(
      paste(
        "`fit_input_type` and `diagnostics_function` should either both",
        "be supplied or both be `NULL`."
      ),
      call. = FALSE
    )
  }
  fn_output <- SimFN(
    output_type = output_type,
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
    status_output_type <- if (is.null(fit_input_type)) {
      sub(
        pattern = "-diagnostics$",
        replacement = "",
        x = input_type
      )
    } else {
      fit_input_type
    }
    k4 <- grepl(
      pattern = "-k4",
      x = status_output_type,
      fixed = TRUE
    )
    repids <- .SumValidRepids(
      taskid = taskid,
      reps = reps,
      output_folder = output_folder,
      output_type = status_output_type,
      k4 = k4
    )
    reps_used <- length(repids)
    if (reps_used < 1L) {
      stop(
        paste0(
          "No admissible replications are available for ",
          status_output_type,
          "."
        ),
        call. = FALSE
      )
    }
    param <- params[taskid, ]
    n <- param$n
    time <- param$time
    replication <- function(repid) {
      suffix <- .SimSuffix(
        taskid = taskid,
        repid = repid
      )
      fn_input <- SimFN(
        output_type = input_type,
        output_folder = output_folder,
        suffix = suffix
      )
      if (file.exists(fn_input)) {
        diagnostics <- readRDS(fn_input)
      } else if (!is.null(fit_input_type)) {
        fn_fit <- SimFN(
          output_type = fit_input_type,
          output_folder = output_folder,
          suffix = suffix
        )
        diagnostics <- diagnostics_function(
          readRDS(fn_fit)
        )
        saveRDS(
          object = diagnostics,
          file = fn_input,
          compress = "xz"
        )
        .SimChMod(fn_input)
      } else {
        diagnostics <- readRDS(fn_input)
      }
      if (
        !inherits(
          diagnostics,
          diagnostics_class
        )
      ) {
        stop(
          paste0(
            "Replication ",
            repid,
            " does not contain the output of `",
            fit_function,
            "`."
          ),
          call. = FALSE
        )
      }
      if (
        !identical(
          isTRUE(diagnostics$run$default_priors),
          isTRUE(default_priors)
        )
      ) {
        stop(
          paste0(
            "Replication ",
            repid,
            " does not match the requested prior condition."
          ),
          call. = FALSE
        )
      }
      diagnostics
    }
    if (is.null(ncores)) {
      par <- FALSE
    } else {
      ncores <- min(
        as.integer(ncores),
        parallel::detectCores(),
        reps_used
      )
      par <- ncores > 1L
    }
    if (par) {
      diagnostics <- parallel::mclapply(
        X = repids,
        FUN = replication,
        mc.cores = ncores
      )
    } else {
      diagnostics <- lapply(
        X = repids,
        FUN = replication
      )
    }
    parnames <- diagnostics[[1]]$parameters$parameter
    same_parameters <- vapply(
      X = diagnostics,
      FUN = function(x) {
        identical(x$parameters$parameter, parnames)
      },
      FUN.VALUE = logical(1)
    )
    if (!all(same_parameters)) {
      stop(
        "Parameter names or ordering differ across diagnostic replications.",
        call. = FALSE
      )
    }
    diagnostic_names <- setdiff(
      x = names(diagnostics[[1]]$parameters),
      y = "parameter"
    )
    numeric_diagnostics <- vapply(
      X = diagnostics[[1]]$parameters[diagnostic_names],
      FUN = is.numeric,
      FUN.VALUE = logical(1)
    )
    if (!all(numeric_diagnostics)) {
      stop(
        "All parameter diagnostics should be numeric.",
        call. = FALSE
      )
    }
    parameter_matrices <- lapply(
      X = diagnostics,
      FUN = function(x) {
        as.matrix(
          x$parameters[
            ,
            diagnostic_names,
            drop = FALSE
          ]
        )
      }
    )
    .array_summary <- function(x) {
      dims <- dim(x[[1]])
      values <- array(
        data = unlist(
          x = x,
          use.names = FALSE
        ),
        dim = c(
          dims,
          length(x)
        )
      )
      finite_values <- is.finite(values)
      means <- apply(
        X = values,
        MARGIN = c(1, 2),
        FUN = function(z) {
          z <- z[is.finite(z)]
          if (length(z) == 0L) NA_real_ else mean(z)
        }
      )
      vars <- apply(
        X = values,
        MARGIN = c(1, 2),
        FUN = function(z) {
          z <- z[is.finite(z)]
          if (length(z) < 2L) NA_real_ else stats::var(z)
        }
      )
      valid <- apply(
        X = finite_values,
        MARGIN = c(1, 2),
        FUN = sum
      )
      dimnames(means) <- dimnames(x[[1]])
      dimnames(vars) <- dimnames(x[[1]])
      dimnames(valid) <- dimnames(x[[1]])
      list(
        means = means,
        vars = vars,
        sds = sqrt(vars),
        valid = valid
      )
    }
    parameter_summary <- .array_summary(parameter_matrices)
    .parameter_data_frame <- function(x) {
      data.frame(
        taskid = taskid,
        replications = reps,
        replications_used = reps_used,
        parnames = parnames,
        method = method,
        default_priors = default_priors,
        n = n,
        time = time,
        as.data.frame(
          x,
          check.names = FALSE
        ),
        row.names = NULL,
        check.names = FALSE
      )
    }
    means <- .parameter_data_frame(parameter_summary$means)
    vars <- .parameter_data_frame(parameter_summary$vars)
    sds <- .parameter_data_frame(parameter_summary$sds)
    valid_matrix <- parameter_summary$valid
    colnames(valid_matrix) <- paste0(
      "n_valid_",
      colnames(valid_matrix)
    )
    valid <- .parameter_data_frame(valid_matrix)
    runs <- do.call(
      what = "rbind",
      args = lapply(
        X = seq_along(diagnostics),
        FUN = function(j) {
          data.frame(
            taskid = taskid,
            repid = repids[j],
            method = method,
            n = n,
            time = time,
            diagnostics[[j]]$run,
            row.names = NULL,
            check.names = FALSE
          )
        }
      )
    )
    rownames(runs) <- NULL
    run_diagnostic_names <- names(diagnostics[[1]]$run)[
      vapply(
        X = diagnostics[[1]]$run,
        FUN = is.numeric,
        FUN.VALUE = logical(1)
      )
    ]
    run_matrices <- lapply(
      X = diagnostics,
      FUN = function(x) {
        as.matrix(
          x$run[
            ,
            run_diagnostic_names,
            drop = FALSE
          ]
        )
      }
    )
    run_summary <- .array_summary(run_matrices)
    .run_data_frame <- function(x) {
      data.frame(
        taskid = taskid,
        replications = reps,
        replications_used = reps_used,
        method = method,
        default_priors = default_priors,
        n = n,
        time = time,
        as.data.frame(
          x,
          check.names = FALSE
        ),
        row.names = NULL,
        check.names = FALSE
      )
    }
    run_means <- .run_data_frame(run_summary$means)
    run_vars <- .run_data_frame(run_summary$vars)
    run_sds <- .run_data_frame(run_summary$sds)
    run_valid_matrix <- run_summary$valid
    colnames(run_valid_matrix) <- paste0(
      "n_valid_",
      colnames(run_valid_matrix)
    )
    run_valid <- .run_data_frame(run_valid_matrix)
    output <- list(
      repids = repids,
      replications = diagnostics,
      means = means,
      vars = vars,
      sds = sds,
      valid = valid,
      runs = runs,
      run_means = run_means,
      run_vars = run_vars,
      run_sds = run_sds,
      run_valid = run_valid
    )
    class(output) <- unique(
      c(
        summary_class,
        "manmetavar.mplus.diagnostics.summary",
        class(output)
      )
    )
    saveRDS(
      object = output,
      file = fn_output,
      compress = "xz"
    )
    .SimChMod(fn_output)
  }
}
