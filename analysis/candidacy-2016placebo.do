do preamble-2016data

preserve

rename atleast1demwomanchallenger atLeast1DemWomanChallenger
rename atleast1repwomanchallenger atLeast1RepWomanChallenger
rename repincumbent repIncumbent
rename manincumbent manIncumbent
rename demincumbent demIncumbent

* Aggregate tweets up to district level
#delimit ;	
collapse 	(first) atLeast1DemWomanChallenger atLeast1RepWomanChallenger
			(first) state 
			(first) repIncumbent manIncumbent demIncumbent
			(mean) 	white_pct black_pct hispanic_pct 
			(mean) 	foreignborn_pct female_pct 
			(mean) 	age29andunder_pct age65andolder_pct 
			(mean) 	median_hh_inc clf_unemploy_pct 
			(mean) 	lesshs_pct college_pct rural_pct
			(sum) 	rephouse14 totalhouse14 
			(sum) 	reppresvotes2012 totalpresvotes2012
			(sum) 	reppresvotes2008 totalpresvotes2008
			(sum) 	population votingPopulation tweets, by(district)
	;
#delimit cr
count

******** Compute shares of votes for past elections ********
* 2014 House elections (analogous to 2016 House in the 2018 analysis)
gen repHouse14Share = (rephouse14 / totalhouse14) * 100
label variable repHouse14Share 		"Vote share of Rep. party in 2014 House elections"

* Past Presidential elections (use 2012 as main, 2008 for change)
gen repPres12Share = (reppresvotes2012 / totalpresvotes2012) * 100
label variable repPres12Share 		"Vote share of Rep. Pres. candidate in 2012"

gen repPres08Share = (reppresvotes2008 / totalpresvotes2008) * 100
label variable repPres08Share 		"Vote share of Rep. Pres. candidate in 2008"

gen repPres2008to2012change = repPres12Share - repPres08Share
label variable repPres2008to2012change "Change in share of republican vote in the presidential elections from 2008-2012"

* Gen log of tweets density (using 2018 tweets as placebo)
gen lnTweetsToPop = ln( (tweets + 1) / population)
label variable lnTweetsToPop "Log of ratio of no. of tweets containing #metoo to population in district in 2018"

***************************************************************************************************
* Turnout data
* Turnout at the 2012 Presidential elections
gen turnoutPres12 = (totalpresvotes2012 / votingPopulation) * 100
replace turnoutPres12 = 100 if turnoutPres12 > 100 & ~missing(votingPopulation)
label variable turnoutPres12 "Percentage district turnout at the 2012 Presidential elections"

* Turnout at the 2008 Presidential elections
gen turnoutPres08 = (totalpresvotes2008 / votingPopulation) * 100
replace turnoutPres08 = 100 if turnoutPres08 > 100 & ~missing(votingPopulation)
label variable turnoutPres08 "Percentage district turnout at the 2008 Presidential elections"

* Turnout at the 2014 House elections
gen turnoutHouse14 = (totalhouse14 / votingPopulation) * 100
replace turnoutHouse14 = 100 if turnoutHouse14 > 100 & ~missing(votingPopulation)
label variable turnoutHouse14 "Percentage district turnout at the 2014 House elections"

* Define global variable lists
global presX 	repPres12Share repPres2008to2012change turnoutPres12
global houseX 	turnoutHouse14 repHouse14Share

gen repManIncumbent = repIncumbent * manIncumbent
gen demManIncumbent = demIncumbent * manIncumbent

#delimit ;	
global census 
	population
	white_pct black_pct hispanic_pct 
	foreignborn_pct female_pct 
	age29andunder_pct age65andolder_pct 
	median_hh_inc clf_unemploy_pct 
	lesshs_pct college_pct 
	rural_pct;
#delimit cr

* center at mean so incumbent indicators are interpretable
qui su lnTweetsToPop
replace lnTweetsToPop = lnTweetsToPop - r(mean)

capture program drop PostEstAdds
program define PostEstAdds
    quietly {
        // Basic table info
        estadd local nobs    "\multicolumn{1}{c}{$ `e(N)' $}"
        estadd local StateFE "\multicolumn{1}{c}{$ X $}"
        estadd local censusX "\multicolumn{1}{c}{$ X $}"

        // Joint F-test of electoral covariates
        testparm $houseX $presX
    }
    TestStatSig r(F) r(p)
    quietly estadd local elec_F   "\multicolumn{1}{c}{$ F = `r(StatStars)' $}"

    quietly {
        // Joint F-test of census covariates
        testparm $census
    }
    TestStatSig r(F) r(p)
    quietly estadd local census_F "\multicolumn{1}{c}{$ F = `r(StatStars)' $}"
end

eststo clear
eststo: reghdfe atLeast1RepWomanChallenger i.repManIncumbent##c.lnTweetsToPop $houseX $presX $census, absorb(state) cluster(state)
	PostEstAdds

eststo: reghdfe atLeast1RepWomanChallenger i.demManIncumbent##c.lnTweetsToPop $houseX $presX $census, absorb(state) cluster(state)
	PostEstAdds

eststo: reghdfe atLeast1DemWomanChallenger i.repManIncumbent##c.lnTweetsToPop $houseX $presX $census, absorb(state) cluster(state)
	PostEstAdds

eststo: reghdfe atLeast1DemWomanChallenger  i.demManIncumbent##c.lnTweetsToPop $houseX $presX $census, absorb(state) cluster(state)
	PostEstAdds
restore


*==================================================================================================
#delimit ;	
local esttab_options "b(%9.3fc)
					 se(%9.3fc)
					 star (* 0.1 ** 0.05 *** 0.01)
					 obslast
					 noomitted
					 varwidth(20)
					 modelwidth(8)
					 interaction(*)
					 nobaselevels
					 ";	
					 
local keep_coeff    "
                    lnTweetsToPop
                    1.repManIncumbent
                    1.demManIncumbent
                    1.repManIncumbent#c.lnTweetsToPop
                    1.demManIncumbent#c.lnTweetsToPop
                    " ; 
                    
local coeff_labels  "
                    lnTweetsToPop                        "Log tweet density"
                    1.repManIncumbent                    "Republican man incumbent"
                    1.demManIncumbent                    "Democratic man incumbent"
                    1.repManIncumbent#c.lnTweetsToPop    "Log tweet density $ \times $ (Republican man incumbent)"
                    1.demManIncumbent#c.lnTweetsToPop    "Log tweet density $ \times $ (Democratic man incumbent)"
                    " ;

esttab,
		booktabs replace fragment
	    keep(`keep_coeff') ///
		order(`keep_coeff')
		coeflabel(`coeff_labels') 
		`esttab_options'
		alignment(D{.}{.}{-1})
		title()
	nomtitles noobs nonotes nolines nonumber nogap
	compress;

esttab  using ../ms/tables/candidacy-2016.tex,
		booktabs replace fragment
		keep(`keep_coeff')
		order(`keep_coeff')
		coeflabel(`coeff_labels') 
		`esttab_options' 		
		scalars("StateFE State fixed effects"
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

