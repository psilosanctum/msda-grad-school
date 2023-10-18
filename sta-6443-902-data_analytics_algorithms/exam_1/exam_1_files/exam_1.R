library(car) 
library(DescTools)
library(MASS)
library(e1071)
library(fBasics)
library(MASS)

setwd("/Users/c2cypher/codebase/msda/msda-grad-school/sta-6443-902-data_analytics_algorithms/exam_1/exam_1_files")
birthweight = read.csv("birthweight.csv", header=TRUE)

birthweight$Weight = as.numeric(birthweight$Weight)
birthweight$MomSmoke = as.factor(birthweight$MomSmoke)
birthweight$Black = as.factor(birthweight$Black)
birthweight$Married = as.factor(birthweight$Married)
birthweight$Boy = as.factor(birthweight$Boy)
birthweight$Ed = as.factor(birthweight$Ed)
str(birthweight)

# Exercise 1
# 1a)
boxplot(birthweight$Weight,
        main="Weight Boxplot",
        xlab="Infant Weight",
        ylab="Grams",
        col="red",
        border="black");
points(mean(birthweight$Weight, na.rm=TRUE), col="blue")

qqnorm(birthweight$Weight,
       main="Weight QQ-Plot");
qqline(birthweight$Weight, col="red")

shapiro.test(birthweight$Weight)

# 1b)
boxplot(Weight~MomSmoke,
        data=birthweight,
        main="Infant Weight by MomSmoke",
        xlab="MomSmoke",
        ylab="Infant Weight (grams)",
        col="red",
        border="black")

# 1c)
shapiro.test(birthweight$Weight[birthweight$MomSmoke==0])
shapiro.test(birthweight$Weight[birthweight$MomSmoke==1])

# Exercise 2
var.test(Weight ~ MomSmoke,
         data=birthweight,
         alternative="two.sided")
t.test(Weight ~ MomSmoke,
       data=birthweight,
       alternative="two.sided",
       var.equal=TRUE)

# Exercise 3
table(birthweight$MomSmoke)

# 3a)
aov.momsmoke = aov(Weight~MomSmoke,
                   data=birthweight)
LeveneTest(aov.momsmoke)

# 3b)
summary(aov.momsmoke)
ScheffeTest(aov.momsmoke)
lm.momsmoke = lm(Weight~MomSmoke,
                 data=birthweight)
summary(lm.momsmoke)$r.squared
par(mfrow=c(2,2))
plot(aov.momsmoke)

# Exercise 4
# 4a)
full_model = aov(Weight ~ Black + Married + Boy + MomSmoke + Ed,
                 data=birthweight)
Anova(full_model, type=3)

temp_model_1 = aov(Weight ~ Black + Married + Boy + MomSmoke,
                   data=birthweight)
Anova(temp_model_1, type=3)

temp_model_2 = aov(Weight ~ Black + Boy + MomSmoke,
                   data=birthweight)
Anova(temp_model_2, type=3)

temp_model_3 = aov(Weight ~ Black + MomSmoke,
                   data=birthweight)
Anova(temp_model_3, type=3)

temp_model_4 = aov(Weight ~ Black + MomSmoke + Black*MomSmoke,
                   data=birthweight)
Anova(temp_model_4, type=3)

final_model = aov(Weight ~ Black + MomSmoke,
                  data=birthweight)
Anova(final_model, type=3)

# 4b)
lm.final_model = lm(Weight ~ Black + MomSmoke,
                    data=birthweight)
summary(lm.final_model)$r.squared
par(mfrow=c(2,2))
plot(full_model)

# 4c)
final_model = aov(Weight ~ Black + MomSmoke,
                  data=birthweight)
Anova(final_model, type=3)
ScheffeTest(final_model)

