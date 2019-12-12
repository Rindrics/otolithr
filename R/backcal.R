back_calculate_ <- function(otolith_radius, x_at_hatch, x_at_catch,
                            linear = TRUE) {
  a <- (x_at_hatch - x_at_catch) / (otolith_radius[1] - rev(otolith_radius)[1])
  b <- x_at_catch - a * rev(otolith_radius)[1]
  if (linear) {
    return(a * otolith_radius + b)
  } else {
    stop("allometric")
  }
}

#' @export
back_calculate <- function(df_otolith, df_measure) {
  bound <- dplyr::left_join(df_otolith, df_measure, by = "ID")
  species  <- unique(df_otolith$Species)
  if (species == "maiwashi") {
    sl_at_hatch <- 5.9 # Takahashi et al. 2008 Can.J.fish
    is_linear  <- unique(bound$SL_mm) > 25 # Takahashi et al. 2008 Can.J.Fish
    bound %>%
      dplyr::mutate(BackCalSL_mm = back_calculate_(OR_microm,
                                                   x_at_hatch = sl_at_hatch,
                                                   x_at_catch = SL_mm,
                                                   linear = TRUE))
  } else {
    stop("")
  }
}
