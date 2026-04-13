do preamble-voter

assert_macros "indX voteX knowledgeX"

eststo clear
eststo: qui reg vote_16 c.lnTweetsToPop $indX $voteX $knowledgeX, r cluster(fips)
PostEstVoter
	
eststo: qui reg vote2_18 c.lnTweetsToPop $indX $voteX $knowledgeX, r cluster(fips)
PostEstVoter

eststo: qui reg vote_change2 c.lnTweetsToPop $indX $voteX $knowledgeX, r cluster(fips)
PostEstVoter

*==================================================================================================
#delimit ;	
local esttab_options "b(%9.3fc)
					 se(%9.3fc)
					 star (* 0.1 ** 0.05 *** 0.01)
					 obslast
					 noomitted
					 varwidth(35)
					 modelwidth(8)
					 interaction(*)
					";				 
local keep_coeff 	"
					lnTweetsToPop
					1.straighttic_baseline 
					2.straighttic_baseline 
					";	
local coeff_labels 	"
					lnTweetsToPop "Log of tweet density"
					1.straighttic_baseline "$ \mathds{1} $(Always vote for Democrats)"
					2.straighttic_baseline "$ \mathds{1} $(Always vote for Republicans)"
					";
#delimit cr
*==================================================================================================

#delimit;				
esttab, 
		keep(`keep_coeff')
		order(`keep_coeff')
		coeflabel(`coeff_labels') 
		`esttab_options' 	
		scalars("dummyLine \emph{Control variables}"
				"ind_X \hspace{1em}Individual characteristics"
				"vote_X \hspace{1em}Voting history \& tendency"
				"know_X \hspace{1em}Political interest \& knowledge"
				"ind_F $ F $-test: Individual characteristics = 0"	
				"vote_F $ F $-test: Voting history \& tendency = 0"
				"know_F $ F $-test: Political interest \& knowledge = 0"	
				"r2 $ R^2 $"
				"nobs $ N $")		
	compress
	;			

esttab  using ../ms/tables/voter-vote.tex, 
		booktabs replace fragment
		keep(`keep_coeff')
		order(`keep_coeff')
		coeflabel(`coeff_labels') 
		`esttab_options' 	
		scalars("dummyLine \emph{Control variables}"
				"ind_X \hspace{1em}Individual characteristics"
				"vote_X \hspace{1em}Voting history \& tendency"
				"know_X \hspace{1em}Political interest \& knowledge"
				"ind_F $ F $-test: Individual characteristics = 0"	
				"vote_F $ F $-test: Voting history \& tendency = 0"
				"know_F $ F $-test: Political interest \& knowledge = 0"	
				"r2 $ R^2 $"
				"nobs $ N $")		
		alignment(D{.}{.}{-1})
	nomtitles noobs
	compress
	;			
#delimit cr

