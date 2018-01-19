## In  this demo we will familarize with the concept of "false positives"
## which have a prominent role in almost all "omic experiments"
## ... so most likely you will have to deal with it ...


## Data: we will generate the needed data inside R, we are not "loading" any type of data
## remember that when you eed to get the help for a specific R function ?NameOfTheFunction
## will do the trick 


## Data Generation
X <- matrix(rnorm(100000), nrow = 20, ncol = 5000)
## the command matrix creates a matrix of a given size
## the function rnorm extract 1000 random number from a normal distribution 
## of mean 0 and standard deviation 1


## Questions: 
# - how many samples?
# - how many variables?

dim(X) ## will tell us the size of the matrix 

## let's calculate the correlation among the variables
cormat <- cor(X)

dim(cormat)

## now I want to visualize the distribution of the correlation coefficients
## cormat is symmetric, this means that the correlation between varA and varB is
## the same that the one between varB and varA ... 
## moreover the correlation between varA and varA is 1.
## we need only the upper triagle of the matrix

utri <- cormat[upper.tri(cormat)]
## this seems apparently a strange command ... let's look to the help ;-)

## now it is time to look to the distribution of the correlation coefficients
hist(utri)

## Ok, you see, I have relatively high correlation values even though these are only random 
## numbers. Why? Is this surprising?

## let's look to a specific variable
hicorr <- which(cormat > 0.5, arr.ind = TRUE)
## plot a good couple
plot(X[,14],X[,44], type = "p")




## FOR YOU ##############################################################################
## 
## 1) Try to look to what happens to the histogram when you change the number of variables
##    pay attention! You should adjust also the number of rows and columns
## 2) In the typical case, false positives show up during statistical testing. Suppose that our 20 
##    samples are now belonging to two classes: the first ten are controls, the other treated. Try to
##    perform a serie of t-tests comparing them on all the variables. To do that you need some R 
##    ingredients

# X[1:10,] selects the first 10 rows of the matrix
# t.test   is the function to perform the test, look to the help to see how it works
# 
# ## is the structure used to perform 10 times the same thing ...
# for (i in 1:10) {
#   
# }






















