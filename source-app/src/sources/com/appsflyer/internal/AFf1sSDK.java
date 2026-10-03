package com.appsflyer.internal;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import com.appsflyer.AFLogger;
import com.appsflyer.attribution.AppsFlyerRequestListener;

public final class AFf1sSDK extends AFf1tSDK<String> {
    private final String registerClient;

    private final AFj1ySDK f365w;

    @Override
    protected final AppsFlyerRequestListener registerClient() {
        return null;
    }

    @Override
    protected final boolean unregisterClient() {
        return false;
    }

    @Override
    public final boolean values() {
        return false;
    }

    public AFf1sSDK(AFd1nSDK aFd1nSDK, String str, AFj1ySDK aFj1ySDK) {
        super(AFe1bSDK.IMPRESSIONS, new AFe1bSDK[]{AFe1bSDK.RC_CDN}, aFd1nSDK, str);
        this.registerClient = str;
        this.f365w = aFj1ySDK;
    }

    @Override
    protected final AFe1xSDK<String> valueOf(String str) {
        return ((AFf1tSDK) this).f367e.AFInAppEventParameterName(this.registerClient);
    }

    @Override
    public final void valueOf() {
        super.valueOf();
        AFe1pSDK<Result> aFe1pSDK = this.AFLogger;
        if (aFe1pSDK != 0) {
            int statusCode = aFe1pSDK.getStatusCode();
            if (statusCode == 200) {
                StringBuilder sb = new StringBuilder("Cross promotion impressions success: ");
                sb.append(this.registerClient);
                AFLogger.afInfoLog(sb.toString(), false);
                return;
            }
            if (statusCode == 301 || statusCode == 302) {
                StringBuilder sb2 = new StringBuilder("Cross promotion redirection success: ");
                sb2.append(this.registerClient);
                AFLogger.afInfoLog(sb2.toString(), false);
                String strAFInAppEventType = aFe1pSDK.AFInAppEventType("Location");
                AFj1ySDK aFj1ySDK = this.f365w;
                if (aFj1ySDK == null || strAFInAppEventType == null) {
                    return;
                }
                aFj1ySDK.AFKeystoreWrapper = strAFInAppEventType;
                AFj1ySDK aFj1ySDK2 = this.f365w;
                Context context = aFj1ySDK2.valueOf.get();
                if (context != null) {
                    try {
                        if (aFj1ySDK2.AFKeystoreWrapper != null) {
                            context.startActivity(new Intent("android.intent.action.VIEW", Uri.parse(aFj1ySDK2.AFKeystoreWrapper)).setFlags(268435456));
                            return;
                        }
                        return;
                    } catch (Exception e) {
                        AFLogger.afErrorLog("Failed to open cross promotion url, does OS have browser installed?".concat(String.valueOf(e)), e);
                        return;
                    }
                }
                return;
            }
            StringBuilder sb3 = new StringBuilder("call to ");
            sb3.append(this.registerClient);
            sb3.append(" failed: ");
            sb3.append(statusCode);
            AFLogger.afInfoLog(sb3.toString());
        }
    }
}
