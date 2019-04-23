make_data <- function(fname, fname_with_type) {
  data         <- load_hdr(fname)
  out          <- get_info(fname_with_type)
  out$inc      <- get_incdata(data)
  out$radius   <- cumsum(out$inc)
  out$ninc     <- length(out$inc)
  out$age.ofst <- dic_ageoffset[[out$spcs]]
  out$age      <- out$ninc + out$age
  out
}

load_otolith <- function(dir, type = NULL) {
  if (is.null(type))
    type <- detect_type(dir)
  fname_with_type <- fullpath2fname(dir) %>%
    set_type(type)
  out <- make_data(dir, fname_with_type)
  invisible(out)
}
