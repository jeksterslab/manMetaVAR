data_analysis_adid2010_data_ema <- function(overwrite = FALSE) {
  set.seed(42)

  ## Find project paths ------------------------------------------------------

  root <- rprojroot::is_rstudio_project

  output <- root$find_file(
    ".setup",
    "data-raw",
    "adid2010-data-ema.Rds"
  )

  metadata_output <- root$find_file(
    ".setup",
    "data-raw",
    "adid2010-data-ema-metadata.Rds"
  )

  mplus_output <- root$find_file(
    ".setup",
    "data-raw",
    "adid2010-data-ema-mplus.txt"
  )

  raw_data <- root$find_file(
    ".setup",
    "data-raw",
    "adid2010-ema.txt"
  )

  plot_dir <- root$find_file(
    ".setup",
    "data-raw",
    "plots"
  )

  write <- overwrite ||
    !file.exists(output) ||
    !file.exists(metadata_output)

  if (!write) {
    return(
      invisible(
        list(
          data = output,
          metadata = metadata_output
        )
      )
    )
  }

  if (!file.exists(raw_data)) {
    message(
      paste0(
        "Raw data file does not exist: ",
        raw_data
      ),
      call. = FALSE
    )
    write <- FALSE
  }

  cat("\ndata_analysis_adid2010_data_ema\n")

  if (!requireNamespace("dynTools", quietly = TRUE)) {
    stop(
      "Package `dynTools` is required for this preprocessing script.",
      call. = FALSE
    )
  }

  ## User settings -----------------------------------------------------------

  id <- "id"
  datetime <- "datetime"
  time <- "time"

  observed <- c(
    "allneg",
    "allpos"
  )

  tz <- "America/New_York"

  min_gap <- as.difftime(
    30,
    units = "mins"
  )

  time_units <- "hours"
  time_origin <- "by_id"

  detrend_degree <- 1L
  drop_detrend_skipped_ids <- TRUE

  regularize_delta_t <- 1
  regularize_grid <- "by_id"
  regularize_method <- "snap"

  ## Helper functions --------------------------------------------------------

  make_dir <- function(path) {
    if (!dir.exists(path)) {
      dir.create(
        path,
        recursive = TRUE
      )
    }

    invisible(path)
  }

  stage_count <- function(data, stage) {
    data.frame(
      stage = stage,
      n_ids = length(unique(data[[id]])),
      n_rows = nrow(data),
      stringsAsFactors = FALSE
    )
  }

  plot_by_id_pdf <- function(data, file) {
    ids <- unique(data[[id]])

    grDevices::pdf(
      file = file,
      width = 7,
      height = 5,
      onefile = TRUE
    )

    on.exit(
      grDevices::dev.off(),
      add = TRUE
    )

    for (i in seq_along(ids)) {
      for (j in seq_along(observed)) {
        dynTools::PlotByID(
          data = data,
          id = id,
          time = time,
          observed = observed[j],
          ids = ids[i],
          legend = FALSE,
          ask = FALSE
        )
      }
    }

    invisible(file)
  }

  count_observed_rows <- function(data) {
    sum(
      rowSums(
        !is.na(
          data[
            ,
            observed,
            drop = FALSE
          ]
        )
      ) > 0L
    )
  }

  make_dir(plot_dir)

  before_plot <- file.path(
    plot_dir,
    "adid2010-ema-by-id-before-detrending.pdf"
  )

  after_plot <- file.path(
    plot_dir,
    "adid2010-ema-by-id-after-detrending.pdf"
  )

  processing_counts <- list()

  ## 1. Read raw data --------------------------------------------------------

  data <- read.csv(
    file = raw_data
  )

  required_raw_variables <- c(
    id,
    "sdate",
    "stime",
    observed
  )

  missing_raw_variables <- setdiff(
    required_raw_variables,
    names(data)
  )

  if (length(missing_raw_variables) > 0L) {
    stop(
      paste0(
        "The following required variables are missing from the raw data: ",
        paste(
          missing_raw_variables,
          collapse = ", "
        ),
        "."
      ),
      call. = FALSE
    )
  }

  processing_counts[[length(processing_counts) + 1L]] <- stage_count(
    data = data,
    stage = "raw"
  )

  ## 2. Replace study-specific missing-value codes ---------------------------

  data <- dynTools::ReplaceMissingCode(
    data = data,
    values = c(-999, "-999"),
    columns = names(data)
  )

  ## 3. Construct date-time variable -----------------------------------------
  ##
  ## `invalid = "error"` gives an immediate, specific error for malformed clock
  ## times. Invalid or missing dates produce `NA` and are caught by the
  ## structural check in the next step.

  data[[datetime]] <- dynTools::MakeClockTime(
    date = data$sdate,
    time = data$stime,
    tz = tz,
    date_formats = c(
      "%m/%d/%y",
      "%m/%d/%Y",
      "%Y-%m-%d"
    ),
    invalid = "error"
  )

  ## 4. Check basic structure before time cleaning ---------------------------

  dynTools::CheckDynData(
    data = data,
    id = id,
    time = datetime,
    observed = observed,
    require_unique = FALSE,
    require_numeric_time = FALSE,
    require_numeric_observed = TRUE,
    min_rows = 1L
  )

  ## 5. Resolve exact duplicate ID-time rows ---------------------------------

  data <- dynTools::ResolveDuplicateIDTime(
    data = data,
    id = id,
    time = datetime,
    observed = observed,
    method = "max_complete"
  )

  processing_counts[[length(processing_counts) + 1L]] <- stage_count(
    data = data,
    stage = "duplicates_resolved"
  )

  ## 6. Resolve observations that are too close in time -----------------------
  ##
  ## Consecutive observations separated by less than `min_gap` are grouped into
  ## a close-time cluster. The most complete row is retained from each cluster.

  data <- dynTools::ResolveCloseTimeByID(
    data = data,
    id = id,
    time = datetime,
    observed = observed,
    min_gap = min_gap,
    method = "max_complete"
  )

  processing_counts[[length(processing_counts) + 1L]] <- stage_count(
    data = data,
    stage = "close_times_resolved"
  )

  ## 7. Retain only variables needed for the empirical example ---------------
  ##
  ## This makes later missingness rules explicit: after this point the data
  ## contain only ID, date-time, and the observed variables.

  data <- data[
    ,
    c(
      id,
      datetime,
      observed
    ),
    drop = FALSE
  ]

  ## 8. Remove rows with no observed data ------------------------------------

  data <- dynTools::DeleteObservedAllNA(
    data = data,
    id = id,
    time = datetime,
    observed = observed
  )

  processing_counts[[length(processing_counts) + 1L]] <- stage_count(
    data = data,
    stage = "all_observed_missing_rows_removed"
  )

  ## 9. Enforce a complete initial observation within ID ---------------------
  ##
  ## Because the data now contain only ID, date-time, and `observed`, the
  ## complete-case rule used by `DeleteInitialNA()` is equivalent to requiring
  ## the first retained row to be complete on all observed variables.

  data <- dynTools::DeleteInitialNA(
    data = data,
    id = id,
    time = datetime,
    observed = observed
  )

  processing_counts[[length(processing_counts) + 1L]] <- stage_count(
    data = data,
    stage = "initial_incomplete_rows_removed"
  )

  if (nrow(data) == 0L) {
    stop(
      "No rows remain after applying the initial-observation rule.",
      call. = FALSE
    )
  }

  ## 10. Create elapsed time in hours ----------------------------------------
  ##
  ## Each ID starts at time 0. No additional CT time rescaling is applied, so
  ## one unit of `time` is one hour.

  data <- dynTools::ElapsedTimeByID(
    data = data,
    id = id,
    time = datetime,
    output = time,
    units = time_units,
    origin = time_origin
  )

  ## 11. Plot cleaned data before detrending ---------------------------------

  plot_by_id_pdf(
    data = data,
    file = before_plot
  )

  ## 12. Detrend observed variables within ID --------------------------------
  ##
  ## When an ID-variable combination cannot be detrended, the whole ID is
  ## dropped. This avoids mixing detrended and undetrended series in one model.

  data <- dynTools::DetrendByID(
    data = data,
    id = id,
    time = time,
    observed = observed,
    covariates = NULL,
    degree = detrend_degree,
    replace = TRUE,
    keep_mean = TRUE,
    warn_skipped = TRUE,
    drop_skipped_ids = drop_detrend_skipped_ids
  )

  detrend_skipped <- attr(
    data,
    "detrend_skipped"
  )

  processing_counts[[length(processing_counts) + 1L]] <- stage_count(
    data = data,
    stage = "detrended"
  )

  if (nrow(data) == 0L) {
    stop(
      "No IDs remain after detrending diagnostics were applied.",
      call. = FALSE
    )
  }

  ## No within-ID scaling or standardization is applied.

  ## 13. Plot data after detrending ------------------------------------------

  plot_by_id_pdf(
    data = data,
    file = after_plot
  )

  ## 14. Snap observations to an hourly ID-specific grid ---------------------
  ##
  ## With elapsed time measured in hours, `delta_t = 1` and `method = "snap"`
  ## round each empirical observation to the nearest elapsed hour relative to
  ## that ID's first retained observation. Empty hourly grid rows are inserted
  ## with missing observed values. If multiple observations snap to the same
  ## hour, `RegularizeTimeByID()` keeps the closest row; ties are resolved by
  ## completeness and then original order.

  data_irregular <- data
  n_observed_rows_before_regularization <- count_observed_rows(data_irregular)

  data <- dynTools::RegularizeTimeByID(
    data = data_irregular,
    id = id,
    time = time,
    observed = observed,
    covariates = NULL,
    delta_t = regularize_delta_t,
    grid = regularize_grid,
    method = regularize_method
  )

  n_observed_rows_after_regularization <- count_observed_rows(data)

  if (
    n_observed_rows_after_regularization >
      n_observed_rows_before_regularization
  ) {
    stop(
      paste(
        "Hourly regularization increased the number of rows containing",
        "observed data."
      ),
      call. = FALSE
    )
  }

  n_observed_rows_collapsed <-
    n_observed_rows_before_regularization -
    n_observed_rows_after_regularization

  if (n_observed_rows_collapsed > 0L) {
    warning(
      paste0(
        n_observed_rows_collapsed,
        " observed row(s) were discarded because multiple observations ",
        "snapped to the same ID-hour."
      ),
      call. = FALSE
    )
  }

  regularization_summary <- data.frame(
    n_ids = length(unique(data[[id]])),
    n_rows_irregular = nrow(data_irregular),
    n_rows_hourly = nrow(data),
    n_rows_added_net = nrow(data) - nrow(data_irregular),
    n_empty_hourly_rows = nrow(data) - n_observed_rows_after_regularization,
    n_observed_rows_before = n_observed_rows_before_regularization,
    n_observed_rows_after = n_observed_rows_after_regularization,
    n_observed_rows_collapsed = n_observed_rows_collapsed,
    delta_t = regularize_delta_t,
    time_units = time_units,
    grid = regularize_grid,
    method = regularize_method,
    stringsAsFactors = FALSE
  )

  processing_counts[[length(processing_counts) + 1L]] <- stage_count(
    data = data,
    stage = "snapped_to_hourly_grid"
  )

  ## 15. Check final data structure ------------------------------------------

  dynTools::CheckDynData(
    data = data,
    id = id,
    time = time,
    observed = observed,
    require_unique = TRUE,
    require_numeric_time = TRUE,
    require_numeric_observed = TRUE,
    min_rows = 2L
  )

  first_row <- !duplicated(data[[id]])

  if (
    any(
      !stats::complete.cases(
        data[
          first_row,
          observed,
          drop = FALSE
        ]
      )
    )
  ) {
    stop(
      paste(
        "At least one ID does not have a complete observed vector at its first",
        "final time point."
      ),
      call. = FALSE
    )
  }

  processing_summary <- do.call(
    what = rbind,
    args = processing_counts
  )

  rownames(processing_summary) <- NULL

  ## 16. Save final modeling data and metadata -------------------------------

  preprocessing_settings <- list(
    id = id,
    datetime = datetime,
    time = time,
    observed = observed,
    timezone = tz,
    missing_codes = c(-999, "-999"),
    duplicate_method = "max_complete",
    close_time_min_gap = min_gap,
    close_time_method = "max_complete",
    time_units = time_units,
    time_origin = time_origin,
    time_scaled = FALSE,
    detrend_degree = detrend_degree,
    detrend_keep_mean = FALSE,
    drop_detrend_skipped_ids = drop_detrend_skipped_ids,
    scale_within_id = FALSE,
    regularize_delta_t = regularize_delta_t,
    regularize_grid = regularize_grid,
    regularize_method = regularize_method
  )

  data <- data[
    !(
      data$id %in% c(
        1009, 1051, 1074, 1126, 1127, 1137, 1143, 1173, 1184, 1196,
        1203, 1229, 1257, 1273, 1278, 1285, 1288, 1302, 1308, 1328
      )
    ),
  ]

  colnames(data) <- c(
    "id",
    "time",
    "na",
    "pa"
  )

  saveRDS(
    object = data,
    file = output
  )

  data_mplus <- data.frame(
    ID = data$id,
    TIME = data$time,
    Y1 = data$na,
    Y2 = data$pa
  )

  write.table(
    x = data_mplus,
    file = mplus_output,
    sep = " ",
    na = "-999",
    quote = FALSE,
    row.names = FALSE,
    col.names = FALSE
  )

  saveRDS(
    object = list(
      preprocessing_settings = preprocessing_settings,
      processing_summary = processing_summary,
      detrend_skipped = detrend_skipped,
      regularization_summary = regularization_summary,
      plot_files = c(
        before = before_plot,
        after = after_plot
      ),
      dynTools_version = as.character(
        utils::packageVersion("dynTools")
      )
    ),
    file = metadata_output
  )

  invisible(
    list(
      data = output,
      metadata = metadata_output,
      plots = c(
        before = before_plot,
        after = after_plot
      )
    )
  )
}

data_analysis_adid2010_data_ema()
rm(data_analysis_adid2010_data_ema)
