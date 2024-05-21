* Direct file path
cd "C:\Users\rpseely\OneDrive - Syracuse University\Documents\GitHub\exercises\course-project-nepobabies"

* Direct Stata to use the cleaned GSS dataset
use "GSSclean_noRDs"

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
merge m:m ymhiredate using "C:\Users\rpseely\OneDrive - Syracuse University\Documents\GitHub\exercises\course-project-nepobabies\FRED_unrate_60to22_robust.dta"
**** THIS NEEDS TO BE FIXED, LIKE ALTER THE DATASET SO THAT IT IS JUST ymhiredate AND DOES NOT INCLUDE ymhiredate_m3, etc.

* dropping the few observations that failed to merge data
 drop if _merge == 1
 drop if _merge == 2

rename UNRATE unemployrate
 
* Creating variable for age at time of hiring, i.e. age at ymhiredate
gen agehire = age - yearsjob


* Association between being a nepobaby and hired young
gen hireyoung = .

replace hireyoung = 1 if (agehire > 30)

replace hireyoung = 2 if (age hire <= 30)

replace hireyoung = . if ((paind10 == .i) | (maind10 == .i))

tab hireyoung nepobaby, chi2
* Significant association

logit nepobaby agehire, or
* Significant association
* Should probably move this to data section, or keep it at the top to say this is why we focus on young adults.
* Odds ratio = 0.9676843 , so 3.3% decrease in likelihood of being a nepobaby associated with being hired each year older.
* need to run this again without 2022 data

* Keeping observations only of target group; people hired as young adults
drop if agehire > 29
* Leaves us with 2,852 observations




** Chi square test of all groups of unemployment
gen unemployrate_groups = .

replace unemployrate_groups = 1 if unemployrate <= 4.7

replace unemployrate_groups = 2 if (unemployrate > 4.7) & (unemployrate <= 5.5)

replace unemployrate_groups = 3 if (unemployrate > 5.5) & (unemployrate < 6.8)

replace unemployrate_groups = 4 if unemployrate >= 6.8

* Cross-tabulation & chi-square test of the three groups of hiring in terms of unemployment
tabulate nepobaby unemployrate_groups, chi2
* Updated unemployrate values for no 2022 data.



*** START OF SENSITIVTY ANALYSIS ... CURRENT CODE IS A PLACE FILLER ***


* SA FOR MINUS 3
drop ymhiredate_m3
gen ymhiredate_m3 = ymhiredate

drop _merge

merge m:m ymhiredate_m3 using "C:\Users\rpseely\OneDrive - Syracuse University\Documents\GitHub\exercises\course-project-nepobabies\minus3.dta"

drop if _merge == 1
drop if _merge == 2


** Chi square test of all groups of unemployment (ymhiredate of 3 months earlier)
gen unemployrate_groups_m3 = .

replace unemployrate_groups_m3 = 1 if unemployrate_m3 <= 4.7

replace unemployrate_groups_m3 = 2 if (unemployrate_m3 > 4.7) & (unemployrate_m3 <= 5.5)

replace unemployrate_groups_m3 = 3 if (unemployrate_m3 > 5.5) & (unemployrate_m3 < 6.8)

replace unemployrate_groups_m3 = 4 if unemployrate_m3 >= 6.8

replace unemployrate_groups_m3 = . if yearsjob < 1

* Cross-tabulation & chi-square test of the three groups of hiring in terms of unemployment
tabulate nepobaby unemployrate_groups_m3, chi
* This seems to have worked! In the sense that it performed the analysis I wanted it to.
* It gives us a p-value of 0.332




* SA FOR MINUS 6
drop ymhiredate_m6

gen ymhiredate_m6 = ymhiredate

drop _merge

merge m:m ymhiredate_m6 using "C:\Users\rpseely\OneDrive - Syracuse University\Documents\GitHub\exercises\course-project-nepobabies\minus6.dta"

drop if _merge == 1
drop if _merge == 2


** Chi square test of all groups of unemployment (ymhiredate of 6 months earlier)
gen unemployrate_groups_m6 = .

replace unemployrate_groups_m6 = 1 if unemployrate_m6 <= 4.7

replace unemployrate_groups_m6 = 2 if (unemployrate_m6 > 4.7) & (unemployrate_m6 <= 5.5)

replace unemployrate_groups_m6 = 3 if (unemployrate_m6 > 5.5) & (unemployrate_m6 < 6.8)

replace unemployrate_groups_m6 = 4 if unemployrate_m6 >= 6.8

replace unemployrate_groups_m6 = . if yearsjob < 1

* Cross-tabulation & chi-square test of the three groups of hiring in terms of unemployment
tabulate nepobaby unemployrate_groups_m6, chi
*  p-value of 0.205, so it does not pass the sensitivity analysis









* SA FOR PLUS 3
drop ymhiredate_p3

gen ymhiredate_p3 = ymhiredate

drop _merge

merge m:m ymhiredate_p3 using "C:\Users\rpseely\OneDrive - Syracuse University\Documents\GitHub\exercises\course-project-nepobabies\plus3.dta"

drop if _merge == 1
drop if _merge == 2


** Chi square test of all groups of unemployment (ymhiredate of 6 months earlier)
gen unemployrate_groups_p3 = .

replace unemployrate_groups_p3 = 1 if unemployrate_p3 <= 4.7

replace unemployrate_groups_p3 = 2 if (unemployrate_p3 > 4.7) & (unemployrate_p3 <= 5.5)

replace unemployrate_groups_p3 = 3 if (unemployrate_p3 > 5.5) & (unemployrate_p3 < 6.8)

replace unemployrate_groups_p3 = 4 if unemployrate_p3 >= 6.8

replace unemployrate_groups_p3 = . if yearsjob < 1

* Cross-tabulation & chi-square test of the three groups of hiring in terms of unemployment
tabulate nepobaby unemployrate_groups_p3, chi
* p-value of 0.532, so does not pass the sensitivity analysis :(








* SA FOR PLUS 6
drop ymhiredate_p6

gen ymhiredate_p6 = ymhiredate

drop _merge

merge m:m ymhiredate_p6 using "C:\Users\rpseely\OneDrive - Syracuse University\Documents\GitHub\exercises\course-project-nepobabies\plus6.dta"

drop if _merge == 1
drop if _merge == 2


** Chi square test of all groups of unemployment (ymhiredate of 6 months earlier)
gen unemployrate_groups_p6 = .

replace unemployrate_groups_p6 = 1 if unemployrate_p6 <= 4.7

replace unemployrate_groups_p6 = 2 if (unemployrate_p6 > 4.7) & (unemployrate_p6 <= 5.5)

replace unemployrate_groups_p6 = 3 if (unemployrate_p6 > 5.5) & (unemployrate_p6 < 6.8)

replace unemployrate_groups_p6 = 4 if unemployrate_p6 >= 6.8

replace unemployrate_groups_p6 = . if yearsjob < 1

* Cross-tabulation & chi-square test of the three groups of hiring in terms of unemployment
tabulate nepobaby unemployrate_groups_p6, chi
* p-value of 0.163, so it does pass the sensitivity analysis :)









* correlation
egen nepobaby_1 = total(nepobaby == 1), by(unemployrate)
egen nepobaby_0 = total(nepobaby == 0 | nepobaby == 1), by(unemployrate)
gen nepobaby_ratio = nepobaby_1 / nepobaby_0


* Correlation between nepobaby : allworkers ratio and the unemployment rate
pwcorr nepobaby_ratio unemployrate, sig
* weak but significant relationship (0.0979 correlation)
*Showing the realtionship graphically
twoway (scatter nepobaby_ratio unemployrate), ytitle(Nepotism Ratio) xtitle(Unemployment Rate), (lfit nepobaby_ratio unemployrate)


// Fit logistic regression
logistic nepobaby unemployrate
* p-value = 0.408

// Generate predicted probabilities
predict p, pr

// Scatter plot with linear regression line and no individual data points
twoway (scatter nepobaby unemployrate, msymbol(none)) ///
       (line p unemployrate, lcolor(blue) lwidth(medium)), ///
       xtitle(Unemployment Rate) ytitle(Probability of Having a Baby) ///
       legend(off) ///
       yscale(range(0 0.3))








* Examining the ratio of nepobabies and all people hired during times of low and high unemployment

* setting up group sizes given unemployment rates
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




* High unemployment
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
 graph bar (mean) ratio_high (mean) ratio_midh (mean) ratio_midl (mean) ratio_low, blabel(bar) ytitle("Nepobaby Ratio") title("Nepotism Hiring in Different Labor Markets") legend(order(1 "high unemployment" 2 "mid-high unemployment" 3 "mid-low unemployment" 4 "low unemployment"))




 
 
 
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


*Adding in a chi-square test for the association between gender of respondent and being a nepobaby 

gen neposex = 1 if sex == 1
replace neposex = 2 if sex == 2
replace neposex = . if nepobaby == 0
gen nepoparentsex = 1 if (indus10 == paind10)
replace nepoparentsex = 2 if (indus10 == maind10)
replace nepoparentsex = . if (indus10 != paind10 & indus10 != maind10)
replace nepoparentsex = . if (paind10 == maind10)

tab neposex nepoparentsex, chi2
*Ran this code, got a very strong result with a p-value of 0.000







* Creating bar graph to visualize the t-test
graph bar (mean) malenepopa (mean) femalenepopa, title(`"Male vs. Female Nepobabies - Father"')

* Creating a better bar graphically
gen nepomale = 1 if sex == 1
replace nepomale = . if nepobaby == 0
replace nepomale = . if (paind10 == maind10)
gen nepofemale = 1 if sex == 2
replace nepofemale = . if nepobaby == 0
replace nepofemale = . if (paind10 == maind10)
tab nepomale
tab nepofemale

gen nepoparentsex_label = ""
replace nepoparentsex_label = "Nepotistic Father" if nepoparentsex == 1
replace nepoparentsex_label = "Nepotistic Mother" if nepoparentsex == 2


graph bar (count) nepomale nepofemale, over(nepoparentsex_label) ///
    stack ///
    title("Proportion of Male and Female Nepobabies by Nepotistic Parent Sex", size(medsmall)) ///
    legend(label(1 "Male Nepobabies") label(2 "Female Nepobabies")) ///
	ytitle("Nepobaby Count")


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
graph bar (mean) malenepoma (mean) femalenepoma,  title(`"Male vs. Female Nepobabies - Mother"')

* Looking at the demographics of nepobabies in high unemployment



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




* EDUCATION (college educated)
* Creating variable for college educated nepobabies
gen nepo_educ = (nepobaby == 1 & educ >= 16)

* Labeling irrelevant data as missing to avoid noise/confusion
replace nepo_educ = . if nepobaby == 0

* Creating a variable for the sample of college educated people surveyed
gen sample_educ = (educ >= 16)

* Comparing the means of college educating people in the whole sample vs. college educated nepobabies
ttest sample_educ == nepo_educ, unpaired
* p-value = 0.0917 that nepobabies are more likely to be college education than non-nepobabies - should definitely recheck this

* EDUCATION (less than high school)

gen nepo_educl = (nepobaby == 1 & educ < 12)

replace nepo_educl = . if nepobaby == 0

gen sample_educl = (educ < 12)

ttest sample_educl == nepo_educl, unpaired
* p-value = 0.3789, so no significant association

* Creating a chi-square test for nepobaby and education
tab nepobaby educ, chi2
* p = 0.099. I did the following t-test to see if it was worth examining further, and given the insignificant result of the t-test I do not believe it is worth including as a significant result in the paper.

* Creating a two-sample t-test for average education of nepobabies and non-nepobabies

gen educ_notnepo = educ
replace educ_notnepo = . if nepobaby == 1

gen educ_nepo = educ
replace educ_nepo = . if nepobaby == 0

ttest educ_nepo == educ_notnepo, unpaired
* insignificant result




* HOURS WORKED WEEKLY (self-reported)
* Creating variable for nepobabies who work overtime
gen nepo_hrs = (nepobaby == 1 & hrs1 >= 45)

* Labeling irrelevant data as missing to avoid noise/confusion
replace nepo_hrs = . if nepobaby == 0

* Creating a variable for the sample of people surveyed who work overtime
gen sample_hrs = (hrs1 >= 45)

* Comparing the means of overtime workers in the whole sample vs. overtime working nepobabies
ttest sample_hrs == nepo_hrs, unpaired


gen nepo_hrslow = (nepobaby == 1 & hrs1 < 30)

replace nepo_hrslow = . if nepobaby == 0

gen sample_hrslow = (hrs1 < 30)

ttest sample_hrslow == nepo_hrslow, unpaired

* Creating a chi-square test for nepobaby and weekly hours worked


* New t-test for hours worked

gen samplehrs = hrs1
replace samplehrs = . if nepobaby == 1

gen nepohrs = hrs1
replace nepohrs = . if nepobaby != 1

ttest nepohrs == samplehrs, unpaired
* This yields an insignificant difference between the two.



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


* Creating variable for low income nepobabies (make less than or equal to the 25th percentile of income: 14860.38)
gen nepo_linc = (nepobaby == 1 & realinc <= 14860.38)

* Labeling irrelevant data as missing to avoid noise/confusion
replace nepo_linc = . if nepobaby == 0

* Creating a variable for the proportion of males surveyed
gen sample_linc = (realinc <= 14860.38)

* Comparing the means of males in the whole sample vs. male nepobabies
ttest sample_linc == nepo_linc, unpaired


* Creating a proper t-0test for nepobabies and income

gen sample_inc = realinc
replace sample_inc = . if nepobaby == 1

gen nepoinc = realinc
replace nepoinc = . if nepobaby != 1

ttest sample_inc == nepoinc, unpaired
* Yield a result of no significant difference



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

* Creating chi-square test for nepobaby and job safety
tab nepobaby joblose, chi2
* This yielded a significant result, similar to the t-test.
