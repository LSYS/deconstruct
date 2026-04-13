*==================================================================================================
* State, counties, and district
*==================================================================================================
encode county, generate(countyName)
drop county
label variable countyName		"County name"

egen county = group(district countyName)
label variable county			"District-County"

gen stateid_str = state
encode state, generate(encodedStateID)
drop state
rename encodedStateID stateID
label variable stateID			"State in ISO 3166-1 Alpha-2 code"

egen stateCounty = group(stateID countyName)
label variable stateCounty		"State-County"

encode state_name, generate(encodedStateName)
drop state_name
rename encodedStateName state
label variable state			"State of county"

encode district, generate(encodedDistrict)
drop district
rename encodedDistrict district
label variable district			"Congressional district of county"

label variable fips				"FIPS county code"


*==================================================================================================
* Aggregated tweets data
*==================================================================================================
rename tweet_count tweets
label variable tweets			"No. of metoo tweets in county in 2018"

*==================================================================================================
* Individual-level data
*==================================================================================================
drop gender

encode politician, generate(pol)
drop politician
rename pol politician
label variable politician		"House candidate name"
	
label variable party			"Party of candidate"
label variable woman			"==1 if candidate is a woman"
label variable democrat			"==1 if candidate ran under Democratic banner"
label variable republican		"==1 if candidate ran under Republican banner"
label variable independent		"==1 if candidate runs under a non-Dem. non-Rep. banner"
label variable votes			"No. of candidate vote in district-county in the 2018 House elections"
	
** Race of politician	
label variable np1_white		"==1 if candidate most probably a White according to NamePrism"
label variable np1_black		"==1 if candidate most probably a Black according to NamePrism"
label variable np1_hispanic		"==1 if candidate most probably a Hispanic according to NamePrism"
label variable np1_others		"==1 if candidate most probably a Non-white non-Black non-Hispanic according to NamePrism"

*==================================================================================================
* Vote counts needed for calculating shares
*==================================================================================================
rename district_county_votes districtCountyVotes
label variable districtCountyVotes			"No. of district-county votes in 2018 House elections"

rename twoparty_district_county_votes district2ptyCountyVotes
label variable district2ptyCountyVotes		"No. of two-party district-county votes in 2018 House elections"

*==================================================================================================
* County demographics
*==================================================================================================
rename total_population population
label variable population				"Population of county based on the 2012-16 ACS"
		
label variable white_pct				"Percentage non-hispanic whites in county based on the 2012-16 ACS"
label variable black_pct				"Percentage non-hispanic blacks in county based on the 2012-16 ACS"
label variable hispanic_pct				"Percentage hispanics or latinos in county based on the 2012-16 ACS"
label variable foreignborn_pct			"Percentage foreign-born in county based on the 2012-16 ACS"
label variable female_pct				"Percentage women in county"
label variable age29andunder_pct		"Percentage population 29 years or below in county based on the 2012-16 ACS"
label variable age65andolder_pct		"Percentage population 65 years or above in county based on the 2012-16 ACS"
label variable median_hh_inc			"Median hh income in the past 12 months (in 2016 inflation-adjusted dollars)"
label variable clf_unemploy_pct			"Unemployed population in LF as a percentage of county population in civilian LF"
label variable lesshs_pct				"Percentage of population with an education < regular high school diploma based on the 2012-16 ACS"
label variable lesscollege_pct			"Percentage of population with an education < than a bachelor's degree based on the 2012-16 ACS"
label variable rural_pct				"Rural population as a percentage of total population based on the 2012-16 ACS"

gen college_pct = 100 - lesscollege_pct
label variable college_pct "Percentage of population with college degree and above level of education"

gen other_pct = 100 - white_pct - black_pct - hispanic_pct
label variable other_pct	"Percentage of non-white, non-black, non-hispanic race in county"

#delimit ;
label define rural_urban_label 
	1 "metro; pop > 1,000,000"
	2 "metro; 250,000 < pop < 1,000,000"
	3 "metro; pop < 250,000"
	4 "urban, adjacent to a metro area; 20,000 < pop"
	5 "urban, not adjacent to a metro area; 20,000 < pop" 
	6 "urban, adjacent to a metro area; 2,500 < pop < 19,999"
	7 "urban, not adjacent to a metro area; 2,500 < pop < 19,999"
	8 "rural, adjacent to a metro area; pop < 2,500"
	9 "rural, not adjacent to a metro area; pop < 2,500"
	10 "missing";
#delimit cr

replace ruralurban_cc = 10 if missing(ruralurban_cc)	
rename ruralurban_cc ruralUrban
label values ruralUrban rural_urban_label
fvset base 9 ruralUrban
label variable ruralUrban			"rural-urban continuum codes year 2013 from USDA Economic Research Service"

rename cvap								votingPopulation
label variable votingPopulation			"Voting-aged population of county based on the 2012-16 ACS"

gen cvap_pct = 100 * (votingPopulation / population)
gen cvap_pct19 = 100 * (votingPopulation19 / population19)

*==================================================================================================
* Past electoral records
*==================================================================================================
* 2016 Presidential election
rename trump16 repPres16
label variable repPres16			"No. of votes for Donald Trump in the 2016 presidential election"

rename totalpresvotes2016 totalPres16
label variable totalPres16			"No. of all-party votes cast in 2016 Presidential elections at county level"

rename totaltwoptypresvotes2016 totalPres2pty16
label variable totalPres2pty16		"No. of two-party votes cast in 2016 Presidential elections at county level"

* 2012 Presidential election
rename romney12 repPres12
label variable repPres12			"No. of votes for Mitt Romney in the 2012 presidential election"

rename totalpresvotes2012 totalPres12
label variable totalPres12			"No. of all-party votes cast in 2012 Presidential elections at county level"

rename totaltwoptypresvotes2012 totalPres2pty12
label variable totalPres2pty12		"No. of two-party votes cast in 2012 Presidential elections at county level"

* 2016 House elections
rename rephouse16 repHouse16
label variable repHouse16			"No. of votes for the republican candidate in the 2016 house election"

rename totalhousevotes2016 totalHouse16
label variable totalHouse16 		"No. of votes cast in 2016 House elections at county level"

rename totaltwoptyhousevotes2016 totalHouse2pty16
label variable totalHouse2pty16 	"No. of two-party votes cast in 2016 House elections at county level"

*==================================================================================================
* Generating key variables needed for main.do
*==================================================================================================

* Vote shares (main dependent variables)
gen share = (votes / districtCountyVotes)  * 100
label variable share 			"Vote share in district-county in the 2018 House elections"

gen share2pty = (votes / district2ptyCountyVotes) * 100
label variable share2pty		"Share of two-party votes gained in district-county in the 2018 midterm elections"

* Log tweet density (main independent variable)
gen lnTweetsToPop = ln((tweets + 1) / population)
label variable lnTweetsToPop "Log of ratio of no. of tweets containing #metoo to population in county in 2018"

gen lnTweets = ln(tweets + 1)
label variable lnTweets	"Log of no. of tweets containing #metoo in county in 2018"

* Past election vote shares
gen repPresShare16 = (repPres16 / totalPres16) * 100
label variable repPresShare16 		"Vote share of Rep. Pres. candidate in 2016"

gen repPres2ptyShare16 = (repPres16 / totalPres2pty16) * 100
label variable repPres2ptyShare16  	"Two-party vote share of Rep. Pres. candidate in 2016"

gen repPresShare12 = (repPres12 / totalPres12) * 100
label variable repPresShare12 		"Vote share of Rep. Pres. candidate in 2012"

gen repPres2ptyShare12 = (repPres12 / totalPres2pty12) * 100
label variable repPres2ptyShare12 	"Two-party Vote share of Rep. Pres. candidate in 2012"

gen repHouseShare16 = (repHouse16 / totalHouse16) * 100
label variable repHouseShare16 		"Vote share of Rep. party in 2016 House elections"

gen repHouse2ptyShare16 = (repHouse16 / totalHouse2pty16) * 100
label variable repHouse2ptyShare16 "Two-party vote share of Rep. party in 2016 House elections"

* Vote share changes
gen repPresShareChange12to16 = repPresShare16 - repPresShare12
label variable repPresShareChange12to16	"Change in share of republican vote in the presidential elections from 2012-2016"

gen repPres2ptyShareChange12to16 = repPres2ptyShare16 - repPres2ptyShare12
label variable repPres2ptyShareChange12to16 "Change in two-party share of republican vote in the presidential elections from 2012-2016"


*==================================================================================================
* 2018 County-level votes
*==================================================================================================
rename demhouse18							demHouse18
label variable demHouse18					"No. of county votes for the Democratic party in the 2018 house election"

rename rephouse18							repHouse18
label variable repHouse18					"No. of county votes for the Republican party in the 2018 house election"

rename otherhouse18							otherHouse18
label variable otherHouse18					"No. of county votes for third-parties in the 2018 house election"

* Generate state-county level total vote counts
gen totalHouse18 = demHouse18 + repHouse18 + otherHouse18
label variable totalHouse18					"No. of votes cast county in 2018 House elections"

gen totalHouse2pty18 = demHouse18 + repHouse18
label variable totalHouse2pty18				"No. of two-party votes cast county in 2018 House elections"

* Generate vote shares
gen repHouseShare18 = (repHouse18 / totalHouse18) * 100
label variable repHouseShare18 				"Vote share of Rep. party in county in 2018 House elections"

gen repHouse2ptyShare18 = (repHouse18 / totalHouse2pty18) * 100
label variable repHouse2ptyShare18 			"Two-party vote share of Rep. party in county in 2018 House elections"

rename repPresVotes2008				repPres08
label variable repPres08			"No. of votes for Republican party in 2008 Presidential election"
rename demPresVotes2008				demPres08
label variable demPres08			"No. of votes for Democratic party in 2008 Presidential election"
rename otherPresVotes2008			otherPres08
label variable otherPres08			"No. of votes for third party in 2008 Presidential election"

gen totalPres08 = repPres08 + demPres08 + otherPres08
label variable totalPres08			"No. of all-party votes cast in 2008 Presidential elections at county level"

***************************************************************************************************
* Turnout data
* Turnout at the 2016 Presidential elections
gen turnoutPres16 = (totalPres16 / votingPopulation) * 100
replace turnoutPres16 = 100 if turnoutPres16 > 100 & ~missing(votingPopulation) /* Only 12 obsevations, they have very small population, with discrepancy in the order of 10 citizens. */
label variable turnoutPres16 "Percentage county turnout at the 2016 Presidential elections"


* Turnout at the 2016 House elections
gen turnoutHouse16 = (totalHouse16 / votingPopulation) * 100
replace turnoutHouse16 = 100 if turnoutHouse16 > 100 & ~missing(votingPopulation) /* Only 11 obsevations, they have very small population, most discrepancy in the order of 1 citizens. */
label variable turnoutHouse16 "Percentage county turnout at the 2016 House elections"

gen totalPres2pty08 = repPres08 + demPres08
label variable totalPres2pty08		"No. of two-party votes cast in 2008 Presidential elections at county level"

gen repPres2ptyShare08 = (repPres08 / totalPres2pty08) * 100
label variable repPres2ptyShare08	"Two-party vote share of Rep. Pres. candidate in 2008"

* Turnout at the 2012 Presidential elections
gen turnoutPres12 = (totalPres12 / votingPopulation) * 100
replace turnoutPres12 = 100 if turnoutPres12 > 100 & ~missing(votingPopulation) /* Only 16 obsevations, they have very small population, with discrepancy in the order of 100 citizens. */
label variable turnoutPres12 "Percentage county turnout at the 2012 Presidential elections"


*==================================================================================================
* Define global variable lists (matching main.do)
*==================================================================================================
#delimit ;
global census 
	c.population
	c.white_pct c.black_pct c.hispanic_pct 
	c.foreignborn_pct c.female_pct 
	c.age29andunder_pct c.age65andolder_pct 
	c.median_hh_inc c.clf_unemploy_pct 
	c.lesshs_pct c.college_pct 
	c.rural_pct i.ruralUrban
	;
#delimit cr

global pty			i.independent i.republican
global presX 		c.repPresShare16  c.repPresShareChange12to16
global elecX		($presX c.repHouseShare16)##($pty)
global censusX	    ($census)##($pty)
global raceGender 	i.woman##c.female_pct i.np1white##c.white_pct i.np1black##c.black_pct i.np1hispanic##c.hispanic_pct i.np1other##c.other_pct


compress




