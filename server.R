library(shiny)
library(rvest)
library(dplyr)
source("source/functions.R")

shinyServer(function(input, output) {

  ibex = reactive({
    
    ibex_page = read_html("http://www.bolsamadrid.es/esp/aspx/Mercados/Precios.aspx?indice=ESI100000000&punto=indice")
    
    ibex_page %>% 
      html_node(xpath = '//*[@id="ctl00_Contenido_tblAcciones"]') %>% 
      html_table() %>% 
      select(Nombre, Fecha, `Últ.`, Volumen, `% Dif.`) %>% 
      rename(Precio = `Últ.`,
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
  
})


