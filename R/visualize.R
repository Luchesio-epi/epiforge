#' Plot epidemic curve
#'
#' @description
#' Generates a ggplot2 epidemic curve (epi curve) from clean surveillance data.
#'
#' @param data A tibble from [epi_clean()].
#' @param disease Character. Name of the disease to plot. If NULL, all diseases plotted.
#' @param period Character. One of `"weekly"` or `"monthly"`.
#' @param fill_color Character. Bar fill color. Default: `"#2166ac"`.
#'
#' @return A ggplot2 object.
#' @export
epi_curve <- function(data,
                      disease    = NULL,
                      period     = "weekly",
                      fill_color = "#2166ac") {

  period <- match.arg(period, c("weekly", "monthly"))

  if (!is.null(disease)) {
    data <- data |> dplyr::filter(disease == !!disease)
    if (nrow(data) == 0) cli::cli_abort("No data found for disease: {.val {disease}}")
  }

  # Agrégation par période
  date_floor <- if (period == "weekly") "week" else "month"

  plot_data <- data |>
    dplyr::mutate(period_date = lubridate::floor_date(date, unit = date_floor)) |>
    dplyr::group_by(period_date, disease) |>
    dplyr::summarise(cases = sum(cases, na.rm = TRUE), .groups = "drop")

  p <- ggplot2::ggplot(plot_data, ggplot2::aes(x = period_date, y = cases)) +
    ggplot2::geom_col(fill = fill_color, color = "white", width = if (period == "weekly") 6 else 25) +
    ggplot2::facet_wrap(~ disease, scales = "free_y") +
    ggplot2::scale_x_date(
      date_labels = if (period == "weekly") "W%V\n%Y" else "%b\n%Y",
      date_breaks = if (period == "weekly") "4 weeks" else "1 month"
    ) +
    ggplot2::labs(
      title = "Epidemic Curve",
      x     = if (period == "weekly") "Epidemiological Week" else "Month",
      y     = "Number of Cases"
    ) +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(
      plot.title   = ggplot2::element_text(face = "bold"),
      strip.text   = ggplot2::element_text(face = "bold"),
      axis.text.x  = ggplot2::element_text(angle = 45, hjust = 1)
    )

  return(p)
}
