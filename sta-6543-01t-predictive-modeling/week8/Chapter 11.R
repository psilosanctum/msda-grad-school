library(AppliedPredictiveModeling)
library(randomForest)

### Simulate some two class data with two predictors
set.seed(975)
training <- quadBoundaryFunc(500)
testing <- quadBoundaryFunc(1000)
testing$class2 <- ifelse(testing$class == "Class1", 1, 0)
testing$ID <- 1:nrow(testing)

#Scatter plot
xyplot(X1~ X2, groups=class, data=training)

### Fit three models: QDA, RM, Logistic 

################################## QDA ###################################
library(MASS)
set.seed(1)
qdaFit <- qda(class ~ X1 + X2, data = training)

################################## RM ###################################
library(randomForest)
set.seed(1)
rfFit <- randomForest(class ~ X1 + X2, data = training, ntree = 2000)

################################## Logistic ###################################
glmFit <- train(class ~ X1 + X2,
                     data = training,
                     method = "glm",
                     trControl = trainControl(method = "repeatedcv", 
                                              repeats = 5))



### Predict the test set based on three models
testing$qda <- predict(qdaFit, testing)$posterior[,1]
testing$rf <- predict(rfFit, testing, type = "prob")[,1]
testing$glm <- predict(glmFit, testing, type = "prob")[,1]

### Create the confusion matrix from the test set.

#Confusion Matrix of qda Fit
confusionMatrix(data = predict(qdaFit, testing, type = "prob")$class, reference = testing$class)

#Confusion matrix of random forest
confusionMatrix(data = predict(rfFit, testing), reference = testing$class)

#Confusion matrix of logistic 
confusionMatrix(data = predict(glmFit, testing), reference = testing$class)

### ROC curves:
### Like glm(), roc() treats the last level of the factor as the event
### of interest so we use relevel() to change the observed class data

library(pROC)
#ROC for QDA
qdaROC <- roc(testing$class, testing$qda)
plot(qdaROC, col=1, lty=1)

#ROC for Random forest
rfROC <- roc(testing$class,testing$rf)
lines(rfROC, col=2, lty=2)

#ROC for GLM
glmROC <- roc(testing$class, testing$glm)
lines(glmROC, col=3, lty=3)
legend('bottomright', c('QDA','RF','GLM'), col=1:3, lty=1:3,lwd=2)





