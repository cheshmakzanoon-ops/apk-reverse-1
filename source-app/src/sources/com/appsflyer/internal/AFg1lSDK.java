package com.appsflyer.internal;

import kotlin.jvm.internal.Intrinsics;
import kotlin.text.StringsKt;

public final class AFg1lSDK extends AFg1mSDK {
    private final AFd1nSDK values;

    public AFg1lSDK(AFd1nSDK aFd1nSDK) {
        Intrinsics.checkNotNullParameter(aFd1nSDK, "");
        this.values = aFd1nSDK;
    }

    @Override
    public final void mo760e(AFg1hSDK aFg1hSDK, String str, Throwable th, boolean z, boolean z2, boolean z3, boolean z4) {
        Intrinsics.checkNotNullParameter(aFg1hSDK, "");
        Intrinsics.checkNotNullParameter(str, "");
        Intrinsics.checkNotNullParameter(th, "");
        if (z3) {
            if (StringsKt.isBlank(str)) {
                str = "missing label";
            }
            this.values.init().values(th, withTag$SDK_prodRelease(str, aFg1hSDK));
        }
    }
}
