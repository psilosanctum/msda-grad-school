# required packages
library(AppliedPredictiveModeling)
library(caret) #train function
library(ISLR) #the stock market data
library(rpart)
library(ipred) #bagging
library(gbm) #boosting
library(randomForest) #random forest

#Access the data
attach(Smarket)

###Data splitting 
train = which(Year<2005)
Smarket.train= Smarket[train,]; # observations before 2005 are served as train data.
Smarket.test= Smarket[-train,]; # observations from 2005 are served as test data. 

### Create a control function that will be used across models. 
set.seed(100)
ctrl <- trainControl(method = "LGOCV",
                     summaryFunction = twoClassSummary,
                     classProbs = TRUE,
                     savePredictions = TRUE)

###############################Classification Trees#########################################

 set.seed(476)
 rpartTune<- train(x = as.matrix(Smarket.train[,1:8]),
               y = Smarket.train$Direction,
 method = "rpart",
 tuneLength = 30,
 metric = "ROC",
 trControl = ctrl)

 rpartTune
plot(rpartTune)

###############################Bagged Trees#########################################

set.seed(476)
treebagTune <- train(x = as.matrix(Smarket.train[,1:8]),
               y = Smarket.train$Direction,
                     method = "treebag",
                     nbagg = 50,
                     trControl = ctrl)

treebagTune

###############################Boosting#########################################
gbmGrid = expand.grid( interaction.depth = seq( 1, 7, by=2 ),
                       n.trees = seq( 100, 1000, by=100 ),
                       shrinkage = c(0.01, 0.1),
                       n.minobsinnode = 10 )

set.seed(476) 
gbmTune <- train(x = as.matrix(Smarket.train[,1:8]),
               y = Smarket.train$Direction,
                 method = "gbm",
                 tuneGrid = gbmGrid,
                 trControl = ctrl,
                 verbose = FALSE)
gbmTune

plot(gbmTune, auto.key = list(columns = 4, lines = TRUE))

gbmImp <- varImp(gbmTune, scale = FALSE)
plot(gbmImp)


##########################Random Forest######################################
mtryGrid <- data.frame(mtry = 1:8) #since we only have 8 predictors

### Tune the model using cross-validation
set.seed(476)
rfTune <- train(x = as.matrix(Smarket.train[,1:8]),
               y = Smarket.train$Direction,
                method = "rf",
                tuneGrid = mtryGrid,
                ntree = 200,
                importance = TRUE,
                trControl = ctrl)
rfTune

plot(rfTune)

###############################ROC curvers ######################
#library(pROC)

### Predict the test set based on four models
#Classification Trees
Smarket.test$rpart<- predict(rpartTune,Smarket.test, type = "prob")[,1]

#Bagged Trees
Smarket.test$treebag <- predict(treebagTune,Smarket.test, type = "prob")[,1]

#Boosting
Smarket.test$Boosting <- predict(gbmTune,Smarket.test, type = "prob")[,1]

#Random Forest
Smarket.test$RF <- predict(rfTune,Smarket.test, type = "prob")[,1]

#ROC for Classification Trees
RPARTROC <- roc(Smarket.test$Direction, Smarket.test$rpart)
plot(RPARTROC, col=1, lty=1, lwd=2)

#ROC for Bagged Trees
TREEBAGROC <- roc(Smarket.test$Direction, Smarket.test$treebag)
lines(TREEBAGROC, col=2, lty=2, lwd=2)

#ROC for Boosting
BoostingROC <- roc(Smarket.test$Direction, Smarket.test$Boosting)
lines(BoostingROC, col=3, lty=3, lwd=2)

#ROC for Random Forest
RFROC <- roc(Smarket.test$Direction, Smarket.test$RF)
lines(RFROC, col=4, lty=4, lwd=2)

legend('bottomright', c('RPART','Bagged Tree','Boosting','Random Forest'), col=1:8, lty=1:8,lwd=2)


#########################Create the confusion matrix from the test set######################
#Confusion matrix of Classification Trees
confusionMatrix(data = predict(rpartTune, Smarket.test), reference = Smarket.test$Direction)

#Confusion Matrix of Bagged Trees
confusionMatrix(data = predict(treebagTune, Smarket.test), reference = Smarket.test$Direction)

#Confusion matrix of Boosting
confusionMatrix(data = predict(gbmTune, Smarket.test), reference = Smarket.test$Direction)

#Confusion matrix of Random Forest
confusionMatrix(data = predict(rfTune, Smarket.test), reference = Smarket.test$Direction)



#Resamples of Tranining data
res = resamples(list(RPART = rpartTune, BaggedTree = treebagTune, 
Boosting = gbmTune, RF = rfTune ))
dotplot(res)

#We can add the models from chapters 12 and 13
res2 = resamples(list(Logistic = logisticTune, LDA =ldaTune,PLSDA = plsdaTune, 
Penalized = glmnTune, NSC = nscTune,QDA = QDATune, RDA =RDATune,MDA = MDATune, NB = NBTune, KNN = KNNTune, 
NN = NNTune, FDA = FDATune, SVM = SVMTune, RPART = rpartTune, BaggedTree = treebagTune, 
Boosting = gbmTune, RF = rfTune ))
dotplot(res2)








