package com.appsflyer.internal;

public final class AFh1sSDK extends AFa1pSDK {
    @Override
    public final boolean registerClient() {
        return true;
    }

    @Override
    public final AFe1bSDK AFInAppEventParameterName() {
        if (this.registerClient == 1) {
            return AFe1bSDK.CONVERSION;
        }
        return AFe1bSDK.LAUNCH;
    }
}
