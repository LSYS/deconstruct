#!/bin/bash
#This script allow you to review hardcoded numbers appearing in the manuscript
#From https://github.com/jdingel/projecttemplate/blob/master/paper/reviewing/hardcodednumbers.sh
SRC_TEX="paper.tex"
LOG_DIR="./inspecting/logs"
LOG_FILE="$LOG_DIR/hardcoded-numbers.log"

for file in $(find -name $SRC_TEX)
do
	echo '===' ${file} '==='
	cat ${file} | 
	# =======================================================================
	# Ignore lines relating to environment
    sed -n '/\\begin{document}/,$p' |  # Skip lines until \begin{document}
    grep -Ev '^\\newcommand' | # Ignore lines starting with \newcommand (e.g., \newcommand{\nc}{})
    grep -Ev '^\\setcounter' | # Ignore lines starting with \setcounter
    grep -Ev '^\\vspace' | 
    grep -Ev '^\\hspace' | 
    grep -Ev '^\\usepackage' | 
    grep -Ev '^\\setlength' | 
	# =======================================================================
    # Ignore math, tables, figures
    sed '/begin{equation}/,/end{equation}/d' | sed '/begin{equation\*}/,/end{equation\*}/d' | sed '/begin{align}/,/end{align}/d' | sed '/begin{align\*}/,/end{align\*}/d' | #Remove equation environments
	sed 's/\\input{[A-Za-z0-9_\/\.]*}//g' | # Drop input files that might contain numbers
	grep -v 'includegraphics' | #Drop lines that are graphics filepaths or numbers setting the figure size
	sed 's/[0-9\.]*\\textwidth//g' |
	sed 's/\$[A-Za-z0-9+=_{}\ ]*\$//g' |  #Drop inline equations that may contain numbers
    sed '/\\begin{figure}/,/\\end{figure}/d' | # Remove lines within figure environments
    sed '/\\begin{table}/,/\\end{table}/d' | # Remove lines within table environments
	# =======================================================================
  	# Ignore commented-out lines
    sed '/\\iffalse/,/\\fi/d' | # Remove lines between \iffalse and \fi
    sed '/^%/d' | # Remove lines beginning with %
	# =======================================================================
	# Ignore internal links
    sed 's/\\cref{[^}]*}//g' |  # Ignore numbers from \cref{}
    sed 's/\\ref{[^}]*}//g' |  # Ignore numbers from \ref{}
    sed 's/\\nameref{[^}]*}//g' |  # Ignore numbers from \nameref{}
    sed 's/\\crefrange{[^}]*}//g' |  # Ignore numbers from \nameref{}
	# =======================================================================
    # Ignore citations
	sed 's/\\cite{[A-Za-z0-9:,\-]*}//g' | #Drop citations with \cite{} that may contain numbers
	sed 's/\\citealt{[^}]*}//g' |  #Drop citations with \citealt{} that may contain numbers
    sed 's/\\citep{[^}]*}//g' |  # This seems to work for \citep and not line 16..
    sed 's/\\citet{[^}]*}//g' |  # This seems to work for \citep and not line 16..
    sed 's/\\cite{[^}]*}//g' |  
	grep '[0-9]' -n 
done > $LOG_FILE

cat $LOG_FILE