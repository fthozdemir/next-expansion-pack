# Storybook Expantion

This expansion will install and configure Storybook to work with Tailwind CSS. It generates your stories with OpenAI.

## Installation

```bash
curl -s https://raw.githubusercontent.com/fthozdemir/next-expansion-pack/main/storybook/trigger.sh | bash -s
```

**_Attention:_** Storybook will automatically start while installing itself. To continue the expansion installation, interrupt the process in the terminal by pressing (cmd + c).

## Configuration

The Bash script automatically adds the **OPEN_AI_APIKEY** environment variable to all necessary files. Just don't forget to add your key in the .env file.

## Usage

`pnpm plop` will generate a .stories file for the selected component. To select your file, just type five characters of the file name, and you may select the desired one with the arrow keys in the terminal.
