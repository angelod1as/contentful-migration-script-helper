#!/bin/sh
# Don't forget to chmod this file :)

if [ $# -ne 1 ]; then
  echo "Error: This script requires one argument: <filename>"
  exit 1
fi

FILENAME="$1"
MIGRATIONS_DIR="migrations/contentful/migrations"

# Ensure migrations directory exists
mkdir -p "$MIGRATIONS_DIR"

## BUILDING THE FILENAME
existing_files=$(ls "$MIGRATIONS_DIR"/????-*.ts 2>/dev/null | sort -r)

if [ -z "$existing_files" ]; then
  new_number="0001"
else
  latest_file=$(echo "$existing_files" | head -n 1)
  latest_number=$(basename "$latest_file" | cut -d '-' -f 1)
  new_number=$((10#$latest_number + 1)) # Force base 10 arithmetic
  new_number=$(printf "%04d" "$new_number")
fi

new_filename="$new_number-$FILENAME.ts"
new_filepath="$MIGRATIONS_DIR/$new_filename"

# Create the TypeScript migration file with the desired format
cat <<EOF > "$new_filepath"
import Migration from "contentful-migration"

export = function (migration: Migration) {
  const newContentType = migration
}
EOF

echo "Migration generated successfully: $new_filename"