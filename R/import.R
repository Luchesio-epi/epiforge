#' Import epidemiological data from CSV or Excel
#'
#' @description
#' Reads routine health surveillance data exported from DHIS2 or any
#' compatible system. Accepts CSV (.csv) or Excel (.xlsx, .xls) files.
#'
#' @param path Character. Path to the data file.
#' @param format Character. One of `"csv"`, `"xlsx"`, or `"auto"` (default).
#'   If `"auto"`, the format is detected from the file extension.
#' @param sheet Integer or character. Sheet name or index for Excel files. Default: 1.
#' @param skip Integer. Number of rows to skip before reading. Default: 0.
#'
#' @return A tibble with the raw imported data.
#' @export
#'
#' @examples
#' \dontrun{
#' df <- epi_import("data/surveillance_week42.csv")
#' df <- epi_import("data/dhis2_export.xlsx", sheet = 1)
#' }
epi_import <- function(path, format = "auto", sheet = 1, skip = 0) {

  # Vérification existence fichier
  if (!file.exists(path)) {
    cli::cli_abort("File not found: {.path {path}}")
  }

  # Détection automatique du format
  if (format == "auto") {
    ext <- tolower(tools::file_ext(path))
    format <- dplyr::case_when(
      ext == "csv"  ~ "csv",
      ext %in% c("xlsx", "xls") ~ "xlsx",
      TRUE ~ NA_character_
    )
    if (is.na(format)) {
      cli::cli_abort("Cannot detect format from extension: {.val {ext}}. Use format = 'csv' or 'xlsx'.")
    }
  }

  # Import selon format
  data <- switch(format,
    "csv"  = readr::read_csv(path, skip = skip, show_col_types = FALSE),
    "xlsx" = readxl::read_excel(path, sheet = sheet, skip = skip),
    cli::cli_abort("Unknown format: {.val {format}}")
  )

  cli::cli_alert_success("Imported {nrow(data)} rows and {ncol(data)} columns from {.path {path}}")
  return(data)
}
