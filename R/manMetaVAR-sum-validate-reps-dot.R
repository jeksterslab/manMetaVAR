.SumValidateReps <- function(reps) {
  if (
    length(reps) != 1L ||
      !is.numeric(reps) ||
      !is.finite(reps) ||
      reps < 2 ||
      reps != floor(reps)
  ) {
    stop(
      "`reps` should be a single integer of at least two.",
      call. = FALSE
    )
  }
  as.integer(reps)
}
