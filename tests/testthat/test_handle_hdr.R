context("Handling .hdr file")

test_that("parse date", {
  hdr <- read_hdr("hdrs/soyo_maiwashi.hdr")
  expect_equal(format_date(hdr), as.Date("2016-05-25"))
})
