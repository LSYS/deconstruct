import delimited "./data/tweets-ts-day-2016to18-nan.csv", clear

gen ln_global = ln(tweets)

* Convert date
gen date1 = date(date, "YMD")
drop date
rename date1 date
format date %td
tsset date

local globalColor ebblue*1.8

#delimit ;
twoway  (connected ln_global date, cmissing(no) sort lwidth(vvthin) msymbol(o) msize(small) mlwidth(vvthin) mcolor(`globalColor')) ,
    tlabel(8nov2016 21jan2017 16oct2017 6nov2018, angle(35) labsize(small))
    tmlabel(1jan2016 1jan2017 1jan2018,
        angle(35) labsize(vsmall))
    tline(1jan2016 1jan2017 1jan2018
        , lwidth(vvthin) lpattern(shortdash_dot) lcolor(black*0.6))
    tline(8nov2016 21jan2017 16oct2017 6nov2018
        , lwidth(thin) lpattern("_-.-") lcolor(red*1.75))
    xtitle("") ytitle("")
    ylabel(5 8 11, glcolor(gs14) glwidth(vvthin) angle(horizontal) labsize(vsmall) nogrid)
    ttext(11.1 26oct2016 "2016 elections"
          10.7 8jan2017 "1st Women's march"
          9.26 3oct2017 "Birth of MeToo movement on Twitter"
          11.1 25oct2018 "2018 elections"
            , orientation(vertical) size(small))
    graphregion(margin(2 1 0 1) color(white))
    plotregion(margin(zero))
    ;
#delimit cr

savefig, path(../ms/figures/tweets-ts-2016to18) format(png pdf) override(width(1000))
