library(shiny)
library(sqldf)

# Replace all these files once we have the prediction datasets
# load the necessary data
preddataColla <- read.csv(file = "predictionsColla.csv", na.strings =c("", "NA"))
call <- data.frame(preddataColla)

preddataContent <- read.csv(file = "predictionsContent.csv", na.strings =c("", "NA"))
call <- data.frame(preddataContent)

imagedata <- read.csv(file = "bookimages.csv", na.strings =c("", "NA"))
call <- data.frame(imagedata)


function(input, output) {

  # select only the needed columns and get only unique rows
  preddataColla <- unique(preddataColla[,c(2,3,4,5)])
  preddataContent <- unique(preddataContent[,c(2,3,4,5)])
  
  #userid zero ? remove the row
  preddataColla  <- preddata [apply(preddataColla [c(1)],1,function(z) any(z!=0)),]
  preddataContent  <- preddataContent [apply(preddataContent [c(1)],1,function(z) any(z!=0)),]
  
  # remove dups if any
  isbns <- unique( preddataColla$ISBN)
  titles <- unique( preddataColla$title)
  #titles <- order(titles)
 
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
        need(input$state != "", "Please select a valid isbn from ")
      )
      myvar <-gsub("(^|[^0-9])0+", "\\1", input$state, perl = TRUE)
      if(input$recommender == "Collaborative")
           statement <- paste("select ISBN,rating from preddataColla where ISBN LIKE \'%",
                         myvar,"\'", sep="")
      else
        statement <- paste("select ISBN,rating from preddataContent where ISBN LIKE \'%",
                           myvar,"\'", sep="")
      
      state <-sqldf(statement)

     })
  
    # get data here for dropdown Title
    # also add validation for errors
    datasetInputStatetitle <- reactive({
      validate(
        need(input$statetitle != "", "Please select a valid title")
      )
      myvar <-gsub("(^|[^0-9])0+", "\\1", input$statetitle, perl = TRUE)
      if(input$recommender == "Collaborative")
          statement <- paste("select title,rating from preddataColla where title LIKE \'%",
                         myvar,"\'", sep="")
      else
        statement <- paste("select title,rating from preddataContent where title LIKE \'%",
                           myvar,"\'", sep="")
      
      statetitle <-sqldf(statement)

    })
    
  
 output$caption <- renderText({
    input$caption
  })
  

 #Image link for isbn
  output$html_link <- renderUI({
   imgurl <- imagedata[imagedata$ISBN==input$state,]$image
    a("Picture of the book you chose.", 
      href=imgurl, target="_blank") 
  })
 
  #Image link for title
  output$html_link2 <- renderUI({
    imgurl <- imagedata[imagedata$title==input$statetitle,]$image
    a("Picture of the book you chose", 
      href=imgurl, target="_blank") 
  })
  
   
  # just a debug statement
  output$text <- renderText({
    paste("Input text is:", input$infeed)
  })
  
  # output of the isbn recommender
  output$viewisbn <- renderTable({
    head(datasetInputState(), n = input$obs)
  },caption="<b> <span style='color:#48ca3b'>ISBNs Recommended:</b>",
  caption.placement = getOption("xtable.caption.placement", "top"), 
  caption.width = getOption("xtable.caption.width", NULL)
  )
  
  # output of the title recommender
  output$viewtitle <- renderTable({
    head(datasetInputStatetitle(), n = input$obs)
  },caption="<br><br><b> <span style='color:#48ca3b'>Titles Recommended: </b>",
  caption.placement = getOption("xtable.caption.placement", "top"), 
  caption.width = getOption("xtable.caption.width", NULL)
  )
  
  # dummy
  output$textEmpty <- renderText({
    paste("<b>","ISBN:", "</b>")
  })
  
  # dummy
  output$textEmpty2 <- renderText({
    paste("<br><b>","Title:", "</b>")
  })
  
}