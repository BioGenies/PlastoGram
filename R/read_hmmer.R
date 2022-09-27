#' Read a tblout HMMER file
#'
#' This function is a modified version of a read_tblout function 
#' from the rhmmer package. For the original code see
#' https://github.com/arendsee/rhmmer/blob/master/R/parse.R
#' @param file Filename
#' @import readr
#' @return data.frame
#' @export
read_tblout <- function(file){
  col_types <- readr::cols(
    domain_name         = readr::col_character(),
    domain_accession    = readr::col_character(),
    query_name          = readr::col_character(),
    query_accession     = readr::col_character(),
    sequence_evalue     = readr::col_double(),
    sequence_score      = readr::col_double(),
    sequence_bias       = readr::col_double(),
    best_domain_evalue  = readr::col_double(),
    best_domain_score   = readr::col_double(),
    best_domain_bis     = readr::col_double(),
    domain_number_exp   = readr::col_double(),
    domain_number_reg   = readr::col_integer(),
    domain_number_clu   = readr::col_integer(),
    domain_number_ov    = readr::col_integer(),
    domain_number_env   = readr::col_integer(),
    domain_number_dom   = readr::col_integer(),
    domain_number_rep   = readr::col_integer(),
    domain_number_inc   = readr::col_character()
  )
  
  N <- length(col_types$cols)
  
  # the line delimiter should always be just "\n", even on Windows
  lines <- readr::read_lines(file, progress=FALSE)
  
  x <- sub(
    pattern = sprintf("(%s).*", paste0(rep('\\S+', N), collapse=" +")),
    replacement = '\\1',
    x=lines,
    perl = TRUE
  ) 
  y <- paste0(gsub(pattern="  *", replacement="\t", x), collapse="\n")
  
  table <- readr::read_tsv(y,
    col_names=names(col_types$cols),
    comment='#',
    na='-',
    col_types = col_types,
    progress=FALSE
  )
  
  descriptions <- sub(lines[!grepl("^#", lines, perl=TRUE)],
                      pattern = sprintf("%s *(.*)", paste0(rep('\\S+', N), collapse=" +")),
                      replacement = '\\1',
                      perl = TRUE
  )
  
  table$description <- descriptions[!grepl(" *#", descriptions, perl=TRUE)]
  
  table
}