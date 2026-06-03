#' Standardize and clean epidemiological data
#'
#' @description
#' Validates and standardizes column names, date formats, and geographic levels
#' in imported surveillance data. This is a required step before computing indicators.
#'
#' @param data A tibble from [epi_import()].
#' @param date_col Character. Name of the date column. Default: `"date"`.
#' @param cases_col Character. Name of the cases column. Default: `"cases"`.
#' @param disease_col Character. Name of the disease column. Default: `"disease"`.
#' @param geo_col Character. Name of the geographic unit column. Default: `"location"`.
#' @param date_format Character. Expected date format string (e.g. `"%Y-%m-%d"`). Default: `"auto"`.
#'
#' @return A standardized tibble with columns: date, disease, location, cases.
#' @export
#'
#' @examples
#' \dontrun{
#' raw <- epi_import("data/surveillance.csv")
#' clean <- epi_clean(raw, date_col = "semaine", cases_col = "nb_cas",
#'                    disease_col = "maladie", geo_col = "zone")
#' }
epi_clean <- function(data,
                      date_col    = "date",
                      cases_col   = "cases",
                      disease_col = "disease",
                      geo_col     = "location",
                      date_format = "auto") {

  required_cols <- c(date_col, cases_col, disease_col, geo_col)
  missing_cols  <- setdiff(required_cols, names(data))

  if (length(missing_cols) > 0) {
    cli::cli_abort(c(
      "Missing required columns in data:",
      "x" = "{.val {missing_cols}}"
    ))
  }

  # Renommage vers noms standards
  data <- data |>
    dplyr::rename(
      date     = !!date_col,
      cases    = !!cases_col,
      disease  = !!disease_col,
      location = !!geo_col
    )

  # Conversion de la date
  if (!inherits(data$date, "Date")) {
    data$date <- lubridate::parse_date_time(data$date,
                   orders = c("ymd", "dmy", "mdy", "Ymd"),
                   quiet = TRUE) |> as.Date()
  }

  if (any(is.na(data$date))) {
    n_na <- sum(is.na(data$date))
    cli::cli_warn("{n_na} row(s) have unparseable dates and will be removed.")
    data <- data |> dplyr::filter(!is.na(date))
  }

  # Conversion cases en numérique
  data$cases <- suppressWarnings(as.numeric(data$cases))

  if (any(is.na(data$cases))) {
    n_na <- sum(is.na(data$cases))
    cli::cli_warn("{n_na} row(s) have non-numeric case counts. Setting to NA.")
  }

  # Sélection et ordre des colonnes standards
  data <- data |>
    dplyr::select(date, disease, location, cases, dplyr::everything()) |>
    dplyr::arrange(date, disease, location)

  cli::cli_alert_success("Data cleaned: {nrow(data)} rows ready for analysis.")
  return(data)
}
