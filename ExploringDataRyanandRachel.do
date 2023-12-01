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

**paind10 maind10 indus10 
**Creating dummy variable for nepobaby = 1 if respondent is in the same industry as their mother or father, 0 otherwise
*** Use replace function to replace the value in indus10 with something other than "iap" if the value is missing
gen nepobaby = ((indus10 == paind10)|(indus10 == maind10))

**Creating a new variable for year hired
**** Must make determination on missing variables, i.e. every four years yearsjob asked.
gen yearsjob_int = round(yearsjob)

** Creating variable for the year (yearsjob_int) respondents obtained job
gen yearhire = (year - yearsjob_int)


**Trying to create the full interview date as an integer so that it can be formatted as a stata date.
egen flintdate = concat(dateintv year)
gen flintdate_int = int(flintdate)

**Creating new date variable for full interview date, including year.
gen flintdate = string(dateintv) + string(year)

**Getting rid of missing data
drop if year < 1975
drop if missing(dateintv)

gen contains_non_numeric = regexm(flintdate, "[^0-9]")
list flintdate contains_non_numeric

gen flintdate_int = cond(contains_non_numeric == 0, int(flintdate), .)

**Not working yet! But trying to create a variable that makes the full interview date variable into an integer
gen flintdate_int = int(flintdate)

**Creating new variable for full hire date, including year.
gen flhiredate = string(dateintv) + string(yearhire)
**This variable includes the rounded values (.25 year and .75 years as 0 and 1 respectably)
**There are many missing values for all respondents who have not answered the yearsjob question. Prof. Buzard? Drop it? Data cleaning needed.

**Converting the full interview and hire dates into a Stata date format.
gen flhiredate1 = date(substr(flhiredate, 3, .), "MDY")
**Did not work.

**Suggested code from ChatGPT to recode as Stata date format
**Not working yet!
// Extract day, month, and year components
gen day = mod(flintdate, 100)
gen month = floor(mod(flintdate/100, 100))
gen year = floor(flintdate/10000)

// Convert to Stata date variable
gen date_var = date(year, month, day)

// Display the results
list flintdate date_var

