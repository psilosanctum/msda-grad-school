#required packages
library(AppliedPredictiveModeling) 
library(caret)
library(kernlab)


############################
#R Demonstration 4(1): Model tuning for kNN methods
## For two-class data in Chapter 4
############################

#Access the two-class data
data(twoClassData)
str(predictors)
str(classes)
#check if two classes are balanced
table(classes)

plot(predictors$PredictorA[classes=='Class1'], predictors$PredictorB[classes=='Class1'],
xlab="Predictor A", ylab="Predictor B", xlim=c(0,0.7), ylim=c(0,0.7), col ='red', pch=2)
points(predictors$PredictorA[classes=='Class2'], predictors$PredictorB[classes=='Class2'], 
pch=3, col ='green')
legend('topleft', c("Class1", "Class 2"), col=c('red','green' ), pch=c(2,3))


###############################
##KNN illustration (KNN methods)
###############################
#KNN = 5
#library(caret)
x = cbind(predictors, classes)
head(x)

###############################
#A function for plotting the boundary of kNN method
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
###############################


#KNN = 1
model <- knn3(classes ~ ., data=x, k = 1)
decisionplot(model, x, class = "classes", main = "kNN (1)")

windows()
#KNN = 100
model <- knn3(classes ~ ., data=x, k = 100)
decisionplot(model, x, class = "classes", main = "kNN (100)")


#Apply KNN method available at the caret package
set.seed(1)
ctrl <- trainControl(method="repeatedcv",repeats = 3)
knnFit <- train(classes ~ ., data = x, method = "knn", trControl = ctrl, preProcess = c("center","scale"), tuneLength = 25)
knnFit
plot(knnFit, print.thres = 0.5, type="l")

#KNN = 25
model <- knn3(classes ~ ., data=x, k = 25)
decisionplot(model, x, class = "classes", main = "kNN (25)")
