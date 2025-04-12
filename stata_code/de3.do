* Data Exercise #2
* Patrick Beal
* Econ 388, Dr. Eastmond


* Setting directory
cd "C:\Users\jpbeal\Box\Econ 388\econ388_tech_growth\stata_code"

* Start logging
cap log close
log using DE3.log, replace

* Set directory to data
cd "C:\Users\jpbeal\Box\Econ 388\econ388_tech_growth"

* Ensure that we have the data
capture confirm file "cleaned_data.dta"
if _rc {
	do "stata_code\data_cleaning.do"
}

* Load the cleaned data
use cleaned_data, clear


* Create varlists for technology and control variables
local g_tech g_cellphone g_ag_tractor g_bed_hosp g_vehicle_car g_eft
local controls avh hc pop pctivliteracy
local g_controls g_avh g_hc g_pop g_pctivliteracy


* Run simple regression with all variables
// Bare model
reg g_gdp_per_cap `g_tech', robust
test `g_tech'

// Controlling variables
reg g_gdp_per_cap `g_tech' `g_controls', robust
test `g_tech'

// Controlling for developed
reg g_gdp_per_cap `g_tech' developed, robust
test `g_tech'

// Controlling for both
reg g_gdp_per_cap `g_tech' `g_controls' developed, robust
test `g_tech'

// Controlling for both and time
reg g_gdp_per_cap `g_tech' `g_controls' developed year, robust
test `g_tech'

gen year2 = year^2

// Controlling for vars and time by developed
reg g_gdp_per_cap `g_tech' `g_controls' year if developed==0, robust
test `g_tech'
reg g_gdp_per_cap `g_tech' `g_controls' year if developed==1, robust
test `g_tech'

* Modeling interaction effects
local g_interaction
foreach var in `g_tech' {
	gen dev_`var' = developed * `var'
	local g_interaction `g_interaction' dev_`var'
}

* Regression on interaction effects
reg g_gdp_per_cap `g_tech' `g_controls' `g_interaction', robust


* Rerun regressions and output to latex file
eststo model1: reg g_gdp_per_cap `g_tech', robust
eststo model2: reg g_gdp_per_cap `g_tech' `g_controls', robust
eststo model3: reg g_gdp_per_cap `g_tech' `g_controls' developed, robust
eststo model4: reg g_gdp_per_cap `g_tech' `g_controls' developed year, robust

esttab model1 model2 model3 model4 using normal_reg.tex, replace ///
    se star(* 0.10 ** 0.05 *** 0.01) ///
    label title("Effect of Technology Growth on GDP per Capita Growth") ///
    alignment(D{.}{.}{-1}) ///
    compress

eststo model5: reg g_gdp_per_cap `g_tech' `g_controls' year if developed==0, robust
eststo model6: reg g_gdp_per_cap `g_tech' `g_controls' year if developed==1, robust
eststo model7: reg g_gdp_per_cap `g_tech' `g_controls' developed `g_interaction' year, robust

esttab model5 model6 model7 using by_developed.tex, replace ///
	se star(* 0.10 ** 0.05 *** 0.01) ///
	label title("Effect of Technology Growth on GDP per Capita Growth by Developed") ///
    alignment(D{.}{.}{-1}) ///
    compress
	
save cleaned_data.dta, replace

cap log close