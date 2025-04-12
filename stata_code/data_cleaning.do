* Data Exercise #3 Cleaning
* Patrick Beal
* Econ 388, Dr. Eastmond


* Setting directory
cd "C:\Users\jpbeal\Box\Econ 388\econ388_tech_growth\stata_code"

* Start logging
cap log close
log using data_cleaning.log, replace

* Set directory to data
cd "C:\Users\jpbeal\Box\Econ 388\econ388_tech_growth\raw_data"

* Load the GDP data
use pwt1001, clear

* Fix the names of places so we can merge
replace country = "Bolivia" if country == "Bolivia (Plurinational State of)"
replace country = "Bosnia-Herzegovina" if country == "Bosnia and Herzegovina"
replace country = "Democratic Republic of the Congo" if country == "D.R. of the Congo"
replace country = "Hong Kong" if country == "China, Hong Kong SAR"
replace country = "Iran" if country == "Iran (Islamic Republic of)"
replace country = "Laos" if country == "Lao People's DR"
replace country = "South Korea" if country == "Republic of Korea"
replace country = "Russia" if country == "Russian Federation"
replace country = "Slovak Republic" if country == "Slovakia"
replace country = "Syria" if country == "Syrian Arab Republic"
replace country = "Venezuala" if country == "Venezuela (Bolivarian Republic of)"
replace country = "Vietnam" if country == "Viet Nam"

rename country country_name

* Merge in with the technological growth data
merge 1:1 country_name year using chat.dta.tga
keep if _merge == 3
drop _merge

* Generate GDP per capita
gen gdp_per_cap = rgdpna / pop

* Generate binary for developed
gen developed = 0
replace developed = 1 if country_name == "France" | country_name == "Germany" | country_name == "Italy" | country_name == "Japan" | country_name == "United Kingdom" | country_name == "United States"

* Variable lists for technology and controls
local tech cellphone ag_tractor bed_hosp vehicle_car eft
local controls avh hc pop pctivliteracy

* Generate log variables and store in log lists
gen log_gdp_per_cap = log(gdp_per_cap)

local log_tech
foreach var in `tech' {
	gen log_`var' = log(`var')
	local log_tech `log_tech' log_`var'
}

local log_controls
foreach var in `controls' {
	gen log_`var' = log(`var')
	local log_controls `log_controls' log_`var'
}

* Collapse according to developed and undeveloped
collapse (mean) log_gdp_per_cap `log_tech' `log_controls' `controls' [aweight=pop], by(developed year)

* Computes percent changes and store in growth lists
tsset developed year
bysort developed (year): gen g_gdp_per_cap = D.log_gdp_per_cap

local g_tech
foreach var in `tech' {
	bysort developed (year): gen g_`var' = D.log_`var'
	local g_tech `g_tech' g_`var'
}

local g_controls
foreach var in `controls' {
	bysort developed (year): gen g_`var' = D.log_`var'
	local g_controls `g_controls' g_`var'
}

* Keep the variables we want to use for analysis
keep developed g_gdp_per_cap `g_tech' `controls' `g_controls' year
browse

* Drop years we don't have any data
drop if year >= 2004
foreach var of varlist _all {
	replace `var' = 0 if missing(`var')
}

cd "../"
save cleaned_data.dta, replace

cap log close
