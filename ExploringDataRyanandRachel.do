cd "C:\Users\rpseely\Syracuse University\Rachel Hannah Rabinowitz - ECN 310 Project"

use "gss7222_r1" 
 

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



 
 **the next few lines are for getting an idea of those variables look like 
tab dateintv
tab educ
tab fndjob2

**this gives us important information on the number of observation and descriptive statistics of important variables
summarize fndjob2 educ dateintv major1 paeduc maeduc industry indus80 indus07 indus10 paind10 paind80 paind16 maind10 maind80 indfirst

**this examines the relationship between education and finding a job through a relative
graph box educ, over (fndjob2)

save "GSSclean_noRDs.dta" , replace

** This prevents false positives from occurring for the nepobaby, panepobaby, and manepobaby variables.
replace indus10 = 1 if missing(indus10)

**Creating dummy variable for nepobaby = 1 if respondent is in the same industry as their mother or father, 0 otherwise
gen nepobaby = ((indus10 == paind10)|(indus10 == maind10))
** Create variable for being in the same industry as ONLY a respondent's father. (same false positives as nepobaby)
gen panepobaby = (indus10 == paind10)
** Create variable for being in the same industry as ONLY a respondent's mother. (same false positives as nepobaby)
gen manepobaby = (indus10 == maind10)


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
 
**paind10 maind10 indus10 
**Creating dummy variable for nepobaby = 1 if respondent is in the same industry as their mother or father, 0 otherwise
*** Use replace function to replace the value in indus10 with something other than "iap" if the value is missing
gen nepobaby = ((indus10 == paind10)|(indus10 == maind10))

**Getting rid of missing data
drop if year < 1975
drop if missing(dateintv)

* Convert dateintv to a string for easier manipulation
gen dateintv_str = string(dateintv)

* Extract dayintv (last two digits)
gen dayintv = real(substr(dateintv_str, -2, .))

* Extract monthintv based on the length of dateintv
gen monthintv = .
replace monthintv = real(substr(dateintv_str, 1, 1)) if length(dateintv_str) == 3
replace monthintv = real(substr(dateintv_str, 1, 2)) if length(dateintv_str) == 4

* Display the results
browse dateintv dateintv_str dayintv monthintv year

* Rename year variable for clarity
rename year yearintv

** This created a variable for the year and month a respondent was interviewed!
** It does so in the format of a Stata date, where Jan. 1960 is considered 1 and every month's code after that = (months after Jan. 1960)
gen ymintdate = ym(yearintv, monthintv)

** Creates a variable for the month and year a respondent was hired (assuming they were hired exactly the number of years ago they reported) which leaves us with 9,256 variables/.
gen ymhiredate = ymintdate - (yearsjob * 12)

** We can only perform analysis for the respondents who answered the `yearsjob` question.
drop if missing(yearsjob)

*** Manual input of unemployment rates by month
*** We must actually create the unemployment rates variable. It worked for me when I created the variable in the data editor but I did not save that. We must figure out how to do that. I imagine it will look something like...
gen unemployrate = .

*1975
*January
replace unemployrate = 8.1 if flintdate == 180
*February 
replace unemployrate = 8.1 if flintdate == 181
*March 
replace unemployrate = 8.6 if flintdate == 182
*April 
replace unemployrate = 8.8 if flintdate == 183
*May 
replace unemployrate = 9.0 if flintdate == 184
*June 
replace unemployrate = 8.8 if flintdate == 185
*July 
replace unemployrate = 8.6 if flintdate == 186
*August 
replace unemployrate = 8.4 if flintdate == 187
*September 
replace unemployrate = 8.4 if flintdate == 188
*October 
replace unemployrate = 8.4 if flintdate == 189
*November 
replace unemployrate = 8.3 if flintdate == 190
*December 
replace unemployrate = 8.2 if flintdate == 191

*1976
*January
replace unemployrate = 7.9 if flintdate == 192
*February 
replace unemployrate = 7.7 if flintdate == 193
*March 
replace unemployrate = 7.6 if flintdate == 194
*April 
replace unemployrate = 7.7 if flintdate == 195
*May 
replace unemployrate = 7.4 if flintdate == 196
*June 
replace unemployrate = 7.6 if flintdate == 197
*July 
replace unemployrate = 7.8 if flintdate == 198
*August 
replace unemployrate = 7.8 if flintdate == 199
*September 
replace unemployrate = 7.6 if flintdate == 200
*October 
replace unemployrate = 7.7 if flintdate == 201
*November 
replace unemployrate = 7.8 if flintdate == 202
*December 
replace unemployrate = 7.8 if flintdate == 203


