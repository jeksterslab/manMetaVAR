.ParseMplusPosteriorDraws <- function(posterior,
                                      expected_columns) {
  if (
    length(expected_columns) != 1L ||
      !is.numeric(expected_columns) ||
      !is.finite(expected_columns) ||
      expected_columns < 1 ||
      expected_columns != floor(expected_columns)
  ) {
    stop(
      "`expected_columns` should be a single positive integer.",
      call. = FALSE
    )
  }
  expected_columns <- as.integer(expected_columns)
  posterior <- gsub(
    pattern = "\"",
    replacement = "",
    x = posterior,
    fixed = TRUE
  )
  tokens <- scan(
    text = paste(
      posterior,
      collapse = "\n"
    ),
    what = character(),
    quote = "",
    comment.char = "",
    quiet = TRUE
  )
  if (length(tokens) == 0L) {
    stop(
      "No posterior draws were found.",
      call. = FALSE
    )
  }
  tokens <- gsub(
    pattern = "([0-9.])[dD]([+-]?[0-9]+)$",
    replacement = "\\1E\\2",
    x = tokens
  )
  values <- suppressWarnings(
    as.numeric(tokens)
  )
  if (anyNA(values)) {
    invalid <- unique(tokens[is.na(values)])
    stop(
      paste0(
        "The saved posterior draws contain nonnumeric values: ",
        paste(
          utils::head(invalid, 5L),
          collapse = ", "
        ),
        "."
      ),
      call. = FALSE
    )
  }
  remainder <- length(values) %% expected_columns
  if (remainder != 0L) {
    stop(
      paste0(
        "The saved posterior token stream contains ",
        length(values),
        " values, which cannot be divided into records of ",
        expected_columns,
        " columns."
      ),
      call. = FALSE
    )
  }
  out <- matrix(
    data = values,
    ncol = expected_columns,
    byrow = TRUE
  )
  storage.mode(out) <- "double"
  out
}
