## Nepobabies Reproducibility Package
#### Steps Taken to Produce Nepobaby Results

1. In our [OneDrive folder]([url](https://sumailsyr-my.sharepoint.com/personal/rhrabino_syr_edu/_layouts/15/onedrive.aspx?ct=1696616219053&or=OWA%2DNT&cid=87642c6f%2D751b%2Dbfc3%2D8c20%2D489c586e0930&fromShare=true&ga=1&id=%2Fpersonal%2Frhrabino%5Fsyr%5Fedu%2FDocuments%2FECN%20310%20Project)), one can find the original dataset given to us by Professor Zhu containing the 1972-2022 General Social Survey dataset. The title of the file containing the dataset is "gss7222_r1.dta"
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

3. We downloaded the FRED monthly unemployment rate dataset as an excel from the following website: https://fred.stlouisfed.org/series/UNRATE. We chose the range of months to be (1960-01-01) to (2022-12-01). In excel, we deleted the rows above the data so that it could be merged into Stata. We also created a new column, column C, and made it "ymhiredate" or the representative number in Stata for the year and month, with January of 1960 being 0 and every month after being the next counting number. This was done using the AutoFill function. Then, the only columns in the excel sheet were Columns A (the month of the observation/unemployment rate), B (the unemployment rate), and C (the column we created to represent the month in Stata).

4. In order to perform a sensitivity analysis, we created a number of excel sheets based off of the orginal excel sheet that was downloaded from the FRED.

- First, within the original excel sheet, after taking the steps above, we created four new columns: D, E, F, and G, respectively titled "ymhiredate_m3", "ymhiredate_m6",	"ymhiredate_p3", and	"ymhiredate_p6". These represent each of the time frames for which we perform the sensitivity analysis. 

- Then, similar to column C for ymhiredate, we used the AutoFill function to create the Stata-numbered representative months based on each time frame of the sensitivity analysis. Column D for minus three months started at -3, column E for minus six months started at -6, column F for plus three months started at 3, and column G for plus six months started at 6, with each column going up from the starting point by one integer.

- From there, four separate excel sheets were made for each of the sensitivity analyses, where only two columns, column B, the unemployment rate, and the respective column representing that time frame's Stata-numbered month were present. 

- The unemployment rate columns in the excel sheets for each time frame were titled "unemployrate_xn", where "_xn" represents a suffix of _m3, _m6, _p3, or _p6, similar to the month ("ymhiredate") column. These excel sheets were then titled "minus3", "minus6", "plus3", and "plus6".


5. We then used the FRED_unrate_dtaconversion.do file to convert each of the five excel files into .dta Stata-style datasets.


6.  We merged the FRED monthly unemployment rate dataset titled "FRED_unrate_60to22_robust.dta" into "GSSclean_noRDs.dta" using a command in our main do-file, allowing us to study the interaction between nepotism and unemployment rates.

7. We then used the do-file called "nepobabies.do" to complete our analysis. 
