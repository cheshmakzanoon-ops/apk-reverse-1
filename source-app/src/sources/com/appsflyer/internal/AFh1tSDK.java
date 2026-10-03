package com.appsflyer.internal;

public final class AFh1tSDK extends AFa1pSDK {
    public final AFe1bSDK force;

    @Deprecated
    public AFh1tSDK() {
        this.force = null;
    }

    public AFh1tSDK(String str, byte[] bArr, String str2, AFe1bSDK aFe1bSDK) {
        super(null, str, Boolean.FALSE);
        this.values = str2;
        values(bArr);
        this.force = aFe1bSDK;
    }

    @Override
    public final AFe1bSDK AFInAppEventParameterName() {
        AFe1bSDK aFe1bSDK = this.force;
        return aFe1bSDK != null ? aFe1bSDK : AFe1bSDK.CACHED_EVENT;
    }
}
