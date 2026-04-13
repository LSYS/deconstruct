tictoc tic 1
preserve

do preamble-candidacy

* center at mean so incumbent indicators are interpretable
qui su lnTweetsToPop
replace lnTweetsToPop = lnTweetsToPop - r(mean)
su lnTweetsToPop

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

assert_macros "houseX presX census"

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
                    1.demManIncumbent                    "Demomcratic man incumbent"
                    1.repManIncumbent#c.lnTweetsToPop    "Log tweet density $ \times $ (Republican man incumbent)"
                    1.demManIncumbent#c.lnTweetsToPop    "Log tweet density $ \times $ (Demomcratic man incumbent)"
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

esttab  using ../ms/tables/candidacy.tex,
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
