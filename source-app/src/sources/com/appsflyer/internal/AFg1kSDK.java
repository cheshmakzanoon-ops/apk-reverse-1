package com.appsflyer.internal;

import com.appsflyer.AFLogger;
import java.util.Map;
import org.json.JSONException;

public final class AFg1kSDK extends AFe1fSDK<Void> {

    private final AFd1xSDK f386d;
    private final AFe1pSDK<String> registerClient;
    private final Throwable unregisterClient;

    @Override
    public final long AFKeystoreWrapper() {
        return 1000L;
    }

    @Override
    public final boolean values() {
        return false;
    }

    public AFg1kSDK(AFf1kSDK aFf1kSDK, AFd1xSDK aFd1xSDK) {
        super(AFe1bSDK.GCDSDK, new AFe1bSDK[]{AFe1bSDK.RC_CDN}, "GCD-CHECK");
        this.unregisterClient = aFf1kSDK.m790d();
        this.registerClient = aFf1kSDK.AFLogger;
        this.f386d = aFd1xSDK;
    }

    @Override
    public final AFe1cSDK AFInAppEventType() throws Exception {
        AFLogger.afDebugLog("[GCD-A01] Loading conversion data. Counter: ".concat(String.valueOf(this.f386d.valueOf("appsFlyerCount", 0))));
        long jAFInAppEventType = this.f386d.AFInAppEventType("appsflyerConversionDataCacheExpiration", 0L);
        if (jAFInAppEventType != 0 && System.currentTimeMillis() - jAFInAppEventType > 5184000000L) {
            AFLogger.afDebugLog("[GCD-E02] Cached conversion data expired");
            this.f386d.AFInAppEventParameterName("sixtyDayConversionData", true);
            this.f386d.values("attributionId", null);
            this.f386d.AFInAppEventParameterName("appsflyerConversionDataCacheExpiration", 0L);
        }
        Map<String, Object> mapRegisterClient = registerClient();
        if (mapRegisterClient != null) {
            try {
                if (!mapRegisterClient.containsKey("is_first_launch")) {
                    mapRegisterClient.put("is_first_launch", Boolean.FALSE);
                }
                AFg1rSDK.AFInAppEventType(mapRegisterClient);
            } catch (Exception e) {
                StringBuilder sb = new StringBuilder("[GCD] Error executing conversion data callback: ");
                sb.append(e.getLocalizedMessage());
                AFLogger.afErrorLog(sb.toString(), e);
            }
            return AFe1cSDK.SUCCESS;
        }
        try {
            if (this.unregisterClient != null) {
                StringBuilder sb2 = new StringBuilder("Launch exception: ");
                sb2.append(this.unregisterClient.getMessage());
                AFg1rSDK.AFKeystoreWrapper(sb2.toString());
                return AFe1cSDK.SUCCESS;
            }
            AFe1pSDK<String> aFe1pSDK = this.registerClient;
            if (aFe1pSDK != null && !aFe1pSDK.isSuccessful()) {
                StringBuilder sb3 = new StringBuilder("Launch status code: ");
                sb3.append(this.registerClient.getStatusCode());
                AFg1rSDK.AFKeystoreWrapper(sb3.toString());
                return AFe1cSDK.SUCCESS;
            }
            return AFe1cSDK.FAILURE;
        } catch (Exception e2) {
            StringBuilder sb4 = new StringBuilder("[GCD] Error executing conversion data callback: ");
            sb4.append(e2.getLocalizedMessage());
            AFLogger.afErrorLog(sb4.toString(), e2);
        }
    }

    private Map<String, Object> registerClient() {
        String strValueOf = this.f386d.valueOf("attributionId", (String) null);
        if (strValueOf == null) {
            return null;
        }
        try {
            new AFe1rSDK();
            return AFe1rSDK.values(strValueOf);
        } catch (JSONException e) {
            StringBuilder sb = new StringBuilder("[GCD] Failed to parse GCD response: ");
            sb.append(e.getMessage());
            AFLogger.afErrorLog(sb.toString(), e);
            return null;
        }
    }
}
