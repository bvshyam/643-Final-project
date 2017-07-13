library(shiny)

preddata <- read.csv(file = "predictionsDBTable.csv", na.strings =c("", "NA"))
call <- data.frame(preddata)

titledata <- read.csv(file = "storeDBTitleISBN.csv", na.strings =c("", "NA"))
call <- data.frame(titledata)

imagedata <- read.csv(file = "bookimages.csv", na.strings =c("", "NA"))
call <- data.frame(imagedata)

combinedData <- merge(preddata,titledata, by=c("ISBN"))


# Define server logic required to summarize and view the selected
# dataset
function(input, output) {
  
  # By declaring datasetInput as a reactive expression we ensure 
  # that:
  #
  #  1) It is only called when the inputs it depends on changes
  #  2) The computation and result are shared by all the callers 
  #	  (it only executes a single time)
  #
  titledata <- unique(titledata[,c(2,3)])
  preddata <- unique(preddata[,c(2,3,4)])
  #userid zero ? remove the row
  titledata  <- titledata [apply(titledata [c(1)],1,function(z) any(z!=0)),]
  preddata  <- preddata [apply(preddata [c(1)],1,function(z) any(z!=0)),]
  
  
  isbns <- unique(titledata$ISBN)
  titles <- unique(titledata$title)
  
  #isbns <- order(as.character(isbns))
  #isbns<-order(-isbns)
  titles <- order(titles)
  
  # Drop-down selection box for which data set
  output$choose_dataset <- renderUI({
    if( (input$dataset=="isbn") ) {
      selectInput("dataset", "Or choose a value", as.list(isbns))
    }else{
      selectInput("dataset", "Or choose a value", as.list(title))
    }
    
  })
  
  
  
  #datasetInput <- reactive({
  #  switch(input$dataset,
  #         "isbn" = preddata,
  #         "title" = titledata)
  #})
  
  # set data here 
  datasetInput <- reactive({
    if( (input$dataset=="isbn") ) {
      #"isbn" = preddata
      mydata <- preddata[preddata$ISBN==input$infeed,]
      "isbn" = mydata
    }else{
      mydata <- preddata[preddata$title==input$infeed,]
      #"title" = preddata
      "title" = mydata
    }
    
    #  switch(input$dataset,
    #         "isbn" = preddata[preddata$ISBN==input$infeed,],
    #         "title" = preddata[preddata$title==input$infeed,])
  })
  
  
  # The output$caption is computed based on a reactive expression
  # that returns input$caption. When the user changes the
  # "caption" field:
  #
  #  1) This function is automatically called to recompute the 
  #     output 
  #  2) The new caption is pushed back to the browser for 
  #     re-display
  # 
  # Note that because the data-oriented reactive expressions
  # below don't depend on input$caption, those expressions are
  # NOT called when input$caption changes.
  output$caption <- renderText({
    input$caption
  })
  
  # The output$summary depends on the datasetInput reactive
  # expression, so will be re-executed whenever datasetInput is
  # invalidated
  # (i.e. whenever the input$dataset changes)
  output$summary <- renderPrint({
    dataset <- datasetInput()
    summary(dataset)
  })
  
  
  output$html_link <- renderUI({
    imgurl <- imagedata[imagedata$ISBN==input$infeed,]$image
    if(is.null(imgurl))
       return(list(imgurl=""))
    
    #imgurl <- paste("https://isbnsearch.org/isbn/","",input$infeed)
    a("Find out more about the book here", 
      href=imgurl, target="_blank") 
  })
  
  
  
  # The output$view depends on both the databaseInput reactive
  # expression and input$obs, so will be re-executed whenever
  # input$dataset or input$obs is changed. 
  output$view <- renderTable({
    head(datasetInput(), n = input$obs)
  })
  
  output$text <- renderText({
    paste("Input text is:", input$infeed)
  })
  
}