context("Handling .hdr file")

test_that("parse date", {
  hdr <- read_hdr("hdrs/soyo_maiwashi.hdr")
  expect_equal(format_date(hdr), as.Date("2016-05-25"))
})

test_that("give info from filename", {
  df <- hdr2df("hdrs/YK1608_st01_001.hdr",
               species = "maiwashi",
               fname_pattern = c("Cruise", "Station", "SampleNo"))
  expect_equal(unique(df$Cruise),   "YK1608")
  expect_equal(unique(df$Station),  "st01")
  expect_equal(unique(df$SampleNo), "001")
})

