#' Prediction of subchloroplast localization.
#'
#' PlastoGram is a robust ensemble model for detailed and accurate prediction 
#' of subplastid localization and origin of analysed protein. PlastoGram 
#' classifies protein as nuclear- or plastid-encoded and predicts its most 
#' probable localization considering envelope, stroma, thylakoid membrane or 
#' thylakoid lumen. For the latter, also the import pathway (Sec or Tat) is 
#' predicted. We also provide an additional function to differentiate 
#' nuclear-encoded inner and outer membrane proteins.
#' 
#' PlastoGram is available as R function (\code{\link{predict.plastogram_model}}) or
#' shiny GUI (\code{\link{PlastoGram_gui}}).
#' 
#' PlastoGram requires the external software HMMER.
#'
#' @name PlastoGram-package
#' @aliases PlastoGram-package PlastoGram
#' @docType package
#' @importFrom utils menu
#' @author
#' Maintainer: Katarzyna Sidorczuk <sidorczuk.katarzyna17@@gmail.com>
#' @references ...
#' @keywords package
NULL
globalVariables(c("sequence_score"))