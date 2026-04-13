set scheme s2color
grstyle init
grstyle set plain

import delimited "./data/cawp.csv", clear

gen house_losers  = housecandidates  - housewinners
gen senate_losers = senatecandidates - senatewinners

local winnerColor ebblue*2
local totalColor  eltblue*1.4

#delimit ;
graph bar housewinners house_losers,
    over(year, lab(nolab))
    stack
    bar(1, fcolor(`winnerColor')) bar(2, fcolor(`totalColor'))
    legend(order(1) label(1 "Elected into House")
            ring(0) position(10) textfirst)
    nodraw name(g1, replace);
#delimit cr

#delimit ;
graph bar senatewinners senate_losers,
    over(year, label(angle(50)))
    stack
    bar(1, fcolor(`winnerColor')) bar(2, fcolor(`totalColor'))
    legend(order(1) label(1 "Elected into Senate")
            ring(0) position(10) textfirst)
    nodraw name(g2, replace);
#delimit cr

graph combine g1 g2, row(2) graphregion(color(white) margin(zero)) plotregion(margin(zero))

savefig, path(../ms/figures/cawp) format(png pdf) override(width(1000))
