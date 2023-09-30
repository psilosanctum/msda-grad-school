library(car)
library(MASS)
library(DescTools)

setwd("/Users/c2cypher/codebase/msda/sta-6443-902-data_analytics_algorithms/HW2")

# Exercise 1
# 1a)
heart = read.csv("data/heartbpchol.csv") 
heart$Cholesterol = as.numeric(heart$Cholesterol)
heart$BP_Status = as.factor(heart$BP_Status)
str(heart)

table(heart$BP_Status) 

boxplot(Cholesterol ~ BP_Status, heart, 
        main = "Cholesterol Distribution by BP Status",
        xlab = "BP Status",
        ylab = "Cholesterol",
        col = "red",
        horizontal = FALSE)

aov.heart = aov(Cholesterol ~ BP_Status, heart)
summary(aov.heart)

lm.res = lm(Cholesterol ~ BP_Status, heart)
summary(lm.res)$r.squared

leveneTest(aov.heart)

par(mfrow=c(2,2)) 
plot(aov.heart)

# 1b)
ScheffeTest(aov.heart)

# Exercise 2
bupa = read.csv("data/bupa.csv")
bupa$mcv = as.numeric(bupa$mcv)
bupa$alkphos = as.numeric(bupa$alkphos)
bupa$drinkgroup = as.factor(bupa$drinkgroup)
str(bupa)

table(bupa$drinkgroup) 

boxplot(mcv ~ drinkgroup, bupa, 
        main = "Mean Corpuscular Volume Distribution by Drink Group",
        xlab = "Drink Group",
        ylab = "Mean Corpuscular Volume",
        col = "red",
        horizontal = FALSE)
aov.mcv <- aov(mcv ~ drinkgroup, bupa)
summary(aov.mcv)

lm.res_mcv <- lm(mcv ~ drinkgroup, bupa)
summary(lm.res_mcv)$r.squared

leveneTest(aov.mcv)

par(mfrow=c(2,2))
plot(aov.mcv)

# 2b)
table(bupa$drinkgroup) 

boxplot(alkphos ~ drinkgroup, bupa,
        main = "Alkaline Phosphatase Distribution by Drink Group",
        xlab = "Alkaline Phosphatase",
        ylab = "Drink Group",
        col = "red",
        horizontal = FALSE)

aov.alkphos <- aov(alkphos ~ drinkgroup, bupa)
summary(aov.alkphos)

lm.alkphos <- lm(alkphos ~ drinkgroup, bupa)
summary(lm.alkphos)$r.squared

leveneTest(aov.alkphos)

par(mfrow=c(2,2))
plot(aov.alkphos)

# 2c)
ScheffeTest(aov.mcv)
ScheffeTest(aov.alkphos)

# Exercise 3
# 3a)
psych = read.csv("data/psych.csv")
psych$salary = as.numeric(psych$salary)
str(psych)

table(psych$sex); table(psych$rank)

aov.psych1 = aov(salary ~ sex * rank, psych)
summary(aov.psych1)

aov.psych2 = aov(salary ~ rank * sex, psych)
summary(aov.psych2)

Anova(aov.psych1, type = 3)

lm.psych1 = lm(salary ~ sex*rank, psych)
summary(lm.psych1)$r.squared

# 3b)
aov.psych3 = aov(salary ~ rank + sex, psych)
summary(aov.psych3)

aov.psych4 = aov(salary ~ sex + rank, psych)
summary(aov.psych4)

Anova(aov.psych3, type = 3)

lm.psych3 = lm(salary ~ rank + sex, psych)
summary(lm.psych3)$r.squared

# 3c)
par(mfrow=c(2,2))
plot(aov.psych3)

# 3d)
TukeyHSD(aov.psych4)
TukeyHSD(aov.psych3)

# Exercice 4
# 4a)
cars = read.csv("data/cars_new.csv")
cars$mpg_highway = as.numeric(cars$mpg_highway)
cars$cylinders = as.factor(cars$cylinders)
cars$origin = as.factor(cars$origin)
cars$type = as.factor(cars$type)
str(cars)

aov.cars <- aov(mpg_highway ~ cylinders + origin + type, cars)
Anova(aov.cars, type = 3)

lm.cars <- lm(mpg_highway ~ cylinders + type, cars)
summary(lm.cars)$r.squared

# 4b)
aov.cars2 <- aov(mpg_highway ~ cylinders + type + cylinders * type, cars)
Anova(aov.cars2, type = 3)

lm.cars2 <- lm(mpg_highway ~ cylinders + type + cylinders * type, cars)
summary(lm.cars2)$r.squared

par(mfrow=c(2,2))
plot(aov.cars2)

# 4c)
TukeyHSD(aov.cars2)

