

//	Dix Hospital Ledger descriptive analysis
//	12-Sep-2019


//	Import data, recevied 11-Sep-2019 from Sarah Almond
	
	import delimited "/Users/nabarun/Dropbox/Projects/Dix Park Intake/data/Dix Ledger Deidentified.csv", clear
	
	describe
	
//	Variable cleanup
	
	//	Age
			
		// Age at admission (string)
			tab age, m
			la var age "Age at admission in years (cleaned)"
			
			* missing
			replace age="" if regexm(lower(age),"unk")
				replace age="" if age=="?"
					
			* pick median of age ranges	
			replace age = "33" if age=="30-35?"
			replace age = "43" if age=="45 or 50"
			replace age = "43" if age=="45-50"
			replace age = "45" if age=="4_"
			replace age = "58" if age=="55 or 60"
			replace age = "73" if age=="70-5"
			
			* fraction to decimal and trim extra characters
			replace age = regexr(age," 1/2", ".5") 
			replace age = regexr(age,"\+", "")
			replace age = regexr(age,"(\?)", "") 
			
			replace age = "35" if age=="About 35"
			replace age = "58" if age=="58 ()"
		
			tab age, m
			
			* convert to numeric
			destring age, replace
			hist age, width(5) freq
	
		//	Age of first attack (string)
		
			
	
	//	Dates of admission and discharge
	
		* Admission
		gen admitdate = date(dateofadmission,"YMD")
			order admitdate, a(dateofadmission)
				format admitdate %td
					la var admitdate "Date of admission (cleaned)"
						*drop dateofadmission
		
		gen year = year(admitdate)
			order year, a(admitdate)
				la var year "Year of admission"
				
		gen decade = .
		
		* Discharge
		gen disdate = date(dateofdischarge,"YMD")
			order disdate, a(admitdate)
				la var disdate "Date of discharge (cleaned)"
					format disdate %td
					
			* If discharge date is missing, infer using length of stay and admit date	
			
				* clean up 
				replace lengthofstay = regexr(lengthofstay,";;", ";") 
				replace lengthofstay = regexr(lengthofstay,",", ";") 
					
			
					gen y = regexs(1) if regexm(lengthofstay,"[0-9]{1,2}y")
						order y, a(lengthofstay)
							replace y = regexr(y, "y", "")
								destring y, replace
							
										
			
			* list of leap years
			
				* 	1856,1860,1864,1868,1872,1876,1880,1884,1888,1892,1896,1904,1908,1912,1916,1920

				
		//	Marital status
		
		gen marital = .
			replace marital = 1 if maritalstatus=="Single"
			replace marital = 2 if maritalstatus=="Married"
			replace marital = 2 if maritalstatus=="Single;Married"
			replace marital = 3 if maritalstatus=="Widowed"
			replace marital = 3 if maritalstatus=="Married; Widowed"
			replace marital = 4 if maritalstatus=="Divorced"
			replace marital = 4 if maritalstatus=="Separated"
			replace marital = 9 if maritalstatus==""
			replace marital = 9 if maritalstatus=="unknown"
				la var marital "Marital status at admission (recoded)"
					label define marlabel 1 "Single" 2 "Married" 3 "Widowed" 4 "Separated or Divorced" 9 "Unknown"
						label values marital marlabel
							tab marital
		
	
