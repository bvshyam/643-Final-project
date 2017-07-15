library(shiny)
library(sqldf)

uti<- read.csv(file = "uti.csv", na.strings =c("", "NA"))
call <- data.frame(uti)
uti <- uti[,c(2,3,4,5)]
colnames(uti) <- c("userID","isbn","title","predictions")

preddataColla  <- uti
preddataContent <- uti # change to content one later

imagedata <- read.csv(file = "bookimages.csv", na.strings =c("", "NA"))
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
  
  
  
  # set data here 
  # datasetInput <- reactive({
  #  if( (input$dataset=="isbn") ) {
  #    #"isbn" = preddata
  #    mydata <- preddata[preddata$ISBN==input$infeed,]
  #    "isbn" = mydata
  #  }else{
  #    mydata <- preddata[preddata$title==input$infeed,]
  #    #"title" = preddata
  #    "title" = mydata
  #  }}
  #)
  
  
  
  # getch data here for dropdown ISBN
  # also add validation for errors
  datasetInputState <- reactive({
    validate(
      need(input$state != "", "Please select a isbn from ")
    )
    # removed preceeding zeros from ISBN
    myvar <-gsub("(^|[^0-9])0+", "\\1", input$state, perl = TRUE)
    if(input$recommender == "Collaborative")
      #statement <- paste("select isbn,predictions from predictionsColla where isbn LIKE \'%",
      #              myvar,"\'", sep="")
      statement <- paste("select isbn,predictions from predictionsColla where isbn LIKE \'%",
                         myvar,"\' and userID = ",input$stateuser, sep="")
    
    else
      #statement <- paste("select isbn,predictions from predictionsContent where isbn LIKE \'%",
      #                   myvar,"\'", sep="")
      statement <- paste("select isbn,predictions from predictionsContent where isbn LIKE \'%",
                         myvar,"\' and userID = ",input$stateuser, sep="")
    
    state <-sqldf(statement)
    
  })
  
  # get data here for dropdown Title
  # also add validation for errors
  datasetInputStatetitle <- reactive({
    validate(
      need(input$statetitle != "", "Please select a title")
    )
    myvar <-gsub("(^|[^0-9])0+", "\\1", input$statetitle, perl = TRUE)
    if(input$recommender == "Collaborative")
      statement <- paste("select title,predictions from predictionsColla where title LIKE \'%",
                         myvar,"\'", sep="")
    else
      statement <- paste("select title,predictions from predictionsContent where title LIKE \'%",
                         myvar,"\'", sep="")
    
    statetitle <-sqldf(statement)
    
  })
  
  
  # getch data here for dropdown User
  # also add validation for errors
  datasetInputStateUser <- reactive({
    validate(
      need(input$stateuser != "", "Please select a user from ")
    )
    myvar <-gsub("(^|[^0-9])0+", "\\1", input$stateuser, perl = TRUE)
    if(input$recommender == "Collaborative")
      statement <- paste("select ISBN,predictions from predictionsColla where userID LIKE \'%",
                         myvar,"\'", sep="")
    else
      statement <- paste("select ISBN,predictions from predictionsContent where userID LIKE \'%",
                         myvar,"\'", sep="")
    
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
  
  # output for the isbn 
  output$viewisbn <- renderTable({
    head(datasetInputState(), n = input$obs)
  },caption="<b> <span style='color:#48ca3b'>ISBNs Recommended:</b>",
  caption.placement = getOption("xtable.caption.placement", "top"), 
  caption.width = getOption("xtable.caption.width", NULL)
  )
  
  # output for the title 
  output$viewtitle <- renderTable({
    head(datasetInputStatetitle(), n = input$obs)
  },caption="<br><br><b> <span style='color:#48ca3b'>Titles Recommended: </b>",
  caption.placement = getOption("xtable.caption.placement", "top"), 
  caption.width = getOption("xtable.caption.width", NULL)
  )
  
  ## DONT DISPLAY THE USERS
  # output for the user 
  #  output$viewtitle <- renderTable({
  #    head(datasetInputStateUser(), n = input$obs)
  #  },caption="<br><br><b> <span style='color:#48ca3b'>Users Recommended: </b>",
  #  caption.placement = getOption("xtable.caption.placement", "top"), 
  #  caption.width = getOption("xtable.caption.width", NULL)
  #  )
  
  # dummy
  output$textEmpty <- renderText({
    paste("<b>","ISBN:", "</b>")
  })
  
  # dummy
  output$textEmpty2 <- renderText({
    paste("<br><b>","Title:", "</b>")
  })
  
  
}