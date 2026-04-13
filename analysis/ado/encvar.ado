cap program drop encvar
program encvar
	syntax varlist(min=1 max=1), [VLABel(string) STR_VARname(string) OPTions(string)]
	///////////////////////////////////////////////////////////////////////////////
	// Description:
	// ------------
	//		Just a utility to encode string variables to the same name. Original string
	// 			variables persist with a "_str" suffix.
	//
	// Syntax: 
	// -------
	// 		encvar var
	// MWE:
	// ----
	// 		sysuse lifeexp
	//		cap reg gnppc i.country
	// 		encvar country
	//		reg gnppc i.country
	// 
	// Additional options:
	// -------------------
	//		. str_varname(string): variable name for the original string variable. 
	// 			(Default is to use "_str" suffix)
	// 		. vlabel(string): variable label for new encoded variable.
	//		. options(string): Additional arguments for Stata's encode command. 
	//////////////////////////////////////////////////////////////////////////////			
	if "`str_var_name'"=="" {
		local str_var_name `varlist'_str
	}
	rename `varlist' `str_var_name'
	encode `str_var_name', gen(`varlist') `OPTions'
	if "`vlabel'"!="" {
		label var `varlist' "`vlabel'"
	}
end
