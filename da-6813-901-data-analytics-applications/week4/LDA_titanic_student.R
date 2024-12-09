# This code is to make a LDA model on the titanic dataset. 
# Additionally, we compare the results to the logistic regression output. 
# In this testing data, the accuracy is better for LDA than Logit model. 

# install.packages('MASS')
# install.packages('ggplot2')
# install.packages('titanic')

# Load necessary libraries
library(MASS)
library(ggplot2)
library(titanic)

# See the dimensions of the dataset


# See the composition of the data


# Descriptive Stats




# Remove missing values and empty cells. 



# Creating training and testing samples
set.seed(1)
row.number = sample(1:nrow(ttrain), 0.8*nrow(ttrain))
titatrain = ttrain[row.number,]
titatest = ttrain[-row.number,]

# LDA modeling. 


# View the output


# Predicting for the testing dataset we created



# Make confusion matrix for the LDA predictions to compare accuracy 



# Create logistic model and see output



# Predict on the testing dataset


# Convert predicted probabilities into classes



# Make confusion matrix for Logit model to compare accuracy


