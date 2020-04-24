context("otolith")

test_that("class 'Otolith' exists", {
  otolith <- Otolith$new(Age = 123)
  expect_equal(otolith$Age, 123)
})
