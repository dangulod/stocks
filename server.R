library(shiny)
library(rvest)
library(dplyr)
library(plotly)
source("source/functions.R")

shinyServer(function(input, output) {

  ibex = reactive({
    
    ibex_page = read_html("http://www.bolsamadrid.es/esp/aspx/Mercados/Precios.aspx?indice=ESI100000000&punto=indice")
    
    ibex_page %>% 
      html_node(xpath = '//*[@id="ctl00_Contenido_tblAcciones"]') %>% 
      html_table() %>% 
      select(Nombre, Fecha, `Últ.`, Volumen, `% Dif.`) %>% 
      rename(Name = Nombre,
             Volume = Volumen,
             Price = `Últ.`,
             `+/- %` = `% Dif.`) %>% 
      sp_to_num() %>% 
      mutate(
        Fecha = as.Date(Fecha, format = "%d/%m/%Y")
      ) 
  
  })
  
  output$ibex_table = renderDataTable({
    
    ibex()
    
  },  options = list(searching = F,
                     dom = 't',
                     pagingType = "simple",
                     lengthMenu = 5,
                     pageLength = 15))
  
  
  output$ibex_updown = renderPlotly({
    
    p1 = ibex() %>% 
      arrange(desc(`+/- %`)) %>% 
      head(10) %>% 
      plot_ly(x = ~`+/- %`, 
              y = ~reorder(Name,`+/- %`), 
              name = "Up",
              type = "bar",
              marker = list(color = ' rgba(0, 141, 0, 0.5)',
                            line = list(color = 'rgba(0, 141, 0, 1)', width = 1))) %>% 
      layout(yaxis = list(showgrid = FALSE, showline = FALSE, showticklabels = TRUE, domain= c(0.1, 0.9)),
             xaxis = list(zeroline = FALSE, showline = FALSE, showticklabels = TRUE, domain= c(0, 0.85), showgrid = TRUE))
    
    p2 = ibex() %>% 
      arrange(`+/- %`) %>% 
      head(10) %>% 
      plot_ly(x = ~`+/- %`, 
              y = ~reorder(Name,`+/- %`), 
              hoverinfo = NULL,
              name = "Down",
              type = "bar",
              marker = list(color = ' rgba(255, 0, 0, 0.5)',
                            line = list(color = 'rgba(255, 0, 0, 1)', width = 1))) %>% 
      layout(yaxis = list(showgrid = FALSE, showline = FALSE, showticklabels = TRUE, domain= c(0.1, 0.9)),
             xaxis = list(zeroline = FALSE, showline = FALSE, showticklabels = TRUE, domain= c(0, 0.85), showgrid = TRUE))
    
    subplot(p2, p1)%>%
      layout(title = 'Ibex Stocks with greatest up & down',
             showlegend = FALSE,
             legend = list(x = 0.029, y = 1.038,
                           font = list(size = 10)),
             margin = list(l = 100, r = 20, t = 70, b = 70),
             paper_bgcolor = 'rgb(248, 248, 255)',
             plot_bgcolor = 'rgb(248, 248, 255)') %>%
      add_annotations(xref = 'paper', yref = 'paper',
                      x = 0, y = 0,
                      text = paste("Source: BME, Bolsa de Madrid"),
                      font = list(family = 'Arial', size = 10, color = 'rgb(150,150,150)'),
                      showarrow = FALSE)
    
  })
  
})


