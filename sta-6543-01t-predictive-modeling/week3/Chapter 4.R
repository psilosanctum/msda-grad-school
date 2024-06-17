#required packages
library(AppliedPredictiveModeling) 
library(caret)
library(kernlab)



#R Demonstration 4(1): Model tuning for kNN methods
#Access the two-class data
data(twoClassData)
str(predictors)
str(classes)

plot(predictors$PredictorA[classes=='Class1'], predictors$PredictorB[classes=='Class1'],
xlab="Predictor A", ylab="Predictor B", xlim=c(0,0.7), ylim=c(0,0.7), col ='red', pch=2)
points(predictors$PredictorA[classes=='Class2'], predictors$PredictorB[classes=='Class2'], 
pch=3, col ='green')
legend('topleft', c("Class1", "Class 2"), col=c('red','green' ), pch=c(2,3))


###############################
##KNN illustration (KNN methods)
###############################
#KNN = 5
library(caret)
x = cbind(predictors, classes)
model <- knn3(classes ~ ., data=x, k = 5)

decisionplot <- function(model, data, class = NULL, predict_type = "class",
  resolution = 100, showgrid = TRUE, ...) {

  if(!is.null(class)) cl <- data[,class] else cl <- 1
  data <- data[,1:2]
  k <- length(unique(cl))

  plot(data, col = as.integer(cl)+1L, pch = as.integer(cl)+1L, ...)

  # make grid
  r <- sapply(data, range, na.rm = TRUE)
  xs <- seq(r[1,1], r[2,1], length.out = resolution)
  ys <- seq(r[1,2], r[2,2], length.out = resolution)
  g <- cbind(rep(xs, each=resolution), rep(ys, time = resolution))
  colnames(g) <- colnames(r)
  g <- as.data.frame(g)

  ### guess how to get class labels from predict
  ### (unfortunately not very consistent between models)
  p <- predict(model, g, type = predict_type)
  if(is.list(p)) p <- p$class
  p <- as.factor(p)

  if(showgrid) points(g, col = as.integer(p)+1L, pch = ".")

  z <- matrix(as.integer(p), nrow = resolution, byrow = TRUE)
  contour(xs, ys, z, add = TRUE, drawlabels = FALSE,
    lwd = 2, levels = (1:(k-1))+.5)

  invisible(z)
}


#decisionplot(model, x, class = "classes", main = "kNN (5)")

#KNN = 1
model <- knn3(classes ~ ., data=x, k = 1)
decisionplot(model, x, class = "classes", main = "kNN (1)")

#KNN = 100
model <- knn3(classes ~ ., data=x, k = 100)
decisionplot(model, x, class = "classes", main = "kNN (100)")


#Apply KNN method available at the caret package
set.seed(1)
ctrl <- trainControl(method="repeatedcv",repeats = 3)
knnFit <- train(classes ~ ., data = data, method = "knn", trControl = ctrl, preProcess = c("center","scale"), tuneLength = 25)
knnFit
plot(knnFit, print.thres = 0.5, type="S")

#KNN = 25
model <- knn3(classes ~ ., data=x, k = 25)
decisionplot(model, x, class = "classes", main = "kNN (25)")

#R Demonstration 4(2): Model tuning for SVM models and model comparsions. 

data(twoClassData)
str(predictors)
str(classes)

## Split the data into training (80%) and test sets (20%)
set.seed(100)
x = cbind(predictors, classes)
inTrain <- createDataPartition(classes, p = .8)[[1]]
ClassTrain <- x[inTrain, ]
ClassTest  <- x[-inTrain, ]

#Hyperparameter Estimation For The Gaussian Radial Basis Kernel
library(kernlab)
set.seed(231)
#frac: fraction of data to use for estimation. 
#By default a quarter of the data is used to estimate 
#the range of the sigma hyperparameter.
sigDist <- sigest(classes~ ., data = ClassTrain, frac = 1)
sigDist
svmTuneGrid <- data.frame(sigma = as.vector(sigDist)[1], C = 2^(-2:7))
svmTuneGrid

#######################
#SVM with svmTuneGrid
#######################
set.seed(1056)
svmFit <- train(classes~ .,
                data = ClassTrain,
                method = "svmRadial",
                preProc = c("center", "scale"),
                tuneGrid = svmTuneGrid,
                trControl = trainControl(method = "repeatedcv", 
                                         repeats = 5,
                                         classProbs = TRUE))
## classProbs = TRUE was added since the text was written

## Print the results
svmFit


## A line plot of the average performance. 
## The 'scales' argument is actually an argument 
## to xyplot that converts the x-axis to log-2 units.

plot(svmFit, scales = list(x = list(log = 2)))

## Test set predictions

predictedClasses <- predict(svmFit, ClassTest)
str(predictedClasses)

## Use the "type" option to get class probabilities
predictedProbs <- predict(svmFit, newdata = ClassTest, type = "prob")
head(predictedProbs)

#obtain the prediction class labels
predictedProbs <- predict(svmFit, newdata = ClassTest)
head(predictedProbs)

#######################
#10-fold cross validation
#######################
set.seed(1056)
svmFit10CV <- train(classes ~ .,
                    data = ClassTrain,
                    method = "svmRadial",
                    preProc = c("center", "scale"),
                    tuneGrid = svmTuneGrid,
                    trControl = trainControl(method = "cv", number = 10))
svmFit10CV

#LOOCV
set.seed(1056)
svmFitLOO <- train(classes ~ .,
                    data = ClassTrain,
                   method = "svmRadial",
                   preProc = c("center", "scale"),
                   tuneGrid = svmTuneGrid,
                   trControl = trainControl(method = "LOOCV"))
svmFitLOO

#######################
#LOOCV
#######################
set.seed(1056)
svmFitLOO <- train(classes ~ .,
                    data = ClassTrain,
                   method = "svmRadial",
                   preProc = c("center", "scale"),
                   tuneGrid = svmTuneGrid,
                   trControl = trainControl(method = "LOOCV"))
svmFitLOO

#######################
#The bootstrap
#######################
set.seed(1056)
svmFitBoot <- train(classes ~ .,
                    data = ClassTrain,
                    method = "svmRadial",
                    preProc = c("center", "scale"),
                    tuneGrid = svmTuneGrid,
                    trControl = trainControl(method = "boot", number = 50))
svmFitBoot


#######################
#Between model comparisons
#######################

set.seed(1056)
svmFit <- train(classes~ .,
                data = ClassTrain,
                method = "svmRadial",
                preProc = c("center", "scale"),
                tuneGrid = svmTuneGrid,
                trControl = trainControl(method = "repeatedcv", 
                                         repeats = 5,
                                         classProbs = TRUE))
svmFit

set.seed(1056)
glmProfile <- train(classes ~ .,
                    data = ClassTrain,
                    method = "glm",
                    trControl = trainControl(method = "repeatedcv", 
                                             repeats = 5))
glmProfile

#Compare the SVM and logistic regression models using resamples function
resamp <- resamples(list(SVM = svmFit, Logistic = glmProfile))
summary(resamp)

modelDifferences <- diff(resamp)
summary(modelDifferences)

## The actual paired t-test:
modelDifferences$statistics$Accuracy











