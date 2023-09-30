# HW1
setwd("/Users/c2cypher/codebase/msda/sta-6443-902-data_analytics_algorithms/HW1") # set your own path

######################################################
# Exercise 1: Descriptive Statistics
########################################################
library(dplyr)
library(e1071)
library(fBasics)
library(MASS)
cars=read.csv("Cars.csv", header = TRUE)  # read dataset 

# (a)
MPG_Combo <- 0.6*cars$MPG_City+0.4*cars$MPG_Highway  # combined mpg varialbe 
cars=data.frame(cars, MPG_Combo)   # data frame with MPG_Combo 

# box plot for MPG_Combo
boxplot(cars$MPG_Combo, 
        main="MPG Combined - 60% City & 40% Highway",
        ylab="MPG",
        xlab="MPG Combo",
        col="red",
        border="black"); 
points(mean(cars$MPG_Combo, na.rm = TRUE), col="blue")

# (b)
boxplot(MPG_Combo~Type,
        data = cars,
        main="MPG_Combo by Type",
        xlab="Type",
        ylab="MPG_Combo",
        col="red",
        border="black")

# (c)
# descriptive statistics
summary(cars$Horsepower)
mean(cars$Horsepower)
median(cars$Horsepower)
var(cars$Horsepower)
range(cars$Horsepower)
skewness(cars$Horsepower)

# Visual
boxplot(cars$Horsepower, 
        main = "Horsepower Box Plot - All Vehicles",
        xlab = "Horsepower",
        ylab = "Value",
        col = "red",
        border = "black"); 
points(mean(cars$Horsepower, na.rm = TRUE), col="blue")

hist(cars$Horsepower, 
     main = "Horsepower Histogram - All Vehicles",
     col = "red",
     border = "black")

qqnorm(cars$Horsepower,
       main = "Horsepower QQ-Plot - All Vehicles");
qqline(cars$Horsepower, col = "red")

# quantitative
shapiro.test(cars$Horsepower)

# (d)

# Sports, SUV, Truck filtering and box plot
specified_types <- c("Sports", "SUV", "Truck")
cars2 = filter(cars, Type %in% specified_types)
boxplot(Horsepower ~ Type, 
        data = cars2, 
        main="Horsepower by Type",
        xlab="Type", 
        ylab="Horsepower", 
        col="red", 
        border="black"); 
points(mean(cars$Horsepower), col="blue")

# Sports
qqnorm(cars2$Horsepower[cars2$Type=="Sports"],
       main = "QQ-Plot - Sports");
qqline(cars2$Horsepower[cars2$Type=="Sports"], col = "red")
hist(cars2$Horsepower[cars2$Type=="Sports"], 
     main = "Histogram - Sports", 
     xlab="Sports",
     col = "red",
     border = "black")
shapiro.test(cars2$Horsepower[cars2$Type=="Sports"])

# SUV
qqnorm(cars2$Horsepower[cars2$Type=="SUV"],
       main = "QQ-Plot - SUV");
qqline(cars2$Horsepower[cars2$Type=="SUV"], col = "red")
hist(cars2$Horsepower[cars2$Type=="SUV"], 
     main = "Histogram - SUV", 
     xlab="SUV",
     col = "red",
     border = "black")
shapiro.test(cars2$Horsepower[cars2$Type=="SUV"])

# Truck
qqnorm(cars2$Horsepower[cars2$Type=="Truck"],
       main = "QQ-Plot - Truck");
qqline(cars2$Horsepower[cars2$Type=="Truck"], col = "red")
hist(cars2$Horsepower[cars2$Type=="Truck"], 
     main = "Histogram - Truck", 
     xlab="Truck",
     col = "red",
     border = "black")
shapiro.test(cars2$Horsepower[cars2$Type=="Truck"])


########################################################
# Exercise 2: Hypothesis Testing
########################################################

# (2c)
# Filter DataFrame to include only SUV & Truck 
suv_truck_types <- c("SUV", "Truck")
cars3 = filter(cars2, Type %in% suv_truck_types)

# Perform the Wilcoxon rank-sum test
wilcox.test(Horsepower~Type, data = cars3, exact=FALSE)


########################################################
# Exercise 3: Hypothesis Testing
########################################################

# (3a)
# Import dataset
df = airquality

# Filter DataFrame to include only July & August 
months <- c(7, 8)
aug_july_df = filter(df, Month %in% months)

# Create QQ-plot for July normality check.
qqnorm(aug_july_df$Wind[aug_july_df$Month==7],
       main = "QQ-Plot - July");
qqline(aug_july_df$Wind[aug_july_df$Month==7], col = "red")

# Perform the Shapiro-Wilk test for July normality check.
shapiro.test(aug_july_df$Wind[aug_july_df$Month==7])

# Create QQ-plot for August normality check.
qqnorm(aug_july_df$Wind[aug_july_df$Month==8],
       main = "QQ-Plot - August");
qqline(aug_july_df$Wind[aug_july_df$Month==8], col = "red")

# Perform the Shapiro-Wilk test for August normality check.
shapiro.test(aug_july_df$Wind[aug_july_df$Month==8])

var.test(Wind ~ Month, data=aug_july_df, alternative="two.sided")

# (3c)
t.test(Wind ~ Month, data = aug_july_df, alternative = "two.sided", var.equal=TRUE)

