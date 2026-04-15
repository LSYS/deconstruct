#!/bin/bash

SRC_TEX="paper.tex"
LOG_DIR="./inspecting/logs"
LOG_FILE="$LOG_DIR/linkchecker.log"

# Ensure the log directory exists
mkdir -p "$LOG_DIR"

# Overwrite the log file at the beginning
> "$LOG_FILE"

# Log and output both stdout and stderr
{
    echo "---> Retrieving URL(s) in \href{}{}:"
    # This one reverses the escaping of \# in the URL
    HREF_LIST=$(grep -o 'href{[A-Za-z0-9:/\._?#=]*}' "$SRC_TEX" | sed 's/.*href{//' | sed 's/}//;s/\\#/#/')

    echo "---> Retrieving URL(s) in \url{}:"
    URL_LIST=$(grep -o '\\url{[^}]*}' "$SRC_TEX" | sed 's/\\url{//;s/}//;s/\\#/#/g')

    echo "---> Retrieving all other URLs"
    GLOBAL_LIST=$(cat "$SRC_TEX" | egrep -o "(http|https)://[a-zA-Z0-9./?=_%:-]*" | sort -u)

    ALL_URLS=$(echo "$HREF_LIST $URL_LIST $GLOBAL_LIST" | tr ' ' '\n' | sort -u)
    for URL in $ALL_URLS; 
    do
        echo "Checking URL: $URL"
        wget --spider --no-verbose "$URL"
    done
} 2>&1 | tee -a "$LOG_FILE"
