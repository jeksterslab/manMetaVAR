.WhichMplus <- function() {
  os <- .WhichOS()
  if (os == "windows") {
    bin <- .FindMplusBin(
      command = "where Mplus",
      fallback = "C:\\Program Files\\Mplus\\Mplus.exe"
    ) %||% .FindMplusBin(
      command = "where Mpdemo8",
      fallback = "C:\\Program Files\\Mplus Demo\\Mpdemo8.exe"
    )
    if (is.null(bin)) {
      stop("Mplus or Mplus Demo not found.")
    }
    ifelse(
      test = basename(bin) %in% c("Mplus.exe", "Mpdemo8.exe"),
      yes = basename(bin),
      no = bin
    )
  } else if (os == "osx") {
    bin <- .FindMplusBin(
      command = "which mplus",
      fallback = "/Applications/Mplus/mplus"
    ) %||% .FindMplusBin(
      command = "which mpdemo",
      fallback = "/Applications/MplusDemo/mpdemo"
    )
    if (is.null(bin)) {
      stop(
        "Mplus or Mplus Demo not found."
      )
    }
    ifelse(
      test = basename(bin) %in% c("mplus", "mpdemo"),
      yes = basename(bin),
      no = bin
    )
  } else if (os == "linux") {
    bin <- .FindMplusBin(
      command = "which mplus"
    )
    if (is.null(bin) && dir.exists("/opt/mplus")) {
      test <- file.path(
        list.dirs(
          "/opt/mplus",
          recursive = FALSE
        )[1],
        "mplus"
      )
      if (file.exists(test)) {
        bin <- test
      }
    }
    if (is.null(bin)) {
      bin <- .FindMplusBin(
        command = "which mpdemo"
      )
    }
    if (is.null(bin)) {
      stop(
        "Mplus or Mplus Demo not found."
      )
    }
    ifelse(
      test = basename(bin) %in% c("mplus", "mpdemo"),
      yes = basename(bin),
      no = bin
    )
  } else {
    stop(
      "Unrecognized OS type. Specify Mplus command."
    )
  }
  bin
}
