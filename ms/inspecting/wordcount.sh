#!/bin/bash

SRC_TEX="paper.tex"
LOG_DIR="./inspecting/logs"

# total: Do not give sums per file, only total sum.
# nobib: Do not include bibliography in count (default).
# sum Make sum of all word and equation counts. May also use
             # -sum=#[,#] with up to 7 numbers to indicate how each of the
             # counts (text words, header words, caption words, #headers,
             # #floats, #inlined formulae, #displayed formulae) are summed.
             # The default sum (if only -sum is used) is the same as
             # -sum=1,1,1,0,0,1,1.
# sub: Generate subcounts. Option values are none, part, chapter,
             # section or subsection. Default (-sub) is set to subsection,
             # whereas unset is none. (Alternative option name is -subcount.)
# inc: Parse included TeX files (as separate file).
# quiet: Quiet mode, no error messages. Use is discouraged!
TEXCOUNT_OUTPUT=$(texcount \
    -total \
    -nobib \
    -sum \
    -sub \
    -inc \
    -quiet \
    "$SRC_TEX"
)

echo "Word count report for $SRC_TEX: $TEXCOUNT_OUTPUT"

# Store total word count
OUTPUT_FILE="$LOG_DIR/wordcount.txt"

STORE=$(texcount \
    -1 \
    -nobib \
    -nosum \
    -quiet \
    "$SRC_TEX")

echo "$STORE" > "$OUTPUT_FILE"

# Store detailed word count
DETAILED_OUTPUT_FILE="$LOG_DIR/wordcount-detailed.txt"

STORE=$(texcount \
    -nobib \
    -quiet \
    "$SRC_TEX")

echo "$STORE" > "$DETAILED_OUTPUT_FILE"