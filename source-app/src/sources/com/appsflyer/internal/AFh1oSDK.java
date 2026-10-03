package com.appsflyer.internal;

import com.appsflyer.AFInAppEventType;

public final class AFh1oSDK extends AFh1qSDK {
    public AFh1oSDK() {
        super(AFInAppEventType.PURCHASE, Boolean.TRUE);
    }

    @Override
    public final AFa1pSDK AFKeystoreWrapper(String str) {
        return super.AFKeystoreWrapper(valueOf(str));
    }

    @Override
    public final AFe1bSDK AFInAppEventParameterName() {
        return AFe1bSDK.PURCHASE_VALIDATE;
    }
}
