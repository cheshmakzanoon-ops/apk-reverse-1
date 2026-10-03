package com.appsflyer.internal;

import android.content.Context;
import android.content.Intent;
import com.appsflyer.AFLogger;
import com.appsflyer.AppsFlyerLib;
import com.appsflyer.AppsFlyerProperties;
import com.appsflyer.FirebaseMessagingServiceListener;
import com.appsflyer.internal.AFe1dSDK.RunnableC08534;

public final class AFg1tSDK {
    public static String valueOf;
    public final AFd1xSDK AFKeystoreWrapper;

    static {
        StringBuilder sb = new StringBuilder("https://%sregister.%s/api/v");
        sb.append(AFb1vSDK.AFKeystoreWrapper);
        valueOf = sb.toString();
    }

    public AFg1tSDK(Context context) {
        this.AFKeystoreWrapper = AFb1vSDK.valueOf().valueOf(context);
    }

    public static boolean valueOf(Context context) {
        if (AppsFlyerLib.getInstance().isStopped()) {
            return false;
        }
        try {
            Class.forName("com.google.firebase.messaging.FirebaseMessagingService");
            return AFb1qSDK.AFInAppEventParameterName(context, new Intent("com.google.firebase.MESSAGING_EVENT", null, context, FirebaseMessagingServiceListener.class));
        } catch (ClassNotFoundException unused) {
        } catch (Throwable th) {
            AFLogger.INSTANCE.m798e(AFg1hSDK.UNINSTALL, "An error occurred while trying to verify manifest declarations: ", th);
        }
    }

    public static boolean values(AFd1xSDK aFd1xSDK) {
        return aFd1xSDK.valueOf("sentRegisterRequestToAF");
    }

    public static void valueOf(String str) {
        AFd1nSDK aFd1nSDKAFInAppEventType = AFb1vSDK.valueOf().AFInAppEventType();
        AFf1jSDK aFf1jSDK = new AFf1jSDK(str, aFd1nSDKAFInAppEventType);
        AFe1dSDK aFe1dSDKMo787w = aFd1nSDKAFInAppEventType.mo787w();
        aFe1dSDKMo787w.values.execute(aFe1dSDKMo787w.new RunnableC08534(aFf1jSDK));
    }

    public final AFg1uSDK AFInAppEventType() {
        String string;
        String string2;
        String strValueOf = this.AFKeystoreWrapper.valueOf("afUninstallToken", (String) null);
        long jAFInAppEventType = this.AFKeystoreWrapper.AFInAppEventType("afUninstallToken_received_time", 0L);
        boolean zValueOf = this.AFKeystoreWrapper.valueOf("afUninstallToken_queued");
        this.AFKeystoreWrapper.AFInAppEventParameterName("afUninstallToken_queued", false);
        if (strValueOf == null && (string2 = AppsFlyerProperties.getInstance().getString("afUninstallToken")) != null) {
            String[] strArrSplit = string2.split(",");
            strValueOf = strArrSplit[strArrSplit.length - 1];
        }
        if (jAFInAppEventType == 0 && (string = AppsFlyerProperties.getInstance().getString("afUninstallToken")) != null) {
            String[] strArrSplit2 = string.split(",");
            if (strArrSplit2.length >= 2) {
                try {
                    jAFInAppEventType = Long.parseLong(strArrSplit2[strArrSplit2.length - 2]);
                } catch (NumberFormatException unused) {
                }
            }
        }
        if (strValueOf != null) {
            return new AFg1uSDK(strValueOf, jAFInAppEventType, zValueOf);
        }
        return null;
    }
}
