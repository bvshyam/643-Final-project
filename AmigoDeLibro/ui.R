library(shiny)
options(shiny.error = browser) # to view errors

# Replace all these files once we have the prediction datasets
# load the necessary data (user item title books)
preddataColla <- read.csv(file = "uti.csv", na.strings =c("", "NA"),sep=",")
call <- data.frame(preddataColla)
preddataColla <- preddataColla[,c(2,3,4,5)]
colnames(preddataColla) <- c("userID","isbn","title","moviesrecommended")

users <- unique(preddataColla$userID)
titles <- unique(preddataColla$title)
isbns <- unique(preddataColla$isbn)
moviesR <- unique(preddataColla$moviesrecommended)


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
                  choices = c("Content With Category", "Content Without Category")),
      

      # Selectize lets you create a default option for Title
      selectizeInput(
        'stateuser', 'First choose a User:', choices = users,
        options = list(
          placeholder = 'Please select an option below',
          onInitialize = I('function() { this.setValue(""); }')
        )
      ),
      
      
      # Selectize lets you create a default option for ISBN
      selectizeInput(
        'state', 'Now either choose an ISBN:', choices = isbns,
        options = list(
          placeholder = 'Please select an option below',
          onInitialize = I('function() { this.setValue(""); }')
        )
      ),
      
      # Selectize lets you create a default option for Title
      selectizeInput(
        'statetitle', 'or a Title:', choices = titles,
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
      #htmlOutput("html_link"),
      
      # dummy
      htmlOutput("textEmpty2") #,
      
      # view the recommender by title
      #tableOutput("viewtitle") #,
      # link for the isbn
      #htmlOutput("html_link2")
      
    )
  )
  )