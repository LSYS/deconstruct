version 13 /* That's right... I'm still on Stata 13... */

/* This program is a custom postestimation command that takes a coeffient value (coef),
	its corresponding standard errors (se), the regression degree of freedom remaining (df_r),
	and then computes the corressponding p-value. Rounding parameter is round (e.g. .001 rounds
	to 3 decimal places).
	
	
	e.g. To get pval of x rounded off to three decimal places,
	reg y x 
	get_pval _b[x] _se[x] e(df_r) 0.001 
	local pval `r(pval)'
	dis "`pval'"
*/

capture program drop get_pval
program define get_pval, rclass
	args coef se df_r round
	tempvar tstat
	qui gen `tstat' = `coef'/`se'
	local pval = 2*ttail(`df_r', abs(`tstat') )
	local pval = round(`pval', `round')
	*di `pval'
	return local pval `pval'
end
