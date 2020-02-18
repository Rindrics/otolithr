get_id  <- function(path) {
  fpath.split <- unlist(strsplit(path, "/"))
  id          <- gsub(".hdr", "", fpath.split[length(fpath.split)])
  return(id)
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
  locate_var(ratoc.hdr, "日輪幅") + 1
}

extract_incwidth <- function(ratocdata) {
  as.numeric(ratocdata[locate_1stinc(ratocdata):nrow(ratocdata), 1])
}

inc2age <- function(incno, species = NULL) {
  switch(species,
         "maiwashi" = incno + 2,
         "maaji" = incno + 2)
}

hdr2df <- function(path, species, pick_rank = NULL) {
  hdr       <- read_hdr(path)
  inc_width <- extract_incwidth(hdr)
  incno     <- as.integer(1:length(inc_width))
  data <- tibble::tibble(ID = get_id(path),
                         BL_mm = as.numeric(extract_var(hdr, "体長")),
                         IncNo = incno,
                         iAge = inc2age(IncNo, species = species),
                         Species = species,
                         IncWidth_microm = inc_width,
                         OR_microm = cumsum(inc_width)) %>%
    dplyr::mutate(Age = max(iAge))
  if (is.null(pick_rank)) return(data)
  return(dplyr::mutate(data, Rank = locate_rank(hdr, pick_rank)))
}

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
  idf <- dplyr::filter(df, ID == id)
  if (use_after == TRUE) {
    inc_start <- unique(idf$Rank)
    inc_end   <- max(idf$IncNo)
  } else {
    inc_start <- 1
    inc_end   <- unique(idf$Rank)
  }
  return(dplyr::filter(idf, dplyr::between(IncNo, inc_start, inc_end)))
}

filter_by_rank <- function(df, use_after = TRUE) {
  idlist   <- unique(df$ID)
  purrr::map_df(idlist, filter_by_rank_,
                df = df,
                use_after = use_after)
}

