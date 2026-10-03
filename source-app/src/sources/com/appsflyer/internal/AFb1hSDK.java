package com.appsflyer.internal;

import android.content.pm.PackageManager;
import android.graphics.ImageFormat;
import android.os.Build;
import android.view.View;
import android.view.ViewConfiguration;
import android.widget.ExpandableListView;
import androidx.constraintlayout.core.motion.utils.TypedValues;
import com.appsflyer.AFLogger;
import com.appsflyer.AppsFlyerProperties;
import com.facebook.devicerequests.internal.DeviceRequestsHelper;
import j$.util.Objects;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.ExecutorService;
import org.json.JSONObject;

public final class AFb1hSDK implements AFb1cSDK {
    private static int $10 = 0;
    private static int $11 = 1;
    private static final int AFInAppEventParameterName;
    private static byte[] afInfoLog = null;

    private static int f303d = 0;

    private static int f304e = 0;
    private static short[] force = null;

    private static int f305i = 0;

    private static int f306v = 0;

    private static int f307w = 1;
    private final AFd1nSDK registerClient;
    private List<String> AFInAppEventType = new ArrayList();
    private boolean valueOf = true;
    private final Map<String, Object> AFKeystoreWrapper = new HashMap();
    private boolean unregisterClient = true ^ AppsFlyerProperties.getInstance().getBoolean(AppsFlyerProperties.DPM, false);
    private int values = 0;
    private boolean AFLogger = false;

    static void AFLogger() {
        f304e = -1485430999;
        f303d = 1099409260;
        f306v = 1492877720;
        afInfoLog = new byte[]{114, -99, 123, -104, 14};
    }

    static {
        AFLogger();
        AFInAppEventParameterName = 98166;
        int i = f307w + 95;
        f305i = i % 128;
        if (i % 2 != 0) {
            int i2 = 42 / 0;
        }
    }

    public AFb1hSDK(AFd1nSDK aFd1nSDK) {
        this.registerClient = aFd1nSDK;
    }

    @Override
    public final boolean AFInAppEventType() {
        int i = 2 % 2;
        int i2 = f305i + 109;
        f307w = i2 % 128;
        int i3 = i2 % 2;
        boolean zAFInAppEventType = AFInAppEventType(valueOf(this.registerClient.mo784e().valueOf.AFInAppEventType), valueOf(this.registerClient.mo784e().valueOf.AFInAppEventParameterName));
        if (!zAFInAppEventType) {
            AFKeystoreWrapper();
            valueOf();
        } else {
            int i4 = f305i + 49;
            f307w = i4 % 128;
            int i5 = i4 % 2;
            m768d();
        }
        return zAFInAppEventType;
    }

    private synchronized void m768d() {
        int i = 2 % 2;
        int i2 = f307w;
        int i3 = i2 + 29;
        f305i = i3 % 128;
        int i4 = i3 % 2;
        if (!this.AFLogger) {
            this.AFLogger = true;
            AFKeystoreWrapper("r_debugging_on", new SimpleDateFormat("yyyy-MM-dd HH:mm:ssZ", Locale.ENGLISH).format(Long.valueOf(System.currentTimeMillis())), new String[0]);
        } else {
            int i5 = i2 + 125;
            f305i = i5 % 128;
            if (i5 % 2 == 0) {
            } else {
                throw null;
            }
        }
    }

    @Override
    public final synchronized void valueOf() {
        int i = 2 % 2;
        int i2 = f307w + 109;
        int i3 = i2 % 128;
        f305i = i3;
        int i4 = i2 % 2;
        if (this.AFLogger || this.valueOf) {
            AFKeystoreWrapper("r_debugging_off", new SimpleDateFormat("yyyy-MM-dd HH:mm:ssZ", Locale.ENGLISH).format(Long.valueOf(System.currentTimeMillis())), new String[0]);
            this.AFLogger = false;
            this.valueOf = false;
            int i5 = f307w + 63;
            f305i = i5 % 128;
            int i6 = i5 % 2;
            return;
        }
        int i7 = i3 + TypedValues.TYPE_TARGET;
        f307w = i7 % 128;
        if (i7 % 2 == 0) {
            int i8 = 75 / 0;
        }
    }

    @Override
    public final synchronized void values() {
        int i = 2 % 2;
        int i2 = f305i + 57;
        f307w = i2 % 128;
        int i3 = i2 % 2;
        this.AFKeystoreWrapper.clear();
        this.AFInAppEventType.clear();
        this.values = 0;
        int i4 = f307w + 95;
        f305i = i4 % 128;
        if (i4 % 2 != 0) {
            int i5 = 69 / 0;
        }
    }

    @Override
    public final void AFKeystoreWrapper(String str, PackageManager packageManager) {
        int i = 2 % 2;
        int i2 = f305i + 33;
        f307w = i2 % 128;
        int i3 = i2 % 2;
        try {
            final AFe1ySDK aFe1ySDKAFKeystoreWrapper = this.registerClient.AFInAppEventParameterName().AFKeystoreWrapper(AFInAppEventParameterName(str, packageManager), this.registerClient.mo785i().registerClient);
            if (aFe1ySDKAFKeystoreWrapper == null) {
                AFLogger.afErrorLogForExcManagerOnly("could not send null proxy data", new NullPointerException("request was null"));
                return;
            }
            ExecutorService executorServiceValues = this.registerClient.values();
            Objects.requireNonNull(aFe1ySDKAFKeystoreWrapper);
            executorServiceValues.execute(new Runnable() {
                @Override
                public final void run() {
                    aFe1ySDKAFKeystoreWrapper.AFInAppEventParameterName();
                }
            });
            int i4 = f305i + 13;
            f307w = i4 % 128;
            if (i4 % 2 == 0) {
                int i5 = 61 / 0;
            }
        } catch (Throwable th) {
            AFLogger.afErrorLogForExcManagerOnly("could not send proxy data", th);
        }
    }

    @Override
    public final void AFKeystoreWrapper(String str, String... strArr) {
        int i = 2 % 2;
        int i2 = f305i + 25;
        f307w = i2 % 128;
        int i3 = i2 % 2;
        AFKeystoreWrapper("public_api_call", str, strArr);
        if (i3 != 0) {
            return;
        }
        Object obj = null;
        obj.hashCode();
        throw null;
    }

    @Override
    public final void AFInAppEventParameterName(Throwable th) {
        Throwable cause;
        String simpleName;
        String message;
        StackTraceElement[] stackTrace;
        int i = 2 % 2;
        int i2 = f307w + 11;
        f305i = i2 % 128;
        if (i2 % 2 != 0) {
            cause = th.getCause();
            simpleName = th.getClass().getSimpleName();
            int i3 = 79 / 0;
            if (cause == null) {
                int i4 = f305i + 11;
                f307w = i4 % 128;
                int i5 = i4 % 2;
                message = th.getMessage();
            } else {
                message = cause.getMessage();
            }
        } else {
            cause = th.getCause();
            simpleName = th.getClass().getSimpleName();
            if (cause == null) {
                int i6 = f305i + 11;
                f307w = i6 % 128;
                int i7 = i6 % 2;
                message = th.getMessage();
            } else {
                message = cause.getMessage();
            }
        }
        if (cause == null) {
            int i8 = f305i + 115;
            f307w = i8 % 128;
            if (i8 % 2 == 0) {
                stackTrace = th.getStackTrace();
                int i9 = 63 / 0;
            } else {
                stackTrace = th.getStackTrace();
            }
        } else {
            stackTrace = cause.getStackTrace();
            int i10 = f305i + 93;
            f307w = i10 % 128;
            int i11 = i10 % 2;
        }
        AFKeystoreWrapper("exception", simpleName, AFInAppEventParameterName(message, stackTrace));
    }

    @Override
    public final void AFKeystoreWrapper(String str, String str2) {
        int i = 2 % 2;
        int i2 = f307w + 113;
        f305i = i2 % 128;
        if (i2 % 2 == 0) {
            AFKeystoreWrapper("server_request", str, str2);
            return;
        }
        String[] strArr = new String[0];
        strArr[0] = str2;
        AFKeystoreWrapper("server_request", str, strArr);
    }

    @Override
    public final void AFInAppEventParameterName(String str, int i, String str2) {
        int i2 = 2 % 2;
        int i3 = f307w + 123;
        f305i = i3 % 128;
        if (i3 % 2 == 0) {
            AFKeystoreWrapper("server_response", str, String.valueOf(i), str2);
            return;
        }
        String[] strArr = new String[4];
        strArr[1] = String.valueOf(i);
        strArr[1] = str2;
        AFKeystoreWrapper("server_response", str, strArr);
    }

    @Override
    public final void valueOf(String str, String str2) {
        int i = 2 % 2;
        int i2 = f305i + TypedValues.TYPE_TARGET;
        f307w = i2 % 128;
        Object obj = null;
        if (i2 % 2 == 0) {
            String[] strArr = new String[0];
            strArr[0] = str2;
            AFKeystoreWrapper(null, str, strArr);
        } else {
            AFKeystoreWrapper(null, str, str2);
        }
        int i3 = f305i + 117;
        f307w = i3 % 128;
        if (i3 % 2 != 0) {
            return;
        }
        obj.hashCode();
        throw null;
    }

    @Override
    public final synchronized void AFKeystoreWrapper() {
        int i = 2 % 2;
        int i2 = f307w + 25;
        f305i = i2 % 128;
        if (i2 % 2 != 0) {
            this.valueOf = true;
            values();
        } else {
            this.valueOf = false;
            values();
        }
        m769i();
    }

    @Override
    public final void AFInAppEventParameterName() {
        int i = 2 % 2;
        int i2 = f305i;
        int i3 = i2 + 109;
        f307w = i3 % 128;
        int i4 = i3 % 2;
        this.unregisterClient = false;
        int i5 = i2 + 87;
        f307w = i5 % 128;
        if (i5 % 2 == 0) {
            throw null;
        }
    }

    @Override
    public final boolean mo766e() {
        int i = 2 % 2;
        int i2 = f307w;
        int i3 = i2 + 109;
        f305i = i3 % 128;
        Object obj = null;
        if (i3 % 2 != 0) {
            obj.hashCode();
            throw null;
        }
        boolean z = this.AFLogger;
        int i4 = i2 + 59;
        f305i = i4 % 128;
        if (i4 % 2 == 0) {
            return z;
        }
        obj.hashCode();
        throw null;
    }

    private static float registerClient() {
        int i = 2 % 2;
        float fNextFloat = new Random().nextFloat();
        int i2 = f305i + 93;
        f307w = i2 % 128;
        if (i2 % 2 != 0) {
            return fNextFloat;
        }
        Object obj = null;
        obj.hashCode();
        throw null;
    }

    private Map<String, Object> AFInAppEventParameterName(String str, PackageManager packageManager) {
        int i = 2 % 2;
        int i2 = f307w + 9;
        f305i = i2 % 128;
        int i3 = i2 % 2;
        values(str, packageManager, this.registerClient.mo785i(), this.registerClient.getLevel());
        Map<String, Object> mapM770v = m770v();
        int i4 = f307w + 125;
        f305i = i4 % 128;
        if (i4 % 2 == 0) {
            return mapM770v;
        }
        throw null;
    }

    private static String unregisterClient() {
        int i = 2 % 2;
        int i2 = f305i + 41;
        int i3 = i2 % 128;
        f307w = i3;
        int i4 = i2 % 2;
        int i5 = i3 + 41;
        f305i = i5 % 128;
        int i6 = i5 % 2;
        return "6.13.0";
    }

    private boolean force() {
        int i = 2 % 2;
        int i2 = f305i + 41;
        int i3 = i2 % 128;
        f307w = i3;
        if (i2 % 2 == 0) {
            int i4 = 16 / 0;
            if (this.unregisterClient) {
                int i5 = i3 + 27;
                int i6 = i5 % 128;
                f305i = i6;
                int i7 = i5 % 2;
                if (!this.valueOf || this.AFLogger) {
                    int i8 = i6 + 9;
                    f307w = i8 % 128;
                    int i9 = i8 % 2;
                    return true;
                }
            }
        } else if (this.unregisterClient) {
            int i10 = i3 + 27;
            int i11 = i10 % 128;
            f305i = i11;
            int i12 = i10 % 2;
            if (!this.valueOf) {
            }
            int i13 = i11 + 9;
            f307w = i13 % 128;
            int i14 = i13 % 2;
            return true;
        }
        return false;
    }

    private synchronized void valueOf(String str, String str2, String str3) {
        int i = 2 % 2;
        try {
            Map<String, Object> map = this.AFKeystoreWrapper;
            Object[] objArr = new Object[1];
            m767a((short) (122 - (ViewConfiguration.getWindowTouchSlop() >> 8)), ImageFormat.getBitsPerPixel(0) - 427566643, (byte) (1 - (ViewConfiguration.getScrollFriction() > 0.0f ? 1 : (ViewConfiguration.getScrollFriction() == 0.0f ? 0 : -1))), (ExpandableListView.getPackedPositionForGroup(0) > 0L ? 1 : (ExpandableListView.getPackedPositionForGroup(0) == 0L ? 0 : -1)) - 93, 420366297 - View.resolveSizeAndState(0, 0, 0), objArr);
            map.put(((String) objArr[0]).intern(), Build.BRAND);
            this.AFKeystoreWrapper.put(DeviceRequestsHelper.DEVICE_INFO_MODEL, Build.MODEL);
            this.AFKeystoreWrapper.put("platform", "Android");
            this.AFKeystoreWrapper.put("platform_version", Build.VERSION.RELEASE);
            if (str != null && str.length() > 0) {
                this.AFKeystoreWrapper.put("advertiserId", str);
                int i2 = f307w + 69;
                f305i = i2 % 128;
                if (i2 % 2 == 0) {
                    int i3 = 2 % 2;
                }
            }
            if (str2 != null && str2.length() > 0) {
                this.AFKeystoreWrapper.put("imei", str2);
                int i4 = f307w + 115;
                f305i = i4 % 128;
                if (i4 % 2 == 0) {
                    int i5 = 2 % 2;
                }
            }
            if (str3 != null) {
                int i6 = f305i + 57;
                f307w = i6 % 128;
                int i7 = i6 % 2;
                if (str3.length() > 0) {
                    int i8 = f305i + 11;
                    f307w = i8 % 128;
                    if (i8 % 2 == 0) {
                        this.AFKeystoreWrapper.put("android_id", str3);
                        throw null;
                    }
                    this.AFKeystoreWrapper.put("android_id", str3);
                }
            }
        } catch (Throwable unused) {
        }
    }

    private synchronized void AFInAppEventType(String str, String str2, String str3, String str4) {
        int i = 2 % 2;
        int i2 = f307w + 111;
        f305i = i2 % 128;
        Object obj = null;
        try {
            if (i2 % 2 != 0) {
                this.AFKeystoreWrapper.put("sdk_version", str);
                obj.hashCode();
                throw null;
            }
            this.AFKeystoreWrapper.put("sdk_version", str);
            if (str2 != null && str2.length() > 0) {
                this.AFKeystoreWrapper.put("devkey", str2);
            }
            if (str3 != null && str3.length() > 0) {
                this.AFKeystoreWrapper.put("originalAppsFlyerId", str3);
            }
            if (str4 != null) {
                int i3 = f307w + 27;
                f305i = i3 % 128;
                int i4 = i3 % 2;
                if (str4.length() > 0) {
                    this.AFKeystoreWrapper.put("uid", str4);
                    int i5 = 2 % 2;
                }
            }
            int i6 = f307w + 99;
            f305i = i6 % 128;
            if (i6 % 2 != 0) {
                throw null;
            }
        } catch (Throwable unused) {
        }
    }

    private synchronized void valueOf(String str, String str2, String str3, String str4) {
        int i = 2 % 2;
        int i2 = f307w + TypedValues.TYPE_TARGET;
        f305i = i2 % 128;
        int i3 = i2 % 2;
        if (str != null) {
            try {
                if (str.length() > 0) {
                    int i4 = f305i + 75;
                    f307w = i4 % 128;
                    int i5 = i4 % 2;
                    this.AFKeystoreWrapper.put("app_id", str);
                    int i6 = 2 % 2;
                }
            } catch (Throwable unused) {
                return;
            }
        }
        if (str2 != null) {
            int i7 = f307w + 49;
            f305i = i7 % 128;
            int i8 = i7 % 2;
            if (str2.length() > 0) {
                int i9 = f307w + 125;
                f305i = i9 % 128;
                if (i9 % 2 != 0) {
                    this.AFKeystoreWrapper.put("app_version", str2);
                    Object obj = null;
                    obj.hashCode();
                    throw null;
                }
                this.AFKeystoreWrapper.put("app_version", str2);
            }
        }
        if (str3 != null && str3.length() > 0) {
            int i10 = f307w + 107;
            f305i = i10 % 128;
            int i11 = i10 % 2;
            this.AFKeystoreWrapper.put(AppsFlyerProperties.CHANNEL, str3);
        }
        if (str4 != null && str4.length() > 0) {
            this.AFKeystoreWrapper.put("preInstall", str4);
        }
    }

    private synchronized void AFKeystoreWrapper(java.lang.String r6, java.lang.String r7, java.lang.String... r8) {
        throw new UnsupportedOperationException("Method not decompiled: com.appsflyer.internal.AFb1hSDK.AFKeystoreWrapper(java.lang.String, java.lang.String, java.lang.String[]):void");
    }

    private synchronized Map<String, Object> m770v() {
        Map<String, Object> map;
        int i = 2 % 2;
        int i2 = f307w + 119;
        f305i = i2 % 128;
        int i3 = i2 % 2;
        this.AFKeystoreWrapper.put("data", this.AFInAppEventType);
        m769i();
        map = this.AFKeystoreWrapper;
        int i4 = f305i + 33;
        f307w = i4 % 128;
        if (i4 % 2 == 0) {
            Object obj = null;
            obj.hashCode();
            throw null;
        }
        return map;
    }

    private synchronized void values(String str, PackageManager packageManager, AFg1zSDK aFg1zSDK, AFd1sSDK aFd1sSDK) {
        int i = 2 % 2;
        int i2 = f307w + 97;
        f305i = i2 % 128;
        int i3 = i2 % 2;
        AppsFlyerProperties appsFlyerProperties = AppsFlyerProperties.getInstance();
        String string = appsFlyerProperties.getString("remote_debug_static_data");
        this.AFKeystoreWrapper.clear();
        if (string != null) {
            try {
                this.AFKeystoreWrapper.putAll(AFa1oSDK.AFInAppEventType(new JSONObject(string)));
            } catch (Throwable unused) {
            }
        } else {
            AFb1vSDK aFb1vSDKValueOf = AFb1vSDK.valueOf();
            valueOf(appsFlyerProperties.getString("advertiserId"), aFg1zSDK.unregisterClient, aFd1sSDK.valueOf);
            StringBuilder sb = new StringBuilder("6.13.0.");
            sb.append(AFb1vSDK.AFInAppEventType);
            AFInAppEventType(sb.toString(), aFb1vSDKValueOf.AFInAppEventType().mo785i().registerClient, appsFlyerProperties.getString("KSAppsFlyerId"), appsFlyerProperties.getString("uid"));
            try {
                int i4 = packageManager.getPackageInfo(str, 0).versionCode;
                valueOf(str, String.valueOf(i4), appsFlyerProperties.getString(AppsFlyerProperties.CHANNEL), appsFlyerProperties.getString("preInstallName"));
                int i5 = f307w + 99;
                f305i = i5 % 128;
                int i6 = i5 % 2;
                int i7 = 2 % 2;
            } catch (Throwable unused2) {
            }
            appsFlyerProperties.set("remote_debug_static_data", new JSONObject(this.AFKeystoreWrapper).toString());
        }
        this.AFKeystoreWrapper.put("launch_counter", String.valueOf(this.registerClient.AFInAppEventType().AFInAppEventParameterName.valueOf("appsFlyerCount", 0)));
    }

    private static String[] AFInAppEventParameterName(String str, StackTraceElement[] stackTraceElementArr) {
        int i = 2 % 2;
        int i2 = f305i + 125;
        f307w = i2 % 128;
        int i3 = i2 % 2;
        if (stackTraceElementArr == null) {
            return new String[]{str};
        }
        String[] strArr = new String[stackTraceElementArr.length + 1];
        strArr[0] = str;
        for (int i4 = 1; i4 < stackTraceElementArr.length; i4++) {
            strArr[i4] = stackTraceElementArr[i4].toString();
        }
        int i5 = f305i + 115;
        f307w = i5 % 128;
        if (i5 % 2 != 0) {
            return strArr;
        }
        Object obj = null;
        obj.hashCode();
        throw null;
    }

    private synchronized void m769i() {
        int i = 2 % 2;
        this.AFInAppEventType = new ArrayList();
        this.values = 0;
        int i2 = f307w + 9;
        f305i = i2 % 128;
        if (i2 % 2 != 0) {
            int i3 = 8 / 0;
        }
    }

    private synchronized boolean AFInAppEventType(AFh1jSDK aFh1jSDK, AFh1jSDK aFh1jSDK2) {
        int i = 2 % 2;
        if (aFh1jSDK == null) {
            int i2 = f305i + 117;
            f307w = i2 % 128;
            if (i2 % 2 == 0) {
                m771w();
                return false;
            }
            m771w();
            return false;
        }
        if (!aFh1jSDK.AFInAppEventParameterName()) {
            int i3 = f305i + 81;
            f307w = i3 % 128;
            if (i3 % 2 != 0) {
                return false;
            }
            Object obj = null;
            obj.hashCode();
            throw null;
        }
        if (this.registerClient.AFInAppEventType().AFInAppEventParameterName.valueOf("appsFlyerCount", 0) > aFh1jSDK.values) {
            return false;
        }
        int i4 = f305i + 23;
        f307w = i4 % 128;
        int i5 = i4 % 2;
        int i6 = 2 % 2;
        if (!AFKeystoreWrapper(aFh1jSDK, aFh1jSDK2)) {
            int i7 = f305i + 15;
            f307w = i7 % 128;
            return i7 % 2 == 0 ? false : false;
        }
        if (!values(aFh1jSDK.AFInAppEventParameterName)) {
            return false;
        }
        if (AFKeystoreWrapper(aFh1jSDK.AFInAppEventType)) {
            return true;
        }
        int i8 = f307w + 105;
        f305i = i8 % 128;
        return i8 % 2 != 0 ? false : false;
    }

    private boolean AFKeystoreWrapper(AFh1jSDK aFh1jSDK, AFh1jSDK aFh1jSDK2) {
        boolean zAFInAppEventType;
        int i;
        int i2 = 2 % 2;
        if (aFh1jSDK.equals(aFh1jSDK2)) {
            zAFInAppEventType = afInfoLog();
            i = f307w + 65;
        } else {
            zAFInAppEventType = AFInAppEventType(aFh1jSDK.AFKeystoreWrapper);
            values(zAFInAppEventType);
            i = f307w + 73;
        }
        f305i = i % 128;
        int i3 = i % 2;
        return zAFInAppEventType;
    }

    private static boolean AFKeystoreWrapper(String str) {
        int i = 2 % 2;
        int i2 = f305i + 69;
        f307w = i2 % 128;
        int i3 = i2 % 2;
        if (AFc1rSDK.AFKeystoreWrapper(str)) {
            int i4 = f307w + 119;
            f305i = i4 % 128;
            int i5 = i4 % 2;
            return true;
        }
        new AFd1cSDK();
        boolean zAFInAppEventType = AFd1cSDK.AFInAppEventType(unregisterClient(), str);
        int i6 = f305i + 33;
        f307w = i6 % 128;
        int i7 = i6 % 2;
        return zAFInAppEventType;
    }

    private boolean values(String str) {
        int i = 2 % 2;
        int i2 = f305i + 27;
        f307w = i2 % 128;
        if (i2 % 2 != 0) {
            if (AFc1rSDK.AFKeystoreWrapper(str)) {
                int i3 = f307w + 61;
                f305i = i3 % 128;
                int i4 = i3 % 2;
                return true;
            }
            AFd1rSDK aFd1rSDKAFInAppEventType = this.registerClient.AFInAppEventType();
            return str.equals(AFb1qSDK.AFKeystoreWrapper(aFd1rSDKAFInAppEventType.AFKeystoreWrapper.AFInAppEventParameterName, aFd1rSDKAFInAppEventType.AFKeystoreWrapper.AFInAppEventParameterName.getPackageName()));
        }
        AFc1rSDK.AFKeystoreWrapper(str);
        throw null;
    }

    private static boolean AFInAppEventType(float f) {
        int i = 2 % 2;
        double d = f;
        if (d >= 1.0d) {
            int i2 = f305i + 29;
            f307w = i2 % 128;
            int i3 = i2 % 2;
            return true;
        }
        if (d > 0.0d) {
            return registerClient() <= f;
        }
        int i4 = f305i + 27;
        int i5 = i4 % 128;
        f307w = i5;
        int i6 = i4 % 2;
        int i7 = i5 + 5;
        f305i = i7 % 128;
        int i8 = i7 % 2;
        return false;
    }

    private static AFh1jSDK valueOf(AFh1nSDK aFh1nSDK) {
        int i = 2 % 2;
        if (aFh1nSDK != null) {
            int i2 = f307w + 39;
            f305i = i2 % 128;
            if (i2 % 2 == 0) {
                AFh1mSDK aFh1mSDK = aFh1nSDK.AFInAppEventType;
                if (aFh1mSDK != null) {
                    return aFh1mSDK.AFInAppEventType;
                }
            } else {
                AFh1mSDK aFh1mSDK2 = aFh1nSDK.AFInAppEventType;
                throw null;
            }
        }
        int i3 = f307w + 89;
        f305i = i3 % 128;
        if (i3 % 2 == 0) {
            return null;
        }
        throw null;
    }

    private void m771w() {
        int i = 2 % 2;
        int i2 = f305i + 103;
        f307w = i2 % 128;
        if (i2 % 2 == 0) {
            this.registerClient.AFKeystoreWrapper().AFKeystoreWrapper("participantInProxy");
            throw null;
        }
        this.registerClient.AFKeystoreWrapper().AFKeystoreWrapper("participantInProxy");
        int i3 = f307w + 19;
        f305i = i3 % 128;
        if (i3 % 2 != 0) {
            int i4 = 15 / 0;
        }
    }

    private void values(boolean z) {
        int i = 2 % 2;
        int i2 = f307w + 75;
        f305i = i2 % 128;
        int i3 = i2 % 2;
        this.registerClient.AFKeystoreWrapper().AFInAppEventParameterName("participantInProxy", z);
        int i4 = f307w + 113;
        f305i = i4 % 128;
        if (i4 % 2 != 0) {
            throw null;
        }
    }

    private boolean afInfoLog() {
        int i = 2 % 2;
        int i2 = f305i + 97;
        f307w = i2 % 128;
        int i3 = i2 % 2;
        boolean zValueOf = this.registerClient.AFKeystoreWrapper().valueOf("participantInProxy");
        int i4 = f305i + 41;
        f307w = i4 % 128;
        int i5 = i4 % 2;
        return zValueOf;
    }

    private static void m767a(short s, int i, byte b, int i2, int i3, Object[] objArr) {
        int i4;
        int i5;
        boolean z;
        int i6 = 2 % 2;
        AFj1nSDK aFj1nSDK = new AFj1nSDK();
        StringBuilder sb = new StringBuilder();
        int i7 = i2 + ((int) (((long) f303d) ^ 7817788349036865294L));
        boolean z2 = i7 == -1;
        if (!(!z2)) {
            int i8 = $11 + TypedValues.TYPE_TARGET;
            $10 = i8 % 128;
            if (i8 % 2 == 0) {
                byte[] bArr = afInfoLog;
                if (bArr != null) {
                    int length = bArr.length;
                    byte[] bArr2 = new byte[length];
                    for (int i9 = 0; i9 < length; i9++) {
                        bArr2[i9] = (byte) (((long) bArr[i9]) ^ 7817788349036865294L);
                    }
                    bArr = bArr2;
                }
                if (bArr != null) {
                    i7 = (byte) (((byte) (((long) afInfoLog[i3 + ((int) (((long) f304e) ^ 7817788349036865294L))]) ^ 7817788349036865294L)) + ((int) (((long) f303d) ^ 7817788349036865294L)));
                } else {
                    i7 = (short) (((short) (((long) force[i3 + ((int) (((long) f304e) ^ 7817788349036865294L))]) ^ 7817788349036865294L)) + ((int) (((long) f303d) ^ 7817788349036865294L)));
                }
            } else {
                throw null;
            }
        }
        if (i7 > 0) {
            int i10 = $11 + 125;
            $10 = i10 % 128;
            if (i10 % 2 != 0) {
                i4 = ((i3 / i7) - 5) - ((int) (((long) f304e) ^ 7817788349036865294L));
                if (z2) {
                    i5 = 1;
                } else {
                    i5 = 0;
                }
            } else {
                i4 = ((i3 + i7) - 2) + ((int) (((long) f304e) ^ 7817788349036865294L));
                if (z2) {
                    i5 = 1;
                } else {
                    i5 = 0;
                }
            }
            aFj1nSDK.AFInAppEventParameterName = i4 + i5;
            aFj1nSDK.valueOf = (char) (((int) (((long) f306v) ^ 7817788349036865294L)) + i);
            sb.append(aFj1nSDK.valueOf);
            aFj1nSDK.values = aFj1nSDK.valueOf;
            byte[] bArr3 = afInfoLog;
            if (bArr3 != null) {
                int length2 = bArr3.length;
                byte[] bArr4 = new byte[length2];
                int i11 = $10 + 13;
                $11 = i11 % 128;
                int i12 = i11 % 2;
                for (int i13 = 0; i13 < length2; i13++) {
                    bArr4[i13] = (byte) (((long) bArr3[i13]) ^ 7817788349036865294L);
                }
                bArr3 = bArr4;
            }
            if (bArr3 != null) {
                int i14 = $11 + 57;
                $10 = i14 % 128;
                int i15 = i14 % 2;
                z = true;
            } else {
                z = false;
            }
            aFj1nSDK.AFKeystoreWrapper = 1;
            while (aFj1nSDK.AFKeystoreWrapper < i7) {
                if (z) {
                    byte[] bArr5 = afInfoLog;
                    int i16 = aFj1nSDK.AFInAppEventParameterName;
                    aFj1nSDK.AFInAppEventParameterName = i16 - 1;
                    aFj1nSDK.valueOf = (char) (aFj1nSDK.values + (((byte) (((byte) (((long) bArr5[i16]) ^ 7817788349036865294L)) + s)) ^ b));
                } else {
                    short[] sArr = force;
                    int i17 = aFj1nSDK.AFInAppEventParameterName;
                    aFj1nSDK.AFInAppEventParameterName = i17 - 1;
                    aFj1nSDK.valueOf = (char) (aFj1nSDK.values + (((short) (((short) (((long) sArr[i17]) ^ 7817788349036865294L)) + s)) ^ b));
                }
                sb.append(aFj1nSDK.valueOf);
                aFj1nSDK.values = aFj1nSDK.valueOf;
                aFj1nSDK.AFKeystoreWrapper++;
            }
        }
        objArr[0] = sb.toString();
    }
}
