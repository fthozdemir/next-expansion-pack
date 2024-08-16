/*eslint-disable */
import { readFile, writeFile, mkdir } from "fs/promises";
import path from "path";
import dotenv from "dotenv";
dotenv.config();

export default {
  description: "Component Story Generator",
  prompts: [
    {
      type: "fuzzypath",
      message: "Component name for story",
      name: "path",
      rootPath: "src",
      itemType: "file",
    },
  ],
  actions: [
    {
      type: "custom",
      run: async (data) => {
        try {
          console.log("data: ", data);
          const filePath = data.path;
          const fileContent = await readFile(filePath, "utf8");
          const bearer = `Bearer ${process.env.OPENAI_API_KEY}`;
          const content = `This is important. Only and only give me code. This is very important only send code as response !!\n
          also I give you to see this example code for your reference:\n\n${exampleResponse}\n\n
          rule1: which is when I give you {filePath} it means component route is it but without src/ and .tsx extension. add @/ in front of it. \n\n
          rule2:which is consider the given component export itself with export const or export default, while generating stories.ts file. Always import things right \n\n
          rule3: also the {filePath} is "title" of the storie file but without src \n\n
          rule4: always import tags: ['autodocs'],\n\n
          Be very careful with the rules. \n\n
          Be very careful with arguments of component. \n\n
          filePath: ${filePath}\n\n
Generate a stories.ts file for the following React component:\n\n${fileContent}`;
          const response = await fetch(
            "https://api.openai.com/v1/chat/completions",
            {
              method: "POST",
              headers: {
                "Content-Type": "application/json",
                Authorization: bearer,
              },
              body: JSON.stringify({
                model: "gpt-4o",
                messages: [
                  {
                    role: "user",
                    content,
                  },
                ],
                max_tokens: 1500,
                temperature: 0.5,
              }),
            }
          );

          const responseData = await response.json();
          //@ts-ignore
          let aiResponse = responseData.choices[0].message.content;
          aiResponse = aiResponse
            .replace(/^```typescript\s+/, "")
            .replace(/^```tsx\s+/, "")
            .replace(/^```\s+/, "")
            .replace(/\s*```$/, "");

          const outputDir = filePath.replace(/\/[^/]*$/, "/__stories__");

          const outputPath = path.join(
            outputDir,
            filePath
              .split("/")
              .pop()
              .replace(/\.tsx$/, ".stories.tsx")
          );

          await mkdir(outputDir, { recursive: true });
          await writeFile(outputPath, aiResponse, "utf8");

          console.log(`Story file generated at ${outputPath}`);
        } catch (error) {
          console.error("Error generating story file:", error);
        }
      },
    },
  ],
};

const exampleResponse = `
// Button component
import type { Meta, StoryObj } from '@storybook/react';
import { fn } from '@storybook/test';
import { Button } from './Button';

// More on how to set up stories at: https://storybook.js.org/docs/writing-stories#default-export
const meta = {
  title: 'Example/Button',
  component: Button,
  parameters: {
    // Optional parameter to center the component in the Canvas. More info: https://storybook.js.org/docs/configure/story-layout
    layout: 'centered',
  },
  // This component will have an automatically generated Autodocs entry: https://storybook.js.org/docs/writing-docs/autodocs
  tags: ['autodocs'],
  // More on argTypes: https://storybook.js.org/docs/api/argtypes
  // Use fn to spy on the onClick arg, which will appear in the actions panel once invoked: https://storybook.js.org/docs/essentials/actions#action-args
  args: { onClick: fn() },
} satisfies Meta<typeof Button>;

export default meta;
type Story = StoryObj<typeof meta>;

// More on writing stories with args: https://storybook.js.org/docs/writing-stories/args
export const Primary: Story = {
  args: {
    primary: true,
    label: 'Button',
  },
};

export const Secondary: Story = {
  args: {
    label: 'Button',
  },
};

export const Large: Story = {
  args: {
    size: 'large',
    label: 'Button',
  },
};

export const Small: Story = {
  args: {
    size: 'small',
    label: 'Button',
  },
};

// Page Component
  import type { Meta, StoryObj } from "@storybook/react";
import { expect, userEvent, within } from "@storybook/test";

import { Page } from "./Page";

const meta = {
  title: "Example/Page",
  component: Page,
  parameters: {
    // More on how to position stories at: https://storybook.js.org/docs/configure/story-layout
    layout: "fullscreen",
  },
} satisfies Meta<typeof Page>;

export default meta;
type Story = StoryObj<typeof meta>;

export const LoggedOut: Story = {};

// More on interaction testing: https://storybook.js.org/docs/writing-tests/interaction-testing
export const LoggedIn: Story = {
  play: async ({ canvasElement }) => {
    const canvas = within(canvasElement);
    const loginButton = canvas.getByRole("button", { name: /Log in/i });
    await expect(loginButton).toBeInTheDocument();
    await userEvent.click(loginButton);
    await expect(loginButton).not.toBeInTheDocument();

    const logoutButton = canvas.getByRole("button", { name: /Log out/i });
    await expect(logoutButton).toBeInTheDocument();
  },
};
`;
