context("Calculate age")
infile   <-
  "../Genus-spcs/survey/mtfoo/data/Sardinops-melanostictus_foo_MT01_01.hdr"
data     <- load_hdr(infile)
incs     <- get_incdata(data)

test_that("calc_age() returns age", {
  expect_equal(calc_age(data), 176)
})
