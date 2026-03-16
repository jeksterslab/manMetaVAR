data_process_adid2010_data_ema <- function(overwrite = FALSE) {
  set.seed(42)
  # find root directory
  root <- rprojroot::is_rstudio_project
  output <- root$find_file(
    ".setup",
    "data-raw",
    "adid2010-data-ema.Rds"
  )
  if (!file.exists(output)) {
    write <- TRUE
  } else {
    if (overwrite) {
      write <- TRUE
    } else {
      write <- FALSE
    }
  }
  if (write) {
    cat("\ndata_process_adid2010_data_ema\n")
    Sys.setenv(
      OMP_NUM_THREADS = "1",
      MKL_NUM_THREADS = "1",
      OPENBLAS_NUM_THREADS = "1"
    )
    data <- read.csv(
      file = root$find_file(
        ".setup",
        "data-raw",
        "adid2010-ema.txt"
      )
    )
    # subset the data
    data <- data[
      ,
      c("id", "sdate", "stime", "allneg", "allpos"),
      drop = FALSE
    ]
    # replace -999 with NA
    is_num <- vapply(
      X = data,
      FUN = is.numeric,
      FUN.VALUE = logical(1)
    )
    data[is_num] <- lapply(
      X = data[is_num],
      FUN = function(x) {
        x[x == -999] <- NA
        x
      }
    )
    is_chr <- vapply(
      X = data,
      FUN = is.character,
      FUN.VALUE = logical(1)
    )
    data[is_chr] <- lapply(
      X = data[is_chr],
      FUN = function(x) {
        x[x == "-999"] <- NA
        x
      }
    )
    # create clock time
    # date: "10/29/08" (mm/dd/yy)   time: 6.54 (decimal hours since midnight)
    makeClockTime <- function(date, time, tz = "America/New_York") {
      date_chr <- trimws(as.character(date))
      d <- suppressWarnings(
        as.Date(
          date_chr,
          tryFormats = c("%m/%d/%y", "%m/%d/%Y", "%Y-%m-%d")
        )
      )
      t <- suppressWarnings(as.numeric(time))
      out <- as.POSIXct(rep(NA_character_, length(d)), tz = tz)
      ok <- !is.na(d) & !is.na(t)
      if (any(ok)) {
        secs <- round(t[ok] * 3600) # decimal hours -> seconds
        # Build a naive timestamp string, then "attach" tz without shifting it
        base <- format(d[ok], "%Y-%m-%d")
        h <- secs %/% 3600
        m <- (secs %% 3600) %/% 60
        s <- secs %% 60
        stamp <- sprintf("%s %02d:%02d:%02d", base, h, m, s)
        out[ok] <- as.POSIXct(stamp, tz = tz, format = "%Y-%m-%d %H:%M:%S")
      }
      out
    }
    data$clock_time <- makeClockTime(data$sdate, data$stime)
    # create discrete time rounded to the nearest hour
    ct_num <- as.numeric(data$clock_time)
    data$hour_time <- as.POSIXct(
      round(ct_num / 3600) * 3600,
      origin = "1970-01-01",
      tz = "America/New_York"
    )
    # insert missing hours within each id
    data <- data[order(data$id, data$hour_time, data$clock_time), ]
    key <- paste(data$id, data$hour_time)
    data <- data[!duplicated(key), ]
    # insert missing hours within each id
    data <- data[order(data$id, data$hour_time, data$clock_time), ]
    key <- paste(data$id, data$hour_time)
    data <- data[!duplicated(key), ]
    ids <- unique(data$id)
    completed_list <- vector("list", length(ids))
    names(completed_list) <- ids
    for (i in seq_along(ids)) {
      this_id <- ids[i]
      dsub <- data[data$id == this_id, , drop = FALSE]
      if (all(is.na(dsub$hour_time))) {
        completed_list[[i]] <- dsub
        next
      }
      tmin <- min(dsub$hour_time, na.rm = TRUE)
      tmax <- max(dsub$hour_time, na.rm = TRUE)
      completed_list[[i]] <- data.frame(
        id = this_id,
        hour_time = seq(from = tmin, to = tmax, by = "hour"),
        stringsAsFactors = FALSE
      )
    }
    grid_all <- do.call(rbind, completed_list)
    data <- merge(
      grid_all,
      data,
      by = c("id", "hour_time"),
      all.x = TRUE,
      sort = FALSE
    )
    # make sure that the first measurement is no missing
    data <- lapply(
      X = unique(data[, "id"]),
      FUN = function(id) {
        i <- data[which(data[, "id"] == id), , drop = FALSE]
        test <- any(
          is.na(
            i[1, c("allneg", "allpos")]
          )
        )
        while (test) {
          i <- i[-1, ]
          test <- any(
            is.na(
              i[1, c("allneg", "allpos")]
            )
          )
        }
        i <- i[order(i[, "hour_time"]), ]
        idx <- seq_len(dim(i)[1]) - 1
        cbind(
          i,
          idx
        )
      }
    )
    # linear detrend
    DetrendSeries <- function(y, x, keep_mean = TRUE) {
      ok <- !is.na(y) & !is.na(x)
      if (sum(ok) < 2L || length(unique(x[ok])) < 2L) {
        return(y)
      }
      fit <- stats::lm(y ~ x, subset = ok)
      pred <- stats::predict(fit, newdata = data.frame(x = x))
      res <- y - pred
      if (keep_mean) res + mean(y[ok]) else res
    }
    data <- lapply(
      X = data,
      FUN = function(i) {
        na_dt <- DetrendSeries(
          y = i[, "allneg"],
          x = i[, "idx"]
        )
        pa_dt <- DetrendSeries(
          y = i[, "allpos"],
          x = i[, "idx"]
        )
        i <- cbind(
          i,
          na_dt = na_dt,
          pa_dt = pa_dt
        )
        i <- i[, c("id", "idx", "na_dt", "pa_dt")]
        rownames(i) <- NULL
        colnames(i) <- c(
          "id",
          "time",
          "na",
          "pa"
        )
        i
      }
    )
    # data frame
    data <- as.data.frame(
      do.call(
        what = "rbind",
        args = data
      )
    )
    # save
    saveRDS(
      object = data,
      file = output
    )
  }
}
data_process_adid2010_data_ema()
rm(data_process_adid2010_data_ema)
