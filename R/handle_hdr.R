load_hdr <- function(fname){
  utils::read.csv(fname, fileEncoding = "CP932",
                  header = FALSE, stringsAsFactors = FALSE)
}

locate_1stinc <- function(x) {
  which(x == "日輪幅") + 1 # Data of 1stinc is located just after "日輪幅".
}

get_incdata <- function(hdrdata) {
  x   <- as.character(hdrdata$V1)
  out <- x[locate_1stinc(x):length(x)] %>%
    as.numeric()
  out
}
