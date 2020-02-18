#' @export
plot <- function(x) {
  UseMethod("plot")
}

#' Plot relationship between Age and OR
#'
#' @param df_otolith Tidy otolith data made by \code{hdr2df_in_dir}
#' @export
plot.otolith <- function(df_otolith) {
  df_otolith %>%
    dplyr::group_by(ID, Age) %>%
    dplyr::summarize(OR = max(OR_microm)) %>%
    ggplot2::ggplot(ggplot2::aes(Age, OR, color = ID, label = ID)) +
    ggplot2::geom_point()
}
