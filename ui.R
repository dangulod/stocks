library(shiny)
library(shinydashboard)
library(plotly)

shinyUI(fluidPage(

  
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap.min.css")
  ),
  
  titlePanel("Ibex 35"),

  

  mainPanel(
    
    plotlyOutput("ibex_updown"),
    
    dataTableOutput("ibex_table")
  )
)
)
