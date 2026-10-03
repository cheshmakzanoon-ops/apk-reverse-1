package com.appsflyer.internal;

import com.appsflyer.PurchaseHandler;
import java.util.Map;

public final class AFf1xSDK extends AFf1wSDK {
    public AFf1xSDK(Map<String, Object> map, PurchaseHandler.PurchaseValidationCallback purchaseValidationCallback, AFd1nSDK aFd1nSDK) {
        super(AFe1bSDK.ARS_VALIDATE, new AFe1bSDK[]{AFe1bSDK.RC_CDN}, aFd1nSDK, map, purchaseValidationCallback);
        this.AFInAppEventParameterName.add(AFe1bSDK.CONVERSION);
    }

    @Override
    protected final AFe1xSDK<String> valueOf(String str) throws Throwable {
        AFe1xSDK<String> aFe1xSDKAFInAppEventParameterName = ((AFf1tSDK) this).f367e.AFInAppEventParameterName(afInfoLog(), str, m796w());
        if (aFe1xSDKAFInAppEventParameterName != null) {
            AFKeystoreWrapper(aFe1xSDKAFInAppEventParameterName.valueOf.values);
        }
        return aFe1xSDKAFInAppEventParameterName;
    }

    @Override
    public final boolean values() {
        if (this.AFLogger == null || this.AFLogger.getStatusCode() != 424) {
            return super.values();
        }
        return true;
    }
}
