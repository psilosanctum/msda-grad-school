#Required packages
library(AppliedPredictiveModeling)
library(lattice)
library(caret)
library(corrplot)
library(e1071)
library(pls)
library(elasticnet)

#Access the solubility data
data(solubility) 
#http://127.0.0.1:27533/library/AppliedPredictiveModeling/html/solubility.html

#This data contain traing data
str(solTrainY)
dim(solTrainX)

##Test data
head(solTestY)
head(solTestX)

#############################
#Stage 1: Data pre-processing

### Some initial plots of the data
plot(solTrainY ~ solTrainX$MolWeight,
       ylab = "Solubility (log)",
       main = "(a)", col='blue',
       xlab = "Molecular Weight")

fit = lm(solTrainY ~ solTrainX$MolWeight)
summary(fit)
abline(fit, col=2, lwd=2)

### correlation test for the relationship
### between solubility and molecular weight
cor.test(solTrainY,solTrainX$MolWeight)

xyplot(solTrainY ~ solTrainX$NumRotBonds, type = c("p", "g"),
       ylab = "Solubility (log)",
       xlab = "Number of Rotatable Bonds")

#The function bwplot() makes box-and-whisker plots for numerical variables
bwplot(solTrainY ~ ifelse(solTrainX[,100] == 1, 
                          "structure present", 
                          "structure absent"),
       ylab = "Solubility (log)",
       main = "(b)",
       horizontal = FALSE)

#The above examples showed that there exist strong correlations among
#predictors, so how do we deal with significant correlations?

### Find the columns that are not fingerprints (i.e. the continuous
### predictors). grep will return a list of integers corresponding to
### column names that contain the pattern "FP".

##We just use training set predictors after transformations for skewness and centering/scaling,
## which is solTrainXtrans	
notFingerprints <- grep("FP", names(solTrainXtrans))

#library(caret)
#Draw scatter plot for continuous predictors 
featurePlot(solTrainXtrans[, -notFingerprints],
            solTrainY,
            between = list(x = 1, y = 1),
            type = c("g", "p", "smooth"),
            labels = rep("", 2))

#library(corrplot)
#Draw the correlation matrix plot for the continous predictors 
corrplot::corrplot(cor(solTrainXtrans[, -notFingerprints]), 
                   order = "hclust", 
                   tl.cex = .8)

#Remove high correlated predictors (cor>0.9)
tooHigh <- findCorrelation(cor(solTrainXtrans[, -notFingerprints]), .9)
corrplot::corrplot(cor(solTrainXtrans[, -notFingerprints][,-tooHigh]), 
                   order = "hclust", 
                   tl.cex = .8)

# Remove near zero variance predictors 
nearZeroVar(solTrainXtrans)
#There are three near zero variances whose index are 154 199 200

#Skewness
#library(e1071)
apply(solTrainXtrans[, -notFingerprints], 2, skewness)

#Box-Cox transformation
Original = as.matrix(solTrainXtrans[, -notFingerprints])
solTrainXtransBoxCox = BoxCoxTrans(Original)
solTrainXtransBoxCox

### End of data preprocessing
############################
#We work on the transformed predictor matrix: solTrainXtrans
#instead of the orginal training data: solTrainX
############################
### Model building 

################################################################################
### Linear Regression

### Create a control function that will be used across models. We
### create the fold assignments explicitly instead of relying on the
### random number seed being set to identical values.

set.seed(100)
#Create a series of test/training partitions
#default is 10, the funtion below creates 10 folder
indx <- createFolds(solTrainY, returnTrain = TRUE)

#control the computational nuances of the train function
ctrl <- trainControl(method = "cv", index = indx)

### Linear regression model with all of the predictors. This will
### produce some warnings that a 'rank-deficient fit may be
### misleading'. This is related to the predictors being so highly
### correlated that some of the math has broken down.

set.seed(100)
lmTune0 <- train(x = solTrainXtrans, y = solTrainY,
                 method = "lm",
                 trControl = ctrl)

lmTune0
summary(lmTune0) #provide regression coefficients                

### Save the test set results in a data frame                 
testResults <- data.frame(obs = solTestY,
                          Linear_Regression = predict(lmTune0, solTestXtrans))



### And another using a set of predictors reduced by unsupervised
### filtering. We apply a filter to reduce extreme between-predictor
### correlations. Note the lack of warnings.

tooHigh <- findCorrelation(cor(solTrainXtrans), .9)
trainXfiltered <- solTrainXtrans[, -tooHigh]
testXfiltered  <-  solTestXtrans[, -tooHigh]

set.seed(100)
lmTune <- train(x = trainXfiltered, y = solTrainY,
                method = "lm",
                trControl = ctrl)

lmTune

### Save the test set results in a data frame                 
testResults1 <- data.frame(obs = solTestY,
                          Linear_Regression = predict(lmTune, solTestXtrans))



################################################################################
### Partial Least Squares (PLS) and Principal Component Regression (PCR)

## Run PLS and PCR on solubility data and compare results
#library(pls)
set.seed(100)
plsTune <- train(x = solTrainXtrans, y = solTrainY,
                 method = "pls",
                 tuneGrid = expand.grid(ncomp = 1:50),
                 trControl = ctrl)
plsTune
plot(plsTune)

#prediction for test data
testResults$PLS <- predict(plsTune, solTestXtrans)

set.seed(100)
pcrTune <- train(x = solTrainXtrans, y = solTrainY,
                 method = "pcr",
                 tuneGrid = expand.grid(ncomp = 1:50),
                 trControl = ctrl)
pcrTune                  
plot(pcrTune)

plsResamples <- plsTune$results
plsResamples$Model <- "PLS"
pcrResamples <- pcrTune$results
pcrResamples$Model <- "PCR"
plsPlotData <- rbind(plsResamples, pcrResamples)

xyplot(RMSE ~ ncomp,
       data = plsPlotData,
       #aspect = 1,
       xlab = "# Components",
       ylab = "RMSE (Cross-Validation)",
       auto.key = list(columns = 2),
       groups = Model,
       type = c("o", "g"))

#Predictor importance plot for PLS model
plsImp <- varImp(plsTune, scale = FALSE)
plot(plsImp, top = 25, scales = list(y = list(cex = .95)))

#Predictor importance plot for PCR model
pcrImp <- varImp(pcrTune, scale = FALSE)
plot(pcrImp, top = 25, scales = list(y = list(cex = .95)))


################################################################################
### Penalized Models

## The text used the elasticnet to obtain a ridge regression model.
## There is now a simple ridge regression method.

#you may need to try different ranges of values for lambda
ridgeGrid <- expand.grid(lambda = seq(0, .1, length = 10))


### Start the clock to track time!

##The following codes takes 94.49 seconds to run.
## Your running time may be different depending
## on your cpu. 
set.seed(100) #it may take a while to get results 
ptm <- proc.time()
#library(elasticnet)
ridgeTune <- train(x = solTrainXtrans, y = solTrainY,
                   method = "ridge",
                   tuneGrid = ridgeGrid,
                   trControl = ctrl,
                   preProc = c("center", "scale"))

proc.time() - ptm
### Stop the clock
#> proc.time() - ptm
#   user  system elapsed 
#  89.06    5.34   94.49 

ridgeTune
#check the names of output in ridgeTune
names(ridgeTune)
summary(ridgeTune)

#prediction for test data
testResults$Ridge <- predict(ridgeTune, solTestXtrans)


### ENET
ptm <- proc.time()
enetGrid <- expand.grid(lambda = c(0, 0.01, .1), 
                        fraction = seq(.05, 1, length = 20))
set.seed(100)
enetTune <- train(x = solTrainXtrans, y = solTrainY,
                  method = "enet",
                  tuneGrid = enetGrid,
                  trControl = ctrl,
                  preProc = c("center", "scale"))
proc.time() - ptm
### Stop the clock
#> proc.time() - ptm
#   user  system elapsed 
#  34.31    0.48   34.89 


enetTune
names(enetTune)

#prediction for test data
testResults$ENET <- predict(enetTune, solTestXtrans)


#Which model has the best predictive ability


### create empty spaces to save the values of R2 and RMSE                  
R2 <-RMSE<-MAE<- numeric(0)

#Linear regression model
testResults$LRM<- predict(lmTune0, solTestXtrans)
R2[1] = cor(testResults$LRM, solTestY)^2
RMSE[1] = sqrt(mean((testResults$LRM - solTestY)^2))
MAE[1] = mean(abs(testResults$LRM - solTestY))

#PCR
testResults$PCR <- predict(pcrTune, solTestXtrans)
R2[2] = cor(testResults$PCR, solTestY)^2
RMSE[2] = sqrt(mean((testResults$PCR - solTestY)^2))
MAE[2] = mean(abs(testResults$PCR - solTestY))

#PLS
testResults$PLS <- predict(plsTune, solTestXtrans)
R2[3] = cor(testResults$PLS, solTestY)^2
RMSE[3] = sqrt(mean((testResults$PLS - solTestY)^2))
MAE[3] = mean(abs(testResults$PLS - solTestY))

#Ridge regression
testResults$Ridge <- predict(ridgeTune, solTestXtrans)
R2[4] = cor(testResults$Ridge, solTestY)^2
RMSE[4] = sqrt(mean((testResults$Ridge - solTestY)^2))
MAE[4] = mean(abs(testResults$Ridge - solTestY))

#ENET regression
testResults$ENET <- predict(enetTune, solTestXtrans)
R2[5] = cor(testResults$ENET, solTestY)^2
RMSE[5] = sqrt(mean((testResults$ENET - solTestY)^2))
MAE[5] = mean(abs(testResults$ENET - solTestY))

results = cbind(R2, RMSE, MAE)
row.names(results) = c("LRM", "PCR", "PLS", "Ridge", "ENET")
results

#You may conclude the ENET performs the best in terms of 
#RMSE and MAE.
###End of programming 
################################################################################

















