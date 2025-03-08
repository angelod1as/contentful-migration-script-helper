#!/bin/sh
# Don't forget to chmod this file :)

source .env.local

# Make sure you are logged in
pnpm contentful login

MIGRATIONS_DIR="migrations/contentful"
REGISTRY_FILE="migrations/migrations-registry.txt"

# Ensure registry file exists
if [ ! -f "$REGISTRY_FILE" ]; then
  touch "$REGISTRY_FILE"
fi

for file in "$MIGRATIONS_DIR"/*.ts; do
  filename=$(basename "$file")

  # Check if the migration has already been run
  if grep -q "$filename" "$REGISTRY_FILE"; then
    echo "Skipping migration: $filename (already run)"
    continue
  fi

  # Run the migration
  echo "Running migration: $filename"
  contentful space migration --space-id "$CONTENTFUL_SPACE_ID" "$file"

  # Check if the migration was successful (you might want to add more robust error handling)
  if [ $? -eq 0 ]; then
      # Add the migration filename to the registry
      echo "$filename" >> "$REGISTRY_FILE"
      echo "Migration $filename successfully run and registered."
  else
      echo "Migration $filename failed."
      exit 1 # Exit with an error code
  fi
done

echo "Migration process completed."