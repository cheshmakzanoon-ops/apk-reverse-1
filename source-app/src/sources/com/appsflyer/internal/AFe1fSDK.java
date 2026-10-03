package com.appsflyer.internal;

import android.net.TrafficStats;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;
import java.util.concurrent.Callable;
import java.util.concurrent.atomic.AtomicInteger;

public abstract class AFe1fSDK<Result> implements Comparable<AFe1fSDK<?>>, Callable<AFe1cSDK> {
    private static final AtomicInteger AFLogger = new AtomicInteger();
    public final Set<AFe1bSDK> AFInAppEventParameterName;
    public final AFe1bSDK AFInAppEventType;
    public AFe1cSDK AFKeystoreWrapper;

    private Throwable f338d;

    private long f339e;
    private final int registerClient;
    private final String unregisterClient;

    private boolean f340v;
    public final Set<AFe1bSDK> valueOf;
    public volatile int values;

    protected abstract AFe1cSDK AFInAppEventType() throws Exception;

    protected void AFInAppEventType(Throwable th) {
    }

    protected abstract long AFKeystoreWrapper();

    protected void valueOf() {
    }

    protected abstract boolean values();

    public AFe1fSDK(AFe1bSDK aFe1bSDK, AFe1bSDK[] aFe1bSDKArr, String str) {
        HashSet hashSet = new HashSet();
        this.valueOf = hashSet;
        this.AFInAppEventParameterName = new HashSet();
        int iIncrementAndGet = AFLogger.incrementAndGet();
        this.registerClient = iIncrementAndGet;
        this.f340v = false;
        this.values = 0;
        this.AFInAppEventType = aFe1bSDK;
        Collections.addAll(hashSet, aFe1bSDKArr);
        if (str != null) {
            this.unregisterClient = str;
        } else {
            this.unregisterClient = String.valueOf(iIncrementAndGet);
        }
    }

    public void AFInAppEventParameterName() {
        this.f340v = true;
    }

    protected final boolean AFLogger() {
        return this.f340v;
    }

    @Override
    public final AFe1cSDK call() throws Exception {
        TrafficStats.setThreadStatsTag("AppsFlyer".hashCode());
        this.AFKeystoreWrapper = null;
        this.f338d = null;
        long jCurrentTimeMillis = System.currentTimeMillis();
        this.values++;
        try {
            AFe1cSDK aFe1cSDKAFInAppEventType = AFInAppEventType();
            this.AFKeystoreWrapper = aFe1cSDKAFInAppEventType;
            this.f339e = System.currentTimeMillis() - jCurrentTimeMillis;
            valueOf();
            return aFe1cSDKAFInAppEventType;
        } catch (Throwable th) {
            try {
                this.f338d = th;
                this.AFKeystoreWrapper = AFe1cSDK.FAILURE;
                AFInAppEventType(th);
                throw th;
            } catch (Throwable th2) {
                this.f339e = System.currentTimeMillis() - jCurrentTimeMillis;
                valueOf();
                throw th2;
            }
        }
    }

    public final Throwable m790d() {
        return this.f338d;
    }

    @Override
    public final int compareTo(AFe1fSDK<?> aFe1fSDK) {
        int i = this.AFInAppEventType.afErrorLog - aFe1fSDK.AFInAppEventType.afErrorLog;
        if (i != 0) {
            return i;
        }
        if (this.unregisterClient.equals(aFe1fSDK.unregisterClient)) {
            return 0;
        }
        return this.registerClient - aFe1fSDK.registerClient;
    }

    public final boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null || getClass() != obj.getClass()) {
            return false;
        }
        AFe1fSDK aFe1fSDK = (AFe1fSDK) obj;
        if (this.AFInAppEventType != aFe1fSDK.AFInAppEventType) {
            return false;
        }
        return this.unregisterClient.equals(aFe1fSDK.unregisterClient);
    }

    public final int hashCode() {
        return (this.AFInAppEventType.hashCode() * 31) + this.unregisterClient.hashCode();
    }

    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(this.AFInAppEventType);
        sb.append("-");
        sb.append(this.unregisterClient);
        String string = sb.toString();
        if (String.valueOf(this.registerClient).equals(this.unregisterClient)) {
            return string;
        }
        StringBuilder sb2 = new StringBuilder();
        sb2.append(string);
        sb2.append("-");
        sb2.append(this.registerClient);
        return sb2.toString();
    }
}
