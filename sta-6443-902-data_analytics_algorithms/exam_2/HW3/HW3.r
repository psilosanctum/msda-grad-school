library(tidyverse)
library(olsrr)
library(car)

setwd("/Users/c2cypher/codebase/msda/msda-grad-school/sta-6443-902-data_analytics_algorithms/exam_2/HW3/")

# Exercise 1
# 1a)
heart <- read_csv("heart.csv", show_col_types = FALSE)

linearmodel.heart = lm(Cholesterol ~ Weight, heart)

plot(heart$Weight, heart$Cholesterol, xlab ="Weight", ylab ="Cholesterol")
abline(linearmodel.heart, col ="red")

cor(heart$Weight, heart$Cholesterol, method ="spearman")

plot(linearmodel.heart, which=c(1:4))
par(mfrow=c(2,2))


# 1b)
summary(linearmodel.heart)


# Exercise 2
linearmodel.heart2 = lm(Cholesterol~., data = heart)

pairs(heart)

plot(linearmodel.heart2, which=c(1:4))
par(mfrow=c(2,2))

influentialpoints <- which(cooks.distance(linearmodel.heart2) > 0.015) 
heart[influentialpoints, ]

linearmodel.heart2 <- lm(Cholesterol~., data = heart[-influentialpoints, ])

# 2b)
summary(linearmodel.heart2)

vif(linearmodel.heart2)


# Exercise 3
# 3a)
stepwisemodel = ols_step_both_p(linearmodel.heart2, pent = 0.05, prem = 0.05, details = FALSE)
stepwisemodel

plot(stepwisemodel)

linearmodel.step = lm(Cholesterol~ Systolic + Diastolic, data = heart[-influentialpoints, ])

plot(linearmodel.step, which=c(1:4))
par(mfrow=c(2,2))


# 3b)
linearmodel.step = lm(Cholesterol~ Systolic + Diastolic, data = heart)
summary(linearmodel.step)


# Exercice 4
# 4a)
bestmodel = ols_step_best_subset(linearmodel.heart2)
bestmodel

