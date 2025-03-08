#!/bin/sh
# Don't forget to chmod this file :)

source .env.local

# Make sure you are logged in
pnpm contentful login

# Save into variables:
MIGRATIONS_DIR="migrations/contentful/migrations"
REGISTRY_FILE="migrations/contentful/scripts/migrations-registry.txt"
TEMP_DIR="migrations/contentful/temp-folder"

# Ensure the migrations directory and registry file exist.
mkdir -p "$MIGRATIONS_DIR"
mkdir -p "$TEMP_DIR"

if [ ! -f "$REGISTRY_FILE" ]; then
  touch "$REGISTRY_FILE"
fi

# Loop through the TypeScript files in the migrations folder.
for file in "$MIGRATIONS_DIR"/*.ts; do
  filename=$(basename "$file" .ts)

  # If their filename (without extension) is found in the registry-file, skip it.
  if grep -q "$filename" "$REGISTRY_FILE"; then
    echo "Skipping migration: $filename (already run)"
    continue
  fi

  # Transpile the TS file to JS in the temporary folder.
  echo "Transpiling migration: $filename"
  npx tsc "$file" --outDir "$TEMP_DIR"

  # Check if the transpilation was successful.
  if [ $? -ne 0 ]; then
    echo "Transpilation of $filename failed."
    exit 1
  fi

  # Run the migration using the transpiled JS file.
  echo "Running migration: $filename"
  contentful space migration --space-id "$CONTENTFUL_SPACE_ID" "$TEMP_DIR/$filename.js"

  # Check if migration was successful.
  if [ $? -eq 0 ]; then
    # Add the migration filename (without extension) to the registry.
    echo "$filename" >> "$REGISTRY_FILE"
    echo "Migration $filename successfully run and registered."
  else
    echo "Migration $filename failed."
    exit 1
  fi
done

# Clean up the temporary folder.
rm -rf "$TEMP_DIR"

echo "Migration process completed."