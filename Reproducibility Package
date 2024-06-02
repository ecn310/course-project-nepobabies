## Nepobabies Reproducibility Package
#### Steps Taken to Produce Nepobaby Results

1. In our OneDrive folder, linked below, you can find the original dataset given to us by Professor Zhu containing the 1972-2022 General Social Survey dataset.
https://sumailsyr-my.sharepoint.com/personal/rhrabino_syr_edu/_layouts/15/onedrive.aspx?ct=1696616219053&or=OWA%2DNT&cid=87642c6f%2D751b%2Dbfc3%2D8c20%2D489c586e0930&fromShare=true&ga=1&id=%2Fpersonal%2Frhrabino%5Fsyr%5Fedu%2FDocuments%2FECN%20310%20Project
The title of the dataset is "gss7222_r1.dta"
Using the following lines of code, we kept only the variables we were interested in looking at, allowing us to reduce the size of the file and the number of irrelevant variables:

keep year rincome age dateintv educ paeduc maeduc jobinc jobsec jobpay ///
jobkeep jobhonor jobinter fndjob2 thisjob7 wrkwell paind16 paind10 paind80 ///
maind80 maind10 indus10 major1 major2 voedcol voedncol colmajr1 colmajr2 ///
joblose yearsjob covemply race parborn granborn wealth opwlth income72 ///
income77 income82 income86 income91 income98 income06 income16 coninc realinc ///
povline incdef wlthpov progtax oprich inequal3 taxrich taxshare contrich ///
class class1 hrs1 hrs2 jobhour hrswork workhr sethours sex intltest ///
skiltest wojobyrs occmobil lastslf gdjobsec thisjob2 ///

It is important to note that we did not use all of those variables for varying reasons, mostly that observations were not taken during any or most of our survey years.


2. We saved that dataset as a .dta file and titled it "GSSclean_noRDs"

3. We use the do-file called "nepobabies.do" to complete our analysis. 

4. We downloaded the FRED monthly unemployment rate dataset as an excel from the following website: https://fred.stlouisfed.org/series/UNRATE
We chose the range of months to be (1960-01-01) to (2022-12-01)
In excel, we deleted the rows above the data so that it could be merged into stata. We also created a new column, column C, and made it "ymhiredate" or the representative number in Stata for the year in month, with January of 1960 being 0 and every month after being the next counting number.
We then saved the excel dataset .xls as a stata dataset .dta so that it could be merged.

5. We merged the FRED monthly unemployment rate dataset titled "FREDunemploymentrates1960_2022.dta" into "GSSclean_noRDs.dta" using a command in our main do-file.

