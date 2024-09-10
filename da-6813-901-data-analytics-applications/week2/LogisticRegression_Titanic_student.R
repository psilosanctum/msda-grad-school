#### This program uses Titanic data for logit model


# install.packages("titanic")
# install.packages("caret")
# install.packages("gam")

# Ignore this next line
# detach("package:titanic", unload = T)

### Load the packages in R

library(titanic)
library(caret)
library(lattice)
library(ggplot2)
library(gam)


# The library "titanic" contains many data sets. We will use titanic_train
# for our analysis. At this point we don't know how the data look like.
# One way to get some idea about data is to get classes of different variable




# Now we know the variables in titanic_train and their type (character, numeric, integer, etc.)

# We will use Survived as the dependent variable and Pclass, Sex, Age, SibSp, Parch, Fare,
# and Embarked as predictor variables for the logistic regression model. You can also use Cabin
# but it's not that straightforward so we will leave it for your practice!

# If you read the output of "str" command above, you will realize that Sex and Embarked are
# character variables and so they can't be used in the model as they are. Further,
# Pclass is an ordinal variable, meaning it tells us that 1st class is better than 2nd which is
# better than 3rd. But it doesn't tell us by how much. Compare that to Fare. It tells us
# which fare is higher and also by how much.
# We will create dummy variables for Sex, Embarked, and Pclass. The dummy variables are
# indicator variables which take on exactly 2 values - 1 and 0 where 1 is presence and 0 is absence

# To create dummy variables, we need to know the number of distinct values for each variable.
# These distinct values are called levels. For example, Sex can take 2 values in our data:male and female
# Thus, Sex has 2 levels in our data.
# The general formula for number of dummy variables that you create for a character of ordinal
# variable is given as
# Number of dummy variables = Number of levels - 1

# Thus, for Sex, which has 2 levels, the number of dummy variables will be 2-1 = 1

# Try to figure out the levels of Sex, Embarked, and Pclass





# Sex has 2 levels: female and male
# Embarked has 4 levels: "", C, Q, and S
# and Pclass has 3 levels: 1,2,3

# Notice that Embarked as a missing value. Do we need to consider this as a level?
# It depends on your application. In our case we really don't. So we should delete these
# observations. Thus, Sex will have 2-1 = 1 dummy, Embarked will have 3-1 = 2 dummy, and
# Pclass will have 3-1 = 2 dummy variables

# So let's keep only the observations with non missing values. But I am going to do it for 
# all the variables we will use in the model rather than only for Embarked. I was to make
# sure that we have only the observations for which data on all the variables is available.
# Once we do this, we will create the dummy variables for Sex, Embarked, and Pclass

# Deleting observations with one or more missing values will alter the data set.
# I like to keep the original data set unaltered. Therefore, I will clone the dataset
# into a new one called ttrain





# Now ttrain has exactly the same information as titanic_train

# Run the next commands line by line and pay attention to the ttrain data description in the 
# window on right -----------> 
# Do you see the number of observations changing?





# Notice that the number of observation has dropped a lot!





# Sex and Embarked are character variables. So we can't use the function "is.na" for them
# instead I will use "is.nan" which is like asking R: Is the value of the variable "NaN"? 
# In R, for character variables missing values are stored as NaN and for non-character 
# variables they are stored as NA. 





# Next line is needed for catching the missing values





# At this point the total observations in ttrain should be 712

# Create dummy variables for Sex, Pclass, and Embarked
# sdummy is the dummy variable for Sex. It takes a value of 1 when the passenger is a male
# and 0 when the passenger is a female. The command is similar to the one in Excel.





# pdummy1 and pdumm2 are 2 dummy variables for Pclass
# When Pclass is 2, pdummy1 is 1 otherwise it is 0.
# When Pclass is 3, pdummy2 is 1 otherwise it is 0.

# Thus, we can get the following nice coding for the 3 levels
# Pclass    pdummy1    pdummy2
#   1         0          0
#   2         1          0
#   3         0          1






# Do the same for Embarked






# Print out the first 10 observations in the data to take a look





# Estimate the logit model - first cut
# Here, Survived is your dependent variable, and then we list all the predictor variables
# separated by "+" sign. Note that now we are using the dummy variables.
# For "binary" logistic regression, we use "binomial" distribution.






# To take a look at the output, execute the next line. we will discuss the results in the class.





# Finally, just to get some idea about the performance of the model, fit our model on the
# exact same data from which you estimated it, i.e., ttrain
# Ideally, you will test it on some other dataset. For example, use titanic_test
# for testing the model

# In the following statement, we create a new variable "PredProb" which will have 
# predicted probability stored in the ttrain data set.





# Note that PredProb is predicted probability of Survived, which is 1 or 0. So how do
# you compare probabilities with this? The easiest way is to convert probabilities into 1s and 0s
# I create a new variable PredSur which will be 1 if PredProb is >= 0.5 and 0 otherwise





# Finally, we will use the command "confusionMatrix" from the package caret to get accuracy of the
# model prediction. More on this in the next class










