# STA6443 HW2
library(DescTools); library(car)
setwd("/Users/c2cypher/codebase/msda/msda-grad-school/sta-6443-902-data_analytics_algorithms/exam_1/HW2")  # need to change this path

############################
#Exercise 1
############################
heartbpchol <- read.csv("data/heartbpchol.csv", header=TRUE)
str(heartbpchol)

#a)
aov.heart <- aov(Cholesterol ~ BP_Status, data = heartbpchol)
summary(aov.heart)

lm.heart <- lm(Cholesterol ~ BP_Status, data = heartbpchol)
summary(lm.heart)$r.squared

LeveneTest(aov.heart)


#b)
TukeyHSD(aov.heart)
ScheffeTest(aov.heart)

############################
#Exercise 2
############################
bupa <- read.csv("data/bupa.csv", header=TRUE)
str(bupa)
bupa$drinkgroup <- as.factor(bupa$drinkgroup) # drinking group is a categorical. Must address as factor before anova.

#a)
aov.mcv <- aov(mcv ~ drinkgroup, data = bupa)
summary(aov.mcv)

lm.mcv <- lm(mcv ~ drinkgroup, data = bupa)
summary(lm.mcv)$r.squared

LeveneTest(aov.mcv)

#b)
aov.alkphos <- aov(alkphos ~ drinkgroup, data = bupa)
summary(aov.alkphos)

lm.alkphos <- lm(alkphos ~ drinkgroup, data = bupa)
summary(lm.alkphos)$r.squared

leveneTest(aov.alkphos)

#c)
TukeyHSD(aov.mcv)
TukeyHSD(aov.alkphos)

############################
#Exercise 3
############################
#a) sex, rank and interaction
psych <- read.csv("data/psych.csv", header=TRUE)
str(psych)

table(psych$rank); table(psych$sex)  # check unbalanced

aov.psych1  <- aov(salary ~ sex*rank, data = psych)
summary(aov.psych1)

aov.psych2  <- aov(salary ~ rank*sex, data = psych)
summary(aov.psych2)

Anova(aov.psych1, type=3)  # Type3 test

lm.psych1 <- lm(salary ~ sex*rank, data = psych)
summary(lm.psych1)$r.squared

#b)
aov.psych3  <- aov(salary ~ sex+rank, data = psych)
summary(aov.psych3)

aov.psych4  <- aov(salary ~ rank+sex, data = psych)
summary(aov.psych4)

Anova(aov.psych3, type=3)  # Type3 test

lm.psych3 <- lm(salary ~ sex*rank, data = psych)
summary(lm.psych3)$r.squared

#c)
par(mfrow=c(2,2))
plot(aov.psych3)

#d)
TukeyHSD(aov.psych3)

############################
#Exercise 4
############################

cars <- read.csv("data/cars_new.csv", header=TRUE)
str(cars)
cars$cylinders <- as.factor(cars$cylinders)

# a)
# 3-way main effect model (type, origin, cylinders)
aov.cars1 <- aov(mpg_highway ~ type + origin + cylinders  , data = cars)
Anova(aov.cars1, type=3)  # Type III tests

#refit without origin
aov.cars2 <- aov(mpg_highway ~ type + cylinders  , data = cars)
Anova(aov.cars2, type=3)  # Type III tests

lm.cars2 <- lm(mpg_highway ~ type + cylinders  , data = cars)
summary(lm.cars2)$r.squared

#b) 
# adding interaction terms from model (a)
aov.cars3<- aov(mpg_highway ~ type + cylinders + type*cylinders  , data = cars)
summary(aov.cars3)
Anova(aov.cars3, type=3)  # Type III tests

lm.cars3 <- lm(mpg_highway ~ type + cylinders + type*cylinders , data = cars)
summary(lm.cars3)$r.squared

#c)
TukeyHSD(aov.cars3)

