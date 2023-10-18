library(e1071);

setwd("/Users/c2cypher/codebase/msda/msda-grad-school/sta-6443-902-data_analytics_algorithms/exam_1/hw1")
cars=read.csv("Cars.csv", header=TRUE)

######################################################
# Exercise 1
########################################################

# (a)
MPG_Combo <- 0.6*cars$MPG_City+0.4*cars$MPG_Highway  # combined mpg varialbe 
cars=data.frame(cars, MPG_Combo)   # data frame with MPG_Combo 

boxplot(cars$MPG_Combo,
        main = "A Box Plot of the Combined MPG of All Vehicles",
        ylab = "MGP_Combo")

#######
#b)
#######
boxplot(MPG_Combo~Type, data=cars, main=" MPG_Combo by Vehicle Type ",
        xlab="Type", ylab="MGP_Combo")

#######
#c)
#######
# descriptive statistics
summary(cars$Horsepower)
mean(cars$Horsepower); var(cars$Horsepower)
range(cars$Horsepower) # [min,max]
skewness(cars$Horsepower) # skewness

# visualization
par(mfrow=c(1,2))
boxplot(cars$Horsepower, ylab="Horsepower"); points(mean(cars$Horsepower), col="red", pch=7)
hist(cars$Horsepower, xlab="Horsepower",main=""); 

# check Normality
par(mfrow=c(1,1))
qqnorm(cars$Horsepower); qqline(cars$Horsepower)
shapiro.test(cars$Horsepower) 

######
#d)
######
Sports=cars[cars$Type=="Sports", ]
# Sports=subset(cars, Type=="Sports") # different way to extrat Sports data

SUV=cars[cars$Type=="SUV", ]
# SUV=subset(cars, Type=="SUV")

Truck=cars[cars$Type=="Truck", ]
# Truck=subset(cars, Type=="Truck")

boxplot(Horsepower ~ Type, data=cars)
#######################################
#Sports
#######################################
par(mfrow=c(1,2))
boxplot(Sports$Horsepower, main="Sports")
qqnorm(Sports$Horsepower); qqline(Sports$Horsepower, col = 2)
shapiro.test(Sports$Horsepower) 

########################################
#SUV
########################################
boxplot(SUV$Horsepower, main="SUV")
qqnorm(SUV$Horsepower); qqline(SUV$Horsepower, col = 2, pch=7)
shapiro.test(SUV$Horsepower) 

########################################
#Truck
########################################
boxplot(Truck$Horsepower, main="Truck")
qqnorm(Truck$Horsepower); qqline(Truck$Horsepower, col = 2)
shapiro.test(Truck$Horsepower) 

################
#Exercise 2
################

wilcox.test(Truck$Horsepower, SUV$Horsepower, alternative = "two.sided")

# or we can perform through sub-data - different ways to generate sub data.frame
# wilcox.test result is same as above

sub.cars = cars[(cars$Type == "SUV" | cars$Type=="Truck"),]
sub.cars = cars[(cars$Type %in% c("SUV", "Truck")),]
sub.cars = subset(cars, Type %in% c("SUV","Truck"))

wilcox.test(Horsepower ~ Type, data=sub.cars, alternative = "two.sided")

##################
#Exercise 3
#################
July=airquality[airquality$Month==7, ]
Aug=airquality[airquality$Month==8, ]

qqnorm(July$Wind); qqline(July$Wind, col = 2)
shapiro.test(July$Wind) 

qqnorm(Aug$Wind); qqline(Aug$Wind, col = 2)
shapiro.test(Aug$Wind) 

var.test(July$Wind, Aug$Wind)
t.test(July$Wind, Aug$Wind, var.equal = TRUE)

# or we can perform through sub-data - different ways to generate sub data.frame
# var.test and t.test are same as above

sub.airquality = airquality[(airquality$Month == "7" | airquality$Month=="8"),]
sub.airquality = airquality[(airquality$Month %in% c("7", "8")),]
sub.airquality = subset(airquality, Month == "7" | Month=="8")

var.test(Wind ~ Month, data = sub.airquality)
t.test(Wind ~ Month, data = sub.airquality, var.equal = TRUE)



