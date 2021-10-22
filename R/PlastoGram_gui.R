#' PlastoGram Graphical User Interface
#'
#' Launches graphical user interface that predicts presence of 
#' antimicrobial peptides.
#'
#' @importFrom shiny runApp
#' @seealso \code{\link[shiny]{runApp}}
#' @return No return value, called for side effects.
#' @section Warning : Any ad-blocking software may cause malfunctions.
#' @export PlastoGram_gui
PlastoGram_gui <- function() {
  runApp(system.file("PlastoGram", package = "PlastoGram"))
}