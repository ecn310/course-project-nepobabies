cd "C:\Users\rpseely\OneDrive - Syracuse University\Documents\GitHub\exercises\course-project-nepobabies"

use "GSSclean_noRDs" 
 
***Keeping only the variables we want to examine
keep year rincome age dateintv educ paeduc maeduc jobinc jobsec jobpay ///
jobkeep jobhonor jobinter fndjob2 thisjob7 wrkwell paind16 paind10 paind80 ///
maind80 maind10 indus10 major1 major2 voedcol voedncol colmajr1 colmajr2 ///
joblose yearsjob covemply race parborn granborn wealth opwlth income72 ///
income77 income82 income86 income91 income98 income06 income16 coninc realinc ///
povline incdef wlthpov progtax oprich inequal3 taxrich taxshare contrich ///
class class1 hrs1 hrs2 jobhour hrswork workhr sethours sex intltest ///
skiltest wojobyrs occmobil lastslf gender1 gender2 gender3 gender4 gender5 ///
gender6 gender7 gender8 gender9 gender10 gender11 gender12 gender13 gender14 ///
gdjobsec thisjob2

save "GSSclean_noRDs.dta" , replace

** This prevents false positives from occurring for the nepobaby, panepobaby, and manepobaby variables.
replace indus10 = 1 if missing(indus10)

**Creating dummy variable for nepobaby = 1 if respondent is in the same industry as their mother or father, 0 otherwise
gen nepobaby = ((indus10 == paind10)|(indus10 == maind10))
** Create variable for being in the same industry as ONLY a respondent's father. (same false positives as nepobaby)
gen panepobaby = (indus10 == paind10)
** Create variable for being in the same industry as ONLY a respondent's mother. (same false positives as nepobaby)
gen manepobaby = (indus10 == maind10)

**Getting rid of missing data
drop if year < 1975
drop if missing(dateintv)
** We can only perform analysis for the respondents who answered the `yearsjob` question.
drop if missing(yearsjob)
*Dropping observations for age not recorded - cannot accurately measure agehire without age.
drop if missing(age)

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

** Run the do-file that inputs unemployment rates by month.
** This must be corrected to the line: do urate_input.do. For some reason it only works when I have it like this.
do "urate_input"

"C:\Users\rpseely\OneDrive - Syracuse University\Documents\GitHub\course-project-nepobabies\urate_input.do"

*Creating variable for age when getting job, i.e. age at ymhiredate
gen agehire = age - yearsjob

* Keeping observations only of target group; young adults
drop if agehire > 29


* We create two groups of nepobabies to test the difference in means for differently competitive labor markets.
* The unemployment rates we chose to be considered high and low are first and third quartiles of the unemployment rates over the period of time we look at from 1987-2022
* We choose to cut out the middle 50% of the observations because we found that it was very noisy. We would change the unemployment rate we found to significant by 0.5 percentage points and get an entirely different result on the t-test.
* Creating variable for nepobabies hired during high unemployment (third quartile)
gen nepo_highu = (nepobaby == 1 & unemployrate >= 6.625)
* Creating variable for nepobabies hired during low unemployment (first quartile)
gen nepo_lowu = (nepobaby == 1 & unemployrate <= 4.8)
*Creating a variable for nepobabies hired between the first and third quartile of all monthly unemployment rates.
gen nepo_midu = (nepobaby == 1) & (unemployrate > 4.8) & (unemployrate < 6.625)

* Making the t-test only for nepobabies, not the whole sample, so that the means are more representative of the nepobaby population
replace nepo_highu = . if nepobaby == 0
replace nepo_lowu = . if nepobaby == 0
replace nepo_midu = . if nepobaby == 0

* Testing the difference of means between the two 
ttest nepo_highu == nepo_lowu

* Visual of the difference in means
graph bar (mean) nepo_highu (mean) nepo_lowu, title(`"Nepobabies in High vs. Low Unemployment"')

** T-test does not really work because it does not measure what it intends to measure
ttest nepo_highu == nepo_midu
ttest nepo_midu == nepo_lowu


* Testing at different unemployment rate cutoff: top quartile vs. bottom three quartiles of unemployment rates

gen nepo_high25u = (nepobaby == 1 & unemployrate >= 6.625)

gen nepo_low75u = (nepobaby == 1 & unemployrate < 6.625)

replace nepo_high25u = . if nepobaby == 0

replace nepo_low75u = . if nepobaby == 0

ttest nepo_high25u == nepo_low75u
* This does not really make sense because of course there will be more nepobabies in 75% of the monthly unemployment rates. Not really testing what it is intended to because there is nothing that holds the two groups constant.


** Chi square test of all groups of unemployment
gen unemployrate_groups = .

replace unemployrate_groups = 1 if unemployrate <= 4.8

replace unemployrate_groups = 2 if (unemployrate > 4.8) & (unemployrate < 6.625)

replace unemployrate_groups = 3 if unemployrate >= 6.625

* Cross-tabulation & chi-square test of the three groups of hiring in terms of unemployment
tabulate nepobaby unemployrate_groups, chi2

gen highu_ratio = nepo_highu / allhire_highu




*Put this line of code at the beginning
ssc install ciplot
 
* Creates a plot with the confidence intervals of nepo_highu and nepo_lowu. Should edit this to include bars.
ciplot nepo_highu nepo_lowu

** The blocked out section below includes my numerous attempts to create a bar graph including confidence interval lines
/*

*Creating confidence interval variables for the ciplot
ci proportion (nepo_highu)
gen lci_nhu = r(lb)
gen uci_nhu = r(ub)

ci proportion (nepo_lowu)
gen lci_nlu = r(lb)
gen uci_nlu = r(ub)

list nepo_highu lci_nhu uci_nhu nepo_lowu lci_nlu uci_nhu in 1/10

twoway (bar mean(nepo_highu) nepo_highu) (rcap lci_nhu uci_nhu nepo_highu, color(blue)), ///
       (bar mean(nepo_lowu) nepo_lowu) (rcap lci_nlu uci_nlu nepo_lowu, color(red)), ///
       legend(order(1 "Variable 1" 2 "Variable 2"))
	 
	 
twoway (bar mean(nepo_highu) nepo_highu, barwidth(0.4)) ///
       (rcap lci_nhu uci_nhu nepo_highu, color(blue)), ///
       (bar mean(nepo_lowu) nepo_lowu, barwidth(0.4)) ///
       (rcap lci_nlu uci_nlu nepo_lowu, color(red)), ///
       legend(order(1 "Variable 1" 2 "Variable 2"))
	   
egen mean_nhu = mean(nepo_highu)
egen mean_nlu = mean(nepo_lowu)

ci mean nepo_highu
ci mean nepo_lowu

graph bar (mean) nepo_highu nepo_lowu, /// 
	bar(1, asyvars) ///
    ytitle("Proportion of Observations Equal to 1") ///
    title("Proportions with Confidence Intervals")
	
graph twoway (bar nepo_highu nepo_lowu) (rcap nepo_highu lci_nhu uci_nhu) (rcap nepo_lowu lci_nlu uci_nlu), ///
    legend(label(1 "Variable 1") label(2 "Variable 2")) ///
    ytitle("Proportion of Observations Equal to 1") ///
    title("Proportions with Confidence Intervals")

	  
	  
	  
* attempt to create ciplot w conf. int.
graph bar (mean) nepo_highu nepo_lowu, bargap(20) ///
    rcap(mean - r(se), mean + r(se)) ///
    legend(order(1 "Variable 1" 2 "Variable 2"))
	
*/


* Examining the ratio of nepobabies and all people hired during times of low and high unemployment
gen allhire_highu = (unemployrate >= 6.625)

replace allhire_highu = . if nepobaby == 1

gen allhire_lowu = (unemployrate <= 4.8)

replace allhire_lowu = . if nepobaby == 1

gen allhire_midu = (unemployrate > 4.8) & (unemployrate < 6.625)

replace allhire_midu = . if nepobaby == 1

* Calculate the number of observations where nepo_highu = 1
egen nepo_highu_1 = total(nepo_highu == 1)

* Calculate the number of observations where allhire_highu = 1
egen allhire_highu_1 = total(allhire_highu == 1)

* Calculate the ratio
gen ratio_high = nepo_highu_1 / allhire_highu_1

* To view the ratio of nepobabies hired in high unemployment to non-nepobabies hired in high unemployment
tab ratio_high
* The ratio = 0.0987


* Calculate the number of observations where nepo_lowu = 1
egen nepo_lowu_1 = total(nepo_lowu == 1)

* Calculate the number of observations where allhire_lowu = 1
egen allhire_lowu_1 = total(allhire_lowu == 1)

* Calculate the ratio
gen ratio_low = nepo_lowu_1 / allhire_lowu_1

* To view the ratio of nepobabies hired in low unemployment to non-nepobabies hired in low unemployment
tab ratio_low
* The ratio = 0.0607


* Calculate the number of observations where nepo_midu = 1
egen nepo_midu_1 = total(nepo_midu == 1)

* Calculate the number of observations where allhire_midu = 1
egen allhire_midu_1 = total(allhire_midu == 1)

* Calculate the ratio
gen ratio_mid = nepo_midu_1 / allhire_midu_1

* To view the ratio of nepobabies hired in "middle" unemployment to non-nepobabies hired in "middle" unemployment
tab ratio_mid
* The ratio = 0.0914

*To graphically view the relationships of all the ratios
graph bar (mean) ratio_high (mean) ratio_mid (mean) ratio_low, blabel(bar) ytitle(Ratio of Nepobabies to Non-Nepobabies) title(Nepotism Hiring in Different Labor Markets) legend(order(1 "high unemployment hire" 2 "median unemployment hire" 3 "low unemployment hire"))


** The following commands create the frequency table showing the amounts of observations of nepobabies and non-nepobabies hired during different unemployment rates.
gen hire_urate = .

replace hire_urate = 1 if (unemployrate <= 4.8)

replace hire_urate = 2 if (unemployrate > 4.8) & (unemployrate < 6.625)

replace hire_urate = 3 if (unemployrate >= 6.625)

tab hire_urate nepobaby


* Testing to see how nepobaby rates change with gender of parent and child

** Nepobaby by FATHER

*Creating variable for male nepobabies with the same industry as their father.
gen malenepopa = (panepobaby == 1 & sex == 1)

*Creating variable for female nepobabies with the same industry as their father.
gen femalenepopa = (panepobaby == 1 & sex ==2)

*Marking irrelevant datapoints as missing
replace malenepopa = . if panepobaby == 0
replace femalenepopa = . if panepobaby == 0

*Removing instances of respondents having the same industry as both their mother and father.
replace malenepopa = . if (maind10 == paind10)
replace femalenepopa = . if (maind10 == paind10)

*Testing the significance in the differences between the proportion of male and female nepobabies with the same industry as their father.
ttest femalenepopa == malenepopa

* Creating bar graph to visualize the t-test
graph bar (mean) malenepopa (mean) femalenepopa, title(`"Male vs. Female Nepobabies - Father"')


** Nepobaby by MOTHER

*Creating variable for male nepobabies with the same industry as their mother.
gen malenepoma = (manepobaby == 1 & sex == 1)
*Creating variable for female nepobabies with the same industry as their father.
gen femalenepoma = (manepobaby == 1 & sex ==2)

*Marking irrelevant datapoints as missing
replace malenepoma = . if manepobaby == 0
replace femalenepoma = . if manepobaby == 0

*Removing instances of respondents having the same industry as both their mother and father.
replace malenepoma = . if (maind10 == paind10)
replace femalenepoma = . if (maind10 == paind10)

*Testing the significance in the differences between the proportion of male and female nepobabies with the same industry as their mother.
ttest femalenepoma == malenepoma

* Creating bar graph to visualize the t-test
graph bar (mean) malenepoma (mean) femalenepoma, title(`"Male vs. Female Nepobabies - Mother"')


 * Sensitivity analysis: minus 3 months
 * Creating a variable that brings the ymhiredate back 3 months
 gen hiredate_minus_3m = ymhiredate - 3
 
 * Creating a variable that gives us the unemployment rate from three months ago.
gen urate_minus3m = .
replace urate_minus3m = unemployrate  ymhiredate == hiredate_minus_3

* Looking at the demographics of nepobabies in high unemployment

* RACE
* Creating variable for white nepobabies (white is equal to 1)
gen nepo_white = (nepobaby == 1 & race == 1)

* Labeling irrelevant data as missing to avoid noise/confusion
replace nepo_white = . if nepobaby == 0

* Creating a variable for the proportion of white people surveyed
gen sample_white = (race == 1)

* Comparing the means of white people in the whole sample vs. white nepobabies
ttest sample_white == nepo_white, unpaired

graph bar (mean) sample_white (mean) nepo_white, title(`"Race for Nepobabies vs Sample"')

* GENDER
* Creating variable for male nepobabies
gen nepo_male = (nepobaby == 1 & sex == 1)

* Labeling irrelevant data as missing to avoid noise/confusion
replace nepo_male = . if nepobaby == 0

* Creating a variable for the sample of males surveyed
gen sample_male = (sex == 1)

* Comparing the means of males in the whole sample vs. male nepobabies
ttest sample_male == nepo_male, unpaired

graph bar (mean) sample_male (mean) nepo_male

* CLASS (self-reported)
* Creating variable for middle and upper class nepobabies
gen nepo_midup = (nepobaby == 1 & class >= 3)

* Labeling irrelevant data as missing to avoid noise/confusion
replace nepo_midup = . if nepobaby == 0

* Creating a variable for the sample of middle and upper class people surveyed
gen sample_midup = (class >= 3)

* Comparing the means of middle/upper class people in the whole sample vs. middle/upper class nepobabies
ttest sample_midup == nepo_midup, unpaired

* EDUCATION
* Creating variable for college educated nepobabies
gen nepo_educ = (nepobaby == 1 & educ >= 16)

* Labeling irrelevant data as missing to avoid noise/confusion
replace nepo_educ = . if nepobaby == 0

* Creating a variable for the sample of college educated people surveyed
gen sample_educ = (educ >= 16)

* Comparing the means of college educating people in the whole sample vs. college educated nepobabies
ttest sample_educ == nepo_educ, unpaired

* HOURS WORKED WEEKLY (self-reported)
* Creating variable for nepobabies who work overtime
gen nepo_hrs = (nepobaby == 1 & hrs1 >= 45)

* Labeling irrelevant data as missing to avoid noise/confusion
replace nepo_hrs = . if nepobaby == 0

* Creating a variable for the sample of people surveyed who work overtime
gen sample_hrs = (hrs1 >= 45)

* Comparing the means of overtime workers in the whole sample vs. overtime working nepobabies
ttest sample_hrs == nepo_hrs, unpaired

* INCOME
* Income variable: `realinc` is family income in base year 1986

* Creating variable for high income nepobabies (make greater than or equal to the 90th percentile of income: 66220)
gen nepo_hinc = (nepobaby == 1 & realinc >= 66220)

* Labeling irrelevant data as missing to avoid noise/confusion
replace nepo_hinc = . if nepobaby == 0

* Creating a variable for the proportion of males surveyed
gen sample_hinc = (realinc >= 66220)

* Comparing the means of males in the whole sample vs. male nepobabies
ttest sample_hinc == nepo_hinc, unpaired


* Creating variable for low income nepobabies (make greater than or equal to the 90th percentile of income: 66220)
gen nepo_linc = (nepobaby == 1 & realinc <= 14860.38)

* Labeling irrelevant data as missing to avoid noise/confusion
replace nepo_linc = . if nepobaby == 0

* Creating a variable for the proportion of males surveyed
gen sample_linc = (realinc <= 14860.38)

* Comparing the means of males in the whole sample vs. male nepobabies
ttest sample_linc == nepo_linc, unpaired

* JOB SAFETY

* Creating variable for high income nepobabies (make greater than or equal to the 90th percentile of income: 66220)
gen nepo_safe = (nepobaby == 1 & joblose == 4)

* Labeling irrelevant data as missing to avoid noise/confusion
replace nepo_safe = . if nepobaby == 0
replace nepo_safe = . if missing(joblose)

* Creating a variable for the proportion of males surveyed
gen sample_safe = (joblose == 4)
replace sample_safe = . if missing(joblose)

* Comparing the means of males in the whole sample vs. male nepobabies
ttest sample_safe == nepo_safe, unpaired

* Creating bar graph for this t-test
graph bar (mean) sample_safe (mean) nepo_safe, title(`"Job Safety for Nepobabies and Sample"')
