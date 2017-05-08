library(shiny)
library(shinydashboard)

shinyUI(fluidPage(

  
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap.min.css")
  ),
  
  titlePanel("Old Faithful Geyser Data"),

  box(title = "STOCK",solidHeader = T,
    selectInput("Selet stocks", multiple = T,
                inputId = "stocks", 
                choices = c("ARCELORMIT.", 
                            "BA.POPULAR", 
                            "BA.SABADELL", 
                            "BA.SANTANDER", 
                            "BANKIA", 
                            "BANKINTER"))),

  mainPanel(
    dataTableOutput("ibex_table")
  )
)
)
