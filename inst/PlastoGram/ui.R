library(shiny)
library(shinythemes)
library(shinyalert)
library(shinyhelper)

shinyUI(fluidPage(tags$head(includeScript("ga.js"), 
                            tags$link(rel = "stylesheet", type = "text/css"))
                  ,#, href = "progress.css")),
                  title = "PlastoGram",
                  theme = shinytheme("united"),
                  headerPanel(""),
                  
                  tags$style(type='text/css', ".content, .container-fluid {background-color: #f6faf2;}",
                             HTML("a {color: #477443}"),
                             HTML(".btn-default {background-color: #a9d384;border-color: #374c33;color: #374c33}"),
                             HTML(".sweet-alert p {text-align: justify; font-size: 14px; width=100%;}"),
                             HTML("table.DTFC_Cloned tr {background-color: #f6faf2}")),
                         #    type = 'button', ".btn-default .action-button {background-color: #e1f0d5;border-color: #52804b}"),

                  sidebarLayout(
                    sidebarPanel(style = "background-color: #e1f0d5;border-color: #52804b;border-width: .25rem",
                                 includeMarkdown("readme.md"),
                                 uiOutput("dynamic_ui"),
                                 markdown("<br><br>**Citation**:"),
                                 markdown(PlastoGram:::markdown_citation()),
                                 markdown("**Contact**:"),
                                 markdown(PlastoGram:::markdown_contact()),
                                 markdown("**Funding**:"),
                                 markdown(PlastoGram:::markdown_acknowledgements())
                    ),

                    mainPanel(
                      uiOutput("dynamic_tabset")
                    )
                  )))
