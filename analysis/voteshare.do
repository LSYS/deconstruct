
*==================================================================================================
global mainInteract	c.lnTweetsToPop#c.repPresShare16 c.lnTweetsToPop c.repPresShare16
global gender		1.woman 1.man
global pty			1.republican 1.independent 1.democrat
global pg 			1.rman 1.rwoman 1.dman 1.dwoman 1.iwoman 1.iman

global censusX 		(i.republican)##($census)
global raceGender 	i.woman##c.female_pct i.np1_white##c.white_pct i.np1_black##c.black_pct i.np1_hispanic##c.hispanic_pct i.np1_others##c.other_pct
global elecX		($pty)##(c.repHouseShare16 c.repPresShare12 c.repPresShare16)
global X			$elecX $censusX $raceGender

global elec2ptyX	i.republican##(c.repHouse2ptyShare16 c.repPres2ptyShare12 c.repPres2ptyShare16)
global X2pty		$elec2ptyX $censusX $raceGender

gen man = 1 - woman
gen rman = man * republican
gen dman = man * democrat
gen rwoman = woman * republican
gen dwoman = woman * democrat
gen iwoman = woman * independent
gen iman = man * independent

preserve
* Centering Rep. vote share
replace repPres2ptyShare16 = repPres2ptyShare16 - 50
replace repPresShare16 = repPresShare16 - 50	
*==================================================================================================
* Party + Gender	
#delimit ;	
local esttab_options "b(%9.3fc)
					 se(%9.3fc)
					 star (* 0.1 ** 0.05 *** 0.01)
					 obslast
					 noomitted
					 modelwidth(9)
					 interaction(*)
					 ";	
local keep_coeff 	"
					1.rwoman#c.lnTweetsToPop
					1.dwoman#c.lnTweetsToPop
					1.rman#c.lnTweetsToPop
					1.dman#c.lnTweetsToPop
					1.rwoman#c.lnTweetsToPop#c.repPresShare16
					1.dwoman#c.lnTweetsToPop#c.repPresShare16
					1.rman#c.lnTweetsToPop#c.repPresShare16
					1.dman#c.lnTweetsToPop#c.repPresShare16
					";

local coeff_labels 	"
					1.rwoman#c.lnTweetsToPop	"Log tweet density $ \times $ (Rep. woman)"
					1.dwoman#c.lnTweetsToPop	"Log tweet density $ \times $ (Dem. woman)"
					1.rman#c.lnTweetsToPop		"Log tweet density $ \times $ (Rep. man)"
					1.dman#c.lnTweetsToPop		"Log tweet density $ \times $ (Dem. man)"
					
					1.rwoman#c.lnTweetsToPop#c.repPresShare16		"Log tweet density $ \times $ (Pres. 2016 Rep. vote share) $ \times $ (Rep. woman)"
					1.dwoman#c.lnTweetsToPop#c.repPresShare16		"Log tweet density $ \times $ (Pres. 2016 Rep. vote share) $ \times $ (Dem. woman)"
					1.rman#c.lnTweetsToPop#c.repPresShare16			"Log tweet density $ \times $ (Pres. 2016 Rep. vote share) $ \times $ (Rep. man)  "
					1.dman#c.lnTweetsToPop#c.repPresShare16			"Log tweet density $ \times $ (Pres. 2016 Rep. vote share) $ \times $ (Dem. man)  " 
					";					
#delimit cr	
*==================================================================================================

assert_macros "pg X elecX censusX census raceGender mainInteract X2pty pty"

eststo clear
VoteShareRegressions
restore

#delimit;					 
esttab, 
	keep(`keep_coeff')
	order(`keep_coeff')
	coeflabel(`coeff_labels') 
	`esttab_options'
	varwidth(80)
compress
;			 

esttab  using ../ms/tables/voteshare.tex, 
		booktabs replace fragment
		keep(`keep_coeff')
		order(`keep_coeff')
		coeflabel(`coeff_labels') 
		`esttab_options' 		
		scalars("dummyLine \emph{Control variables}"
				"candidateFE	\hspace{1em}Candidate fixed effects"
				"elecX \hspace{1em}2016 House \& 2012--16 Pres. election"
				"censusX \hspace{1em}County census demographics"
				"raceGenderX \hspace{1em}Racial \& gender voting"	
				"elec_F $ F $-test: House \& 2012--16 Pres. election = 0"								
				"census_F $ F $-test: Census controls = 0"								
				"raceGender_F $ F $-test: Racial \& gender voting = 0"	
				"twoPty Main-party candidates only"
				"r2 $ R^2 $"
				"nobs $ N $")	
		alignment(D{.}{.}{-1})
	nomtitles 
	compress nolines nonumber nogap noobs
	nonotes;			 
#delimit cr
