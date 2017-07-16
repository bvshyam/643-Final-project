library(dplyr)

return_output <- function(method, userid, count) {

  if(method == 'content_category') {
  output = recommendation_list(userid,count) %>% merge(dfbooks,"ISBN")
  print(userid)
  }
  else if(method=='collabrative'){
    
  }
  else if(method=='content_decade'){
    
    
  }
      
  return(output)
    
    
}