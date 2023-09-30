# install.packages("magrittr") # for tee pipes, otherwise basic pipes are covered by tidyverse

library(magrittr) #load packages
library(tidyverse)

data("mtcars") #for data

mtcars %>%
  filter(carb > 1) %>%
  group_by(cyl) %>%
  summarise(Ave_mpg = mean(mpg)) %>%
  arrange(desc(Ave_mpg)) # learning how to use pipes instead of wrapped functions or intermediate objects
# we grouped by cylinders, then computed means and sorted. 

cars_reduced = mtcars %>% group_by(cyl, gear,carb) %>% filter(mpg>27) %>% 
  mutate(MileagePerCylinder = mpg/cyl) #grouped by cylinders, gears and carburetors, found efficient cars (mpg>27) and computed their mileage per cylinders

rnorm(100) %>% matrix(ncol = 2) %T>% plot() %>% str() #create 100 random numbers to plot and see class and values. Tee pipes helps and plot doesn't return any object
#tee pipe will return the left hand side to the next two functions

#Example in class
mtcars %>% filter(carb > 1) %>% select(c(1:4)) %T>% plot() %>% summary() #plot kills the ouput

x = as_vector(mtcars$mpg)
y = as_vector(mtcars$hp)
cor.test(x,y) # compute correlation

data("diamonds")
diamonds %>% filter(color == "I") %>% group_by(cut) %>% summarize(price = mean(price)) #practice filter group and sumarize with pipes
diamonds %>% filter(cut == "Ideal") %>% group_by(color) %>% summarize(sd_carat = sd(carat))

diamonds %>% unite(dims, x, y, z, sep = ",") # uniting data for x, y, z dimensions of diamonds

######

set.seed(3)
df = tibble(a = rnorm(10), b = rnorm(10), c = rnorm(10), d = rnorm(10)) #creating a dataframe of random numbers

rescale01 = function(x){rng = range(x,na.rm = T) #writing a function to rescale objects using max and min
(x-rng[1])/(rng[2]-rng[1])
}
df$a = rescale01(df$a) #rescaling using rescale function
df$b = rescale01(df$b)
df$c = rescale01(df$c)
df$d = rescale01(df$d)
print(df)

(df = data.frame(a=c(1:3), b = c(4:6), c= c(10:12))) # zscore function
zscore = function(x) {
  z = (x-mean(x))/sd(x)
  return(z)
}


zscore(df$a)
zscore(df$b)
zscore(df$c) #computing zscores using function

(df2 = data.frame(a=c(1:3), b = c(4,5,Inf), c = c(7,8,NA), d = c(10:12))) # zscore function
zscore(df2$a)
zscore(df2$b)
zscore(df2$c)
zscore(df2$d)

zscore_mod = function(x) {
  x = x[which(x<Inf)]
  z = (x-mean(x, na.rm = T))/sd(x, na.rm = T)
  return(z)
}
zscore_mod(df2$a)
zscore_mod(df2$b)
zscore_mod(df2$c)
zscore_mod(df2$d)

###Example
data("airquality")

#1
normalize <- function(x){normalize <- (x-min(x))/(max(x)-min(x)); return(normalize)}
normalize <- function(x){normalize <- (x-min(x, na.rm = TRUE))/(max(x, na.rm = TRUE)-min(x, na.rm = TRUE)); return(normalize)}

#2 
airquality %>% mutate(norm_ozone = normalize(Ozone)) %>% select(norm_ozone, Month) %>% group_by(Month) %>% summarise(month_norm_ozone = mean(norm_ozone, na.rm = TRUE))

#3 
zscore <- function(x){z <- (x-mean(x, na.rm = TRUE))/sd(x, na.rm = TRUE); return(z)}
airquality %>% mutate(z_ozone = zscore(Ozone)) %>% select(z_ozone, Month) %>% group_by(Month) %>% summarise(month_z_ozone = mean(z_ozone, na.rm = TRUE))

#Conditionals
if(c(1:3) == c(1,3,5)){
  sum(1:5)
}else{
  sum(1:2)
} #issues

if(all(c(1:3) == c(1,3,5))){
  sum(1:5)
}else{
  sum(1:2)
} #better

if(identical(c(1:3), c(1,3,5))){
  sum(1:5)
}else{
  sum(1:2)
} #best

sqrt(2)^2 == 2 ## why?

# multiple conditions
switch(3,"red","green","blue")
switch("length", "color" = "red", "shape" = "square", "length" = 5)

# Examples
myfun <- function(x) {  #myfun function squares a numeric vector
  if(is.vector(x, mode = "numeric")) {
    return(x^2) }
  else {
    stop("Wrong data format!")
  }
}

a = c("1","2","3","4","5","6","7")
str(a)

myfun(a)

mydist <- function(n, distribution, shape = NULL) {   #mydist function generates random numbers
  if(distribution == "gamma" && shape == "NULL")
    stop("Specify shape parameter")
  switch(distribution,
         gamma = rgamma(n, shape),
         exp = rexp(n),
         norm = rnorm(n),
         stop("distribution must be either gamma, exponential, or normal"))
}

set.seed(1)
mydist(20, "exp")

##for loops
df = tibble(a = rnorm(10), b = rnorm(10), c = rnorm(10), d = rnorm(10)) #creating a dataframe of random numbers
median(df$a); median(df$b); median(df$c); median(df$d);

output = numeric(length = ncol(df)) #initialize - important for loops
for (i in seq_along(df)){
  output[i] = median(df[[i]])
}
print(output)

## while loops
flip = function(){sample(c("T", "H"), 1)
}

flips = 0
nheads = 0

while(nheads < 3){
  if(flip() == "H"){
    nheads = nheads + 1
  }else{
    nheads = 0
  }
  flips = flips + 1
}
print(flips)

###
df = tibble(a = rnorm(10), b = rnorm(10), c = rnorm(10), d = rnorm(10)) #creating a dataframe of random numbers
col_summary = function(df, fun){
  out = numeric(length = ncol(df))
  for (i in seq_along(df)){
    out[i] = fun(df[[i]])
  }
  print(out)
}

col_summary(df, mean)
col_summary(df, median)
col_summary(df, sd)

###
m1 = matrix(c(1:10), nrow = 5, ncol = 6)
a_m1 = apply(m1, MARGIN = 1,FUN = sum)

movies = c("spyderman", "batman", "vertigo", "chinatown")
movies_upper = lapply(movies, toupper)
movies_upper2 = sapply(movies, toupper)

print(movies_upper)
print(movies_upper2)

str(movies_upper)
str(movies_upper2)

data("mtcars")
tapply(mtcars$mpg, mtcars$cyl, mean)

# finance stock prices example
setwd("/Users/arkaroy1/Dropbox/My Mac (arkas-mac.lan)/Desktop/UTSA_Class_Stuff/MSDA Bootcamp/Data")

tech <- c("FB-2", "GOOG", "^GSPC-2", "^IRX") #create vector of filenames
#create an empty data frame to fill
dat <- data.frame() 

# Read csv, add a column referring to the company
# Then combine them into one data folder
for (sym in tech) {
  filename = paste(sym, ".csv", sep="") #filenames
  t <- read_csv(filename)
  t = t[!is.na(t[,"Open"]),] #remove observation thats empty for Open variable. This is only okay for this data, because GOOG has an extra observation thats empty.
  t <- mutate(t, Symbol = sym) #make new variable with company name
  
  dat <- rbind(dat, t) #add onto previous companies data or empty df.
}

df <- dat %>% mutate(PriceChange = Open - Close) #compute new variable about price change
df2 <- dat %>% mutate(MaxChange = High - Low) #compute new variable about price change

correl <- c() #initialize empty vector
X <- df %>% filter(Symbol == "FB-2") %>% select(PriceChange) #set X outside of look for price change for facebook
for (sym in tech[2:4]) { #loop runs over all companies except fb
  Y <- df %>% filter(Symbol == sym) %>% select(PriceChange)   #Y changes in loop for price change for other companies
  r <- cor(X, Y) %>% round(2) #compute correlation and roung to 2 decimal points
  msg <- paste("Correlation between daily price changes in Facebook stocks and ", sym, " is ", r, 
               ".", sep="") #creates an object with the sentence and correlation value in relation to fb.
  print(msg) #prints the above message
  correl <- c(correl, r) #stores the correlation values. 
}
