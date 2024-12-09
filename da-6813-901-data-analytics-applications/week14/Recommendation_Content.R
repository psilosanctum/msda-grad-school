rm(list = ls())

# In this code, we will perform some recommendation routines, 
# using content based filtering and collaborative filtering.
# I won't go too much into the technical details of each of these 
# methods, however, feel free to dive into them more in details. 
#
# load necessary libraries
library(data.table)
library(reshape2)
library(proxy)

# To perform the recommendations, we will use movie ratings. 
# The dataset is from MovieLens and is publicly available. 
# I am using their smallest data (ml-latest-small.zip) to keep 
# the recommendation routine simple. 

setwd("/Users/arkaroy1/Desktop/UTSA_Class_Slides/MSDA6813/Data/ml-latest-small")

links = read.csv(file="links.csv", header=TRUE, sep=",")
movies = read.csv(file="movies.csv", header=TRUE, sep=",")
tag = read.csv(file="tags.csv", header=TRUE, sep=",")
ratings = read.csv(file="ratings.csv", header=TRUE, sep=",")

# Have a look at the structure of movies and ratings data.
str(movies)
str(ratings)

# Content based filtering: Analyze an item that an user has interacted
# with, and give recommendations that are similar in content to
# that item. "Content" refers to a set of attributes/features
# that describe the item. For e.g. for a movie recommendation 
# engine, the content based filer would recommend movies that are
# similar based on its features, such as genres, actors, directors, 
# year of production, etc. Assumption - users prefer a certain
# type of product, so we try to recommend similar products. 
# Think of it as providing alternatives/substitutes to the item
# that was viewed. 

# Here, we will build a basic content-based recommender routine 
# based on movie genres only. In more complicated routines, it is
# possible to include several attributes and place higher weights
# on attributes that have been decided to be more important. 
# This could be done with methods such as the Term Frequency–
# Inverse Document Frequency algorithm (TF-IDF). 

# To obtain the movie features matrix, the pipe-separated genres 
# available in the movies dataset had to be split. The data.table 
# package has a tstrsplit() function that works well here to 
# perform string splits
genres <- as.data.frame(movies$genres, stringsAsFactors=FALSE)
genres <- as.data.frame(tstrsplit(genres[,1], '[|]', type.convert=TRUE), 
                         stringsAsFactors=FALSE)
colnames(genres) <- c(1:7)

# Then you create a matrix with columns representing every unique genre,
# and indicate whether a genre was present or not in each movie.

# Get the unique genres present in the data
genres_list = unique(c(unique(genres[,1]), unique(genres[,2]), unique(genres[,3]), unique(genres[,4]), 
         unique(genres[,5]), unique(genres[,6]), unique(genres[,7]), unique(genres[,8]), 
         unique(genres[,9]), unique(genres[,10])))

# Remove the NA, "no genres listed" and IMAX.
genres_list = subset(genres_list, genres_list != "(no genres listed)")
genres_list = subset(genres_list, genres_list != "IMAX")
genres_list = na.omit(genres_list)

dim(movies)

genre_matrix <- matrix(0,dim(movies)[1]+1,length(genres_list)) # empty matrix with 0s, size of observations + 1
genre_matrix[1,] <- genres_list #set first row to genre list
colnames(genre_matrix) <- genres_list #set column names to genre list

#iterate through matrix
for (i in 1:nrow(genres)) {
  for (c in 1:ncol(genres)) {
    genmat_col = which(genre_matrix[1,] == genres[i,c])
    genre_matrix[i+1,genmat_col] <- 1
  }
}

#convert into dataframe
genre_matrix <- as.data.frame(genre_matrix[-1,], stringsAsFactors=FALSE) #remove first row, which was the genre list

# see data class
str(genre_matrix)
#convert from characters to integers
for (c in 1:ncol(genre_matrix)) {
  genre_matrix[,c] <- as.integer(genre_matrix[,c])
} 

# Now, what we need is a user profile matrix. This can be easily done with the dcast() function 
# in the reshape2 package. I first convert the ratings into a binary format to keep things simple. 
# Ratings of 4 and 5 are mapped to 1, representing likes, and ratings of 3 and below are mapped to 
# -1, representing dislikes.
likes_dislikes = ratings
for (i in 1:nrow(ratings)){
  if (ratings[i,3] > 3){
    likes_dislikes[i,3] <- 1
  }
  else{
    likes_dislikes[i,3] <- -1
  }
}


# Then we transforms the data from a LONG format to a WIDE format. This also creates many 
# NA values because not every user rated every movie. Let us substitute the NA values with 0.
likes_dislikes <- dcast(likes_dislikes, movieId~userId, value.var = "rating", na.rm=FALSE)
for (i in 1:ncol(likes_dislikes)){
  likes_dislikes[which(is.na(likes_dislikes[,i]) == TRUE),i] <- 0
}
likes_dislikes = likes_dislikes[,-1] #remove movieIds col. Rows are movieIds, cols are userIds

# Now we have the likes_dislikes matrix in the right format. This matrix has 9724 rows, representing 
# the movieIds, and 610 cols, representing the userIds. 

# To create the simple user profile matrix, let us compute the dot product of the movie genre matrix and 
# the likes_dislikes matrix. Before we proceed with the dot product, you might notice that the movies 
# dataset has 9742 movies, but the ratings dataset only has 9724 movies. To deal with this, let's:

# Remove the movies that have never been rated from the genres matrix.
movieIds <- (unique(movies$movieId)) #9742
ratingmovieIds <- (unique(ratings$movieId)) #9724
movies2 <- movies[-which((movieIds %in% ratingmovieIds) == FALSE),]
rownames(movies2) <- NULL

# Remove rows that are not rated from genre_matrix
genre_matrix <- genre_matrix[-which((movieIds %in% ratingmovieIds) == FALSE),]
rownames(genre_matrix) <- NULL # reset the offset here also

# Calculate dot product for User Profiles
user = as.matrix(t(genre_matrix)) %*% as.matrix(likes_dislikes)

#Convert to Binary scale
for (i in 1:nrow(user)){
  for (j in 1:ncol(user)){
    if (user[i,j] < 0)
      user[i,j] <- 0
    else 
      user[i,j] <- 1
  }
}

# This user profiles shows the aggregated inclination of each user towards movie genres. 
# Each column represents a unique userId, and positive values shows a preference towards a 
# certain genre.  

# Now that we have the user profiles, we can assume that users like similar items, and retrieve 
# movies that are closest in similarity to a user’s profile, which represents a user’s preference 
# for an item’s feature.

# Here I will show the second way, and will use Jaccard similarity to measure the similarity between user 
# profiles, and the movie genre matrix. Jaccard similarity is suitable for binary data.
# It measures the size of the intersection divided by the size of the union of the sample sets.
Jaccard = function (x, y) {
  M.11 = sum(x == 1 & y == 1)
  M.10 = sum(x == 1 & y == 0)
  M.01 = sum(x == 0 & y == 1)
  return (M.11 / (M.11 + M.10 + M.01))
}

# For every movie and user, compute Jaccard distance across the genres. This will take a while. 
# Possibly only run for a single person when running demo in class. Replace the first for loop with dim(user)[2]
# and the user_genre below to have columns dim(user)[2]. 
user_genre = matrix(0,dim(genre_matrix)[1],1)
for (u in 3:3){
  for (m in 1:dim(genre_matrix)[1]){
    user_genre[m,] = Jaccard(user[,u],genre_matrix[m,])
  }
}

# Find the movie with the highest similarity. 
movie_ind <- which(user_genre == max(user_genre))
movies2[movie_ind,]
# You'll notice the the movie Night Watch (Nochnoy dozor) falls under Action|Fantasy|Horror|Mystery|Sci-Fi|Thriller. 
rownames(user)[which(user[,3] == 1)]
# For user 3, their genre preference were Action|Mystery|Documentary|Thriller|Horror|Fantasy|Western|Film-Noir|Sci-Fi. 
# Clearly you can see the overlap.