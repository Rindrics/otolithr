Otolith <- R6::R6Class("Otolith", list(
  Age = NA,
  initialize = function(Age = NA) {
    stopifnot(is.numeric(Age), length(Age) == 1)
    self$Age <- Age
  }
))
