###########################
#R demonstration 3(2)
#PCA, creating dummy variables, 
#near zero variance
# multicorrelation 
#removing and binning predictors.
###########################

#R codes for PCA
library(caret)

## Use caret's preProcess function to transform for skewness
segPP <- preProcess(segTrainX, method = c("BoxCox", "scale", "center"))
## We may need to remove MemberAvgAvgIntenStatusCh2 and 
## MemberAvgTotalIntenStatusCh2 before using the preProcess function 

## Apply the transformations
segTrainTrans <- predict(segPP, segTrainX)
## R's prcomp is used to conduct PCA
## PCA is an unsupervised learning method
pr <- prcomp(~AvgIntenCh1 + EntropyIntenCh1, 
             data = segTrainTrans,  scale. = TRUE)

xyplot(AvgIntenCh1 ~ EntropyIntenCh1, data = segTrainTrans,
       groups = segTrain$Class,
       xlab = "Channel 1 Fiber Width",
       ylab = "Intensity Entropy Channel 1",
       auto.key = list(columns = 2), type = c("p", "g"),
       main = "Original Data", aspect = 1)


#check if we specify auto.key=FALSE

windows() #get another plot window 
xyplot(AvgIntenCh1 ~ EntropyIntenCh1, data = segTrainTrans,
       groups = segTrain$Class,
       xlab = "Channel 1 Fiber Width",
       ylab = "Intensity Entropy Channel 1",
       auto.key = FALSE, type = c("p", "g"),
       main = "Original Data", aspect = 1)

windows() #get another plot window 
xyplot(AvgIntenCh1 ~ EntropyIntenCh1, data = segTrainTrans,
       groups = segTrain$Class,
       xlab = "Channel 1 Fiber Width",
       ylab = "Intensity Entropy Channel 1",
       auto.key = list(columns = 1), type = c("p"),
       main = "Original Data", aspect = 1)

xyplot(PC2 ~ PC1,
       data = as.data.frame(pr$x),
       groups = segTrain$Class,
       xlab = "Principal Component #1",
       ylab = "Principal Component #2",
       main = "Transformed",
       xlim = extendrange(pr$x),
       ylim = extendrange(pr$x),
       type = c("p", "g"), aspect = 1)

#Fit PCA to entire set of segmentation data
## There are a few predictors with only a single value, so we remove these first
## (since PCA uses variances, which would be zero)

isZV <- apply(segTrainX, 2, function(x) length(unique(x)) == 1)  #identify the predictor with a single value
segTrainX <- segTrainX[, !isZV]

segPP <- preProcess(segTrainX, c("BoxCox", "center", "scale"))
segTrainTrans <- predict(segPP, segTrainX)

segPCA <- prcomp(segTrainTrans, center = TRUE, scale. = TRUE)
str(segPCA)
head(segPCA$x[,1:5])

#Scree plot
PTotalVariance = (segPCA$sdev^2)/sum(segPCA$sdev^2)*100
ts.plot(PTotalVariance, xlab='Component', ylab='Percent of Total Variance')
points(PTotalVariance, col=2)

#calculate the weight of the first five components
sum(PTotalVariance[1:5])

#Plot a scatterplot matrix of the first three components

panelRange <- extendrange(segPCA$x[, 1:3])
splom(as.data.frame(segPCA$x[, 1:3]), #a data matrix consisting of three PCs
      groups = segTrainClass,
      type = c("p", "g"),
      auto.key = list(columns = 2),
      prepanel.limits = function(x) panelRange)


#Implement a series of transformations to multiple data
trans <- preProcess(segTrainX, method = c("BoxCox", "center", "scale", "pca"))
trans
#dimension reduction based on PCA:
#with 55 PCs, we could capture 95% of the variance 
#with 5 PCs, we could capture 46.36% of the variance
#we do not need to consider all 114 predictors. 

#consider all the PCs
sum(PTotalVariance)

# Apply the transformations:
transformed <- predict(trans, segTrainX)
# These values are different than the previous PCA components since
# they were transformed prior to PCA
head(transformed[, 1:6])


#R-codes for removing predictors 

#Near zero variance predictor 
## Near zero variance predictor means that the fraction of unique values 
##over the sample size is low (say 10%). 

nearZeroVar(segTrainTrans)
#Remove the near zero variance predictor 
segTrainTrans1 = segTrainTrans[, -nearZeroVar(segTrainTrans)]
nearZeroVar(segTrainTrans1)

## To filter on correlations, we first get the correlation matrix for the 
## predictor set
segCorr <- cor(segTrainTrans1)

library(corrplot)
corrplot(segCorr, order = "hclust", tl.cex = .35) 
#tl.cexfor the size of text label (variable names).

## caret's findCorrelation function is used to identify columns to remove.
highCorr <- findCorrelation(segCorr, .75)
highCorr

#R-codes for removing highly correlated predictors 
## caret's findCorrelation function is used to identify columns to remove.
highCorr <- findCorrelation(segCorr, .75)
highCorr

#Removing highly correlated predictors
segCorr1 <- cor(segTrainTrans1[,-highCorr])
corrplot(segCorr1, order = "hclust", tl.cex = .35)

#R-codes for creating dummy variables 
data(cars)
type <- c("convertible", "coupe", "hatchback", "sedan", "wagon")
cars$Type <- factor(apply(cars[, 14:18], 1, function(x) type[which(x == 1)]))

carSubset <- cars[sample(1:nrow(cars), 20), c(1, 2, 19)]

head(carSubset)
levels(carSubset$Type)

simpleMod <- dummyVars(~Mileage + Type,
                       data = carSubset,
                       ## Remove the variable name from the
                       ## column name
                       levelsOnly = TRUE)
simpleMod
predict(simpleMod, carSubset)


#R-codes for creating dummy variables with interaction  
withInteraction <- dummyVars(~Mileage + Type + Mileage:Type,
                             data = carSubset,
                             levelsOnly = TRUE)
withInteraction
predict(withInteraction, head(carSubset))






