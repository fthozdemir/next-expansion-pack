import { useTranslations } from "next-intl";
import * as React from "react";
import { Link } from "@/lib/navigation";
import { LanguageSwitcher } from "@/components/language-switcher";

export default function HomePage() {
  const t = useTranslations("home");

  return (
    <main>
      <section className="container flex  items-center justify-center bg-white">
        <div className="relative flex min-h-screen flex-col items-center justify-center py-12 gap-4 text-center">
          <h1 className="mt-8 text-4xl md:text-6xl">{t("helloWorld")}</h1>
          <p className="mt-4 max-w-lg text-lg">{t("welcome")}</p>
          <LanguageSwitcher />

          <Link
            href="/components"
            className="mt-8 px-4 py-2 bg-blue-500 text-white rounded-md"
          >
            Components
          </Link>
        </div>
      </section>
    </main>
  );
}
