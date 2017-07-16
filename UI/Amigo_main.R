

return_output <- function(method, userid, count) {

  if(method == 'content_category') {
  output = recommendation_list(userid,10) %>% merge(dfbooks,"ISBN")
  }
  else if(method=='collabrative'){
    
  }
  else if(method=='content_decade'){
    
    
  }
      
  return(output)
    
    
}