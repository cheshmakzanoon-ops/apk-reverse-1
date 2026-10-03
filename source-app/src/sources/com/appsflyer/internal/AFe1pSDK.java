package com.appsflyer.internal;

import com.appsflyer.internal.components.network.http.ResponseNetwork;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

public class AFe1pSDK<Body> implements ResponseNetwork<Body> {
    final boolean AFInAppEventParameterName;
    final int AFInAppEventType;
    private final Body AFKeystoreWrapper;
    final Map<String, List<String>> valueOf;
    public final AFe1tSDK values;

    public AFe1pSDK(Body body, int i, boolean z, Map<String, List<String>> map, AFe1tSDK aFe1tSDK) {
        this.AFKeystoreWrapper = body;
        this.AFInAppEventType = i;
        this.AFInAppEventParameterName = z;
        this.valueOf = new HashMap(map);
        this.values = aFe1tSDK;
    }

    @Override
    public Body getBody() {
        return this.AFKeystoreWrapper;
    }

    @Override
    public int getStatusCode() {
        return this.AFInAppEventType;
    }

    @Override
    public boolean isSuccessful() {
        return this.AFInAppEventParameterName;
    }

    @Override
    public List<String> getHeaderField(String str) {
        for (String str2 : this.valueOf.keySet()) {
            if (str2 != null && str2.equalsIgnoreCase(str)) {
                return this.valueOf.get(str2);
            }
        }
        return null;
    }

    public final String AFInAppEventType(String str) {
        List<String> headerField = getHeaderField(str);
        if (headerField == null || headerField.isEmpty()) {
            return null;
        }
        Iterator<String> it = headerField.iterator();
        StringBuilder sb = new StringBuilder(it.next());
        while (it.hasNext()) {
            sb.append(", ");
            sb.append(it.next());
        }
        return sb.toString();
    }

    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null || getClass() != obj.getClass()) {
            return false;
        }
        AFe1pSDK aFe1pSDK = (AFe1pSDK) obj;
        if (this.AFInAppEventType == aFe1pSDK.AFInAppEventType && this.AFInAppEventParameterName == aFe1pSDK.AFInAppEventParameterName && this.AFKeystoreWrapper.equals(aFe1pSDK.AFKeystoreWrapper) && this.valueOf.equals(aFe1pSDK.valueOf)) {
            return this.values.equals(aFe1pSDK.values);
        }
        return false;
    }

    public int hashCode() {
        return (((((((this.AFKeystoreWrapper.hashCode() * 31) + this.AFInAppEventType) * 31) + (this.AFInAppEventParameterName ? 1 : 0)) * 31) + this.valueOf.hashCode()) * 31) + this.values.hashCode();
    }
}
