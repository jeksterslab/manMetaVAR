.FindMplusBin <- function(command,
                          fallback = NULL) {
  bin <- suppressWarnings(
    system(
      command,
      intern = TRUE,
      ignore.stderr = TRUE
    )
  )
  if (length(bin) > 0 && file.exists(bin)) {
    out <- bin
  } else if (!is.null(fallback) && file.exists(fallback)) {
    out <- fallback
  } else {
    out <- NULL
  }
  out
}
