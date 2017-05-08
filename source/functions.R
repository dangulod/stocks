sp_to_num = function(x = x) {

  require(dplyr)
  
  tonum_v = function(x = x) {
    
    if(is.numeric(x)) return(x)
    
    if(length(head(x[grepl(",|NA|\\.", x)], 50)) != min(length(x), 50)) {
      
      return(x)
      
    } else {
      
      x = gsub("\\.","", x)
      x = gsub(",","\\.", x)
      
      x = suppressWarnings(as.numeric(x))
      
      return(x)
    }
  }
  
  if (is.data.frame(x)) {
    
    x = bind_cols(lapply(x, function(x) tonum_v(x)))
    
  } else {
    
    x = tonum(x)
    
  }

  return(x)
  
}
