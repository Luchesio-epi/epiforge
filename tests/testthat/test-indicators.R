test_that("epi_indicators returns expected columns", {
  # Données minimales de test
  data <- tibble::tibble(
    date     = as.Date(c("2024-01-01", "2024-01-08", "2024-01-01")),
    disease  = c("Malaria", "Malaria", "Cholera"),
    location = c("District A", "District A", "District A"),
    cases    = c(10, 15, 5)
  )
  result <- epi_indicators(data, period = "weekly")
  expect_true("total_cases" %in% names(result))
  expect_true("period_label" %in% names(result))
})

test_that("epi_indicators computes incidence when population provided", {
  data <- tibble::tibble(
    date     = as.Date("2024-01-01"),
    disease  = "Malaria",
    location = "District A",
    cases    = 100
  )
  result <- epi_indicators(data, population = 10000, period = "weekly")
  expect_true("incidence_per_100k" %in% names(result))
  expect_equal(result$incidence_per_100k, 1000)
})
