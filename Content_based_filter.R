
#install.packages("randomForest")
library(randomForest)
library(tidyr)
library(stringr)
suppressWarnings(suppressMessages(library(sparklyr)))
suppressWarnings(suppressMessages(library(dplyr)))
suppressWarnings(suppressMessages(library(reshape2)))
suppressWarnings(suppressMessages(library(knitr)))
suppressWarnings(suppressMessages(library(recommenderlab)))
suppressWarnings(suppressMessages(library(recosystem)))
suppressWarnings(suppressMessages(library(irlba)))
suppressWarnings(suppressMessages(library(stringr))) # str_replace_all
suppressWarnings(suppressMessages(library(tictoc))) # timing



dfbookratings <- read.csv("data/BX-Book-Ratings.csv", header = TRUE, sep =";", stringsAsFactors = FALSE)

dfusers <- read.csv("data/BX-Users.csv", header = TRUE, sep =";", stringsAsFactors = FALSE)
dfbooks <- read.csv("data/BX-Books.csv", header = TRUE, sep =";", stringsAsFactors = FALSE)

bookdec <- read.csv("data/final_output.csv", header = TRUE, sep =",", stringsAsFactors = FALSE) %>% select(isbn,category)


dfbooks_filter <- bookdec %>% mutate(itemnum = row_number()) %>% mutate(reads = 1)


dfbooks_filter[is.na(dfbooks_filter)] = 'Unknown'


dfbooks_filter <- dfbooks_filter %>% select(isbn, itemnum,category,reads) %>% spread(category,reads)

dfbooks_filter[is.na(dfbooks_filter)]=0
# test1 <- dfbooks_filter
# 
# dfbooks_filter[is.na(dfbooks_filter)]=0
# 
# test <- test1 %>% select(c(3:144)) 
# 
# rowSums(test1)


colnames(dfbooks_filter)[1] = 'ISBN'

combinedData_filter <- merge(dfbookratings,dfusers, by=c("User.ID")) %>% select(User.ID,ISBN,Book.Rating)

combinedData_filter <- merge(combinedData_filter,dfbooks_filter, by=c("ISBN")) %>% select(-ISBN)


colnames(combinedData_filter)[1:3] <- c("userid","brating","itemid")#,"Fiction","Technology","Children","History","Geography")

head(combinedData_filter)

nrat = unlist(lapply(combinedData_filter$brating,function(x) {
  if(x>3) {return(1)}
  else {return(0)}
}))


combinedData_filter = cbind(nrat,combinedData_filter)

#test <- combinedData_filter %>% select[c(1,2,3,nrat)]


apply(combinedData_filter[,-c(2:4)],2,function(x) table(x))



scaled_rating <- scale(combinedData_filter[,-c(1,2,3,4)])

scaled_rating <- cbind(combinedData_filter[,c(1,2,3,4)],scaled_rating)

head(scaled_rating)


scaled_rating <- scaled_rating[,!apply(scaled_rating, 2, function(x) all(is.na(x)))] 

all_names <- colnames(scaled_rating)

all_names_correct <- str_replace_all(all_names,pattern = "[^[:alnum:]]",replacement = ".")

colnames(scaled_rating) = all_names_correct


##

set.seed(7)
which_train <- sample(x=c(T,F),size=nrow(scaled_rating),replace=T,prob=c(.9,.1))
train <- scaled_rating[which_train,] %>% select(-brating, -userid,-itemid)

test <- scaled_rating[!which_train,] %>% select(-brating, -userid,-itemid)


fit = randomForest(as.factor(nrat)~.,train)


summary(fit)

predictions = predict(fit,test)


head(predictions)

cm = table(predictions,test$nrat)

(accuracy <- sum(diag(cm))/sum(cm))

#Precision?
(precision <- diag(cm)/rowSums(cm))


#recall
(recall <- (diag(cm)/colSums(cm)))


head(dfbooks_filter)
totalbooks <- dfbooks_filter %>% select(ISBN) %>% unique()

head(totalbooks)


nonrated = function(userid) {
  
  (ratedbooks = dfbookratings[dfbookratings$User.ID ==276729 & dfbookratings$Book.Rating >0,] %>% select(ISBN) %>% unique())
  nonratedbooks = totalbooks[!totalbooks %in% ratedbooks] %>% data.frame()
  
  df = data.frame(cbind(rep))
  
}




head(ratedbooks)
nrow(ratedbooks)
head(nonratedbooks)
nrow(nonratedbooks)
nrow(dfbooks_filter)

head(dfbookratings)
head(totalbooks)
head(ratedbooks)
head(nonratedbooks)


head(totalbooks[dfbookratings$Book.Rating >0,])

nrow(dfbookratings)
nrow(totalbooks)
nrow(nonratedbooks)
nrow(dfbooks_filter)
