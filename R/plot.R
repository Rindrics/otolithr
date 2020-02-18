#' @export
plot <- function(x) {
  UseMethod("plot")
}

#' Plot relationship between Age and OR
#'
#' @param df_otolith Tidy otolith data made by \code{hdr2df_in_dir}
#' @export
plot.otolith <- function(df_otolith) {
  p <- df_otolith %>%
    dplyr::group_by(ID, Age, BL_mm) %>%
    dplyr::summarize(OR_microm = max(OR_microm)) %>%
    plotly::plot_ly(x = ~Age, y = ~OR_microm, type = 'scatter',
                   mode = 'markers', hoverinfo = text,
                   text = ~paste('ID: ', ID,
                                '</br> BL_mm: ', BL_mm))
  p
}
