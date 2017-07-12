library(shiny)

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
      textInput("infeed", "ISBN/Title:", ""),
      
      # dropdown is too slow to load
     # uiOutput("choose_dataset"),
      
      submitButton("Submit")
    ),
    
    
    # Show the caption, a summary of the dataset and an HTML 
    # table with the requested number of observations
    mainPanel(
      
      h3(textOutput("Books recommeded for you", container = span)),
      
      #verbatimTextOutput("summary"), 
      
      tableOutput("view"),
     
      
      htmlOutput("html_link")
    )
  )
)