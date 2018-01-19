## In  this demo we will familarize some useful way to visualize your data
## looking to their specific peculiarity, with a particular eye on their
## distribution


## Data: 
## 1) RNAseq data 
## 2) MALDI-TOF spectral data of prostate cancer samples
## 3) Chemico-physical properties of a large datset of wines

## let'l load the data
load("rnaseq.RData")
load("prostate.RData")
load("wines.RData")

## to see what we actually loaded look to the "environment" tab of RStudio


## PROSTATE DATA ##########################################################
## this will give a fast summary of the complex object Prostate2000Raw
str(Prostate2000Raw)

## mz is a vector with the mass scale
## intensity is a matrix containing the intensities of the 10523 m/z over 654 samples

plot(x = Prostate2000Raw$mz, y = Prostate2000Raw$intensity[,20], type = "l")

## so we see how a single mass spectrum looks like ... le'ts use a for loop to 
## look to the range of the data

## initialize the vector which will contain the data
mymax <- rep(0,ncol(Prostate2000Raw$intensity))

## iteratively fill the fector with the maximum for each patient
for (i in 1:ncol(Prostate2000Raw$intensity)){
  mymax[i] <- max(Prostate2000Raw$intensity[,i])
}

## Show the maxima
plot(mymax)
## to see everything ...
matplot(Prostate2000Raw$mz, Prostate2000Raw$intensity, type = "l")
## it is taking a lot of time .... actually the object contains a lot of data!


## RNASQ DATA
## First of all let's look to the shape of the data matrix
dim(countsn)

## How man samples, and variables?
counts <- t(counts)

## how the matrix look like?
image(counts, axes = FALSE)
## log transof

## the technology is producing counts ... do we expect normal data?
## let's look to the distribution of the 98th var
hist(counts[,98])
## is it normal?
qqnorm(counts[,98]);qqline(counts[,98])
## No, but this is not unexpected 
## since the number of reads are counts ...

## also with this is not really better
qqnorm(log10(counts[,98]));qqline(log10(counts[,98]))

## let's dicuss why!

## WINES DATASET

## another time, how many samples? How many variables?
## you see here the situation is radically different, less variables than samples!
dim(wines)

## these are the variables
colnames(wines)

##  with only 13 variables we can also give a look to the summary
summary(wines)

## Three classes of wines and 177 samples, not really fat ...
## what we see: rather symmetric distributions, big variablity in 
## intensity 
hist(wines[,"tot. phenols"])
qqnorm(wines[,"tot. phenols"]);qqline(wines[,"tot. phenols"])
## not completely normal, in particular for the extreme values, 
## but at least symmetric
pairs(wines[,1:6], pch = as.numeric(vintages), col = as.numeric(vintages))

## too look to the individual intensities box plots are quite popular
boxplot(wines[,"alcohol"], col = "orange")
boxplot(wines[,"alcohol"]~vintages, col = "orange")

## NOTE! not good for small datasets!
stripchart(wines[,"alcohol"]~vintages,vertical=TRUE,method="jitter", 
            pch = c(1,2,3), col = c(1,2,3))


## FOR YOU
## - Visualize some of the other variables in the wine dataset
## - If you apply some transformation to the data (log10 or sqrt) are the q-q plots getting better?















