* Directing the file path
cd "C:\Users\rpseely\OneDrive - Syracuse University\Documents\GitHub\exercises\course-project-nepobabies"

* Importing the excel file and telling Stata where the variable names are
import excel "C:\Users\rpseely\OneDrive - Syracuse University\Documents\GitHub\exercises\course-project-nepobabies\FRED_unrate_60to22_robust.xlsx", firstrow 

* Saving the .xlsx file as a .dta file to be used for data analysis in Stata
saveold "C:\Users\rpseely\OneDrive - Syracuse University\Documents\GitHub\exercises\course-project-nepobabies\FRED_unrate_60to22_robust.dta", replace