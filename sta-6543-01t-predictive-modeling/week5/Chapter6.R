library(e1071)
library(ggplot2)
library(gbm)
library(randomForest)
library(scatterplot3d)

#Iris data
par(mfrow = c(1,2))
ggplot(data=iris, aes(x = Petal.Length, y = Petal.Width)) + 
  geom_point(aes(color=Species, shape=Species)) +
  xlab("Petal Length") +  ylab("Petal Width")

## Consider only Species "setosa" and "virginica"
ggplot(data=iris[iris$Species != "versicolor",], aes(x = Petal.Length, y = Petal.Width)) + 
  geom_point(aes(color=Species, shape=Species)) +
  xlab("Petal Length") +  ylab("Petal Width")

## Generalize data
n.iris = iris[iris$Species != "versicolor",c("Petal.Length","Petal.Width","Species")]
n.iris$Species = as.factor(ifelse(n.iris$Species == "setosa",-1,1))
colnames(n.iris) = c("x1","x2","y")
ggplot(data=n.iris, aes(x = x1, y = x2)) + geom_point(aes(color=y, shape=y)) +
  xlab("x1") +  ylab("x2")

## Some separating hyperplanes for the Iris data
ggplot(data=n.iris, aes(x = x1, y = x2)) + geom_point(aes(color=y, shape=y)) +
  xlab("x1") +  ylab("x2") + geom_abline(intercept = 1.5, slope = -0.1, 
    color="red", linetype="solid", size=1) + geom_abline(intercept = 1.2, slope = -0.03, 
    color="green", linetype="solid", size=1) + geom_abline(intercept = 1.0, slope = -0.1, 
    color="blue", linetype="solid", size=1) 

## Linear classifier
make.grid = function(x, n = 75) {
  grange = apply(x, 2, range)
  x1 = seq(from = grange[1,1], to = grange[2,1], length = n)
  x2 = seq(from = grange[1,2], to = grange[2,2], length = n)
  expandgrid = expand.grid(x1 = x1, x2 = x2)
  colnames(expandgrid) = colnames(x)
  expandgrid
}
x.grid = make.grid(n.iris[,1:2],n=70)
colnames(x.grid)=c("x1","x2")
x.grid$y = as.factor(ifelse(x.grid$x2 > 1.5 - 0.1*x.grid$x1,1,-1))
ggplot(data=x.grid, aes(x = x1, y = x2)) + geom_point(aes(color=y), size = 0.3) +
  xlab("x1") +  ylab("x2") + geom_abline(intercept = 1.5, slope = -0.1, 
    color="red", linetype="solid", size=1) + geom_point(data=n.iris, 
      aes(x = x1, y = x2,color=y, shape=y))

## Maximal Margin Classifier
ref.intercept = n.iris$x2 + 0.1*n.iris$x1 - 1.5
iris.margin = c(which.min(ifelse(ref.intercept>0,ref.intercept,100)),
  which.min(-ifelse(ref.intercept<0,ref.intercept,-100)))
b = -0.1
m = 1.5
new.points.x = (n.iris$x2[iris.margin] - m + n.iris$x1[iris.margin]/b)/(b + 1/b)
new.points.y = (m/b+b*n.iris$x2[iris.margin]+n.iris$x1[iris.margin])/(b + 1/b)
old.points.x = n.iris$x1[iris.margin]
old.points.y = n.iris$x2[iris.margin]
par(pty="s")
plot(n.iris$x1,n.iris$x2,xlab = "x1",ylab = "x2",col = as.integer(n.iris$y)+3,pch = as.integer(n.iris$y) + 4, cex = 0.7,
  xlim = c(0,7), ylim = c(0,7))
abline(m,b,col = "red")
abline(ref.intercept[iris.margin[1]]+m,b,lty =2, col = "green")
abline(ref.intercept[iris.margin[2]]+m,b,lty =2, col = "green")
segments(new.points.x,new.points.y,old.points.x,old.points.y,col = "black")


## Maximal Margin Classifier
m1 = m
b1 = b
m = mean(ref.intercept[iris.margin])+m
ref.intercept = n.iris$x2 -b*n.iris$x1 - m
iris.margin = c(which.min(ifelse(ref.intercept>0,ref.intercept,100)),
  which.min(-ifelse(ref.intercept<0,ref.intercept,-100)))
new.points.x = (n.iris$x2[iris.margin] - m + n.iris$x1[iris.margin]/b)/(b + 1/b)
new.points.y = (m/b+b*n.iris$x2[iris.margin]+n.iris$x1[iris.margin])/(b + 1/b)
old.points.x = n.iris$x1[iris.margin]
old.points.y = n.iris$x2[iris.margin]
par(pty="s")
plot(n.iris$x1,n.iris$x2,xlab = "x1",ylab = "x2",col = as.integer(n.iris$y)+3,pch = as.integer(n.iris$y) + 4, cex = 0.7,
  xlim = c(0,7), ylim = c(0,7))
abline(m,b,col = "red")
abline(ref.intercept[iris.margin[1]]+m,b,lty =2, col = "green")
abline(ref.intercept[iris.margin[2]]+m,b,lty =2, col = "green")
segments(new.points.x,new.points.y,old.points.x,old.points.y,col = "black")
abline(m1,b,lty = 2,col = "red")

## Maximal Margin Classifier
par(pty="s")
plot(n.iris$x1,n.iris$x2,xlab = "x1",ylab = "x2",col = as.integer(n.iris$y)+3,pch = as.integer(n.iris$y) + 4, cex = 0.7,
  xlim = c(0,7), ylim = c(0,7))
abline(m,b,col = "red")
abline(ref.intercept[iris.margin[1]]+m,b,lty =2, col = "green")
abline(ref.intercept[iris.margin[2]]+m,b,lty =2, col = "green")
segments(new.points.x,new.points.y,old.points.x,old.points.y,col = "black")
abline(mean(ref.intercept[iris.margin])+m,b,lwd =2,col = "red")
m = 20
b = -5
abline(m,b,col = "red", lty = 2)
ref.intercept = n.iris$x2 -b*n.iris$x1 - m
iris.margin = c(which.min(ifelse(ref.intercept>0,ref.intercept,100)),
  which.min(-ifelse(ref.intercept<0,ref.intercept,-100)))
new.points.x = (n.iris$x2[iris.margin] - m + n.iris$x1[iris.margin]/b)/(b + 1/b)
new.points.y = (m/b+b*n.iris$x2[iris.margin]+n.iris$x1[iris.margin])/(b + 1/b)
old.points.x = n.iris$x1[iris.margin]
old.points.y = n.iris$x2[iris.margin]
abline(ref.intercept[iris.margin[1]]+m,b,lty =2, col = "green")
abline(ref.intercept[iris.margin[2]]+m,b,lty =2, col = "green")
segments(new.points.x,new.points.y,old.points.x,old.points.y,col = "black")

## Maximal Margin Classifier
m = mean(ref.intercept[iris.margin])+m
ref.intercept = n.iris$x2 -b*n.iris$x1 - m
iris.margin = c(which.min(ifelse(ref.intercept>0,ref.intercept,100)),
  which.min(-ifelse(ref.intercept<0,ref.intercept,-100)))
new.points.x = (n.iris$x2[iris.margin] - m + n.iris$x1[iris.margin]/b)/(b + 1/b)
new.points.y = (m/b+b*n.iris$x2[iris.margin]+n.iris$x1[iris.margin])/(b + 1/b)
old.points.x = n.iris$x1[iris.margin]
old.points.y = n.iris$x2[iris.margin]
par(pty="s")
plot(n.iris$x1,n.iris$x2,xlab = "x1",ylab = "x2",col = as.integer(n.iris$y)+3,pch = as.integer(n.iris$y) + 4, cex = 0.7,
  xlim = c(0,7), ylim = c(0,7))
abline(m,b,col = "red")
abline(ref.intercept[iris.margin[1]]+m,b,lty =2, col = "green")
abline(ref.intercept[iris.margin[2]]+m,b,lty =2, col = "green")
segments(new.points.x,new.points.y,old.points.x,old.points.y,col = "black")
abline(mean(ref.intercept[iris.margin])+m,b,lwd =2,col = "red")
abline(m,b,col = "red", lty = 2)


## Package e1071
## A quick look at the svm result for Iris data
iris.svm1 = svm(y ~ ., data = n.iris, kernel = "linear", scale = F)
plot(iris.svm1,n.iris)
iris.svm1$index
iris.svm1$SV
iris.svm1$rho
iris.svm1$coefs


## Details in the output 
beta = t(iris.svm1$coefs) %*% iris.svm1$SV
beta0 = -iris.svm1$rho
plot(n.iris$x1,n.iris$x2,xlab = "x1",ylab = "x2",col = as.integer(n.iris$y)+2,
  pch = as.integer(n.iris$y) + 4)
# show the support vectors
points(n.iris[iris.svm1$index,c(1,2)],col=as.integer(n.iris[iris.svm1$index,"y"])
  +2, cex=2) 
abline(-beta0/beta[1,2],-beta[1,1]/beta[1,2],col = "red")
abline(iris.svm1$SV[1,2] + beta[1,1]/beta[1,2] *iris.svm1$SV[1,1],
       -beta[1,1]/beta[1,2], col = "red",lty = 2)
abline(iris.svm1$SV[2,2] + beta[1,1]/beta[1,2] *iris.svm1$SV[2,1],
       -beta[1,1]/beta[1,2], col = "red",lty = 2)


## Cost: $C$ is a regularization parameter
iris.svm2 = svm(y ~ ., data = n.iris, kernel = "linear", cost =1)
iris.svm2$SV
iris.svm3 = svm(y ~ ., data = n.iris, kernel = "linear", cost = 10000)
iris.svm3$SV

## The iris data we used
par(mfrow = c(1,2))
par(pty = "s")
plot(iris$Petal.Length,iris$Petal.Width,col = as.numeric(iris$Species)+1,
  pch = as.numeric(iris$Species)+2, xlab = "Petal Length",ylab = "Petal Width")
legend("topleft",legend = unique(iris$Species), col = as.numeric(unique(iris$Species))+1,
  pch = as.numeric(unique(iris$Species))+2)
par(pty = "s")
plot(n.iris$x1,n.iris$x2,col = 2*as.numeric(n.iris$y),xlab = "Petal Length",
  ylab = "Petal Width",pch = 2*as.numeric(n.iris$y)+1)
legend("topleft",legend = c("setosa","virginica"), col = c(2,4),pch = c(3,5))


## The "other" iris data
iris2 = iris[iris$Species != "setosa",c("Petal.Length","Petal.Width","Species")]
iris2$Species=as.factor(as.character(iris2$Species))
plot(iris2$Petal.Length,iris2$Petal.Width,col = as.numeric(iris2$Species)+2,
  pch = as.numeric(iris2$Species)+3, xlab = "Petal Length",ylab = "Petal Width",cex =2)
legend("topleft",legend = unique(iris2$Species), col = as.numeric(unique(iris2$Species))+2, 
  pch = as.numeric(unique(iris2$Species))+3,cex = 2)

## SVM classifier
iris2.svm1 = svm(Species ~ ., data = iris2, kernel = "linear",scale = F)
plot(iris2.svm1,iris2,cex = 2)

## Support Points
x.grid = make.grid(iris2[,1:2], n = 100)
y.grid = predict(iris2.svm1, x.grid)
plot(x.grid,col = as.numeric(y.grid)+2,pch = 20,cex=0.3)
points(iris2[,1:2],col = as.numeric(iris2$Species)+2, pch = 19, cex = 0.7)
points(iris2[iris2.svm1$index,1:2], pch = 5, cex = 1.2, col = as.numeric(iris2[iris2.svm1$index,3])+2)

## Support vectors
plot(x.grid,col = as.numeric(y.grid)+2,pch = 20,cex=0.3)
points(iris2[,1:2],col = as.numeric(iris2$Species)+2, pch = 19, cex = 0.7)
points(iris2[iris2.svm1$index,1:2], pch = 5, cex = 1.2, col = as.numeric(iris2[iris2.svm1$index,3])+2)

beta = t(iris2.svm1$coefs) %*% iris2.svm1$SV
beta0 = -iris2.svm1$rho
abline(-beta0/beta[1,2],-beta[1,1]/beta[1,2],col = "red")
abline(-(beta0-1)/beta[1,2],-beta[1,1]/beta[1,2],col = "red",lty = 2)
abline(-(beta0+1)/beta[1,2],-beta[1,1]/beta[1,2],col = "red",lty = 2)

## Variation of Cost: $C$
par(mfrow = c(2,2))
x.grid = make.grid(iris2[,1:2], n = 50)
for(c in c(0.1,10,50,1000)){
iris2.svm1 = svm(Species ~ ., data = iris2, kernel = "linear",scale = F, cost = c) 
y.grid = predict(iris2.svm1, x.grid)
plot(x.grid,col = as.numeric(y.grid)+2,pch = 20,cex=0.3, main = paste("C = ",c))
points(iris2[,1:2],col = as.numeric(iris2$Species)+2, pch = 19, cex = 0.7)
points(iris2[iris2.svm1$index,1:2], pch = 5, cex = 1.2, 
  col = as.numeric(iris2[iris2.svm1$index,3])+2)

beta = t(iris2.svm1$coefs) %*% iris2.svm1$SV
beta0 = -iris2.svm1$rho
abline(-beta0/beta[1,2],-beta[1,1]/beta[1,2],col = "red")
abline(-(beta0-1)/beta[1,2],-beta[1,1]/beta[1,2],col = "red",lty = 2)
abline(-(beta0+1)/beta[1,2],-beta[1,1]/beta[1,2],col = "red",lty = 2)
}


## Tuning of $C$
set.seed(1)
iris2.tune = tune(svm, Species ~ ., data = iris2, kernel = "linear", scale = F, 
  ranges = list(cost = c(0.001,0.01,0.1,0.5,1,5,10,50,100)))
summary(iris2.tune)

## Fine tuning of $C$
set.seed(1)
iris2.tune = tune(svm, Species ~ ., data = iris2, kernel = "linear", scale = F, 
  ranges = list(cost = seq(0.02,0.2,0.02)))
summary(iris2.tune)

## Tuning of $C$ (Don't be superstitious)
iris2.tune = tune(svm, Species ~ ., data = iris2, kernel = "linear", scale = F, 
  ranges = list(cost = seq(0.02,0.2,0.02)))
summary(iris2.tune)

## A simulated data
y.fun = function(x,alpha){
  (alpha*((2*x)^2*exp(-1+2*x +0.3*(2*x)^2)-2*x)+(1-alpha)*(0.5-(2*x)^2/2-0.8*(2*x)^3)+0.5)/2
}
m = 300
alpha = 0.52
beta = 0.05
set.seed(1)
x = runif(2*m)
z = rbinom(m,1,beta)
df = data.frame(x1=x[1:m],x2=x[(m+1):(2*m)], z= z)
df$y = ifelse(df$x2 > y.fun(df$x1,alpha),1,0)
df$y = as.factor(ifelse(df$z==1,1-df$y,df$y))
df$z = NULL

tr.ind = 1:100
df.tr = df[tr.ind,]
df.te = df[-tr.ind,]
par(pty = "s")
plot(df.tr$x1,df.tr$x2, xlab = "x1",ylab = "x2", col = as.numeric(df.tr$y)+1,
  pch = as.numeric(df.tr$y)+3,cex = 1.5)

## Linear SVM with tuning
C = c(0.01,0.05,seq(0.1,1,0.1),2,5,10)
sim.tune = tune(svm, y ~ ., data = df.tr, kernel = "linear", scale = F, 
  ranges = list(cost = C))
summary(sim.tune)


########################
class.plot = function(model = NULL, data, train.index =NULL, method, class = NULL,  k = 1, 
  n.trees = 100, prob = 0.5, predict_type = "class", train = T, resolution = 100, add = FALSE, ...){
  
  if(is.null(model) & !(method %in% c("knn","Bayes")))return(
    "Please type model or select method as knn or Bayes")
  if(is.null(method)){return("Please type in method")}
  if(method == "naiveBayes" & predict_type != "raw"){
    return("Please change predict_type to 'raw'")}
  
  if(!is.null(train.index)){data.tr = data[train.index,]
  data.te = data[-train.index,]}else{data.tr = data
  data.te = NULL}
  
  if(!is.null(class)) {
    cl1 <- data.tr[,class]
    cl2 = data.te[,class]
  }else {
    cl1 <- data.tr[,3]
    cl2 = data.te[,3]}
  if(abs(nrow(data)-nrow(data.tr))>1){if(length(unique(cl1)) != length(unique(cl2))){
    return("training and test sets class numbers do not match")}}
  
  plot.title = paste(k,"-NN classification for ",sep = "")
  if(method == "logistic" & length(unique(cl1))<=2){
    plot.title = paste("Logistic regression classification with p = ",prob," for ",sep = "")
  }else if(method == "logistic" & length(unique(cl1)) > 2){
    plot.title = paste("Logistic regression classification for ")   
    }else if(method == "lda"){plot.title = paste("LDA classification for ")
    }else if(method == "qda"){plot.title = paste("QDA classification for ")
    }else if(method == "tree"){plot.title = paste("Tree classification for ")
    }else if(method == "svm"){plot.title = paste("SVM classification for ")
    }else if(method == "gbm"){plot.title = paste("Boosting classification for ")
    }else if(method == "randomForest"){plot.title = paste("Random Forest classification for ")
    }else if(method == "naiveBayes"){plot.title = 
      paste("Naive Bayes classification for ",sep = "")}

  
  if(!add){
  if(train){
    plot(data.tr[,1:2], col = as.integer(cl1)+1L, pch = as.integer(cl1)+1L,
         main = paste(plot.title, "train data", sep = ""), ...)
  } else {
    plot(data.te[,1:2], col = as.integer(cl2)+1L, pch = as.integer(cl2)+1L,
         main = paste(plot.title,"test data",sep = ""), ...)}
  }
  r <- sapply(data[,1:2], range, na.rm = TRUE)
  xs <- seq(r[1,1], r[2,1], length.out = resolution)
  ys <- seq(r[1,2], r[2,2], length.out = resolution)
  g <- cbind(rep(xs, each=resolution), rep(ys, time = resolution))
  colnames(g) <- colnames(r)
  g <- as.data.frame(g)
  if(method == "knn"){
    p = knn(data.tr[,1:2],g,data.tr[,3], k = k)
  }else if(method == "logistic" & length(unique(cl1))<=2){
      p = predict(model, g, type = predict_type)
      p = ifelse(p>prob,1,0)
  }else if(method == "naiveBayes"){
      p = predict(model, g, type = predict_type)
      p = apply(p,1,which.max)
  }else if(method == "gbm"){
    p = predict(model, g, n.tree = n.trees, type = predict_type)
    p = ifelse(p>prob,1,0)
  }else if(method == "tree" | method == "svm"){
    p = predict(model, g, type = predict_type)
  }else if(method == "randomForest"){
    p = predict(model, g, type = predict_type)
  }else if(method == "Bayes"){
    p = model(g)
    }else{
      p = predict(model, g)
  }
  if(is.list(p)) p = p$class
  p = as.factor(p)
  z = matrix(as.integer(p), nrow = resolution, byrow = TRUE)
  contour(xs, ys, z, add = TRUE, drawlabels = FALSE,
          lwd = 2, levels = (1:(length(unique(data[,3]))-1))+.5, ...)
  points(g, col = as.integer(p)+1L, pch = ".")
  invisible(z)
}
########################

## Linear SVM with "best" cost
##class.plot is available on the blackboard
sim.best = svm(y ~ ., data = df.tr, kernel = "linear", scale = F,
  cost = as.numeric(sim.tune$best.parameters))
class.plot(sim.best,data =  df,train.index = tr.ind,method = "svm",train = T)
##############

## Misclassification errors for testing data
err = vector()
for(c in C){
  sim.svm = svm(y ~ ., data = df.tr, kernel = "linear", scale = F, cost = c)
  err = c(err,mean(predict(sim.svm, newdata = df.te) != df.te$y))
}
C[which.min(err)]
rbind(C,err)

## Polynomial SVM with "best" tuned cost
set.seed(1)
sim2.tune = tune(svm, y ~ ., data = df.tr, kernel = "polynomial", scale = F, 
  ranges = list(cost = C))
sim2.tune$best.parameters
sim2.best = svm(y ~ ., data = df.tr, kernel = "polynomial", scale = F,
  cost = as.numeric(sim2.tune$best.parameters))
class.plot(sim2.best,data =  df,train.index = tr.ind,method = "svm",train = T)


## Misclassification errors for testing data using polynomial SVM
err2 = vector()
for(c in C){
  sim2.svm = svm(y ~ ., data = df.tr, kernel = "polynomial", scale = F, cost = c)
  err2 = c(err2,mean(predict(sim2.svm, newdata = df.te) != df.te$y))
}
c("best cost for test data =",C[which.min(err2)])
rbind(C,err2)

#Compare to linear SVM
rbind(C,err)
#It is not getting better

## SVM using Radial options
set.seed(1)
sim3.tune = tune(svm, y ~ ., data = df.tr, kernel = "radial", scale = F, 
  ranges = list(cost = C))
sim3.tune$best.parameters

#It seems that we may need to explore more values of $C$
C1 = unique(c(C,seq(6,20,2)))
C = seq(6,20,2)
sim3.tune = tune(svm, y ~ ., data = df.tr, kernel = "radial", scale = F, 
  ranges = list(cost = C))
summary(sim3.tune)


## SVM with radial options and best cost
sim3.best = svm(y ~ ., data = df.tr, kernel = "radial", scale = F, cost = as.numeric(sim3.tune$best.parameters))
class.plot(sim3.best,data =  df,train.index = tr.ind,method = "svm",train = T)

## Misclassification errors for testing data with radial
C = sort(C1)
err3 = vector()
for(c in C){
  sim3.svm = svm(y ~ ., data = df.tr, kernel = "polynomial", scale = F, cost = c)
  err3 = c(err3,mean(predict(sim3.svm, newdata = df.te) != df.te$y))
}
c("best cost for test data =",C[which.min(err3)])
rbind(C,err3)

## Plots for testing data
par(mfrow = c(1,3))
par(pty = "s")
class.plot(sim.best,data =  df,train.index = tr.ind,method = "svm",train = F)
class.plot(sim2.best,data =  df,train.index = tr.ind,method = "svm",train = F)
class.plot(sim3.best,data =  df,train.index = tr.ind,method = "svm",train = F)
x = seq(0,1,length.out = 200)
lines(x,y.fun(x,alpha), col = "blue", lwd = 3)

## Comparing SVM, Random Forest, and Boosting in training data
par(mfrow = c(1,3))
x = seq(0,1,length.out = 200)
par(pty = "s")
class.plot(sim3.best,data =  df,train.index = tr.ind,method = "svm",train = T)
lines(x,y.fun(x,alpha), col = "blue", lwd = 3)
sim.boost = gbm(as.numeric(y) - 1 ~ ., data = df.tr, n.trees = 5000, distribution = "bernoulli", 
  shrinkage = 0.01, interaction.depth = 4)
class.plot(sim.boost, data = df, train.index = tr.ind, train = T,method = "gbm",
  n.trees = 5000, predict_type = "response")
lines(x,y.fun(x,alpha), col = "blue", lwd = 3)
sim.rf = randomForest(y ~ ., data = df, ntree = 1000, subset = tr.ind)
class.plot(sim.rf,data = df,train.index = tr.ind,method = "randomForest", train = T)
lines(x,y.fun(x,alpha), col = "blue", lwd = 3)

c("training data error for SVM = ",mean(predict(sim3.best,df.tr) != as.character(df.tr$y)))
boost.pred.tr = predict(sim.boost,df.tr,n.trees = 3000, type = "response")
c("training data error for boosting = ",mean(ifelse(boost.pred.tr>0.5,1,0) != as.numeric(as.character(df.tr$y))))
c("training data error for random forest = ",mean(predict(sim.rf,df.tr) != as.character(df.tr$y)))

## Comparing SVM, Random Forest, and Boosting in testing data
par(mfrow = c(1,3))
x = seq(0,1,length.out = 200)
par(pty = "s")
class.plot(sim3.best,data =  df,train.index = tr.ind,method = "svm",train = F)
lines(x,y.fun(x,alpha), col = "blue", lwd = 3)
sim.boost = gbm(as.numeric(y) - 1 ~ ., data = df.tr, n.trees = 5000, distribution = "bernoulli", 
  shrinkage = 0.01, interaction.depth = 4)
class.plot(sim.boost, data = df, train.index = tr.ind, train = F,method = "gbm",
  n.trees = 5000, predict_type = "response")
lines(x,y.fun(x,alpha), col = "blue", lwd = 3)
sim.rf = randomForest(y ~ ., data = df, ntree = 1000, subset = tr.ind)
class.plot(sim.rf,data = df,train.index = tr.ind,method = "randomForest", train = F)
lines(x,y.fun(x,alpha), col = "blue", lwd = 3)

c("testing data error for SVM = ",mean(predict(sim3.best,df.te) != as.character(df.te$y)))
boost.pred.te = predict(sim.boost,df.te,n.trees = 3000, type = "response")
c("testing data error for boosting = ",mean(ifelse(boost.pred.te>0.5,1,0) != as.numeric(as.character(df.te$y))))
c("testing data error for random forest = ",mean(predict(sim.rf,df.te) != as.character(df.te$y)))
dev.off()

# Extensions
# Iris Example, with a modification
iris2 = iris[,3:5]
colnames(iris2) = c("x1","x2","y")
iris2$y = as.factor(ifelse(iris2$y == "versicolor",1,-1))
iris2$z = sqrt((iris2$x1-mean(iris2$x1))^2 + (iris2$x2 - mean(iris2$x2))^2)
set.seed(1)
tr.ind = sample(seq_len(nrow(iris2)),0.7*nrow(iris2))
iris2.tr = iris2[tr.ind,]
iris2.te = iris2[-tr.ind,]
plot(iris2[,1:2],col = as.numeric(iris2$y)+1, pch = as.numeric(iris2$y)+3, cex = 1.5)

## Use a direct linear SVM
set.seed(1)
C = c(seq(0.1,1,0.1),seq(2,10,1),seq(20,100,10))
iris2.tune = tune(svm, y ~ x1 + x2, data = iris2.tr, kernel = "linear",ranges = list(cost = C))
c("best tuned cost variable = ",as.numeric(iris2.tune$best.parameters))
iris2.best = svm(y ~ x1 + x2, data = iris2.tr, kernel = "linear", scale = F, cost = as.numeric(iris2.tune$best.parameters))
iris2.tr.lin = predict(iris2.best, iris2.tr)
iris2.te.lin = predict(iris2.best,iris2.te)
lin.tr.err = mean(iris2.tr.lin != iris2.tr$y)
lin.te.err = mean(iris2.te.lin != iris2.te$y)
c("training data error = ",lin.tr.err)
c("testing data error = ",lin.te.err)
plot(iris2.best,iris2,x1 ~ x2)

## Adding a new feature variable
##Let $z=\sqrt{(x_1-\bar{x}_1)^2 + (x_2-\bar{x}_2)^2}$
  
with(data = iris2,scatterplot3d(x = x1,y = x2,z = z,color = as.numeric(y)+1, 
  pch = as.numeric(y)+3))

## Redo a linear SVM with the added feature
set.seed(1)
iris2.tune2 = tune(svm, y ~ ., data = iris2.tr, kernel = "linear",ranges = list(cost = C))
c("best tuned cost variable = ",as.numeric(iris2.tune2$best.parameters))
iris2.best2 = svm(y ~ ., data = iris2.tr, kernel = "linear", scale = F, cost = as.numeric(iris2.tune2$best.parameters))
iris2.tr.lin2 = predict(iris2.best2, iris2.tr)
iris2.te.lin2 = predict(iris2.best2,iris2.te)
lin.tr.err2 = mean(iris2.tr.lin2 != iris2.tr$y)
lin.te.err2 = mean(iris2.te.lin2 != iris2.te$y)
c("training data error = ",lin.tr.err2)
c("testing data error = ",lin.te.err2)
plot(iris2.best2,iris2,x1 ~ x2)


## SVM plot from a different angle
plot(iris2.best2,iris2,x1 ~ z)

## SVM with a different option: Radial
iris2.svm = svm(y ~ ., data = iris2.tr[,1:3], kernel = "radial", scale = F)
iris2.tr.rad = predict(iris2.svm, iris2.tr[,1:3])
iris2.te.rad = predict(iris2.svm, iris2.te[,1:3])
rad.tr.err = mean(iris2.tr.rad != iris2.tr$y)
rad.te.err = mean(iris2.te.rad != iris2.te$y)
c("training data error = ",rad.tr.err)
c("testing data error = ",rad.te.err)
plot(iris2.svm,iris2[,1:3])



## A simulated linear regression example

\scriptsize

  - The data set has two $X$ variables and the response is $$E(Y) = 2x_1 +5x_2 - 2x_1x_2 - x_1^2 + 100\sin(x_1),$$ with standard error 0.1 \pause
  
  - 100 training data (black) and 100 test data (red) \pause
  
set.seed(1)
x1 = rnorm(200,1,10)
x2 = rexp(200,0.1)
y = sin(x1)*100 -x1^2 + 2*x1 + 5*x2 - 2*x1*x2 + rnorm(200,0,0.1)
df = data.frame(x1 = x1,x2 = x2,y = y)
tr.ind = 1:100
df.tr = df[tr.ind,]
df.te = df[-tr.ind,]
df$m = c(rep(1,100),rep(2,100))
with(data = df, scatterplot3d(x = x1, y = x2, z = y, color = m))
df$m = NULL


## Different methods with root MSEs
sim.lm = lm(y ~ ., data = df.tr)
sqrt(mean((predict(sim.lm,newdata = df.te) - df.te$y)^2))
sim.poly = lm(y ~ poly(x1,3)+poly(x2,3), data = df.tr)
sqrt(mean((predict(sim.poly,newdata = df.te) - df.te$y)^2))
sim.gam = mgcv::gam(y ~ s(x1) + s(x2), data = df, method = "REML", subset = tr.ind)
sqrt(mean((predict(sim.gam,newdata = df.te) - df.te$y)^2))
sim.svm.l = svm(y ~ ., data = df, kernel = "linear", scale = F, subset = tr.ind)
sqrt(mean((predict(sim.svm.l,newdata = df.te) - df.te$y)^2))
sim.svm.r = svm(y ~ ., data = df, kernel = "radial", scale = F, subset = tr.ind)
sqrt(mean((predict(sim.svm.r,newdata = df.te) - df.te$y)^2))
set.seed(12345)
sim.svm.tune = tune(svm, y ~ ., data = df.tr, 
  ranges = list(epsilon = seq(0,1,0.2), cost = 2^(seq(0.5,4,.5))))
#plot(sim.svm.tune)
sqrt(mean((predict(sim.svm.tune$best.model,newdata = df.te) - df.te$y)^2))


