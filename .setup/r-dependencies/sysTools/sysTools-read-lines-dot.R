.ReadLines <- function(con,
                       ...) {
  if (file.exists(con)) {
    out <- tryCatch(
      readLines(
        con = con,
        ...
      ),
      error = function(e) {
        message(
          sprintf(
            "Error reading file: %s\n%s",
            con,
            e$message
          )
        )
        NA
      },
      warning = function(w) {
        message(
          sprintf(
            "Warning while reading file: %s\n%s",
            con,
            w$message
          )
        )
        NA
      }
    )
  } else {
    message(
      sprintf(
        "File does not exist: %s",
        con
      )
    )
    out <- NA
  }
  out
}
