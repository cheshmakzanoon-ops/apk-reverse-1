package com.appsflyer.internal;

import android.app.Activity;
import android.content.Intent;
import kotlin.jvm.internal.Intrinsics;

public final class AFh1zSDK {
    public final String AFKeystoreWrapper;
    public final Intent valueOf;
    public final String values;

    public AFh1zSDK(Activity activity, AFh1aSDK aFh1aSDK) {
        Intrinsics.checkNotNullParameter(activity, "");
        Intrinsics.checkNotNullParameter(aFh1aSDK, "");
        this.valueOf = activity.getIntent();
        this.values = aFh1aSDK.AFInAppEventParameterName(activity);
        this.AFKeystoreWrapper = aFh1aSDK.valueOf(activity);
    }
}
