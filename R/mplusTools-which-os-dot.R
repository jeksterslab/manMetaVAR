.WhichOS <- function() {
  sysinfo <- Sys.info()
  os <- if (!is.null(sysinfo)) {
    sysinfo["sysname"]
  } else {
    .Platform$OS.type
  }
  os <- tolower(os)
  if (
    grepl(
      pattern = "darwin",
      x = R.version$os,
      ignore.case = TRUE
    ) || os == "darwin"
  ) {
    os <- "osx"
  } else if (
    grepl(
      pattern = "linux-gnu",
      x = R.version$os,
      ignore.case = TRUE
    ) || os == "unix"
  ) {
    os <- "linux"
  } else if (os == "windows") {
    os <- "windows"
  } else {
    stop(
      "Unrecognized OS type. Specify Mplus command."
    )
  }
  os
}
