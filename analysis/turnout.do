*==================================================================================================
global elec2X 	repPres2ptyShare16 repPres2ptyShareChange12to16 repHouse2ptyShare16

preserve
#delimit;
collapse (first) 	
	votes-countyName 
	stateid_str-turnoutPres12
	, by(county);
#delimit cr

gen lpop = ln(population)
gen lpop19 = ln(population19)

gen lcvap = ln(cvap_pct*population)
gen lcvap19 = ln(cvap_pct19*population19)

#delimit ;
local census
	c.lpop
	c.lcvap
	c.white_pct c.black_pct c.hispanic_pct 
	c.foreignborn_pct c.female_pct 
	c.age29andunder_pct c.age65andolder_pct 
	c.median_hh_inc c.clf_unemploy_pct 
	c.lesshs_pct c.college_pct 
	c.rural_pct i.ruralUrban;
#delimit cr

#delimit;
local censusX 
	lpop
	lcvap
	white_pct black_pct hispanic_pct 
	foreignborn_pct female_pct 
	age29andunder_pct age65andolder_pct
	median_hh_inc clf_unemploy_pct lesshs_pct college_pct
	;
#delimit cr
global dcensus 
* Define demo change and create global macro for the variables
foreach var of varlist `censusX' {
	gen `var'1916 = `var'19 - `var'
	label var `var'1916 "`var'19 - `var'"
	global dcensus $dcensus `var'1916
}

gen dlnHouse18_16 = ln(totalHouse18) - ln(totalHouse16)
gen dlnHouse18_14 = ln(totalHouse18) - ln(totalHouse14)

global controls `census' $elec2X turnoutPres16 turnoutHouse16 $dcensus
local spec $controls, robust cluster(state) absorb(state)

assert_macros "elec2X dcensus controls"

replace repPres2ptyShare16 = repPres2ptyShare16 - 50
su repPres2ptyShare16

*==================================================================================================
capture program drop PostEstTurnout
program define PostEstTurnout
    quietly {
        // Basic table info
        estadd local nobs       "\multicolumn{1}{c}{$ `e(N)' $}"
        estadd local stateFE    "\multicolumn{1}{c}{$ X $}"
        estadd local censusX    "\multicolumn{1}{c}{$ X $}"
        
        // Joint F-test of electoral covariates
        testparm $elec2X turnoutPres16 turnoutHouse16
    }
    TestStatSig r(F) r(p)
    quietly estadd local elec_F "\multicolumn{1}{c}{$ F = `r(StatStars)' $}"
    
    quietly {
        // Joint F-test of census covariates
        testparm `census' $dcensus
    }
    TestStatSig r(F) r(p)
    quietly estadd local census_F "\multicolumn{1}{c}{$ F = `r(StatStars)' $}"
end
*==================================================================================================

eststo clear 
eststo: areg dlnHouse18_16 c.lnTweetsToPop 						  `spec'
PostEstTurnout
	
eststo: areg dlnHouse18_16 c.lnTweetsToPop##c.repPres2ptyShare16  `spec'
PostEstTurnout

eststo: areg dlnHouse18_14 c.lnTweetsToPop 						  `spec'
PostEstTurnout

eststo: areg dlnHouse18_14 c.lnTweetsToPop##c.repPres2ptyShare16  `spec'
PostEstTurnout
restore


*==================================================================================================
#delimit ;	
local esttab_options "b(%9.4fc)
					 se(%9.4fc)
					 star (* 0.1 ** 0.05 *** 0.01)
					 obslast
					 noomitted
					 varwidth(20)
					 modelwidth(8)
					 interaction(*)
					 nobaselevels
					 ";	
					 
local keep_coeff 	"
					lnTweetsToPop
					repPres2ptyShare16
					c.lnTweetsToPop#c.repPres2ptyShare16
					";	
					
local coeff_labels 	"
					lnTweetsToPop							"Log tweet density"
					repPres2ptyShare16						"Pres. 2016 Republican vote share"
					c.lnTweetsToPop#c.repPres2ptyShare16	"Log tweet density $ \times $ (Pres. 2016 Republican vote share)"
					";
#delimit cr


#delimit ;		
esttab,
		keep(`keep_coeff')
		order(`keep_coeff')
		coeflabel(`coeff_labels') 
		`esttab_options' 		
		scalars("stateFE State fixed effects"
				"censusX Census Control"
				"elec_F F-test: Electoral controls = 0"
				"census_F F-test: County census = 0"
				"r2 $ R^2 $"
				"nobs $ N $")		
		alignment(D{.}{.}{-1})
		title()
	nomtitles noobs nonotes nolines nonumber nogap
	compress;	
#delimit cr		

#delimit ;		
esttab  using ../ms/tables/turnout.tex,
		booktabs replace fragment
		keep(`keep_coeff')
		order(`keep_coeff')
		coeflabel(`coeff_labels') 
		`esttab_options' 		
		scalars("stateFE State fixed effects"
				"censusX Census Control"
				"elec_F F-test: Electoral controls = 0"
				"census_F F-test: County census = 0"
				"r2 $ R^2 $"
				"nobs $ N $")		
		alignment(D{.}{.}{-1})
		title()
	nomtitles noobs nonotes nolines nonumber nogap
	compress;	
#delimit cr		
