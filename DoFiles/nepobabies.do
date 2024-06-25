* Direct file path
cd "C:\Users\rpseely\OneDrive - Syracuse University\Documents\GitHub\exercises\course-project-nepobabies\Data\Last.Step.Data"


* Direct Stata to use the cleaned GSS dataset
use "GSSclean_noRDs"

cd "C:\Users\rpseely\Downloads"
use "gss7222_r1.dta"

cd "C:\Users\rpseely\Downloads\GSS_stata\GSS_stata_unzipd"
use "gss7222_r3a.dta"



** This prevents false positives from occurring for the nepobaby, panepobaby, and manepobaby variables.
replace indus10 = 1 if missing(indus10)

** Creating dummy variable for nepobaby = 1 if respondent is in the same industry as their mother or father, 0 otherwise
gen nepobaby = ((indus10 == paind10)|(indus10 == maind10))
** Create variable for being in the same industry as ONLY a respondent's father. (same false positives as nepobaby)
gen panepobaby = (indus10 == paind10)
** Create variable for being in the same industry as ONLY a respondent's mother. (same false positives as nepobaby)
gen manepobaby = (indus10 == maind10)

** Getting rid of missing data
** dateintv variable needed to determine hire date.
drop if missing(dateintv)
** We can only perform analysis for the respondents who answered the `yearsjob` question.
drop if missing(yearsjob)
** Dropping observations for age not recorded - cannot accurately measure agehire without age.
drop if missing(age)
* dropping because the 2022 survey year does not include necessary variables for defining a variable.
drop if year== 2022

* Convert dateintv to a string for easier manipulation
gen dateintv_str = string(dateintv)

* Extract dayintv (last two digits)
gen dayintv = real(substr(dateintv_str, -2, .))

* Extract monthintv based on the length of dateintv
gen monthintv = .
replace monthintv = real(substr(dateintv_str, 1, 1)) if length(dateintv_str) == 3
replace monthintv = real(substr(dateintv_str, 1, 2)) if length(dateintv_str) == 4

* Renaming year variable for clarity. It should be made clear that the year variable attached to observations denotes the year they were interviewed, not the year they were hired.
rename year yearintv

** This created a variable for the year and month a respondent was interviewed!
** It does so in the format of a Stata date, where Jan. 1960 is considered 1 and every month's code after that = (months after Jan. 1960)
gen ymintdate = ym(yearintv, monthintv)

** Creates a variable for the month and year a respondent was hired (assuming they were hired exactly the number of years ago they reported) which leaves us with 9,256 variables/.
gen ymhiredate = ymintdate - (yearsjob * 12)

* For ease of merging FRED data
sort ymhiredate

* Merging FRED unemployment rate based on ymhiredate variable
merge m:m ymhiredate using "C:\Users\rpseely\OneDrive - Syracuse University\Documents\GitHub\exercises\course-project-nepobabies\Data\Last.Step.Data\FRED_unrate_60to22_robust"
**** THIS NEEDS TO BE FIXED, LIKE ALTER THE DATASET SO THAT IT IS JUST ymhiredate AND DOES NOT INCLUDE ymhiredate_m3, etc.

* dropping the few observations that failed to merge data
 drop if _merge == 1
 drop if _merge == 2

 * Renaming the variable to match from the FRED data
rename UNRATE unemployrate
 
* Creating variable for age at time of hiring, i.e. age at ymhiredate
gen agehire = age - yearsjob


* Performing a test of association between being a nepobaby and being hired young

* Creating and defining the variable for being hired young
gen hireyoung = .

replace hireyoung = 1 if (agehire > 30)

replace hireyoung = 2 if (age hire <= 30)

replace hireyoung = . if ((paind10 == .i) | (maind10 == .i))

* Using a chi-square test to determine the relationship between being hired young and being a nepobaby
tab hireyoung nepobaby, chi2
* Significant association

* Using a logistic regression model to determine if age of hire is a significant predictor of nepotism status
logit nepobaby agehire, or
* Significant association
* Odds ratio = 0.9676843 , so 3.3% decrease in likelihood of being a nepobaby associated with being hired each year older.

* Keeping observations only of target group; people hired as young adults
drop if agehire > 29
* Leaves us with 2,852 observations




** Chi square test of all groups of unemployment

* Creating variable for unemployment level hire group and defining it based on quartiles of unemployment rates
gen unemployrate_groups = .

replace unemployrate_groups = 1 if unemployrate <= 4.7

replace unemployrate_groups = 2 if (unemployrate > 4.7) & (unemployrate <= 5.5)

replace unemployrate_groups = 3 if (unemployrate > 5.5) & (unemployrate < 6.8)

replace unemployrate_groups = 4 if unemployrate >= 6.8

* Cross-tabulation & chi-square test of the four groups of hiring in terms of unemployment
tabulate nepobaby unemployrate_groups, chi2
* No significant association




*** START OF SENSITIVTY ANALYSIS (SA)


* SA FOR MINUS 3
drop ymhiredate_m3
gen ymhiredate_m3 = ymhiredate

drop _merge

merge m:m ymhiredate_m3 using "C:\Users\rpseely\OneDrive - Syracuse University\Documents\GitHub\exercises\course-project-nepobabies\Data\Last.Step.Data\minus3.dta"

drop if _merge == 1
drop if _merge == 2


** Chi square test of all groups of unemployment (ymhiredate of 3 months earlier)
gen unemployrate_groups_m3 = .

replace unemployrate_groups_m3 = 1 if unemployrate_m3 <= 4.7

replace unemployrate_groups_m3 = 2 if (unemployrate_m3 > 4.7) & (unemployrate_m3 <= 5.5)

replace unemployrate_groups_m3 = 3 if (unemployrate_m3 > 5.5) & (unemployrate_m3 < 6.8)

replace unemployrate_groups_m3 = 4 if unemployrate_m3 >= 6.8

replace unemployrate_groups_m3 = . if yearsjob < 1

* Cross-tabulation & chi-square test of the four groups of hiring in terms of unemployment
tabulate nepobaby unemployrate_groups_m3, chi
* It gives us a p-value of 0.332




* SA FOR MINUS 6
drop ymhiredate_m6

gen ymhiredate_m6 = ymhiredate

drop _merge

merge m:m ymhiredate_m6 using "C:\Users\rpseely\OneDrive - Syracuse University\Documents\GitHub\exercises\course-project-nepobabies\Data\Last.Step.Data\minus6.dta"

drop if _merge == 1
drop if _merge == 2


** Chi square test of all groups of unemployment (ymhiredate of 6 months earlier)
gen unemployrate_groups_m6 = .

replace unemployrate_groups_m6 = 1 if unemployrate_m6 <= 4.7

replace unemployrate_groups_m6 = 2 if (unemployrate_m6 > 4.7) & (unemployrate_m6 <= 5.5)

replace unemployrate_groups_m6 = 3 if (unemployrate_m6 > 5.5) & (unemployrate_m6 < 6.8)

replace unemployrate_groups_m6 = 4 if unemployrate_m6 >= 6.8

replace unemployrate_groups_m6 = . if yearsjob < 1

* Cross-tabulation & chi-square test of the four groups of hiring in terms of unemployment
tabulate nepobaby unemployrate_groups_m6, chi
*  p-value of 0.205









* SA FOR PLUS 3
drop ymhiredate_p3

gen ymhiredate_p3 = ymhiredate

drop _merge

merge m:m ymhiredate_p3 using "C:\Users\rpseely\OneDrive - Syracuse University\Documents\GitHub\exercises\course-project-nepobabies\Data\Last.Step.Data\plus3.dta"

drop if _merge == 1
drop if _merge == 2


** Chi square test of all groups of unemployment (ymhiredate of 6 months earlier)
gen unemployrate_groups_p3 = .

replace unemployrate_groups_p3 = 1 if unemployrate_p3 <= 4.7

replace unemployrate_groups_p3 = 2 if (unemployrate_p3 > 4.7) & (unemployrate_p3 <= 5.5)

replace unemployrate_groups_p3 = 3 if (unemployrate_p3 > 5.5) & (unemployrate_p3 < 6.8)

replace unemployrate_groups_p3 = 4 if unemployrate_p3 >= 6.8

replace unemployrate_groups_p3 = . if yearsjob < 1

* Cross-tabulation & chi-square test of the four groups of hiring in terms of unemployment
tabulate nepobaby unemployrate_groups_p3, chi
* p-value of 0.527








* SA FOR PLUS 6
drop ymhiredate_p6

gen ymhiredate_p6 = ymhiredate

drop _merge

merge m:m ymhiredate_p6 using "C:\Users\rpseely\OneDrive - Syracuse University\Documents\GitHub\exercises\course-project-nepobabies\Data\Last.Step.Data\plus6.dta"

drop if _merge == 1
drop if _merge == 2


** Chi square test of all groups of unemployment (ymhiredate of 6 months earlier)
gen unemployrate_groups_p6 = .

replace unemployrate_groups_p6 = 1 if unemployrate_p6 <= 4.7

replace unemployrate_groups_p6 = 2 if (unemployrate_p6 > 4.7) & (unemployrate_p6 <= 5.5)

replace unemployrate_groups_p6 = 3 if (unemployrate_p6 > 5.5) & (unemployrate_p6 < 6.8)

replace unemployrate_groups_p6 = 4 if unemployrate_p6 >= 6.8

replace unemployrate_groups_p6 = . if yearsjob < 1

* Cross-tabulation & chi-square test of the four groups of hiring in terms of unemployment
tabulate nepobaby unemployrate_groups_p6, chi2
* p-value of 0.163








* Testing the correlation between the nepotism ratio (ratio of nepobabies to all workers) and the unemployment rate

* Creating the nepotism ratio variable, which is the ratio of nepobabies to all workers at each unemployment rate
egen nepobaby_1 = total(nepobaby == 1), by(unemployrate)
egen nepobaby_0 = total(nepobaby == 0 | nepobaby == 1), by(unemployrate)
gen nepobaby_ratio = nepobaby_1 / nepobaby_0


* Correlation between nepobaby : all workers ratio and the unemployment rate
pwcorr nepobaby_ratio unemployrate, sig
* weak but significant relationship (0.0979 correlation)

*Showing the realtionship graphically with a scatter plot and best-fit line
twoway (scatter nepobaby_ratio unemployrate, legend(label(1 "Ratio of Nepobabies to All Workers"))) ///
       (lfit nepobaby_ratio unemployrate, legend(label(2 "Fit Line"))), ///
       ytitle("Nepotism Ratio") xtitle("Unemployment Rate") 
	   
	   
* Using a logistic regression to determine if the unemployment rate is a significant predictor of nepotism status.
logistic nepobaby unemployrate
* p-value = 0.408









* Creating variables for the ratios of nepobabies to all workers at each unemployment level as defined in the chi-square test. This code will be used to create a graphic that pairs with the chi-square analysis. This section ends with the "graph bar" command

* Defining the ratios for each unemployment level and their defining unemployment rates
gen nepo_lowu = .
replace nepo_lowu = 1 if unemployrate <= 4.7 & nepobaby == 1
replace nepo_lowu = 0 if unemployrate <= 4.7 & nepobaby == 0


gen nepo_midlu = .
replace nepo_midlu = 1 if (unemployrate > 4.7) & (unemployrate <= 5.5) & nepobaby == 1
replace nepo_midlu = 0 if (unemployrate > 4.7) & (unemployrate <= 5.5) & nepobaby == 0

gen nepo_midhu = .
replace nepo_midhu = 1 if (unemployrate > 5.5) & (unemployrate < 6.8) & nepobaby == 1
replace nepo_midhu = 0 if (unemployrate > 5.5) & (unemployrate < 6.8) & nepobaby == 0

gen nepo_highu = .
replace nepo_highu = 1 if unemployrate >= 6.8 & nepobaby == 1
replace nepo_highu = 0 if unemployrate >= 6.8 & nepobaby == 0

gen allhire_highu = (unemployrate >= 6.8)

gen allhire_lowu = (unemployrate <= 4.7)

gen allhire_midlu = (unemployrate > 4.7) & (unemployrate <= 5.5)

gen allhire_midhu = (unemployrate > 5.5) & (unemployrate < 6.8)


* Calculate the number of observations where nepo_highu = 1
egen nepo_highu_1 = total(nepo_highu == 1)

* Calculate the number of observations where allhire_highu = 1
egen allhire_highu_1 = total(allhire_highu == 1)

* Calculate the ratio
gen ratio_high = nepo_highu_1 / allhire_highu_1

* To view the ratio of nepobabies hired in high unemployment to all workers hired in high unemployment
tab ratio_high
* With four groups the ratio is 0.1125



* Calculate the number of observations where nepo_lowu = 1
egen nepo_lowu_1 = total(nepo_lowu == 1)

* Calculate the number of observations where allhire_lowu = 1
egen allhire_lowu_1 = total(allhire_lowu == 1)

* Calculate the ratio
gen ratio_low = nepo_lowu_1 / allhire_lowu_1

* To view the ratio of nepobabies hired in low unemployment to all workers hired in low unemployment
tab ratio_low
* Four groups ratio is now 0.0879802


* Calculate the number of observations where nepo_midu = 1
egen nepo_midhu_1 = total(nepo_midhu == 1)

* Calculate the number of observations where allhire_midu = 1
egen allhire_midhu_1 = total(allhire_midhu == 1)

* Calculate the ratio
gen ratio_midh = nepo_midhu_1 / allhire_midhu_1

* To view the ratio of nepobabies hired in "middle-high" unemployment to all workers hired in "middle-high" unemployment
tab ratio_midh
* Ratio is 0.1027607


* Calculate the number of observations where nepo_midu = 1
egen nepo_midlu_1 = total(nepo_midlu == 1)

* Calculate the number of observations where allhire_midu = 1
egen allhire_midlu_1 = total(allhire_midlu == 1)

* Calculate the ratio
gen ratio_midl = nepo_midlu_1 / allhire_midlu_1

* To view the ratio of nepobabies hired in "middle-low" unemployment to all workers hired in "middle-low" unemployment
tab ratio_midl
* Ratio is 0.101949


*To graphically view the relationships of all the ratios
 graph bar (mean) ratio_high (mean) ratio_midh (mean) ratio_midl (mean) ratio_low, blabel(bar) ytitle("Nepobaby Ratio") legend(order(1 "high unemployment" 2 "mid-high unemployment" 3 "mid-low unemployment" 4 "low unemployment"))



* TESTING NEPOBABY DEMOGRAPHICS
 

 
* Testing to see how nepobaby rates change with gender of parent and child


* Chi-square test for the association between gender of respondent and gender of a parent 

gen neposex = 1 if sex == 1
replace neposex = 2 if sex == 2
replace neposex = . if nepobaby == 0
gen nepoparentsex = 1 if (indus10 == paind10)
replace nepoparentsex = 2 if (indus10 == maind10)
replace nepoparentsex = . if (indus10 != paind10 & indus10 != maind10)
replace nepoparentsex = . if (paind10 == maind10)

tab neposex nepoparentsex, chi2
* Very strong result with a p-value of 0.000


* Creating a stacked bar graph to represent this relationship
gen nepodad = 1 if indus10 == paind10
replace nepodad = . if nepobaby == 0
replace nepodad = . if (paind10 == maind10)
gen nepomom = 1 if indus10 == maind10
replace nepomom = . if nepobaby == 0
replace nepomom = . if (paind10 == maind10)
tab nepodad
tab nepomom

gen neposex_label = ""
replace neposex_label = "Male Nepobaby" if sex == 1
replace neposex_label = "Female Nepobaby" if sex == 2

graph bar (count) nepodad nepomom, over(neposex_label) ///
    stack ///
    legend(label(1 "Nepotistic Father") label(2 "Nepotistic Mother")) ///
	ytitle("Nepobaby Count")


* RACE
tab nepobaby race, chi2
* p-value = 0.210 so this yields an insignificant result


* GENDER
tab nepobaby sex, chi2
* p-value = 0.124, so no strong association


* CLASS (self-reported)


* Creating a chi-square test for nepobaby and class
tab nepobaby class, chi2
* This yields an insignifcant result


* EDUCATION 

* Creating a two-sample t-test for average education of nepobabies and non-nepobabies

gen educ_notnepo = educ
replace educ_notnepo = . if nepobaby == 1

gen educ_nepo = educ
replace educ_nepo = . if nepobaby == 0

ttest educ_nepo == educ_notnepo, unpaired
* insignificant result

* Chi-square test for years of education and nepotism status
tab educ nepobaby, chi2
* Not conventional at significant levels but close


* HOURS WORKED WEEKLY (self-reported)

* Two-sample t-test for hours worked
gen samplehrs = hrs1
replace samplehrs = . if nepobaby == 1

gen nepohrs = hrs1
replace nepohrs = . if nepobaby != 1

ttest nepohrs == samplehrs, unpaired
* This yields an insignificant difference between the two, p = 0.7003 (for nepobabies working more hours) and p = 0.2997 (for nepobabies working fewer hours)



* INCOME
* Income variable: `realinc` is family income in base year 1986



* Two-sample t-test for nepobaby status vs. average income

gen sample_inc = realinc
replace sample_inc = . if nepobaby == 1

gen nepoinc = realinc
replace nepoinc = . if nepobaby != 1

ttest sample_inc == nepoinc, unpaired
* Yields a p-value of 0.0866 (for nepobabies having higher family income), so close to but insiginificant at conventional levels



* JOB SAFETY

* Creating variable for high income nepobabies (make greater than or equal to the 90th percentile of income: 66220)

* Creating chi-square test for nepobaby and job safety
tab nepobaby joblose, chi2
* This yielded a significant result with a p-value of 0.042

* Creating bar graph to represent this test
* Setting up variables to be used in bar graph
gen nepo_safe = (nepobaby == 1 & joblose == 4)

replace nepo_safe = . if nepobaby == 0
replace nepo_safe = . if missing(joblose)

gen sample_safe = (joblose == 4)
replace sample_safe = . if missing(joblose)

graph bar (mean) sample_safe (mean) nepo_safe, title(`"Job Safety for Nepobabies and Sample"')

