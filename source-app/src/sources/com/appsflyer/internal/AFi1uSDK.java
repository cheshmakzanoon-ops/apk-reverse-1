package com.appsflyer.internal;

import android.app.Activity;
import android.net.Uri;
import kotlin.jvm.internal.Intrinsics;
import kotlin.text.StringsKt;

public final class AFi1uSDK implements AFh1aSDK {
    private String AFInAppEventParameterName;

    @Override
    public final void values(Activity activity) {
        Intrinsics.checkNotNullParameter(activity, "");
        String str = this.AFInAppEventParameterName;
        if (str == null || str.length() == 0) {
            this.AFInAppEventParameterName = AFKeystoreWrapper(activity);
        }
    }

    @Override
    public final String valueOf(Activity activity) {
        String str = this.AFInAppEventParameterName;
        this.AFInAppEventParameterName = null;
        String str2 = str;
        return (str2 == null || str2.length() == 0) ? AFKeystoreWrapper(activity) : str;
    }

    private static String AFKeystoreWrapper(Activity activity) {
        Uri uriAFInAppEventParameterName = AFc1cSDK.AFInAppEventParameterName(activity != null ? activity.getIntent() : null);
        String string = uriAFInAppEventParameterName != null ? uriAFInAppEventParameterName.toString() : null;
        if (string == null) {
            string = "";
        }
        if (AFKeystoreWrapper(string)) {
            return null;
        }
        return string;
    }

    private static boolean AFKeystoreWrapper(String str) {
        return StringsKt.startsWith$default(str, "android-app://", false, 2, (Object) null);
    }

    @Override
    public final String AFInAppEventParameterName(Activity activity) {
        Uri referrer = (activity == null || activity.getIntent() == null) ? null : activity.getReferrer();
        String string = referrer != null ? referrer.toString() : null;
        return string == null ? "" : string;
    }
}
