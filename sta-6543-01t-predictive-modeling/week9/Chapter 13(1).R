# required packages
library(AppliedPredictiveModeling)
library(caret)
library(ISLR) #the stock market data
library(pROC) #roc
library(MASS) #lda
library(klaR) #rda
library(mda)  #mda
library(earth) #fda
library(e1071)
library(kernlab) #SVM


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

################################Quadratic discriminant analysis#################################
 set.seed(476)
 QDATune <- train(x = as.matrix(Smarket.train[,1:8]),
 y = Smarket.train$Direction,
 method = "qda",
 metric = "ROC",
 trControl = ctrl)
 QDATune 


#library(pROC)
### Predict the test set based the logistic regression 
Smarket.test$QDA <- predict(QDATune,Smarket.test, type = "prob")[,1]
#ROC for QDA model
QDAROC <- roc(Smarket.test$Direction, Smarket.test$QDA)
plot(QDAROC, col=1, lty=1, lwd=2)

#Confusion matrix of QDA model
confusionMatrix(data = predict(QDATune, Smarket.test), reference = Smarket.test$Direction)


###########################regularized discriminant analysis###################################
 set.seed(476)
 RDATune <- train(x = as.matrix(Smarket.train[,1:8]),
 y = Smarket.train$Direction,
 method = "rda",
 preProc = c('center', 'scale'),
 metric = "ROC",
 trControl = ctrl)
 RDATune

###################################mixture discriminant analysis####################### 
 set.seed(476)
 MDATune <- train(as.matrix(Smarket.train[,1:8]),
 y =  Smarket.train$Direction,
 method = "mda",
 tuneGrid = expand.grid(.subclasses = 3:10),
 metric = "ROC",
 trControl = ctrl)
 MDATune
 
###############################Naïve Bayes################################################
 set.seed(476)
 NBTune <- train(x = as.matrix(Smarket.train[,1:8]),
 y = Smarket.train$Direction,
 method = "nb",
 preProc = c('center', 'scale'),
 metric = "ROC",
 trControl = ctrl)
 NBTune

###############################K-nearest neighbors#########################################

 set.seed(1)
 KNNTune <- train(x = as.matrix(Smarket.train[,1:8]),
               y = Smarket.train$Direction,
 method = "knn",
 metric = "ROC",
 preProc = c("center", "scale"),
 tuneGrid = data.frame(.k =  seq(1,400, by=10)),
 trControl = ctrl)
 plot(KNNTune)


###############################Neural networks##############################################
 set.seed(476)
 nnetGrid <- expand.grid(.size = 1:10,
 .decay = c(0, .1, 1, 2))
 maxSize <- max(nnetGrid$.size)
 numWts <-200

 NNTune <- train(x = as.matrix(Smarket.train[,1:8]),
               y = Smarket.train$Direction,
 method = "nnet",
 metric = "ROC",
 preProc = c("center", "scale", "spatialSign"),
 tuneGrid = nnetGrid,
 trace = FALSE,
 maxit = 2000,
 MaxNWts = numWts,
 trControl = ctrl)
 NNTune
 plot(NNTune)


###############################Flexible discriminant analysis############################### 
 set.seed(476)
 FDATune <- train(x = as.matrix(Smarket.train[,1:8]),
 y = Smarket.train$Direction,
 method = "fda",
 preProc = c('center', 'scale'),
 metric = "ROC",
 trControl = ctrl)
 FDATune


###############################Support Vector Machines############################### 
set.seed(476)
sigmaRangeReduced <- sigest(as.matrix(Smarket.train[,1:8]))
svmRGridReduced <- expand.grid(.sigma = sigmaRangeReduced[1],
.C = 2^(seq(-4, 4)))
SVMTune <- train(x = as.matrix(Smarket.train[,1:8]),
               y = Smarket.train$Direction,
method = "svmRadial", #svmLinear #svmPoly
metric = "ROC",
preProc = c("center", "scale"),
tuneGrid = svmRGridReduced,
fit = FALSE,
trControl = ctrl)
SVMTune


###############################ROC curvers ######################
#library(pROC)

### Predict the test set based on eight models
#QDA
Smarket.test$QDA<- predict(QDATune,Smarket.test, type = "prob")[,1]

#RDA
Smarket.test$RDA <- predict(RDATune,Smarket.test, type = "prob")[,1]

#MDA
Smarket.test$MDA <- predict(MDATune,Smarket.test, type = "prob")[,1]

#NB
Smarket.test$NB <- predict(NBTune,Smarket.test, type = "prob")[,1]

#KNN
Smarket.test$KNN <- predict(KNNTune,Smarket.test, type = "prob")[,1]

#NN
Smarket.test$NN <- predict(NNTune,Smarket.test, type = "prob")[,1]

#FDA
Smarket.test$FDA <- predict(FDATune, Smarket.test, type = "prob")[,1]

#SVM
Smarket.test$SVM <- predict(SVMTune, Smarket.test[,1:8], type = "prob")[,1]


#ROC for QDA
QDAROC <- roc(Smarket.test$Direction, Smarket.test$QDA)
plot(QDAROC, col=1, lty=1, lwd=2)

#ROC for RDA
RDAROC <- roc(Smarket.test$Direction, Smarket.test$RDA)
lines(RDAROC, col=2, lty=2, lwd=2)

#ROC for MDA
MDAROC <- roc(Smarket.test$Direction, Smarket.test$MDA)
lines(MDAROC, col=3, lty=3, lwd=2)

#ROC for NB
NBROC <- roc(Smarket.test$Direction, Smarket.test$NB)
lines(NBROC, col=4, lty=4, lwd=2)

#ROC for KNN
KNNROC <- roc(Smarket.test$Direction, Smarket.test$KNN)
lines(KNNROC, col=5, lty=5, lwd=2)

#ROC for NN
NNROC <- roc(Smarket.test$Direction, Smarket.test$NN)
lines(NNROC, col=6, lty=6, lwd=2)

#ROC for FDA
FDAROC <- roc(Smarket.test$Direction, Smarket.test$FDA)
lines(FDAROC, col=7, lty=7, lwd=2)

#ROC for SVM
SVMROC <- roc(Smarket.test$Direction, Smarket.test$SVM)
lines(SVMROC, col=8, lty=8, lwd=2)

legend('bottomright', c('QDA','RDA','MDA','NV', 'KNN', 'NN', 'FDA','SVM'), col=1:8, lty=1:8,lwd=2)


#########################Create the confusion matrix from the test set######################
#Confusion matrix of QDA
confusionMatrix(data = predict(QDATune, Smarket.test), reference = Smarket.test$Direction)

#Confusion Matrix of RDA
confusionMatrix(data = predict(RDATune, Smarket.test), reference = Smarket.test$Direction)

#Confusion matrix of MDA
confusionMatrix(data = predict(MDATune, Smarket.test), reference = Smarket.test$Direction)

#Confusion matrix of NB
confusionMatrix(data = predict(NBTune, Smarket.test), reference = Smarket.test$Direction)

#Confusion matrix of KNN
confusionMatrix(data = predict(KNNTune, Smarket.test), reference = Smarket.test$Direction)

#Confusion matrix of NN
confusionMatrix(data = predict(NNTune, Smarket.test), reference = Smarket.test$Direction)

#Confusion matrix of FDA
confusionMatrix(data = predict(FDATune, Smarket.test), reference = Smarket.test$Direction)

#Confusion matrix of SVM
confusionMatrix(data = predict(SVMTune, Smarket.test[,1:8]), reference = Smarket.test$Direction)


#Resamples of Tranining data
res = resamples(list(QDA = QDATune, RDA =RDATune,MDA = MDATune, NB = NBTune, KNN = KNNTune, 
NN = NNTune, FDA = FDATune, SVM = SVMTune ))
dotplot(res)

#We can add the models from chapter 12
res1 = resamples(list(Logistic = logisticTune, LDA =ldaTune,PLSDA = plsdaTune, 
Penalized = glmnTune, NSC = nscTune,QDA = QDATune, RDA =RDATune,MDA = MDATune, NB = NBTune, KNN = KNNTune, 
NN = NNTune, FDA = FDATune, SVM = SVMTune ))
dotplot(res1)




