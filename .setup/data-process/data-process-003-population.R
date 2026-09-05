data_process_population <- function(overwrite = FALSE,
                                    n_population = 1000000L,
                                    batch_size = 50000L,
                                    seed = 42001L,
                                    margin = 1) {
  cat("\ndata_process_population\n")
  if (
    length(n_population) != 1L ||
      is.na(n_population) ||
      n_population < 2 ||
      n_population != as.integer(n_population)
  ) {
    stop(
      "`n_population` must be a single integer greater than one.",
      call. = FALSE
    )
  }
  if (
    length(batch_size) != 1L ||
      is.na(batch_size) ||
      batch_size < 1 ||
      batch_size != as.integer(batch_size)
  ) {
    stop(
      "`batch_size` must be a positive integer.",
      call. = FALSE
    )
  }
  if (
    length(seed) != 1L ||
      is.na(seed) ||
      seed != as.integer(seed)
  ) {
    stop(
      "`seed` must be a single integer.",
      call. = FALSE
    )
  }
  if (
    length(margin) != 1L ||
      is.na(margin) ||
      margin <= 0 ||
      margin > 1
  ) {
    stop(
      "`margin` must be greater than zero and no greater than one.",
      call. = FALSE
    )
  }
  n_population <- as.integer(n_population)
  batch_size <- as.integer(batch_size)
  seed <- as.integer(seed)
  root <- rprojroot::is_rstudio_project
  data_folder <- root$find_file(
    "data"
  )
  if (!dir.exists(data_folder)) {
    dir.create(
      data_folder,
      recursive = TRUE
    )
  }
  population_file <- file.path(
    data_folder,
    "population.rda"
  )
  if (!file.exists(population_file)) {
    write <- TRUE
  } else {
    if (overwrite) {
      write <- TRUE
    } else {
      write <- FALSE
    }
  }
  if (write) {
    model_file <- file.path(
      data_folder,
      "model.rda"
    )
    params_file <- file.path(
      data_folder,
      "params.rda"
    )
    if (!file.exists(model_file)) {
      stop(
        "`data/model.rda` does not exist. Run data-process-model first.",
        call. = FALSE
      )
    }
    if (!file.exists(params_file)) {
      stop(
        "`data/params.rda` does not exist. Run data-process-params first.",
        call. = FALSE
      )
    }
    data_environment <- new.env(
      parent = emptyenv()
    )
    load(
      file = model_file,
      envir = data_environment
    )
    load(
      file = params_file,
      envir = data_environment
    )
    model <- data_environment$model
    params <- data_environment$params
    rm(data_environment)

    k <- model$k
    q <- k * k
    beta_names <- paste0(
      "beta[",
      rep(seq_len(k), times = k),
      ",",
      rep(seq_len(k), each = k),
      "]"
    )
    beta_pair_location <- which(
      lower.tri(
        x = matrix(
          data = FALSE,
          nrow = q,
          ncol = q
        ),
        diag = TRUE
      ),
      arr.ind = TRUE
    )
    n_beta_pairs <- nrow(beta_pair_location)
    mu_names <- paste0(
      "mu[",
      seq_len(k),
      ",1]"
    )
    vech <- function(x) {
      x[
        lower.tri(
          x = x,
          diag = TRUE
        )
      ]
    }
    tau_names <- function(index) {
      index_matrix <- matrix(
        data = FALSE,
        nrow = length(index),
        ncol = length(index)
      )
      location <- which(
        lower.tri(
          x = index_matrix,
          diag = TRUE
        ),
        arr.ind = TRUE
      )
      paste0(
        "tau_sqr[",
        index[location[, "row"]],
        ",",
        index[location[, "col"]],
        "]"
      )
    }
    condition_key <- function(x) {
      format(
        x,
        scientific = FALSE,
        trim = TRUE,
        digits = 15
      )
    }
    calibrate_beta <- function(heterogeneity,
                               condition_seed) {
      if (heterogeneity == 0) {
        beta_mu <- model$beta_mu
        beta_sigma <- matrix(
          data = 0,
          nrow = q,
          ncol = q
        )
        dimnames(beta_sigma) <- list(
          beta_names,
          beta_names
        )
        beta_sigma_mcse <- beta_sigma
        return(
          list(
            empirical = FALSE,
            seed = NA_integer_,
            n_population = NA_integer_,
            beta_mu = beta_mu,
            beta_sigma = beta_sigma,
            beta_mu_mcse = setNames(
              rep(0, q),
              beta_names
            ),
            beta_sigma_mcse = beta_sigma_mcse
          )
        )
      }
      set.seed(condition_seed)
      n_complete <- 0L
      moment_mean <- numeric(q + n_beta_pairs)
      moment_m2 <- matrix(
        data = 0,
        nrow = q + n_beta_pairs,
        ncol = q + n_beta_pairs
      )
      while (n_complete < n_population) {
        n_batch <- min(
          batch_size,
          n_population - n_complete
        )
        beta <- simStateSpace::SimBetaN(
          n = n_batch,
          beta = model$beta_mu,
          vcov_beta_vec_l =
            sqrt(heterogeneity) * model$beta_sigma_l,
          margin = margin
        )
        beta_vec <- t(
          vapply(
            X = beta,
            FUN = function(x) {
              c(x)
            },
            FUN.VALUE = numeric(q)
          )
        )
        beta_product <-
          beta_vec[
            ,
            beta_pair_location[, "row"],
            drop = FALSE
          ] *
            beta_vec[
              ,
              beta_pair_location[, "col"],
              drop = FALSE
            ]
        moments <- cbind(
          beta_vec,
          beta_product
        )
        batch_mean <- colMeans(moments)
        batch_centered <- sweep(
          x = moments,
          MARGIN = 2L,
          STATS = batch_mean,
          FUN = "-"
        )
        batch_m2 <- crossprod(batch_centered)
        if (n_complete == 0L) {
          moment_mean <- batch_mean
          moment_m2 <- batch_m2
        } else {
          n_combined <- n_complete + n_batch
          delta <- batch_mean - moment_mean
          moment_m2 <- moment_m2 +
            batch_m2 +
            tcrossprod(delta) *
              (
                as.double(n_complete) *
                  as.double(n_batch) /
                  as.double(n_combined)
              )
          moment_mean <- moment_mean +
            delta *
              (
                as.double(n_batch) /
                  as.double(n_combined)
              )
        }
        n_complete <- n_complete + n_batch
      }
      beta_mean <- moment_mean[seq_len(q)]
      moment_sigma <- moment_m2 / (n_population - 1)
      beta_sigma <- moment_sigma[
        seq_len(q),
        seq_len(q),
        drop = FALSE
      ]
      dimnames(beta_sigma) <- list(
        beta_names,
        beta_names
      )
      beta_sigma_mcse <- matrix(
        data = 0,
        nrow = q,
        ncol = q,
        dimnames = list(
          beta_names,
          beta_names
        )
      )
      for (j in seq_len(n_beta_pairs)) {
        row <- beta_pair_location[j, "row"]
        col <- beta_pair_location[j, "col"]
        gradient <- numeric(q + n_beta_pairs)
        gradient[row] <- gradient[row] - beta_mean[col]
        gradient[col] <- gradient[col] - beta_mean[row]
        gradient[q + j] <- 1
        variance <- drop(
          crossprod(
            gradient,
            moment_sigma %*% gradient
          )
        ) / n_population
        mcse <- sqrt(
          max(variance, 0)
        )
        beta_sigma_mcse[row, col] <- mcse
        beta_sigma_mcse[col, row] <- mcse
      }
      beta_mu <- matrix(
        data = beta_mean,
        nrow = k,
        ncol = k,
        dimnames = dimnames(model$beta_mu)
      )
      list(
        empirical = TRUE,
        seed = condition_seed,
        n_population = n_population,
        beta_mu = beta_mu,
        beta_sigma = beta_sigma,
        beta_mu_mcse = setNames(
          sqrt(diag(beta_sigma) / n_population),
          beta_names
        ),
        beta_sigma_mcse = beta_sigma_mcse
      )
    }

    heterogeneity <- sort(
      unique(params$heterogeneity)
    )
    conditions <- vector(
      mode = "list",
      length = length(heterogeneity)
    )
    names(conditions) <- vapply(
      X = heterogeneity,
      FUN = condition_key,
      FUN.VALUE = character(1)
    )
    for (i in seq_along(heterogeneity)) {
      h <- heterogeneity[i]
      condition_seed <- seed + i - 1L
      cat(
        paste0(
          "  heterogeneity = ",
          condition_key(h),
          "\n"
        )
      )
      condition <- calibrate_beta(
        heterogeneity = h,
        condition_seed = condition_seed
      )
      ma_fixed <- c(
        model$mu_mu,
        c(condition$beta_mu)
      )
      ma_random <- rbind(
        cbind(
          model$mu_sigma,
          matrix(
            data = 0,
            nrow = k,
            ncol = q
          )
        ),
        cbind(
          matrix(
            data = 0,
            nrow = q,
            ncol = k
          ),
          condition$beta_sigma
        )
      )
      dimnames(ma_random) <- list(
        c(mu_names, beta_names),
        c(mu_names, beta_names)
      )
      parameter <- c(
        ma_fixed,
        vech(model$mu_sigma),
        vech(condition$beta_sigma)
      )
      names(parameter) <- c(
        paste0(
          "alpha[",
          seq_len(k + q),
          ",1]"
        ),
        tau_names(seq_len(k)),
        tau_names(k + seq_len(q))
      )
      condition$heterogeneity <- h
      condition$mu_mu <- model$mu_mu
      condition$mu_sigma <- model$mu_sigma
      condition$ma_fixed <- ma_fixed
      condition$ma_random <- ma_random
      condition$parameter <- parameter
      condition$nominal_beta_mu <- model$beta_mu
      condition$nominal_beta_sigma <-
        heterogeneity[i] * model$beta_sigma
      conditions[[i]] <- condition
    }
    population <- list(
      conditions = conditions,
      calibration = list(
        generator = "simStateSpace::SimBetaN",
        simStateSpace_version = as.character(
          utils::packageVersion("simStateSpace")
        ),
        seed = seed,
        n_population = n_population,
        batch_size = batch_size,
        margin = margin,
        generated = Sys.time()
      )
    )
    class(population) <- c(
      "manmetavar.population",
      class(population)
    )
    save(
      population,
      file = population_file,
      compress = "xz"
    )
  }
}
data_process_population()
rm(data_process_population)
