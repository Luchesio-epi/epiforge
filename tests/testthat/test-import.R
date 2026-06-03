test_that("epi_import rejects non-existent file", {
  expect_error(epi_import("fichier_inexistant.csv"), "File not found")
})

test_that("epi_import detects unsupported extension", {
  # Créer un fichier temporaire avec extension inconnue
  tmp <- tempfile(fileext = ".txt")
  write("test", tmp)
  expect_error(epi_import(tmp), "Cannot detect format")
  unlink(tmp)
})
