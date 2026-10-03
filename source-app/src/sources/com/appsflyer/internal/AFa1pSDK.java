package com.appsflyer.internal;

import android.net.Uri;
import com.appsflyer.AppsFlyerProperties;
import com.appsflyer.attribution.AppsFlyerRequestListener;
import java.util.HashMap;
import java.util.Map;

public abstract class AFa1pSDK {
    public Map<String, Object> AFInAppEventParameterName;
    public String AFInAppEventType;
    public final Map<String, Object> AFKeystoreWrapper;
    public String AFLogger;

    public String f294d;

    public String f295e;

    private byte[] f296i;
    public int registerClient;
    public String unregisterClient;
    public AppsFlyerRequestListener valueOf;
    public String values;

    private final boolean f297w;

    public abstract AFe1bSDK AFInAppEventParameterName();

    public boolean AFLogger() {
        return true;
    }

    public boolean mo764d() {
        return true;
    }

    public boolean mo765e() {
        return true;
    }

    public boolean registerClient() {
        return false;
    }

    public AFa1pSDK() {
        this(null, null, null);
    }

    public AFa1pSDK(String str, String str2, Boolean bool) {
        this.AFKeystoreWrapper = new HashMap();
        this.AFLogger = str;
        this.unregisterClient = str2;
        this.f297w = bool != null ? bool.booleanValue() : true;
    }

    public AFa1pSDK AFKeystoreWrapper(String str) {
        this.unregisterClient = str;
        return this;
    }

    public final boolean valueOf() {
        return this.AFLogger == null && this.values == null;
    }

    public final AFa1pSDK AFInAppEventType(Map<String, ?> map) {
        synchronized (map) {
            this.AFKeystoreWrapper.putAll(map);
        }
        return this;
    }

    public final AFa1pSDK AFKeystoreWrapper(String str, Object obj) {
        synchronized (this.AFKeystoreWrapper) {
            this.AFKeystoreWrapper.put(str, obj);
        }
        return this;
    }

    public final Map<String, Object> AFInAppEventType() {
        return this.AFKeystoreWrapper;
    }

    public final AFa1pSDK AFInAppEventType(int i) {
        this.registerClient = i;
        synchronized (this.AFKeystoreWrapper) {
            if (this.AFKeystoreWrapper.containsKey("counter")) {
                this.AFKeystoreWrapper.put("counter", Integer.toString(i));
            }
            if (this.AFKeystoreWrapper.containsKey("launch_counter")) {
                this.AFKeystoreWrapper.put("launch_counter", Integer.toString(i));
            }
        }
        return this;
    }

    public final AFa1pSDK values(byte[] bArr) {
        this.f296i = bArr;
        return this;
    }

    public final byte[] values() {
        return this.f296i;
    }

    public final boolean AFKeystoreWrapper() {
        return this.f297w;
    }

    protected static String valueOf(String str) {
        String strValues = AFb1vSDK.valueOf().AFInAppEventType().AFInAppEventType().values();
        return strValues != null ? Uri.parse(str).buildUpon().appendQueryParameter(AppsFlyerProperties.CHANNEL, strValues).build().toString() : str;
    }

    public static boolean values(double d) {
        if (d < 0.0d || d >= 1.0d) {
            return false;
        }
        if (d == 0.0d) {
            return true;
        }
        int i = (int) (1.0d / d);
        if (i + 1 > 0) {
            return ((int) ((Math.random() * ((double) i)) + 1.0d)) != i;
        }
        throw new IllegalArgumentException("Unsupported max value");
    }
}
