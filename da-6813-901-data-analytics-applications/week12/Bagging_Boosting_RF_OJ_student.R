################################################################### 
# Fitting a classification tree 
################################################################### 

# install.packages("gbm")
# install.packages("ISLR")
# install.packages("randomForest")
# install.packages("tree")

# First let's fit a conventional decision tree. 

library(gbm)
library(ISLR)
library(randomForest)
library(tree)

# See the data
data("OJ")
View(OJ)
dim(OJ) 

# Create training and test sets
set.seed(1)
train <- 1:870
OJ.train <- OJ[train, ]
OJ.test <- OJ[-train, ]

# Build a tree


#See a summary of results 
summary(tree.OJ)

#Plot the tree
x11();plot(tree.OJ)
text(tree.OJ, pretty = 0, cex = 1.1)

#Perform cost complexity pruning by cross-validation


#Plot the estimated test error rate
par(mfrow = c(1,1))
x11();plot(cv.OJ$size, cv.OJ$dev, type = "b", xlab = "Tree size", ylab = "Deviance")

#Get the best size 

#Get the pruned tree of the best size 

# Plot the pruned tree
par(mfrow = c(1, 1)) 
x11();plot(prune.OJ)
text(prune.OJ, pretty = 0)

#Compare the training error rates between the pruned and unpruned trees. It is expected that the error will increase 
#in the training set, as pruning reduces the size of the tree. 
summary(tree.OJ)
summary(prune.OJ)

# test confusion matrix and error rates for the pruned tree


# Compute the error rates.


# test error rates for the unpruned tree


# Same error rates between two. However, pruned tree has less likelihood of overfitting, and therefore reduces the 
# likelihood of high variance when fitting the test data. 

######################################################################################

###### Next let's perform bagging using random forest.

#If a response vector is a factor, classification is assumed, otherwise regression is assumed.



# mtry is Number of variables randomly sampled as candidates at each split. Note that the default values 
# are different for classification (sqrt(p) where p is number of variables in x) and regression (p/3).
# ntree is the Number of trees to grow. This should not be set to too small a number, to ensure that every input row 
# gets predicted at least a few times. Importance is "Should importance of predictors be assessed?"


# Notice that our error rate went down in comparison to the pruned decision tree. 


#Get variable importance measure for each predictor 
importance(bag.OJ)
x11();varImpPlot(bag.OJ)

#
# Grow a random forest with default mtry. 


# Notice our error in this case increases, by going with the default mtry, which is the default number of splitting vars.


# We will look at doing a grid search over these hypoer parameters soon. 

# Get variable importance measure for each predictor -->
importance(bag.sqrt)
x11();varImpPlot(bag.sqrt)


# Boosting #  



# Perform boosting 
# We're using the bernouli distribution since the response is binary. If not specified, gbm will try to guess: 
# if the response has only 2 unique values, bernoulli is assumed; otherwise, if the response is a factor, multinomial 
# is assumed; otherwise, if the response has class "Surv", coxph is assumed; otherwise, gaussian is assumed.


# interaction.depth is Integer specifying the maximum depth of each tree (i.e., the highest level of variable interactions allowed). A value 
# of 1 implies an additive model, a value of 2 implies a model with up to 2-way interactions, etc. Default is 1.

# The predictions of each tree are added together sequentially.
# The contribution of each tree to this sum can be weighted to slow down the learning by the algorithm.
# This weigting is called the shrinkage or learning rate. 

# "It is important to know that smaller values of shrinkage (almost) always give improved predictive performance. 
# That is, setting shrinkage=0.001 will almost certainly result in a model with better out-of-sample predictive 
# performance than setting shrinkage=0.01. However, the model with shrinkage=0.001 will likely require ten times as many 
# iterations as the model with shrinkage=0.01" - Ridgeway.



# We can see that boosting did not reduce the test error rates, in fact it was one of the higher values. 



# Get variable importance measure for each predictor -->
x11();summary(boost.OJ1)

# Comparison:
# If the problem is that the model has high bias, Bagging won't help. However, Boosting could generate a combined model 
# with lower errors on the training set. 
# By contrast, if the difficulty is over-fitting, then Bagging is the best option. 
# Boosting doesn’t help avoid over-fitting. For this reason, Bagging is effective more often than Boosting.

# Tuning hyperparameters

# Establish a list of possible values for hyper-parameters



# Create a data frame containing all combinations 


# Create an empty vector to store OOB error values
oob_err <- c()

# Write a loop over the rows of hyper_grid to train the grid of models



# Identify optimal set of hyperparmeters based on OOB error


