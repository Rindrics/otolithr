context("Functional test")

indir      <- "../Genus-spcs"
paths      <- get_path(indir)
paths2load <- get_dir2load(paths)[1]

test_that("load_otolith() loads otolith data from relative path", {
  data <- load_otolith(paths2load)
  expect_is(data$ninc, "integer")
})

test_that("load_otolith() loads otolith data being given 'type' manually", {
  data <- load_otolith("../Sardinops-melanostictus_foo_MT01_01.hdr",
                       "survey")
  expect_is(data$ninc, "integer")
  data <- load_otolith("../Sardinops-melanostictus_20160629_minato_002.hdr",
                       "commercial")
  expect_is(data$ninc, "integer")

  data  <- load_otolith("../Sardinops-melanostictus_20160909_temp24_10.hdr",
                        "reared")
  expect_is(data$ninc, "integer")
})
