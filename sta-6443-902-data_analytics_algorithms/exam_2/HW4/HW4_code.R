library(DescTools); library(ResourceSelection)
setwd("C:/Users/sdy897/Box/Working files/Class/UTSA_STA6443_Algorithms1/HW/2020 FALL/HW4")

#####################
#Exercise 1
#####################
#a)
liver=read.csv("liver.csv", header=TRUE)
str(liver)


liverF = liver[which(liver$Gender == "Female"),]

glm.null.F <- glm(LiverPatient ~ 1, data = liverF, family = "binomial")
glm.full.F <- glm(LiverPatient ~ Age+TB+DB+Alkphos+Alamine+Aspartate+TP+ALB, data = liverF, family = "binomial")

# Perform stepwise selection based on AIC criteria

glm.liverF<-step(glm.null.F, scope = list(upper=glm.full.F),
                      direction="both",test="Chisq", trace = F) 

# cook's d
plot(glm.liverF, which = 4, id.n = 5)  

# b) and c)
# Final model 
summary(glm.liverF)
OR=exp(glm.liverF$coefficients)
round(OR,3)

# Hosmer-Lemeshow test
hoslem.test(glm.liverF$y, fitted(glm.liverF), g=10)

# residual plots
resid.d<-residuals(glm.liverF, type = "deviance")
resid.p<-residuals(glm.liverF, type = "pearson")
std.res.d<-residuals(glm.liverF, type = "deviance")/sqrt(1 - hatvalues(glm.liverF)) # standardized deviance residuals
std.res.p <-residuals(glm.liverF, type = "pearson")/sqrt(1 - hatvalues(glm.liverF)) # standardized pearson residuals

#dev.new(width = 1000, height = 1000, unit = "px")
par(mfrow=c(1,2))
plot(std.res.d[glm.liverF$model$LiverPatient==0], col = "red", 
     ylim = c(-3.5,3.5), ylab = "std. deviance residuals", xlab = "ID")
points(std.res.d[glm.liverF$model$LiverPatient==1], col = "blue")

plot(std.res.p[glm.liverF$model$LiverPatient==0], col = "red", 
     ylim = c(-3.5,3.5), ylab = "std. Pearson residuals", xlab = "ID")
points(std.res.p[glm.liverF$model$LiverPatient==1], col = "blue")

#####################
#Exercise 2
#####################
#a)
liverM = liver[which(liver$Gender == "Male"),]

glm.null.M <- glm(LiverPatient ~ 1, data = liverM, family = "binomial")
glm.full.M <- glm(LiverPatient ~ Age+TB+DB+Alkphos+Alamine+Aspartate+TP+ALB, data = liverM, family = "binomial")

# Perform stepwise selection based on AIC criteria
glm.liverM <- step(glm.null.M, scope = list(upper=glm.full.M),direction="both",test="Chisq", trace = F) 

# cook's d
plot(glm.liverM, which = 4, id.n = 5)  
(inf.id=which(cooks.distance(glm.liverM)>0.25))

# b) and c)
# Final model without influential points
glm.liverM2 = glm(LiverPatient ~ DB+Alamine+Age+Alkphos, data = liverM[-inf.id, ], family = "binomial")
summary(glm.liverM2)

OR=exp(glm.liverM2$coefficients)
round(OR,3)

# Hosmer-Lemeshow test
hoslem.test(glm.liverM$y, fitted(glm.liverM), g=10)

# residual plots
resid.d<-residuals(glm.liverM2, type = "deviance")
resid.p<-residuals(glm.liverM2, type = "pearson")
std.res.d<-residuals(glm.liverM2, type = "deviance")/sqrt(1 - hatvalues(glm.liverM2)) # standardized deviance residuals
std.res.p <-residuals(glm.liverM2, type = "pearson")/sqrt(1 - hatvalues(glm.liverM2)) # standardized pearson residuals


par(mfrow=c(1,2))
plot(std.res.d[glm.liverM$model$LiverPatient==0], col = "red", 
     ylim = c(-3.5,3.5), ylab = "std. deviance residuals", xlab = "ID")
points(std.res.d[glm.liverM$model$LiverPatient==1], col = "blue")

plot(std.res.p[glm.liverM$model$LiverPatient==0], col = "red", 
     ylim = c(-3.5,3.5), ylab = "std. Pearson residuals", xlab = "ID")
points(std.res.p[glm.liverM$model$LiverPatient==1], col = "blue")

# cook's d
plot(glm.liverM2, which=4, id.n=5)
(inf.id=which(cooks.distance(glm.liverM2)>0.25))


#####################
#Exercise 3
#####################

sleep=read.csv("sleep_new.csv", header=TRUE)

glm.null.sleep1 <- glm(maxlife10 ~ 1, data = sleep, family = "binomial")

glm.full.sleep1 <- glm(maxlife10 ~ bodyweight+brainweight+totalsleep+gestationtime
                       +as.factor(predationindex)+as.factor(sleepexposureindex), data = sleep, family = "binomial")

glm.sleep1 <- step(glm.null.sleep1, scope = list(upper=glm.full.sleep1),
                    direction="both",test="Chisq", trace = F)

summary(glm.sleep1)

# b) and c)
# Final model 
summary(glm.sleep1)
OR=exp(glm.sleep1$coefficients)
round(OR,3)

# Hosmer-Lemeshow test
hoslem.test(glm.sleep1$y, fitted(glm.sleep1), g=10)

# residual plots
resid.d<-residuals(glm.sleep1, type = "deviance")
resid.p<-residuals(glm.sleep1, type = "pearson")
std.res.d<-residuals(glm.sleep1, type = "deviance")/sqrt(1 - hatvalues(glm.sleep1)) # standardized deviance residuals
std.res.p <-residuals(glm.sleep1, type = "pearson")/sqrt(1 - hatvalues(glm.sleep1)) # standardized pearson residuals

#dev.new(width = 1000, height = 1000, unit = "px")
par(mfrow=c(1,2))
plot(std.res.d[glm.sleep1$model$maxlife10==0], col = "red", 
     ylim = c(-3.5,3.5), ylab = "std. deviance residuals", xlab = "ID")
points(std.res.d[glm.sleep1$model$maxlife10==1], col = "blue")

plot(std.res.p[glm.sleep1$model$maxlife10==0], col = "red", 
     ylim = c(-3.5,3.5), ylab = "std. Pearson residuals", xlab = "ID")
points(std.res.p[glm.sleep1$model$maxlife10==1], col = "blue")

# cook's d
par(mfrow=c(1,1))
plot(glm.sleep1, which = 4, id.n = 5)  

#####################
#Exercise 4
#####################

glm.null.sleep2 <- glm(maxlife10 ~ 1, data = sleep, family = "binomial")

glm.full.sleep2 <- glm(maxlife10 ~ bodyweight+brainweight+totalsleep+gestationtime
                       + predationindex + sleepexposureindex, data = sleep, family = "binomial")

glm.sleep2 <- step(glm.null.sleep2, scope = list(upper=glm.full.sleep2),
                    direction="both",test="Chisq", trace = F)

# b) and c)
# Final model 
summary(glm.sleep2)
OR=exp(glm.sleep2$coefficients)
round(OR,3)

# Hosmer-Lemeshow test
hoslem.test(glm.sleep2$y, fitted(glm.sleep2), g=10)

# residual plots
resid.d<-residuals(glm.sleep2, type = "deviance")
resid.p<-residuals(glm.sleep2, type = "pearson")
std.res.d<-residuals(glm.sleep2, type = "deviance")/sqrt(1 - hatvalues(glm.sleep2)) # standardized deviance residuals
std.res.p <-residuals(glm.sleep2, type = "pearson")/sqrt(1 - hatvalues(glm.sleep2)) # standardized pearson residuals

#dev.new(width = 1000, height = 1000, unit = "px")
par(mfrow=c(1,2))
plot(std.res.d[glm.sleep2$model$maxlife10==0], col = "red", 
     ylim = c(-3.5,3.5), ylab = "std. deviance residuals", xlab = "ID")
points(std.res.d[glm.sleep2$model$maxlife10==1], col = "blue")

plot(std.res.p[glm.sleep2$model$maxlife10==0], col = "red", 
     ylim = c(-3.5,3.5), ylab = "std. Pearson residuals", xlab = "ID")
points(std.res.p[glm.sleep2$model$maxlife10==1], col = "blue")

# cook's d
par(mfrow=c(1,1))
plot(glm.sleep2, which = 4, id.n = 5)  

