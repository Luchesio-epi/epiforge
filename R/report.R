#' Generate an epidemiological surveillance report
#' @param data A tibble from [epi_clean()].
#' @param indicators A tibble from [epi_indicators()].
#' @param period Character. One of `"weekly"` or `"monthly"`.
#' @param geo_level Character. One of `"district"`, `"region"`, or `"national"`.
#' @param output_format Character. One of `"docx"` or `"pdf"`. Default: `"docx"`.
#' @param output_file Character. Path for the output file.
#' @param title Character. Report title.
#' @param location_name Character. Name of the geographic area.
#' @param logo_path Character. Optional path to a logo image file.
#' @return Invisibly returns the path to the generated report.
#' @export
epi_report <- function(data,
                       indicators,
                       period        = "weekly",
                       geo_level     = "district",
                       output_format = "docx",
                       output_file   = NULL,
                       title         = "Epidemiological Surveillance Report",
                       location_name = "All locations",
                       logo_path     = NULL) {

  period        <- match.arg(period,        c("weekly", "monthly"))
  geo_level     <- match.arg(geo_level,     c("district", "region", "national"))
  output_format <- match.arg(output_format, c("docx", "pdf"))

  if (is.null(output_file)) {
    timestamp   <- format(Sys.Date(), "%Y%m%d")
    output_file <- glue::glue("epiforge_{period}_report_{timestamp}.{output_format}")
  }

  template_name <- glue::glue("{period}_report.Rmd")
  template_path <- system.file("templates", template_name, package = "epiforge")

  if (!file.exists(template_path)) {
    cli::cli_abort("Template not found: {.path {template_path}}")
  }

  cli::cli_alert_info("Generating {period} report in {output_format} format...")

  rmd_params <- list(
    data          = data,
    indicators    = indicators,
    period        = period,
    geo_level     = geo_level,
    title         = title,
    location_name = location_name,
    logo_path     = logo_path,
    report_date   = Sys.Date()
  )

  rmarkdown::render(
    input         = template_path,
    output_file   = output_file,
    params        = rmd_params,
    quiet         = TRUE,
    output_format = if (output_format == "docx") "word_document" else "pdf_document"
  )

  cli::cli_alert_success("Report generated: {.path {output_file}}")
  invisible(output_file)
}
