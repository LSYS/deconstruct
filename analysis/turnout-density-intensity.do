eststo clear
*==================================================================
capture program drop turnout_density_intensity
program define turnout_density_intensity
    syntax, measure(string)
    
    cap drop mtt

    * Determine which tweet variable to use
    if "`measure'" == "density" {
        gen mtt = s_lnTweetsToPop
        local store_name "table3_density"
    }
    else if "`measure'" == "intensity" {
        gen mtt = s_lnTweets
        local store_name "table3_intensity"
    }
    else {
        di as error "measure() must be 'density' or 'intensity'"
        exit 198
    }
    
    * Run regression
    areg dlnHouse18_16 c.mtt c.mtt#c.repPres2ptyShare16 ///
        $controls, robust cluster(state) absorb(state)
    
    * Store estimates
    estimates store `store_name'
end

*==================================================================
preserve
collapse (first) votes-countyName stateid_str-turnoutPres12, by(county)

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

global elec2X repPres2ptyShare16 repPres2ptyShareChange12to16 repHouse2ptyShare16
global controls `census' $elec2X turnoutPres16 turnoutHouse16 $dcensus

gen dlnHouse18_16 = ln(totalHouse18) - ln(totalHouse16)
replace repPres2ptyShare16 = repPres2ptyShare16 - 50

foreach var in lnTweetsToPop lnTweets {
    egen s_`var' = std(`var')
}

assert_macros "elec2X dcensus controls"

eststo clear
turnout_density_intensity, measure(density)
turnout_density_intensity, measure(intensity)


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
                     
local keep_coeff    "
                    mtt
                    repPres2ptyShare16
                    c.mtt#c.repPres2ptyShare16
                    ";  
                    
local coeff_labels  "
                    mtt                           "MeToo tweets"
                    repPres2ptyShare16            "Pres. 2016 Republican vote share"
                    c.mtt#c.repPres2ptyShare16    "MeToo tweets $ \times $ (Pres. 2016 Republican vote share)"
                    ";
#delimit cr

#delimit ;      
esttab table3_density table3_intensity,
        keep(`keep_coeff')
        order(`keep_coeff')
        coeflabel(`coeff_labels') 
        `esttab_options'           
        alignment(D{.}{.}{-1})
        title()
    nomtitles noobs nonotes nolines nonumber nogap
    compress;

esttab table3_density table3_intensity 
        using ../ms/tables/turnout-density-intensity.tex, 
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
