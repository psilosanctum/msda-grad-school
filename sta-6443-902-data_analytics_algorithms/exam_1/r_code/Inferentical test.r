setwd("/Users/c2cypher/codebase/msda/msda-grad-school/sta-6443-902-data_analytics_algorithms")  # need to change this path

#install.packages("BSDA")  # BSDA package for Sign test

water=read.table("datasets/water.txt",header=TRUE, sep="")

str(water)

###############################################
# one-sample test 
# normality check for mortal and hardness
##############################################
summary(water$mortal)
hist(water$mortal)
boxplot(water$mortal); points(mean(water$mortal), col="red")
qqnorm(water$mortal);qqline(water$mortal, col = 2)
shapiro.test(water$mortal)

summary(water$hardness)
hist(water$hardness)
boxplot(water$hardness); points(mean(water$hardness), col="red")
qqnorm(water$hardness);qqline(water$hardness, col = 2)
shapiro.test(water$hardness)

# one-sample t-test
t.test(water$mortal, mu=1500)

t.test(water$mortal, mu=1500, alternative = "less") # "greater"


# sign test
library(BSDA)
?SIGN.test(water$hardness, md=45)

# SIGN.test(water$hardness, md=45, alternative = "less")
# for the homework, make a very specific conclusion: "we reject the null because..."
################################################
# two-sample test
# normality check by location
################################################

################################################
# hardness (South vs. North)
boxplot(hardness ~ location, data = water, main="hardness by location",
        xlab="location", ylab="hardness")

qqnorm(water$hardness[water$location=="N"]);
qqline(water$hardness[water$location=="N"], col = 2)

shapiro.test(water$hardness[water$location=="S"])
shapiro.test(water$hardness[water$location=="N"])

# non-parametric wilcox test
wilcox.test(hardness ~ location, data=water, exact=FALSE)


#################################################
# mortality (South vs. North)
boxplot(mortal ~ location, data=water, main="mortal by location",
        xlab="location", ylab="mortal")

shapiro.test(water$mortal[water$location=="S"])
shapiro.test(water$mortal[water$location=="N"])

# Equal variance test to decide - pooled t-test or satterthwaite t-test?
var.test(mortal ~ location, water, 
         alternative = "two.sided")
bartlett.test(mortal ~ location, water)

# parametric t-test
t.test(mortal ~ location, water, 
         alternative = "two.sided",var.equal=TRUE)


####################################################
# log transformation

load("datasets/research.RData")

# Salary of researchers from "Ap" (applied) and "Th" (Theory) fields.
# Aim to compare salary of two groups ("Ap" and "Th") 

# Chekc normality
boxplot(salary ~ field, data=research)
wilcox.test(salary ~ field, data=research, exact=TRUE)
# we reject the null which means they do not follow the same distribution

hist(research$salary[research$field=="Ap"])
hist(research$salary[research$field=="Th"])

# Log transformation

log.salary = log(research$salary)

research = cbind(research, log.salary)

boxplot(log.salary ~ field, data=research)

shapiro.test(research$log.salary[research$field=="Th"])
shapiro.test(research$log.salary[research$field=="Ap"])

# Equal variance test to decide - pooled t-test or satterthwaite t-test?
var.test(log.salary ~ field, data = research, 
         alternative = "two.sided")
bartlett.test(log.salary ~ field, data= research)

# parametric t-test
t.test(log.salary ~ field, data = research, 
       alternative = "two.sided",var.equal=TRUE)


