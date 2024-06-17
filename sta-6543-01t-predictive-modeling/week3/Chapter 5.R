#install.packages('Metrics')
library(Metrics)
library(caret)


# Use the 'c' function to combine numbers into a vector 
y <- c(0.22, 0.83, -0.12, 0.89, -0.23, -1.30, -0.15, -1.4, 
0.62, 0.99, -0.18, 0.32, 0.34, -0.30, 0.04, -0.87, 
0.55, -1.30, -1.15, 0.20) #observed 

yhat <- c(0.24, 0.78, -0.66, 0.53, 0.70, -0.75, -0.41, -0.43, 
0.49, 0.79, -1.19, 0.06, 0.75, -0.07, 0.43, -0.42, 
-0.25, -0.64, -1.26, -0.07)  #predicted 

#MAE
mae(y, yhat)
#or
mean(abs(y - yhat))

#MSE
(MSE = mean((y - yhat)^2))

#RMSE 
sqrt(MSE)
#or
RMSE(y, yhat)


#R^2
cor(y, yhat)^2
#or
R2(y, yhat)

#Visualize the results 
diff <- y - yhat

#plot of the observed and predicted values
plot(y, yhat)
fit = lm(yhat~y)
abline(fit)

#plot of the predicted values and residuals 
residual = resid(fit)
plot(yhat, residual, col=2)
abline(h = 0, col = "darkgrey", lty = 2, lwd=2)
