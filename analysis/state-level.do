set scheme s2color
grstyle init
grstyle set plain

collapse (sum) tweets repHouse18 demHouse18, by(stateID)

gen lnT = ln(tweets + 1)
gen repStateHouse2ptyShare18 = (repHouse18 / (repHouse18 + demHouse18)) * 100

* State-level regression — annotation on the scatter reports these
qui reg repStateHouse2ptyShare18 lnT, r
local coeff: display %5.3f _b[lnT]
local se:    display %5.3f _se[lnT]
local t:     display %5.2f (_b[lnT] / _se[lnT])
local r2:    display %5.3f e(r2)

#delimit ;
twoway  (lfitci repStateHouse2ptyShare18 lnT,
            color(gs15*0.8))
        (lfitci repStateHouse2ptyShare18 lnT,
            ciplot(rline) lcolor(eltblue*1.5) lpattern(shortdash) lwidth(thin))
        (scatter repStateHouse2ptyShare18 lnT,
            mlabel(stateID) mlabposition(12) mcolor(ebblue*1.8) msymbol(o)),
        xtitle(MeToo tweet density (log))
        ytitle(Republican House 2018 Vote Share)
        ylabel(20 40 60 80, grid glcolor(gs15*0.3))
        plotregion(style(none))
        text(19 5.9 "coeff=`coeff', (robust) std. error=`se', t=`t'. R-squared=`r2'",
            placement(ne) size(small))
        legend(off)
        ;
#delimit cr

savefig, path(../ms/figures/state-level) format(png pdf) override(width(1000))
