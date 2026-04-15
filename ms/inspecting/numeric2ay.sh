#!/bin/bash

SRC_TEX="paper.tex"

#==================================================================================
# For periods
# Expected behavior is:
# Before---This citation should appear before the period.\cite{multi, citation, here}
# After---This citation should appear before the period \cite{multi, citation, here}.
#==================================================================================
sed -i 's/\.\\cite{\([^}]*\)}/ \\cite{\1}./g' $SRC_TEX #Change \cite{} with periods

sed -i 's/\.\\citep{\([^}]*\)}/ \\citep{\1}./g' $SRC_TEX #same as above, but for \citep

#==================================================================================
# For commas
# Expected behavior is:
# Before---This citation,\cite{einstein} should be before the comma.
# After---This citation \cite{einstein}, should be before the comma.
#==================================================================================
sed -i 's/,\\cite{\([^}]*\)}/ \\cite{\1},/g' $SRC_TEX #Change \cite{} with periods

sed -i 's/,\\citep{\([^}]*\)}/ \\citep{\1},/g' $SRC_TEX #same as above, but for \citep