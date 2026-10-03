package com.appsflyer.internal;

import androidx.exifinterface.media.ExifInterface;
import kotlin.jvm.internal.Intrinsics;

public final class AFg1dSDK extends AFg1mSDK {
    private final boolean valueOf;
    private final AFd1nSDK values;

    public AFg1dSDK(AFd1nSDK aFd1nSDK) {
        Intrinsics.checkNotNullParameter(aFd1nSDK, "");
        this.values = aFd1nSDK;
        this.valueOf = true;
    }

    @Override
    public final boolean getShouldExtendMsg() {
        return this.valueOf;
    }

    @Override
    public final void mo759d(AFg1hSDK aFg1hSDK, String str, boolean z) {
        Intrinsics.checkNotNullParameter(aFg1hSDK, "");
        Intrinsics.checkNotNullParameter(str, "");
        if (z) {
            this.values.afInfoLog().valueOf("D", AFInAppEventType(str, aFg1hSDK));
        }
    }

    @Override
    public final void mo760e(AFg1hSDK aFg1hSDK, String str, Throwable th, boolean z, boolean z2, boolean z3, boolean z4) {
        Intrinsics.checkNotNullParameter(aFg1hSDK, "");
        Intrinsics.checkNotNullParameter(str, "");
        Intrinsics.checkNotNullParameter(th, "");
        if (z4) {
            this.values.afInfoLog().valueOf(ExifInterface.LONGITUDE_EAST, AFInAppEventType(str, aFg1hSDK));
        }
        if (z4) {
            this.values.afInfoLog().AFInAppEventParameterName(th);
        }
    }

    @Override
    public final void mo761i(AFg1hSDK aFg1hSDK, String str, boolean z) {
        Intrinsics.checkNotNullParameter(aFg1hSDK, "");
        Intrinsics.checkNotNullParameter(str, "");
        if (z) {
            this.values.afInfoLog().valueOf("I", AFInAppEventType(str, aFg1hSDK));
        }
    }

    @Override
    public final void mo763w(AFg1hSDK aFg1hSDK, String str, boolean z) {
        Intrinsics.checkNotNullParameter(aFg1hSDK, "");
        Intrinsics.checkNotNullParameter(str, "");
        if (z) {
            this.values.afInfoLog().valueOf(ExifInterface.LONGITUDE_WEST, AFInAppEventType(str, aFg1hSDK));
        }
    }

    @Override
    public final void mo762v(AFg1hSDK aFg1hSDK, String str, boolean z) {
        Intrinsics.checkNotNullParameter(aFg1hSDK, "");
        Intrinsics.checkNotNullParameter(str, "");
        if (z) {
            this.values.afInfoLog().valueOf(ExifInterface.GPS_MEASUREMENT_INTERRUPTED, AFInAppEventType(str, aFg1hSDK));
        }
    }

    @Override
    public final void force(AFg1hSDK aFg1hSDK, String str) {
        Intrinsics.checkNotNullParameter(aFg1hSDK, "");
        Intrinsics.checkNotNullParameter(str, "");
        this.values.afInfoLog().valueOf("F", AFInAppEventType(str, aFg1hSDK));
    }
}
