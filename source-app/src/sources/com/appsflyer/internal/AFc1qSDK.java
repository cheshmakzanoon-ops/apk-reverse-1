package com.appsflyer.internal;

import android.os.Build;
import com.appsflyer.AFLogger;
import com.appsflyer.deeplink.DeepLink;
import com.appsflyer.deeplink.DeepLinkResult;
import com.facebook.gamingservices.cloudgaming.internal.SDKAnalyticsEvents;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import com.facebook.share.internal.ShareConstants;
import j$.util.DesugarTimeZone;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Observable;
import java.util.Observer;
import java.util.concurrent.Callable;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.FutureTask;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;
import org.json.JSONException;
import org.json.JSONObject;

public final class AFc1qSDK extends AFh1vSDK {
    private int AFLogger$LogLevel;
    private final ExecutorService afDebugLog;
    private final AFb1cSDK afErrorLog;
    private boolean afErrorLogForExcManagerOnly;
    private final AFg1zSDK afInfoLog;
    private int afLogForce;
    private final AFd1sSDK afRDLog;
    private final AFc1jSDK afVerboseLog;
    private final AFi1kSDK afWarnLog;
    private final List<AFi1nSDK> force;
    private int getLevel;

    private final AFd1rSDK f315i;

    private final AFg1bSDK f316v;

    private final CountDownLatch f317w;

    public AFc1qSDK(AFd1nSDK aFd1nSDK) {
        super(null, "https://%sdlsdk.%s/v1.0/android/", Boolean.FALSE, Boolean.TRUE, null);
        this.force = new ArrayList();
        this.f317w = new CountDownLatch(1);
        this.f316v = aFd1nSDK.unregisterClient();
        this.f315i = aFd1nSDK.AFInAppEventType();
        this.afInfoLog = aFd1nSDK.mo785i();
        this.afWarnLog = aFd1nSDK.force();
        this.afDebugLog = aFd1nSDK.values();
        this.afErrorLog = aFd1nSDK.afInfoLog();
        this.afVerboseLog = aFd1nSDK.afErrorLog();
        this.afRDLog = aFd1nSDK.getLevel();
    }

    public final DeepLinkResult unregisterClient() {
        DeepLinkResult.Error error;
        AFLogger.INSTANCE.m797d(AFg1hSDK.DDL, "start");
        FutureTask futureTask = new FutureTask(new Callable<DeepLinkResult>() {
            @Override
            public final DeepLinkResult call() throws Exception {
                AFc1qSDK.AFKeystoreWrapper(AFc1qSDK.this);
                AFc1qSDK.this.force();
                return AFc1qSDK.AFInAppEventParameterName(AFc1qSDK.this);
            }
        });
        this.afDebugLog.execute(futureTask);
        try {
            DeepLinkResult deepLinkResult = (DeepLinkResult) futureTask.get(this.afVerboseLog.AFLogger, TimeUnit.MILLISECONDS);
            this.f316v.valueOf(deepLinkResult, this.afVerboseLog.AFLogger);
            this.afVerboseLog.AFInAppEventType(deepLinkResult);
            return deepLinkResult;
        } catch (InterruptedException e) {
            e = e;
            AFLogger.INSTANCE.mo760e(AFg1hSDK.DDL, "AppsFlyer SDK is stopped: the request was not sent to the server", e, true, true, false, true);
            if (e.getCause() instanceof IOException) {
                error = DeepLinkResult.Error.NETWORK;
            } else {
                error = DeepLinkResult.Error.UNEXPECTED;
            }
            DeepLinkResult deepLinkResult2 = new DeepLinkResult(null, error);
            this.f316v.valueOf(deepLinkResult2, this.afVerboseLog.AFLogger);
            this.afVerboseLog.AFInAppEventType(deepLinkResult2);
            return deepLinkResult2;
        } catch (ExecutionException e2) {
            e = e2;
            AFLogger.INSTANCE.mo760e(AFg1hSDK.DDL, "AppsFlyer SDK is stopped: the request was not sent to the server", e, true, true, false, true);
            if (e.getCause() instanceof IOException) {
                error = DeepLinkResult.Error.NETWORK;
            } else {
                error = DeepLinkResult.Error.UNEXPECTED;
            }
            DeepLinkResult deepLinkResult3 = new DeepLinkResult(null, error);
            this.f316v.valueOf(deepLinkResult3, this.afVerboseLog.AFLogger);
            this.afVerboseLog.AFInAppEventType(deepLinkResult3);
            return deepLinkResult3;
        } catch (TimeoutException e3) {
            AFLogger.afErrorLogForExcManagerOnly("[DDL] Timeout", e3);
            AFLogger aFLogger = AFLogger.INSTANCE;
            AFg1hSDK aFg1hSDK = AFg1hSDK.DDL;
            StringBuilder sb = new StringBuilder("Timeout, didn't manage to find deferred deep link after ");
            sb.append(this.afLogForce);
            sb.append(" attempt(s) within ");
            sb.append(this.afVerboseLog.AFLogger);
            sb.append(" milliseconds");
            aFLogger.m797d(aFg1hSDK, sb.toString());
            DeepLinkResult deepLinkResult4 = new DeepLinkResult(null, DeepLinkResult.Error.TIMEOUT);
            this.f316v.valueOf(deepLinkResult4, this.afVerboseLog.AFLogger);
            this.afVerboseLog.AFInAppEventType(deepLinkResult4);
            return deepLinkResult4;
        }
    }

    private boolean afInfoLog() {
        List list = (List) this.AFKeystoreWrapper.get("referrers");
        return (list != null ? list.size() : 0) < this.AFLogger$LogLevel && !this.AFKeystoreWrapper.containsKey("referrers");
    }

    public void force() {
        String[] strArr;
        this.afLogForce++;
        AFLogger aFLogger = AFLogger.INSTANCE;
        AFg1hSDK aFg1hSDK = AFg1hSDK.DDL;
        StringBuilder sb = new StringBuilder("Preparing request ");
        sb.append(this.afLogForce);
        aFLogger.m797d(aFg1hSDK, sb.toString());
        if (this.afLogForce == 1) {
            this.AFKeystoreWrapper.put("is_first", Boolean.valueOf(this.f315i.AFInAppEventParameterName.valueOf("appsFlyerCount", 0) == 0));
            Map<String, Object> map = this.AFKeystoreWrapper;
            StringBuilder sb2 = new StringBuilder();
            sb2.append(Locale.getDefault().getLanguage());
            sb2.append("-");
            sb2.append(Locale.getDefault().getCountry());
            map.put("lang", sb2.toString());
            this.AFKeystoreWrapper.put("os", Build.VERSION.RELEASE);
            this.AFKeystoreWrapper.put("type", Build.MODEL);
            Map<String, Object> map2 = this.AFKeystoreWrapper;
            AFd1rSDK aFd1rSDK = this.f315i;
            map2.put(SDKAnalyticsEvents.PARAMETER_REQUEST_ID, AFb1lSDK.values(aFd1rSDK.AFKeystoreWrapper, aFd1rSDK.AFInAppEventParameterName));
            AFc1aSDK aFc1aSDK = this.afRDLog.AFKeystoreWrapper;
            if (aFc1aSDK != null && (strArr = aFc1aSDK.AFKeystoreWrapper) != null) {
                this.AFKeystoreWrapper.put("sharing_filter", strArr);
            }
            Map<String, Object> mapAFKeystoreWrapper = AFKeystoreWrapper(AFb1tSDK.valueOf(this.f315i.AFKeystoreWrapper.AFInAppEventParameterName, new HashMap()));
            Map<String, Object> mapAFKeystoreWrapper2 = AFKeystoreWrapper(AFb1tSDK.AFInAppEventParameterName(this.f315i.AFKeystoreWrapper.AFInAppEventParameterName));
            if (mapAFKeystoreWrapper != null) {
                this.AFKeystoreWrapper.put("gaid", mapAFKeystoreWrapper);
            }
            if (mapAFKeystoreWrapper2 != null) {
                this.AFKeystoreWrapper.put("oaid", mapAFKeystoreWrapper2);
            }
        }
        Map<String, Object> map3 = this.AFKeystoreWrapper;
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS", Locale.US);
        long jCurrentTimeMillis = System.currentTimeMillis();
        simpleDateFormat.setTimeZone(DesugarTimeZone.getTimeZone("UTC"));
        map3.put(SDKConstants.PARAM_DEBUG_MESSAGE_TIMESTAMP, simpleDateFormat.format(new Date(jCurrentTimeMillis)));
        this.AFKeystoreWrapper.put("request_count", Integer.valueOf(this.afLogForce));
        ArrayList arrayList = new ArrayList();
        Iterator<AFi1nSDK> it = this.force.iterator();
        while (it.hasNext()) {
            Map<String, String> mapValueOf = valueOf(it.next());
            if (mapValueOf != null) {
                arrayList.add(mapValueOf);
            }
        }
        if (!arrayList.isEmpty()) {
            this.AFKeystoreWrapper.put("referrers", arrayList);
        }
        AFKeystoreWrapper(afWarnLog());
    }

    private String afWarnLog() {
        return new AFi1cSDK(this.f315i).AFInAppEventParameterName(this.afInfoLog.registerClient, (String) this.AFKeystoreWrapper.get(SDKConstants.PARAM_DEBUG_MESSAGE_TIMESTAMP));
    }

    static class C08371 {
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

    public void AFInAppEventParameterName(AFi1nSDK aFi1nSDK) {
        if (values(aFi1nSDK)) {
            this.force.add(aFi1nSDK);
            this.f317w.countDown();
            AFLogger aFLogger = AFLogger.INSTANCE;
            AFg1hSDK aFg1hSDK = AFg1hSDK.DDL;
            StringBuilder sb = new StringBuilder("Added non-organic ");
            sb.append(aFi1nSDK.getClass().getSimpleName());
            aFLogger.m797d(aFg1hSDK, sb.toString());
            return;
        }
        int i = this.getLevel + 1;
        this.getLevel = i;
        if (i == this.AFLogger$LogLevel) {
            this.f317w.countDown();
        }
    }

    private static boolean values(AFi1nSDK aFi1nSDK) {
        Long l = (Long) aFi1nSDK.values.get("click_ts");
        return l != null && System.currentTimeMillis() - TimeUnit.SECONDS.toMillis(l.longValue()) < TimeUnit.DAYS.toMillis(1L);
    }

    @Override
    public final AFe1bSDK AFInAppEventParameterName() {
        return AFe1bSDK.DLSDK;
    }

    private Map<String, Object> AFKeystoreWrapper(final AFa1aSDK aFa1aSDK) {
        if (aFa1aSDK == null || aFa1aSDK.valueOf == null) {
            return null;
        }
        Boolean bool = aFa1aSDK.AFInAppEventType;
        if (bool == null || !bool.booleanValue()) {
            return new HashMap<String, Object>() {
                {
                    put("type", "unhashed");
                    put(SDKConstants.PARAM_VALUE, aFa1aSDK.valueOf);
                }
            };
        }
        return null;
    }

    private static Map<String, String> valueOf(AFi1nSDK aFi1nSDK) {
        if (aFi1nSDK.unregisterClient != AFi1nSDK.AFa1uSDK.FINISHED) {
            return null;
        }
        HashMap map = new HashMap();
        String str = (String) aFi1nSDK.values.get("referrer");
        if (str == null) {
            return null;
        }
        map.put(ShareConstants.FEED_SOURCE_PARAM, (String) aFi1nSDK.values.get(ShareConstants.FEED_SOURCE_PARAM));
        map.put(SDKConstants.PARAM_VALUE, str);
        return map;
    }

    static void AFKeystoreWrapper(AFc1qSDK aFc1qSDK) {
        ArrayList<AFi1nSDK> arrayList = new ArrayList();
        for (AFi1nSDK aFi1nSDK : aFc1qSDK.afWarnLog.AFInAppEventType()) {
            if (aFi1nSDK != null && aFi1nSDK.unregisterClient != AFi1nSDK.AFa1uSDK.NOT_STARTED) {
                arrayList.add(aFi1nSDK);
            }
        }
        aFc1qSDK.AFLogger$LogLevel = arrayList.size();
        for (final AFi1nSDK aFi1nSDK2 : arrayList) {
            int i = C08371.valueOf[aFi1nSDK2.unregisterClient.ordinal()];
            if (i == 1) {
                AFLogger aFLogger = AFLogger.INSTANCE;
                AFg1hSDK aFg1hSDK = AFg1hSDK.DDL;
                StringBuilder sb = new StringBuilder();
                sb.append(aFi1nSDK2.values.get(ShareConstants.FEED_SOURCE_PARAM));
                sb.append(" referrer collected earlier");
                aFLogger.m797d(aFg1hSDK, sb.toString());
                aFc1qSDK.AFInAppEventParameterName(aFi1nSDK2);
            } else if (i == 2) {
                aFi1nSDK2.addObserver(new Observer() {
                    @Override
                    public final void update(Observable observable, Object obj) {
                        AFLogger aFLogger2 = AFLogger.INSTANCE;
                        AFg1hSDK aFg1hSDK2 = AFg1hSDK.DDL;
                        StringBuilder sb2 = new StringBuilder();
                        sb2.append(aFi1nSDK2.values.get(ShareConstants.FEED_SOURCE_PARAM));
                        sb2.append(" referrer collected via observer");
                        aFLogger2.m797d(aFg1hSDK2, sb2.toString());
                        AFc1qSDK.this.AFInAppEventParameterName((AFi1nSDK) observable);
                    }
                });
            }
        }
    }

    static DeepLinkResult AFInAppEventParameterName(AFc1qSDK aFc1qSDK) throws JSONException, InterruptedException, IOException {
        DeepLink deepLinkAFInAppEventType;
        while (true) {
            AFg1bSDK aFg1bSDK = aFc1qSDK.f316v;
            int i = aFc1qSDK.afLogForce;
            if (i <= 0 || i > 2) {
                AFLogger.afErrorLogForExcManagerOnly("Unexpected ddl requestCount - start", new IllegalStateException("Metrics: Unexpected ddl requestCount = ".concat(String.valueOf(i))));
            } else {
                int i2 = i - 1;
                aFg1bSDK.AFLogger[i2] = System.currentTimeMillis();
                if (i2 == 0) {
                    if (aFg1bSDK.unregisterClient != 0) {
                        aFg1bSDK.values.put("from_fg", Long.valueOf(aFg1bSDK.AFLogger[i2] - aFg1bSDK.unregisterClient));
                        aFg1bSDK.AFKeystoreWrapper.values("ddl", new JSONObject(aFg1bSDK.values).toString());
                    } else {
                        AFLogger.afInfoLog("Metrics: fg ts is missing");
                    }
                }
            }
            HttpURLConnection httpURLConnectionAFKeystoreWrapper = new AFb1uSDK(aFc1qSDK, aFc1qSDK.afErrorLog).AFKeystoreWrapper(aFc1qSDK.afInfoLog.registerClient);
            AFg1bSDK aFg1bSDK2 = aFc1qSDK.f316v;
            int i3 = aFc1qSDK.afLogForce;
            if (i3 <= 0 || i3 > 2) {
                AFLogger.afErrorLogForExcManagerOnly("Unexpected ddl requestCount - end", new IllegalStateException("Metrics: Unexpected ddl requestCount = ".concat(String.valueOf(i3))));
            } else {
                int i4 = i3 - 1;
                aFg1bSDK2.registerClient[i4] = System.currentTimeMillis();
                if (aFg1bSDK2.AFLogger[i4] != 0) {
                    aFg1bSDK2.f378e[i4] = aFg1bSDK2.registerClient[i4] - aFg1bSDK2.AFLogger[i4];
                    aFg1bSDK2.values.put("net", aFg1bSDK2.f378e);
                    aFg1bSDK2.AFKeystoreWrapper.values("ddl", new JSONObject(aFg1bSDK2.values).toString());
                } else {
                    StringBuilder sb = new StringBuilder("Metrics: ddlStart[");
                    sb.append(i4);
                    sb.append("] ts is missing");
                    AFLogger.afInfoLog(sb.toString());
                }
            }
            if (httpURLConnectionAFKeystoreWrapper.getResponseCode() != 200) {
                AFLogger aFLogger = AFLogger.INSTANCE;
                AFg1hSDK aFg1hSDK = AFg1hSDK.DDL;
                StringBuilder sb2 = new StringBuilder("Error occurred. Server response code = ");
                sb2.append(httpURLConnectionAFKeystoreWrapper.getResponseCode());
                aFLogger.m797d(aFg1hSDK, sb2.toString());
                return new DeepLinkResult(null, DeepLinkResult.Error.HTTP_STATUS_CODE);
            }
            JSONObject jSONObject = new JSONObject(AFb1vSDK.AFInAppEventType(httpURLConnectionAFKeystoreWrapper));
            aFc1qSDK.afErrorLogForExcManagerOnly = jSONObject.optBoolean("is_second_ping", true);
            if (jSONObject.optBoolean("found")) {
                deepLinkAFInAppEventType = DeepLink.AFInAppEventType(jSONObject.optJSONObject("click_event"));
                deepLinkAFInAppEventType.valueOf.put("is_deferred", true);
            } else {
                deepLinkAFInAppEventType = null;
            }
            if (deepLinkAFInAppEventType != null) {
                return new DeepLinkResult(deepLinkAFInAppEventType, null);
            }
            if (aFc1qSDK.afLogForce <= 1 && aFc1qSDK.afInfoLog() && aFc1qSDK.afErrorLogForExcManagerOnly) {
                AFLogger.INSTANCE.m797d(AFg1hSDK.DDL, "Waiting for referrers...");
                aFc1qSDK.f317w.await();
                AFg1bSDK aFg1bSDK3 = aFc1qSDK.f316v;
                long jCurrentTimeMillis = System.currentTimeMillis();
                if (aFg1bSDK3.registerClient[0] != 0) {
                    aFg1bSDK3.values.put("rfr_wait", Long.valueOf(jCurrentTimeMillis - aFg1bSDK3.registerClient[0]));
                    aFg1bSDK3.AFKeystoreWrapper.values("ddl", new JSONObject(aFg1bSDK3.values).toString());
                } else {
                    AFLogger.afInfoLog("Metrics: ddlEnd[0] ts is missing");
                }
                if (aFc1qSDK.getLevel != aFc1qSDK.AFLogger$LogLevel) {
                    aFc1qSDK.force();
                } else {
                    return new DeepLinkResult(null, null);
                }
            } else {
                return new DeepLinkResult(null, null);
            }
        }
    }
}
