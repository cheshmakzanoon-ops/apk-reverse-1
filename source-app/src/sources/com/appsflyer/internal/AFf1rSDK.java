package com.appsflyer.internal;

import com.appsflyer.PurchaseHandler;
import java.util.Map;

public final class AFf1rSDK extends AFf1wSDK {
    public AFf1rSDK(Map<String, Object> map, PurchaseHandler.PurchaseValidationCallback purchaseValidationCallback, AFd1nSDK aFd1nSDK) {
        super(AFe1bSDK.PURCHASE_VALIDATE, new AFe1bSDK[]{AFe1bSDK.RC_CDN}, aFd1nSDK, map, purchaseValidationCallback);
        this.AFInAppEventParameterName.add(AFe1bSDK.CONVERSION);
    }

    @Override
    protected final AFe1xSDK<String> valueOf(String str) throws Throwable {
        AFe1xSDK<String> aFe1xSDKValues = ((AFf1tSDK) this).f367e.values(afInfoLog(), str, m796w());
        if (aFe1xSDKValues != null) {
            AFKeystoreWrapper(aFe1xSDKValues.valueOf.values);
        }
        return aFe1xSDKValues;
    }
}
