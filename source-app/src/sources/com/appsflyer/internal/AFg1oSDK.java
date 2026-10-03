package com.appsflyer.internal;

import com.appsflyer.AFInAppEventParameterName;
import com.appsflyer.AFLogger;
import com.appsflyer.attribution.AppsFlyerRequestListener;
import com.appsflyer.internal.components.network.http.ResponseNetwork;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import org.json.JSONObject;

public final class AFg1oSDK extends AFf1tSDK<Map<String, Object>> {
    private static final List<String> registerClient = Arrays.asList("googleplay", "playstore", "googleplaystore");
    private final AFe1zSDK afInfoLog;
    private String afWarnLog;
    private final AFd1rSDK force;

    private final AFd1xSDK f392i;

    private final AFg1bSDK f393v;

    private Map<String, Object> f394w;

    @Override
    public final AppsFlyerRequestListener registerClient() {
        return null;
    }

    @Override
    public final boolean unregisterClient() {
        return false;
    }

    @Override
    public final boolean values() {
        return false;
    }

    public AFg1oSDK(AFd1nSDK aFd1nSDK) {
        super(AFe1bSDK.GCDSDK, new AFe1bSDK[]{AFe1bSDK.RC_CDN}, aFd1nSDK, "GCD-FETCH");
        this.afInfoLog = aFd1nSDK.AFInAppEventParameterName();
        this.f392i = aFd1nSDK.AFKeystoreWrapper();
        this.f393v = aFd1nSDK.unregisterClient();
        this.force = aFd1nSDK.AFInAppEventType();
        this.AFInAppEventParameterName.add(AFe1bSDK.CONVERSION);
        this.AFInAppEventParameterName.add(AFe1bSDK.LAUNCH);
    }

    @Override
    public final void valueOf() {
        super.valueOf();
        Map<String, Object> map = this.f394w;
        String str = this.afWarnLog;
        if (map != null) {
            AFg1rSDK.AFInAppEventType(map);
        } else if (str != null && !str.isEmpty()) {
            AFg1rSDK.AFKeystoreWrapper(str);
        } else {
            AFg1rSDK.AFKeystoreWrapper("Unknown error");
        }
    }

    @Override
    public final AFe1xSDK<Map<String, Object>> valueOf(String str) {
        String strConcat;
        String strAFInAppEventType = AFb1vSDK.AFInAppEventType(this.f392i, this.force.values());
        if (strAFInAppEventType != null && !strAFInAppEventType.trim().isEmpty()) {
            if (!registerClient.contains(strAFInAppEventType.toLowerCase(Locale.getDefault()))) {
                strConcat = "-".concat(String.valueOf(strAFInAppEventType));
            } else {
                AFLogger.afWarnLog(String.format("[GCD] AF detected using redundant Google-Play channel for attribution - %s. Using without channel postfix.", strAFInAppEventType));
                strConcat = "";
            }
        } else {
            strConcat = "";
        }
        AFe1xSDK<Map<String, Object>> aFe1xSDKAFInAppEventType = this.afInfoLog.AFInAppEventType(strConcat, str);
        StringBuilder sb = new StringBuilder("[GCD-B01] URL: ");
        sb.append(aFe1xSDKAFInAppEventType.valueOf.values);
        AFb1bSDK.valueOf(sb.toString());
        return aFe1xSDKAFInAppEventType;
    }

    @Override
    public final AFe1cSDK AFInAppEventType() throws Exception {
        AFe1cSDK aFe1cSDKAFInAppEventType;
        AFe1cSDK aFe1cSDK;
        if (((AFf1tSDK) this).unregisterClient.valueOf()) {
            AFLogger.afDebugLog("[GCD-E03] 'isStopTracking' enabled");
            this.afWarnLog = "'isStopTracking' enabled";
            throw new AFf1zSDK();
        }
        AFe1cSDK aFe1cSDK2 = AFe1cSDK.FAILURE;
        int i = 0;
        while (i <= 2) {
            boolean z = i >= 2;
            this.f393v.f380v = System.currentTimeMillis();
            try {
                try {
                    aFe1cSDKAFInAppEventType = super.AFInAppEventType();
                    ResponseNetwork responseNetwork = this.AFLogger;
                    if (responseNetwork != null) {
                        int statusCode = responseNetwork.getStatusCode();
                        boolean z2 = statusCode == 403 || statusCode >= 500;
                        if (!responseNetwork.isSuccessful() && statusCode != 404) {
                            if (!z) {
                                if (!z2) {
                                }
                            }
                            this.afWarnLog = "Error connection to server: ".concat(String.valueOf(statusCode));
                            aFe1cSDK = AFe1cSDK.FAILURE;
                        } else {
                            Map<String, Object> map = (Map) responseNetwork.getBody();
                            int statusCode2 = responseNetwork.getStatusCode();
                            Boolean bool = (Boolean) map.get("iscache");
                            if (statusCode2 == 404) {
                                map.remove("error_reason");
                                map.remove("status_code");
                                map.put("af_status", "Organic");
                                map.put("af_message", "organic install");
                            }
                            if (bool != null && !bool.booleanValue()) {
                                this.f392i.AFInAppEventParameterName("appsflyerConversionDataCacheExpiration", System.currentTimeMillis());
                            }
                            if (map.containsKey("af_siteid")) {
                                if (map.containsKey(AFInAppEventParameterName.AF_CHANNEL)) {
                                    StringBuilder sb = new StringBuilder("[Invite] Detected App-Invite via channel: ");
                                    sb.append(map.get(AFInAppEventParameterName.AF_CHANNEL));
                                    AFLogger.afDebugLog(sb.toString());
                                } else {
                                    AFLogger.afDebugLog(String.format("[CrossPromotion] App was installed via %s's Cross Promotion", map.get("af_siteid")));
                                }
                            }
                            map.put("is_first_launch", Boolean.FALSE);
                            this.f392i.values("attributionId", new JSONObject(map).toString());
                            if (!this.f392i.valueOf("sixtyDayConversionData")) {
                                map.put("is_first_launch", Boolean.TRUE);
                            }
                            this.f394w = map;
                            aFe1cSDK = AFe1cSDK.SUCCESS;
                        }
                        this.f393v.values(i);
                        AFLogger.afDebugLog("[GCD-A03] Server retrieving attempt finished");
                        return aFe1cSDK;
                    }
                } catch (AFf1ySDK e) {
                    AFLogger.afDebugLog("[GCD-E05] AppsFlyer dev key is missing");
                    this.afWarnLog = "AppsFlyer dev key is missing";
                    throw e;
                } catch (Exception e2) {
                    StringBuilder sb2 = new StringBuilder("[GCD] Error: ");
                    sb2.append(e2.getMessage());
                    AFLogger.afErrorLog(sb2.toString(), e2, false, false);
                    aFe1cSDKAFInAppEventType = AFe1cSDK.FAILURE;
                    if (z) {
                        this.afWarnLog = e2.getMessage();
                        throw e2;
                    }
                }
                this.f393v.values(i);
                AFLogger.afDebugLog("[GCD-A03] Server retrieving attempt finished");
                aFe1cSDK2 = aFe1cSDKAFInAppEventType;
                i++;
            } catch (Throwable th) {
                this.f393v.values(i);
                AFLogger.afDebugLog("[GCD-A03] Server retrieving attempt finished");
                throw th;
            }
        }
        return aFe1cSDK2;
    }
}
