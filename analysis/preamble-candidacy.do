* Aggaregate tweets up to district level
#delimit ;	
collapse 	(first) atLeast1DemWomanChallenger atLeast1RepWomanChallenger
			(first) state 
			(first) openSeat womanIncumbent repIncumbent manIncumbent demIncumbent
			(mean) 	white_pct black_pct hispanic_pct 
			(mean) 	foreignborn_pct female_pct 
			(mean) 	age29andunder_pct age65andolder_pct 
			(mean) 	median_hh_inc clf_unemploy_pct 
			(mean) 	lesshs_pct college_pct rural_pct
			(sum) 	repHouse16 totalHouse16 totalHouse2pty16 repPres16 totalPres16 totalPres2pty16
			(sum) 	repPres12 totalPres12 totalPres2pty12
			(sum) 	population votingPopulation tweets, by(district)
	;
#delimit cr
count

******** Compute shares of votes for past elections as: #votes / #population of voting age ********
* Past Presidential elections
gen repPres16Share = (repPres16 / totalPres16) * 100
label variable repPres16Share 		"Vote share of Rep. Pres. candidate in 2016"

gen repPres16TwoPtyShare = (repPres16 / totalPres2pty16) * 100
label variable repPres16TwoPtyShare 	"Two-party vote share of Rep. Pres. candidate in 2016"

gen repPres12Share = (repPres12 / totalPres12) * 100
label variable repPres12Share 		"Vote share of Rep. Pres. candidate in 2012"

gen repPres12ShareTwoPty = (repPres12 / totalPres2pty12) * 100
label variable repPres12ShareTwoPty 	"Two-party Vote share of Rep. Pres. candidate in 2012"

gen repShareChange = repPres16Share - repPres12Share
label variable repShareChange 		"Change in share of republican vote in the presidential elections from 2012-2016"

gen repTwoPtyShareChange = repPres16TwoPtyShare - repPres12ShareTwoPty
label variable repTwoPtyShareChange "Change in two-party share of republican vote in the presidential elections from 2012-2016"

* 2016 House elections
gen repHouse16Share = (repHouse16 / totalHouse16) * 100
label variable repHouse16Share 		"Vote share of Rep. party in 2016 House elections"

gen twoPtyRepHouse16Share = (repHouse16 / totalHouse2pty16) * 100
label variable twoPtyRepHouse16Share "Two-party vote share of Rep. party in 2016 House elections"

* Gen log of tweets density
gen lnTweetsToPop = ln( (tweets + 1) / population)
label variable lnTweetsToPop "Log of ratio of no. of tweets containing #metoo to population in county in 2018"

***************************************************************************************************
* Turnout data
* Turnout at the 2016 Presidential elections
gen turnoutPres16 = (totalPres16 / votingPopulation) * 100
replace turnoutPres16 = 100 if turnoutPres16 > 100 & ~missing(votingPopulation) /* Only 12 obsevations, they have very small population, with discrepancy in the order of 10 citizens. */
label variable turnoutPres16 "Percentage county turnout at the 2016 Presidential elections"

* Turnout at the 2012 Presidential elections
gen turnoutPres12 = (totalPres12 / votingPopulation) * 100
replace turnoutPres12 = 100 if turnoutPres12 > 100 & ~missing(votingPopulation) /* Only 16 obsevations, they have very small population, with discrepancy in the order of 100 citizens. */
label variable turnoutPres12 "Percentage county turnout at the 2012 Presidential elections"

* Turnout at the 2016 House elections
gen turnoutHouse16 = (totalHouse16 / votingPopulation) * 100
replace turnoutHouse16 = 100 if turnoutHouse16 > 100 & ~missing(votingPopulation) /* Only 11 obsevations, they have very small population, most discrepancy in the order of 1 citizens. */
label variable turnoutHouse16 "Percentage county turnout at the 2016 House elections"
global presX 	repPres16Share repShareChange turnoutPres16
global houseX 	turnoutHouse16 repHouse16Share

cap gen repManIncumbent = repIncumbent * manIncumbent
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
