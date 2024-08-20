---
  title: "Poster Project"
author: "Leonel Salazar"
format: docx
---
  
  ```{r}

library(fmsb)
library(gbm)
library(here)
library(ggplot2)
library(gridExtra)
library(MASS)
library(corrplot)
library(caret)
library(e1071)
library(pROC)
library(nnet)
library(pROC)
library(randomForest)
library(class)

```


```{r}


# Use 'here' to create the path to the dataset
diabetes <- here::here("diabetes.csv")

# Load the dataset and assign it to the variable 'diabetes'
diabetes <- read.csv(diabetes)

# View the first few rows of the dataset
head(diabetes)

```


```{r}

# Convert the outcome variable to a factor
diabetes$Outcome <- as.factor(diabetes$Outcome)

numeric_columns <- names(diabetes)[names(diabetes) != "Outcome"]
diabetes[numeric_columns] <- lapply(diabetes[numeric_columns], as.numeric)

str(diabetes)

```



```{r}

# Original data histograms
for (col in numeric_columns) {
  print(ggplot(diabetes, aes_string(x = col)) +
          geom_histogram(bins = 30, fill = "blue", color = "black", alpha = 0.7) +
          ggtitle(paste("Histogram of", col, "(Original)")) +
          xlab(col) +
          ylab("Frequency"))
}

# Original data Q-Q plots
for (col in numeric_columns) {
  print(ggplot(diabetes, aes_string(sample = col)) +
          stat_qq() +
          stat_qq_line() +
          ggtitle(paste("Q-Q Plot of", col, "(Original)")) +
          xlab("Theoretical Quantiles") +
          ylab("Sample Quantiles"))
}

```



```{r}
# Load the dataset
diabetes_file_path <- here::here("diabetes.csv")
diabetes <- read.csv(diabetes_file_path)

# Convert the Outcome variable to a factor
diabetes$Outcome <- as.factor(diabetes$Outcome)

# Set seed for reproducibility
set.seed(123)

# Create training (20%) and testing (80%) indices
train_index <- createDataPartition(diabetes$Outcome, p = 0.2, list = FALSE)

# Split the data
train_data <- diabetes[train_index, ]
test_data <- diabetes[-train_index, ]

# Verify the split
cat("Training set size:", nrow(train_data), "\n")
cat("Testing set size:", nrow(test_data), "\n")

# Normalize the predictor variables for neural network
preproc <- preProcess(train_data[, -which(names(train_data) == "Outcome")], method = c("center", "scale"))
train_data_norm <- predict(preproc, train_data[, -which(names(train_data) == "Outcome")])
test_data_norm <- predict(preproc, test_data[, -which(names(test_data) == "Outcome")])

# Add the Outcome variable back to the normalized data
train_data_norm$Outcome <- train_data$Outcome
test_data_norm$Outcome <- test_data$Outcome


```



```{r}
# Fit logistic regression model
lr_model <- glm(Outcome ~ ., data = train_data, family = binomial)
lr_prob_predictions <- predict(lr_model, newdata = test_data, type = "response")

# Evaluate logistic regression model
lr_predictions <- ifelse(lr_prob_predictions > 0.5, 1, 0)
lr_confusion <- confusionMatrix(as.factor(lr_predictions), test_data$Outcome)
lr_accuracy <- lr_confusion$overall["Accuracy"]
lr_precision <- lr_confusion$byClass["Pos Pred Value"]
lr_recall <- lr_confusion$byClass["Sensitivity"]
lr_f1 <- 2 * (lr_precision * lr_recall) / (lr_precision + lr_recall)

# Logistic Regression ROC Curve
lr_roc_curve <- roc(test_data$Outcome, lr_prob_predictions)

```

```{r}

# Fit SVM model
svm_model <- svm(Outcome ~ ., data = train_data, kernel = "radial", probability = TRUE)
svm_predictions <- predict(svm_model, newdata = test_data, probability = TRUE)
svm_prob_predictions <- attr(svm_predictions, "probabilities")[, 2]

# Evaluate SVM model
svm_confusion <- confusionMatrix(as.factor(ifelse(svm_prob_predictions > 0.5, 1, 0)), test_data$Outcome)
svm_accuracy <- svm_confusion$overall["Accuracy"]
svm_precision <- svm_confusion$byClass["Pos Pred Value"]
svm_recall <- svm_confusion$byClass["Sensitivity"]
svm_f1 <- 2 * (svm_precision * svm_recall) / (svm_precision + svm_recall)

# SVM ROC Curve
svm_roc_curve <- roc(test_data$Outcome, svm_prob_predictions)

```
```{r}

# Fit k-NN model (k = 5)
knn_model <- knn(train = train_data[, -which(names(train_data) == "Outcome")], 
                 test = test_data[, -which(names(test_data) == "Outcome")], 
                 cl = train_data$Outcome, k = 5, prob = TRUE)
knn_prob_predictions <- attr(knn_model, "prob")

# Evaluate k-NN model
knn_confusion <- confusionMatrix(knn_model, test_data$Outcome)
knn_accuracy <- knn_confusion$overall["Accuracy"]
knn_precision <- knn_confusion$byClass["Pos Pred Value"]
knn_recall <- knn_confusion$byClass["Sensitivity"]
knn_f1 <- 2 * (knn_precision * knn_recall) / (knn_precision + knn_recall)

# k-NN ROC Curve
knn_roc_curve <- roc(test_data$Outcome, knn_prob_predictions)


```
```{r}

# Fit neural network model
nn_model <- nnet(Outcome ~ ., data = train_data_norm, size = 5, maxit = 200, decay = 0.01, linout = FALSE)
nn_prob_predictions <- predict(nn_model, newdata = test_data_norm, type = "raw")

# Ensure predictions are factors with the same levels as the actual outcomes
nn_predictions <- ifelse(nn_prob_predictions > 0.5, 1, 0)
nn_predictions <- as.factor(nn_predictions)
levels(nn_predictions) <- levels(test_data_norm$Outcome)

# Evaluate neural network model
nn_confusion <- confusionMatrix(nn_predictions, test_data_norm$Outcome)
nn_accuracy <- nn_confusion$overall["Accuracy"]
nn_precision <- nn_confusion$byClass["Pos Pred Value"]
nn_recall <- nn_confusion$byClass["Sensitivity"]
nn_f1 <- 2 * (nn_precision * nn_recall) / (nn_precision + nn_recall)

# Neural Network ROC Curve
nn_roc_curve <- roc(test_data_norm$Outcome, as.numeric(nn_prob_predictions))

```


```{r}

# Fit random forest model
rf_model <- randomForest(Outcome ~ ., data = train_data, ntree = 100, mtry = 3, importance = TRUE)
rf_prob_predictions <- predict(rf_model, newdata = test_data, type = "prob")[, 2]

# Evaluate random forest model
rf_confusion <- confusionMatrix(predict(rf_model, newdata = test_data), test_data$Outcome)
rf_accuracy <- rf_confusion$overall["Accuracy"]
rf_precision <- rf_confusion$byClass["Pos Pred Value"]
rf_recall <- rf_confusion$byClass["Sensitivity"]
rf_f1 <- 2 * (rf_precision * rf_recall) / (rf_precision + rf_recall)

# Random Forest ROC Curve
rf_roc_curve <- roc(test_data$Outcome, rf_prob_predictions)


```
```{r}

# Create a data frame to compare models
model_comparison1 <- data.frame(
  Model = c("Logistic Regression", "SVM", "k-NN", "Neural Network", "Random Forest"),
  Accuracy = c(lr_accuracy, svm_accuracy, knn_accuracy, nn_accuracy, rf_accuracy),
  Precision = c(lr_precision, svm_precision, knn_precision, nn_precision, rf_precision),
  Recall = c(lr_recall, svm_recall, knn_recall, nn_recall, rf_recall),
  F1_Score = c(lr_f1, svm_f1, knn_f1, nn_f1, rf_f1)
)

# Print the comparison table
print(model_comparison1)

# Plot ROC Curves
plot(lr_roc_curve, col = "black", main = "ROC Curves for Different Models")
plot(svm_roc_curve, add = TRUE, col = "red")
plot(knn_roc_curve, add = TRUE, col = "blue")
plot(nn_roc_curve, add = TRUE, col = "green")
plot(rf_roc_curve, add = TRUE, col = "purple")
legend("bottomright", legend = c("Logistic Regression", "SVM", "k-NN", "Neural Network", "Random Forest"),
       col = c("black", "red", "blue", "green", "purple"), lwd = 2)

# Print AUC values
cat("AUC for Logistic Regression:", auc(lr_roc_curve), "\n")
cat("AUC for SVM:", auc(svm_roc_curve), "\n")
cat("AUC for k-NN:", auc(knn_roc_curve), "\n")
cat("AUC for Neural Network:", auc(nn_roc_curve), "\n")
cat("AUC for Random Forest:", auc(rf_roc_curve), "\n")


```





### Removed all Zeroes


```{r}



library(here)
library(caret)
library(e1071)
library(class)
library(nnet)
library(randomForest)
library(pROC)
library(ggplot2)
library(gridExtra)

# Load the dataset
diabetes_file_path <- here::here("diabetes.csv")
diabetes <- read.csv(diabetes_file_path)

# Convert the Outcome variable to a factor
diabetes$Outcome <- as.factor(diabetes$Outcome)

# Identify the columns to exclude from zero-checking
exclude_columns <- c("Outcome")

# Check how many rows have a 0 in any column except the Outcome column
rows_with_zero <- apply(diabetes[, !names(diabetes) %in% exclude_columns], 1, function(row) any(row == 0))

# Remove rows with a 0 in any column except the Outcome column
diabetes_cleaned <- diabetes[!rows_with_zero, ]

# Display the number of remaining observations
cat("Number of observations after removing rows with 0 in any column (excluding Outcome):", nrow(diabetes_cleaned), "\n")

# Set seed for reproducibility
set.seed(123)

# Create training (80%) and testing (20%) indices
train_index <- createDataPartition(diabetes_cleaned$Outcome, p = 0.8, list = FALSE)

# Split the data
train_data <- diabetes_cleaned[train_index, ]
test_data <- diabetes_cleaned[-train_index, ]

# Verify the split
cat("Training set size:", nrow(train_data), "\n")
cat("Testing set size:", nrow(test_data), "\n")

# Normalize the predictor variables for neural network and k-NN
preproc <- preProcess(train_data[, -which(names(train_data) == "Outcome")], method = c("center", "scale"))
train_data_norm <- predict(preproc, train_data[, -which(names(train_data) == "Outcome")])
test_data_norm <- predict(preproc, test_data[, -which(names(test_data) == "Outcome")])
diabetes_norm <- predict(preproc, diabetes_cleaned[, -which(names(diabetes_cleaned) == "Outcome")])

# Add the Outcome variable back to the normalized data
train_data_norm$Outcome <- train_data$Outcome
test_data_norm$Outcome <- test_data$Outcome
diabetes_norm$Outcome <- diabetes_cleaned$Outcome

# Fit logistic regression model
lr_model <- glm(Outcome ~ ., data = train_data, family = binomial)
lr_prob_predictions <- predict(lr_model, newdata = test_data, type = "response")
lr_predictions <- as.factor(ifelse(lr_prob_predictions > 0.5, 1, 0))

# Fit SVM model
svm_model <- svm(Outcome ~ ., data = train_data, kernel = "radial", probability = TRUE)
svm_prob_predictions <- predict(svm_model, newdata = test_data, probability = TRUE)
svm_prob_predictions <- attr(svm_prob_predictions, "probabilities")[, 2]
svm_predictions <- as.factor(ifelse(svm_prob_predictions > 0.5, 1, 0))

# Fit k-NN model (k = 5)
knn_model <- knn(train = train_data_norm[, -which(names(train_data_norm) == "Outcome")], 
                 test = test_data_norm[, -which(names(test_data_norm) == "Outcome")], 
                 cl = train_data_norm$Outcome, k = 5)
knn_predictions <- knn_model

# Fit neural network model
nn_model <- nnet(Outcome ~ ., data = train_data_norm, size = 5, maxit = 200, decay = 0.01, linout = FALSE)
nn_prob_predictions <- predict(nn_model, newdata = test_data_norm, type = "raw")
nn_predictions <- as.factor(ifelse(nn_prob_predictions > 0.5, 1, 0))

# Fit random forest model
rf_model <- randomForest(Outcome ~ ., data = train_data, ntree = 100, mtry = 3, importance = TRUE)
rf_prob_predictions <- predict(rf_model, newdata = test_data, type = "prob")[, 2]
rf_predictions <- as.factor(ifelse(rf_prob_predictions > 0.5, 1, 0))

# Evaluate Models
evaluate_model <- function(predictions, prob_predictions, true_labels) {
  confusion <- confusionMatrix(predictions, true_labels)
  accuracy <- confusion$overall["Accuracy"]
  precision <- confusion$byClass["Pos Pred Value"]
  recall <- confusion$byClass["Sensitivity"]
  f1 <- 2 * (precision * recall) / (precision + recall)
  auc_val <- auc(roc(true_labels, prob_predictions))
  list(confusion = confusion, accuracy = accuracy, precision = precision, recall = recall, f1 = f1, auc = auc_val)
}

lr_eval <- evaluate_model(lr_predictions, lr_prob_predictions, test_data$Outcome)
svm_eval <- evaluate_model(svm_predictions, svm_prob_predictions, test_data$Outcome)
knn_eval <- evaluate_model(knn_predictions, as.numeric(knn_predictions), test_data$Outcome)
nn_eval <- evaluate_model(nn_predictions, as.numeric(nn_prob_predictions), test_data$Outcome)
rf_eval <- evaluate_model(rf_predictions, rf_prob_predictions, test_data$Outcome)

# Create a data frame to compare models
model_comparison <- data.frame(
  Model = c("Logistic Regression", "SVM", "k-NN", "Neural Network", "Random Forest"),
  Accuracy = c(lr_eval$accuracy, svm_eval$accuracy, knn_eval$accuracy, nn_eval$accuracy, rf_eval$accuracy),
  Precision = c(lr_eval$precision, svm_eval$precision, knn_eval$precision, nn_eval$precision, rf_eval$precision),
  Recall = c(lr_eval$recall, svm_eval$recall, knn_eval$recall, nn_eval$recall, rf_eval$recall),
  F1_Score = c(lr_eval$f1, svm_eval$f1, knn_eval$f1, nn_eval$f1, rf_eval$f1),
  AUC = c(lr_eval$auc, svm_eval$auc, knn_eval$auc, nn_eval$auc, rf_eval$auc)
)

# Print the comparison table
print(model_comparison)

# Extract ROC data
extract_roc_data <- function(roc_object) {
  data.frame(
    specificity = roc_object$specificities,
    sensitivity = roc_object$sensitivities,
    model = deparse(substitute(roc_object))
  )
}

lr_roc_data <- extract_roc_data(roc(test_data$Outcome, lr_prob_predictions))
svm_roc_data <- extract_roc_data(roc(test_data$Outcome, svm_prob_predictions))
knn_roc_data <- extract_roc_data(roc(test_data$Outcome, as.numeric(knn_predictions)))
nn_roc_data <- extract_roc_data(roc(test_data$Outcome, as.numeric(nn_prob_predictions)))
rf_roc_data <- extract_roc_data(roc(test_data$Outcome, rf_prob_predictions))

# Combine ROC data
roc_data <- rbind(
  transform(lr_roc_data, model = "Logistic Regression"),
  transform(svm_roc_data, model = "SVM"),
  transform(knn_roc_data, model = "k-NN"),
  transform(nn_roc_data, model = "Neural Network"),
  transform(rf_roc_data, model = "Random Forest")
)

# Plot ROC Curves
roc_plot <- ggplot(roc_data, aes(x = 1 - specificity, y = sensitivity, color = model)) +
  geom_line(size = 1) +
  labs(x = "False Positive Rate", y = "True Positive Rate", title = "ROC Curves") +
  theme_minimal()

# Display the ROC plot
print(roc_plot)

```

```{r}


# Generate predictions for the entire dataset
lr_prob_predictions <- predict(lr_model, newdata = diabetes_cleaned, type = "response")
lr_predictions <- as.factor(ifelse(lr_prob_predictions > 0.5, 1, 0))

svm_prob_predictions <- predict(svm_model, newdata = diabetes_cleaned, probability = TRUE)
svm_prob_predictions <- attr(svm_prob_predictions, "probabilities")[, 2]
svm_predictions <- as.factor(ifelse(svm_prob_predictions > 0.5, 1, 0))

knn_predictions <- knn(train = train_data_norm[, -which(names(train_data_norm) == "Outcome")], 
                       test = diabetes_norm[, -which(names(diabetes_norm) == "Outcome")], 
                       cl = train_data_norm$Outcome, k = 5)

nn_prob_predictions <- predict(nn_model, newdata = diabetes_norm, type = "raw")
nn_predictions <- as.factor(ifelse(nn_prob_predictions > 0.5, 1, 0))

rf_prob_predictions <- predict(rf_model, newdata = diabetes_cleaned, type = "prob")[, 2]
rf_predictions <- as.factor(ifelse(rf_prob_predictions > 0.5, 1, 0))

# Create a new dataset with original outcomes and predictions
diabetes_pred <- diabetes_cleaned
diabetes_pred$LR_Prediction <- lr_predictions
diabetes_pred$SVM_Prediction <- svm_predictions
diabetes_pred$KNN_Prediction <- knn_predictions
diabetes_pred$NN_Prediction <- nn_predictions
diabetes_pred$RF_Prediction <- rf_predictions

# Display the first few rows of the new dataset
head(diabetes_pred)

```


```{r}

library(ggplot2)

# Create a copy of the model_comparison dataframe
model_comparison_ordered <- model_comparison

# Add a column for the overall ranking based on AUC
model_comparison_ordered$Rank <- rank(-model_comparison_ordered$AUC)

# Sort the dataframe by the ranking
model_comparison_ordered <- model_comparison_ordered[order(model_comparison_ordered$Rank), ]

# Plot the rankings
ggplot(model_comparison_ordered, aes(x = reorder(Model, -AUC), y = AUC, fill = Model)) +
  geom_bar(stat = "identity") +
  labs(title = "Model Comparison: AUC Ranking", x = "Model", y = "AUC") +
  theme_minimal() +
  theme(legend.position = "none")

```


```{r}

library(gridExtra)

# Create individual plots
plot1 <- ggplot(model_comparison, aes(x = Model, y = Accuracy, fill = Model)) +
  geom_bar(stat = "identity") +
  labs(title = "Model Comparison: Accuracy", x = "Model", y = "Accuracy") +
  theme_minimal() +
  theme(legend.position = "none")

plot2 <- ggplot(model_comparison, aes(x = Model, y = Precision, fill = Model)) +
  geom_bar(stat = "identity") +
  labs(title = "Model Comparison: Precision", x = "Model", y = "Precision") +
  theme_minimal() +
  theme(legend.position = "none")

plot3 <- ggplot(model_comparison, aes(x = Model, y = Recall, fill = Model)) +
  geom_bar(stat = "identity") +
  labs(title = "Model Comparison: Recall", x = "Model", y = "Recall") +
  theme_minimal() +
  theme(legend.position = "none")

plot4 <- ggplot(model_comparison, aes(x = Model, y = F1_Score, fill = Model)) +
  geom_bar(stat = "identity") +
  labs(title = "Model Comparison: F1 Score", x = "Model", y = "F1 Score") +
  theme_minimal() +
  theme(legend.position = "none")

plot5 <- ggplot(model_comparison, aes(x = Model, y = AUC, group = 1)) +
  geom_line(aes(color = Model), size = 1) +
  geom_point(aes(color = Model), size = 3) +
  labs(title = "Model Comparison: AUC", x = "Model", y = "AUC") +
  theme_minimal() +
  theme(legend.position = "none")

# Arrange the plots in a grid
grid.arrange(plot1, plot2, plot3, plot4, plot5, ncol = 2)

```
```{r}

print(plot1)

print(plot2)

print(plot3)

print(plot4)

print(plot5)
```



```{r}

# Fit random forest model
rf_model <- randomForest(Outcome ~ ., data = train_data, ntree = 100, mtry = 3, importance = TRUE)

# Get feature importance
importance <- importance(rf_model)
importance_df <- data.frame(Feature = row.names(importance), Importance = importance[, "MeanDecreaseGini"])

# Sort by importance
importance_df <- importance_df[order(importance_df$Importance, decreasing = TRUE), ]

# Print feature importance
print(importance_df)

```


```{r}

ggplot(importance_df, aes(x = reorder(Feature, Importance), y = Importance, fill = Importance)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Feature Importance from Random Forest Model", x = "Features", y = "Importance") +
  theme_minimal() +
  scale_fill_gradient(low = "violet", high = "orange")


```

