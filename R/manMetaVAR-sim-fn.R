#' Simulation File Name
#'
#' @return Returns a character string file name with the `output_folder`
#' in the OS-specific format.
#'
#' @inheritParams Template
#'
#' @export
#' @keywords manMetaVAR simulation
SimFN <- function(output_type,
                  output_folder,
                  suffix) {
  file.path(
    output_folder,
    paste0(
      SimProj(),
      "-",
      output_type,
      "-",
      suffix
    )
  )
}
