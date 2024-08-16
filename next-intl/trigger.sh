#!/bin/bash

RED='\033[0;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
NC='\033[0m'
YELLOW='\033[1;33m'

echo -e "${CYAN}========================="
echo "Next-Intl Internationalization Expansion"
echo "========================="
echo -e "${NC}"

#region //*=========== Install Packages ===========
echo -e "${NC}"
echo -e "${GREEN}Downloading Next-Intl ${NC}"
echo -e "This may take a while to download."
echo ""
pnpm install next-intl

#endregion //*=========== Install Packages ===========
#region //*=========== Step 1: Add VSCode Rules ===========

# Variables for file paths
EXTENSIONS_FILE=".vscode/extensions.json"
SETTINGS_FILE=".vscode/settings.json"

# Check and add the extension to extensions.json
if [ -f "$EXTENSIONS_FILE" ]; then
    if grep -q 'lokalise.i18n-ally' "$EXTENSIONS_FILE"; then
        echo -e "${GREEN}i18n-ally extension already in recommendations.${NC}"
    else
        sed -i '' '/"recommendations": \[/a \
    "lokalise.i18n-ally",' "$EXTENSIONS_FILE"
        echo -e "${GREEN}Added i18n-ally extension to recommendations.${NC}"
    fi
else
    echo -e "${RED}Extensions file not found: $EXTENSIONS_FILE${NC}"
fi

# Add settings to settings.json
if [ -f "$SETTINGS_FILE" ]; then
    if ! grep -q 'i18n-ally.localesPaths' "$SETTINGS_FILE"; then
        # Insert the i18n-ally settings after the "prettier.singleQuote": false line
        sed -i '' '/"prettier.singleQuote": false/a \
  ,"i18n-ally.localesPaths": ["messages"],\
  "i18n-ally.keystyle": "nested"' "$SETTINGS_FILE"

        echo -e "${GREEN}Added i18n-ally settings to settings.json.${NC}"
    else
        echo -e "${GREEN}i18n-ally settings already present in settings.json.${NC}"
    fi
else
    echo -e "${RED}settings.json file not found in .vscode directory.${NC}"
fi

#endregion //*=========== Step 1: Add VSCode Rules ===========

#region //*=========== Step 2: Add eslint Rules ===========

echo "${CYAN} Addind eslint rules"
# Variables for file paths
ESLINT_FILE=".eslintrc.json"

# Add ESLint rule
if [ -f "$ESLINT_FILE" ]; then
    if ! grep -q 'no-restricted-imports' "$ESLINT_FILE"; then
        # Add the new rule before the last closing curly brace in the "rules" object
        sed -i '' '/"rules": {/a \
    "no-restricted-imports": [\
      "error",\
      {\
        "name": "next/link",\
        "message": "Please import from `@/navigation` instead."\
      },\
      {\
        "name": "next/navigation",\
        "importNames": ["redirect", "permanentRedirect", "useRouter", "usePathname"],\
        "message": "Please import from `@/navigation` instead."\
      }\
    ],' "$ESLINT_FILE"

        echo -e "${GREEN}Added no-restricted-imports rule to .eslintrc.json.${NC}"
    else
        echo -e "${GREEN}no-restricted-imports rule already exists in .eslintrc.json.${NC}"
    fi
else
    echo -e "${RED}.eslintrc.json file not found.${NC}"
fi
echo "${GREEN}DONE:${NE} Addind eslint rules"

#endregion //*=========== Step 2: Add eslint Rules ===========

#region //*=========== Step 3: Configure next.config.mjs ===========
echo "${CYAN} Configuring next.config.mjs"
# Variables for file paths
CONFIG_FILE="next.config.mjs"

# Add imports at the top of the config file
if [ -f "$CONFIG_FILE" ]; then
    if ! grep -q 'import createNextIntlPlugin from "next-intl/plugin";' "$CONFIG_FILE"; then
        # Add the import lines at the top of the file
        sed -i '' '1i\
import createNextIntlPlugin from "next-intl/plugin";\
const withNextIntl = createNextIntlPlugin();\
' "$CONFIG_FILE"
        echo -e "${GREEN}Added import statements at the top of config.mjs.${NC}"
    else
        echo -e "${GREEN}Import statements already present in config.mjs.${NC}"
    fi
    
    # Replace the export line at the end of the file
    if grep -q 'export default nextConfig;' "$CONFIG_FILE"; then
        sed -i '' 's|export default nextConfig;|export default withNextIntl(nextConfig);|' "$CONFIG_FILE"
        echo -e "${GREEN}Replaced export statement in config.mjs.${NC}"
    else
        echo -e "${CYAN}Export statement already modified in config.mjs.${NC}"
    fi
else
    echo -e "${RED}config.mjs file not found.${NC}"
fi

echo "${GREEN}DONE:${NE} Configuring next.config.mjs"
#endregion //*=========== Step 3: Configure next.config.mjs ===========

#region //*=========== Step 4: Add files ===========
# ======== Create Directories ===========

#=========== Downloading Files ===========
echo ""
echo -e "${GREEN}[Step 4] Downloading files${NC}"
echo ""

# Check if the script is running in an interactive shell
if [[ -t 0 ]]; then
  INTERACTIVE=true
else
  INTERACTIVE=false
fi

# Start the file downloading process
echo ""
echo -e "${GREEN}[Step 4] Downloading files${NC}"
echo ""

DIRNAME="next-intl"
REPO="https://raw.githubusercontent.com/fthozdemir/next-expansion-pack/main"
files=(
  "src/pathnames.ts"
  "src/middleware.ts"
  "src/i18n.ts"
  "src/lib/navigation.ts"
  "src/components/language-switcher.tsx"
  "src/app/[locale]/page.tsx"
  "src/app/[locale]/components/layout.tsx"
  "src/app/[locale]/components/page.tsx"
  "messages/en.json"
  "messages/tr.json"
)

# Loop through the list of files
for file in "${files[@]}"
do
  # Create directory structure for the file
  dir_path=$(dirname "$file")
  mkdir -p "$dir_path"

  # Encode the file path for the URL
  encoded_file=$(echo "$file" | sed 's/\[/%5B/g; s/\]/%5D/g')

  if [ -f "$file" ]; then
    if $INTERACTIVE; then
      # Prompt the user if the file already exists
      echo -e "${YELLOW}File '$file' already exists. Do you want to overwrite it? (yes/no)${NC}"
      read -r answer
      if [[ "$answer" =~ ^[Yy]$ ]]; then
          echo -e "${CYAN}Overwriting $file with $REPO/$DIRNAME/$encoded_file${NC}"
          curl -LJs -o "$file" "$REPO/$DIRNAME/$encoded_file"
          if [ $? -eq 0 ]; then
            echo -e "${GREEN}Successfully overwritten: $file${NC}"
          else
            echo -e "${RED}Failed to overwrite: $file${NC}"
          fi
      else
          echo -e "${RED}$file not changed, please add changes manually.${NC}"
      fi
    else
      # Non-interactive mode: default to overwrite or skip
      echo -e "${CYAN}Overwriting (non-interactive): $file with $REPO/$DIRNAME/$encoded_file${NC}"
      curl -LJs -o "$file" "$REPO/$DIRNAME/$encoded_file"
      if [ $? -eq 0 ]; then
        echo -e "${GREEN}Successfully overwritten: $file${NC}"
      else
        echo -e "${RED}Failed to overwrite: $file${NC}"
      fi
    fi
  else
    # Download the file if it doesn't exist
    echo -e "${CYAN}Downloading $file from $REPO/$DIRNAME/$encoded_file${NC}"
    curl -LJs -o "$file" "$REPO/$DIRNAME/$encoded_file"
    if [ $? -eq 0 ]; then
      echo -e "${GREEN}Downloaded: $file${NC}"
    else
      echo -e "${RED}Failed to download: $file${NC}"
    fi
  fi
done


#endregion //*=========== Step 4: Add files ===========

echo ""
echo -e "${CYAN}============================================"
echo "🔋Next-Intl Internationalization Expansion Completed"


