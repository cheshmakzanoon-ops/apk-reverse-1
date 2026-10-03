package com.appsflyer.internal;

import android.util.Base64;
import com.appsflyer.AFLogger;
import com.appsflyer.attribution.AppsFlyerRequestListener;
import java.net.MalformedURLException;
import java.net.URL;

public final class AFf1qSDK extends AFf1tSDK<String> {
    private final AFh1tSDK registerClient;

    @Override
    protected final boolean unregisterClient() {
        return false;
    }

    @Override
    protected final AFe1xSDK<String> valueOf(String str) {
        String strEncodeToString = Base64.encodeToString(this.registerClient.values(), 2);
        AFLogger.afInfoLog("cached data: ".concat(String.valueOf(strEncodeToString)));
        ((AFf1tSDK) this).f366d.AFKeystoreWrapper(this.registerClient.unregisterClient, strEncodeToString);
        return ((AFf1tSDK) this).f367e.AFKeystoreWrapper(this.registerClient);
    }

    @Override
    public final boolean values() {
        AFe1bSDK aFe1bSDK;
        AFh1tSDK aFh1tSDK = this.registerClient;
        if (aFh1tSDK.force != null) {
            aFe1bSDK = aFh1tSDK.force;
        } else {
            aFe1bSDK = AFe1bSDK.CACHED_EVENT;
        }
        return (aFe1bSDK == AFe1bSDK.ARS_VALIDATE && this.AFLogger != null && this.AFLogger.getStatusCode() == 424) || super.values();
    }

    @Override
    protected final AppsFlyerRequestListener registerClient() {
        return this.registerClient.valueOf;
    }

    public AFf1qSDK(AFh1tSDK aFh1tSDK, AFd1nSDK aFd1nSDK) {
        AFe1bSDK aFe1bSDK;
        if (aFh1tSDK.force != null) {
            aFe1bSDK = aFh1tSDK.force;
        } else {
            aFe1bSDK = AFe1bSDK.CACHED_EVENT;
        }
        AFe1bSDK aFe1bSDK2 = aFe1bSDK;
        AFe1bSDK[] aFe1bSDKArr = {AFe1bSDK.RC_CDN};
        StringBuilder sb = new StringBuilder();
        sb.append(aFh1tSDK.values);
        sb.append("-");
        sb.append(AFInAppEventType(aFh1tSDK));
        super(aFe1bSDK2, aFe1bSDKArr, aFd1nSDK, sb.toString(), aFh1tSDK.values);
        this.registerClient = aFh1tSDK;
    }

    private static String AFInAppEventType(AFh1tSDK aFh1tSDK) {
        try {
            return new URL(aFh1tSDK.unregisterClient).getHost();
        } catch (MalformedURLException unused) {
            return "";
        }
    }
}
