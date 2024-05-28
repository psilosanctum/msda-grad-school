###########################
#R demonstration 3(1):Data scaling, transformation to skewnewss, and outliers
#Mtivating example: cell segmentation in high-content creening 
###########################

library(AppliedPredictiveModeling)
data(segmentationOriginal)

#Access cell segmentation data
## Retain the original training set
segTrain <- subset(segmentationOriginal, Case == "Train")
head(segTrain)
str(segTrain)

## Retain the original test/validation set
segTest <- subset(segmentationOriginal, Case == "Test")
str(segTest)

## Remove the first three columns (identifier columns)
segTrainX <- segTrain[, -(1:3)]
segTrainClass <- segTrain$Class #two levels: PS and WS

## Centering and Scaling
newsegTrainX = scale(segTrainX, center=TRUE, scale=TRUE)

##Validate if the mean is zero and the variance of each column is 1
colMeans(newsegTrainX) #calculate the column mean of each predictor
covariance  = cov(newsegTrainX) #calcualte the covariance matrix 
diag(covariance) #take the diagonal elements out from the covariane matrix

##Transformation to resolve skewness
#Rule of thumbs > 20
max(segTrainX$VarIntenCh3)/min(segTrainX$VarIntenCh3)

#calculate the skewness of a predictor 
#install.packages('e1071')
library(e1071)
skewness(segTrainX$VarIntenCh3)

#Box-cox transformation 
library(caret)
BoxCoxTrans(segTrainX$VarIntenCh3)

## Apply the transformations for predictor VarIntenCh3
VarIntenCh3BoxCox <- BoxCoxTrans(segTrainX$VarIntenCh3)
VarIntenCh3Trans <- predict(VarIntenCh3BoxCox, segTrainX$VarIntenCh3)

#Histgram comparisons before and after transformation
histogram(segTrainX$VarIntenCh3, xlab = "Natural Units",type = "count",main="Original")
windows()
histogram(VarIntenCh3Trans, xlab = "Log Units",type = "count", main="Log-transformation")

##Box Cox transformation for another predictor PerimCh1
BoxCoxTrans(segTrainX$PerimCh1)

## Apply the transformations for predictor VarIntenCh3
PerimCh1BoxCox <- BoxCoxTrans(segTrainX$PerimCh1)
PerimCh1Trans <- predict(PerimCh1BoxCox, segTrainX$PerimCh1)

#Histgram comparisons before and after transformation
histogram(segTrainX$PerimCh1, xlab = "Natural Units",type = "count",main="Original")
windows()
histogram(PerimCh1Trans, xlab = "Inverse Units",type = "count", main="Inverse-transformation")

##Spatial sign to resolve outliers
library(ICSNP)
spatialsign = spatial.sign(segTrainX$PerimCh1, center = TRUE, shape = TRUE)
spatialsign

## Use caret's preProcess function to transform for skewness
?preProcess
segPP <- preProcess(segTrainX, method = c("BoxCox", "scale","center","spatialSign"))
##Warning in preProcess.default(segTrainX, method = c("BoxCox", "scale", "center",  :
##These variables have zero variances: MemberAvgAvgIntenStatusCh2, MemberAvgTotalIntenStatusCh2

#remove near zero variance (nzv) predictors 
segPP <- preProcess(segTrainX, method = c("BoxCox", "scale","center", "nzv", "spatialSign"))
segTrainTrans <- predict(segPP, segTrainX)
head(segTrainTrans[,1:7]) #print out a few obsevation for the first five column

#calculate the column mean of each predictor
colMeans(segTrainTrans)
