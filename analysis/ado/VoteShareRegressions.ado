capture program drop VoteShareRegressions
program define VoteShareRegressions
	* (1) Average effect --- no controls
	eststo: qui areg share ($pg)#(c.lnTweetsToPop) , absorb(politician) cluster(politician)
		estadd local nobs  			"\multicolumn{1}{c}{$ `e(N)' $}"
		estadd local candidateFE 	"\multicolumn{1}{c}{$ X $}"
	* (2) Average effect --- full controls
	eststo: qui areg share ($pg)#(c.lnTweetsToPop) i.republican##c.repPresShare16  $pg $X, absorb(politician) cluster(politician)
		estadd local nobs  			"\multicolumn{1}{c}{$ `e(N)' $}"
		estadd local candidateFE 	"\multicolumn{1}{c}{$ X $}"
		estadd local elecX 			"\multicolumn{1}{c}{$ X $}"
		estadd local censusX 		"\multicolumn{1}{c}{$ X $}"
		estadd local raceGenderX 	"\multicolumn{1}{c}{$ X $}"
		qui testparm $elecX 1.republican#c.repPresShare16
			TestStatSig r(F) r(p)
			estadd local elec_F = "\multicolumn{1}{c}{$ F = `r(StatStars)' $}"		
		qui testparm $censusX
			TestStatSig r(F) r(p)
			estadd local census_F = "\multicolumn{1}{c}{$ F = `r(StatStars)' $}"	
		qui testparm $raceGender
			TestStatSig r(F) r(p)
			estadd local raceGender_F = "\multicolumn{1}{c}{$ F = `r(StatStars)' $}"		
	* (3) Heterogeneous --- full controls
	eststo: qui areg share ($pg)#($mainInteract) $pg $X, absorb(politician) cluster(politician)
		estadd local nobs  			"\multicolumn{1}{c}{$ `e(N)' $}"
		estadd local candidateFE 	"\multicolumn{1}{c}{$ X $}"
		estadd local elecX 			"\multicolumn{1}{c}{$ X $}"
		estadd local censusX 		"\multicolumn{1}{c}{$ X $}"
		estadd local raceGenderX 	"\multicolumn{1}{c}{$ X $}"
		qui testparm $elecX 1.republican#c.repPresShare16
			TestStatSig r(F) r(p)
			estadd local elec_F = "\multicolumn{1}{c}{$ F = `r(StatStars)' $}"		
		qui testparm $censusX
			TestStatSig r(F) r(p)
			estadd local census_F = "\multicolumn{1}{c}{$ F = `r(StatStars)' $}"	
		qui testparm $raceGender
			TestStatSig r(F) r(p)
			estadd local raceGender_F = "\multicolumn{1}{c}{$ F = `r(StatStars)' $}"		
	* (4) Heterogeneous --- two-party with full controls
		replace repPresShare16 = repPres2ptyShare16
	eststo: qui areg share2pty ($pg)#($mainInteract) $pg $X2pty if ~independent, absorb(politician) cluster(politician)
		estadd local nobs  			"\multicolumn{1}{c}{$ `e(N)' $}"
		estadd local candidateFE 	"\multicolumn{1}{c}{$ X $}"
		estadd local elecX 			"\multicolumn{1}{c}{$ X $}"
		estadd local censusX 		"\multicolumn{1}{c}{$ X $}"
		estadd local raceGenderX 	"\multicolumn{1}{c}{$ X $}"
		estadd local twoPty 		"\multicolumn{1}{c}{$ X $}"
		qui testparm $elec2ptyX 1.republican#c.repPres2ptyShare16
			TestStatSig r(F) r(p)
			estadd local elec_F = "\multicolumn{1}{c}{$ F = `r(StatStars)' $}"		
		qui testparm $censusX
			TestStatSig r(F) r(p)
			estadd local census_F = "\multicolumn{1}{c}{$ F = `r(StatStars)' $}"	
		qui testparm $raceGender
			TestStatSig r(F) r(p)
			estadd local raceGender_F = "\multicolumn{1}{c}{$ F = `r(StatStars)' $}"		
end
