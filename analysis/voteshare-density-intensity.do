eststo clear
*==================================================================
capture program drop voteshare_density_intensity
program define voteshare_density_intensity
    syntax, measure(string)
    
    cap drop mtt

    * Determine which tweet variable to use
    if "`measure'" == "density" {
        gen mtt = s_lnTweetsToPop
        local store_name "table1_density"
    }
    else if "`measure'" == "intensity" {
        gen mtt = s_lnTweets
        local store_name "table1_intensity"
    }
    else {
        di as error "measure() must be 'density' or 'intensity'"
        exit 198
    }
    
    * Run regression
    reghdfe share2pty ($pg)#(c.mtt##c.repPresShare16) $pg $X2pty if ~independent, ///
        absorb(politician) cluster(politician)
    
    * Store estimates
    estimates store `store_name'
end


*==================================================================
preserve
global pg           1.rman 1.rwoman 1.dman 1.dwoman
global census c.population c.white_pct c.black_pct c.hispanic_pct c.foreignborn_pct c.female_pct c.age29andunder_pct c.age65andolder_pct c.median_hh_inc c.clf_unemploy_pct c.lesshs_pct c.college_pct c.rural_pct i.ruralUrban
global censusX      (i.republican)##($census)
global raceGender   i.woman##c.female_pct i.np1_white##c.white_pct i.np1_black##c.black_pct i.np1_hispanic##c.hispanic_pct i.np1_others##c.other_pct
global elec2ptyX    i.republican##(c.repHouse2ptyShare16 c.repPres2ptyShare12)
global X2pty        $elec2ptyX 1.republican#c.repPres2ptyShare16 $censusX $raceGender

gen man = 1 - woman
gen rman = man * republican
gen dman = man * democrat
gen rwoman = woman * republican
gen dwoman = woman * democrat
replace repPres2ptyShare16 = repPres2ptyShare16 - 50
replace repPresShare16 = repPres2ptyShare16

foreach var in lnTweetsToPop lnTweets {
    egen s_`var' = std(`var')
}

assert_macros "pg censusX raceGender elec2ptyX X2pty"

eststo clear
voteshare_density_intensity, measure(density)
voteshare_density_intensity, measure(intensity)

*==================================================================
#delimit ;  
local esttab_options "b(%9.3fc)
                     se(%9.3fc)
                     star (* 0.1 ** 0.05 *** 0.01)
                     obslast
                     noomitted
                     modelwidth(9)
                     interaction(*)
                     "; 
local keep_coeff    "
                    1.rwoman#c.mtt
                    1.dwoman#c.mtt
                    1.rman#c.mtt
                    1.dman#c.mtt
                    1.rwoman#c.mtt#c.repPresShare16
                    1.dwoman#c.mtt#c.repPresShare16
                    1.rman#c.mtt#c.repPresShare16
                    1.dman#c.mtt#c.repPresShare16
                    "; 

local coeff_labels  "
                    1.rwoman#c.mtt    "MeToo tweets $ \times $ (Rep. woman)"
                    1.dwoman#c.mtt    "MeToo tweets $ \times $ (Dem. woman)"
                    1.rman#c.mtt      "MeToo tweets $ \times $ (Rep. man)"
                    1.dman#c.mtt      "MeToo tweets $ \times $ (Dem. man)"
                    
                    1.rwoman#c.mtt#c.repPresShare16       "MeToo tweets $ \times $ (Pres. 2016 Rep. vote share) $ \times $ (Rep. woman)"
                    1.dwoman#c.mtt#c.repPresShare16       "MeToo tweets $ \times $ (Pres. 2016 Rep. vote share) $ \times $ (Dem. woman)"
                    1.rman#c.mtt#c.repPresShare16         "MeToo tweets $ \times $ (Pres. 2016 Rep. vote share) $ \times $ (Rep. man)  "
                    1.dman#c.mtt#c.repPresShare16         "MeToo tweets $ \times $ (Pres. 2016 Rep. vote share) $ \times $ (Dem. man)  " 
                    ";                    

esttab table1_density table1_intensity,
        booktabs replace fragment
        keep(`keep_coeff')
        order(`keep_coeff')
        coeflabel(`coeff_labels')
        `esttab_options'
        alignment(D{.}{.}{-1})
        title()
    nomtitles noobs nonotes nolines nonumber nogap
    compress;

esttab  table1_density table1_intensity
        using ../ms/tables/voteshare-density-intensity.tex, 
        booktabs replace fragment
        keep(`keep_coeff')
        order(`keep_coeff')
        coeflabel(`coeff_labels')
        `esttab_options'
        alignment(D{.}{.}{-1})
        title()
    nomtitles noobs nonotes nolines nonumber nogap
    compress;

#delimit cr             

restore



