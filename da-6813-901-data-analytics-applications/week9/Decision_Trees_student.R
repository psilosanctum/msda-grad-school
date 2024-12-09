# Illustration of deicision trees 
# Use the tree package
# This is an example exercise taken from the book “An Introduction to Statistical Learning with Applications in R” 
# by Gareth James, Deniela Witten, Trever Hastie.
################################################################### 
# Fitting a classification tree -->
################################################################### 
# install.packages("tree")
# install.packages("ISLR")


library(tree)

library(ISLR)

# Have a look at the data. 
data("Carseats")

# See the data structure

# Create a binary response, since sales is coninuous. 
# I chose the mean (7.5) as the separator. 

# Grow a tree

# See the default output 

# See a summary of results

# Plot the tree 


#Estimate test error rate using validation set approach -->
  
# Create training and test sets

# Grow a tree using the training set 


# Get predictions on the test set


#Compute the confusion matrix 

# Perform cost complexity pruning by cross-validation (CV), using misclassification rate

# Note: k = alpha (pruning), dev = cross-validation error rate, size = size of tree -->

# Look at what is stored in the result object -->

# Plot the estimated test error rate

# Note that when k is small, size is large, and vice versa. 
# Get the best size 


#Get the pruned tree of the best size 


# Plot the pruned tree. Nine leaves. 

# Get predictions on the test set

# Get the confusion matrix  

# Compute the missclassification rate of a larger pruned tree for size 15.


# You can see the accuracy decreases on the testing data, as we use a larger size tree (alpha = k smaller)

################################################################### -->
# Fitting a regression tree -->
################################################################### 

library(MASS)

data(Boston)
# We will use the housing data from Boston. 

# Create training and test sets. 50/50 split.


# Grow a tree using the training set. Media value (medv) is the response. 


# Plot the tree 


# Perform cost complexity pruning by CV


# Plot the estimated test error rate 

# Note: Best size = 8 (i.e., no pruning) 
  
# If needed, pruning can be performed by specifying the "best" argument 


# Get predictions on the test data 



# Plot the observed values against the predicted values



# Compute the test error rate 


