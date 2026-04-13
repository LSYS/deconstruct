import delimited "../build/8-VOTER/out/voter-individual.csv", clear

label variable fips				"FIPS county code"

rename tweet_count tweets
label variable tweets			"No. of metoo tweets in county in 2018"

encode county, gen(countyName)
drop county
label variable countyName		"County name of respondent"

encode state, gen(_state)
drop state
rename _state state
label variable state			"State of respondent"

*==================================================================================================
* Individual demo baseline
*==================================================================================================
 * Gender 
label define genderLabel 1 "Male" 2 "Female"
rename gender_baseline gender
label values gender genderLabel
label variable gender 		"Gender of respondent"

* Race/ethnic
** Set Asian, Native American, Mixed, Other, MIddle Eastern into a catchall 'Others' category
replace race_baseline = 4 if race_baseline > 4
#delimit ;
label define raceLabel 
	1 "White"
	2 "Black"
	3 "Hispanic"
	4 "Others";
#delimit cr
rename race_baseline race
label values race raceLabel 
label variable race		"Race of respondent"

* Have child below 18?
label define haveChildLabel 1 "Yes" 2 "No"
label values child18_baseline haveChildLabel 
fvset base 2 child18_baseline
label variable child18_baseline			"Have child below age of 18 as at 2012 survey"

label values child18_2016 haveChildLabel 
fvset base 2 child18_2016
label variable child18_2016				"Have child below age of 18 as at 2016 survey"

* How many child below 18?
replace child18num_baseline = 0 if missing(child18num_baseline)
label variable child18num_baseline 		"How many children below age of 18 as at 2012 survey"

* Education
#delimit ;
label define educLabel 
	1 "No HS"
	2 "HS grad"
	3 "Some college"
	4 "2-year college"
	5 "4-year college"
	6 "Post-grad";
#delimit cr
label values educ_baseline educLabel 
fvset base 1 educ_baseline 
label variable educ_baseline			"Education level of respondent as at 2012 survey"

label values educ_2016 educLabel 
fvset base 1 educ_2016 
label variable educ_2016				"Education level of respondent as at 2016 survey"

label values educ_2018 educLabel 
fvset base 1 educ_2018 
label variable educ_2018				"Education level of respondent as at 2018 survey"

label variable birthyr_baseline			"Birth year of respondent"

* Marital status
#delimit ;
label define maritalLabel 
	1 "Married"
	2 "Separated"
	3 "Divorced"
	4 "Widowed"
	5 "Single"
	6 "Domestic partnership";
#delimit cr
label values marstat_baseline maritalLabel
label variable marstat_baseline 		"Marital status of respondent as at 2012 survey"

* Create birthyr cohort by decade
gen birthCohort = 0 
replace birthCohort = 1 if birthyr_baseline > 1930 & birthyr_baseline <= 1940
replace birthCohort = 2 if birthyr_baseline > 1940 & birthyr_baseline <= 1950
replace birthCohort = 3 if birthyr_baseline > 1950 & birthyr_baseline <= 1960
replace birthCohort = 4 if birthyr_baseline > 1960 & birthyr_baseline <= 1970
replace birthCohort = 5 if birthyr_baseline > 1970 & birthyr_baseline <= 1980
replace birthCohort = 6 if birthyr_baseline > 1980 & birthyr_baseline <= 1990
replace birthCohort = 7 if birthyr_baseline > 1990 

#delimit ;
label define cohortLabel 
	0 "Birthyear < 1930"
	1 "Birthyear 1930-1940"
	2 "Birthyear 1940-1950"
	3 "Birthyear 1950-1960"
	4 "Birthyear 1960-1970"
	5 "Birthyear 1970-1980"
	6 "Birthyear 1980-1990"
	7 "Birthyear 1990-2000";
#delimit cr
label values birthCohort cohortLabel
label variable birthCohort 				"Birth year cohort of respondent by decade"

* Create my own employment status type, which includes student
gen employ_baseline = 0 if student2_baseline < 3
replace employ_baseline = employstat2_baseline if student2_baseline >= 3

#delimit ;
label define empLabel 
	0 "Student"
	1 "Full-time employed"
	2 "Part-time employed"
	3 "Self-employed"
	4 "Unemployed or temporarily on layoff"
	5 "Retired"
	6 "Permanently disabled"
	7 "Homemaker"
	8 "Other";
#delimit cr

label values employ_baseline empLabel 
fvset base 8 employ_baseline 
label variable employ_baseline		"Employment status of respondent as at 2012 survey"
drop student2_baseline employstat2_baseline

* Family income
#delimit ;
label define famIncLabel 
	1 "< 10,000"
	2 "10,000 - 19,999"
	3 "20,000 - 29,999"
	4 "30,000 - 39,999"
	5 "40,000 - 49,999"
	6 "50,000 - 59,999"
	7 "60,000 - 69,999"
	8 "70,000 - 79,999"
	9 "80,000 - 99,999"
	10 "100,000 - 119,999"
	11 "120,000 - 149,999"
	31 "> 150,000"
	97 "Prefer not to reveal"
	;
#delimit cr

label values faminc_baseline famIncLabel
label variable faminc_baseline 		"Family annual income over the last year as at 2012 survey"

label values faminc_2016 famIncLabel
label variable faminc_2016	 		"Family annual income over the last year as at 2016 survey"

// *==================================================================================================
// * County/District/State demographics
// *==================================================================================================
rename total_population					population
label variable population				"Population of county based on the 2012-16 ACS"

*==================================================================================================
* VOTER data
*==================================================================================================
label variable sexism16					"range 1 to 24, increasing in sexism in 2016 VOTER survey"

label variable sexism18					"range 1 to 24, increasing in sexism in 2018 VOTER survey"

label variable sexism_change 			"range -23 to 23, increase in sexism from 2016 to 2018"

label variable ideo_baseline_18 		"range -4 to 4, increase in conservatism from 2012 to 2018"

label variable ideo_16_18 				"range -4 to 4, increase in conservatism from 2016 to 2018"

label variable pid_baseline_18 			"range -2 to 2, increasing in Dem alignment from 2012 to 2018"

label variable pid_16_18	 			"range -2 to 2, increasing in Dem alignment from 2016 to 2018"

rename ideo5_baseline_processed			ideo_baseline
label variable ideo_baseline			"Ideology of respondent as at 2012, range 1-5, from liberal to conservative"

rename ideo5_2016_processed				ideo_2016
label variable ideo_2016				"Ideology of respondent as at 2016, range 1-5, from liberal to conservative"

rename ideo5_2018_processed				ideo_2018
label variable ideo_2018				"Ideology of respondent as at 2018, range 1-5, from liberal to conservative"

rename pid3_baseline_processed2			pid_baseline
label variable pid_baseline				"Party identification of respondent as at 2012, 1=Dem, 2=Others/Ind, 3=Rep"

rename pid3_2016_processed2				pid_2016
label variable pid_2016					"Party identification of respondent as at 2016, 1=Dem, 2=Others/Ind, 3=Rep"

rename pid3_2018_processed2				pid_2018
label variable pid_2018					"Party identification of respondent as at 2018, 1=Dem, 2=Others/Ind, 3=Rep"

replace vote_16 = 0 if vote_16 == 2
label variable vote_16 					"==1 if voted Republican in 2016 Presidential Election"

replace vote_18 = 0 if vote_18 == 2
label variable vote_18 					"==1 if would have voted Republican in Congress election in 2018"

replace vote2_18 = 0 if vote2_18 == 2
label variable vote2_18 					"==1 if would have voted Republican in Congress election in 2018, includes additional forcing question"

label variable vote_change 				"range -1 to 1, -1 if change from Rep to Dem, 1 if change from Dem to Rep"

label variable vote_change2				"range -1 to 1, -1 if change from Rep to Dem, 1 if change from Dem to Rep, includes forcing vote"

* How closely have you followed the recent allegations of sexual harassment and
* assault against prominent men in entertainment, politics and the media?
label variable follow_2018 				"range 1 to 4, 1=Very Closely 2=Somewhat closely 3=Not very closely 4=Not at all closely"

* Which comes closer to your view about recent allegations of sexual harassment
* and assault? [randomize order of responses]
* 0 = They are mainly isolated incidents of individual misconduct
* 1 = They mainly reflect widespread problems in society
replace alleg_2018 = alleg_2018 - 1
label variable alleg_2018				"==1 if recent allegations of sex harassment reflect wider problem in society"

* Do you approve or disapprove of how the Republican Party is handling the issue
* of sexual harassment and sexual assault in politics? [randomize order of parties]
replace sexual_rep_2018	= 5 - sexual_rep_2018			
label variable sexual_rep_2018			"range 1-4, increasing in approval of Rep. party in handling sexual harassment in politics"

* Do you approve or disapprove of how the Democratic Party is handling the issue
* of sexual harassment and sexual assault in politics? [randomize order of parties]
replace sexual_dem_2018	= 5 - sexual_dem_2018			
label variable sexual_dem_2018			"range 1-4, increasing in approval of Dem. party in handling sexual harassment in politics"

* Feeling thermometer - Feminists
replace ft_fem_2016  = . if ft_fem_2016 == 997
label variable ft_fem_2016 				"Feeling thermometer for feminists, 0 to 100, increasing in favor of feminism"

* Men and women’s opportunities for achievement
* In the U.S. today, do men have more opportunities for achievement than women have, do women have 
* more opportunities than men, or do they have equal opportunities?
#delimit ;
label define genderEqualityLabel 
	1 "Men have more opportunities than women"
	2 "Men and women have equal opportunities"
	3 "Women have more opportunities than men"
	8 "Don't know";
#delimit cr
label values gender_equality_2016 genderEqualityLabel 
label variable gender_equality_2016 	"Opinion of respondent on whether men and women have equal opportunities for achievement"

* Attention to the issue of sexual harassment
* Do you think recent attention to the issue of sexual harassment and assault…
#delimit ;
label define attentionLabel 
	1 "Has not gone far enough"
	2 "Has been about right"
	3 "Has gone too far";
#delimit cr
label values attention_2018 attentionLabel
label variable attention_2018 			"Opinion of respondent in 2018 on whether attention on sexual harssment has gone to far"

* Registered to vote?
replace votereg2_2016 = 0 if votereg2_2016 >= 2
label variable votereg2_2016 			"==1 if respondent is registered to vote"

* Registered to vote in zipcode given?
replace votereg_f_2016 = 0 if votereg_f_2016 >= 2
label variable votereg_f_2016 			"==1 if respondent is registered to vote in reported zipcode"

* Turnout to vote in 2016 Pres. election?
replace turnout16_2016 = 0 if turnout16_2016 >= 2
label variable turnout16_2016			"==1 if respondent turnout to vote in 2016 election"

* trumpapp_2018
* Do you approve or disapprove of the way Donald Trump is handling his job as President?
#delimit ;
label define appLabel
	1 "Strongly approve"
	2 "Somewhat approve"
	3 "Somewhat disapprove"
	4 "Strongly disapprove"
	5 "Don't know";
#delimit cr
label values trumpapp_2018 appLabel
label variable trumpapp_2018 			"Approval of Trump in handling his job as president in 2018"

* obamaapp_baseline
* Do you approve or disapprove of the way Barack Obama is handling his job as President?
label values obamaapp_baseline appLabel
label variable obamaapp_baseline 		"Approval of Obama in handling his job as president in 2012"

* cong2012_2_baseline (Generic presidential vote intention)
* If an election for president was going to be held now, would you vote for...
replace cong2012_2_baseline = 3 if cong2012_2_baseline >= 3
#delimit ;
label define voteGenericLabel
	1 "The Democratic Party candidate"
	2 "The Republican Party candidate"
	3 "Other/Not sure/Would not vote";
#delimit cr
label values cong2012_2_baseline voteGenericLabel
label variable cong2012_2_baseline	"Who respondent would have voted for in 2012 in a congress election"
fvset base 3 cong2012_2_baseline	

* vote_generic_baseline (Generic presidential vote intention)
* If an election for president was going to be held now, would you vote for...
replace vote_generic_baseline = 3 if vote_generic_baseline >= 3
label values vote_generic_baseline voteGenericLabel
label variable vote_generic_baseline	"Who respondent would have voted for in 2012 in a presidential election"
fvset base 3 vote_generic_baseline	

* straighttic_baseline 
* Do you almost always vote for candidates from the same party?
#delimit ;
label define straightTicketLabel
	1 "Almost always vote for Democrats"
	2 "Almost always vote for Republicans"
	3 "Vote for both Democrats and Republicans";
#delimit cr
label values straighttic_baseline straightTicketLabel
label variable straighttic_baseline 	"Does respondent tend to almost always vote the same party"
fvset base 3 straighttic_baseline 	

* newsint2_baseline (Interest in news and public affairs)
* Would you say you follow what's going on in government and public affairs ... ?
replace newsint2_baseline = 5 - newsint2_baseline
#delimit ;
label define newsintLabel
	4 "Most of the time"
	3 "Some of the time"
	2 "Only now and then"
	1 "Hardly at all";
#delimit cr
label values newsint2_baseline newsintLabel
label variable newsint2_baseline 		"For much does respondent follow government and public affairs in 2012"
fvset base 1 newsint2_baseline 

* newsint_2016
replace newsint_2016 = . if newsint_2016 == 7
replace newsint_2016 = 5 - newsint_2016
label values newsint_2016 newsintLabel
label variable newsint_2016		 		"For much does respondent follow government and public affairs in 2016"

* newsint_2018
replace newsint_2018 = . if newsint_2018 == 7
replace newsint_2018 = 5 - newsint_2018
label values newsint_2018 newsintLabel
label variable newsint_2018		 		"For much does respondent follow government and public affairs in 2018"

* polinterest_baseline (Level of interest in politics/current events)
* How interested are you in politics and current affairs?
replace polinterest_baseline = 5 - polinterest_baseline
#delimit ;
label define polinterestLabel
	4 "Very much interested"
	3 "Somewhat interested"
	2 "Not much interested"
	1 "Not sure";
#delimit cr
label values polinterest_baseline polinterestLabel
label variable polinterest_baseline 	"How interested is respondent in politics and current affairs"
fvset base 1 polinterest_baseline 	

* pol_know_baseline (How much would you say that you know about politics?)
* How much would you say that you know about politics?
replace pol_know_baseline = 5 - pol_know_baseline
#delimit ;
label define polknowLabel
	1 "Nothing"
	2 "A little"
	3 "Some"
	4 "A lot";
#delimit cr
label values pol_know_baseline polknowLabel
label variable pol_know_baseline 		"How much does respondent know about politics"
fvset base 1 pol_know_baseline 		

* hourscomputing_baseline
label variable hourscomputing_baseline	"How many hours does respondent spend on a computer on a typical day"

* intuse_home_baseline (How often do you use the Internet...AT HOME)
#delimit ;
label define intuseLabel
	1 "Never"
	2 "Less often than every few weeks"
	3 "Every few weeks"
	4 "1-2 days a week"
	5 "3-5 days a weel"
	6 "About once a day"
	7 "Several times a day";
#delimit cr
label values intuse_home_baseline intuseLabel
label variable intuse_home_baseline		"How often does respondent use the internet at home in 2012"
fvset base 1 intuse_home_baseline		

* intuse_mobile_baseline (How often do you use the Internet...FROM A MOBILE WIRELESS DEVICE)
label values intuse_mobile_baseline intuseLabel
label variable intuse_mobile_baseline		"How often does respondent use the internet on a mobile device in 2012"
fvset base 1 intuse_mobile_baseline		

***************************************************************************************************
* Generated log transform of tweets
gen lnTweets = ln(tweets + 1)
label variable lnTweets	"Log of no. of tweets containing #metoo in county in 2018"

gen lnTweetsToPop = ln( (tweets + 1) / population)

label variable lnTweetsToPop "Log of ratio of no. of tweets containing #metoo to population in county in 2018"

* No. of respondents in county (FIPS)
bysort fips: gen n_fips = _N
label variable n_fips 		"No. of respondents in FIPS"
*==================================================================================================
drop vote18_other_2018 case_identifier caseid insample

*==================================================================================================
* Defining global variable lists
*==================================================================================================
global knowledgeX 	i.polinterest_baseline i.pol_know_baseline
global indX			i.gender i.race c.child18num_baseline i.educ_baseline i.birthCohort i.employ_baseline i.faminc_baseline i.marstat_baseline
global voteX		i.cong2012_2_baseline i.vote_generic_baseline i.straighttic_baseline
compress

*==================================================================================================
capture program drop PostEstVoter
program define PostEstVoter
    quietly {
        // Basic table info
        estadd local nobs    "\multicolumn{1}{c}{$ `e(N)' $}"
        estadd local ind_X   "\multicolumn{1}{c}{$ X $}"
        estadd local vote_X  "\multicolumn{1}{c}{$ X $}"
        estadd local know_X  "\multicolumn{1}{c}{$ X $}"
        
        // Joint F-test of individual characteristics
        testparm $indX
    }
    TestStatSig r(F) r(p)
    quietly estadd local ind_F "\multicolumn{1}{c}{$ F = `r(StatStars)' $}"
    
    quietly {
        // Joint F-test of voting history & tendency
        testparm $voteX
    }
    TestStatSig r(F) r(p)
    quietly estadd local vote_F "\multicolumn{1}{c}{$ F = `r(StatStars)' $}"
    
    quietly {
        // Joint F-test of political interest & knowledge
        testparm $knowledgeX
    }
    TestStatSig r(F) r(p)
    quietly estadd local know_F "\multicolumn{1}{c}{$ F = `r(StatStars)' $}"
end
*==================================================================================================
