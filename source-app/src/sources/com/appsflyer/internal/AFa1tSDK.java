package com.appsflyer.internal;

import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import com.appsflyer.AFLogger;
import com.caverock.androidsvg.SVGParser;

public final class AFa1tSDK implements AFd1vSDK {
    private static IntentFilter valueOf = new IntentFilter("android.intent.action.BATTERY_CHANGED");

    @Override
    public final AFd1vSDK.AFa1ySDK AFInAppEventParameterName(Context context) {
        String str = null;
        float f = 0.0f;
        try {
            Intent intentRegisterReceiver = context.registerReceiver(null, valueOf);
            if (intentRegisterReceiver != null) {
                if (2 == intentRegisterReceiver.getIntExtra("status", -1)) {
                    int intExtra = intentRegisterReceiver.getIntExtra("plugged", -1);
                    if (intExtra == 1) {
                        str = "ac";
                    } else if (intExtra == 2) {
                        str = "usb";
                    } else if (intExtra == 4) {
                        str = "wireless";
                    } else {
                        str = "other";
                    }
                } else {
                    str = SVGParser.XML_STYLESHEET_ATTR_ALTERNATE_NO;
                }
                int intExtra2 = intentRegisterReceiver.getIntExtra("level", -1);
                int intExtra3 = intentRegisterReceiver.getIntExtra("scale", -1);
                if (-1 != intExtra2 && -1 != intExtra3) {
                    f = (intExtra2 * 100.0f) / intExtra3;
                }
            }
        } catch (Throwable th) {
            AFLogger.afErrorLogForExcManagerOnly("Device that failed to register receiver", th);
        }
        return new AFd1vSDK.AFa1ySDK(f, str);
    }
}
