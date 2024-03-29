% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/datasets.R
\docType{data}
\name{PlastoGram_H}
\alias{PlastoGram_H}
\title{PlastoGram_H model}
\format{
A list of length four:
\describe{
  \item{ngram_models}{Lower-level, task-specific ngram models}
  \item{RF_model}{Higher-level random forest model that makes
  final prediction based on results from lower-level models}
  \item{OM_IM_model}{Additional model for differentiation of
  proteins predicted as N_E into OM and IM}
  \item{imp_ngrams}{list of informative ngrams for all models}
  }
}
\description{
PlastoGram model trained on the holdout version
of the data sets. Its performance is better but it may be due
to the slight overfitting.
}
\keyword{datasets}
