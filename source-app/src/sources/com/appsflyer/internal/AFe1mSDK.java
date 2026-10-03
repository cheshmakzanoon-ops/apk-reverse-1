package com.appsflyer.internal;

import java.util.HashMap;
import java.util.Map;

public class AFe1mSDK {
    final Map<String, String> AFInAppEventParameterName;
    public boolean AFInAppEventType;
    public boolean AFKeystoreWrapper;
    public int AFLogger;

    private final boolean f341d;

    private boolean f342e;
    private final boolean registerClient;
    private final byte[] unregisterClient;
    final String valueOf;
    public final String values;

    public AFe1mSDK(String str, byte[] bArr, String str2, Map<String, String> map, boolean z) {
        this(str, bArr, str2, map, z, (byte) 0);
    }

    private AFe1mSDK(String str, byte[] bArr, String str2, Map<String, String> map, boolean z, byte b) {
        this.f342e = true;
        this.AFInAppEventType = false;
        this.AFKeystoreWrapper = true;
        this.AFLogger = -1;
        this.values = str;
        this.unregisterClient = bArr;
        this.valueOf = str2;
        this.AFInAppEventParameterName = map;
        this.registerClient = z;
        this.f341d = true;
    }

    public AFe1mSDK(String str, String str2) {
        this(str, null, str2, new HashMap(), false);
    }

    public final byte[] values() {
        return this.unregisterClient;
    }

    public final boolean valueOf() {
        return this.registerClient;
    }

    public final boolean AFKeystoreWrapper() {
        return this.f342e;
    }

    public final boolean AFInAppEventParameterName() {
        return this.AFInAppEventType;
    }

    public final boolean AFInAppEventType() {
        return this.f341d;
    }

    public final boolean registerClient() {
        return this.AFKeystoreWrapper;
    }
}
