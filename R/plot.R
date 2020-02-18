plot <- function(x) {
  UseMethod("plot")
}

plot.otolith <- function(df_otolith) {
  df_otolith %>%
    dplyr::group_by(ID, Age) %>%
    dplyr::summarize(OR = max(OR_microm)) %>%
    ggplot2::ggplot(ggplot2::aes(Age, OR, color = ID, label = ID)) +
    ggplot2::geom_point()
}
