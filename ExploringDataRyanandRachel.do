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
gen nepobaby = ((indus10 == paind10)|(indus10 == maind10))

**Creating new date variable to match with recession dates
gen flintdate = string(dateintv) + substr(string(year), -2, 2)

