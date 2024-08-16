import { notFound } from "next/navigation";
import { LocalePrefix } from "next-intl/routing";
import { getRequestConfig } from "next-intl/server";

export * from "./pathnames";
// Define a union type for supported locales
export type SupportedLocale = "en" | "tr";

// Define the locales array with the correct type
export const locales: readonly SupportedLocale[] = ["en", "tr"] as const;
export const localePrefix: LocalePrefix<typeof locales> = "always";
export const defaultLocale: SupportedLocale = "en";

export const localeLangDict = {
  en: "English",
  tr: "Türkçe",
};

// Create a type guard function to check if a locale is supported
function isSupportedLocale(locale: string): locale is SupportedLocale {
  return locales.includes(locale as SupportedLocale);
}

export default getRequestConfig(async ({ locale }) => {
  // Validate that the incoming `locale` parameter is valid
  if (!isSupportedLocale(locale)) {
    notFound();
  }

  // Use a type assertion for the dynamic import
  const messages = (await import(`../messages/${locale}.json`)) as {
    default: Record<string, string>;
  };

  return {
    messages: messages.default,
  };
});
