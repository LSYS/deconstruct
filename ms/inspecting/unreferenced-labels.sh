#!/bin/bash
# From https://github.com/jdingel/projecttemplate/blob/master/paper/reviewing/Makefile
SRC_TEX="paper.tex"
LOG_DIR="./inspecting/logs"
LOG_FILE="$LOG_DIR/unreferenced-labels.log"

diff \
  --side-by-side \
  --suppress-common-lines \
  <(grep -o --no-filename 'ref{[A-Za-z0-9:_]*}' "$SRC_TEX" | sed 's/ref//' | sort | uniq) \
  <(grep -o --no-filename 'label{[A-Za-z0-9:_]*}' "$SRC_TEX" | sed 's/label//' | sort | uniq) |
  tee "$LOG_FILE"
