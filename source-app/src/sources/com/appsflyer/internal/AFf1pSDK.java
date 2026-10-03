package com.appsflyer.internal;

import android.graphics.drawable.Drawable;
import android.view.ViewConfiguration;
import android.widget.ExpandableListView;
import com.appsflyer.AFLogger;
import com.appsflyer.attribution.AppsFlyerRequestListener;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import kotlin.text.StringsKt;
import org.json.JSONObject;

public class AFf1pSDK extends AFf1tSDK<String> {
    private static final AFe1bSDK[] afVerboseLog = {AFe1bSDK.DLSDK, AFe1bSDK.ONELINK, AFe1bSDK.REGISTER};
    private final AFg1xSDK afDebugLog;
    private final AFd1rSDK afInfoLog;
    private final AFd1lSDK afWarnLog;
    private final AFe1jSDK force;

    protected final AFg1qSDK f362i;
    public final AFa1pSDK registerClient;

    private final AFf1eSDK f363v;

    protected final AFd1xSDK f364w;

    @Override
    protected boolean unregisterClient() {
        return true;
    }

    public AFf1pSDK(AFa1pSDK aFa1pSDK, AFd1nSDK aFd1nSDK) {
        this(aFa1pSDK, aFd1nSDK, null);
    }

    public AFf1pSDK(AFa1pSDK aFa1pSDK, AFd1nSDK aFd1nSDK, String str) {
        super(aFa1pSDK.AFInAppEventParameterName(), new AFe1bSDK[]{AFe1bSDK.RC_CDN}, aFd1nSDK, str);
        this.registerClient = aFa1pSDK;
        this.force = aFd1nSDK.afVerboseLog();
        this.f364w = aFd1nSDK.AFKeystoreWrapper();
        this.f363v = aFd1nSDK.mo784e();
        this.afWarnLog = aFd1nSDK.mo786v();
        this.afInfoLog = aFd1nSDK.AFInAppEventType();
        this.f362i = aFd1nSDK.mo783d();
        this.afDebugLog = aFd1nSDK.onInstallConversionDataLoadedNative();
        for (AFe1bSDK aFe1bSDK : afVerboseLog) {
            if (this.AFInAppEventType == aFe1bSDK) {
                return;
            }
        }
        int i = this.registerClient.registerClient;
        AFe1bSDK aFe1bSDK2 = this.AFInAppEventType;
        if (i <= 0) {
            if (aFe1bSDK2 != AFe1bSDK.CONVERSION) {
                this.valueOf.add(AFe1bSDK.CONVERSION);
                return;
            }
            return;
        }
        this.AFInAppEventParameterName.add(AFe1bSDK.CONVERSION);
    }

    @Override
    protected final AFe1xSDK<String> valueOf(String str) throws Throwable {
        double d;
        String string;
        String strReplaceAll;
        String str2;
        AFInAppEventType(this.registerClient);
        if (this.registerClient.AFInAppEventType().containsKey("meta")) {
            try {
                d = this.f363v.valueOf.AFInAppEventType.AFInAppEventType.values.AFInAppEventType;
            } catch (NullPointerException unused) {
                d = 1.0d;
            }
            if (AFa1pSDK.values(d)) {
                this.registerClient.AFInAppEventType().remove("meta");
            }
        }
        String str3 = this.registerClient.unregisterClient;
        Map<String, Object> mapAFInAppEventType = this.registerClient.AFInAppEventType();
        String str4 = null;
        try {
            string = new JSONObject(mapAFInAppEventType).toString();
            try {
                if (string != null) {
                    strReplaceAll = string.replaceAll("\\p{C}", "*Non-printing character*");
                    str2 = string != null ? string : "";
                    if (strReplaceAll.equals(str2)) {
                        strReplaceAll = str2;
                    } else {
                        AFLogger.afWarnLog("Payload contains non-printing characters");
                    }
                    StringBuilder sb = new StringBuilder();
                    sb.append(this);
                    sb.append(": preparing data: ");
                    sb.append(strReplaceAll);
                    AFb1bSDK.valueOf(sb.toString());
                    ((AFf1tSDK) this).f366d.AFKeystoreWrapper(str3, strReplaceAll);
                    return ((AFf1tSDK) this).f367e.valueOf(this.registerClient, str, this.afWarnLog);
                }
                throw new NullPointerException("JSON toString of eventParams map returns null");
            } catch (NullPointerException e) {
                e = e;
                AFLogger.afErrorLog("JSONObject return null String object. Trying to create AFJsonObject.", e, true);
                try {
                    Object[] objArr = {mapAFInAppEventType};
                    Object method = AFa1zSDK.afDebugLog.get(1054062260);
                    if (method == null) {
                        method = ((Class) AFa1zSDK.valueOf(73 - ExpandableListView.getPackedPositionGroup(0L), (char) (41260 - (ViewConfiguration.getWindowTouchSlop() >> 8)), Drawable.resolveOpacity(0, 0) + 36)).getMethod("valueOf", Map.class);
                        AFa1zSDK.afDebugLog.put(1054062260, method);
                    }
                    String str5 = (String) ((Method) method).invoke(null, objArr);
                    try {
                        if (str5 != null) {
                            strReplaceAll = str5.replaceAll("\\p{C}", "*Non-printing character*");
                            string = str5;
                        } else {
                            throw new NullPointerException("JSON toString of eventParams map returns null");
                        }
                    } catch (NullPointerException e2) {
                        e = e2;
                        string = str5;
                        AFLogger.afErrorLog("AFJsonObject return null String object.", e, true);
                        strReplaceAll = "";
                    } catch (Exception e3) {
                        e = e3;
                        string = str5;
                        AFLogger.afErrorLogForExcManagerOnly("AFFinalizer: reflection init failed", e);
                        strReplaceAll = "";
                    } catch (Throwable th) {
                        th = th;
                        string = str5;
                        AFLogger.afErrorLog("Unexpected error", th, true);
                        strReplaceAll = "";
                    }
                } catch (Throwable th2) {
                    try {
                        Throwable cause = th2.getCause();
                        if (cause != null) {
                            throw cause;
                        }
                        throw th2;
                    } catch (NullPointerException e4) {
                        e = e4;
                        AFLogger.afErrorLog("AFJsonObject return null String object.", e, true);
                        strReplaceAll = "";
                        if (string != null) {
                        }
                        if (strReplaceAll.equals(str2)) {
                            AFLogger.afWarnLog("Payload contains non-printing characters");
                        } else {
                            strReplaceAll = str2;
                        }
                        StringBuilder sb2 = new StringBuilder();
                        sb2.append(this);
                        sb2.append(": preparing data: ");
                        sb2.append(strReplaceAll);
                        AFb1bSDK.valueOf(sb2.toString());
                        ((AFf1tSDK) this).f366d.AFKeystoreWrapper(str3, strReplaceAll);
                        return ((AFf1tSDK) this).f367e.valueOf(this.registerClient, str, this.afWarnLog);
                    } catch (Exception e5) {
                        e = e5;
                        AFLogger.afErrorLogForExcManagerOnly("AFFinalizer: reflection init failed", e);
                        strReplaceAll = "";
                        if (string != null) {
                        }
                        if (strReplaceAll.equals(str2)) {
                            AFLogger.afWarnLog("Payload contains non-printing characters");
                        } else {
                            strReplaceAll = str2;
                        }
                        StringBuilder sb3 = new StringBuilder();
                        sb3.append(this);
                        sb3.append(": preparing data: ");
                        sb3.append(strReplaceAll);
                        AFb1bSDK.valueOf(sb3.toString());
                        ((AFf1tSDK) this).f366d.AFKeystoreWrapper(str3, strReplaceAll);
                        return ((AFf1tSDK) this).f367e.valueOf(this.registerClient, str, this.afWarnLog);
                    } catch (Throwable th3) {
                        th = th3;
                        AFLogger.afErrorLog("Unexpected error", th, true);
                        strReplaceAll = "";
                        if (string != null) {
                        }
                        if (strReplaceAll.equals(str2)) {
                            AFLogger.afWarnLog("Payload contains non-printing characters");
                        } else {
                            strReplaceAll = str2;
                        }
                        StringBuilder sb4 = new StringBuilder();
                        sb4.append(this);
                        sb4.append(": preparing data: ");
                        sb4.append(strReplaceAll);
                        AFb1bSDK.valueOf(sb4.toString());
                        ((AFf1tSDK) this).f366d.AFKeystoreWrapper(str3, strReplaceAll);
                        return ((AFf1tSDK) this).f367e.valueOf(this.registerClient, str, this.afWarnLog);
                    }
                }
            } catch (Throwable th4) {
                th = th4;
                str4 = string;
                AFLogger.afErrorLog("Unexpected error", th, true);
                strReplaceAll = "";
                string = str4;
            }
        } catch (NullPointerException e6) {
            e = e6;
            string = null;
        } catch (Throwable th5) {
            th = th5;
        }
    }

    @Override
    protected final AppsFlyerRequestListener registerClient() {
        return this.registerClient.valueOf;
    }

    protected void AFInAppEventParameterName(AFa1pSDK aFa1pSDK) {
        this.f362i.AFInAppEventType(aFa1pSDK.AFInAppEventType());
    }

    protected void values(AFa1pSDK aFa1pSDK) {
        this.f362i.values(aFa1pSDK);
    }

    private static Map<String, Object> AFKeystoreWrapper(AFa1pSDK aFa1pSDK) {
        Map<String, Object> map = (Map) aFa1pSDK.AFInAppEventType().get("meta");
        if (map != null) {
            return map;
        }
        HashMap map2 = new HashMap();
        aFa1pSDK.AFInAppEventType().put("meta", map2);
        return map2;
    }

    protected void AFInAppEventType(AFa1pSDK aFa1pSDK) throws Throwable {
        AFe1iSDK aFe1iSDK;
        boolean z = true;
        try {
            AFInAppEventParameterName(aFa1pSDK);
            values(aFa1pSDK);
        } catch (Throwable th) {
            AFLogger.afErrorLog("Error while collecting payload params", th, true, false);
        }
        if (aFa1pSDK.mo765e()) {
            aFa1pSDK.AFInAppEventType(new AFd1qSDK(aFa1pSDK.AFInAppEventType(), ((AFf1tSDK) this).unregisterClient.AFKeystoreWrapper.AFInAppEventParameterName));
            aFa1pSDK.AFInAppEventType((Map<String, ?>) ((AFf1tSDK) this).unregisterClient.values(aFa1pSDK.AFInAppEventType()));
            if (this.afInfoLog.AFKeystoreWrapper("com.appsflyer.security.enable")) {
                AFg1zSDK aFg1zSDK = ((AFf1tSDK) this).unregisterClient;
                try {
                    new AFb1sSDK(aFa1pSDK).afInfoLog();
                } catch (Exception e) {
                    AFLogger.afErrorLogForExcManagerOnly("native: reflection init failed", e);
                }
            }
        }
        if (aFa1pSDK.AFLogger()) {
            aFa1pSDK.AFInAppEventType((Map<String, ?>) ((AFf1tSDK) this).unregisterClient.values());
        }
        Set<AFe1bSDK> set = this.valueOf;
        if (!set.contains(AFe1bSDK.LAUNCH) && !set.contains(AFe1bSDK.CONVERSION)) {
            z = false;
        }
        if (AFLogger() && z) {
            aFa1pSDK.AFInAppEventType(this.f364w.valueOf("appsFlyerCount", 0));
        }
        if (aFa1pSDK.registerClient()) {
            Map<String, Object> mapAFKeystoreWrapper = AFKeystoreWrapper(aFa1pSDK);
            AFe1jSDK aFe1jSDK = this.force;
            String strValueOf = aFe1jSDK.valueOf();
            String strAFInAppEventType = aFe1jSDK.AFInAppEventType();
            if (AFe1jSDK.values()) {
                aFe1iSDK = AFe1iSDK.DEFAULT;
            } else {
                aFe1iSDK = AFe1iSDK.API;
            }
            AFe1hSDK aFe1hSDK = new AFe1hSDK(strValueOf, strAFInAppEventType, aFe1iSDK);
            JSONObject jSONObject = new JSONObject();
            jSONObject.put("name", aFe1hSDK.AFInAppEventType);
            if (aFe1hSDK.values != AFe1iSDK.DEFAULT) {
                jSONObject.put("method", aFe1hSDK.values.AFInAppEventParameterName);
            }
            String str = aFe1hSDK.valueOf;
            if (str != null && !StringsKt.isBlank(str)) {
                jSONObject.put("prefix", aFe1hSDK.valueOf);
            }
            mapAFKeystoreWrapper.put("host", jSONObject);
        }
        if (this.afInfoLog.AFKeystoreWrapper("AF_PREINSTALL_DISABLED")) {
            AFKeystoreWrapper(aFa1pSDK).put("preinstall_disabled", Boolean.TRUE);
        }
        this.afDebugLog.AFKeystoreWrapper(aFa1pSDK.AFInAppEventType(), aFa1pSDK.AFInAppEventParameterName());
    }
}
