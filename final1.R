#author: Nikhil Bendre, Justin Thomas 
#date: 05/01/2012
#Program to estimate the click through rates per position, depth, age, gender 


#Notes:
#1. doMC won't work on Windows since it doesnt have a windows binary
#2. bigmemory needs R version greater than 2.13.0, probably working on R-studio, solves this problem 


#Install R packages, 
# install.packages('bigmemory')
# install.packages('biganalytics')
# install.packages('doMC')
# install.packages('biglm')


#load all the libraries
library(bigmemory)
library(biganalytics)
library(doMC)
#specify the number of cores as arguement in registerDoMC()
registerDoMC(8)


#read the training data into a big.matrix
searchData <- read.big.matrix("/scratch/jt3/pdata/training.txt", header = TRUE, type = "integer",sep = "\t")

#To check the data
#head(searchData)

#read the user profile data into a big.matrix 
# this is the file we have got after preprocessing stage from Hadoop Streaming
userProfileData <- read.big.matrix("G:/partial/userid_profile1.txt", header = FALSE, type = "integer",sep = "\t")

#To check the data
#head(userProfileData)

#@nbendre
#calculates the Clicks per position
clickPerPosition <- function(clickValue,position,operator1,operator2) 
{
  value <- mwhich(searchData, c(1,7), list(clickValue, position), list(operator1,operator2), "AND")
}

#@nbendre
#calculates the Clicks per Depth
clickPerDepth <- function(clickValue,depth,operator1,operator2) 
{
  value <- mwhich(searchData, c(1,6), list(clickValue, depth), list(operator1,operator2), "AND")
}

#@nbendre 
#calculate the number of users per Gender 
#@nbendre
registerDoMC(8)
#-------------by DoMC ------------
 foreach(i=0:2, .combine=c) %dopar% {
    nGenderVal <- length(mwhich(userProfileData,2,i,"eq"))
}

#@nbendre 
#calculate the number of users per Gender 
#@nbendre
registerDoMC(8)
#-------------by DoMC ------------
 foreach(i=1:6, .combine=c) %dopar% {
    nGenderVal <- length(mwhich(userProfileData,3,i,"eq"))
}



#@nbendre
#caculating the clicks per position
#args: clickValue,positionNumber,Operator1,Operator2
#Operator1/2 args: 'eq', 'neq', 'le', 'lt', 'ge' and 'gt'
#The possible values of Position are 1,2 and 3.

registerDoMC(8)
# --------------- by doMC -------------------- 
 foreach(i=1:3, .combine=c) %dopar% {
    noPos <- length(clickPerPosition(0,i,"eq","eq"))
 }

registerDoMC(8)
# --------------- by doMC -------------------- 
 foreach(i=1:3, .combine=c) %dopar% {
    nPos <- length(clickPerPosition(0,i,"neq","eq"))
 }

#@nbendre
#caculating the clicks per depth
#args: clickValue,depthNumber,Operator1,Operator2
#Operator1/2 args: 'eq', 'neq', 'le', 'lt', 'ge' and 'gt'

registerDoMC(8)
# --------------- by doMC -------------------- 
 foreach(i=1:3, .combine=c ) %dopar% {
    noDep <- length(clickPerDepth(0,i,"eq","eq"))
 }	

registerDoMC(8)
# --------------- by doMC -------------------- 
 foreach(i=1:3, .combine=c ) %dopar% {
    nDep <- length(clickPerDepth(0,i,"neq","eq"))
 }	

# Calculating the linear regression 
# Click is the dependent variable, Position & Depth are independent variables

#allow the matrix to give column names 
options(bigmemory.allow.dimnames=TRUE)

#give letters to colnames
colnames(searchData) <- LETTERS[1:12]

#formula for linear regression on big matrix
blm <- biglm.big.matrix(A~F+G, data = searchData)
#display the linear regression summary 
summary(blm)


