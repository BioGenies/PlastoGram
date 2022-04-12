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
#'   \item{Lower_level_preds}{Prediction results from eight lower-level
#'   models trained to recognize sequence features associated with specific 
#'   subplastidlocalization. Data frame with 9 columns and number of rows
#'   equal to the number of analyzed sequences. The first column contains sequence
#'   name and the following columns store prediction results from all lower-level
#'   models. For more information on lower-order models see Details section.}
#'   \item{Higher_level_preds}{Prediction results from higher-level model
#'   trained to determine final subplastid localization of a given protein
#'   based on predictions obtained by lower-level models. Data frame with 10 columns
#'   and number of rows equal to number of analyzed sequences. The first column
#'   (\code{seq_name}) indicates sequence name an the following eight columns 
#'   contain prediction probabilities for each of the locations considered by 
#'   the PlastoGram model. The last column (\code{Localization}) contains 
#'   abbreviation of a predicted location. For more information on higher-level 
#'   model see Details section.}
#'   \item{OM_IM_preds}{}
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
#'   \item{Membrane_model}{identifies membrane proteins}
#'   \item{N_E_vs_N_TM_model}{differentiates between nuclear-encoded envelope 
#'   proteins and nuclear-encoded thylakoid membrane proteins. Prediction
#'   values over 0.5 indicate envelope, whereas lower thylakoid membrane}
#'   \item{Plastid_membrane_model}{distinguishes plastid-encoded proteins 
#'   targeted to plastid inner and thylakoid membrane. Prediction values 
#'   higher than 0.5 indicate inner membrane, whereas lower thylakoid 
#'   membrane}
#'   \item{N_E_vs_N_S_model}{differentiates nuclear-encoded proteins 
#'   targeted to envelope from nuclear-encoded stromal proteins. Prediction 
#'   values over 0.5 indicate envelope, whereas lower stroma}
#'   \item{Nuclear_membrane_model}{distinguishes nuclear-encoded membrane
#'   proteins from all others}}
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
#' @export
predict.plastogram_model <- function(object, newdata, hmmer_dir = Sys.which("hmmsearch"), ...) {
  
  ngrams <- add_missing_features(get_ngrams(newdata),
                                 c(object[["imp_ngrams"]], object[["OM_IM_model"]][["forest"]][["independent.variable.names"]]))
  
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
  
  hl_preds <- data.frame(seq_name = names(newdata),
                         predict(object[["RF_model"]], all_res)[["predictions"]])
  hl_preds[["Localization"]] <- change_res_names(colnames(hl_preds)[2:ncol(hl_preds)][max.col(hl_preds[, colnames(hl_preds)[2:ncol(hl_preds)]])])
  
  n_e <- which(hl_preds[["Localization"]] == "Nuclear-encoded; envelope")
  om_im_preds <- if(length(n_e > 0)) {
    om_im_res <- predict(object[["OM_IM_model"]],
                         ngrams[n_e, ])[["predictions"]]
    df <- data.frame(seq_name = hl_preds[["seq_name"]][n_e],
                     OM = om_im_res[, "TRUE"],
                     IM = om_im_res[, "FALSE"])
    df[["Localization"]] <- sapply(1:nrow(df), function(i) ifelse(df[["OM"]][i] > df[["IM"]][i], "OM", "IM"))
    df
  } else {
    NULL
  }
  
  plastogram_res <- list("Lower_level_preds" = all_res,
                         "Higher_level_preds" = hl_preds,
                         "OM_IM_preds" = om_im_preds,
                         "Final_results" = data.frame(hl_preds[, c("seq_name", "Localization")],
                                                      Probability = sapply(1:nrow(hl_preds[, 2:(ncol(hl_preds)-1)]), function(i) max(hl_preds[i, 2:(ncol(hl_preds)-1)]))))
  class(plastogram_res) <- "plastogram_prediction"
  plastogram_res
}

