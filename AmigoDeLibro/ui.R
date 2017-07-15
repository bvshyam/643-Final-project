library(shiny)

# Set the working directory
setwd("/Users/tulasiramarao/Documents/Tulasi/CUNYProjects/DATA643/RPrograms/AmigoDeLibro")

# Replace all these files with the ones from prediction 
# load the necessary data
preddataColla1 <- read.csv(file = "predictionsColla.csv", na.strings =c("", "NA"))
call <- data.frame(preddataColla1)
#colnames(preddataColla1)

preddataContent1 <- read.csv(file = "predictionsContent.csv", na.strings =c("", "NA"))
call <- data.frame(preddataContent1)


users <- read.csv(file = "users.csv", na.strings =c("", "NA"))
call <- data.frame(users)

isbns <- read.csv(file = "isbns.csv", na.strings =c("", "NA"))
call <- data.frame(isbns)

titles <- read.csv(file = "titles.csv", na.strings =c("", "NA"))
call <- data.frame(titles)

users <- subset(users,select = c(2))
colnames(users) <- c("user")

isbns <- subset(isbns,select = c(2))
colnames(isbns) <- c("isbn")

titles <- subset(titles,select = c(2))
colnames(titles) <- c("title")

# Extract isbn and title
#titledata <- unique(preddataColla1[,c(3,4)])
#colnames(titledata) <- c("ISBN","title")
#titledata  <- titledata [apply(titledata [c(1)],1,function(z) any(z!=0)),]
#isbns <- unique(titledata$ISBN)
#titles <- unique(titledata$title)


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
      numericInput("obs", "Enter the number of books to view:", 2),
      
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
      htmlOutput("textEmpty2"),
     
      # view the recommender by title
      tableOutput("viewtitle") #,
      # link for the isbn
      #htmlOutput("html_link2")
      
    )
  )
  )