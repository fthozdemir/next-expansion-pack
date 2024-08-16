import Head from "next/head";
import { useTranslations } from "next-intl";
import * as React from "react";

import { Button } from "@/components/button";
import { Skeleton } from "@/components/skeleton";

export default function ComponentPage() {
  const t = useTranslations("components");

  return (
    <section>
      <Head>{t("components")}</Head>
      <h1>{t("components")}</h1>
      <h2>{t("button")}</h2>
      <div className="flex gap-4">
        <Button>{t("button")}</Button>
      </div>
      <div className="flex w-1/3 flex-col space-y-3">
        <h2>{t("skeleton")}</h2>
        <Skeleton className="h-[100px] w-full rounded-xl" />
        <div className="space-y-2 pt-10">
          <Skeleton className="h-[30px] w-3/5" />
          <Skeleton className="h-[30px] w-full" />
          <Skeleton className="h-[30px] w-3/4" />
        </div>
      </div>
    </section>
  );
}
