cls 					// Clear results window
clear all               // Start with a clean slate
set more off, perm      // Disable partitioned output
macro drop _all         // Clear all macros to avoid namespace conflicts
set linesize 150        // Line size limit to make output more readable, affects logs
set varabbrev off, perm // Turn off variable abbreviation
// pause on                // Enable pause mode for debugging
version 13.1            // Set Stata version to 13.1

// Set root path
// cap net install here, from("https://raw.githubusercontent.com/korenmiklos/here/master/")
cap here
if _rc == 0 {
	here, set
	cd ${here}
}
else {
	global here "\\wsl.localhost\Debian\home\lsys\deconstruct\analysis"
	cd $here
}

// Point to ado programs
adopath ++ ./ado

// import delimited "..\build\mergeForStata\output\forStata19.csv"
use ../build/7-merge/output/panel.dta

