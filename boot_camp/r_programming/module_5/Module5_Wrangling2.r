#this will remove all the data files
rm(list=ls())

# install.packages("Lahman") uncomment and run for the first time

library(tidyverse) # load libraries needed for this module
library(nycflights13)
library(Lahman)

data("relig_income")
reshaped = pivot_longer(relig_income, -religion, names_to = "income", values_to = "count") #to make longer df

data("billboard")
billboard_longer = pivot_longer(billboard, cols = starts_with("wk"), 
    names_to = "week", names_prefix = "wk", 
    values_to = "rank", values_drop_na = T) #to make longer df and drop NAs 

data("us_rent_income")
us_rent_income_wider = pivot_wider(us_rent_income, 
    names_from = variable, values_from = c(estimate, moe)) # to make wider df from multiple variables

#In class Example
data("mtcars")
(widempg = pivot_wider(mtcars, names_from = c("am", "cyl"), 
        values_from = mpg)) # make longer mtcars based on am and gears
widempg = select(widempg, `1_6`:`1_8`, everything()) #reorganize the columns

data("warpbreaks")
pivot_wider(warpbreaks, names_from = wool, values_from = breaks) #make wider but multiple values in each cell
pivot_wider(warpbreaks, names_from = wool, values_from = breaks, 
    values_fn = list(breaks = mean)) #multiple values are averaged to return mean using values_fn argument


################

(df = data.frame(x = c(NA, "a/1", "a/2", "b/3")))
(y = separate(df, x, c("A", "B"), sep = "/", convert = TRUE)) # separating text based on /, convert enforces proper class of new variable
 
 (year = data.frame(y = c(2019, 2020, 2019, 2020,2019, 2020))) # separating numbers by position
 (y1 = separate(year, y, c("Century", "year"), sep = 2, convert = TRUE))
 unite(y1, fullyear, Century, year, sep="") # uniting variables

 # Example
 data("esoph") 
 sep_esoph = separate(esoph, agegp, into = c("MinAge", "MaxAge"), sep = "-") # separating by -
 
 unite(sep_esoph, agegp, MinAge, MaxAge, sep = "-") #Bad idea, missing values!
 unite(sep_esoph, agegp, MinAge, MaxAge, sep = "-", na.rm = TRUE) #gets rid of missing values
 wider_esoph = pivot_wider(esoph, names_from = agegp, 
        values_from = c("ncases", "ncontrols")) #make wider and 2 variables
 
# Example
data("flights")
data("airlines")
data("planes")
data("weather")
data("airports")

dist=count(planes, planes$tailnum) # check if tailnum is unique
dist
filter(dist, n >1) # none -  so tailnum is unique in planes table so its a primary ket
 
dist_flight=count(flights, flights$month, flights$day, flights$flight) 
dist_flight
filter(dist_flight, n>1) # here there is more than 1 so it's not unique so not a primary key
 
mutate(flights, id = row_number()) # create your own unique id using rownames().

flight2 = left_join(select(flights,carrier, dep_time, 
        dep_delay, flight), airlines, by = "carrier") #joining flights and airlines by carrier

Joined = left_join(flights,weather) # joining without a key, tidyverse will use intersecting variables
left_join(flights, airports, by = c("dest"="faa")) #with multiple keys, you can specify one. 
left_join(flights, airports, by = c("origin"="faa"))

(top_dest = head(count(flights, dest, sort = TRUE), 10)) #find top 10 destinations
semi_join(flights, top_dest, by = "dest") # find flights that go to top 10 dests
anti_join(flights, top_dest, by = "dest") # find flights that don't go to top 10 dests

anti_join(flights, planes, by = "tailnum")

## Texas example - load data
hmda_2017_tx_all_40 = read_csv("/Users/arkaroy1/Dropbox/My Mac (arkas-mac.lan)/Desktop/UTSA_Class_Stuff/MSDA Bootcamp/Data/Texas_data/hmda_2017_tx_all_40.csv")
hmda_2017_tx_all_06 = read_csv("/Users/arkaroy1/Dropbox/My Mac (arkas-mac.lan)/Desktop/UTSA_Class_Stuff/MSDA Bootcamp/Data/Texas_data/hmda_2017_tx_all_06.csv")

smallTexas = sample_n(hmda_2017_tx_all_06, 500) # take 500 samples. 
rm(hmda_2017_tx_all_06) # removing full data to save memory, these are big datasets.
Texas = left_join(smallTexas, select(hmda_2017_tx_all_40, respondent_id, lien_status), by = "respondent_id") # merging lien status to the sample
rm(hmda_2017_tx_all_40) # removing full data to save memory

table(Texas$lien_status) # finding the most common lien status

#Baseball example
data("AwardsManagers")
data("Managers")
data("AwardsPlayers")
data("Salaries")
data("Appearances")
data("People")

AwardedManagers = left_join(Managers, AwardsManagers, by = "playerID") #merge managers with awards
AwardedManagers = select(AwardedManagers, -c("yearID.y":"notes")) #reorganizing columns

AwdSal = left_join(Salaries, AwardsPlayers, by = c("playerID", "yearID")) #mergine salary with awards for players
AwdSal = select(AwdSal, -c("lgID.y":"notes")) #reorganizing columns

topsals = slice(arrange(AwdSal, desc(salary)), 1:10) #sorting by descending salaries (top)
bottomsals = slice(arrange(AwdSal, (salary)), 1:10) #sorting by salaries (bottom)

paid_sitters = anti_join(Salaries, Appearances, by = c("playerID", "yearID")) #players who were paod but didn't play

unpaid = anti_join(People, Salaries, by = "playerID")  #players who weren't paid
playUnpaid= left_join(unpaid, Appearances, by = "playerID") #players who weren't paid but played
grp_playUnpaid = group_by(playUnpaid, playerID) #players played multiple times without pay so group by players
TotalPlayedUnpaid = summarise(grp_playUnpaid , total_games = sum(GS, na.rm = TRUE)) #sum all the games they started without pay
arrange(TotalPlayedUnpaid, desc(total_games)) #sort in scending order and show players who played most games without pay


