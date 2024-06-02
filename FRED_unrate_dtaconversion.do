* Directing the file path
cd "C:\Users\rpseely\OneDrive - Syracuse University\Documents\GitHub\exercises\course-project-nepobabies"

** Saving the original unemployment rate excel dataset as a .dta file
* Importing the excel file and telling Stata where the variable names are
import excel "C:\Users\rpseely\OneDrive - Syracuse University\Documents\GitHub\exercises\course-project-nepobabies\FRED_unrate_60to22_robust.xlsx", firstrow 

* Saving the .xlsx file as a .dta file to be used for data analysis in Stata
saveold "C:\Users\rpseely\OneDrive - Syracuse University\Documents\GitHub\exercises\course-project-nepobabies\FRED_unrate_60to22_robust.dta", replace

** Saving the unemployment rate (lagged 3 months) excel dataset as a .dta file
* Importing the excel file and telling Stata where the variable names are
import excel "C:\Users\rpseely\OneDrive - Syracuse University\Documents\GitHub\exercises\course-project-nepobabies\minus3", firstrow 

* Saving the .xlsx file as a .dta file to be used for data analysis in Stata
saveold "C:\Users\rpseely\OneDrive - Syracuse University\Documents\GitHub\exercises\course-project-nepobabies\minus3", replace


** Saving the unemployment rate (lagged 6 months) excel dataset as a .dta file
* Importing the excel file and telling Stata where the variable names are
import excel "C:\Users\rpseely\OneDrive - Syracuse University\Documents\GitHub\exercises\course-project-nepobabies\minus6", firstrow 

* Saving the .xlsx file as a .dta file to be used for data analysis in Stata
saveold "C:\Users\rpseely\OneDrive - Syracuse University\Documents\GitHub\exercises\course-project-nepobabies\minus6", replace


** Saving the unemployment rate (lead 3 months) excel dataset as a .dta file
* Importing the excel file and telling Stata where the variable names are
import excel "C:\Users\rpseely\OneDrive - Syracuse University\Documents\GitHub\exercises\course-project-nepobabies\plus3", firstrow 

* Saving the .xlsx file as a .dta file to be used for data analysis in Stata
saveold "C:\Users\rpseely\OneDrive - Syracuse University\Documents\GitHub\exercises\course-project-nepobabies\plus3", replace


** Saving the unemployment rate (lead 6 months) excel dataset as a .dta file
* Importing the excel file and telling Stata where the variable names are
import excel "C:\Users\rpseely\OneDrive - Syracuse University\Documents\GitHub\exercises\course-project-nepobabies\plus6", firstrow 

* Saving the .xlsx file as a .dta file to be used for data analysis in Stata
saveold "C:\Users\rpseely\OneDrive - Syracuse University\Documents\GitHub\exercises\course-project-nepobabies\plus6", replace
