.ParseTauSqr <- function(x) {
  pattern <- "^tau_sqr\\[([0-9]+),([0-9]+)\\]$"
  matches <- regexec(
    pattern = pattern,
    text = x
  )
  pieces <- regmatches(
    x = x,
    m = matches
  )
  valid <- lengths(pieces) == 3L
  if (!all(valid)) {
    stop(
      paste0(
        "Could not parse the following tau_sqr parameter names: ",
        paste(x[!valid], collapse = ", "),
        "."
      ),
      call. = FALSE
    )
  }
  data.frame(
    parnames = x,
    row = as.integer(
      vapply(
        X = pieces,
        FUN = `[`,
        FUN.VALUE = character(1),
        2L
      )
    ),
    col = as.integer(
      vapply(
        X = pieces,
        FUN = `[`,
        FUN.VALUE = character(1),
        3L
      )
    ),
    stringsAsFactors = FALSE
  )
}
