libname mylib "P:\";
filename bigrec "P:\fa15_data.txt"  lrecl = 65576;
data mytemp;
infile bigrec;
input 
myid 1-7
used_car_dgli  3749                                                  
used_car_neit  3713                                                  
used_car_agli  3641                                                  
used_car_aglo  3605                                                  
used_car_anya  3677                                                  
used_car_anyd  3821                                                  
used_car_dglo  3785                                                  
no_time_healthy_meal_agli  4045                                                 
no_time_healthy_meal_aglo  4026                                                 
no_time_healthy_meal_anya  4064                                                 
no_time_healthy_meal_anyd  4140                                                 
no_time_healthy_meal_dgli  4102                                                 
no_time_healthy_meal_dglo  4121                                                 
no_time_healthy_meal_neit  4083     
coca_cola_classic  40103
espn  9625
ikea  43988 
kfc  41650
nike  42621;
run;
/* the above reads in the raw data from the data file -  now create five point scale variables */
/* now before we create variables lets create formats so we know what each value will mean */
proc format;
value myscale
     1 = "disagree a lot"
     2 = "disagree a little"
     3 = "neither agree nor disagree"
     4 = "agree a little"
     5 = "agree a lot";
value yesno
     0 = "no"
     1 = "yes";
run;
/* do that by creating a new temp sas data set myvars by starting with the temp sas data set mytemp */
data myvars;
set mytemp;
if used_car_dglo  = 1 then used_car_good =1;                                                  
if used_car_dgli   = 1 then used_car_good = 2;                                             
if used_car_neit = 1 then used_car_good = 3;                                                  
if used_car_agli = 1 then used_car_good = 4;                                                  
if used_car_aglo = 1 then used_car_good = 5;     
if no_time_healthy_meal_dglo  = 1 then no_time_eat_healthy = 1;                                                 
if no_time_healthy_meal_dgli  =1 then no_time_eat_healthy = 2;                                                
if no_time_healthy_meal_neit  = 1 then no_time_eat_healthy = 3;    
if no_time_healthy_meal_agli  = 1 then no_time_eat_healthy = 4;                                                 
if no_time_healthy_meal_aglo  =1 then no_time_eat_healthy = 5;  
/* now set up binary yes � no variables knowing that missing values get a zero and a 1 gets a 1 */
if coca_cola_classic = .  then classic_coke = 0;
if coca_cola_classic = 1 then classic_coke = 1;
if espn = . then espn_sports = 0;
if espn = 1 then espn_sports = 1;
if ikea = . then ikea_furniture = 0;
if ikea = 1 then ikea_furniture = 1;
if kfc = . then kfc_chicken = 0;
if kfc =1 then kfc_chicken = 1;
if nike = . then nike_trainers = 0;
if nike = 1 then nike_trainers = 1;
label used_car_good 'a used car is as good as a new car';
label no_time_eat_healthy 'I do not have time to eat a healthy meal';
/* now attach the values for each of the variables using the proc format labels */
format   used_car_good    no_time_eat_healthy  myscale.
                coca_cola_classic  espn_sports  ikea_furniture  kfc_chicken  nike_trainers  yesno. ;
run;
/* now run freqs to check your work */
proc freq data = myvars;
tables
used_car_dglo                                               
used_car_dgli                                            
used_car_neit                                            
used_car_agli                                              
used_car_aglo    
no_time_healthy_meal_dglo                                                 
no_time_healthy_meal_dgli                                                
no_time_healthy_meal_neit     
no_time_healthy_meal_agli                                               
no_time_healthy_meal_aglo
used_car_good
no_time_eat_healthy
classic_coke 
espn_sports  
ikea_furniture  
kfc_chicken  
nike_trainers;
run ; 

