

//	Dix Hospital Ledger descriptive analysis
//	17-Sep-2019


//	Import data, recevied 16-Sep-2019 from Sarah Almond

	import delimited "/Users/nabarun/Documents/GitHub/DixLedgerDataCleaning/Dix Ledger Deidentified.csv", clear

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
					replace lengthofstay = regexr(lengthofstay,";;", ";")
						replace lengthofstay = regexr(lengthofstay,",", ";")


					gen y = regexs(1) if regexm(lengthofstay,"^[0-9]{1,2}y")
						order y, a(lengthofstay)
							replace y = regexr(y, "y", "")
								destring y, replace


			* Format dates for back calc in python
			gen temp = regexr(dateofdischarge,"-", ",")
				replace temp = regexr(temp,"-", ",")
					order temp, a(dateofdischarge)
						la var temp "formatted date of discharge for python"


			split lengthofstay, parse(;)
				rename lengthofstay1 years
				replace years = regexr(years,"y","")
					rename lengthofstay2 months
					replace months = regexr(months, "m","")
						rename lengthofstay3 days
						replace days = regexr(days,"d","")

						gen flag = regexm(rd,"m,|d,")
							order flag, a(rd)


			gen rd = "years=" + years + ", months=" + months + ", days=" + days
				order rd, b(lengthofstay)
					replace rd="" if lengthofstay==""

			python
			from datetime import *
			from dateutil.relativedelta import *
			import numpy as np
			from sfi import Data


			temp = np.array(Data.get("temp"))
			dt = datetime(temp)
			delta = relativedelta('rd')
			dt - delta
			end



			python
			from datetime import *
			from dateutil.relativedelta import *
			dt = datetime(2018,4,9)
			delta = relativedelta(years=10, months=2, days=3)
			dt - delta
			end


			python
			from datetime import *
			from dateutil.relativedelta import *
			dt = datetime('admitdate')
			delta = relativedelta(years=10, months=2, days=3)
			infer = dt - delta
			Data.addVarFloat('infer')
			Data.store('infer',None,infer)
			end


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

		//	Final disposition

		* Flag for death
			gen dead = regexm(lower(finalcondition),"die|dead")
				order dead, b(finalcondition)
					la var dead "Infer dead"
		* Flag for better as improved or cured
			gen dead = regexm(lower(finalcondition),"die|dead")
				order dead, b(finalcondition)
		* Transferred to other facilities
			gen transfer = regexm(lower(remarksfreetext),"w.n.c|western|transf|sent")
		* Suicide flag
			gen suicide = regexm(lower(remarksfreetext), "suicide")
		* Pellagra flag
			gen pellagra = regexm(lower(remarksfreetext), "pellagra")




/* I'm trying to find a way to  group final condition into meaningful
Mutually exclusive, hierarchical categories:
better = improved, much improved, cured
died = any mention of death
left = eloped, escaped
