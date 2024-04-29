LIBNAME mylib "P:\";
FILENAME bigrec "P:\fa15_data.txt"  LRECL = 65576;
DATA mytemp;
INFILE bigrec;
INPUT 
myid 1-7
clothes_last_long_time_aglo 3411 
clothes_last_long_time_agli 3438
clothes_last_long_time_neit 3492
clothes_last_long_time_dgli 3519
clothes_last_long_time_dglo 3546

buy_clothes_dont_need_aglo 3417 
buy_clothes_dont_need_agli 3444
buy_clothes_dont_need_neit 3498
buy_clothes_dont_need_dgli 3525
buy_clothes_dont_need_dglo 3552

attractive_to_others_aglo 3412 
attractive_to_others_agli 3439
attractive_to_others_neit 3493
attractive_to_others_dgli 3520
attractive_to_others_dglo 3547

disc_clothes_good_aglo 3421 
disc_clothes_good_agli 3448
disc_clothes_good_neit 3502
disc_clothes_good_dgli 3529
disc_clothes_good_dglo 3556

dress_to_please_myself_aglo 3431 
dress_to_please_myself_agli 3458
dress_to_please_myself_neit 3512
dress_to_please_myself_dgli 3539
dress_to_please_myself_dglo 3566

adidas_brand 42607;
RUN;
/* the above reads in the raw data from the data file -  now create five point scale variables */
/* now before we create variables lets create formats so we know what each value will mean */
PROC FORMAT;
VALUE myscale
     1 = "disagree a lot"
     2 = "disagree a little"
     3 = "neither agree nor disagree"
     4 = "agree a little"
     5 = "agree a lot";
VALUE yesno
     0 = "no"
     1 = "yes";
RUN;
/* do that by creating a new temp sas data set myvars by starting with the temp sas data set mytemp */
DATA myvars;
SET mytemp;
IF clothes_last_long_time_dglo = 1 THEN clothes_last_long_time = 1;                                                  
IF clothes_last_long_time_dgli = 1 THEN clothes_last_long_time = 2;                                             
IF clothes_last_long_time_neit = 1 THEN clothes_last_long_time = 3;                                                  
IF clothes_last_long_time_agli = 1 THEN clothes_last_long_time = 4;                                                  
IF clothes_last_long_time_aglo = 1 THEN clothes_last_long_time = 5;     

IF buy_clothes_dont_need_dglo = 1 THEN buy_clothes_dont_need = 1;                                                 
IF buy_clothes_dont_need_dgli = 1 THEN buy_clothes_dont_need = 2;                                                
IF buy_clothes_dont_need_neit = 1 THEN buy_clothes_dont_need = 3;    
IF buy_clothes_dont_need_agli = 1 THEN buy_clothes_dont_need = 4;                                                 
IF buy_clothes_dont_need_aglo = 1 THEN buy_clothes_dont_need = 5;

IF attractive_to_others_dglo = 1 THEN attractive_to_others = 1;                                                 
IF attractive_to_others_dgli = 1 THEN attractive_to_others = 2;                                                
IF attractive_to_others_neit = 1 THEN attractive_to_others = 3;    
IF attractive_to_others_agli = 1 THEN attractive_to_others = 4;                                                 
IF attractive_to_others_aglo = 1 THEN attractive_to_others = 5;

IF disc_clothes_good_dglo = 1 THEN disc_clothes_good = 1;                                                 
IF disc_clothes_good_dgli = 1 THEN disc_clothes_good = 2;                                                
IF disc_clothes_good_neit = 1 THEN disc_clothes_good = 3;    
IF disc_clothes_good_agli = 1 THEN disc_clothes_good = 4;                                                 
IF disc_clothes_good_aglo = 1 THEN disc_clothes_good = 5;

IF dress_to_please_myself_dglo = 1 THEN dress_to_please_myself = 1;                                                 
IF dress_to_please_myself_dgli = 1 THEN dress_to_please_myself = 2;                                                
IF dress_to_please_myself_neit = 1 THEN dress_to_please_myself = 3;    
IF dress_to_please_myself_agli = 1 THEN dress_to_please_myself = 4;                                                 
IF dress_to_please_myself_aglo = 1 THEN dress_to_please_myself = 5;   

/* now set up binary yes ? no variables knowing that missing values get a zero and a 1 gets a 1 */
IF adidas_brand = .  THEN adidas = 0;
IF adidas_brand = 1 THEN adidas = 1;

LABEL clothes_last_long_time = 'I make my clothes last a long time.';
LABEL buy_clothes_dont_need = 'Often buy clothes I dont really need.';
LABEL attractive_to_others = 'Important to look attractive to others.';
LABEL disc_clothes_good = 'Clothes at disc dept just as good as dept.';
LABEL dress_to_please_myself = 'Dress to please myself.';

/* now attach the values for each of the variables using the proc format labels */
FORMAT clothes_last_long_time buy_clothes_dont_need attractive_to_others disc_clothes_good dress_to_please_myself  myscale.
	   adidas yesno. ;
RUN;
/* now run freqs to check your work */
PROC FREQ DATA = myvars;
TABLES
clothes_last_long_time_dglo
clothes_last_long_time_dgli
clothes_last_long_time_neit
clothes_last_long_time_agli
clothes_last_long_time_aglo

buy_clothes_dont_need_dglo
buy_clothes_dont_need_dgli
buy_clothes_dont_need_neit
buy_clothes_dont_need_agli
buy_clothes_dont_need_aglo


attractive_to_others_dglo
attractive_to_others_dgli
attractive_to_others_neit
attractive_to_others_agli
attractive_to_others_aglo

disc_clothes_good_dglo
disc_clothes_good_dgli
disc_clothes_good_neit
disc_clothes_good_agli
disc_clothes_good_aglo

dress_to_please_myself_dglo
dress_to_please_myself_dgli
dress_to_please_myself_neit
dress_to_please_myself_agli
dress_to_please_myself_aglo

clothes_last_long_time
buy_clothes_dont_need
attractive_to_others
disc_clothes_good
dress_to_please_myself

adidas;
RUN; 
