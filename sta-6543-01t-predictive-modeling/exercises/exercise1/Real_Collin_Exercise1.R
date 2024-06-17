# Import library and set working directory
library(tidyverse)
library(AppliedPredictiveModeling)
library(caret)
library(earth)

setwd("/Users/c2cypher/codebase/msda/msda-grad-school/sta-6543-01t-predictive-modeling/exercises/exercise1/")

# a) Read data into R
auto_df = read.table("/Users/c2cypher/codebase/msda/msda-grad-school/sta-6543-01t-predictive-modeling/exercises/exercise1/Auto-1.txt", header = T)

# b) Draw scatterplot
ggplot(data = auto_df, aes(x = horsepower, y = mpg)) +
  geom_point(color = 'blue') +
  labs(title = "Horsepower vs. MPG",
       x = "Horsepower", y = "MPG")

# c) Least squares regression
auto_model = lm(mpg ~ horsepower, data = auto_df)
summary(auto_model)

# d) Find the proportion of variation - R-squared can be found in above output

# e) Draw boxplot for residuals of linear regression
residuals_model = residuals(auto_model)
boxplot(residuals_model, main = "Boxplot - from MPG vs. HP Residuals",
        ylab = "Residuals", col = "blue")

# f) Fit a single linear model & conduct 10-fold CV
fit_linear_model = lm(mpg ~ horsepower, data = auto_df)
set.seed(1)
fitted_results <- train(mpg ~ horsepower, data = auto_df, method = "lm", trControl = trainControl(method = "cv", number = 10))
print(fitted_results)

ggplot(auto_df, aes(x = horsepower, y = mpg)) +
  geom_point() +
  geom_smooth(method = "lm", col = "blue") +
  labs(title = "Scatterplot - Fitted", x = "Horsepower", y = "MPG")

fitted_values = predict(fit_linear_model, auto_df)
ggplot(auto_df, aes(x = fitted_values, y = mpg)) +
  geom_point() +
  geom_abline(slope = 1, intercept = 0, col = "red") +
  labs(title = "Scatterplot - Observed vs. Fitted values", x = "Fitted", y = "Observed")

# g) Fit a quadratic model & conduct 1-fold CV
auto_df$horsepower2 = auto_df$horsepower^2
auto_df = auto_df[order(auto_df[,3], decreasing = FALSE),]
set.seed(1)
quad_fit = train(mpg ~ horsepower + horsepower2, 
                data = auto_df,
                method = "lm", 
                trControl = trainControl(method= "cv"))
summary(quad_fit)
plot(auto_df$horsepower, auto_df$mpg,xlab = "Horsepower", ylab = "Fuel Efficiency (MPG)")
lines(auto_df$horsepower, fitted(lm2Fit), col=2, lwd=2)

fitted_quad = predict(quad_fit, auto_df)
ggplot(auto_df, aes(x = fitted_quad, y = mpg)) +
  geom_point() +
  geom_abline(slope = 1, intercept = 0, col = "red") +
  labs(title = "Scatterplot between Observed and Fitted values", x = "Fitted Values", y = "Observed Values")

# h) Fit a mars model
set.seed(1)
mars_model <- train(mpg ~ horsepower, 
                 data = auto_df,
                 method = "earth",
                 tuneLength = 15,
                 trControl = trainControl(method= "cv"))
summary(mars_model)
plot(mars_model)

par(mfrow=c(1,2))
plot(auto_df$horsepower, auto_df$mpg,xlab = "Horsepower", ylab = "Fuel Efficiency (MPG)")
lines(auto_df$horsepower,fitted(mars_model), col=2, lwd=2)

observed_values = auto_df$mpg
predicted_values = fitted(mars_model)
plot(observed_values, predicted_values, ylim=c(12, 70))

