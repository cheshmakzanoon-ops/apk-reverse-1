package com.appsflyer.internal;

import android.content.Context;
import android.os.Process;
import android.telephony.TelephonyManager;
import android.widget.ExpandableListView;
import com.appsflyer.AFLogger;
import com.appsflyer.AppsFlyerProperties;
import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;
import java.util.Map;

public final class AFg1zSDK {
    Map<String, Object> AFInAppEventType;
    public final AFd1lSDK AFKeystoreWrapper;
    public volatile String registerClient;
    public volatile String unregisterClient;
    public long valueOf;
    public final AFf1bSDK values;
    public boolean AFInAppEventParameterName = false;

    public volatile boolean f395d = false;

    public AFg1zSDK(AFd1lSDK aFd1lSDK, AFf1bSDK aFf1bSDK) {
        this.AFKeystoreWrapper = aFd1lSDK;
        this.values = aFf1bSDK;
    }

    public final boolean valueOf() {
        return this.f395d;
    }

    public final String valueOf(AFd1xSDK aFd1xSDK) {
        String str;
        boolean z = AppsFlyerProperties.getInstance().getBoolean(AppsFlyerProperties.COLLECT_IMEI, false);
        String strValueOf = aFd1xSDK.valueOf("imeiCached", (String) null);
        if (!z || !AFc1rSDK.AFInAppEventType(this.unregisterClient)) {
            if (this.unregisterClient != null) {
                str = this.unregisterClient;
            } else {
                str = null;
            }
        } else {
            Context context = this.AFKeystoreWrapper.AFInAppEventParameterName;
            if (context == null || !AFInAppEventParameterName(context)) {
                str = null;
            } else {
                try {
                    TelephonyManager telephonyManager = (TelephonyManager) context.getSystemService("phone");
                    str = (String) telephonyManager.getClass().getMethod("getDeviceId", null).invoke(telephonyManager, null);
                    if (str == null) {
                        if (strValueOf != null) {
                            AFLogger.afDebugLog("use cached IMEI: ".concat(String.valueOf(strValueOf)));
                        } else {
                            strValueOf = null;
                        }
                        str = strValueOf;
                    }
                } catch (InvocationTargetException e) {
                    if (strValueOf != null) {
                        AFLogger.afDebugLog("use cached IMEI: ".concat(String.valueOf(strValueOf)));
                    } else {
                        strValueOf = null;
                    }
                    StringBuilder sb = new StringBuilder("WARNING: Can't collect IMEI because of missing permissions: ");
                    sb.append(e.getMessage());
                    AFLogger.afErrorLog(sb.toString(), e);
                } catch (Exception e2) {
                    if (strValueOf != null) {
                        AFLogger.afDebugLog("use cached IMEI: ".concat(String.valueOf(strValueOf)));
                    } else {
                        strValueOf = null;
                    }
                    StringBuilder sb2 = new StringBuilder("WARNING: Can't collect IMEI: other reason: ");
                    sb2.append(e2.getMessage());
                    AFLogger.afErrorLog(sb2.toString(), e2);
                }
            }
        }
        if (!AFc1rSDK.AFInAppEventType(str)) {
            aFd1xSDK.values("imeiCached", str);
            return str;
        }
        AFLogger.afInfoLog("IMEI was not collected.");
        return null;
    }

    public final Map<String, Object> values(Map<String, Object> map) throws Throwable {
        try {
            try {
                Object[] objArr = {map, this.AFKeystoreWrapper.AFInAppEventParameterName};
                Object declaredConstructor = AFc1fSDK.afRDLog.get(-1825004078);
                if (declaredConstructor == null) {
                    declaredConstructor = ((Class) AFc1fSDK.AFInAppEventType(((Process.getThreadPriority(0) + 20) >> 6) + 37, (char) ((-1) - ExpandableListView.getPackedPositionChild(0L)), (Process.getElapsedCpuTime() > 0L ? 1 : (Process.getElapsedCpuTime() == 0L ? 0 : -1)) + 123)).getDeclaredConstructor(Map.class, Context.class);
                    AFc1fSDK.afRDLog.put(-1825004078, declaredConstructor);
                }
                return (Map) ((Constructor) declaredConstructor).newInstance(objArr);
            } catch (Throwable th) {
                Throwable cause = th.getCause();
                if (cause != null) {
                    throw cause;
                }
                throw th;
            }
        } catch (Exception e) {
            AFLogger.afErrorLogForExcManagerOnly("AFCksmV3: reflection init failed", e);
            return new HashMap();
        }
    }

    public final Map<String, Object> values() {
        HashMap map = new HashMap();
        if (AFInAppEventType()) {
            map.put("lvl", this.AFInAppEventType);
        } else if (this.AFInAppEventParameterName) {
            this.AFInAppEventType = new HashMap();
            AFInAppEventParameterName();
            this.AFInAppEventType.put("error", "pending LVL response");
            map.put("lvl", this.AFInAppEventType);
        }
        return map;
    }

    private boolean AFInAppEventType() {
        Map<String, Object> map = this.AFInAppEventType;
        return (map == null || map.isEmpty()) ? false : true;
    }

    public final boolean AFKeystoreWrapper() {
        return this.AFInAppEventParameterName && !AFInAppEventType();
    }

    final void AFInAppEventParameterName() {
        this.AFInAppEventType.put("ttr", Long.valueOf(System.currentTimeMillis() - this.valueOf));
        this.AFInAppEventType.put("lvl_timestamp", Long.valueOf(this.valueOf));
    }

    private static boolean AFInAppEventParameterName(Context context) {
        if (AppsFlyerProperties.getInstance().getBoolean(AppsFlyerProperties.COLLECT_ANDROID_ID_FORCE_BY_USER, false) || AppsFlyerProperties.getInstance().getBoolean(AppsFlyerProperties.COLLECT_IMEI_FORCE_BY_USER, false)) {
            return true;
        }
        AFb1vSDK.valueOf();
        return !AFb1vSDK.values(context);
    }
}
