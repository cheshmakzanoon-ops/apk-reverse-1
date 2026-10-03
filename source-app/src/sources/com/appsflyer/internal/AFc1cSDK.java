package com.appsflyer.internal;

import android.content.Intent;
import android.net.Uri;
import android.os.Parcelable;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.Intrinsics;

public final class AFc1cSDK {
    public static Uri AFInAppEventParameterName(Intent intent) {
        if (intent == null) {
            return null;
        }
        AFi1jSDK aFi1jSDK = new AFi1jSDK(intent);
        Intrinsics.checkNotNullParameter("android.intent.extra.REFERRER", "");
        Uri uri = (Uri) ((Parcelable) aFi1jSDK.AFInAppEventParameterName(new Function0<T>() {
            private String $AFKeystoreWrapper;

            public C08725() {
                super(0);
                str = str;
            }

            public final Parcelable invoke() {
                return AFi1jSDK.this.AFKeystoreWrapper.getParcelableExtra(str);
            }
        }, "Error while trying to read android.intent.extra.REFERRER extra from intent", null, true));
        if (uri != null) {
            return uri;
        }
        String strAFKeystoreWrapper = aFi1jSDK.AFKeystoreWrapper("android.intent.extra.REFERRER_NAME");
        if (strAFKeystoreWrapper != null) {
            return Uri.parse(strAFKeystoreWrapper);
        }
        return null;
    }
}
