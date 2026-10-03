package com.appsflyer.internal;

import com.appsflyer.AFLogger;
import com.appsflyer.AppsFlyerProperties;
import com.facebook.share.internal.ShareConstants;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import org.json.JSONObject;

public final class AFf1kSDK extends AFf1pSDK {
    private final AFc1kSDK afDebugLog;
    private final AFi1kSDK afInfoLog;
    private final AppsFlyerProperties afRDLog;
    private final AFf1eSDK afVerboseLog;
    private final AFg1bSDK afWarnLog;
    public Map<String, Object> force;

    private final AFd1xSDK f355v;

    public AFf1kSDK(AFa1pSDK aFa1pSDK, AFd1nSDK aFd1nSDK) {
        super(aFa1pSDK, aFd1nSDK);
        this.afInfoLog = aFd1nSDK.force();
        this.f355v = aFd1nSDK.AFKeystoreWrapper();
        this.afWarnLog = aFd1nSDK.unregisterClient();
        this.afVerboseLog = aFd1nSDK.mo784e();
        this.afRDLog = AppsFlyerProperties.getInstance();
        this.afDebugLog = aFd1nSDK.AppsFlyer2dXConversionCallback();
        this.AFInAppEventParameterName.add(AFe1bSDK.RESOLVE_ESP);
        this.AFInAppEventParameterName.add(AFe1bSDK.DLSDK);
    }

    @Override
    public final void valueOf() {
        super.valueOf();
        AFg1bSDK aFg1bSDK = this.afWarnLog;
        int i = ((AFf1pSDK) this).registerClient.registerClient;
        long jCurrentTimeMillis = System.currentTimeMillis();
        if (i == 1) {
            if (aFg1bSDK.f377d != 0) {
                aFg1bSDK.AFInAppEventParameterName.put("net", Long.valueOf(jCurrentTimeMillis - aFg1bSDK.f377d));
                aFg1bSDK.AFKeystoreWrapper.values("first_launch", new JSONObject(aFg1bSDK.AFInAppEventParameterName).toString());
                return;
            }
            AFLogger.afInfoLog("Metrics: launch start ts is missing");
        }
    }

    @Override
    protected final void AFInAppEventType(AFa1pSDK aFa1pSDK) throws Throwable {
        super.AFInAppEventType(aFa1pSDK);
        int i = aFa1pSDK.registerClient;
        this.afWarnLog.AFInAppEventParameterName(i);
        Map map = (Map) aFa1pSDK.AFInAppEventType().get("meta");
        if (map == null) {
            map = new HashMap();
            aFa1pSDK.AFInAppEventType().put("meta", map);
        }
        if (!aFa1pSDK.AFInAppEventType().containsKey("af_deeplink")) {
            aFa1pSDK.AFInAppEventType(this.afDebugLog.valueOf());
        }
        AFh1iSDK aFh1iSDKAFInAppEventType = this.afVerboseLog.AFInAppEventType();
        if (aFh1iSDKAFInAppEventType != null) {
            HashMap map2 = new HashMap();
            map2.put("cdn_token", aFh1iSDKAFInAppEventType.values);
            if (aFh1iSDKAFInAppEventType.AFKeystoreWrapper != null) {
                map2.put("c_ver", aFh1iSDKAFInAppEventType.AFKeystoreWrapper);
            }
            if (aFh1iSDKAFInAppEventType.AFInAppEventParameterName > 0) {
                map2.put("latency", Long.valueOf(aFh1iSDKAFInAppEventType.AFInAppEventParameterName));
            }
            if (aFh1iSDKAFInAppEventType.AFInAppEventType > 0) {
                map2.put("delay", Long.valueOf(aFh1iSDKAFInAppEventType.AFInAppEventType));
            }
            if (aFh1iSDKAFInAppEventType.valueOf > 0) {
                map2.put("res_code", Integer.valueOf(aFh1iSDKAFInAppEventType.valueOf));
            }
            if (aFh1iSDKAFInAppEventType.registerClient != null) {
                StringBuilder sb = new StringBuilder();
                sb.append(aFh1iSDKAFInAppEventType.registerClient.getClass().getSimpleName());
                sb.append(": ");
                sb.append(aFh1iSDKAFInAppEventType.registerClient.getMessage());
                map2.put("error", sb.toString());
            }
            if (aFh1iSDKAFInAppEventType.f396e != null) {
                map2.put("sig", aFh1iSDKAFInAppEventType.f396e.toString());
            }
            if (aFh1iSDKAFInAppEventType.unregisterClient != null) {
                map2.put("cdn_cache_status", aFh1iSDKAFInAppEventType.unregisterClient);
            }
            map.put("rc", map2);
        }
        if (i == 1) {
            if (this.afRDLog.getBoolean(AppsFlyerProperties.AF_WAITFOR_CUSTOMERID, false)) {
                aFa1pSDK.AFInAppEventType().put("wait_cid", Boolean.toString(true));
            }
            HashMap map3 = new HashMap(this.afWarnLog.values);
            this.afWarnLog.AFKeystoreWrapper.AFKeystoreWrapper("ddl");
            if (!map3.isEmpty()) {
                map.put("ddl", map3);
            }
            HashMap map4 = new HashMap(this.afWarnLog.AFInAppEventParameterName);
            if (!map4.isEmpty()) {
                map.put("first_launch", map4);
            }
        } else if (i == 2) {
            HashMap map5 = new HashMap(this.afWarnLog.AFInAppEventParameterName);
            if (!map5.isEmpty()) {
                map.put("first_launch", map5);
            }
            this.afWarnLog.AFKeystoreWrapper.AFKeystoreWrapper("first_launch");
        }
        if (map.isEmpty()) {
            aFa1pSDK.AFInAppEventType().remove("meta");
        }
        if (i <= 2) {
            ArrayList arrayList = new ArrayList();
            for (AFi1nSDK aFi1nSDK : this.afInfoLog.AFInAppEventType()) {
                boolean z = aFi1nSDK instanceof AFi1pSDK;
                int i2 = C08605.valueOf[aFi1nSDK.unregisterClient.ordinal()];
                if (i2 == 1) {
                    if (z) {
                        aFa1pSDK.AFKeystoreWrapper("rfr", ((AFi1pSDK) aFi1nSDK).valueOf);
                        this.f355v.AFInAppEventParameterName(AppsFlyerProperties.NEW_REFERRER_SENT, true);
                    }
                    arrayList.add(aFi1nSDK.values);
                } else if (i2 == 2 && i == 2 && !z) {
                    HashMap map6 = new HashMap();
                    map6.put(ShareConstants.FEED_SOURCE_PARAM, aFi1nSDK.AFInAppEventParameterName);
                    map6.put("response", "TIMEOUT");
                    map6.put("type", aFi1nSDK.AFLogger);
                    arrayList.add(map6);
                }
            }
            if (!arrayList.isEmpty()) {
                aFa1pSDK.AFKeystoreWrapper("referrers", arrayList);
            }
            Object obj = this.force;
            if (obj != null) {
                aFa1pSDK.AFKeystoreWrapper("fb_ddl", obj);
            }
        }
        this.f362i.valueOf(aFa1pSDK);
    }

    static class C08605 {
        static final int[] valueOf;

        static {
            int[] iArr = new int[AFi1nSDK.AFa1uSDK.values().length];
            valueOf = iArr;
            try {
                iArr[AFi1nSDK.AFa1uSDK.FINISHED.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                valueOf[AFi1nSDK.AFa1uSDK.STARTED.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
        }
    }
}
