################################################################################
### Load packages
library(AppliedPredictiveModeling)
library(caret)
library(ISLR) #access the Hitters data
library(tree)
library(rpart)
library(partykit)
 
### Load the data
data(solubility)

### Create a control function that will be used across models. We
### create the fold assignments explicitly instead of relying on the
### random number seed being set to identical values.

set.seed(100)
indx <- createFolds(solTrainY, returnTrain = TRUE)
ctrl <- trainControl(method = "cv", index = indx)
?trainControl

################################################################################
### Basic Regression Trees

#library(rpart)

ptm <- proc.time() #takes 3.92 seconds to run in my computer
set.seed(100)
cartTune <- train(x = solTrainXtrans, y = solTrainY,
                  method = "rpart",
                  tuneLength = 25,
                  trControl = ctrl)
cartTune
## cartTune$finalModel
proc.time() - ptm

### Plot the tuning results
### Cross-validated RMSE profile for the regression tree
plot(cartTune, scales = list(x = list(log = 10)))

### Use the partykit package to make some nice plots. First, convert
### the rpart objects to party objects.
# install.packages('partykit')
#library(partykit)
 
cartTree <- as.party(cartTune$finalModel)
plot(cartTree)

### Get the variable importance. 'competes' is an argument that
### controls whether splits not used in the tree should be included
### in the importance calculations.

cartImp <- varImp(cartTune, scale = FALSE, competes = FALSE)
cartImp
plot(cartImp,20)

### Save the test set results in a data frame                 
testResults <- data.frame(obs = solTestY,
                          CART = predict(cartTune, solTestXtrans))

ptm <- proc.time() #takes 7.00 seconds to run in my computer
set.seed(100)
### Tune the conditional inference tree
cGrid <- data.frame(mincriterion = sort(c(.95, seq(.75, .99, length = 2))))

ctreeTune <- train(x = solTrainXtrans, y = solTrainY,
                   method = "ctree",
                   tuneGrid = cGrid,
                   trControl = ctrl)
ctreeTune
proc.time() - ptm
### Stop the clock

plot(ctreeTune)
##ctreeTune$finalModel               
plot(ctreeTune$finalModel)

### Save the test set results in a data frame  
testResults$cTree <- predict(ctreeTune, solTestXtrans)

################################################################################
### Bagged Trees

### Optional: parallel processing can be used via the 'do' packages,
### such as doMC, doMPI etc. We used doMC (not on Windows) to speed
### up the computations.

### WARNING: Be aware of how much memory is needed to parallel
### process. It can very quickly overwhelm the available hardware. The
### estimate of the median memory usage (VSIZE = total memory size) 
### was 9706M for a core, but could range up to 9706M. This becomes 
### severe when parallelizing randomForest() and (especially) calls 
### to cforest(). 

### WARNING 2: The RWeka package does not work well with some forms of
### parallel processing, such as mutlicore (i.e. doMC).

#library(doMC)
#registerDoMC(5)

ptm <- proc.time() #takes 26.92 seconds to run in my computer
set.seed(100)
treebagTune <- train(x = solTrainXtrans, y = solTrainY,
                     method = "treebag",
                     nbagg = 50,
                     trControl = ctrl)

treebagTune
proc.time() - ptm
### Stop the clock

### Save the test set results in a data frame  
testResults$Bagged <- predict(treebagTune, solTestXtrans)


################################################################################
### Boosting
#having three tuning parameter: the number of trees K
# the shrikage paraemter lambda (small values)
#the number d splits in each tree
gbmGrid = expand.grid( interaction.depth = seq( 1, 7, by=2 ),
                       n.trees = seq( 100, 1000, by=100 ),
                       shrinkage = c(0.01, 0.1),
                       n.minobsinnode = 10 )
#n.minobsinnode the splitting of nodes can cease 
#when a certain number of observations (default = 10) are in each node

ptm <- proc.time() #takes 463.26 seconds to run in my computer
set.seed(100)
gbmTune <- train(x = solTrainXtrans, y = solTrainY,
                 method = "gbm",
                 tuneGrid = gbmGrid,
                 trControl = ctrl,
                 verbose = FALSE)
gbmTune
proc.time() - ptm
### Stop the clock

plot(gbmTune, auto.key = list(columns = 4, lines = TRUE))

### Save the test set results in a data frame  
testResults$Boosting <- predict(gbmTune, solTestXtrans)

################################################################################
###  Random Forests

mtryGrid <- data.frame(mtry = floor(seq(10, ncol(solTrainXtrans), length = 10)))

ptm <- proc.time() #takes 520.62 seconds to run in my computer
### Tune the model using cross-validation
set.seed(100)
rfTune <- train(x = solTrainXtrans, y = solTrainY,
                method = "rf",
                tuneGrid = mtryGrid,
                ntree = 200,
                importance = TRUE,
                trControl = ctrl)
rfTune
proc.time() - ptm
### Stop the clock

plot(rfTune)

rfImp <- varImp(rfTune, scale = FALSE)
rfImp

### Save the test set results in a data frame  
testResults$RF <- predict(rfTune, solTestXtrans)


### Tune the model using the OOB estimates
ctrlOOB <- trainControl(method = "oob")

ptm <- proc.time() #takes 68.95 seconds to run in my computer
set.seed(100)
rfTuneOOB <- train(x = solTrainXtrans, y = solTrainY,
                   method = "rf",
                   tuneGrid = mtryGrid,
                   ntree = 200,
                   importance = TRUE,
                   trControl = ctrlOOB)
rfTuneOOB
proc.time() - ptm
### Stop the clock

#plot the tuning parameter
plot(rfTuneOOB)

rfImp <- varImp(rfTuneOOB, scale = FALSE)
rfImp
plot(rfImp, 20)

### Save the test set results in a data frame  
testResults$RFOOB <- predict(rfTuneOOB, solTestXtrans)

################################################################################
### Cubist

cbGrid <- expand.grid(committees = c(1:10, 20, 50, 75, 100), 
                      neighbors = c(0, 1, 5, 9))

ptm <- proc.time() #takes  307.76 seconds to run in my computer
set.seed(100)
cubistTune <- train(solTrainXtrans, solTrainY,
                    "cubist",
                    tuneGrid = cbGrid,
                    trControl = ctrl)
cubistTune
proc.time() - ptm
### Stop the clock


plot(cubistTune, auto.key = list(columns = 4, lines = TRUE))

cbImp <- varImp(cubistTune, scale = FALSE)
cbImp
plot(cbImp,20)

### Save the test set results in a data frame  
testResults$Cubist <- predict(cubistTune, solTestXtrans)

################################################################################
### Performance of tree-based models
set.seed(100) 
Cart.pred <- predict(cartTune, solTestXtrans)
cTree.pred <- predict(ctreeTune, solTestXtrans)
Bagged.pred <- predict(treebagTune, solTestXtrans)
Boosting.pred <- predict(gbmTune, solTestXtrans)
RF.pred   <- predict(rfTune, solTestXtrans)
RFOOB.pred <- predict(rfTuneOOB, solTestXtrans)
Cubist.pred <- predict(cubistTune, solTestXtrans)


data.frame(rbind(CART=postResample(pred=Cart.pred,obs = solTestY),
                                cTree=postResample(pred=cTree.pred ,obs = solTestY),
                                Bagged=postResample(pred=Bagged.pred,obs = solTestY), 
                                Boosting=postResample(pred=Boosting.pred,obs = solTestY),
                                RF=postResample(pred=RF.pred,obs = solTestY), 
                                RFOOB=postResample(pred=RFOOB.pred,obs = solTestY), 
                                Cubist=postResample(pred=Cubist.pred,obs = solTestY) ))































#Chapter 9
#Resamples
res = resamples(list(CART = cartTune, cTree =ctreeTune,Bagged = treebagTune, Boosting = gbmTune, RF = rfTune, Cubist = cubistTune ))
dotplot(res,  metric =res$metric[1])
#RFOOB = rfTuneOOB, cannot be added since it uses different ctrl






