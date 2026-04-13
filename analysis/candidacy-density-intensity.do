eststo clear
*==================================================================
capture program drop candidacy_density_intensity
program define candidacy_density_intensity
    syntax, measure(string)

    cap drop mtt
    
    * Determine which tweet variable to use
    if "`measure'" == "density" {
        gen mtt = s_lnTweetsToPop
        local store_name "table2_density"
    }
    else if "`measure'" == "intensity" {
        gen mtt = s_lnTweets
        local store_name "table2_intensity"
    }
    else {
        di as error "measure() must be 'density' or 'intensity'"
        exit 198
    }
    
    * Run regression
    reghdfe atLeast1DemWomanChallenger i.demManIncumbent##c.mtt ///
        $houseX $presX $census, absorb(state) cluster(state)
    
    * Store estimates
    estimates store `store_name'
end

*==================================================================
preserve
#delimit ;  
collapse    (first) atLeast1DemWomanChallenger state openSeat womanIncumbent repIncumbent manIncumbent demIncumbent
            (mean)  white_pct black_pct hispanic_pct foreignborn_pct female_pct 
                    age29andunder_pct age65andolder_pct median_hh_inc clf_unemploy_pct lesshs_pct college_pct rural_pct
            (sum)   repHouse16 totalHouse16 totalHouse2pty16 repPres16 totalPres16 totalPres2pty16
                    repPres12 totalPres12 totalPres2pty12 population votingPopulation tweets, by(district);
#delimit cr

gen repPres16Share = (repPres16 / totalPres16) * 100
gen repPres12Share = (repPres12 / totalPres12) * 100
gen repShareChange = repPres16Share - repPres12Share
gen repHouse16Share = (repHouse16 / totalHouse16) * 100
gen turnoutPres16 = (totalPres16 / votingPopulation) * 100
replace turnoutPres16 = 100 if turnoutPres16 > 100 & ~missing(votingPopulation)
gen turnoutHouse16 = (totalHouse16 / votingPopulation) * 100
replace turnoutHouse16 = 100 if turnoutHouse16 > 100 & ~missing(votingPopulation)
cap gen repManIncumbent = repIncumbent * manIncumbent
gen demManIncumbent = demIncumbent * manIncumbent

global presX    repPres16Share repShareChange turnoutPres16
global houseX   turnoutHouse16 repHouse16Share
#delimit ;  
global census population white_pct black_pct hispanic_pct foreignborn_pct female_pct 
    age29andunder_pct age65andolder_pct median_hh_inc clf_unemploy_pct lesshs_pct college_pct rural_pct;
#delimit cr

gen lnTweetsToPop = ln((tweets + 1) / population)
gen lnTweets = ln(tweets + 1)

foreach var in lnTweetsToPop lnTweets {
    egen s_`var' = std(`var')
}

assert_macros "houseX presX census"

eststo clear
candidacy_density_intensity, measure(density)
candidacy_density_intensity, measure(intensity)

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
                    mtt
                    1.demManIncumbent
                    1.demManIncumbent#c.mtt
                    " ; 
                    
local coeff_labels  "
                    mtt                        "MeToo tweets"
                    1.demManIncumbent           "Democratic man incumbent"
                    1.demManIncumbent#c.mtt    "MeToo tweets $ \times $ (Democratic man incumbent)"
                    " ;

esttab table2_density table2_intensity,
        booktabs replace fragment
        keep(`keep_coeff') ///
        order(`keep_coeff')
        coeflabel(`coeff_labels') 
        `esttab_options'
        alignment(D{.}{.}{-1})
        title()
    nomtitles noobs nonotes nolines nonumber nogap
    compress;

esttab  table2_density table2_intensity
        using ../ms/tables/candidacy-density-intensity.tex, 
        booktabs replace fragment
        keep(`keep_coeff') ///
        order(`keep_coeff')
        coeflabel(`coeff_labels') 
        `esttab_options'
        alignment(D{.}{.}{-1})
        title()
    nomtitles noobs nonotes nolines nonumber nogap
    compress;

#delimit cr             


restore
