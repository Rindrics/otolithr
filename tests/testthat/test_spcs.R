test_that("set_spcsname() give spcs name class correctly", {
  fname <- "foo"
  expect_is(set_spcsname(fname, "Sardinops-melanostictus"),
            "Sardinops-melanostictus")
  expect_is(set_spcsname(fname, "Engraulis-japonicus"),
            "Engraulis-japonicus")
  expect_is(set_spcsname(fname, "Trachurus-japonicus"),
            "Trachurus-japonicus")
})
