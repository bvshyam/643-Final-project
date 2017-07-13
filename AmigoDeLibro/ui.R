library(shiny)

titledata <- read.csv(file = "storeDBTitleISBN.csv", na.strings =c("", "NA"))
call <- data.frame(titledata)

titledata <- unique(titledata[,c(2,3)])
titledata  <- titledata [apply(titledata [c(1)],1,function(z) any(z!=0)),]
isbns <- unique(titledata$ISBN)


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
                  choices = c("User Based", "Item Based", "SVD")),
      
      selectInput("dataset", "Search by:", 
                  choices = c("isbn", "title")),
 
      numericInput("obs", "Number of books to view:", 10),
      textInput("infeed", "Enter ISBN/Title:", ""),
      
      # dropdown is too slow to load
     # uiOutput("choose_dataset"),
   
      selectInput("state", "Choose an ISBN:",  isbns),
      
      submitButton("Submit")
    ),
    
    
    # Show the caption, a summary of the dataset and an HTML 
    # table with the requested number of observations
    mainPanel(
      
      htmlOutput("html_link"),
      
      h3(textOutput("Books recommeded for you", container = span)),
      
      #verbatimTextOutput("summary"), 
      
      tableOutput("view"),
      tableOutput("viewisbn")
      
      
      
      
    )
  )
  )