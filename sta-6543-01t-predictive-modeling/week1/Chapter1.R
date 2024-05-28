#### Basic commands 
x=c(1,3,2,5) #create a vector 
x 
y=seq(from=4, length=4, by=1);  #create a regular sequence
y
?seq 
length(x) 
length(y) 
x+y 
x/y 
ls()  #return a vector of character strings giving the names of the objects in the specified 
#environment
rm(x) #remove objects  
ls()

?matrix
x=matrix(data=c(1,2,3,4), nrow=2, ncol=2)
x=matrix(c(1,2,3,4) ,2,2)
x
matrix(c(1,2,3,4),2,2,byrow=TRUE)
sqrt(x)
x^2
x=rnorm(50)
y=x+rnorm(50,mean=50,sd=.1)
cor(x,y)
set.seed(1303)
rnorm (50)

#### Graphics
set.seed(1)
x=rnorm(100) #generate 100 standard normal r.v.s
y=rnorm(100) 
par(mfrow=c(2,2))
plot(x,y) 
plot(x,y,xlab="this is the x-axis",ylab="this is the y-axis", main="Plot of X vs Y") 
plot(x,y,col=2) #colors are indexed by numbers in R
dev.off() #shuts down the specified (by default the current) device


x=seq(-pi,pi,length=50) 
y=x 
f=outer(x,y,function (x,y)cos(y)/(1+x^2)) 
par(mfrow=c(2,2))
contour (x,y,f) 
contour(x,y,f,nlevels=45,add=T) 
fa=(f-t(f))/2 
contour(x,y,fa,nlevels=15) 
image(x,y,fa) 
persp(x,y,fa) 
persp(x,y,fa,theta=30) 
persp(x,y,fa,theta=30,phi=20)
persp(x,y,fa,theta=30,phi=70)
persp(x,y,fa,theta=30,phi=40)

#### Indexing Data
A=matrix(1:16,4,4)
A
A[2,3]
A[c(1,3),c(2,4)]
A[1:3,2:4]
A [1:2 ,]
A[1,]
A[1,1:4,drop=FALSE]
dim(A)

#### Loading Data
data = read.table("C://Users/DTY670/Desktop/STA6543 Summer 2022/Course Contents/Chapter 1/Income.txt")
data

#read the data with column name
data = read.table("C://Users/DTY670/Desktop/STA6543 Summer 2022/Course Contents/Chapter 1/Income.txt", header=TRUE)
data

#### Additional Graphical and Numerical Summaries
data = read.table("C://Users/DTY670/Desktop/STA6543 Summer 2022/Course Contents/Chapter 1/Income.txt", header=TRUE); data

dev.off()
#Scatter plot
plot(data$Income, data$Expenditure)

#linear regression 
fit= lm(Expenditure~Income, data=data)
summary(fit)
abline(fit, lwd=2,col=2)

#name x and y axis labels 
plot(data$Income, data$Expenditure, xlab="Income", ylab="Expenditure")

#linear regression 
fit= lm(Expenditure~Income, data=data)
summary(fit)
abline(fit, lwd=2,col=2)

#residual plot
residual = resid(fit)
plot(data$Income, residual)
abline(h=0)

#boxplot of residuals for outlier(s) detections
boxplot(residual)
