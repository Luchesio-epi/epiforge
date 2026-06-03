#' @keywords internal
"_PACKAGE"

#' Check that required columns exist in a dataframe
#'
#' @param data A dataframe.
#' @param cols Character vector of required column names.
#' @return Invisible TRUE if all columns present, otherwise aborts.
#' @keywords internal
check_cols <- function(data, cols) {
  missing <- setdiff(cols, names(data))
  if (length(missing) > 0) {
    cli::cli_abort(c(
      "Missing required columns:",
      "x" = "{.val {missing}}"
    ))
  }
  invisible(TRUE)
}

#' Format a date range as a readable string
#'
#' @param dates Date vector.
#' @return Character string like "2024-01-01 to 2024-03-31".
#' @keywords internal
format_date_range <- function(dates) {
  dates <- dates[!is.na(dates)]
  glue::glue("{min(dates)} to {max(dates)}")
}
