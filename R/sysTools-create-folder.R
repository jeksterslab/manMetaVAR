.CreateFolder <- function(x,
                          prefix = NULL) {
  if (!dir.exists(x)) {
    stop(
      paste(
        x,
        "does not exist."
      )
    )
  }
  out <- file.path(
    x,
    .RandomFolder(prefix = prefix)
  )
  dir.create(
    path = out,
    showWarnings = FALSE
  )
  out
}
