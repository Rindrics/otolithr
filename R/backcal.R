backcal <- function(arglist) {
  if (!all(names(arglist) %in% c("bl_at_catch", "orvec"))) {
    stop("Name of arglist is wrong!")
  }
  UseMethod("backcal")
}

backcal.maiwashi <- function(arglist) {
  bl_hatch <- 5.9 # sl at hatch (Takahashi et al. 2008 Can.J.fish)
  bl_catch <- arglist$bl_at_catch
  orvec    <- arglist$orvec

  a <- (bl_hatch - bl_catch) / (orvec[1] - rev(orvec)[1])
  b <- bl_catch - a * rev(orvec)[1]

  bl_calculated <- backcal_i_maiwashi(a = a,
                                      b = b,
                                      orvec[c(-1, -length(orvec))])
  c(bl_hatch, bl_calculated, bl_catch)
}

backcal_i_maiwashi <- function(a, b, radius) {
  a * radius + b
}


back_calculate <- function(bl_at_catch, orvec, species) {
  out <- list(bl_at_catch = unique(bl_at_catch), # To make length == 1
              orvec       = orvec)
  class(out) <- as.character(species)
  backcal(out)
}

