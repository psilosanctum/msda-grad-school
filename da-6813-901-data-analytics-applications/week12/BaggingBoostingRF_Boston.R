################################################################### 
# Bagging and random forest #  
###################################################################

# Illustration using randomForest package and Boston data
library(randomForest)
library(MASS)

data(Boston)
# Perform bagging (i.e., random forest with m = p = 13) 
set.seed(1)
train  = sample(1:nrow(Boston), nrow(Boston)/2)

bag.boston <- randomForest(medv ~ ., data = Boston, subset = train, 
                           mtry = 13, ntree = 500, importance = TRUE)
bag.boston


# Estimate test error rate
yhat.bag <- predict(bag.boston, newdata = Boston[-train, ])
boston.test <- Boston[-train, "medv"]
mean((yhat.bag - boston.test)^2)


# Compare observed and fitted values
plot(yhat.bag, boston.test)
abline(0, 1)

# Grow a random forest 
# (Default m = p/3 for regression and sqrt(p) for classification)
set.seed(1)
rf.boston <- randomForest(medv ~ ., data = Boston, subset = train, 
                          mtry = 6, ntree = 500, importance = TRUE)


# Estimate test error rate 
yhat.rf = predict(rf.boston, newdata = Boston[-train, ])
mean((yhat.rf - boston.test)^2)


# Get variable importance measure for each predictor 
importance(rf.boston)


# Be sure to look at ?importance 
# Note: 1 = mean decrease in accuracy, 2 = mean decrease in node impurity (RSS) 
varImpPlot(rf.boston)

################################################################### 
# Boosting #  
################################################################### 

# Illustration using gbm package and Boston data

library(gbm)

# Fit a boosted regression tree 
set.seed(1)
boost.boston <- gbm(medv ~ ., data = Boston[train, ], distribution = "gaussian", 
                    n.trees = 5000, interaction.depth = 4)


# Get the relative influence plot 
summary(boost.boston)


# Get the partial dependence plot of selected variables on response 
par(mfrow = c(1, 2))
plot(boost.boston, i = "rm")
plot(boost.boston, i = "lstat")


# Estimate test error rate for the boosted model 
yhat.boost <- predict(boost.boston, newdata = Boston[-train, ], 
                      n.trees = 5000)
mean((yhat.boost - boston.test)^2)


# Perform boosting with a different value of lambda 
boost.boston <- gbm(medv ~ ., data = Boston[train, ], distribution = "gaussian", 
                    n.trees = 5000, interaction.depth = 4, shrinkage = 0.01, verbose = F)
yhat.boost <- predict(boost.boston, newdata = Boston[-train, ], 
                      n.trees = 5000)
mean((yhat.boost - boston.test)^2)



