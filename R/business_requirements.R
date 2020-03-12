generate_mock <- function() {
  data.frame(ID              = NA,
             DateCollected   = NA,
             BL_mm           = NA,
             IncNo           = NA,
             iAge            = NA,
             Species         = NA,
             IncWidth_microm = NA,
             OR_microm       = NA,
             BackCalBL_mm    = NA,
             Age             = NA,
             DateHatched     = NA)
}

confirm_data_format <- function(df) {
  if (length(colnames(df)) != length(colnames(generate_mock())) ||
      !all(colnames(df) == colnames(generate_mock()))) {
    stop("Output is not equal to the defintion in 'business_requirements.R'")
  }
}
