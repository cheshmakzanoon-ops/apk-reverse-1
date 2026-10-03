package com.appsflyer;

import com.appsflyer.internal.AFb1mSDK;
import com.appsflyer.internal.AFd1nSDK;
import com.appsflyer.internal.AFd1rSDK;
import com.appsflyer.internal.AFe1dSDK;
import com.appsflyer.internal.components.network.http.ResponseNetwork;
import java.util.Map;

public final class PurchaseHandler {
    private final AFd1rSDK AFInAppEventParameterName;
    public final AFe1dSDK AFKeystoreWrapper;
    public final AFd1nSDK valueOf;

    public interface PurchaseValidationCallback {
        void onFailure(Throwable th);

        void onResponse(ResponseNetwork<String> responseNetwork);
    }

    public PurchaseHandler(AFd1nSDK aFd1nSDK) {
        this.valueOf = aFd1nSDK;
        this.AFInAppEventParameterName = aFd1nSDK.AFInAppEventType();
        this.AFKeystoreWrapper = aFd1nSDK.mo787w();
    }

    public final boolean valueOf(Map<String, Object> map, PurchaseValidationCallback purchaseValidationCallback, String... strArr) {
        boolean zAFInAppEventType = AFb1mSDK.AFInAppEventType(map, strArr, this.AFInAppEventParameterName);
        if (!zAFInAppEventType && purchaseValidationCallback != null) {
            purchaseValidationCallback.onFailure(new IllegalArgumentException("Invalid Request Data"));
        }
        return zAFInAppEventType;
    }
}
