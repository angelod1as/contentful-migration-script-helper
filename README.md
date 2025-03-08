# Contentful Migration Script Helper

This is a tiny step-by-step helper to manage Contentful Migration Scripts using Contentful CLI and Bash scripts.

- No installation, just copy and paste.
- Tracks which migrations ran without any new Content Model (using a good and old text file!)
- Need to make changes? Just write them! It's easy 🎉

## Requirements

- `contentful-cli`
- A Contentful account
- A Node.js project

## Setup

1. Copy the `migrations` folder to your project's root.
2. Allow the scripts to run by running `chmod 777 ./migrations/generate-migration.sh ./migrations/migrate.sh`.
3. Add your `CONTENTFUL_SPACE_ID` to your `.env.local` file
   - If you are using a different named `.env` file, you'll need to edit the `.sh` files
4. For extra pizzaz, add to your `package.json` `scripts`:

```json
    "cf:new": "./migrations/scripts/generate-migration.sh",
    "cf:migrate": "./migrations/scripts/migrate.sh"
```

## Running

(change `pnpm` to `yarn` or `npm` or whatever)

1. Run `pnpm cf:new <environment> <filename>` to generate a new migration file.
2. Edit your migration file
3. run `pnpm cf:migrate` to run the migration and log it in your registry.

## Caveats

1. I'm using Typescript. If you want to use `js`, change line `19` and `30` of `generate-migration.sh`.
2. This is a very personal way of dealing with this "migration registry" issue and I'd love to get suggestions.
