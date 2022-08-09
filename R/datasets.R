#' @name PlastoGram_H
#' @title PlastoGram_H model
#' @description PlastoGram model trained on the holdout version
#' of the data sets. Its performance is better but it may be due
#' to the slight overfitting.
#' @docType data
#' @format A list of length four:
#' \describe{
#'   \item{ngram_models}{Lower-level, task-specific ngram models}
#'   \item{RF_model}{Higher-level random forest model that makes
#'   final prediction based on results from lower-level models}
#'   \item{OM_IM_model}{Additional model for differentiation of
#'   proteins predicted as N_E into OM and IM}
#'   \item{imp_ngrams}{list of informative ngrams for all models}
#'   }
#' @keywords datasets
NULL

#' @name PlastoGram_P
#' @title PlastoGram_P model
#' @description PlastoGram model trained on the partitioning version
#' of the data sets. Its performance is slightly worse but it was
#' evaluated on sequences that were below 40% identity threshold
#' in regard to training sequences.
#' @docType data
#' @format A list of length four:
#' \describe{
#'   \item{ngram_models}{Lower-level, task-specific ngram models}
#'   \item{RF_model}{Higher-level random forest model that makes
#'   final prediction based on results from lower-level models}
#'   \item{OM_IM_model}{Additional model for differentiation of
#'   proteins predicted as N_E into OM and IM}
#'   \item{imp_ngrams}{list of informative ngrams for all models}
#'   }
#' @keywords datasets
NULL