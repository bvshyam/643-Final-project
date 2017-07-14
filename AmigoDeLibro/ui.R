library(shiny)

titledata <- read.csv(file = "storeDBTitleISBN.csv", na.strings =c("", "NA"))
call <- data.frame(titledata)

titledata <- unique(titledata[,c(2,3)])
titledata  <- titledata [apply(titledata [c(1)],1,function(z) any(z!=0)),]
isbns <- unique(titledata$ISBN)
titles <- unique(titledata$title)


# Define UI for dataset viewer application
fluidPage(
  tags$style(HTML("
                  @import url('//fonts.googleapis.com/css?family=Lobster|Cabin:400,700');
                  
                  h1 {
                  font-family: 'Lobster', cursive;
                  font-weight: 500;
                  line-height: 1.1;
                  color: #48ca3b;
                  }
                  
                  ")),
  # Application title
  headerPanel("Amigo De Libro"),
  
  # Sidebar with controls to provide a caption, select a dataset,
  # and specify the number of observations to view. Note that
  # changes made to the caption in the textInput control are
  # updated in the output area immediately as you type
  sidebarLayout(
    sidebarPanel(
      selectInput("recommender", "Recommender:", 
                  choices = c("Collaborative", "Content")),
      
      # Selectize lets you create a default option for ISBN
      selectizeInput(
        'state', 'Choose an ISBN:', choices = isbns,
        options = list(
          placeholder = 'Please select an option below',
          onInitialize = I('function() { this.setValue(""); }')
        )
      ),
      
      # Selectize lets you create a default option for Title
      selectizeInput(
        'statetitle', 'Choose a Title:', choices = titles,
        options = list(
          placeholder = 'Please select an option below',
          onInitialize = I('function() { this.setValue(""); }')
        )
      ),
      
      # how many rows to view
      numericInput("obs", "Number of books to view:", 2),
      
      submitButton("Submit")
    ),
    
    
    # Show the caption, a summary of the dataset and an HTML 
    # table with the requested number of observations
    mainPanel(
      h3(textOutput("Please wait for a few seconds for the tables to load <br><br>")),

      # dummy
      htmlOutput("textEmpty"),
      # view the recommender by ISBN
      tableOutput("viewisbn"),
      # link for the isbn
      htmlOutput("html_link"),
      
      # dummy
      htmlOutput("textEmpty2"),
     
      # view the recommender by title
      tableOutput("viewtitle"),
      # link for the isbn
      htmlOutput("html_link2")
      
    )
  )
  )