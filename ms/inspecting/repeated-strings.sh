#!/bin/bash
SRC_TEX="paper.tex"
LOG_DIR="./inspecting/logs"
LOG_FILE="$LOG_DIR/repeated-strings.log"

# Overwrite the log file at the beginning
> "$LOG_FILE"

{
    echo "Repeated unigrams:"
    egrep "\b([a-zA-Z]+) \1\b" "$SRC_TEX" -n

    echo "Repeated bigrams:"
    egrep "\b(\S+) (\S+) \1 \2\b" "$SRC_TEX" -n

    echo "Repeated trigrams:"
    egrep "\b(\S+) (\S+) (\S+) \1 \2 \3\b" "$SRC_TEX" -n
} 2>&1 | tee -a "$LOG_FILE"