context("Util functions")

test_that("extract_fname() works well", {
  expect_equal(extract_fname("foo/bar/baz.txt"), "baz.txt")
  expect_equal(extract_fname("foo/bar.txt"),     "bar.txt")
  expect_equal(extract_fname("foo/bar.txt.csv"), "bar.txt.csv")
})
