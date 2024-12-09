# In this note we develop an Agglomerative Hierarchical 
# clustering. It’s also known as Agglomerative Nesting. 
# It works in a bottom-up manner. That is, each object is 
# initially considered as a single-element cluster (leaf). 
# At each step of the algorithm, the two clusters that are 
# the most similar are combined into a new bigger cluster 
# (nodes). This procedure is iterated until all points are 
# member of just one single big cluster (root). The result 
# is a tree which can be plotted as a dendrogram.


# Install missing packages if they aren't installed already
# install.packages("tidyverse") # data manipulation
# install.packages("cluster") # clustering algorithms
# install.packages("factoextra") # clustering visualization
# install.packages("dendextend") # for comparing two dendrograms

# Load the packages 
library(tidyverse)  # data manipulation
library(cluster)    # clustering algorithms
library(factoextra) # clustering visualization
library(dendextend) # for comparing two dendrograms

# Load the data



# Remove any missing value that might be present in the data:



# As we don’t want the clustering algorithm to depend to an 
# arbitrary variable unit, we start by scaling/standardizing:



# To see how the data looks after scaling



# Compute dissimilarity matrix




# How to we measure the dissimilarity between observations? There are many ways. 
# One way:Maximum or complete linkage clustering: It computes all 
# pairwise dissimilarities between the elements in cluster 1 
# and the elements in cluster 2, and considers the largest value 
# (i.e., maximum value) of these dissimilarities as the distance 
# between the two clusters. It tends to produce more compact clusters.

# Hierarchical clustering using "Complete" link




# Plot the obtained dendrogram -- Click plot zoom.



# In the dendrogram, each leaf is an observation. As we move up the 
# tree, observations that are similar to each other are combined into 
# branches, which are themselves fused at a higher height.

# The height of the fusion, provided on the vertical axis, indicates 
# the (dis)similarity between two observations. The higher the height 
# of the fusion, the less similar the observations are.

# Cut tree into 4 groups



# Number of members in each cluster



# Draw the dendrogram with a border around the 4 clusters. The argument 
# border is used to specify the border colors for the rectangles:



