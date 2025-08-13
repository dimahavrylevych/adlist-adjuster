#!/bin/bash

URL="https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
OUTPUT="filtered_adlist.txt"
TMPFILE=$(mktemp)

# Array of words to filter out
#FILTER_WORDS=("googleadservices" "tracker")
FILTER_WORDS=("googleadservices")

echo "Starting adlist adjustment script..."
echo "Downloading file from: $URL"
curl -s "$URL" -o "$TMPFILE"
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to download file from $URL"
    rm "$TMPFILE"
    exit 1
fi
echo "Download complete. Temporary file: $TMPFILE"

# Build grep pattern
PATTERN=$(printf "|%s" "${FILTER_WORDS[@]}")
PATTERN="${PATTERN:1}"
echo "Filtering out lines containing: ${FILTER_WORDS[*]}"
echo "Using grep pattern: $PATTERN"

# Remove lines containing any word from the array and save to output
grep -Ev "$PATTERN" "$TMPFILE" > "$OUTPUT"
if [[ $? -eq 0 ]]; then
    echo "Filtering complete. Output saved to: $OUTPUT"
else
    echo "Error: Filtering failed."
fi

# Clean up
rm "$TMPFILE"
echo "Temporary file removed. Script finished."