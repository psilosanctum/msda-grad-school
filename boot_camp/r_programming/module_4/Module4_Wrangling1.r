library(tidyverse) # load package

##example reading in data
Texas = read_csv("/Users/arkaroy1/Dropbox/My Mac (arkas-mac.lan)/Desktop/UTSA_Class_Stuff/MSDA Bootcamp/Data/Texas_data/hmda_2017_tx_all_06.csv")
str(Texas)

# reading in file wthout giving column names. 
states <- read_csv("/Users/arkaroy1/Dropbox/My Mac (arkas-mac.lan)/Desktop/UTSA_Class_Stuff/MSDA Bootcamp/Data/introductory_state_example.csv", col_names = c("years", "states", "population"))

# reading this file
college <- read_csv("/Users/arkaroy1/Dropbox/My Mac (arkas-mac.lan)/Desktop/UTSA_Class_Stuff/MSDA Bootcamp/Data/college_history.csv", na = c("", "."))
challenge = read_csv(readr_example("challenge.csv"), guess_max = 1200)

write_csv(college, "/Users/arkaroy1/Dropbox/My Mac (arkas-mac.lan)/Desktop/UTSA_Class_Stuff/MSDA Bootcamp/Data/test_college.csv")

data("mtcars") #loading data
head(mtcars) #seeing first 6 observations

carnames = rownames(mtcars) #getting the names of cars that are stored as row names
print(carnames) # print function
mtcars$names = carnames # creating a new variable for the car names
mtcars = as_tibble(mtcars) #converting to tibble

tibble(a=c(1:10), b = "x",c=4*a) #crearting a tibble
tibble(`$$` = c("USD","AUD","PES", "YEN"), `.1`=20) #can use unconventional names in tibbles

data("iris") #load data
print(iris)
tib_iris = as_tibble(iris) # convert to tibble
print(tib_iris)

(cars_reduced = filter(mtcars, carb == 1, gear == 4)) #filter cars with 1 carb and 4 gears

(cars56 = filter(mtcars, cyl == 6 | gear == 5)) #filter cars with 6 cylinders and 5 gears

(cars56_both = filter(mtcars, cyl == 6 & gear == 5)) #filter cars with 6 cylinders and 5 gears

test = arrange(mtcars,cyl,desc(gear),carb) # sort mtcars first by cylinders, then gears, then carburetors

secular_colls <-  filter(college, sponsorship == "Secular") #Find secular college
secular_colls_srtd <-  arrange(secular_colls, established) # sort by time (established)
original_name = secular_colls_srtd$original_name[!is.na(secular_colls_srtd$original_name)] #Find the orginal_name that is not missing

states1840 = filter(states, years == 1840) # Find states in 1840
print(arrange(states1840, desc(population)), n=5) #sort by population and print top 5

#Extra
big_income = filter(Texas, hud_median_family_income > 75000)
srtd_pop = arrange(big_income, desc(population))

###
select(mtcars, mpg, cyl, hp, am) #select the variables mpg, cyl, hp, and am from mtcars and make an object
select(mtcars,mpg:hp)
select(mtcars, -c(mpg:hp)) #select all but the variable mpg to hp
select(mtcars, starts_with("mp")) # picks up columns that start with mp
select(mtcars, contains("m")) # picks up columns that contains m
select(mtcars, gear, cyl, everything()) #everything() helps reorganize data

mutate(mtcars, mileagePerCylinder = mpg/cyl) #create a new variable mileagePerCylinder using formula
# and put at the end of the object

mtcars2 = transmute(mtcars, mileagePerCylinder = mpg/cyl) #assigning the mutated object to mtcars2 object

#install.packages("corrplot") # helps make a correlation matrix plot
library(corrplot)

my_data = select(mtcars, mpg, disp, hp, drat, wt, qsec)
rc = cor(my_data) #computes a correlation matrix, input is a data frame of variables mpg, disp, hp, drat, wt, qsec.
corrplot(rc) #plots the correlation matrix

eff_mtcars = mutate(mtcars, efficient = if_else(mpg > 23, 1, 0)) # make efficient var where mpg > 23 and put 1 else 0
eff_cars = filter(eff_mtcars, efficient == 1) #filter the efficient variable == 1
mean(eff_cars$mpg) #mean mpg of efficient cars

# Extra
Texas_mod = mutate(Texas, perc_min_pop = minority_population*100/population)

####
summarise(mtcars, avgmpg = mean(mpg), minmpg = min(mpg), maxmpg = max(mpg))# not too useful

grp_data = group_by(mtcars,cyl,gear,carb) #group mtcars by cylinders, then gears, then carburetors
summarise(grp_data, avempg=mean(mpg), minmpg = min(mpg), maxmpg = max(mpg)) #compute summary stats across groups.

filter(grp_data, mpg>27)
mutate(filter(grp_data, mpg>27), mileagePerCylinder = mpg/cyl)

sample_n(mtcars, 5)
sample_frac(mtcars, 0.5)

by_gears = group_by(mtcars, gear)
sample_n(by_gears, 3)

data("ChickWeight") 
test = mutate(ChickWeight, diet_name = case_when(Diet == 1 ~ "Veges", Diet == 2 ~ "Fruits", Diet == 3 ~ "Candy", Diet == 4 ~ "Meat"))

library(nycflights13) #example of nyc flights

data("flights") #load data
head(flights) #peek at data

#flights on januart 1st
jan1flights = filter(flights, month == 1, day == 1)

feb1flights = filter(flights, month == 2, day == 1)

# sort the flights on jan 1 by arrival delay
srtdjan1flights = arrange(jan1flights, desc(arr_delay))

srtdfeb1flights = arrange(feb1flights, desc(arr_delay))
# select and show carrier and flights information
dfjan = select(srtdjan1flights, carrier, flight, arr_delay)

dffeb = select(srtdfeb1flights, carrier, flight, arr_delay)

head(dfjan, n = 5) # see top 5. 
head(dffeb, n = 5)

# compute gain
df2 = mutate(flights, gain = arr_delay - dep_delay)
df2_new = mutate(flights, total_delay = arr_delay + dep_delay)
# compute speed
df3 = mutate(df2, speed = distance/air_time)
#sort gain, select and show carrier and flights information
df4 = select(arrange(df3, desc(gain)), carrier, flight, gain)
df4_new = select(arrange(df2_new, desc(total_delay)), carrier, flight, total_delay)

head(df4, n = 5) #see top 5
head(df4_new, n = 5) 


