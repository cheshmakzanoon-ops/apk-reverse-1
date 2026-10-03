package com.appsflyer.internal;

import android.util.Base64;
import com.appsflyer.AFLogger;
import java.nio.charset.Charset;

public final class AFf1gSDK {
    public AFh1nSDK AFInAppEventParameterName = null;
    public AFh1nSDK AFInAppEventType = AFKeystoreWrapper();
    public long AFKeystoreWrapper;
    public long valueOf;
    public final AFd1xSDK values;

    public AFf1gSDK(AFd1xSDK aFd1xSDK) {
        this.values = aFd1xSDK;
        this.valueOf = aFd1xSDK.AFInAppEventType("af_rc_timestamp", 0L);
        this.AFKeystoreWrapper = aFd1xSDK.AFInAppEventType("af_rc_max_age", 0L);
    }

    private AFh1nSDK AFKeystoreWrapper() {
        String strValueOf = this.values.valueOf("af_remote_config", (String) null);
        if (strValueOf == null) {
            AFLogger.INSTANCE.m797d(AFg1hSDK.REMOTE_CONTROL, "No configuration found in cache");
            return null;
        }
        try {
            return new AFh1nSDK(new String(Base64.decode(strValueOf, 2), Charset.defaultCharset()));
        } catch (Exception e) {
            AFLogger.INSTANCE.m799e(AFg1hSDK.REMOTE_CONTROL, "Error reading malformed configuration from cache, requires fetching from remote again", e, true);
            return null;
        }
    }
}
