#!/bin/bash

SRC_TEX="paper.tex"

#==================================================================================
# Citations after periods.
# Expected behavior is:
# Before---This citation should appear after the period \cite{multi, citation, here}.
# After----This citation should appear after the period.\cite{multi, citation, here}
#==================================================================================
sed -i 's/\s*\\cite{\([^}]*\)}\./.\\cite{\1}/g' $SRC_TEX #Change \cite{} with periods

sed -i 's/\s*\\citep{\([^}]*\)}\./.\\citep{\1}/g' $SRC_TEX #same as above, but for \citep

sed -i 's/\s*\\citealt{\([^}]*\)}\./.\\citep{\1}/g' $SRC_TEX #same as above, but for \citealt

#==================================================================================
# Citations after commas.
# Expected behavior is:
# Before---This citation \cite{einstein}, should be after the comma.
# After----This citation,\cite{einstein} should be after the comma.
#==================================================================================
sed -i 's/\s*\\cite{\([^}]*\)},/,\\cite{\1}/g' $SRC_TEX #Change \cite{} with commas

sed -i 's/\s*\\citep{\([^}]*\)},/,\\citep{\1}/g' $SRC_TEX #same as above, but for \citep

sed -i 's/\s*\\citealt{\([^}]*\)},/,\\citep{\1}/g' $SRC_TEX #same as above, but for \citealt
