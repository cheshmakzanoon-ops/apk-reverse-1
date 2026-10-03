package com.appsflyer.internal;

import com.appsflyer.AFLogger;
import com.appsflyer.deeplink.DeepLinkResult;
import j$.util.concurrent.ConcurrentHashMap;
import java.util.Collections;
import java.util.Map;
import org.json.JSONObject;

public final class AFg1bSDK {
    public final Map<String, Object> AFInAppEventParameterName;
    public final Map<String, Object> AFInAppEventType;
    public final AFd1xSDK AFKeystoreWrapper;
    public final long[] AFLogger;

    public long f377d;

    public final long[] f378e;

    public long f379i;
    public final long[] registerClient;
    public long unregisterClient;

    public long f380v;
    public long valueOf;
    public final Map<String, Object> values;

    public AFg1bSDK(AFd1xSDK aFd1xSDK) {
        ConcurrentHashMap concurrentHashMap = new ConcurrentHashMap();
        this.AFInAppEventParameterName = concurrentHashMap;
        ConcurrentHashMap concurrentHashMap2 = new ConcurrentHashMap();
        this.values = concurrentHashMap2;
        ConcurrentHashMap concurrentHashMap3 = new ConcurrentHashMap();
        this.AFInAppEventType = concurrentHashMap3;
        this.valueOf = 0L;
        this.unregisterClient = 0L;
        this.AFLogger = new long[2];
        this.registerClient = new long[2];
        this.f378e = new long[2];
        this.f377d = 0L;
        this.f380v = 0L;
        this.AFKeystoreWrapper = aFd1xSDK;
        concurrentHashMap.putAll(AFInAppEventParameterName("first_launch"));
        concurrentHashMap2.putAll(AFInAppEventParameterName("ddl"));
        concurrentHashMap3.putAll(AFInAppEventParameterName("gcd"));
        this.f379i = aFd1xSDK.AFInAppEventType("prev_session_dur", 0L);
    }

    public final void AFInAppEventParameterName() {
        this.unregisterClient = System.currentTimeMillis();
        if (values()) {
            long j = this.valueOf;
            if (j != 0) {
                this.AFInAppEventParameterName.put("init_to_fg", Long.valueOf(this.unregisterClient - j));
                this.AFKeystoreWrapper.values("first_launch", new JSONObject(this.AFInAppEventParameterName).toString());
                return;
            }
            AFLogger.afInfoLog("Metrics: init ts is missing");
        }
    }

    public final void AFInAppEventParameterName(AFg1fSDK aFg1fSDK) {
        if (values()) {
            this.AFInAppEventParameterName.put("start_with", aFg1fSDK.toString());
            this.AFKeystoreWrapper.values("first_launch", new JSONObject(this.AFInAppEventParameterName).toString());
        }
    }

    public final void AFInAppEventParameterName(int i) {
        long jCurrentTimeMillis = System.currentTimeMillis();
        this.f377d = jCurrentTimeMillis;
        if (i == 1) {
            long j = this.unregisterClient;
            if (j != 0) {
                this.AFInAppEventParameterName.put("from_fg", Long.valueOf(jCurrentTimeMillis - j));
                this.AFKeystoreWrapper.values("first_launch", new JSONObject(this.AFInAppEventParameterName).toString());
                return;
            }
            AFLogger.afInfoLog("Metrics: fg ts is missing");
        }
    }

    public final void valueOf(DeepLinkResult deepLinkResult, long j) {
        this.values.put("status", deepLinkResult.getStatus().toString());
        this.values.put("timeout_value", Long.valueOf(j));
        this.AFKeystoreWrapper.values("ddl", new JSONObject(this.values).toString());
    }

    public final void values(int i) {
        long jCurrentTimeMillis = System.currentTimeMillis();
        long j = this.f380v;
        if (j != 0) {
            this.AFInAppEventType.put("net", Long.valueOf(jCurrentTimeMillis - j));
        } else {
            AFLogger.afInfoLog("Metrics: gcdStart ts is missing");
        }
        this.AFInAppEventType.put("retries", Integer.valueOf(i));
        this.AFKeystoreWrapper.values("gcd", new JSONObject(this.AFInAppEventType).toString());
    }

    private Map<String, Object> AFInAppEventParameterName(String str) {
        Map<String, Object> mapEmptyMap = Collections.emptyMap();
        String strValueOf = this.AFKeystoreWrapper.valueOf(str, (String) null);
        if (strValueOf == null) {
            return mapEmptyMap;
        }
        try {
            return AFa1oSDK.AFInAppEventType(new JSONObject(strValueOf));
        } catch (Exception e) {
            AFLogger.afErrorLog("Error while parsing cached json data", e, true);
            return mapEmptyMap;
        }
    }

    public final boolean values() {
        return this.AFKeystoreWrapper.valueOf("appsFlyerCount", 0) == 0;
    }
}
