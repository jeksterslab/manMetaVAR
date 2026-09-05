.TaskParameters <- function(taskid,
                            params_object = params) {
  if (
    length(taskid) != 1L ||
      !is.numeric(taskid) ||
      !is.finite(taskid) ||
      taskid < 1 ||
      taskid != floor(taskid)
  ) {
    stop(
      "`taskid` should be a single positive integer.",
      call. = FALSE
    )
  }
  required <- c(
    "taskid",
    "n",
    "time",
    "heterogeneity"
  )
  missing <- setdiff(
    required,
    names(params_object)
  )
  if (length(missing) > 0L) {
    stop(
      paste0(
        "The parameter table is missing: ",
        paste(missing, collapse = ", "),
        "."
      ),
      call. = FALSE
    )
  }
  location <- which(
    params_object$taskid == as.integer(taskid)
  )
  if (length(location) != 1L) {
    stop(
      paste0(
        "Could not identify a unique parameter row for taskid = ",
        as.integer(taskid),
        "."
      ),
      call. = FALSE
    )
  }
  params_object[
    location, ,
    drop = FALSE
  ]
}
