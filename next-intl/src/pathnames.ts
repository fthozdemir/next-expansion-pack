import { Pathnames } from "next-intl/routing";
import { locales } from "@/i18n";
export const pathnames = {
  "/translated": {
    en: "/translated",
    tr: "/ceviri",
  },
} satisfies Pathnames<typeof locales>;
