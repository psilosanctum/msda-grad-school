library(LearnBayes)
data(studentdata)
attach(studentdata)
head(studentdata)

# 1a) 
hist(studentdata$Dvds, 
     main="DVDs Owned by Students - Histogram", 
     xlab="Total DVDs", 
     ylab="Frequency", 
     col="blue", 
     border="black")

# 1b)
summary(studentdata$Dvds)

# 1c)
table(studentdata$Dvds)
barplot(table(studentdata$Dvds), 
        main = 'Dvds Owned By Students - Barplot', 
        xlab ='DVDs Count', 
        ylab = 'Student Count', 
        col = 'blue', 
        border = 'black')

# 2a)
boxplot(Height ~ Gender, 
        data = studentdata, 
        main = "Heights by Gender - Boxplot", 
        xlab = "Gender", 
        ylab = "Height (inches)", 
        col = c("blue", "green"))

# 2b) 
output = boxplot(Height ~ Gender)
print(output)

# 2c)
avg_male_height = mean(Height[Gender == "male"], 
                       na.rm = TRUE)
avg_female_height = mean(Height[Gender == "female"], 
                         na.rm = TRUE)
height_diff = avg_male_height - avg_female_height

print(paste0("Male height: ", 
             round(avg_male_height, 
                   digits = 2), 
             " inches."))
print(paste0("Female height: ", 
             round(avg_female_height, 
                   digits = 2), 
             " inches."))
print(paste0("On average, male students are ", 
             round(height_diff, 
                   digits = 2), 
             " inches taller than females."))

# 3a)
plot(ToSleep, WakeUp, 
     xlab = "Sleep Time", 
     ylab = "WakeUp Time", 
     main = "ToSleep and WakeUp - Scatterplot",
     pch = 19, 
     col = "blue")

# 3b)
plot(ToSleep, WakeUp, 
     xlab = "Sleep Time", 
     ylab = "WakeUp Time", 
     main = "ToSleep and WakeUp - Scatterplot",
     pch = 19,
     col = "blue")
fit = lm(WakeUp ~ ToSleep)
summary(fit)
abline(fit, col = "black", lwd = 2)
