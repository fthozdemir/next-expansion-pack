#!/bin/bash

RED='\033[0;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
NC='\033[0m'

echo -e "${CYAN}========================="
echo "Storybook Expansion"
echo "========================="
echo -e "${NC}"


#region  //*=========== Install Packages ===========
echo -e "${NC}"
echo -e "${GREEN}[Step 1] Initializing Storybook ${NC}"
echo -e "This may take a while to download."
echo ""
echo y | pnpm dlx storybook@latest init
echo -e ""
echo ""
echo npx storybook@latest add @storybook/addon-themes
echo -e ""

echo -e "Installing Dev Packages: ${GREEN}plop inquirer-fuzzy-path and dotenv"
echo -e "${NC}"
pnpm install -D  plop inquirer-fuzzy-path dotenv


echo -e "${GREEN}[Step 2] Adding BROWSER=none to pnpm storybook${NC}"
npx -y npe scripts.storybook "storybook dev -p 6006 --ci"

echo -e "${GREEN}[Step 3] Disabling Telemetry data of Storybook${NC}"
# Insert the core configuration in .storybook/main.ts
awk '/const config: StorybookConfig = {/ {
    print
    print "  core: {"
    print "    disableTelemetry: true, // 👈 Disables telemetry"
    print "  },"
    next
}1' .storybook/main.ts > .storybook/main.tmp && mv .storybook/main.tmp .storybook/main.ts

#endregion  //*======== Install Packages ===========


#region  //*=========== Add Files ===========
mkdir -p src/generators
# ======== Create Directories ===========

#=========== Downloading Files ===========
echo ""
echo -e "${GREEN}[Step 4] Downloading files${NC}"
echo ""

DIRNAME="storybook"
REPO="https://raw.githubusercontent.com/fthozdemir/expansion-pack/main"

files=(
  "plopfile.mjs"
  "src/generators/story.mjs"
)
for i in "${files[@]}"
do
  echo "Downloading... $i"
  curl -LJs -o $i $REPO/$DIRNAME/$i
done

#endregion  //*=========== Add Files ===========

#region  //*=========== Add Tailwind ===========
echo -e "${GREEN}[Step 6] Adding import to .storybook/preview.ts${NC}"
# Add import statement to the first line of .storybook/preview.ts
PREVIEW_TS=".storybook/preview.ts"
IMPORT_STATEMENT='import "@/styles/globals.css";'

if ! grep -q "$IMPORT_STATEMENT" "$PREVIEW_TS"; then
  echo "$IMPORT_STATEMENT" | cat - "$PREVIEW_TS" > temp && mv temp "$PREVIEW_TS"
  if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Failed to add import statement to $PREVIEW_TS.${NC}"
    exit 1
  fi
else
  echo -e "${GREEN}Import statement already exists in $PREVIEW_TS.${NC}"
fi

#endregion  //*=========== Add Tailwind ===========



#region  //*=========== Add Envs ===========

API_KEY_LINE='OPENAI_API_KEY="sk-..."'
VALIDATION_LINE='  OPENAI_API_KEY: z.string().min(8, "OPENAI_API_KEY is required"),'

# Add API key to all .env.* files
for file in .env.*; do
  if [ -f "$file" ]; then
    if ! grep -q "^${API_KEY_LINE}" "$file"; then
      echo "$API_KEY_LINE" >> "$file"
      echo -e "${GREEN}Added OPENAI_API_KEY to $file${NC}"
    else
      echo -e "${CYAN}OPENAI_API_KEY already exists in $file${NC}"
    fi
  else
    echo -e "${RED}No .env* files found!${NC}"
  fi
done

# Add validation line to src/lib/env.ts
ENV_FILE="src/lib/env.ts"

if [ -f "$ENV_FILE" ]; then
  if ! grep -q "$VALIDATION_LINE" "$ENV_FILE"; then
    # Use sed to add the validation line after the "z.object({" line
    sed -i '' "/z\.object({/a\\
$VALIDATION_LINE
" "$ENV_FILE"

    # Verify if the line was added
    if grep -q "$VALIDATION_LINE" "$ENV_FILE"; then
      echo -e "${GREEN}Added OPENAI_API_KEY validation to $ENV_FILE${NC}"
    else
      echo -e "${RED}Failed to add OPENAI_API_KEY validation to $ENV_FILE${NC}"
    fi
  else
    echo -e "${CYAN}OPENAI_API_KEY validation already exists in $ENV_FILE${NC}"
  fi
else
  echo -e "${RED}$ENV_FILE not found!${NC}"
fi

#endregion  //*=========== Add Envs ===========
echo ""
echo -e "${CYAN}============================================"
echo "🔋 Storybook Expansion Completed"
echo "dont forget to add your OPENAI_API_KEY to your .env files"
echo "Run pnpm plop to generate your storybook components"
echo "Run pnpm storybook to start the storybook"

