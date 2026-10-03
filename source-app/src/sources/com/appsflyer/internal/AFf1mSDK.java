package com.appsflyer.internal;

import android.graphics.Color;
import android.graphics.PointF;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Process;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewConfiguration;
import com.appsflyer.AFLogger;
import com.appsflyer.attribution.AppsFlyerRequestListener;
import com.appsflyer.internal.components.network.http.exceptions.ParsingException;
import java.lang.reflect.Constructor;
import java.lang.reflect.Method;
import java.util.Map;
import java.util.UUID;

public final class AFf1mSDK extends AFf1tSDK<Map<String, String>> {
    private final UUID afDebugLog;
    private final boolean afInfoLog;
    private final AFe1zSDK force;

    private String f356i;
    public AFa1vSDK registerClient;

    private String f357v;

    private String f358w;

    public interface AFa1vSDK {
        void AFInAppEventType(String str);

        void AFInAppEventType(Map<String, String> map);
    }

    @Override
    public final long AFKeystoreWrapper() {
        return 3000L;
    }

    @Override
    protected final boolean force() {
        return false;
    }

    @Override
    protected final AppsFlyerRequestListener registerClient() {
        return null;
    }

    @Override
    protected final boolean unregisterClient() {
        return false;
    }

    @Override
    public final boolean values() {
        return false;
    }

    public AFf1mSDK(AFd1nSDK aFd1nSDK, UUID uuid, Uri uri) throws Throwable {
        super(AFe1bSDK.ONELINK, new AFe1bSDK[]{AFe1bSDK.RC_CDN}, aFd1nSDK, uuid.toString());
        boolean zBooleanValue = false;
        this.force = aFd1nSDK.AFInAppEventParameterName();
        this.afDebugLog = uuid;
        try {
            if (!AFc1rSDK.AFInAppEventType(uri.getHost()) && !AFc1rSDK.AFInAppEventType(uri.getPath())) {
                try {
                    Object[] objArr = {uri, aFd1nSDK.afErrorLog()};
                    Object declaredConstructor = AFc1fSDK.afRDLog.get(-278328535);
                    if (declaredConstructor == null) {
                        declaredConstructor = ((Class) AFc1fSDK.AFInAppEventType((PointF.length(0.0f, 0.0f) > 0.0f ? 1 : (PointF.length(0.0f, 0.0f) == 0.0f ? 0 : -1)) + 36, (char) (ViewConfiguration.getScrollBarFadeDuration() >> 16), Process.myPid() >> 22)).getDeclaredConstructor(Uri.class, AFc1jSDK.class);
                        AFc1fSDK.afRDLog.put(-278328535, declaredConstructor);
                    }
                    Object objNewInstance = ((Constructor) declaredConstructor).newInstance(objArr);
                    try {
                        Object method = AFc1fSDK.afRDLog.get(-2031775847);
                        if (method == null) {
                            method = ((Class) AFc1fSDK.AFInAppEventType(TextUtils.indexOf("", "") + 36, (char) Drawable.resolveOpacity(0, 0), ViewConfiguration.getKeyRepeatDelay() >> 16)).getMethod("values", null);
                            AFc1fSDK.afRDLog.put(-2031775847, method);
                        }
                        Object objInvoke = ((Method) method).invoke(objNewInstance, null);
                        try {
                            Object method2 = AFc1fSDK.afRDLog.get(-1297618031);
                            if (method2 == null) {
                                method2 = ((Class) AFc1fSDK.AFInAppEventType(51 - Color.alpha(0), (char) (47541 - (ViewConfiguration.getZoomControlsTimeout() > 0L ? 1 : (ViewConfiguration.getZoomControlsTimeout() == 0L ? 0 : -1))), 36 - TextUtils.getOffsetAfter("", 0))).getMethod("AFInAppEventType", null);
                                AFc1fSDK.afRDLog.put(-1297618031, method2);
                            }
                            boolean zBooleanValue2 = ((Boolean) ((Method) method2).invoke(objInvoke, null)).booleanValue();
                            try {
                                Object method3 = AFc1fSDK.afRDLog.get(-1441535903);
                                if (method3 == null) {
                                    method3 = ((Class) AFc1fSDK.AFInAppEventType(TextUtils.getTrimmedLength("") + 51, (char) (47540 - View.MeasureSpec.getSize(0)), 36 - (KeyEvent.getMaxKeyCode() >> 16))).getMethod("AFInAppEventParameterName", null);
                                    AFc1fSDK.afRDLog.put(-1441535903, method3);
                                }
                                zBooleanValue = ((Boolean) ((Method) method3).invoke(objInvoke, null)).booleanValue();
                                String[] strArrSplit = uri.getPath().split("/");
                                if (zBooleanValue2 && strArrSplit.length == 3) {
                                    this.f357v = strArrSplit[1];
                                    this.f358w = strArrSplit[2];
                                    this.f356i = uri.toString();
                                }
                            } catch (Throwable th) {
                                Throwable cause = th.getCause();
                                if (cause == null) {
                                    throw th;
                                }
                                throw cause;
                            }
                        } catch (Throwable th2) {
                            Throwable cause2 = th2.getCause();
                            if (cause2 == null) {
                                throw th2;
                            }
                            throw cause2;
                        }
                    } catch (Throwable th3) {
                        Throwable cause3 = th3.getCause();
                        if (cause3 == null) {
                            throw th3;
                        }
                        throw cause3;
                    }
                } catch (Throwable th4) {
                    Throwable cause4 = th4.getCause();
                    if (cause4 == null) {
                        throw th4;
                    }
                    throw cause4;
                }
            }
        } catch (Exception e) {
            AFLogger.afErrorLogForExcManagerOnly("OneLinkValidator: reflection init failed", e);
        }
        this.afInfoLog = zBooleanValue;
    }

    public final boolean m795w() {
        return (TextUtils.isEmpty(this.f357v) || TextUtils.isEmpty(this.f358w) || this.f357v.equals("app")) ? false : true;
    }

    public final boolean afInfoLog() {
        return this.afInfoLog;
    }

    @Override
    public final void valueOf() {
        super.valueOf();
        AFa1vSDK aFa1vSDK = this.registerClient;
        if (aFa1vSDK != null) {
            if (this.AFKeystoreWrapper == AFe1cSDK.SUCCESS && this.AFLogger != null) {
                aFa1vSDK.AFInAppEventType((Map<String, String>) this.AFLogger.getBody());
                return;
            }
            Throwable thM790d = m790d();
            if (thM790d instanceof ParsingException) {
                if (((ParsingException) thM790d).getRawResponse().isSuccessful()) {
                    aFa1vSDK.AFInAppEventType("Can't parse one link data");
                    return;
                } else {
                    String str = this.f356i;
                    aFa1vSDK.AFInAppEventType(str != null ? str : "Can't get OneLink data");
                    return;
                }
            }
            String str2 = this.f356i;
            aFa1vSDK.AFInAppEventType(str2 != null ? str2 : "Can't get OneLink data");
        }
    }

    @Override
    protected final AFe1xSDK<Map<String, String>> valueOf(String str) {
        return this.force.values(this.f357v, this.f358w, this.afDebugLog, str);
    }
}
