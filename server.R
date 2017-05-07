library(shiny)
library(rvest)
library(dplyr)

shinyServer(function(input, output) {

  ibex = reactive({
    
    ibex_page = read_html("http://www.bolsamadrid.es/esp/aspx/Mercados/Precios.aspx?indice=ESI100000000&punto=indice")
    
    ibex_page %>% 
      html_node(xpath = '//*[@id="ctl00_Contenido_tblAcciones"]') %>% 
      html_table() %>% 
      as.tbl()
    
  })
  
  output$ibex_table = renderDataTable({
    
    ibex()
    
  },  options = list(searching = F,
                     pagingType = "simple",
                     lengthMenu = 5,
                     pageLength = 15))
  
})
