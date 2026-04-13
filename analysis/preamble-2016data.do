import delimited "../build/9-election2016Data/output/house-2016-stata.csv", clear

*==================================================================================================
* State, counties, and district
*==================================================================================================
rename county countyName
label variable countyName			"County name"

egen county = group(district countyName)
label variable county			"District-County"

encode state, generate(encodedStateName)
drop state
rename encodedStateName state
label variable state			"State of county"

encode district, generate(encodedDistrict)
drop district
rename encodedDistrict district
label variable district			"Congressional district of county"

label variable county_fips				"FIPS county code"

*==================================================================================================
* Aggregated tweets data
*==================================================================================================
rename tweet_count tweets
label variable tweets			"No. of metoo tweets in county in 2018"

rename count_hashtags hashtags 
label variable hashtags 		"No. of hashtags in #metoo tweets in county in 2018"

label variable favorites 		"No. of favorites of #metoo tweets in county in 2018"

label variable retweets 		"No. of #metoo retweets in county in 2018"

rename tweet_length lenOfTweets
label variable lenOfTweets		"Aggregated length of #metoo tweets in county in 2018"

*==================================================================================================
* Individual-level data
*==================================================================================================
encode politician, generate(pol)
drop politician
rename pol politician
label variable politician	"Politician name"

label variable party		"Party of politician"

label variable woman		"==1 if politician is a woman"

label variable black		"==1 if politician is african-american"

label variable democrat		"==1 if politician ran under democratic banner"

label variable republican	"==1 if politician ran under republican banner"

label variable independent	"==1 if politician runs under a non-dem non-rep banner"

label variable incumbent	"==1 if politician ran as the incumbent"

label variable votes		"Number of votes for candidate in county in the 2016 House elections"


*==================================================================================================
* Political seat data
*==================================================================================================
rename openseat 				openSeat
label variable	openSeat		"==1 if incumbent is not contesting"

rename no_main_challenger noMainChallenger 
label variable noMainChallenger "==1 if seat has no candidate of the two main parties"

rename atleast1woman			atLeast1Woman
label variable atLeast1Woman	"==1 if there is at least 1 woman candidate"

rename atleast1womanmain			atLeast1WomanMain
label variable atLeast1WomanMain	"==1 if there is at least 1 woman candidate from the main party"

rename twoptycountyvotes			twoPtyVoteCount
label variable twoPtyVoteCount		"Total no. of two-Party district-county vote count"

*==================================================================================================
* County/District/State demographics
*==================================================================================================
rename countyvotes					countyVotes
label variable countyVotes			"Total votes cast in county"

rename total_population				population
label variable population			"Population of county based on the 2012-16 American Community Survey"
	
rename cvap							votingPopulation
label variable votingPopulation		"Voting-aged population of county based on the 2012-16 American Community Survey"

label variable white_pct			"Percentage of non-hispanic whites in county"
	
label variable black_pct			"Percentage of non-hispanic blacks in county"
	
label variable hispanic_pct			"Percentage of hispanics or latinos in county"
	
label variable nonwhite_pct			"Percentage of non-whites in county"
	
label variable foreignborn_pct		"Percentage of foreign-born in county"

gen otherRace_pct = 100 - (white_pct + black_pct + hispanic_pct)
label variable otherRace_pct 		"Percentage of non-White, non-Black and non-Hispanic in county"
	
label variable female_pct			"Percentage of women in county"

label variable age29andunder_pct	"Percentage of population 29 years or below in county"

label variable age65andolder_pct	"Percentage of population 65 years or above in county"

label variable median_hh_inc		"Median hh income in the past 12 months (in 2016 inflation-adjusted dollars)"

label variable clf_unemploy_pct		"Unemployed population in LF as a percentage of county population in civilian LF"

label variable lesshs_pct			"Percentage of population with an education < regular high school diploma"

label variable lesscollege_pct		"Percentage of population with an education < than a bachelor's degree"

label variable lesshs_whites_pct	"Percentarge of white population with education < regular high school diploma"

label variable lesscollege_whites_pct	"Percentage of white population with education< bachelor's degree"

label variable rural_pct			"Rural population as a percentage of total population"

gen age29andUnder = (age29andunder_pct / 100) * population
label variable age29andUnder		"Population count of age 29 and below"

gen age65andOlder = (age65andolder_pct / 100) * population
label variable age65andOlder		"Population count of age 65 and above"

gen age65andUnder = population - age65andOlder
label variable age65andUnder		"Population count of age 65 and under"

label define rural_urban_label ///
	1 "metro; pop > 1,000,000" ///
	2 "metro; 250,000 < pop < 1,000,000" ///
	3 "metro; pop < 250,000" ///
	4 "urban, adjacent to a metro area; 20,000 < pop" ///
	5 "urban, not adjacent to a metro area; 20,000 < pop" ///
	6 "urban, adjacent to a metro area; 2,500 < pop < 19,999" ///
	7 "urban, not adjacent to a metro area; 2,500 < pop < 19,999" ///
	8 "rural, adjacent to a metro area; pop < 2,500" ///
	9 "rural, not adjacent to a metro area; pop < 2,500" ///
	
tostring ruralurban_cc, gen(ruralurban_cc_str)
drop ruralurban_cc
encode ruralurban_cc_str, generate(ruralUrban) label(rural_urban_label)
drop ruralurban_cc_str
label variable ruralUrban			"rural-urban continuum codes year 2013 from USDA Economic Research Service"
fvset base 9 ruralUrban

*==================================================================================================
* County past electoral records
*==================================================================================================
* All presidential vote shares are two-party
label variable dempresvotes2016		"Dem. vote share in 2016 Pres. election in county"
label variable reppresvotes2016		"Rep. vote share in 2016 Pres. election in county"
label variable totalpresvotes2016	"Total votes in 2016 Pres. election in county"

label variable dempresvotes2012		"Dem. vote share in 2012 Pres. election in county"
label variable reppresvotes2012 	"Rep. vote share in 2012 Pres. election in county"
label variable totalpresvotes2012	"Total votes in 2012 Pres. election in county"

label variable dempresvotes2008		"Dem. vote share in 2008 Pres. election in county"
label variable reppresvotes2008 	"Rep. vote share in 2008 Pres. election in county"
label variable totalpresvotes2008	"Total votes in 2008 Pres. election in county"

label variable dempresvotes2004		"Dem. vote share in 2004 Pres. election in county"
label variable reppresvotes2004 	"Rep. vote share in 2004 Pres. election in county"
label variable totalpresvotes2004	"Total votes in 2004 Pres. election in county"

label variable demgov14			"No. of votes for the democrat candidate in the 2014 gubernatorial election"
label variable repgov14			"No. of votes for the republican candidate in the 2014 gubernatorial election"
label variable othergov14		"No. of votes for the third-party candidate in the 2014 gubernatorial election"

rename repcountyvotes				repCountyVotes
label variable repCountyVotes		"No. of district-county votes for Republican party in 2016 House elections"

rename demcountyvotes				demCountyVotes
label variable demCountyVotes		"No. of district-county votes for Democratic party in 2016 House elections"

rename districtcountyvotes			districtCountyVotes
label variable districtCountyVotes	"Total no. of district-county votes in 2016 House elections"

*==================================================================================================
* Generating additional variables
*==================================================================================================
***************************************************************************************************
* County-level demographics
* Generate other race (non-white non-black non-hispanic) percentage in county
gen other_pct = 100 - white_pct - black_pct - hispanic_pct
label variable other_pct	"Percentage of non-white, non-black, non-hispanic race in county"

gen age29To65pct = 100 - age29andunder_pct - age65andolder_pct
label variable age29To65pct  "Percentage of population aged 29 to 65"

gen college_pct = 100 - lesscollege_pct
label variable college_pct "Percentage of population with college degree and above level of education"

gen male_pct = 100 - female_pct
label variable male_pct "Percentage of population who is male"

gen clf_employ_pct = 100 - clf_unemploy_pct
label variable clf_employ_pct "Employed population in LF as a percentage of county population in civilian LF"

***************************************************************************************************
* Politician-level data
gen notIncumbent = 1 - incumbent
label variable notIncumbent 	"==1 if not incumbent"

gen mainParty = 1 - independent
label variable mainParty		"==1 if politician is running under Democrat or Republican banner"

gen turnout = (countyVotes / votingPopulation) * 100
replace turnout = 100 if turnout > 100 & ~missing(votingPopulation) /* 14 cases, most with discrepancy on the order of 10 citizens */
label variable turnout 				"Number of votes in county as a percentage of voting-aged residents in county"


***************************************************************************************************
* Compute vote shares
gen voteShare = (votes / districtCountyVotes)  * 100
label variable voteShare 			"Share of votes gained in county in the 2016 elections"

gen twoPtyVoteShare = (votes / twoPtyVoteCount) * 100
label variable twoPtyVoteShare		"Share of two-party votes gained in county in the 2016 elections"

gen repPres08VoteShare = (reppresvotes2008 / totalpresvotes2008) * 100 
label variable repPres08VoteShare "Rep. vote share in 2008 Pres. election"

gen repPres12VoteShare = (reppresvotes2012 / totalpresvotes2012) * 100 
label variable repPres12VoteShare "Rep. vote share in 2012 Pres. election"

gen repPres16VoteShare = (reppresvotes2016 / totalpresvotes2016) * 100 
label variable repPres16VoteShare "Rep. vote share in 2016 Pres. election"

gen repPres2008to2012change = repPres12VoteShare - repPres08VoteShare
label variable repPres2008to2012change "Rep. vote share change from the 2008 to 2012 Pres. elections"

gen repPres2012to2016change = repPres16VoteShare - repPres12VoteShare
label variable repPres2012to2016change "Rep. vote share change from the 2012 to 2016 Pres. elections"

gen repHouse16VoteShare = (repCountyVotes / countyVotes) * 100
label variable repHouse16VoteShare 		"Rep. county vote share in 2016 House elections"

gen repTwoPtyHouse16VoteShare = (repCountyVotes / twoPtyVoteCount ) * 100
label variable repTwoPtyHouse16VoteShare "Rep. county two-party vote share in 2016 House elections"

gen repGov14VoteShare = (repgov14 / (repgov14 + demgov14 + othergov14) ) * 100
label variable repGov14VoteShare 			"Rep. county gubernatorial vote share in 2014"

gen repTwoPtyGov14VoteShare = (repgov14 / (repgov14 + demgov14) ) * 100
label variable repTwoPtyGov14VoteShare 			"Rep. county two-party gubernatorial vote share in 2014"

gen repPres04VoteShare = (reppresvotes2004 / totalpresvotes2004) * 100
label variable repPres04VoteShare 				"Rep. vote share in 2004 Pres. election"

gen repPres2004to2008change = repPres08VoteShare - repPres04VoteShare
label variable repPres2004to2008change 			"Rep. vote share change from the 2004 to 2008 Pres. elections"

* Two-party presidential vote shares
gen totalPres2pty08 = dempresvotes2008 + reppresvotes2008
label variable totalPres2pty08 "Total two-party votes in 2008 Pres. election"

gen repPres2ptyShare08 = (reppresvotes2008 / totalPres2pty08) * 100
label variable repPres2ptyShare08 "Rep. two-party vote share in 2008 Pres. election"

gen totalPres2pty12 = dempresvotes2012 + reppresvotes2012
label variable totalPres2pty12 "Total two-party votes in 2012 Pres. election"

gen repPres2ptyShare12 = (reppresvotes2012 / totalPres2pty12) * 100
label variable repPres2ptyShare12 "Rep. two-party vote share in 2012 Pres. election"

gen totalPres2pty16 = dempresvotes2016 + reppresvotes2016
label variable totalPres2pty16 "Total two-party votes in 2016 Pres. election"

gen repPres2ptyShare16 = (reppresvotes2016 / totalPres2pty16) * 100
label variable repPres2ptyShare16 "Rep. two-party vote share in 2016 Pres. election"

* House 2014
gen repHouseShare14 = (rephouse14 / totalhouse14) * 100
gen dempHouseShare14 = (demhouse14 / totalhouse14) * 100

gen repHouse2ptyShare14 = (rephouse14 / ( rephouse14 + demhouse14 )) * 100
gen demHouse2ptyShare14 = (demhouse14 / ( rephouse14 + demhouse14 )) * 100

* Tweets data
#delimit ;
local tweetsX "
	tweets 
	hashtags 
	favorites 
	retweets 
	lenOfTweets";
#delimit cr
	
foreach var in `tweetsX' {
	gen `var'ToPop = (`var' / population) * 1000
	label variable `var'ToPop 	"#`var' per residents in county"
}

foreach var in `tweetsX' {
	gen `var'ToVotingPop = (`var' / votingPopulation) * 1000
	label variable `var'ToVotingPop 	"`var' per 1000 voting-aged residents in county"
}

* Turnout
gen turnoutPres2012 = totalpresvotes2012 * 100 / votingPopulation
replace turnoutPres2012 = 100 if turnoutPres2012 > 100 & ~missing(votingPopulation) /* Only 11 obsevations, they have very small population, most discrepancy in the order of 1 citizens. */
label variable turnoutPres2012 "Percentage county turnout at the 2012 Pres. election"


***************************************************************************************************
* Generated log transform of tweets
gen lnTweets = ln(tweets + 1)
label variable lnTweets	"Log of no. of tweets containing #metoo in county in 2018"

*gen lnTweetsToPop = ln( (tweets + 0.001^100) / population)
gen lnTweetsToPop = ln( (tweets + 1) / population)
label variable lnTweetsToPop "Log of ratio of no. of tweets containing #metoo to population in county in 2018"


*==================================================================================================
* Defining global variable lists
*==================================================================================================
#delimit ;
global census 
	c.population
	c.white_pct c.black_pct c.hispanic_pct 
	c.foreignborn_pct c.female_pct 
	c.age29andunder_pct c.age65andolder_pct 
	c.median_hh_inc c.clf_unemploy_pct 
	c.lesshs_pct c.lesscollege_pct 
	c.rural_pct i.ruralUrban;
#delimit cr

compress
