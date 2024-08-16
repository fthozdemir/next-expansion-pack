import { Metadata } from "next";
import * as React from "react";

export const metadata: Metadata = {
  title: "Components",
  description: "Pre-built components with awesome default",
};
import { NextIntlClientProvider } from "next-intl";
import { getMessages } from "next-intl/server";

export default async function ComponentsLayout({
  children,
  params: { locale },
}: {
  children: React.ReactNode;
  params: { locale: string };
}) {
  const messages = await getMessages();

  return (
    <html lang={locale}>
      <body>
        <NextIntlClientProvider messages={messages}>
          <main className="container">{children}</main>;
        </NextIntlClientProvider>
      </body>
    </html>
  );
}
