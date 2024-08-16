import createMiddleware from "next-intl/middleware";

import { defaultLocale, localePrefix, locales, pathnames } from "@/i18n";

export default createMiddleware({
  // A list of all locales that are supported
  locales,
  // Used when no locale matches
  defaultLocale,
  alternateLinks: true,
  localePrefix,
  pathnames,
});

export const config = {
  // Match only internationalized pathnames

  //matcher: ["/", matcherRegex + "/:path*"],
  matcher: ["/", "/(tr|en)/:path*", "/((?!api|_next|_vercel|.*\\..*).*)"],
};
