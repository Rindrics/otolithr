get_id  <- function(path) {
  fpath.split <- unlist(strsplit(path, "/"))
  gsub(".hdr", "", fpath.split[length(fpath.split)])
}

read_hdr  <- function(path) {
  read.csv(path, fileEncoding = "cp932",
           stringsAsFactors = FALSE, header = FALSE)
}

locate_var    <- function(ratoc.hdr, varname) {
  which(as.character(ratoc.hdr[, 1]) == varname)
}

extract_var <- function(hdr, varname) {
  hdr[locate_var(hdr, varname), 2]
}

locate_1stinc    <- function(ratoc.hdr) {
  locate_var(ratoc.hdr, "\u65e5\u8f2a\u5e45") + 1
}

extract_incwidth <- function(ratocdata) {
  as.numeric(ratocdata[locate_1stinc(ratocdata):nrow(ratocdata), 1])
}

inc2age <- function(incno, species = NULL) {
  switch(species,
         "maiwashi" = incno + 2,
         "maaji"    = incno + 2)
}

format_date <- function(hdr) {
  string <- extract_var(hdr, "\u63a1\u96c6\u65e5\u4ed8")
  as.Date(paste0(20, substr(string, 1, 8)))
}

#' Convert `.hdr` file into data frame
#' @param path Path of the target hdr file
#' @param species Species in romaji
#' @param pick_rank `Rank` (A, B, C, etc.) to find location
#' @examples
#' \dontrun{
#'   hdr2df("PATH_TO_HDR_FILE/sample.hdr", species = "maiwashi")
#'   hdr2df("PATH_TO_HDR_FILE/sample.hdr",
#'          species   = "maiwashi",
#'          pick_rank = "C")
#' }
#' @export
hdr2df <- function(path, species, fname_pattern = NULL, pick_rank = NULL) {
  hdr       <- read_hdr(path)
  inc_width <- extract_incwidth(hdr)
  incno     <- as.integer(1:length(inc_width))
  cruise    <- NA
  station   <- NA
  sampleno  <- NA
  if (!is.null(fname_pattern)) {
    vec <- path %>%
      extract_fname() %>%
      rm_extension() %>%
      split_fname() %>%
      purrr::set_names(fname_pattern)
    cruise   <- vec["Cruise"]
    station  <- vec["Station"]
    sampleno <- vec["SampleNo"]
  }
  data <- tibble::tibble(
    ID              = get_id(path),
    Cruise          = cruise,
    Station         = station,
    DateCollected   = format_date(hdr),
    SampleNo        = sampleno,
    BL_mm           = as.numeric(extract_var(hdr, "\u4f53\u9577")),
    IncNo           = incno,
    iAge            = inc2age(IncNo, species = species),
    Species         = species,
    IncWidth_microm = inc_width,
    OR_microm       = cumsum(inc_width),
    BackCalBL_mm    = back_calculate(
      bl_at_catch = BL_mm,
      orvec       = OR_microm,
      species     = species)
  ) %>%
    dplyr::mutate(Age         = max(iAge),
                  DateHatched = DateCollected - Age)

  confirm_data_format(data)

  class(data) <- c(class(data), "otolith")
  if (is.null(pick_rank)) return(data)
  dplyr::mutate(data, Rank = locate_rank(hdr, pick_rank))
}

#' Tidy all `.hdr`s into a single df in given directory
#'
#' @inheritParams hdr2df
#' @param dir Target directory which contains `.hdr` files
#' @examples
#' \dontrun{
#'   hdr2df_in_dir("PATH_TO_HDR_FILE", species = "maiwashi")
#' }
#' @export
hdr2df_in_dir <- function(dir, species, pick_rank = NULL) {
  filelist <- list.files(dir, pattern = ".+\\.hdr$", full.names = TRUE)
  purrr::map_df(.x = filelist, .f = hdr2df,
                species = species,
                pick_rank = pick_rank)
}

extract_ranks <- function(hdr) {
  hdr[locate_1stinc(hdr):nrow(hdr), 2] %>%
    stringr::str_remove(" ")
}

locate_rank <- function(hdr, rank) {
  stringr::str_which(extract_ranks(hdr), rank)
}

filter_by_rank_ <- function(id, df, use_after) {
  idf <- dplyr::filter(df, ID == id) # nolint
  if (use_after == TRUE) {
    inc_start <- unique(idf$Rank)
    inc_end   <- max(idf$IncNo)
  } else {
    inc_start <- 1
    inc_end   <- unique(idf$Rank)
  }
  return(dplyr::filter(idf, dplyr::between(IncNo, inc_start, inc_end))) # nolint
}

filter_by_rank <- function(df, use_after = TRUE) {
  idlist   <- unique(df$ID)
  purrr::map_df(idlist, filter_by_rank_,
                df = df,
                use_after = use_after)
}
