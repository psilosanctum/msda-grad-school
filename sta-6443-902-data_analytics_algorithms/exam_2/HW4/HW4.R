library(tidyverse)
library(ResourceSelection)
library(DescTools)

setwd("/Users/c2cypher/codebase/msda/msda-grad-school/sta-6443-902-data_analytics_algorithms/exam_2/HW4")

# Exercise 1
# 1a)
liverdata<- read.csv("liver-1.csv", header = TRUE)
str(liverdata)
liverFemale = liverdata[which(liverdata$Gender == "Female"),]
glmnullFemale = glm(LiverPatient ~ 1, data = liverFemale, family = "binomial")
glmfullFemale = glm(LiverPatient ~ Age + TB + DB +Alkphos + Alamine + Aspartate + TP + ALB, data = liverFemale, family = "binomial")
stepwiseselectionfemale = step(glmnullFemale, scope = list(upper = glmfullFemale),
                               direction="both",test="Chisq", trace = F) 
summary(stepwiseselectionfemale)


# 1b)
hoslem.test(stepwiseselectionfemale$y, fitted(stepwiseselectionfemale), g=10)
residualdeviance = residuals(stepwiseselectionfemale, type = "deviance")
residualpearson = residuals(stepwiseselectionfemale, type = "pearson")
standardresidualdeviance = residuals(stepwiseselectionfemale, type = "deviance")/sqrt(1 - hatvalues(stepwiseselectionfemale))
standardresidualpearson = residuals(stepwiseselectionfemale, type = "pearson")/sqrt(1 - hatvalues(stepwiseselectionfemale))
par(mfrow=c(1,2))
plot(standardresidualdeviance[stepwiseselectionfemale$model$LiverPatient==0], col = "red", 
     ylim = c(-3.5,3.5), ylab = "Standard Deviance Residuals", xlab = "ID")
points(standardresidualdeviance[stepwiseselectionfemale$model$LiverPatient==1], col = "blue")
plot(standardresidualpearson[stepwiseselectionfemale$model$LiverPatient==0], col = "red", 
     ylim = c(-3.5,3.5), ylab = "Standard Pearson Residuals", xlab = "ID")
points(standardresidualpearson[stepwiseselectionfemale$model$LiverPatient==1], col = "blue")
plot(stepwiseselectionfemale, which = 4, id.n = 5)
influenceddiagnostics = which(cooks.distance(stepwiseselectionfemale)>0.25)
influenceddiagnostics

# 1c)
summary(stepwiseselectionfemale)
round(exp(stepwiseselectionfemale$coefficients),3)

# Exercise 2
# 2a)
liverMale = liverdata[which(liverdata$Gender == "Male"),]
glmnullMale = glm(LiverPatient ~ 1, data = liverMale, family = "binomial")
glmfullMale = glm(LiverPatient ~ Age + TB + DB +Alkphos + Alamine + Aspartate + TP + ALB, data = liverMale, family = "binomial")
stepwiseselectionmale = step(glmnullMale, scope = list(upper = glmfullMale),
                             direction="both",test="Chisq", trace = F) 
summary(stepwiseselectionmale)

# 2b)
hoslem.test(stepwiseselectionmale$y, fitted(stepwiseselectionmale), g=10)
residualdeviance = residuals(stepwiseselectionmale, type = "deviance")
residualpearson = residuals(stepwiseselectionmale, type = "pearson")
standardresidualdeviance = residuals(stepwiseselectionmale, type = "deviance")/sqrt(1 - hatvalues(stepwiseselectionmale))
standardresidualpearson = residuals(stepwiseselectionmale, type = "pearson")/sqrt(1 - hatvalues(stepwiseselectionmale))
par(mfrow=c(1,2))
plot(standardresidualdeviance[stepwiseselectionmale$model$LiverPatient==0], col = "red", 
     ylim = c(-3.5,3.5), ylab = "Standard Deviance Residuals", xlab = "ID")
points(standardresidualdeviance[stepwiseselectionmale$model$LiverPatient==1], col = "blue")
plot(standardresidualpearson[stepwiseselectionmale$model$LiverPatient==0], col = "red", 
     ylim = c(-3.5,3.5), ylab = "Standard Pearson Residuals", xlab = "ID")
points(standardresidualpearson[stepwiseselectionmale$model$LiverPatient==1], col = "blue")
plot(stepwiseselectionmale, which = 4, id.n = 5)
influenceddiagnostics2 = which(cooks.distance(stepwiseselectionmale)>0.25)
influenceddiagnostics2
glmrefitliver2 =  glm(LiverPatient ~ DB + Alamine + Age + Alkphos, data = liverMale[-influenceddiagnostics2, ], family = "binomial")

# 2c)
summary(glmrefitliver2)
round(exp(glmrefitliver2$coefficients),3)

# Exercise 3
# 3a)
sleepdata = read.csv("sleep-1.csv", header = TRUE)
str(sleepdata)
glmnullsleep = glm(maxlife10 ~ 1, data = sleepdata, family = "binomial")
glmfullsleep = glm(maxlife10 ~ bodyweight + brainweight + totalsleep + gestationtime + as.factor(predationindex) + as.factor(sleepexposureindex), 
                   data = sleepdata, family = "binomial")
stepwiseselectionsleep = step(glmnullsleep, scope = list(upper=glmfullsleep),
                              direction ="both",test ="Chisq", trace = F)
summary(stepwiseselectionsleep)

# 3b)
hoslem.test(stepwiseselectionsleep$y, fitted(stepwiseselectionsleep), g=10)
residudaldeviance2<-residuals(stepwiseselectionsleep, type = "deviance")
residualpearson2<-residuals(stepwiseselectionsleep, type = "pearson")
standardresidualdeviance2<-residuals(stepwiseselectionsleep, type = "deviance")/sqrt(1 - hatvalues(stepwiseselectionsleep)) 
standardresidualpearson2 <-residuals(stepwiseselectionsleep, type = "pearson")/sqrt(1 - hatvalues(stepwiseselectionsleep))
par(mfrow=c(1,2))
plot(standardresidualdeviance2[stepwiseselectionsleep$model$maxlife10==0], col = "red", ylim = c(-3.5,3.5), ylab = "Standard Deviance Residuals", xlab = "ID")
points(standardresidualdeviance2[stepwiseselectionsleep$model$maxlife10==1], col = "blue")
plot(standardresidualpearson2[stepwiseselectionsleep$model$maxlife10==0], col = "red", ylim = c(-3.5,3.5), ylab = "Standard Pearson Residuals", xlab = "ID")
points(standardresidualpearson2[stepwiseselectionsleep$model$maxlife10==1], col = "blue")
plot(stepwiseselectionsleep, which = 4, id.n = 5)
influenceddiagnostics3 = which(cooks.distance(stepwiseselectionsleep)>0.25)
influenceddiagnostics3
glmrefitsleep = glm(maxlife10 ~ brainweight + totalsleep + as.factor(predationindex) + as.factor(sleepexposureindex), 
                    data = sleepdata[-influenceddiagnostics3], family = "binomial")

# 3c)
summary(glmrefitsleep)
round(exp(glmrefitsleep$coefficients),3)

# Exercice 4
# 4a)
glmnullsleep2 = glm(maxlife10 ~ 1, data = sleepdata, family = "binomial")
glmfullsleep2 = glm(maxlife10 ~ bodyweight + brainweight + totalsleep + gestationtime + predationindex + sleepexposureindex, data = sleepdata, family = "binomial")
stepwiseselectionsleep2 = step(glmnullsleep2, scope = list(upper=glmfullsleep2),
                               direction ="both",test ="Chisq", trace = F)
summary(stepwiseselectionsleep2)

# 4b)
hoslem.test(stepwiseselectionsleep2$y, fitted(stepwiseselectionsleep2), g=10)
residudaldeviance3<-residuals(stepwiseselectionsleep2, type = "deviance")
residualpearson3<-residuals(stepwiseselectionsleep2, type = "pearson")
standardresidualdeviance3<-residuals(stepwiseselectionsleep2, type = "deviance")/sqrt(1 - hatvalues(stepwiseselectionsleep2)) 
standardresidualpearson3 <-residuals(stepwiseselectionsleep2, type = "pearson")/sqrt(1 - hatvalues(stepwiseselectionsleep2))
par(mfrow=c(1,2))
plot(standardresidualdeviance3[stepwiseselectionsleep2$model$maxlife10==0], col = "red", ylim = c(-3.5,3.5), ylab = "Standard Deviance Residuals", xlab = "ID")
points(standardresidualdeviance3[stepwiseselectionsleep2$model$maxlife10==1], col = "blue")
plot(standardresidualpearson3[stepwiseselectionsleep2$model$maxlife10==0], col = "red", ylim = c(-3.5,3.5), ylab = "Standard Pearson Residuals", xlab = "ID")
points(standardresidualpearson3[stepwiseselectionsleep2$model$maxlife10==1], col = "blue")
plot(stepwiseselectionsleep2, which = 4, id.n = 5)
influenceddiagnostics4 = which(cooks.distance(stepwiseselectionsleep2)>0.25)
influenceddiagnostics4
glmrefitsleep2 = glm(maxlife10 ~ brainweight + totalsleep + as.factor(predationindex) + as.factor(sleepexposureindex), 
                     data = sleepdata[-influenceddiagnostics4], family = "binomial")

# 4c)
summary(glmrefitsleep2)
round(exp(glmrefitsleep2$coefficients),3)




