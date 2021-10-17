#' @importFrom seqR count_multimers 
get_ngrams <- function(x) {
  as.data.frame(
    as.matrix(
      count_multimers(sequences = x,
                      k_vector = c(1, rep(2,4), rep(3,4)),
                      kmer_gaps_list = list(NULL, NULL, 1, 2, 3, c(0,0), c(0,1), c(1,0), c(1,1)),
                      kmer_alphabet = toupper(colnames(biogram::aaprop)),
                      with_kmer_counts = FALSE)
    )
  )
} 

#' @importFrom stats setNames
add_missing_features <- function(ngrams, imp_ngrams) {
  missing <- imp_ngrams[which(!(imp_ngrams %in% colnames(ngrams)))]
  if(length(missing) > 0) {
    cbind(ngrams, setNames(lapply(missing, function(x) x = 0), missing))
  } else {
    ngrams
  }
}

#' @importFrom rhmmer read_tblout
#' @importFrom dplyr mutate bind_rows
read_hmmer_results <- function(res_file, model_name) {
  res <- mutate(bind_rows(read_tblout(res_file)), 
                pred = (2^sequence_score) / (1+2^sequence_score))[, c("domain_name", "pred")]
  colnames(res) <- c("seq_name", model_name)
  res
}


#' @importFrom biogram write_fasta
#' @importFrom dplyr full_join
predict_profileHMM <- function(test_seqs, hmmer_dir = Sys.which("hmmsearch")) {
  
  if(hmmer_dir == "") {
    stop("It seems that you do not have HMMER installed. To be able to use PlastoGram,
    you should install standalone HMMER. If you have installed HMMER and still
    see this message, please use 'hmmer_dir' argument to provide a proper path to 
    the hmmer directory in which 'hmmsearch' executable is located.")
  } else if(hmmer_dir == Sys.which("hmmsearch")) {
    write_fasta(test_seqs, "test_seqs.fa")
    system(paste0("hmmsearch --tblout hmmer_res_sec ", normalizePath(system.file(package = "PlastoGram")), "/PlastoGram_Sec_model.hmm test_seqs.fa >/dev/null")) 
    system(paste0("hmmsearch --tblout hmmer_res_tat ", normalizePath(system.file(package = "PlastoGram")), "/PlastoGram_Tat_model.hmm test_seqs.fa >/dev/null")) 
  } else {
    if(grepl("/$", hmmer_dir)) hmmer_dir <- gsub("/$", "", hmmer_dir)
    tryCatch(system(paste0(hmmer_dir, "/hmmsearch --tblout hmmer_res_sec ", normalizePath(system.file(package = "PlastoGram")), 
                           "/PlastoGram_Sec_model.hmm test_seqs.fa && hmmsearch --tblout hmmer_res_tat ", 
                           normalizePath(system.file(package = "PlastoGram")), "/PlastoGram_Tat_model.hmm test_seqs.fa >/dev/null")),
             warning = function(w) {
               msg <- conditionMessage(w)
               if(msg == "error in running command") message("Please check if the HMMER directory path you provided is correct.")
             })
  }

  res <- full_join(read_hmmer_results("hmmer_res_sec", "Sec_model"),
                   read_hmmer_results("hmmer_res_tat", "Tat_model"),
                   by = "seq_name")
  
  file.remove(c("test_seqs.fa", "hmmer_res_sec", "hmmer_res_tat"))
  
  res
}
