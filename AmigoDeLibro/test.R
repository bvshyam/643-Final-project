devtools::install_github("ggrothendieck/sqldf")


# Set the working directory
setwd("/Users/tulasiramarao/Documents/Tulasi/CUNYProjects/DATA643/RPrograms/AmigoDeLibro")

preddata <- read.csv("predictionsDBTable.csv", header = TRUE, sep =",", stringsAsFactors = FALSE)
colnames(preddata)
head(preddata)

preddata[preddata$ISBN == "114",]
preddata[preddata$ISBN == "160418X",]



str(preddata)
preddata <- preddata %>%
            order_by(ISBN)

preddata <- preddata[order(preddata[,3]),]

dfbooks <- read.csv("BX-CSV-Dump/BX-Books.csv", header = TRUE, sep =";", stringsAsFactors = FALSE)

colnames(dfbooks)
bookimages <- subset(dfbooks,select = c(1,8))


colnames(bookimages) <- c("ISBN","image")

head(bookimages )
write.csv(bookimages,file="bookimages.csv")

imagedata <- bookimages
url <- imagedata[imagedata$ISBN == "000160418X",]$image
url
str(imagedata)


#sqldf("select * from dfbooks ")
library(sqldf)
sqldf("select image from imagedata where ISBN LIKE '%160418X' ")

urlk <- gsub("\"","",url)
str(urlk)
