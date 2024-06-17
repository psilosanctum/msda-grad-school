#Chapter 7: Nonlinear regression models

#Required packages
library(AppliedPredictiveModeling)
library(caret)
library(earth)

### Load the data
data(solubility)

### Create a control function that will be used across models. We
### create the fold assignments explicitly instead of relying on the
### random number seed being set to identical values.

set.seed(100)
indx <- createFolds(solTrainY, returnTrain = TRUE)
ctrl <- trainControl(method = "cv", index = indx)

################################################################################
### Neural Networks

#Create a grid for tuning parameters 
nnetGrid <- expand.grid(decay = c(0, 0.01, .1), 
                        size = c(1, 3, 5, 7), 
                        bag = FALSE)

#It takes time run
##The following codes takes more than 6,000 seconds to run.
## Your running time may be different depending
## on your cpu. 

ptm <- proc.time() #takes more than 6,000 seconds to run in my computer
set.seed(100) 
nnetTune <- train(x = solTrainXtrans, y = solTrainY,
                  method = "avNNet",
                  tuneGrid = nnetGrid,
                  trControl = ctrl,
                  preProc = c("center", "scale"),
                  linout = TRUE,
                  trace = FALSE,
                  MaxNWts = 13 * (ncol(solTrainXtrans) + 1) + 13 + 1,
                  maxit = 1000,
                  allowParallel = FALSE)
nnetTune
proc.time() - ptm
### Stop the clock

plot(nnetTune)

#save the predicted values into testResults
testResults <- data.frame(obs = solTestY,
                          NNet = predict(nnetTune, solTestXtrans))

################################################################################
### Multivariate Adaptive Regression Splines

ptm <- proc.time() #takes 163 seconds to run in my computer
set.seed(100)
marsTune <- train(x = solTrainXtrans, y = solTrainY,
                  method = "earth",
                  tuneGrid = expand.grid(degree = 1, nprune = 2:38),
                  trControl = ctrl)
marsTune
proc.time() - ptm

plot(marsTune)

#Check the importance of each predictor
marsImp <- varImp(marsTune, scale = FALSE)
plot(marsImp, top = 10)

#save the predicted values into testResults
testResults$MARS <- predict(marsTune, solTestXtrans)


################################################################################
### Support Vector Machines

## In a recent update to caret, the method to estimate the
## sigma parameter was slightly changed. These results will
## slightly differ from the text for that reason.

#SVM with the radial basis function function 
ptm <- proc.time() # Takes 72.23 seconds in my computer
set.seed(100)
svmRTune <- train(x = solTrainXtrans, y = solTrainY,
                  method = "svmRadial",
                  preProc = c("center", "scale"),
                  tuneLength = 14,
                  trControl = ctrl)
svmRTune
proc.time() - ptm

plot(svmRTune, scales = list(x = list(log = 2)))                 

##save the predicted values into testResults
testResults$SVMr <- predict(svmRTune, solTestXtrans)

ptm <- proc.time() # takes 313.55 second to run
#SVM with the polynomial basis function 
svmGrid <- expand.grid(degree = 1:2, 
                       scale = c(0.01, 0.005, 0.001), 
                       C = 2^(-2:5))
set.seed(100)
svmPTune <- train(x = solTrainXtrans, y = solTrainY,
                  method = "svmPoly",
                  preProc = c("center", "scale"),
                  tuneGrid = svmGrid,
                  trControl = ctrl)

svmPTune
proc.time() - ptm

plot(svmPTune, 
     scales = list(x = list(log = 2), 
                   between = list(x = .5, y = 1)))                 

##save the predicted values into testResults
testResults$SVMp <- predict(svmPTune, solTestXtrans)

################################################################################
### K-Nearest Neighbors

### First we remove near-zero variance predictors
knnDescr <- solTrainXtrans[, -nearZeroVar(solTrainXtrans)]

ptm <- proc.time() # takes 39.86 seconds to run
set.seed(100)
knnTune <- train(x = knnDescr, y = solTrainY,
                 method = "knn",
                 preProc = c("center", "scale"),
                 tuneGrid = data.frame(k = 1:20),
                 trControl = ctrl)

knnTune
proc.time() - ptm

plot(knnTune)

testResults$Knn <- predict(knnTune, solTestXtrans[, names(knnDescr)])

#print out the predicted values based on different models
head(testResults)

#Performance of nonlinear models
set.seed(100) 
Nnet.pred = predict(nnetTune, solTestXtrans)
MARS.pred <- predict(marsTune, solTestXtrans)
SVMr.pred <- predict(svmRTune, solTestXtrans)
SVMp.pred <- predict(svmPTune, solTestXtrans)
Knn.pred <- predict(knnTune, solTestXtrans[, names(knnDescr)])

data.frame(rbind(NNET=postResample(pred=Nnet.pred,obs = solTestY),
                 MARS=postResample(pred=MARS.pred ,obs = solTestY),
                 SVMr=postResample(pred=SVMr.pred,obs = solTestY), 
                 SVMp=postResample(pred=SVMp.pred,obs = solTestY),
                 KNN=postResample(pred=Knn.pred,obs = solTestY) ))

