context("Business requirements")

test_that("format of output data frame", {
  expect_setequal(
    colnames(generate_mock()),
    c("ID", "BL_mm", "IncNo", "iAge", "Species", "IncWidth_microm",
      "OR_microm", "BackCalBL_mm", "Age", "DateCollected", "DateHatched")
  )
})
