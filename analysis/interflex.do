tictoc tic 1
preserve

do preamble-candidacy

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
set scheme s2color
grstyle init
grstyle set plain
if c(stata_version) >= 15 {
    grstyle set ci
}


*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Rep man incumbent
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Renaming to y b/c otherwise i get this error
// _tmp_dm_atLeast1DemWomanChallenger invalid name
//                  stata():  3598  Stata returned error
//          fixed_effects():     -  function returned error
//                  <istmt>:     -  function returned error
// r(3598);
gen y = atLeast1DemWomanChallenger
local y y
local d repManIncumbent

assert_macros "houseX presX census"


* Run binning estimator and store Wald test stat
#delimit;
interflex `y' `d' lnTweetsToPop  
	$houseX $presX $census 
	,type(binning) fe(state) cluster(state) nbins(5)
;
#delimit cr
local pwald = round(`r(pwald)', 0.001) 

* Run reg and store estimate
reghdfe `y'  i.`d'##c.lnTweetsToPop $houseX $presX $census, absorb(state) cluster(state)
get_pval _b[1.`d'#c.lnTweetsToPop] _se[1.`d'#c.lnTweetsToPop] e(df_r) 0.001
local pval `r(pval)'

local var_coef = round(_b[1.`d'#c.lnTweetsToPop], 0.001)  
// local var_se = _se[1.`d'#c.lnTweetsToPop]
dis `var_coef'
dis `pval'
dis `pwald'

TestStatSigInterflex `var_coef' `pval'
local coef_print `r(StatStars)'

TestStatSigInterflex `pval' `pval'
local pval `r(StatStars)'

* Run Interflex for kernel
#delimit;
interflex `y' `d' lnTweetsToPop  
	$houseX $presX $census 
	,type(kernel) fe(state) cluster(state)
;
#delimit cr

* Hist. Rep to maroon (bottom/treated class/stack)
gr_edit .plotregion1.plot4.style.editstyle area(shadestyle(color(maroon))) editcopy
gr_edit .plotregion1.plot4.style.editstyle area(shadestyle(intensity(inten50))) editcopy

* Hist. Dem. to maroon (top class/stack)
gr_edit .plotregion1.plot3.style.editstyle area(shadestyle(color(gs10))) editcopy
gr_edit .plotregion1.plot3.style.editstyle area(shadestyle(intensity(inten50))) editcopy

* Set margins
gr_edit .style.editstyle margin(zero) editcopy
gr_edit .plotregion1.style.editstyle margin(zero) editcopy


* Set x axis 
gr_edit .xaxis1.reset_rule -9 -5 1 , tickset(major) ruletype(range) 
gr_edit .yaxis1.reset_rule -.5 1 .5 , tickset(major) ruletype(range) 

* Change xtitle to graph title on top
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Log Tweet Density
gr_edit .xaxis1.title.style.editstyle size(medlarge) editcopy

* Set y reference line
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(width(thick)) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(pattern(dash)) editcopy
gr_edit .plotregion1._xylines[1]

* Change ytitle to graph title on top
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush `"Marginal Effect of Rep. Man Incumbent"'
gr_edit .yaxis1.title.text.Arrpush `"  on Pr(Dem. Woman Challenger)"'

// * Add coef reports
// gr_edit .plotregion1.AddTextBox added_text editor -.080703056704013 -5
// gr_edit .plotregion1.added_text[1].text = {}
// gr_edit .plotregion1.added_text[1].text.Arrpush {bf:{&beta}=`coef_print'}
// gr_edit .plotregion1.added_text[1].style.editstyle size(medlarge) editcopy
// gr_edit .plotregion1.added_text[2].text.Arrpush {bf:Wald (p-val): `pwald'}

// gr_edit .plotregion1.AddTextBox added_text editor -.20703056704013 -5.5
// gr_edit .plotregion1.added_text[2].text = {}
// gr_edit .plotregion1.added_text[2].text.Arrpush {bf:Wald test: {it:p} = `pwald'}

savefig, path(../ms/figures/atLeast1DemWomanChallenger-`d') format(png pdf) override(width(1000))



*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Dem man incumbent
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local d demManIncumbent

* Run binning estimator and store Wald test stat
#delimit;
interflex `y' `d' lnTweetsToPop  
	$houseX $presX $census 
	,type(binning) fe(state) cluster(state) nbins(5) 
;
#delimit cr
local pwald = round(`r(pwald)', 0.001) 

* Run reg and store estimate
reghdfe `y'  i.`d'##c.lnTweetsToPop $houseX $presX $census, absorb(state) cluster(state)
get_pval _b[1.`d'#c.lnTweetsToPop] _se[1.`d'#c.lnTweetsToPop] e(df_r) 0.001
local pval `r(pval)'

local var_coef = round(_b[1.`d'#c.lnTweetsToPop], 0.001)  
// local var_se = _se[1.`d'#c.lnTweetsToPop]
dis `var_coef'
dis `pval'

TestStatSigInterflex `var_coef' `pval'
local coef_print `r(StatStars)'

* Run Interflex for kernel
#delimit;
interflex `y' `d' lnTweetsToPop  
	$houseX $presX $census 
	,type(kernel) fe(state) cluster(state) 
;
#delimit cr

* Hist. Rep to maroon (bottom/treated class/stack)
gr_edit .plotregion1.plot4.style.editstyle area(shadestyle(color(navy))) editcopy
gr_edit .plotregion1.plot4.style.editstyle area(shadestyle(intensity(inten80))) editcopy

* Hist. Dem. to maroon (top class/stack)
gr_edit .plotregion1.plot3.style.editstyle area(shadestyle(color(gs10))) editcopy
gr_edit .plotregion1.plot3.style.editstyle area(shadestyle(intensity(inten80))) editcopy

* Change ytitle to graph title on top
gr_edit .yaxis1.title.text = {}
gr_edit .title.text.Arrpush `"Marginal Effect of Dem. Man Incumbent"'
gr_edit .title.text.Arrpush `"  on Pr(Dem. Woman Challenger)"'
gr_edit .title.style.editstyle horizontal(left) editcopy
gr_edit .title.style.editstyle box_alignment(nwest) editcopy

* Change xtitle to graph title on top
gr_edit .xaxis1.title.text.Arrpush Log Tweet Density

* Set y reference line
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(width(thick)) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(pattern(dash)) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(color(gs10)) editcopy

* Coef line + CI
gr_edit .plotregion1.plot2.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(width(thick)) editcopy
// gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs14))) editcopy
// gr_edit .plotregion1.plot1.style.editstyle area(shadestyle(intensity(inten40))) editcopy

* Set axis label sizes and title
gr_edit .yaxis1.style.editstyle majorstyle(tickstyle(textstyle(size(medlarge)))) editcopy
gr_edit .xaxis1.style.editstyle majorstyle(tickstyle(textstyle(size(medlarge)))) editcopy
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Log Tweet Density
gr_edit .xaxis1.title.style.editstyle size(medlarge) editcopy

* Set margins
gr_edit .style.editstyle margin(zero) editcopy
gr_edit .plotregion1.style.editstyle margin(zero) editcopy

* Set x axis 
gr_edit .xaxis1.reset_rule -9 -5 1 , tickset(major) ruletype(range) 

* Set y axis labels
gr_edit .yaxis1.reset_rule -1 .5 .5 , tickset(major) ruletype(range) 

// * Add coef reports
// gr_edit .plotregion1.AddTextBox added_text editor -.080703056704013 -9.25
// gr_edit .plotregion1.added_text[1].text = {}
// gr_edit .plotregion1.added_text[1].text.Arrpush {bf:{&beta}=`coef_print'}
// gr_edit .plotregion1.added_text[1].style.editstyle size(medlarge) editcopy

// gr_edit .plotregion1.AddTextBox added_text editor -.20703056704013 -5.5
// gr_edit .plotregion1.added_text[2].text = {}
// gr_edit .plotregion1.added_text[2].text.Arrpush {bf:Wald test: {it:p} = `pwald'}

savefig, path(../ms/figures/atLeast1DemWomanChallenger-`d') format(png pdf) override(width(1000))
restore
tictoc toc 1
beepme 3
