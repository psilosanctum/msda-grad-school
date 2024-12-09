# This program is for building a recommendation system
rm(list=ls())

if(!"recommenderlab" %in% rownames(installed.packages())){install.packages("recommenderlab")}

library(recommenderlab)
library(ggplot2)

data("MovieLense") # load the data

MovieLense # Details about the movie dataset
#
# Get the distribution of ratings
table(as.vector(MovieLense@data))

# Total number of ratings. Has to match the total number of cells (943*1664 = 1,569,152)
sum(table(as.vector(MovieLense@data)))

### Get some idea about the average ratings of the movies
movie.rating <- colMeans(MovieLense)
qplot(movie.rating, geom = "histogram") # Fairly normal, with mean around a rating of 3. 

### Get some idea about the total number of ratings
user.rating.count <- rowCounts(MovieLense)
qplot(user.rating.count, geom = "histogram")  # Looks heavily skewed to right. Some movies rated very few times. 

# For the analysis it might be a good idea to remove extreme movies and users
# So, if a movie is rated by less than 50 users then we will drop it
# If a user has rated fewer than 25 movies we will drop the user
newmat <- MovieLense[user.rating.count >= 25, colCounts(MovieLense) >= 50]
newmat

# Take a look at updated avg movie rating
qplot(colMeans(newmat), geom = "histogram") # Slightly shifted, higher mean above 3.5.


## Take a look at the average user rating
user.rating <- rowMeans(newmat)
qplot(user.rating, geom = "histogram")

# See normalized values 
newmat.norm <- normalize(newmat)
qplot(rowMeans(newmat.norm), geom = "histogram")


## Build recommender
r1 <- Recommender(newmat, method = "UBCF")
m1 <- getModel(r1)
names(m1)

# method: a character string defining the recommender method to use.

# The recommender algorithms to be applied to the data set are as follows:
# 1.User-based Collaborative Filtering;
# 2.Item-based Collaborative Filtering;

# The User-Based Collaborative Filtering Approach groups users according to prior usage behavior or 
# according to their preferences, and then recommends an item that a similar user in the same group 
# viewed or liked. To put this in layman terms, if user 1 liked movie A, B and C, and if user 2 liked 
# movie A and B, then movie C might make a good recommendation to user 2. The User-Based Collaborative 
# Filtering approach mimics how word-of-mouth recommendations work in real life.

# Item-Based Collaborative Filtering is a model-based approach which produces recommendations based on 
# the relationship between items inferred from the rating matrix. The assumption behind this approach is 
# that users will prefer items that are similar to other items they like.
# The model-building step consists of calculating a similarity matrix containing all 
# item-toitem similarities using a given similarity measure. Popular are again Pearson 
# correlation and Cosine similarity. All pairwise similarities are stored in a nxn similarity 
# matrix S. To reduce the model size to n x k with k << n, for each item only a list of the 
# k most similar items and their similarity values are stored. The k items which are most similar
# to item i is denoted by the set S(i) which can be seen as the neighborhood of size k of the 
# item. Retaining only k similarities per item improves the space and time complexity 
# significantly but potentially sacrifices some recommendation quality (Sarwar et al. 2001).

# Cosine similarity is a measure of similarity between two non-zero vectors of an inner 
# product space that measures the cosine of the angle between them. The cosine of 0 is 1, 
# and it is less than 1 for any angle in the interval (0, ] radians. It is thus a judgment 
# of orientation and not magnitude: two vectors with the same orientation have a cosine 
# similarity of 1, two vectors oriented at 90? relative to each other have a similarity of 0,
# and two vectors diametrically opposed have a similarity of -1, independent of their magnitude.

### create predictions for the train data using known ratings 
p1 <- predict(r1, newmat, type = "ratings")
p1
as(p1,"matrix")[1,1:10]

# ratings: Object of class "list". Each element in the list represents a top-N 
# recommendation (an integer vector) with item IDs (column numbers in the rating matrix). 
# The items are ordered in each vector.

# Why so many NAs? 
image(newmat[1:100,1:100])
# Sparse data

### Do full analysis of the prediction model with a holdout sample
set.seed(12345)
e <- evaluationScheme(newmat, method="split", train=0.8, given = 15, goodRating=5, k=10)
e

#Creates an evaluationScheme object from a data set. The scheme can be a simple 
#split into training and test data, k-fold cross-evaluation or using k independent 
#bootstrap samples.

#"split" randomly assigns the proportion of objects specified by train to the training 
#set and the rest is used for the test set.

#"cross-validation" creates a k-fold cross-validation scheme. The data is randomly
#split into k parts and in each run k-1 parts are used for training and the remaining 
#part is used for testing. After all k runs each part was used as the test set exactly once.

#"bootstrap" creates the training set by taking a bootstrap sample (sampling with replacement) 
#of size train times number of users in the data set. All objects not in the training set 
#are used for testing.

e1 <- evaluate(e, method = "POPULAR", type = "topNList", n = c(1,3,5,7,10))

#Evaluates a single or a list of recommender model given an evaluation scheme.

#method: a character string or a list.
#TopNLists: signature(x = "realRatingMatrix"): create top-N lists from the ratings in x. 

#n: N (number of recommendations) of the top-N lists generated (only if type="topNList")

# ROC curve
x11();plot(e1, annotate = T)


r1 <- Recommender(getData(e, "train"), "UBCF")
r1

#getData: signature(x = "evaluationScheme"): access data. 
#Parameters are type ("train", "known" or "unknown") and run (1...k). 

#"train" returns the training data for the run 
#"known" returns the known ratings used for prediction for the test data 
#"unknown" returns the ratings used for evaluation for the test data.


p1 <- predict(r1, getData(e, "known"), type="ratings")
p1

as(p1,"matrix")[1,1:10]

#Calculate prediction accuracy. For predicted ratings MAE (mean average error), 
#MSE (means squared error) and RMSE (root means squared error) are calculated. 
#For topNLists various binary classification metrics are returned.

calcPredictionAccuracy(p1, getData(e, "unknown"))

p11 <- predict(r1, getData(e, "known"), type="ratings", n = 5) # top 5 list
p11

as(p11,"matrix")[1:10,1:5]

# If you don't create an evaluation scheme, due to sparsity, get lots of NA. 

set.seed(2346)
mind <- sample(nrow(newmat), 0.8*nrow(newmat), replace = F)
newmat_train <- newmat[mind,]
newmat_test <- newmat[-mind,]


t1 <- Recommender(newmat_train, "UBCF")
t11 <- predict(t1,newmat_test, n=5)
t11

as(t11,"matrix")[1:10,1:5]
rowCounts(t11)[1:5]

# For presentation
recs <- sapply(t11@items,
               function(x){colnames(newmat)[x]})

head(t(recs)) # for presentation

##### Comparing with other models

r2 <- Recommender(getData(e, "train"), "IBCF")
p2 <- predict(r2, getData(e, "known"), type="ratings")
calcPredictionAccuracy(p2, getData(e, "unknown"))



## Add more models

p3 <- predict(Recommender(getData(e, "train"), "POPULAR")
              , getData(e, "known"), type="ratings")

p4 <- predict(Recommender(getData(e, "train"), "SVD")
              , getData(e, "known"), type="ratings")

p5 <- predict(Recommender(getData(e, "train"), "SVDF")
              , getData(e, "known"), type="ratings")



rbind(UBCF = calcPredictionAccuracy(p1, getData(e, "unknown")),
      IBCF = calcPredictionAccuracy(p2, getData(e, "unknown")),
      Popular = calcPredictionAccuracy(p3, getData(e, "unknown")),
      SVD = calcPredictionAccuracy(p4, getData(e, "unknown")),
      SVDF = calcPredictionAccuracy(p5, getData(e, "unknown")))





####
p11 <- predict(r1, newmat_test, type = "ratingMatrix")
as(p11,"matrix")[1,1:10]

#Class "RatingMatrix": Virtual Class For Rating Data. Defines a common class for rating data.
