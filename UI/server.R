#install.packages("sqldf")
library(shiny)
library(sqldf)


source("Amigo_main.R")

options(shiny.error = browser) # to view errors

uti<- read.csv(file = "uti.csv", na.strings =c("", "NA"))
uti <- uti[,c(2,3,4,5)]
call <- data.frame(uti)
colnames(uti) <- c("userID","isbn","title","moviesrecommended")
#make copies
predictionsContentCat  <- uti
predictionsContent <- uti # change to content one later

#imagedata <- read.csv(file = "bookimages.csv", na.strings =c("", "NA"))
#call <- data.frame(imagedata)


function(input, output) {

  # ISBN dropbox 
  output$result <- renderText({
    paste("You chose", input$state)
  })
  
  #Title dropbox
  output$result <- renderText({
    paste("You chose", input$statetitle)
  })
 
  # get data here for dropdown ISBN
  # also add validation for errors
  datasetInputState <- reactive({
    validate(
      need(input$state != "", "Please select a value from the drop down lists on the left ")
    )
    # removed preceeding zeros from ISBN
    myvar <-gsub("(^|[^0-9])0+", "\\1", input$state, perl = TRUE)
    if(input$recommender == "Content With Category")
      #statement <- paste("select isbn,predictions from predictionsContentCat where isbn LIKE \'%",
      #              myvar,"\'", sep="")
      statement <- paste("select moviesrecommended from predictionsContentCat where isbn LIKE \'%",
                         myvar,"\' and userID = ",input$stateuser, sep="")
    
    else
      #statement <- paste("select isbn,predictions from predictionsContent where isbn LIKE \'%",
      #                   myvar,"\'", sep="")
      statement <- paste("select moviesrecommended from predictionsContent where isbn LIKE \'%",
                         myvar,"\' and userID = ",input$stateuser, sep="")
      state <-sqldf(statement)
   
  })
  

  output$caption <- renderText({
    input$caption
  })
  
  
  #Image link for isbn
  #  output$html_link <- renderUI({
  #   imgurl <- imagedata[imagedata$ISBN==input$state,]$image
  #    a("Picture of the book you chose.", 
  #      href=imgurl, target="_blank") 
  #  })
  
  #Image link for title
  #  output$html_link2 <- renderUI({
  #    imgurl <- imagedata[imagedata$title==input$statetitle,]$image
  #    a("Picture of the book you chose", 
  #      href=imgurl, target="_blank") 
  #  })
  
  
  # just a debug statement
  output$text <- renderText({
    paste("Input text is:", input$infeed)
  })
  
  #output for the isbn
  output$viewisbn <- renderTable({
    head(datasetInputState(), n = input$obs)
  },caption="<b> <span style='color:#48ca3b'>Movies Recommended:</b>",
  caption.placement = getOption("xtable.caption.placement", "top"),
  include.rownames=FALSE,
  caption.width = getOption("xtable.caption.width", NULL)
  )
  
  
  # output$viewisbn <- renderUI({
  #   
  #   #return_output(input$recommender,input$stateuser,input$obs)
  #   return_output("content_category",26,2)
  # }) 
  # 

  # dummy
  #output$textEmpty <- renderText({
  #  paste("<b>","ISBN:", "</b>")
  #})
  
  
  
}