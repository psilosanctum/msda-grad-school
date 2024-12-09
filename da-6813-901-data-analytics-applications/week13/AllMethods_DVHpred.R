rm(list = ls())

library(randomForest)
library(e1071)
library(gbm)
library(tree)
library(ggplot2) # plotting
library(reshape2)
library(tidyr)
library(rpart)
library(randomForestSRC) # RF


setwd("/Users/arkaroy1/Desktop/UTSA_Class_Slides/MSDA6813/Data")

df <- read.csv(file="SVR_SpineD2.csv", header=TRUE, sep=",")
str(df)
df$Concurrent.Chemotherapy = as.factor(df$Concurrent.Chemotherapy)
df$Surgery = as.factor(df$Surgery)

# For now simply computing for D2 for spine. Split 50 patients as training and 19 as testing.
  set.seed(123)
  train = sample(1:nrow(df), 50)
  train.data = df[train,]
  test.data = df[-train,]

  set.seed(123)
  # Grid search for opt mtry and ntree
  mtry.values <- seq(2,17,2)
  ntree.values <- seq(1e3,9e3,1e3)
  
  # Create a data frame containing all combinations 
  hyper_grid <- expand.grid(mtry = mtry.values, ntree = ntree.values)
  
  # Create an empty vector to store OOB error values
  oob_err <- c()
  
  # Write a loop over the rows of hyper_grid to train the grid of models
  for (i in 1:nrow(hyper_grid)) {
    
    # Train a Random Forest model
    set.seed(123)
    model <- rfsrc(D2 ~ ., data = train.data, importance = T, mtry = hyper_grid$mtry[i], 
                          ntree = hyper_grid$ntree[i])  
    
    # Store OOB error for the model                      
    oob_err[i] <- model$err.rate[length(model$err.rate)]
  }
  # Find location of opt index in grid search
  opt_i <- which.min(oob_err)
  
  # Run random forest with opt mtry and ntree, predict on test set, and evaluate MSE.
  set.seed(123)
  predRF = predict(rfsrc(D2 ~ ., data = test.data, mtry = hyper_grid$mtry[opt_i], 
                ntree = hyper_grid$ntree[opt_i],importance = T))$predicted
  errRF = mean((predRF - test.data$D2)^2)
  
  # Run linear reg, predict on test set, and evaluate MSE.
  set.seed(123)
  resultsLM = lm(D2 ~ ., data = train.data)
  predLM = predict(resultsLM, newdata = test.data)
  errLM = mean((predLM - test.data$D2)^2)
  
  # Tune SVM, and run SVM with tuned cost and gamma, predict on test set, and evaluate MSE.
  set.seed(123)
  tuned = tune.svm(D2 ~ ., data = train.data, gamma =seq(.01, 0.1, by = .01), cost = seq(0.1,1, by = 0.1), scale = TRUE)
  set.seed(123)
  resultsSVM <- svm(formula=D2 ~ ., data = train.data, gamma = tuned$best.parameters$gamma, cost = tuned$best.parameters$cost, scale = TRUE)
  predSVM <- predict(resultsSVM, test.data, type = "response")
  errSVM = mean((predSVM - test.data$D2)^2)
  
  # Run GBM, predict on test set, and evaluate error.   
  set.seed(123)
  resultsGBM <- gbm(D2 ~ ., data = train.data, distribution = "gaussian", 
                   n.trees = 9000, interaction.depth = 1, shrinkage = 0.001, verbose = F)
  predGBM <- predict(resultsGBM, newdata = test.data, n.trees = 9000, type = "response")
  errGBM = mean((predGBM - test.data$D2)^2)
  
  # Build a unpruned decision tree and predict on test set and compute error. 
  resultsTREE <- rpart(D2 ~ ., train.data)
  predTREE <- predict(resultsTREE, test.data)
  errTREE = mean((predTREE - test.data$D2)^2)
  
  # Build a pruned decision tree, predict on test set and compute error.
  set.seed(123)
  printcp(resultsTREE)
  plotcp(resultsTREE)
  resultsPruneTREE <- prune.rpart(resultsTREE, cp = 0.15)
  predPruneTREE <- predict(resultsPruneTREE, test.data)
  errPruneTREE = mean((predPruneTREE - test.data$D2)^2)
  
  theme_nice <- theme_classic()+
    theme(
      axis.line.y.left = element_line(colour = "black"),
      axis.line.y.right = element_line(colour = "black"),
      axis.line.x.bottom = element_line(colour = "black"),
      axis.line.x.top = element_line(colour = "black"),
      axis.text.y = element_text(colour = "black", face = "bold", size = 14),
      axis.text.x = element_text(color = "black", face = "bold", size = 14),
      axis.ticks = element_line(color = "black")) +
    theme(
      axis.ticks.length = unit(-0.25, "cm"), 
      axis.text.x = element_text(margin=unit(c(0.5,0.5,0.5,0.5), "cm")), 
      axis.text.y = element_text(margin=unit(c(0.5,0.5,0.5,0.5), "cm")))
  
  rattle::fancyRpartPlot(resultsPruneTREE, sub = "") # vizualize the DT
  
  positiveImp = model$importance[model$importance > 0]
  
  data.frame(importance = positiveImp) %>%
    tibble::rownames_to_column(var = "variable") %>%
    ggplot(aes(x = reorder(variable,importance), y = importance)) +
    geom_bar(stat = "identity", fill = "gray", color = "black")+
    coord_flip() +
    labs(x = "Variables", y = "Variable importance")
    theme_nice          
  
all_preds = cbind(c(1:19), test.data$D2, predRF, predSVM, predGBM, predPruneTREE, predTREE, predLM)
colnames(all_preds)[1] = "Patient"
colnames(all_preds)[2] = "D_2"

data_long <- gather(as.data.frame(all_preds), Method, D2, D_2:predLM, factor_key=TRUE)

ggplot(data_long, aes(x=Patient, y=D2, color=Method, size=Method, shape=Method)) +
  geom_point() +
  scale_color_manual(values=c("black", "blue", "green", "violet", "pink",
                              "brown", "red")) + 
  scale_shape_manual(values=c(3, 16, 16, 16, 16, 16, 16)) +
  scale_size_manual(values=c(2, 2, 1, 1, 1, 1, 2))
  
  