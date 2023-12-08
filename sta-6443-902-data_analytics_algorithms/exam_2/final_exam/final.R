library(tidyverse)
library(olsrr)
library(car)
library(ResourceSelection)
library(DescTools)

setwd("/Users/c2cypher/codebase/msda/msda-grad-school/sta-6443-902-data_analytics_algorithms/exam_2/final_exam")

df = read.csv('birthweight_final.csv')
df$Black = as.factor(df$Black)
df$Married = as.factor(df$Married)
df$Boy = as.factor(df$Boy)
df$MomSmoke = as.factor(df$MomSmoke)
df$Ed = as.factor(df$Ed)
str(df)

# Exercise 1)
q1.lm = lm(Weight ~ Black + Married + Boy + MomSmoke + Ed + MomAge + MomWtGain + 
             Visit, data = df)
summary(q1.lm)

model.stepwise = ols_step_both_p(q1.lm, pent = 0.01, prem = 0.01, details = FALSE)
model.stepwise
model.lm.stepwise = lm(Weight ~ MomWtGain + MomSmoke + Black, data = df)
summary(model.lm.stepwise)

model.forward = ols_step_forward_p(q1.lm, pent = 0.01, details = FALSE)
model.forward
model.lm.forward = lm(Weight ~ MomWtGain + MomSmoke + Black, data = df)
summary(model.lm.forward)

model.backward = ols_step_backward_p(q1.lm, prem = 0.01, details = FALSE)
model.backward
model.lm.backward = lm(Weight ~ MomWtGain + MomSmoke + Black, data = df)
summary(model.lm.backward)

adj_r_sq = ols_step_best_subset(q1.lm)
adj_r_sq
model.lm.adj_r_sq = lm(Weight ~ Black + Married + Boy + MomSmoke + Ed + MomWtGain, 
                       data = df)
summary(model.lm.adj_r_sq)

q2.lm.stepwise = lm(Weight ~ MomWtGain + MomSmoke + Black, data = df)
summary(q2.lm.stepwise)

par(mfrow=c(2,2))
plot(q2.lm.stepwise, which = 1:4)

q2.cooks = which(cooks.distance(q2.lm.stepwise) > 0.115)
df[q2.cooks, ]

dim(df[-q2.cooks, ])

q2.refitted.step = lm(Weight ~ MomWtGain + MomSmoke + Black, data = df[-q2.cooks, ])
summary(q2.refitted.step)

# Exercise 2)
model.null = glm(Weight_Gr ~ 1, 
                 data = df, 
                 family = "binomial")
model.full = glm(Weight_Gr ~ Black + Married + Boy + MomSmoke + Ed + MomAge + MomWtGain 
                 + Visit,
                 data = df,
                 family = "binomial")

step.models.AIC = step(model.null, 
                       scope = list(upper = model.full),
                       direction = "both",
                       test = "Chisq",
                       trace = F)
summary(step.models.AIC)

step.models.BIC = step(model.null,
                       scope = list(upper = model.full),
                       direction = "both",
                       test = "Chisq",
                       trace = F,
                       k = log(nrow(df)))
summary(step.models.BIC)

glm.model.bic = glm(Weight_Gr ~ MomWtGain + MomSmoke + MomAge,
                    data = df,
                    family = "binomial")
summary(glm.model.bic)

inf.id = which(cooks.distance(glm.model.bic) > 0.1)
inf.id
dim(df[inf.id])

odds_ratio = exp(glm.model.bic$coefficients)
round(odds_ratio, 3)

sample.prop = mean(df$Weight_Gr)
sample.prop

fit.prob = predict(glm.model.bic, type = "response")
pred.class = ifelse(fit.prob > sample.prop, 1, 0)
mean(df$Weight_Gr != pred.class)

hoslem.test(glm.model.bic$y, fitted(glm.model.bic), g = 10)

