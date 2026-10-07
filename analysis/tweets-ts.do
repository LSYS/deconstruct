set scheme s2color
grstyle init
grstyle set plain

import delimited "./data/tweets-ts-day-nan.csv", clear

gen ln_global = ln(globaltweetcount)
gen ln_us     = ln(identifiedustweetcount)

* Convert date
gen date1 = date(date, "YMD")
drop date
rename date1 date
format date %td
tsset date

local globalColor ebblue*1.8
local UScolor     eltblue*1.8

* Background bands marking key events
gen hearing = 12 if date >= td(04sep2018) & date <= td(27sep2018)
gen cosby   = 12 if date >= td(2apr2018)  & date <= td(26apr2018)
gen primary = 12 if date >= td(5june2018) & date <= td(26june2018)

#delimit ;
twoway  (bar hearing date,  bcolor(gs15))
        (bar primary date,  bcolor(gs15))
        (connected ln_global date, cmissing(no) sort lwidth(thin) lcolor(gs7) lpattern(shortdash) msymbol(o) msize(small) mlwidth(vthin) mcolor(`globalColor'))
        (connected ln_us date, sort cmissing(no) lwidth(thin) msymbol(dh) msize(medsmall) mlwidth(vthin) mcolor(`UScolor'))
        ,
    tlabel(20jan2018 5jun2018 4sep2018 27sep2018 6nov2018, angle(50) labsize(small))
    tmlabel(7jan2018 28jan2018 25feb2018 4mar2018 16apr2018 16apr2018 26april2018 10may2018 25may2018 6jul2018
            27jul2018 20aug2018 16sep2018,
        angle(50) labsize(vsmall))

    tline(7jan2018 28jan2018 25feb2018 4mar2018 10may2018 25may2018 16apr2018 26april2018 6jul2018 27jul2018 20aug2018 16sep2018
            , lwidth(vvthin) lpattern("#-.....-") lcolor(gs12))
    tline(20jan2018 6nov2018
            , lwidth(vthin) lpattern("_-.-") lcolor(red*1.75))
    ttext(10.9 17jan2018 "Women's March", orientation(vertical) size(small))
    ttext(10.7 3nov2018 "2018 Midterm Elections", orientation(vertical) size(small))
    ttext(11.6 16sep2018 "Brett", size(small))
    ttext(11.4 16sep2018 "Kavanaugh", size(small))
    ttext(11.2 15sep2018 "Confirmation", size(small))
    ttext(11.0 16sep2018 "Hearings", size(small))
    ttext(10.1 15jun2018 "2018 U.S.", size(small))
    ttext(9.9 15jun2018 "Primary", size(small))
    ttext(9.7 15jun2018 "Elections", size(small))
    ylabel(5 8 11, glcolor(gs14) glwidth(vvthin) angle(horizontal) labsize(vsmall) nogrid)
    xtitle("")
    legend( order(3 "Global" 4 "Matched to U.S. counties")
            ring(0) position(4) cols(1) rowgap(0) symxsize(10) keygap(0.5) size(small) symysize(2) bmargin(tiny) margin(1 6 1 1) region(lstyle(major_grid)))
    graphregion(margin(0 1 0 0) color(white))
    plotregion(margin(zero))
    scheme(s2mono);
#delimit cr

savefig, path(../ms/figures/tweets-ts) format(png pdf) override(width(1000))
