library(car); library(olsrr)

setwd("C:/Users/sdy897/Box/Working files/Class/UTSA_STA6443_Algorithms1/HW/2020 FALL/HW3")  # need to change this path

##############################
#Exercise 1
#############################
#a)
heart=read.csv("heart.csv", header=TRUE)

lm.heart <- lm(Cholesterol~Weight, data=heart)
summary(lm.heart)

plot(lm.heart, which=4, cook.levels=cutoff, col = "navyblue")

# refit the model without influential points
inf.id=which(cooks.distance(lm.heart)>0.015)
lm.heart.refit=lm(Cholesterol~Weight, data=heart[-inf.id,])

summary(lm.heart.refit)
summary(lm.heart.refit)$r.square

#diagnostics plots
par(mfrow=c(2,2))
plot(lm.heart.refit, which=1:4,  col="blue")

####################################
#Exercise 2:
##################################
#a)
#Fit a linear regression model for cholesterol as a function of diastolic, systolic, and weight

lm.heart2 <- lm(Cholesterol~Weight+Diastolic+Systolic, data=heart)
summary(lm.heart2)


#diagnostics plots
par(mfrow=c(2,3))
plot(lm.heart2, which=1:6, col="blue")
dev.off()

# refit the model without influential points
inf.id=which(cooks.distance(lm.heart2)>0.015)
lm.heart2.refit=lm(Cholesterol~Weight+Diastolic+Systolic, data=heart[-inf.id,])

summary(lm.heart2.refit)
summary(lm.heart2.refit)$r.square

#diagnostics plots
par(mfrow=c(2,2))
plot(lm.heart2.refit, which=1:4,  col="blue")

# Variance of Inflation and pairwise scatter plot
vif(lm.heart2.refit)
pairs(heart[,c(1:3)], pch = 19) 

#####################################
#Exercise 3
#####################################
#a)model selection 
lm.full=lm(Cholesterol~Weight+Diastolic+Systolic, data=heart[-inf.id, ])
model.stepwise<-ols_step_both_p(lm.full, pent = 0.05, prem = 0.05, details = F)
model.stepwise

#b)fit final model

lm.final.step <- lm(Cholesterol~Systolic+Diastolic, data=heart)
summary(lm.final.step)

#diagnostics plots
par(mfrow=c(2,2))
plot(lm.final.step, which=1:4 , col= "blue")

#########################################
#Exercise 4
########################################
model.best.subset<-ols_step_best_subset(lm.full) 
model.best.subset
