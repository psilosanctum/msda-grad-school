# required packages
library(AppliedPredictiveModeling)
library(caret)
library(ISLR) #the stock market data
library(pROC) #roc
library(MASS) #lda
library(glmnet)

### The Stock Market Data ####
# the Smarket data is part of the ISLR library. 
# This data set consists of percentage returns for the S&P 500 stock index
# over 1250 days, from the beginning of 2001 until the end of 2005. 
# For each date, we have recorded the percentage returns for 
# each of the five previous trading days, Lag1 through Lag5. 
# We have also recorded Volume (the number of shares traded on the previous day, in billions),
# Today (the percentage return on the date in question) 
# and Direction (whether the market was Up or Down on this date).

#Data information 
head(Smarket)
names(Smarket)
dim(Smarket)
summary(Smarket);
cor(Smarket); # pairwise correlations for numerical predictors
cor(Smarket[,-9]); ## The only substantial correlation is between Year and Volume. 
attach(Smarket)
plot(Volume);

###Data splitting 
train = which(Year<2005)
Smarket.train= Smarket[train,]; # observations before 2005 are served as test data.
Smarket.test= Smarket[-train,]; # observations from 2005 are served as test data. 

### Create a control function that will be used across models. 
set.seed(100)
ctrl <- trainControl(method = "LGOCV",
                     summaryFunction = twoClassSummary,
                     classProbs = TRUE,
                     savePredictions = TRUE)

################################## Logistic Regression ###################################
 set.seed(476)
 logisticTune <- train(x = as.matrix(Smarket.train[,1:8]),
 y = Smarket.train$Direction,
 method = "glm",
 metric = "ROC",
 trControl = ctrl)
 logisticTune 

 ### Save the test set results in a data frame                 
 testResults <- data.frame(obs = Smarket.test$Direction,
                          logistic = predict(logisticTune, Smarket.test))

#library(pROC)
### Predict the test set based the logistic regression 
Smarket.test$logistic <- predict(logisticTune,Smarket.test, type = "prob")[,1]
#ROC for logistic model
logisticROC <- roc(Smarket.test$Direction, Smarket.test$logistic)
plot(logisticROC, col=1, lty=1, lwd=2)

#Confusion matrix of logistic model
confusionMatrix(data = predict(logisticTune, Smarket.test), reference = Smarket.test$Direction)


################################## LDA ###################################
 set.seed(476)
 ldaTune <- train(x = as.matrix(Smarket.train[,1:8]),
 y = Smarket.train$Direction,
 method = "lda",
 preProc = c('center', 'scale'),
 metric = "ROC",
 trControl = ctrl)
 ldaTune

 ### Save the test set results in a data frame  
 testResults$LDA <- predict(ldaTune, Smarket.test)

###################################Partial least squares discriminant analysis ###################################
 set.seed(476)
 plsdaTune <- train(x = Smarket.train[,1:8],
 y = Smarket.train$Direction,
 method = "pls",
 tuneGrid = expand.grid(.ncomp = 1:5),
 trControl = ctrl)

 plsdaTune

 ### Save the test set results in a data frame  
 testResults$plsda <- predict(plsdaTune, Smarket.test)


###################################Penalized Models ###################################
 glmnGrid <- expand.grid(.alpha = c(0, .1, .2, .4, .6, .8, 1),
 .lambda = seq(.01, .2, length = 40))
 set.seed(476)
 glmnTune <- train(as.matrix(Smarket.train[,1:8]),
 y =  Smarket.train$Direction,
 method = "glmnet",
 tuneGrid = glmnGrid,
 metric = "ROC",
 trControl = ctrl)
 plot(glmnTune)
 
 ### Save the test set results in a data frame  
 testResults$glmn <- predict(glmnTune, Smarket.test)


###############################Nearest Shrunken Centroids######################
nscGrid <- data.frame(.threshold = 0:25)
nscTune <- train(x = as.matrix(Smarket.train[,1:8]),
 y = Smarket.train$Direction,
method = "pam",
 preProc = c("center", "scale"),
 tuneGrid = nscGrid,
 metric = "ROC",
trControl = ctrl)

nscTune
plot(nscTune)

#variale importance 
plot(varImp(nscTune, scale =FALSE))


 ### Save the test set results in a data frame  
 testResults$NSC <- predict(nscTune, Smarket.test)


###############################ROC curvers ######################
#library(pROC)

### Predict the test set based on five models
#logistic 
Smarket.test$logistic <- predict(logisticTune,Smarket.test, type = "prob")[,1]
#LDA
Smarket.test$lda <- predict(ldaTune,Smarket.test, type = "prob")[,1]

#PLSDA
Smarket.test$plsda <- predict(plsdaTune,Smarket.test, type = "prob")[,1]

#Penalized model
Smarket.test$glmn <- predict(glmnTune,Smarket.test, type = "prob")[,1]

#NSC
Smarket.test$nsc <- predict(nscTune,Smarket.test, type = "prob")[,1]

#ROC for logistic model
logisticROC <- roc(Smarket.test$Direction, Smarket.test$logistic)
plot(logisticROC, col=1, lty=1, lwd=2)

#ROC for LDA
ldaROC <- roc(Smarket.test$Direction, Smarket.test$lda)
lines(ldaROC, col=2, lty=2, lwd=2)

#ROC for PLSDA
plsdaROC <- roc(Smarket.test$Direction, Smarket.test$plsda)
lines(plsdaROC, col=3, lty=3, lwd=2)

#ROC for penalized model
plsdaROC <- roc(Smarket.test$Direction, Smarket.test$glmn)
lines(plsdaROC, col=4, lty=4, lwd=2)


#ROC for NSC
plsdaROC <- roc(Smarket.test$Direction, Smarket.test$nsc)
lines(plsdaROC, col=5, lty=5, lwd=2)

legend('bottomright', c('logistic','lda','plsda','penalized model', 'nsc'), col=1:5, lty=1:5,lwd=2)


#########################Create the confusion matrix from the test set######################
#Confusion matrix of logistic model
confusionMatrix(data = predict(logisticTune, Smarket.test), reference = Smarket.test$Direction)

#Confusion Matrix of lda model
confusionMatrix(data = predict(ldaTune, Smarket.test), reference = Smarket.test$Direction)

#Confusion matrix of partial least squares discriminant analysis
confusionMatrix(data = predict(plsdaTune, Smarket.test), reference = Smarket.test$Direction)

#Confusion matrix of penalized models
confusionMatrix(data = predict(glmnTune, Smarket.test), reference = Smarket.test$Direction)

#Confusion matrix of nearest shrunken centroids
confusionMatrix(data = predict(nscTune, Smarket.test), reference = Smarket.test$Direction)

#Resamples of Tranining data
res = resamples(list(Logistic = logisticTune, LDA =ldaTune,PLSDA = plsdaTune, 
Penalized = glmnTune, NSC = nscTune ))
dotplot(res)


dotplot(res,metric="ROC")




