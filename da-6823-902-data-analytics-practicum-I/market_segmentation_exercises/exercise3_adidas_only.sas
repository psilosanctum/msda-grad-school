LIBNAME mylib "P:\";
FILENAME bigrec "P:\fa15_data.txt"  LRECL = 65576;
DATA mytemp;
INFILE bigrec;
INPUT 
myid 1-7
purchase_online_safe_aglo 5526 
purchase_online_safe_agli 5564
purchase_online_safe_neit 5640
purchase_online_safe_dgli 5678
purchase_online_safe_dglo 5716

buy_online_aglo 5518 
buy_online_agli 5556
buy_online_neit 5632
buy_online_dgli 5670
buy_online_dglo 5708

use_devices_for_deal_aglo 5508
use_devices_for_deal_agli 5546
use_devices_for_deal_neit 5622
use_devices_for_deal_dgli 5660
use_devices_for_deal_dglo 5698

hear_products_email_aglo 5525 
hear_products_email_agli 5563
hear_products_email_neit 5639
hear_products_email_dgli 5677
hear_products_email_dglo 5715

internet_chnge_shop_aglo 5495 
internet_chnge_shop_agli 5533
internet_chnge_shop_neit 5609
internet_chnge_shop_dgli 5647
internet_chnge_shop_dglo 5685

environ_friendly_aglo 4181 
environ_friendly_agli 4195
environ_friendly_neit 4223
environ_friendly_dgli 4237
environ_friendly_dglo 4251

recycle_prods_aglo 4190 
recycle_prods_agli 4204
recycle_prods_neit 4232
recycle_prods_dgli 4246
recycle_prods_dglo 4260

environ_good_business_aglo 4182
environ_good_business_agli 4196
environ_good_business_neit 4224
environ_good_business_dgli 4238
environ_good_business_dglo 4252

environ_personal_ob_aglo 4184
environ_personal_ob_agli 4198
environ_personal_ob_neit 4226
environ_personal_ob_dgli 4240
environ_personal_ob_dglo 4254

comp_help_cons_env_aglo 4183 
comp_help_cons_env_agli 4197
comp_help_cons_env_neit 4225
comp_help_cons_env_dgli 4239
comp_help_cons_env_dglo 4253

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
IF purchase_online_safe_dglo = 1 THEN purchase_online_safe = 1;                                                  
IF purchase_online_safe_dgli = 1 THEN purchase_online_safe = 2;                                             
IF purchase_online_safe_neit = 1 THEN purchase_online_safe = 3;                                                  
IF purchase_online_safe_agli = 1 THEN purchase_online_safe = 4;                                                  
IF purchase_online_safe_aglo = 1 THEN purchase_online_safe = 5;     

IF buy_online_dglo = 1 THEN buy_online = 1;                                                 
IF buy_online_dgli = 1 THEN buy_online = 2;                                                
IF buy_online_neit = 1 THEN buy_online = 3;    
IF buy_online_agli = 1 THEN buy_online = 4;                                                 
IF buy_online_aglo = 1 THEN buy_online = 5;

IF use_devices_for_deal_dglo = 1 THEN use_devices_for_deal = 1;                                                 
IF use_devices_for_deal_dgli = 1 THEN use_devices_for_deal = 2;                                                
IF use_devices_for_deal_neit = 1 THEN use_devices_for_deal = 3;    
IF use_devices_for_deal_agli = 1 THEN use_devices_for_deal = 4;                                                 
IF use_devices_for_deal_aglo = 1 THEN use_devices_for_deal = 5;

IF hear_products_email_dglo = 1 THEN hear_products_email = 1;                                                 
IF hear_products_email_dgli = 1 THEN hear_products_email = 2;                                                
IF hear_products_email_neit = 1 THEN hear_products_email = 3;    
IF hear_products_email_agli = 1 THEN hear_products_email = 4;                                                 
IF hear_products_email_aglo = 1 THEN hear_products_email = 5;

IF internet_chnge_shop_dglo = 1 THEN internet_chnge_shop = 1;                                                 
IF internet_chnge_shop_dgli = 1 THEN internet_chnge_shop = 2;                                                
IF internet_chnge_shop_neit = 1 THEN internet_chnge_shop = 3;    
IF internet_chnge_shop_agli = 1 THEN internet_chnge_shop = 4;                                                 
IF internet_chnge_shop_aglo = 1 THEN internet_chnge_shop = 5;

IF environ_friendly_dglo = 1 THEN environ_friendly = 1;                                                  
IF environ_friendly_dgli = 1 THEN environ_friendly = 2;                                             
IF environ_friendly_neit = 1 THEN environ_friendly = 3;                                                  
IF environ_friendly_agli = 1 THEN environ_friendly = 4;                                                  
IF environ_friendly_aglo = 1 THEN environ_friendly = 5;     

IF recycle_prods_dglo = 1 THEN recycle_prods = 1;                                                 
IF recycle_prods_dgli = 1 THEN recycle_prods = 2;                                                
IF recycle_prods_neit = 1 THEN recycle_prods = 3;    
IF recycle_prods_agli = 1 THEN recycle_prods = 4;                                                 
IF recycle_prods_aglo = 1 THEN recycle_prods = 5;

IF environ_good_business_dglo = 1 THEN environ_good_business = 1;                                                 
IF environ_good_business_dgli = 1 THEN environ_good_business = 2;                                                
IF environ_good_business_neit = 1 THEN environ_good_business = 3;    
IF environ_good_business_agli = 1 THEN environ_good_business = 4;                                                 
IF environ_good_business_aglo = 1 THEN environ_good_business = 5;

IF environ_personal_ob_dglo = 1 THEN environ_personal_ob = 1;                                                 
IF environ_personal_ob_dgli = 1 THEN environ_personal_ob = 2;                                                
IF environ_personal_ob_neit = 1 THEN environ_personal_ob = 3;    
IF environ_personal_ob_agli = 1 THEN environ_personal_ob = 4;                                                 
IF environ_personal_ob_aglo = 1 THEN environ_personal_ob = 5;

IF comp_help_cons_env_dglo = 1 THEN comp_help_cons_env = 1;                                                 
IF comp_help_cons_env_dgli = 1 THEN comp_help_cons_env = 2;                                                
IF comp_help_cons_env_neit = 1 THEN comp_help_cons_env = 3;    
IF comp_help_cons_env_agli = 1 THEN comp_help_cons_env = 4;                                                 
IF comp_help_cons_env_aglo = 1 THEN comp_help_cons_env = 5;

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

IF adidas_brand = .  THEN adidas = 0;
IF adidas_brand = 1 THEN adidas = 1;

FORMAT clothes_last_long_time buy_clothes_dont_need attractive_to_others disc_clothes_good dress_to_please_myself purchase_online_safe buy_online use_devices_for_deal hear_products_email internet_chnge_shop environ_friendly recycle_prods environ_good_business environ_personal_ob comp_help_cons_env myscale.
	   adidas yesno. ;

RUN;

PROC FACTOR DATA = myvars 
MAXITER=100
METHOD=principal
MINEIGEN=1
ROTATE=varimax
MSA
SCREE
SCORE
PRINT
NFACTORS=10
OUT=myscores;
VAR purchase_online_safe 
buy_online 
use_devices_for_deal 
hear_products_email 
internet_chnge_shop 
environ_friendly 
recycle_prods 
environ_good_business 
environ_personal_ob 
comp_help_cons_env;
RUN;
DATA myscores1;
SET myscores;
RENAME factor1 = onlineshopper;
RENAME factor2 = environconscious;
RENAME my_id = resp_id;
RUN;
PROC FASTCLUS DATA=myscores1 MAXITER=100 MAXCLUSTERS=3 OUT=finalclus;
VAR
onlineshopper
environconscious
clothes_last_long_time
buy_clothes_dont_need
attractive_to_others
disc_clothes_good
dress_to_please_myself;
RUN;
PROC FASTCLUS DATA=myscores1 MAXITER=100 MAXCLUSTERS=4 OUT=finalclus;
VAR
onlineshopper
environconscious
clothes_last_long_time
buy_clothes_dont_need
attractive_to_others
disc_clothes_good
dress_to_please_myself;
RUN;
PROC FASTCLUS DATA=myscores1 MAXITER=100 MAXCLUSTERS=5 OUT=finalclus;
VAR
onlineshopper
environconscious
clothes_last_long_time
buy_clothes_dont_need
attractive_to_others
disc_clothes_good
dress_to_please_myself;
RUN;
PROC FASTCLUS DATA=myscores1 MAXITER=100 MAXCLUSTERS=6 OUT=finalclus;
VAR
onlineshopper
environconscious
clothes_last_long_time
buy_clothes_dont_need
attractive_to_others
disc_clothes_good
dress_to_please_myself;
RUN;
PROC FASTCLUS DATA=myscores1 MAXITER=100 MAXCLUSTERS=7 OUT=finalclus;
VAR
onlineshopper
environconscious
clothes_last_long_time
buy_clothes_dont_need
attractive_to_others
disc_clothes_good
dress_to_please_myself;
RUN;
PROC FASTCLUS DATA=myscores1 MAXITER=100 MAXCLUSTERS=8 OUT=finalclus;
VAR
onlineshopper
environconscious
clothes_last_long_time
buy_clothes_dont_need
attractive_to_others
disc_clothes_good
dress_to_please_myself;
RUN;