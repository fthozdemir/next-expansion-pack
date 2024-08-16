import { createLocalizedPathnamesNavigation } from "next-intl/navigation";

import { localePrefix, /* ... */ locales, pathnames } from "@/i18n";
// TODO: Fix record strings
const { Link, redirect, usePathname, useRouter, getPathname } =
  createLocalizedPathnamesNavigation({
    locales,
    pathnames: pathnames as typeof pathnames & Record<string, string>,
    localePrefix,
  });

export { Link, redirect, usePathname, useRouter, getPathname };
