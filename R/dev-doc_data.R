#' Document Datasets
#'
#' Creates skeleton to document datasets via `roxygen2`.
#'
#' @param obj object to document
#' @param title Title
#' @param description Description
#' @param write_to_file Logical
#' @param ... N/A
#'
#' @return silently returns the doc_string
#' @export
#'
#' @example examples/doc_data.R
#' @importFrom usethis use_r
doc_data <- function(obj,
                     title = deparse(substitute(obj)),
                     description = "DATASET_DESCRIPTION",
                     write_to_file = TRUE,
                     ...) {

  vartype <- vapply(obj, typeof, FUN.VALUE = character(1))

  items <- paste0("#'   \\item{\\code{",
                  names(vartype),
                  "}}{",
                  vartype,
                  ". DESCRIPTION.}", collapse = "\n")

  out <- paste0(
    "\n#' ",
    title,
    "\n#'\n#' ",
    description,
    "\n#'\n#' @format A `data.frame` with ",
    nrow(obj),
    " rows and ",
    length(vartype),
    " variables:\n#' \\describe{\n",
    items,
    "\n#' }\n\"",
    title,
    "\""
  )

  if (!write_to_file) return(out)
  write(out, file = "R/data.R", append = TRUE, sep = "\n")
  usethis::use_r("data.R")

  invisible(out)

}
