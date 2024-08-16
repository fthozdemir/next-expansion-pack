"use client";

import { useLocale } from "next-intl";
import React from "react";

import { usePathname } from "@/lib/navigation";
import { Link } from "@/lib/navigation";
import { cn } from "@/lib/utils";

import { locales, type SupportedLocale } from "@/i18n";
export const LanguageSwitcher: React.FC = () => {
  const locale = useLocale() as SupportedLocale;
  const pathname = usePathname();
  return (
    <Link
      className={cn(
        "w-8 h-8 bg-[#646464] text-white font-bold text-xs rounded flex items-center justify-center cursor-pointer",
      )}
      href={{
        pathname: pathname,
        //@ts-expect-error idontknow why
        params: { blogSlug: "" },
      }}
      locale={locales.find((l) => l !== locale) || locale}
    >
      {locales.find((l) => l !== locale)!.toLocaleUpperCase(locale)}
    </Link>
  );
};
