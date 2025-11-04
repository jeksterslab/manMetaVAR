.RandomFile <- function(prefix = NULL) {
  if (is.null(prefix)) {
    prefix <- "fn"
  }
  paste0(
    prefix,
    "_",
    paste(
      sample(
        c(letters, LETTERS, 0:9),
        size = 20,
        replace = TRUE
      ),
      collapse = ""
    )
  )
}
