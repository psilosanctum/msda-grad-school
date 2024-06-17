library(MASS)

#Sigmoid neuron
plot(seq(-5,5,length.out = 200),1/(1+exp(-seq(-5,5,length = 200))), type = "l", xlab = "x",
  ylab = expression(sigma(x)),ylim = c(0,1),cex =2)
abline(h=0,col="red")
abline(h=1,col="red")
abline(v=0,col = "green")
segments(-5,0,0,0,col = "green")
segments(0,1,5,1,col = "green")

#TanH / Hyperbolic Tangent activation function
plot(seq(-5,5,length.out = 200),2/(1+exp(-2*seq(-5,5,length = 200)))-1, type = "l", xlab = "x",
  ylab = expression(sigma(x)),ylim = c(-1,1),cex =2)

# ReLU (Rectified Linear Unit) Activation function 
plot(seq(0,3,length.out = 200),seq(0,3,length.out = 200), type = "l", xlab = "x",
  ylab = "ReLu(x)",xlim = c(-3,3),cex =2,col = "red")
segments(-3,0,0,0,col = "red")

# Leaky ReLU Activation function 
plot(seq(0,3,length.out = 200),seq(0,3,length.out = 200), type = "l", xlab = "x",
  ylab = "ReLu(x)",xlim = c(-3,3),cex =2,col = "red",ylim = c(-0.3,3))
segments(-3,-0.3,0,0,col = "red")


#How to choose steps
f = function(x){(10*x[1]^2 + x[2]^2)/2}
df = function(x){c(10*x[1],x[2])}
lx = ly = -20;ux = uy = 20
g = 0.3

x = seq(lx,ux,length = 50)
y = seq(ly,uy,length = 50)
zz = outer(x,y, FUN = function(x,y) (10*x^2 + y^2)/2)

z = c(1,20)
z1 = z - g*df(z)
r = cbind(rbind(z,z1),c(f(z),f(z1)))
for(i in 1:10){
  a = z1
  z1 = z1 - g*df(z1)
  z = a
  r = rbind(r,c(z1,f(z1)))
}

par(mfrow = c(1,2))
contour(x,y,zz, nlevels = 30, xlim = c(lx,ux),ylim = c(ly,uy))
points(0,0,pch =8, col = "blue", cex = 2)
lines(r[,1],r[,2])
points(r[,1],r[,2],col = "red")
legend("bottomright", border = "green", lwd = 3, 
       legend = expression(paste(gamma, " = 0.3, 10 steps")))
       
g = 0.005

x = seq(lx,ux,length = 50)
y = seq(ly,uy,length = 50)
zz = outer(x,y, FUN = function(x,y) (10*x^2 + y^2)/2)

z = c(1,20)
z1 = z - g*df(z)
r = cbind(rbind(z,z1),c(f(z),f(z1)))
for(i in 1:100){
  a = z1
  z1 = z1 - g*df(z1)
  z = a
  r = rbind(r,c(z1,f(z1)))
}
contour(x,y,zz, nlevels = 30, xlim = c(lx,ux),ylim = c(ly,uy))
points(0,0,pch = 8, col = "blue", cex = 2)
lines(r[,1],r[,2])
points(r[,1],r[,2],col = "red")
legend("bottomright", border = "green", lwd = 3,
       legend = expression(paste(gamma,  " = 0.005, 100 steps")))


## When the Step Size Is Right

g = 0.18

x = seq(lx,ux,length = 50)
y = seq(ly,uy,length = 50)
zz = outer(x,y, FUN = function(x,y) (10*x^2 + y^2)/2)

z = c(1,20)
z1 = z - g*df(z)
r = cbind(rbind(z,z1),c(f(z),f(z1)))
while(abs(f(z1)-f(z))>0.0001){
  a = z1
  z1 = z1 - g*df(z1)
  z = a
  r = rbind(r,c(z1,f(z1)))
}
contour(x,y,zz, nlevels = 30, xlim = c(lx,ux),ylim = c(ly,uy))
points(0,0,pch =3, col = "blue", cex = 2)
lines(r[,1],r[,2])
points(r[,1],r[,2],col = "red")
legend("bottomright", border = "green", lwd = 3,
       legend = expression(paste(gamma, " = 0.18, 36 steps")))

## Example Revisited
library(geometry)
alpha = beta = 0.5; g = 1
z = c(1,20)
c = 0
while(f(z - g*df(z)) > f(z) - alpha * g * dot(df(z),df(z))){
  g = beta*g
  c = c+1
}
z1 = z - g*df(z)
r = cbind(rbind(z,z1),c(f(z),f(z1)))
d = 1
while(abs(f(z1)-f(z))>0.0001){
  a = z1
  while(f(a - g*df(a)) > f(a) - alpha * g * dot(df(a),df(a))){
    g = beta*g
    c = c+1
  }
  z1 = z1 - g*df(z1)
  z = a
  r = rbind(r,c(z1,f(z1)))
  d = d+1
}
contour(x,y,zz, nlevels = 30, xlim = c(lx,ux),ylim = c(ly,uy))
points(0,0,pch =3, col = "blue", cex = 2)
lines(r[,1],r[,2])
points(r[,1],r[,2],col = "red")
legend("bottomright", border = "green", lwd = 3,
       legend = expression(paste("initial ",gamma, " = 1", ", final ", gamma, " = 0.18, 49 steps")))


## A better understanding of the sigmoid function
sig = function(s = 1, v0 = 0, v){1/(1+exp(-s*(v-v0)))}
x = seq(-10,10,length.out = 300)
plot(x,sig(v=x),xlab = "v",ylab = expression(sigma(s(v-v[0]))), col = "red", type = "l",lwd = 2)
lines(x,sig(s=0.5,v=x),lty = 2, col="blue",lwd = 2)
lines(x,sig(s=10,v=x),lty = 2, col="green",lwd = 2)
lines(x,sig(s=2,v0=2,v=x),lty = 2, col="brown",lwd = 2)
lines(x,sig(s=5,v0=-5,v=x),lty = 2, col="pink",lwd = 2)
legend("bottomright",legend = c("v0=0,s=1","v0=0,s=0.5","v0=0,s=10","v0=2,s=2","v0=5,s=5"),
  col = c("red","blue","green","brown","pink"),lty = c(1,rep(2,4)),cex = 1.5)


## An example: infert data
df = infert[,c("age","parity","induced","spontaneous","case")]
summary(df)

## Case versus others
library(neuralnet)
set.seed(1)
tr.ind = sample(seq_len(nrow(df)),floor(0.7*nrow(df)))
df.tr = df[tr.ind,]
df.te = df[-tr.ind,]
inf.nn = neuralnet(case ~ ., data = df.tr, hidden = 1, err.fct = "ce", linear.output = F, rep = 3)
# linear.output should be FALSE for categorical outputs
# Default act.fct is "sigmoid" (logistic)
# err.fct is either "sse" or "ce" (cross-entropy)
# hidden is the number of nodes in the layer 
# 
# Default algorithm is "Resilient Backpropagation" (rprop+) with weight backtracking

inf.nn$weights[[1]][[1]]
inf.nn$weights[[1]][[2]]

## Neural network plot (rep = 1)
plot(inf.nn, rep = 1)


## Neural network plot (rep = 2)
plot(inf.nn, rep = 2)


## Neural network plot (rep = 3)
plot(inf.nn, rep = 3)

## Neural network plot (lowest error)
plot(inf.nn, rep = "best"); 
rep.best = which.min(inf.nn$result.matrix[1,])
rep.best

## NN weights details 

inf.pred = predict(inf.nn, df.te[1,],all.units = T, rep = rep.best)
# 1. Use 1st line in the test set; 2. all.units = T shows details
inf.pred

n1 = inf.nn$weights[[rep.best]][[1]][1] + as.matrix(df.te[1,1:4]) %*%
  inf.nn$weights[[rep.best]][[1]][2:5]
nn1 = 1/(1+exp(-n1))
n2 = inf.nn$weights[[rep.best]][[2]][1] + nn1 * 
  inf.nn$weights[[rep.best]][[2]][2]
nn2 = 1/(1+exp(-n2))
print(c(nn1,nn2))

df.te[1,]

## One more try 
set.seed(12345)
inf.nn1 = neuralnet(case ~ ., data = df.tr, hidden = 1, err.fct = "ce", linear.output = F)
inf.pred = predict(inf.nn1, df.te[1,])
plot(inf.nn1, rep = "best")
inf.pred

## More nodes and layers in NN 
set.seed(123)
inf2.1.nn = neuralnet(case ~ ., data = df.tr, hidden = c(2,1), err.fct = "ce", 
  linear.output = F,stepmax = 1000000)
plot(inf2.1.nn, rep = "best")
predict(inf2.1.nn,df.te[1,])

## Test Errors 
df.te[1,]
df.pred = predict(inf.nn, newdata = df.te, rep = rep.best)
df1.pred = predict(inf.nn1, newdata = df.te)
df2.1.pred = predict(inf2.1.nn, newdata = df.te)
mean(round(df.pred,0) != df.te$case)
mean(round(df1.pred,0) != df.te$case)
mean(round(df2.1.pred,0) != df.te$case)


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
par(mfrow = c(1,2))
par(pty = "s")
plot(df.tr$x1,df.tr$x2, xlab = "x1",ylab = "x2", col = as.numeric(df.tr$y)+1,
  pch = as.numeric(df.tr$y)+3, main = "100 training data",cex = 1.5)
par(pty = "s")
plot(df.te$x1,df.te$x2, xlab = "x1",ylab = "x2", main = "200 test data",col = as.numeric(df.te$y)+1,
  pch = as.numeric(df.te$y)+3,cex = 1.5)



#########################
##
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
    }else if(method == "nn"){plot.title = paste("Neural Network classification for ")
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
  }else if(method == "nn"){
    p = apply(predict(model, g),1,which.max)-1
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

#########################
## Representational Power
par(mfrow = c(1,3))
par(pty = "s")
set.seed(1)
sim.nn3 = neuralnet(y ~ ., df.tr, hidden = 3, linear.output = F, err.fct = "ce", stepmax = 1000000)
class.plot(sim.nn3,df, train.index = tr.ind, method = "nn")
set.seed(5)
sim.nn6 = neuralnet(y ~ ., df.tr, hidden = 6, linear.output = F, err.fct = "ce", stepmax = 1000000)
class.plot(sim.nn6,df, train.index = tr.ind, method = "nn")
set.seed(12)
sim.nn12 = neuralnet(y ~ ., df.tr, hidden = 12, linear.output = F, err.fct = "ce", stepmax = 1000000)
class.plot(sim.nn12,df, train.index = tr.ind, method = "nn")

print(rbind(c("train err for 3 nodes","train err for 6 nodes","train err for 12 nodes"),
  c(mean(apply(predict(sim.nn3,df.tr),1,which.max)-1 != df.tr$y),
    mean(apply(predict(sim.nn6,df.tr),1,which.max)-1 != df.tr$y),
    mean(apply(predict(sim.nn12,df.tr),1,which.max)-1 != df.tr$y))))



## Test data 
print(rbind(c("test err for 3 nodes","test err for 6 nodes","test err for 12 nodes"),
  c(mean(apply(predict(sim.nn3,df.te),1,which.max)-1 != df.te$y),
    mean(apply(predict(sim.nn6,df.te),1,which.max)-1 != df.te$y),
    mean(apply(predict(sim.nn12,df.te),1,which.max)-1 != df.te$y))))

par(mfrow = c(1,3))
par(pty = "s")
class.plot(sim.nn3,df, train.index = tr.ind, method = "nn",train = F)
class.plot(sim.nn6,df, train.index = tr.ind, method = "nn",train = F)
class.plot(sim.nn12,df, train.index = tr.ind, method = "nn",train = F)

## Another simulated data
sim.nn.list = readRDS("C://Users/likeb/Desktop/StatisticalLearning/ClassSlides/Data/simulation.neuralnet.rds")
par(mfrow = c(1,2))
df.tr = sim.nn.list[["df.tr"]]
df.te = sim.nn.list[["df.te"]]
df = sim.nn.list[["df"]]
tr.ind = sim.nn.list[["tr.ind"]]
sim.nn1 = sim.nn.list[["sim.nn1"]]
sim.nn2 = sim.nn.list[["sim.nn2"]]
sim.nn3 = sim.nn.list[["sim.nn3"]]
plot(df.tr$x1,df.tr$x2, col = df.tr$y+1,pch = 2*df.tr$y+3,xlab = "x1",ylab = "x2",main = "Train data")
plot(df.te$x1,df.te$x2, col = df.te$y+1,pch = 2*df.te$y+3,xlab = "x1",ylab = "x2",main = "Test data")

## Two neural network model results
par(mfrow = c(2,2))
class.plot(sim.nn1,df,train.index = tr.ind,method = "nn")
class.plot(sim.nn2,df,train.index = tr.ind,method = "nn")
class.plot(sim.nn1,df,train.index = tr.ind,method = "nn",train = F)
class.plot(sim.nn2,df,train.index = tr.ind,method = "nn",train = F)

## The models and Errors

sim.nn1$call
sim.nn2$call
tr1.pred = apply(predict(sim.nn1,df.tr),1,which.max)-1
tr2.pred = apply(predict(sim.nn2,df.tr),1,which.max)-1
te1.pred = apply(predict(sim.nn1,df.te),1,which.max)-1
te2.pred = apply(predict(sim.nn2,df.te),1,which.max)-1
print(rbind(c("train err for nn1","test err for nn1"),c(round(mean(tr1.pred != df.tr$y),2),round(mean(te1.pred != df.te$y),2))))
print(rbind(c("train err for nn2","test err for nn2"),c(round(mean(tr2.pred != df.tr$y),2),round(mean(te2.pred != df.te$y),2))))
print(rbind(c("time spent to calculate nn1 =",sim.nn.list[["time.nn1"]]),
  c("time spent to calculate nn2 =",sim.nn.list[["time.nn2"]])))


## Plot for network 1
plot(sim.nn1,rep = "best")

## Plot for network 2
plot(sim.nn2,rep = "best")

## A deeper learning model
par(mfrow = c(1,2))
class.plot(sim.nn3,df,train.index = tr.ind,method = "nn")
class.plot(sim.nn3,df,train.index = tr.ind,method = "nn",train = F)
sim.nn3$call
tr3.pred = apply(predict(sim.nn3,df.tr),1,which.max)-1
te3.pred = apply(predict(sim.nn3,df.te),1,which.max)-1
print(rbind(c("train err for nn3","test err for nn3"),c(round(mean(tr3.pred != df.tr$y),2),round(mean(te3.pred != df.te$y),2))))
print(c("time spent to calculate nn3 =",sim.nn.list[["time.nn3"]]))

## Network 3 plot

```{r fig.align='center',out.width="90%"}
plot(sim.nn3,rep = "best")
