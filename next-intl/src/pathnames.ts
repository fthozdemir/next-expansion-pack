import { Pathnames } from "next-intl/routing";
import { locales } from "@/i18n";
export const pathnames = {
  "/": {
    en: "/translated",
    tr: "/ceviri",
  },
  "/components": {
    en: "/components",
    tr: "/bilesenler",
  },
} satisfies Pathnames<typeof locales>;
