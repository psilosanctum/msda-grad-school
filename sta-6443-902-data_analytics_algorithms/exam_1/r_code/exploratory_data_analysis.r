###################################
#### Exploratory Data Analysis #####
###################################

# use either "e1071" or "fBasics" that works for your computer
#install.packages("e1071")
library(e1071)

#install.packages("fBasics")
library(fBasics)

#use built in dataset
?airquality  # information about dataset

View(airquality)
dim(airquality)
class(airquality)
str(airquality)

summary(airquality)



#####################
# visualization
#####################
# 1. histogram
hist(airquality$Ozone)
hist(airquality$Wind)
hist(airquality$Temp)

# 2. boxplot
# default setting
boxplot(airquality$Ozone)
points(mean(airquality$Ozone, na.rm=TRUE), col="blue", pch=2)   # mark mean value as a red point

# with graphical/ labeling options 
boxplot(airquality$Ozone,                     
        main = "Distribution of OZone",
        ylab = "Ozone",
        col = "green",
        border = "Blue",
        horizontal = FALSE
)
points(mean(airquality$Ozone, na.rm=TRUE), col="red")

?boxplot # explore other options

# 3. scatter plot - for two variables
plot(airquality$Temp, airquality$Ozone)
plot(airquality$Wind, airquality$Ozone)

#################################################
# descriptive statistics for "Wind"
#   - a variable without missing 
#################################################
summary(airquality$Wind)
mean(airquality$Wind); 
var(airquality$Wind)
range(airquality$Wind) # [min,max]
skewness(airquality$Wind) # skewness function in package "e1071" or "fBasics"
boxplot(airquality$Wind)

# mean value for Month=5
month5.wind = airquality[airquality$Month==5,"Wind"]
mean(month5.wind)

month5 = subset(airquality, Month==5)
mean(month5$Wind)


#################################################
# descriptive statistics for "Ozone"
#   - a variable with missing values
#################################################
summary(airquality$Ozone)  

mean(airquality$Ozone); var(airquality$Ozone)  # what happnes?

mean(airquality$Ozone, na.rm=TRUE); var(airquality$Ozone, na.rm=TRUE)

range(airquality$Ozone,na.rm=TRUE) # [min,max]
skewness(airquality$Ozone, na.rm=TRUE) # skewness function in package "e1071"

mean(airquality[airquality$Month==5,"Ozone"],na.rm=TRUE)
mean(airquality[airquality$Month==6,"Ozone"],na.rm=TRUE)
mean(airquality[airquality$Month==7,"Ozone"],na.rm=TRUE)

#######################################
# histogram and density plots 
par(mfrow=c(1,2))  # multiple plots in one panel # c(1,2) for 1 by 2 matrix plot

hist(airquality$Wind,main="Wind", xlab="Wind"); 
hist(airquality$Ozone,main="Ozone", xlab="Ozone")

plot(density(airquality$Wind),main="Wind"); 
plot(density(airquality$Ozone,na.rm=TRUE),main="Ozone")


par(mfrow=c(1,1))

# calculate descriptive statistics columnwise 
apply(airquality[ ,c("Ozone","Solar.R","Wind","Temp")],2, mean, na.rm=TRUE)
apply(airquality[ ,c("Ozone","Solar.R","Wind","Temp")],2, var, na.rm=TRUE)
apply(airquality[ ,c("Ozone","Solar.R","Wind","Temp")],2, skewness, na.rm=TRUE)

########################
# Normality check
########################
# qualitative way - visually check
qqnorm(airquality$Wind); qqline(airquality$Wind, col = 2)
qqnorm(airquality$Ozone); qqline(airquality$Ozone, col = 2)

# quantitative way - formal test
shapiro.test(airquality$Wind)
shapiro.test(airquality$Ozone)

###################################################
# Visualization and Normality check by groups
####################################################

boxplot(Ozone ~ Month, data=airquality, main="Ozone by Month",
        xlab="Month", ylab="Ozone")

# normality check for each Month
shapiro.test(airquality[airquality$Month==5, "Ozone"])
shapiro.test(airquality[airquality$Month==7, "Ozone"])
shapiro.test(airquality[airquality$Month==8, "Ozone"])

