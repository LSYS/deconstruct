do set_environment
do preamble

* Figure 1
* Timeline of MeToo Tweets in 2018
preserve
do tweets-ts.do
restore

* Figure 2
* State-Level Republican Vote Share and MeToo Movement
preserve
do state-level.do
restore

* Table 1
* The MeToo Movement and Candidate Vote Share
preserve
do voteshare
restore

// * Table 2
* Women Candidacy as Strategic Reaction
preserve
do candidacy
restore

// * Table 3
* The MeToo Movement and the Change in Voter Turnout
preserve
do turnout
restore

* Figure 5
* Women in Congress
preserve
do cawp.do
restore

* Fig 5
* Democratic Women Candidacy as Strategic Reaction
preserve
do interflex.do
restore

* Table  C1
* Predicting Individual Attitudes (VOTER) Using Geolocated MeToo Tweets
preserve
do voter-values.do
restore	

* Table  C2
* The Effect of MeToo on Individual Voting (VOTER Data)
preserve
do voter-vote.do
restore

* Fig F1
* Timeline of MeToo Tweets, 2016-2018
preserve
do tweets-ts-2016to18.do
restore

* Table  E1
* The MeToo Movement and Candidate Vote Share, 2016 House Elections
preserve
do voteshare-2016placebo.do
restore

preserve
do candidacy-2016placebo.do
restore

* Density v intensity
do voteshare-density-intensity.do
do candidacy-density-intensity.do
do turnout-density-intensity.do
