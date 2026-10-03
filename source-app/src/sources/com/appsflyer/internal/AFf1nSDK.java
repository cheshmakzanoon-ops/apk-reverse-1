package com.appsflyer.internal;

import com.appsflyer.deeplink.DeepLinkResult;

public final class AFf1nSDK extends AFe1fSDK<DeepLinkResult> {
    private final AFc1qSDK registerClient;
    private DeepLinkResult unregisterClient;

    @Override
    public final long AFKeystoreWrapper() {
        return 90000L;
    }

    @Override
    public final boolean values() {
        return false;
    }

    public AFf1nSDK(AFc1qSDK aFc1qSDK) {
        super(AFe1bSDK.DLSDK, new AFe1bSDK[]{AFe1bSDK.RC_CDN}, "DdlSdk");
        this.registerClient = aFc1qSDK;
    }

    static class C08614 {
        static final int[] valueOf;

        static {
            int[] iArr = new int[DeepLinkResult.Status.values().length];
            valueOf = iArr;
            try {
                iArr[DeepLinkResult.Status.FOUND.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                valueOf[DeepLinkResult.Status.NOT_FOUND.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                valueOf[DeepLinkResult.Status.ERROR.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
        }
    }

    @Override
    public final AFe1cSDK AFInAppEventType() throws Exception {
        this.unregisterClient = this.registerClient.unregisterClient();
        if (C08614.valueOf[this.unregisterClient.getStatus().ordinal()] == 1) {
            return AFe1cSDK.SUCCESS;
        }
        if (this.unregisterClient.getError() == DeepLinkResult.Error.TIMEOUT) {
            return AFe1cSDK.TIMEOUT;
        }
        return AFe1cSDK.FAILURE;
    }
}
