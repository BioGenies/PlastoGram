library(shiny)
library(ggplot2)
library(PlastoGram)
library(ranger)
library(biogram)
library(DT)
library(shinythemes)
library(rmarkdown)
library(pander)

source("shiny-server-utils.R")

data(PlastoGram_model)

options(shiny.maxRequestSize=10*1024^2)

shinyServer(function(input, output) {
  
  prediction <- reactive({
    
    if (!is.null(input[["seq_file"]]))
      input_sequences <- read_txt(input[["seq_file"]][["datapath"]])
    input[["use_area"]]
    isolate({
      if (!is.null(input[["text_area"]]))
        if(input[["text_area"]] != "")
          input_sequences <- read_txt(textConnection(input[["text_area"]]))
    })
    
    if(exists("input_sequences")) {
      if(length(input_sequences) > 50) {
        #dummy error, just to stop further processing
        stop("Too many sequences. Please use PlastoGram locally.")
      } else {
        if(any(lengths(input_sequences) < 5)) {
          #dummy error, just to stop further processing
          stop("The minimum length of the sequence is 5 amino acids.")
        } else {
          predict(PlastoGram_model, input_sequences, Sys.which("hmmsearch"))
        }
      }
    } else {
      NULL
    }
  })
  
  decision_table <- reactive({
    if(!is.null(prediction())) {
      prediction()[["Final_results"]]
    }
  })
  
  output[["decision_table"]] <- renderDataTable({
    df <- decision_table()
    my_DT(df) %>% 
      formatStyle(1:ncol(df), target = "row", backgroundColor = "#f6faf2")
    
  })
  
  
  
  detailed_preds <- reactive({
    if(!is.null(prediction())) {
      prediction()[["Lower_level_preds"]]
    }
  })
  
  om_im_preds <- reactive({
    if(!is.null(prediction()) & !is.null(prediction()[["OM_IM_preds"]])) {
      prediction()[["OM_IM_preds"]]
    }
  })
  
  
  
  output[["detailed_tab"]] <- renderDataTable({
    my_DT(detailed_preds(), options = list(scrollX = TRUE, fixedColumns = list(leftColumns = 1))) %>% 
      formatRound(2:8, 4) %>% 
      formatStyle("seq_name", target = "row", backgroundColor = "#f6faf2")
  })
  
  output[["om_im_tab"]] <- renderDataTable({
    my_DT(om_im_preds(), options = list(scrollX = TRUE, fixedColumns = list(leftColumns = 1))) %>% 
      formatRound(2:3, 4) %>% 
      formatStyle("seq_name", target = "row", backgroundColor = "#f6faf2")
  })
  
  output[["dynamic_ui"]] <- renderUI({
    if (!is.null(input[["seq_file"]]))
      input_sequences <- read_txt(input[["seq_file"]][["datapath"]])
    input[["use_area"]]
    isolate({
      if (!is.null(input[["text_area"]]))
        if(input[["text_area"]] != "")
          input_sequences <- read_txt(textConnection(input[["text_area"]]))
    })
    
    if(exists("input_sequences")) {
      fluidRow(
        tags$p(HTML("<h3><A HREF=\"javascript:history.go(0)\">Start a new query</A></h3>"))
      )
    } else {
      fluidRow(
        actionButton("seqs", "Show exemplary sequences")
      )
    }
  })
  
  output[["dynamic_tabset"]] <- renderUI({
    if(is.null(prediction())) {
      
      tabPanel(title = "Sequence input",
               tags$textarea(id = "text_area", style = "width:90%",
                             placeholder="Paste sequences (FASTA format required) here...", 
                             rows = 22, cols = 60, ""),
               tags$p(""),
               actionButton("use_area", "Submit data from field above"),
               tags$p(""),
               fileInput('seq_file', 'Submit .fasta or .txt file:'))
      
      
    } else {
      if(!is.null(om_im_preds())) {
        tabsetPanel(
          tabPanel("Results",
                   dataTableOutput("decision_table")
          ),
          tabPanel("Detailed results",
                   includeMarkdown("detailed_results_desc.md"),
                   dataTableOutput("detailed_tab")
          ),
          tabPanel("N_E predictions",
                   includeMarkdown("om_im_results_desc.md"),
                   dataTableOutput("om_im_tab"))
        )
      } else {
        tabsetPanel(
          tabPanel("Results",
                   dataTableOutput("decision_table")
          ),
          tabPanel("Detailed results",
                   includeMarkdown("detailed_results_desc.md"),
                   dataTableOutput("detailed_tab")
          )
        )
      }
    }
  })
  
  
  observeEvent(input[["seqs"]], {
    shinyalert("",
               includeText("sequences.txt"),
               size = 'm')
  })
  
  
})
