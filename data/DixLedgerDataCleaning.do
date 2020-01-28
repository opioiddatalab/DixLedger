//	Import data, recevied 16-Sep-2019 from Sarah Almond
	
cd "/Users/nabarun/Dropbox/Projects/Dix Park Intake/"
import delimited "DixLedgerDeidentified.csv", clear
	
// Internal counting variable
gen counter=1
    la var counter "Equals one for each row observation"

// Derived variables

* Flag for farming occupation
gen farmer = regexm(occupationcleaned, "farm")
	la var farmer "infer farmer occupation"
		note farmer: regex from occupationcleaned = farm

* Flag for health professional
gen healthpro = regexm(occupationcleaned, "doct|pharm|nurse|surg|physician|dentist")
	la var healthpro "inferred health professional occupation" 
		note healthpro: regex from occupationcleaned = doct|pharm|nurse|surg|physician|dentist

* Flag for death
	gen dead = regexm(lower(finalcondition),"die|dead")
		order dead, b(finalcondition)
			la var dead "Infer dead"
            
* Flag for better as improved or cured
	gen better = regexm(lower(finalcondition),"improv|cure")
		order better, b(finalcondition)
        
* Transferred to other facilities
	gen transfer = regexm(lower(remarksfreetext),"w.n.c|western|transf|sent ")
    
* Suicide flag
	gen suicide = regexm(lower(remarksfreetext), "suicide")
    
* Pellagra flag
	gen pellagra = (regexm(lower(remarksfreetext), "pellagra") | regexm(lower(supposedcausecleaned1), "pellagra") | regexm(lower(formcleaned), "pellagra"))
	
  
// Causes

label define yesno 1 "Yes" 0 "No"


local dx "war opiates alcohol cocaine masturbation overwork pregnancy syphilis menopause hereditary"

foreach i of local dx {
    gen `i'= regexm(lower(supposedcauseofattackastranscrib), "`i'") | regexm(lower(supposedcausecleaned1), "`i'") | regexm(lower(supposedcausecleaned2), "`i'")
        note `i': Dichotmous flag derived from regular expression search of cause of attack as transcribed or recoded fields.
            label values `i' yesno
}
    
* Create numeric indicator for gender for Odds Ratios
gen sex=. if gender==""
	la var sex " 0=female"
		replace sex=1 if gender=="M"
			replace sex=0 if gender=="F"
				order sex, a(gender)
					label define mf 1 "male" 0 "female"
						label values sex mf

    
// Clean data formatting errors in length of stay variable

gen revisedlos=lengthofstay

replace revisedlos = "0y;3m;16d" in 2
replace revisedlos = "0y;0m;6d" in 149
replace revisedlos = "21y;9m;0d" in 212
replace revisedlos = "0y;0m;10d" in 245
replace revisedlos = "0y;0m;9d" in 310
replace revisedlos = "2y;11m;16d" in 681
replace revisedlos = "2y;0m;0d" in 691
replace revisedlos = "13y;8m;0d" in 692
replace revisedlos = "4y;11m;0d" in 702
replace revisedlos = "16y;6m;8d" in 715
replace revisedlos = "67y;0m;11d" in 767
replace revisedlos = "6y;0m;11d" in 767
replace revisedlos = "13y;0m;25d" in 812
replace revisedlos = "0y;3m;21d" in 853
replace revisedlos = "0y;11m;24d" in 859
replace revisedlos = "0y;6m;20d" in 861
replace revisedlos = "0y;10m;13d" in 869
replace revisedlos = "0y;8m;17d" in 870
replace revisedlos = "0y;1m;5d" in 871
replace revisedlos = "0y;3m;16d" in 884
replace revisedlos = "0y;7m;27d" in 885
replace revisedlos = "0y;9m;3d" in 893
replace revisedlos = "0y;5m;24d" in 897
replace revisedlos = "15y;7m;1d" in 900
replace revisedlos = "0y;8m;0d" in 902
replace revisedlos = "0y;6m;3d" in 911
replace revisedlos = "0y;0m;16d" in 912
replace revisedlos = "0y;11m;19d" in 914
replace revisedlos = "0y;10m;0d" in 916
replace revisedlos = "0y;5m;21d" in 918
replace revisedlos = "0y;10m;0d" in 919
replace revisedlos = "0y;5m;6d" in 945
replace revisedlos = "10y;1m;19d" in 992
replace revisedlos = "0y;5m;6d" in 1072
replace revisedlos = "0y;0m;20d" in 1113
replace revisedlos = "2y;10m;17d" in 1175
replace revisedlos = "6y;3m;24d" in 1189
replace revisedlos = "3y;9m;26d" in 1192
replace revisedlos = "1y;1d;23m" in 1193
replace revisedlos = "1y;1m;23d" in 1193
replace revisedlos = "3y;4m;0d" in 1237
replace revisedlos = "0y;6m;0d" in 1239
replace revisedlos = "0y;1m;4d" in 1244
replace revisedlos = "0y;1m;24d" in 1254
replace revisedlos = "0y;0m;21d" in 1255
replace revisedlos = "0y;4m;6d" in 1256
replace revisedlos = "4y;1m;0d" in 1258
replace revisedlos = "1y;8m;0d" in 1260
replace revisedlos = "0y;1m;1d" in 1263
replace revisedlos = "0y;11m;19d" in 1267
replace revisedlos = "0y;0m;16d" in 1272
replace revisedlos = "0y;9m;23d" in 1275
replace revisedlos = "0y;4m;10d" in 1329
replace revisedlos = "0y;6m;15d" in 1333
replace revisedlos = "0y;4m;19d" in 1337
replace revisedlos = "1y;6m;0d" in 1340
replace revisedlos = "0y;4m;19d" in 1347
replace revisedlos = "0y;1m;1d" in 1350
replace revisedlos = "0y;0m;4d" in 1352
replace revisedlos = "1y;0m;6d" in 1358
replace revisedlos = "0y;0m;5d" in 1371
replace revisedlos = "0y;9m;0d" in 1395
replace revisedlos = "0y;0m;14d" in 1399
replace revisedlos = "0y;9m;14d" in 1410
replace revisedlos = "0y;0m;13d" in 1411
replace revisedlos = "0y;1m;24d" in 1414
replace revisedlos = "0y;0m;10d" in 1418
replace revisedlos = "0y;9m;16d" in 1420
replace revisedlos = "0y;3m;20d" in 1469
replace revisedlos = "0y;4m;11d" in 1472
replace revisedlos = "0y;4m;11d" in 1473
replace revisedlos = "0y;4m;2d" in 1474
replace revisedlos = "0y;0m;25d" in 1476
replace revisedlos = "0y;1m;14d" in 1479
replace revisedlos = "0y;0m;16d" in 1480
replace revisedlos = "0y;8m;5d" in 1482
replace revisedlos = "0y;6m;28d" in 1485
replace revisedlos = "0y;1m;28d" in 1487
replace revisedlos = "0y;4m;4d" in 1489
replace revisedlos = "0y;11m;27d" in 1491
replace revisedlos = "0y;5m;12d" in 1495
replace revisedlos = "0y;4m;5d" in 1503
replace revisedlos = "0y;0m;20d" in 1509
replace revisedlos = "0y;10m;28d" in 1510
replace revisedlos = "0y;5m;11d" in 1511
replace revisedlos = "0y;8m;23d" in 1542
replace revisedlos = "0y;9m;2d" in 1544
replace revisedlos = "0y;5m;25d" in 1545
replace revisedlos = "0y;0m;14d" in 1548
replace revisedlos = "0y;9m;25d" in 1549
replace revisedlos = "0y;7m;3d" in 1554
replace revisedlos = "0y;1m;3d" in 1557
replace revisedlos = "0y;0m;14d" in 1560
replace revisedlos = "0y;7m;4d" in 1563
replace revisedlos = "0y;4m;4d" in 1568
replace revisedlos = "0y;5m;14d" in 1569
replace revisedlos = "0y;8m;8d" in 1573
replace revisedlos = "0y;0m;29d" in 1575
replace revisedlos = "0y;3m;27d" in 1577
replace revisedlos = "0y;3m;18d" in 1580
replace revisedlos = "0y;6m;27d" in 1581
replace revisedlos = "0y;0m;3d" in 1583
replace revisedlos = "0y;11m;13d" in 1584
replace revisedlos = "0y;7m;2d" in 1588
replace revisedlos = "0y;10m;18d" in 1593
replace revisedlos = "0y;3m;23d" in 1595
replace revisedlos = "0y;10m;14d" in 1596
replace revisedlos = "0y;5m;25d" in 1597
replace revisedlos = "0y;4m;10d" in 1598
replace revisedlos = "0y;10m;4d" in 1601
replace revisedlos = "0y;5m;24d" in 1602
replace revisedlos = "0y;4m;21d" in 1603
replace revisedlos = "0y;5m;13d" in 1606
replace revisedlos = "0y;11m;4d" in 1607
replace revisedlos = "0y;7m;20d" in 1608
replace revisedlos = "0y;8m;23d" in 1609
replace revisedlos = "0y;0m;2d" in 1692
replace revisedlos = "0y;6m;15d" in 1712
replace revisedlos = "0y;1m;6d" in 1728
replace revisedlos = "ym;0m;19d" in 1854
replace revisedlos = "0y;0m;19d" in 1854
replace revisedlos = "0y;7m;1d" in 1868
replace revisedlos = "0y;0m;10d" in 1870
replace revisedlos = "0y;7m;24d" in 1871
replace revisedlos = "0y;3m;15d" in 1874
replace revisedlos = "0y;7m;7d" in 1876
replace revisedlos = "0y;1m;14d" in 1907
replace revisedlos = "0y;2m;22d" in 1908
replace revisedlos = "0y;8m;3d" in 1909
replace revisedlos = "0y;11m;26d" in 1912
replace revisedlos = "0y;8m;14d" in 1914
replace revisedlos = "0y;1m;8d" in 1918
replace revisedlos = "0y;6m;11d" in 1922
replace revisedlos = "0y;5m;13d" in 1924
replace revisedlos = "0y;8m;2d" in 1928
replace revisedlos = "0y;6m;10d" in 1929
replace revisedlos = "0y;6m;22d" in 1930
replace revisedlos = "0y;6m;22d" in 1931
replace revisedlos = "0y;3m;14d" in 1933
replace revisedlos = "0y;5m;26d" in 1936
replace revisedlos = "0y;5m;16d" in 1937
replace revisedlos = "0y;5m;23d" in 1940
replace revisedlos = "0y;4m;15d" in 1942
replace revisedlos = "0y;9m;26d" in 1944
replace revisedlos = "0y;3m;22d" in 1954
replace revisedlos = "0y;5m;16d" in 1955
replace revisedlos = "0y;8m;14d" in 1960
replace revisedlos = "0y;6m;16d" in 1961
replace revisedlos = "0y;9m;2d" in 1965
replace revisedlos = "0y;7m;3d" in 1966
replace revisedlos = "0y;7m;9d" in 1968
replace revisedlos = "0y;5m;4d" in 1971
replace revisedlos = "0y;9m;25d" in 1972
replace revisedlos = "0y;6m;5d" in 1974
replace revisedlos = "0y;1m;4d" in 1975
replace revisedlos = "0y;8m;19d" in 1976
replace revisedlos = "0y;9m;8d" in 1977
replace revisedlos = "0y;5m;11d" in 1978
replace revisedlos = "0y;9m;21d" in 1979
replace revisedlos = "0y;3m;5d" in 1980
replace revisedlos = "0y;2m;22d" in 1981
replace revisedlos = "0y;7m;18d" in 1985
replace revisedlos = "0y;4m;2d" in 1989
replace revisedlos = "0y;6m;15d" in 1993
replace revisedlos = "0y;6m;12d" in 1994
replace revisedlos = "0y;9m;0d" in 1998
replace revisedlos = "0y;5m;25d" in 1999
replace revisedlos = "0y;5m;15d" in 2003
replace revisedlos = "0y;10m;8d" in 2004
replace revisedlos = "0y;6m;21d" in 2007
replace revisedlos = "0y;4m;10d" in 2010
replace revisedlos = "0y;2m;12d" in 2011
replace revisedlos = "0y;4m;10d" in 2013
replace revisedlos = "0y;4m;12d" in 2014
replace revisedlos = "0y;5m;20d" in 2019
replace revisedlos = "0y;2m;12d" in 2024
replace revisedlos = "0y;0m;16d" in 2026
replace revisedlos = "0y;1m;24d" in 2027
replace revisedlos = "0y;7m;29d" in 2028
replace revisedlos = "0y;0m;10d" in 2029
replace revisedlos = "0y;2m;20d" in 2034
replace revisedlos = "0y;0m;7d" in 2036
replace revisedlos = "0y;6m;3d" in 2039
replace revisedlos = "0y;8m;16d" in 2076
replace revisedlos = "0y;10m;10d" in 2077
replace revisedlos = "0y;10m;9d" in 2080
replace revisedlos = "0y;30d" in 2081
replace revisedlos = "0y;0m;30d" in 2081
replace revisedlos = "0y;2m;2d" in 2082
replace revisedlos = "0y;5m;1d" in 2085
replace revisedlos = "0y;7m;21d" in 2087
replace revisedlos = "0y;8m;20d" in 2088
replace revisedlos = "0y;5m;23d" in 2092
replace revisedlos = "0y;4m;21d" in 2095
replace revisedlos = "0y;4m;21d" in 2096
replace revisedlos = "0y;2m;20d" in 2099
replace revisedlos = "0y;11m;13d" in 2100
replace revisedlos = "0y;6m;12d" in 2102
replace revisedlos = "0y;0m;7d" in 2112
replace revisedlos = "5y;4m;5d" in 2749
replace revisedlos = "0y;3m;3d" in 2760
replace revisedlos = "2y;0m;16d" in 2845
replace revisedlos = "14y;11m;28d" in 2848
replace revisedlos = "6y;10m;28d" in 2915
replace revisedlos = "0y;4m;21d" in 3234
replace revisedlos = "0y;6m;17d" in 3401
replace revisedlos = "2y;5m;10d" in 3764
replace revisedlos = "0y;4m;3d" in 3780
replace revisedlos = "0y;2m;16d" in 3855
replace revisedlos = "0y;1m;23d" in 4442
replace revisedlos = "0y;0m;7d" in 4766
replace revisedlos = "0y;0m;30d" in 4767
replace revisedlos = "0y;0m;25d" in 4770
replace revisedlos = "0y;0m;1d" in 4796
replace revisedlos = "0y;0m;14d" in 4827
replace revisedlos = "3y;0m;17d" in 4857
replace revisedlos = "0y;6m;1d" in 5439
replace revisedlos = "0y;0m;12d" in 5739
replace revisedlos = "0y;1m;20d" in 5750
replace revisedlos = "0y;0m;1d" in 5898
replace revisedlos = "0y;7m;10d" in 6117
replace revisedlos = "0y;0m;14d" in 6220
replace revisedlos = "0y;11m;19" in 6979
replace revisedlos = "0y;11m;19d" in 6979
replace revisedlos = "1y;2m;17d" in 7165

// Correct other data entry errors manually
replace dateofadmission="1884-08-23" if patientid==2468

// Dates of Admission and Discharge

* Admission
gen admitdate = date(dateofadmission,"YMD")
	order admitdate, a(dateofadmission)
		format admitdate %td
			la var admitdate "Date of admission (cleaned)"
				*drop dateofadmission
                
gen year = year(admitdate)
	order year, a(admitdate)
		la var year "Year of admission"

* Decade of admission
gen decade = .
    replace decade=1 if year>=1850 & year<=1859
    replace decade=2 if year>=1860 & year<=1869
    replace decade=3 if year>=1870 & year<=1879
    replace decade=4 if year>=1880 & year<=1889
    replace decade=5 if year>=1890 & year<=1899
    replace decade=6 if year>=1900 & year<=1909
    replace decade=7 if year>=1910 & year<=1919
    replace decade=8 if year>=1920 & year<=1929
        label define decadelabel 1 "1850s" 2 "1860s" 3 "1870s" 4 "1880s" 5 "1890s" 6 "1900s" 7 "1910s" 8 "1920s"
            label values decade decadelabel
                la var decade "Decade of admission"
qui tab decade, m

gen dayofweek = dow(admitdate)
    order dayofweek, a(year)
        la var dayofweek "Day of the week of admission date 0=Sunday"
            label define week 0 "Sun" 1 "Mon" 2 "Tue" 3 "Wed" 4 "Thu" 5 "Fri" 6 "Sat"
                label values dayofweek week

gen admitmonth=month(admitdate)
    order admitmonth, a(year)
        la var admitmonth "Month of admission"
            label define month 1 "J" 2 "F" 3 "M" 4 "A" 5 "M" 6 "J" 7 "J" 8 "A" 9 "S" 10 "O" 11 "N" 12 "D"
                label values admitmonth month
                
                            
* Discharge
gen disdate = date(dateofdischarge,"YMD")
	order disdate, a(admitdate)
		la var disdate "Date of discharge (cleaned)"
			format disdate %td

* Decade of discharge
gen disdecade = .
    replace disdecade=1 if year(disdate)>=1850 & year(disdate)<=1859
    replace disdecade=2 if year(disdate)>=1860 & year(disdate)<=1869
    replace disdecade=3 if year(disdate)>=1870 & year(disdate)<=1879
    replace disdecade=4 if year(disdate)>=1880 & year(disdate)<=1889
    replace disdecade=5 if year(disdate)>=1890 & year(disdate)<=1899
    replace disdecade=6 if year(disdate)>=1900 & year(disdate)<=1909
    replace disdecade=7 if year(disdate)>=1910 & year(disdate)<=1919
    replace disdecade=8 if year(disdate)>=1920 & year(disdate)<=1929
        label values disdecade decadelabel
            la var disdecade "Decade of discharge"
qui tab disdecade, m

qui tab dayofweek, m

save DixLedgerDeidentified_clean, replace
export delimited using "DixLedgerDeidentified_clean.csv", delimiter(tab) 
