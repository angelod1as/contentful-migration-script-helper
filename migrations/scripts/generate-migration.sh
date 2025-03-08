#!/bin/sh
# Don't forget to chmod this file :)

source .env.local

if [ $# -ne 2 ]; then
  echo "Error: This script requires two arguments: <environment> <filename>"
  exit 1
fi

ENVIRONMENT="$1"
FILENAME="$2"
MIGRATIONS_DIR="migrations/contentful"

# Ensure migrations directory exists
mkdir -p "$MIGRATIONS_DIR"

## BUILDING THE FILENAME
existing_files=$(ls "$MIGRATIONS_DIR"/????-*.js 2>/dev/null | sort -r)

if [ -z "$existing_files" ]; then
  new_number="0001"
else
  latest_file=$(echo "$existing_files" | head -n 1)
  latest_number=$(basename "$latest_file" | cut -d '-' -f 1)
  new_number=$((10#$latest_number + 1)) # Force base 10 arithmetic
  new_number=$(printf "%04d" "$new_number")
fi

new_filename="$new_number-$FILENAME.js"
new_filepath="$MIGRATIONS_DIR/$new_filename"

# Run the script
echo "Generating migration: $new_filename"
contentful space generate migration -s "$CONTENTFUL_SPACE_ID" -e "$ENVIRONMENT" -f "$new_filepath"

# Check the exit code
if [ $? -ne 0 ]; then
    echo "Error: contentful space generate migration failed."
    exit 1
fi

echo "Migration generated successfully: $new_filename"