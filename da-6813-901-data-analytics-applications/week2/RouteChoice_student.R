#### Here we perform logistic regression. Overcome the perfect separation problem. See an 
#### alternative model through Firth's bias reduced logit model. 

# Install packages
 install.packages("logistf")

# Load the data and packages
 library(logistf)
 
RouteData = read.csv("/Users/arkaroy1/Desktop/UTSA_Class_Slides/MSDA6813/Data/Segmentation_TravelRouteClassify.csv", header=FALSE)

# To see the classes of our data

 
# All are "int" data, so we can simply look for "NA" for missing values. 
# We will use na.omit, which removes all rows with NA values

 
# Remove columns 1, 3, and 4 from analysis, since we're only interested in the arterial lane. 
# Here we concatanate column 2 (arterial, response) along with columns 5-17. 

 
# To rename the columns we can use the "names" function. Note the format is slightly different
# where the function is on the left hand side of the equals sign. 
names(RouteData) = c("ArterialRoute", "TrafficFlow", "TrafficSignalNumber", "Distance",
                      "SeatBelts", "Passengers", "DriverAge", "Gender", "Marital", "Children",
                      "Income", "CarModel", "CarOrigin", "FuelMPG")
 
 
# Let us take a look at a sample (first 10 observations) of the data


# We can see that income and age are categorical variables.
# We will need to account for age and income through dummy variables. 
# This can be done using ifelse. Alternative, here let's use the function "factor"
# to make new variables IncomeF and DriverAgeF that is automatically reconized by R as having levels.



 
# We should also convert distance to miles. Currently, the units are tenth of a mile. 

 
   
# Now we're ready to build the logistic model


 
 
# You should get an error, which reflects a lack of convergence of the GLM function, 
# and one of the predictors being very significant in predicting the response. 
# First, let's solve the first problem. We can increase the maximum number of iterations to 
# allow for convergence. Do this by add "control = list(maxit = 50)" to the glm input:



 
# You'll notice that removes the convergence warning. Next getting the "fitted probabilities" warning
# typically implies a problem of perfect separation. This means that one of the predictors perfectly
# separates at the binary response. In other words, for values less than or equal to a particular 
# number for a predictor, the response is always 0 or 1, and for values more than, the response is 
# the remaining 1 or 0, correspondingly. To see this, sort RouteTrain by our response: ArterialRoute.


 
 
 
# In the sorted file, you'll notice for the predictor "TrafficSignalNumber", for values less than or
# equal to 13, the response is always 0. Conversely, for values more than 13, the response is always
# 1. This is a problem of perfect separation. This makes the GLM model think that "Number of Traffic 
# Signal" is extremely important and try to assign a beta of infinity to it. One way to overcome this
# is to not include "Number of Traffic Signal" in modeling. 



 
# Now we can see the output of the GLM model with logit link

 
  
# Ideally, here you would remove insigificant variables to eventually provide a fully significant
# model. I will leave that for your practice. We can also predict the probabilities on the 
# training dataset for the likelihood of Arterial Route Choice.  


 
# Since these are probabilities, we can convert them to binary simply by an ifelse statement. 

 
 
# Finally we can compute the confusion matrix to see the accuracy of our model. 


 
 
 
# An alternative way of including the Traffic Signal Number as a predictor is to use Firth's 
# Bias Reduced Logit Model. It uses a penalized maximum likelihood estimator that can overcome
# the separation problem and still provide finite coefs. 



 
# Let's take a look at the model output. You can see that the coefs for TrafficSignalNumber and 
# Distance are the only significant coefs. Furthermore, the coef for TrafficSignalNumber is finite.



 
# We can see distance makes a negative impact. We can also get the predicted probabilities directly
# for the training data from "fm1" under "predict".


 
  
 # If you want to predict for other than training data, simply apply the logit function on the
 # testing data "X" by probs = 1 / (1 + exp(-X %*% coef(fm1)))
  
# We can create the choice similar to above using ifelse. 



 
# Finally the confusion matrix shows 100% accuracy. This is because the number of traffic signal 
# plays such a vital role is predicting route choice in our sample. 



 
 