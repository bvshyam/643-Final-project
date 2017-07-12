
# Set the working directory
setwd("/Users/tulasiramarao/Documents/Tulasi/CUNYProjects/DATA643/RPrograms/AmigoDeLibro")

preddata <- read.csv("predictionsDBTable.csv", header = TRUE, sep =",", stringsAsFactors = FALSE)
colnames(preddata)
head(preddata)

preddata[preddata$ISBN == "114",]

str(preddata)
preddata <- preddata %>%
            order_by(ISBN)

preddata <- preddata[order(preddata[,3]),]