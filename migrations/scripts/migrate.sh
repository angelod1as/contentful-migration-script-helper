#!/bin/sh
# Don't forget to chmod this file :)

source .env.local

# Make sure you are logged in
pnpm contentful login

# Save into variables:
MIGRATIONS_DIR="migrations/contentful"
REGISTRY_FILE="migrations/migrations-registry.txt"

# Ensure the migrations directory and registry file exist.
mkdir -p "$MIGRATIONS_DIR"

if [ ! -f "$REGISTRY_FILE" ]; then
  touch "$REGISTRY_FILE"
fi

# Loop through the JavaScript files in the migrations folder.
for file in "$MIGRATIONS_DIR"/*.js; do
  filename=$(basename "$file")
  filename_no_ext=$(basename "$file" .js)

  # If their filename (without extension) is found in the registry-file, skip it.
  if grep -q "$filename_no_ext" "$REGISTRY_FILE"; then
    echo "Skipping migration: $filename (already run)"
    continue
  fi

  # Run the migration using the JS file.
  echo "Running migration: $filename"
  contentful space migration --space-id "$CONTENTFUL_SPACE_ID" "$file"

  # Check if migration was successful.
  if [ $? -eq 0 ]; then
    # Add the migration filename (without extension) to the registry.
    echo "$filename_no_ext" >> "$REGISTRY_FILE"
    echo "Migration $filename successfully run and registered."
  else
    echo "Migration $filename failed."
    exit 1
  fi
done

echo "Migration process completed."