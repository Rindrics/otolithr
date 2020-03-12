#' Preview relationship between Age and OR
#'
#' @export
#' @param df_otolith Tidy otolith data
#'  made by \code{hdr2df} and \code{hdr2df_in_dir}
#' @return Nothing. Side-effect: plots graphs
preview <- function(df_otolith) {
  NextMethod("plot")
  p <- df_otolith %>%
    dplyr::group_by(ID, Age, BL_mm) %>%
    dplyr::summarize(OR_microm = max(OR_microm)) %>%
    plotly::plot_ly(x = ~Age, y = ~OR_microm, type = 'scatter',
                   mode = 'markers', hoverinfo = text,
                   text = ~paste('ID: ', ID,
                                '</br> BL_mm: ', BL_mm))
  p
}
