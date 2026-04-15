#!/bin/bash

SRC_TEX="paper.tex"
LOG_DIR="./inspecting/logs"
LOG_FILE="$LOG_DIR/acronyms.log"

# Ensure the log directory exists
mkdir -p "$LOG_DIR"

# Overwrite the log file at the start
> "$LOG_FILE"

# Function to process files, renamed to "acronyms"
acronyms() {
  local file="$1"
  
  # Check if file exists
  if [[ ! -f "$file" ]]; then
    echo "Error: $file not found" | tee -a "$LOG_FILE"
    return 1
  fi

  echo "Checking file: $file" | tee -a "$LOG_FILE"
  
  # Output file marker
  echo '===' "$file" '===' | tee -a "$LOG_FILE"
  
  cat "$file" | 
  # Process the file content and log results
  # =======================================================================
  # Ignore lines relating to environment
  sed -n '/\\begin{document}/,$p' |  # Skip lines until \begin{document}
  grep -Ev '^\\newcommand' | # Ignore lines starting with \newcommand (e.g., \newcommand{\nc}{} )
  grep -Ev '^\\setcounter' | # Ignore lines starting with \setcounter
  grep -Ev '^\\vspace' | 
  grep -Ev '^\\hspace' | 
  grep -Ev '^\\usepackage' | 
  grep -Ev '^\\setlength' | 
  # =======================================================================
  # Ignore math, tables, figures
  sed '/begin{equation}/,/end{equation}/d' | sed '/begin{equation\*}/,/end{equation\*}/d' | sed '/begin{align}/,/end{align}/d' | sed '/begin{align\*}/,/end{align\*}/d' | # Remove equation environments
  sed 's/\\input{[A-Za-z0-9_\/\.]*}//g' | # Drop input files that might contain numbers
  grep -v 'includegraphics' | # Drop lines that are graphics filepaths or numbers setting the figure size
  sed 's/[0-9\.]*\\textwidth//g' |
  sed 's/\$[A-Za-z0-9+=_{}\ ]*\$//g' |  # Drop inline equations that may contain numbers
  sed '/\\begin{figure}/,/\\end{figure}/d' | # Remove lines within figure environments
  sed '/\\begin{table}/,/\\end{table}/d' | # Remove lines within table environments
  # =======================================================================
  # Ignore commented-out lines
  sed '/\\iffalse/,/\\fi/d' | # Remove lines between \iffalse and \fi
  sed '/^%/d' | # Remove lines beginning with %
  # =======================================================================
  # Ignore citations
  sed 's/\\cite{[A-Za-z0-9:,\-]*}//g' | # Drop citations with \cite{} that may contain numbers
  sed 's/\\citealt{[^}]*}//g' |  # Drop citations with \citealt{} that may contain numbers
  sed 's/\\citep{[^}]*}//g' |  # This seems to work for \citep and not line 16..
  sed 's/\\citet{[^}]*}//g' |  # This seems to work for \citep and not line 16..
  # =======================================================================
  grep -wo "[A-Z]\+\{2,20\}" | sort | uniq -c | sort -gr |
  tee -a "$LOG_FILE"  # Log results to file
}

# Main loop to find and process all files named $SRC_TEX
find . -name "$SRC_TEX" | while IFS= read -r file; do
  acronyms "$file"
done
