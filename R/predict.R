#' Predict subchloroplast localization
#'
#' Predicts protein subchloroplast localization using the PlastoGram algorithm.
#' @param object \code{plastogram_model} object.
#' @param newdata \code{list} of sequences (for example as given by
#' \code{\link[biogram]{read_fasta}} or \code{\link{read_txt}}).
#' @param hmmer_dir path to the hmmer directory in which \code{hmmsearch} executable 
#' is located
#' @param ... further arguments passed to or from other methods.
#' @return object of class \code{plastogram_prediction}, a \code{list} of three
#' \code{data frame}s containing prediction results:
#' \describe{
#'   \item{Lower-order_models_preds}{Prediction results from nine lower-order
#'   models trained to recognize sequence features associated with specific 
#'   subchloroplast localization. Data frame with 10 columns and number of rows
#'   equal to the number of analyzed sequences. The first column contains sequence
#'   name and the following  For more information on lower-order models
#'   see Details section.}
#'   \item{Higher-order_model_preds}{Prediction results from higher-order model
#'   trained to determine final subchloroplast localization of a given protein
#'   based on predictions obtained by lower-order models. Data frame with 10 columns
#'   and number of rows equal to number of analyzed sequences. The first column
#'   (\code{seq_name}), the following nine columns contain prediction probabilities
#'   for each of the locations considered by the PlastoGram model. The last column
#'   (\code{Localization}) contains abbreviation of a predicted location. For more 
#'   information on higher-order model see Details section.}
#'   \item{Final_results}{Summary of PlastoGram predictions. Data frame with 3
#'   columns and number of rows equal to the number of analyzed sequences. The
#'   columns contain the following information: name of the analyzed sequence,
#'   predicted localization, probability of the predicted localization (assumes
#'   values from 0 to 1).}}
#' @export
#' @details PlastoGram depends on the HMMER software for prediction of signals
#' responsible for targeting to the thylakoid lumen via Sec and Tat pathways.
#' 
#' PlastoGram lower-order models are responsible for identification of features
#' characteristic for specific subchloroplast localizations. They include
#' random forest models based on ngrams (short amino acid motifs):
#' \describe{
#'   \item{Nuclear_model}{recognizes nuclear-encoded proteins}
#'   \item{Membrane_model}{recognizes membrane proteins}
#'   \item{Nuclear_OM_model}{recognizes nuclear-encoded proteins targeted to 
#'   plastid outer membrane}
#'   \item{Nuclear_IM_model}{recognizes nuclear-encoded proteins targeted to 
#'   plastid inner membrane}
#'   \item{Nuclear_TM_model}{recognizes nuclear-encoded proteins targeted to 
#'   plastid thylakoid membrane}
#'   \item{Plastid_membrane_model}{differentiates plastid-encoded proteins 
#'   targeted to plastid inner and thylakoid membrane. Prediction values 0 
#'   indicate thylakoid membrane, whereas 1 inner membrane}
#'   \item{Nuclear_OM_stroma_model}{differentiates nuclear-encoded proteins 
#'   targeted to plastid outer membrane and stroma. Prediction values 0 
#'   indicate stroma, whereas 1 outer membrane}}
#' and profile HMM models based on HMMER software
#' \describe{
#'   \item{Sec_model}{recognizes proteins targeted to the thylakoid lumen
#'   via Sec pathway}
#'   \item{Tat_model}{recognizes proteins targeted to the thylakoid lumen
#'   via Tat pathway}}
#'   
#' @importFrom purrr reduce
#' @importFrom stats predict
#' @importFrom dplyr left_join
#' @importFrom ranger ranger
#' @importFrom nnet multinom
#' @export
predict.plastogram_model <- function(object, newdata, hmmer_dir = Sys.which("hmmsearch"), ...) {
  
  ngrams <- add_missing_features(get_ngrams(newdata),
                                 object[["imp_ngrams"]])
  
  ngram_preds_list <- lapply(names(object[["ngram_models"]]), function(ith_model) {
    df <- data.frame(seq_name = names(newdata),
                     pred = predict(object[["ngram_models"]][[ith_model]], ngrams)[["predictions"]][, "TRUE"])
    colnames(df) <- c("seq_name", ith_model)
    df
  }) 
  ngram_models_res <- reduce(ngram_preds_list, full_join, by = "seq_name")
  
  hmm_models_res <- predict_profileHMM(newdata, hmmer_dir)
  
  all_res <- left_join(ngram_models_res, hmm_models_res, by = "seq_name")
  all_res[is.na(all_res)] <- 0
  
  glm_preds <- data.frame(seq_name = names(newdata),
                          predict(object[["glm_model"]], all_res, type = "probs"),
                          Localization = change_res_names(predict(object[["glm_model"]], all_res)))
  
  plastogram_res <- list("Lower-order_models_preds" = all_res,
                         "Higher-order_model_preds" = glm_preds,
                         "Final_results" = data.frame(glm_preds[, c("seq_name", "Localization")],
                                                      Probability = sapply(1:nrow(glm_preds[, 2:(ncol(glm_preds)-1)]), function(i) max(glm_preds[i, 2:(ncol(glm_preds)-1)]))))
  class(plastogram_res) <- "plastogram_prediction"
  plastogram_res
}

