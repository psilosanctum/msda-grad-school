################################################################################
### Section 2.1 Case Study: Predicting Fuel Economy

install.packages('AppliedPredictiveModeling') #install this package into R
#As long as you intall once, you can use it directly without installing it again next time. 

library(AppliedPredictiveModeling)

#Access the fuel econmy data
data(FuelEconomy)
names(cars2010)

#Access the predictor EngDispl
cars2010$EngDispl

## Format data for plotting against engine displacement

## Sort by engine displacement
cars2010 <- cars2010[order(cars2010$EngDispl),]
cars2011 <- cars2011[order(cars2011$EngDispl),]

## Combine data into one data frame
cars2010a <- cars2010
cars2010a$Year <- "2010 Model Year"
cars2011a <- cars2011
cars2011a$Year <- "2011 Model Year"

plotData <- rbind(cars2010a, cars2011a)
str(plotData) #compactly display the internal structure of data 

library(lattice)
xyplot(FE ~ EngDispl|Year, plotData,
       xlab = "Engine Displacement",
       ylab = "Fuel Efficiency (MPG)",
       between = list(x = 1.2))

##############################
## Fit a single linear model and conduct 10-fold CV to estimate the error
##############################
library(caret)
set.seed(1)
#use the cars2010 as training data to 
#build up a linear model
lm1Fit <- train(FE ~ EngDispl, 
                data = cars2010,
                method = "lm", 
                trControl = trainControl(method= "cv"))
lm1Fit
summary(lm1Fit)

#Fitted linear regression line
#efficiency = 50.5632 - 4.5209*displacement

#Quality of fit diagnostics 
par(mfrow=c(1,2))
plot(cars2010$EngDispl, cars2010$FE,xlab = "Engine Displacement", ylab = "Fuel Efficiency (MPG)")
lines(cars2010$EngDispl, fitted(lm1Fit), col=2, lwd=2)

Observed =cars2010$FE
Predicted= fitted(lm1Fit)
plot(Observed, Predicted, ylim=c(12, 70))

##############################
## Fit a quadratic model too
##############################

## Create squared terms
displacement =cars2010$EngDispl
cars2010$displacement2 =cars2010$EngDispl^2
cars2011$displacement2 =cars2011$EngDispl^2

set.seed(1)
lm2Fit <- train(FE ~ EngDispl + displacement2, 
                data = cars2010,
                method = "lm", 
                trControl = trainControl(method= "cv"))
lm2Fit
summary(lm2Fit)

par(mfrow=c(1,2))
#Quality of fit diagnostics 
plot(cars2010$EngDispl, cars2010$FE,xlab = "Engine Displacement", ylab = "Fuel Efficiency (MPG)")
lines(displacement, fitted(lm2Fit), col=2, lwd=2)

Observed =cars2010$FE
Predicted= fitted(lm2Fit)
plot(Observed, Predicted, ylim=c(12, 70))

##############################
## Fit a MARS model (via the earth package)
##############################
install.packages('earth')
library(earth)
?earth
set.seed(1)
marsFit <- train(FE ~ EngDispl, 
                 data = cars2010,
                 method = "earth",
                 tuneLength = 15,
                 trControl = trainControl(method= "cv"))
marsFit
summary(marsFit)

#determine the tuning parameter for
#Multivariate Adaptive Regression Splines (MARS)
plot(marsFit)

par(mfrow=c(1,2))
#Quality of fit diagnostics 
plot(cars2010$EngDispl, cars2010$FE,xlab = "Engine Displacement", ylab = "Fuel Efficiency (MPG)")
lines(displacement,fitted(marsFit), col=2, lwd=2)

Observed =cars2010$FE
Predicted= fitted(marsFit)
plot(Observed, Predicted, ylim=c(12, 70))


##############################
## Prediction performance based on the three models 
##############################
## Predict the test data for prediction
cars2011$lm1  <- predict(lm1Fit,  cars2011)
cars2011$lm2  <- predict(lm2Fit,  cars2011)
cars2011$mars <- predict(marsFit, cars2011)

## Get test set performance values via caret's postResample function
?postResample
postResample(pred = cars2011$lm1,  obs = cars2011$FE)
postResample(pred = cars2011$lm2,  obs = cars2011$FE)
postResample(pred = cars2011$mars, obs = cars2011$FE)
