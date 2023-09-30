# HW1
setwd() # set your own path

######################################################
# Exercise 1
########################################################
cars=read.csv("Cars.csv", header = TRUE)  # read dataset 

# (a)
MPG_Combo <- 0.6*cars$MPG_City+0.4*cars$MPG_Highway  # combined mpg varialbe 
cars=data.frame(cars, MPG_Combo)   # data frame with MPG_Combo 
