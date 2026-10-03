package com.appsflyer.internal;

import android.content.Context;
import com.appsflyer.lvl.AppsFlyerLVL;

public final class AFf1bSDK {

    interface AFa1uSDK {
        void AFInAppEventParameterName(String str, Exception exc);

        void AFKeystoreWrapper(String str, String str2);
    }

    public final boolean AFKeystoreWrapper(long j, Context context, final AFa1uSDK aFa1uSDK) {
        try {
            AppsFlyerLVL.checkLicense(j, context, new AppsFlyerLVL.resultListener() {
                public final void onLvlResult(String str, String str2) {
                    if (str != null && str2 != null) {
                        aFa1uSDK.AFKeystoreWrapper(str, str2);
                    } else if (str2 == null) {
                        aFa1uSDK.AFInAppEventParameterName("onLvlResult with error", new Exception("AFLVL Invalid signature"));
                    } else {
                        aFa1uSDK.AFInAppEventParameterName("onLvlResult with error", new Exception("AFLVL Invalid signedData"));
                    }
                }

                public final void onLvlFailure(Exception exc) {
                    aFa1uSDK.AFInAppEventParameterName("onLvlFailure with exception", exc);
                }
            });
            return true;
        } catch (Throwable unused) {
            return false;
        }
    }
}
