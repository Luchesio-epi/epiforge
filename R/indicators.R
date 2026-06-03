#' Compute core epidemiological indicators
#'
#' @description
#' Calculates standard surveillance indicators from clean data:
#' case counts, incidence rate, attack rate, case fatality rate,
#' and epidemic thresholds.
#'
#' @param data A tibble from [epi_clean()].
#' @param population Numeric. Total population for rate calculations.
#'   If NULL, rates are not computed.
#' @param deaths_col Character. Name of the deaths column if present. Default: NULL.
#' @param period Character. One of `"weekly"` or `"monthly"`.
#' @param geo_level Character. One of `"district"`, `"region"`, or `"national"`.
#'
#' @return A tibble of computed indicators by period, disease, and location.
#' @export
epi_indicators <- function(data,
                           population = NULL,
                           deaths_col = NULL,
                           period     = "weekly",
                           geo_level  = "district") {

  # Validation période
  period    <- match.arg(period,    c("weekly", "monthly"))
  geo_level <- match.arg(geo_level, c("district", "region", "national"))

  # Ajout colonne période
  data <- data |>
    dplyr::mutate(
      period_label = dplyr::case_when(
        period == "weekly"  ~ paste0("S", lubridate::isoweek(date), "-", lubridate::year(date)),
        period == "monthly" ~ format(date, "%Y-%m")
      )
    )

  # Agrégation de base
  result <- data |>
    dplyr::group_by(period_label, disease, location) |>
    dplyr::summarise(
      total_cases = sum(cases, na.rm = TRUE),
      .groups = "drop"
    )

  # Taux d'incidence si population fournie
  if (!is.null(population)) {
    result <- result |>
      dplyr::mutate(
        incidence_per_100k = round((total_cases / population) * 100000, 2)
      )
  }

  # Létalité si colonne décès fournie
  if (!is.null(deaths_col) && deaths_col %in% names(data)) {
    deaths_summary <- data |>
      dplyr::rename(deaths = !!deaths_col) |>
      dplyr::group_by(period_label, disease, location) |>
      dplyr::summarise(total_deaths = sum(deaths, na.rm = TRUE), .groups = "drop")

    result <- dplyr::left_join(result, deaths_summary,
                               by = c("period_label", "disease", "location")) |>
      dplyr::mutate(
        cfr_pct = dplyr::if_else(
          total_cases > 0,
          round((total_deaths / total_cases) * 100, 2),
          NA_real_
        )
      )
  }

  cli::cli_alert_success("Indicators computed for {dplyr::n_distinct(result$disease)} disease(s), {dplyr::n_distinct(result$location)} location(s).")
  return(result)
}
