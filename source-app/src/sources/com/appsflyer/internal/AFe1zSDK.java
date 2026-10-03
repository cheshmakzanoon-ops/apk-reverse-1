package com.appsflyer.internal;

import android.graphics.Color;
import android.media.AudioTrack;
import android.os.Build;
import android.os.SystemClock;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewConfiguration;
import android.widget.ExpandableListView;
import com.appsflyer.AFLogger;
import com.appsflyer.AppsFlyerLib;
import com.appsflyer.AppsFlyerProperties;
import com.facebook.devicerequests.internal.DeviceRequestsHelper;
import com.facebook.internal.ServerProtocol;
import java.lang.reflect.Method;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.StringCompanionObject;
import kotlin.text.Regex;

public final class AFe1zSDK {
    private static int $10 = 0;
    private static int $11 = 1;
    private static String AFInAppEventType = null;
    private static int AFLogger = 0;

    private static int f346e = 1;
    private static int registerClient;
    public static String values;
    private final AFe1vSDK AFInAppEventParameterName;
    private final AFd1rSDK AFKeystoreWrapper;
    private final AFe1jSDK unregisterClient;
    private final AppsFlyerProperties valueOf;

    static void AFInAppEventType() {
        registerClient = 23381860;
    }

    static {
        AFInAppEventType();
        values = "https://%sgcdsdk.%s/install_data/v5.0/";
        AFInAppEventType = "https://%sonelink.%s/shortlink-sdk/v2";
        int i = AFLogger + 47;
        f346e = i % 128;
        if (i % 2 == 0) {
            int i2 = 35 / 0;
        }
    }

    public AFe1zSDK(AFe1vSDK aFe1vSDK, AFd1rSDK aFd1rSDK, AppsFlyerProperties appsFlyerProperties, AFe1jSDK aFe1jSDK) {
        this.AFInAppEventParameterName = aFe1vSDK;
        this.AFKeystoreWrapper = aFd1rSDK;
        this.valueOf = appsFlyerProperties;
        this.unregisterClient = aFe1jSDK;
    }

    public final AFe1xSDK<String> AFInAppEventParameterName(Map<String, Object> map, String str, String str2) throws Throwable {
        String strAFInAppEventParameterName;
        int i = 2 % 2;
        try {
            Object[] objArr = {map, str};
            Object method = AFa1zSDK.afDebugLog.get(982724414);
            if (method == null) {
                method = ((Class) AFa1zSDK.valueOf(TextUtils.lastIndexOf("", '0', 0) + 74, (char) (41260 - (ExpandableListView.getPackedPositionForGroup(0) > 0L ? 1 : (ExpandableListView.getPackedPositionForGroup(0) == 0L ? 0 : -1))), 36 - View.MeasureSpec.makeMeasureSpec(0, 0))).getMethod("values", Map.class, String.class);
                AFa1zSDK.afDebugLog.put(982724414, method);
            }
            byte[] bArr = (byte[]) ((Method) method).invoke(null, objArr);
            int i2 = f346e + 83;
            AFLogger = i2 % 128;
            int i3 = i2 % 2;
            AFi1cSDK aFi1cSDK = new AFi1cSDK(this.AFKeystoreWrapper);
            String str3 = str2;
            if (str3 != null) {
                int i4 = f346e + 43;
                AFLogger = i4 % 128;
                if (i4 % 2 != 0) {
                    int i5 = 61 / 0;
                    if (str3.length() != 0) {
                        if (new Regex("4.?(\\d+)?.?(\\d+)").matches(str3) && !new Regex("3.?(\\d+)?.?(\\d+)").matches(str3)) {
                            strAFInAppEventParameterName = aFi1cSDK.values.AFInAppEventParameterName("https://%sars.%s/api/v2/android/validate_subscription_v2?app_id=");
                            int i6 = f346e + 11;
                            AFLogger = i6 % 128;
                            int i7 = i6 % 2;
                        }
                    }
                } else if (str3.length() != 0) {
                    if (new Regex("4.?(\\d+)?.?(\\d+)").matches(str3)) {
                    }
                }
                strAFInAppEventParameterName = aFi1cSDK.values.AFInAppEventParameterName("https://%sars.%s/api/v2/android/validate_subscription?app_id=");
            } else {
                strAFInAppEventParameterName = aFi1cSDK.values.AFInAppEventParameterName("https://%sars.%s/api/v2/android/validate_subscription?app_id=");
            }
            StringBuilder sb = new StringBuilder();
            sb.append(strAFInAppEventParameterName);
            sb.append(aFi1cSDK.valueOf.AFKeystoreWrapper.AFInAppEventParameterName.getPackageName());
            return AFKeystoreWrapper(new AFe1mSDK(aFi1cSDK.valueOf(sb.toString()), bArr, "POST", Collections.emptyMap(), true), new AFe1nSDK());
        } catch (Throwable th) {
            try {
                Throwable cause = th.getCause();
                if (cause != null) {
                    throw cause;
                }
                throw th;
            } catch (Exception e) {
                AFLogger.afErrorLogForExcManagerOnly("AFFinalizer: reflection init failed", e);
                return null;
            }
        }
    }

    public final AFe1xSDK<String> values(Map<String, Object> map, String str, String str2) throws Throwable {
        boolean z;
        String strAFInAppEventParameterName;
        int i = 2 % 2;
        try {
            Object[] objArr = {map, str};
            Object method = AFa1zSDK.afDebugLog.get(982724414);
            if (method == null) {
                method = ((Class) AFa1zSDK.valueOf(73 - (KeyEvent.getMaxKeyCode() >> 16), (char) ((ViewConfiguration.getFadingEdgeLength() >> 16) + 41260), 36 - TextUtils.getCapsMode("", 0, 0))).getMethod("values", Map.class, String.class);
                AFa1zSDK.afDebugLog.put(982724414, method);
            }
            byte[] bArr = (byte[]) ((Method) method).invoke(null, objArr);
            int i2 = AFLogger + 77;
            f346e = i2 % 128;
            int i3 = i2 % 2;
            AFi1cSDK aFi1cSDK = new AFi1cSDK(this.AFKeystoreWrapper);
            String str3 = str2;
            if (str3 != null) {
                int i4 = AFLogger + 21;
                f346e = i4 % 128;
                int i5 = i4 % 2;
                z = str3.length() == 0 || new Regex("4.?(\\d+)?.?(\\d+)").matches(str3) || new Regex("3.?(\\d+)?.?(\\d+)").matches(str3);
            }
            if (!(!z)) {
                int i6 = f346e + 13;
                AFLogger = i6 % 128;
                int i7 = i6 % 2;
                strAFInAppEventParameterName = aFi1cSDK.values.AFInAppEventParameterName("https://%sviap.%s/api/v1/android/validate_purchase?app_id=");
            } else {
                strAFInAppEventParameterName = aFi1cSDK.values.AFInAppEventParameterName("https://%sviap.%s/api/v1/android/validate_purchase_v2?app_id=");
            }
            StringBuilder sb = new StringBuilder();
            sb.append(strAFInAppEventParameterName);
            sb.append(aFi1cSDK.valueOf.AFKeystoreWrapper.AFInAppEventParameterName.getPackageName());
            return AFKeystoreWrapper(new AFe1mSDK(aFi1cSDK.valueOf(sb.toString()), bArr, "POST", Collections.emptyMap(), true), new AFe1nSDK());
        } catch (Throwable th) {
            try {
                Throwable cause = th.getCause();
                if (cause != null) {
                    throw cause;
                }
                throw th;
            } catch (Exception e) {
                AFLogger.afErrorLogForExcManagerOnly("AFFinalizer: reflection init failed", e);
                return null;
            }
        }
    }

    public final AFe1xSDK<AFh1nSDK> values(boolean z, boolean z2, String str, int i) {
        String str2;
        String str3;
        String str4;
        int i2 = 2 % 2;
        int i3 = f346e + 65;
        AFLogger = i3 % 128;
        int i4 = i3 % 2;
        AFe1jSDK aFe1jSDK = this.unregisterClient;
        Intrinsics.checkNotNullParameter(str, "");
        if (z) {
            int i5 = f346e + 121;
            AFLogger = i5 % 128;
            int i6 = i5 % 2;
            str2 = AFe1jSDK.AFInAppEventParameterName;
        } else {
            str2 = AFe1jSDK.AFKeystoreWrapper;
        }
        if (z2) {
            int i7 = f346e + 53;
            AFLogger = i7 % 128;
            str3 = "stg";
            if (i7 % 2 != 0) {
                int i8 = 45 / 0;
            }
        } else {
            str3 = "";
        }
        StringCompanionObject stringCompanionObject = StringCompanionObject.INSTANCE;
        if (!AFe1jSDK.values()) {
            str4 = "";
        } else {
            int i9 = AFLogger + 59;
            f346e = i9 % 128;
            if (i9 % 2 == 0) {
                str4 = (String) aFe1jSDK.AFInAppEventParameterName.getValue();
                int i10 = 76 / 0;
            } else {
                str4 = (String) aFe1jSDK.AFInAppEventParameterName.getValue();
            }
        }
        String str5 = String.format(str2, Arrays.copyOf(new Object[]{str4, str3, aFe1jSDK.valueOf(), str}, 4));
        Intrinsics.checkNotNullExpressionValue(str5, "");
        AFe1mSDK aFe1mSDK = new AFe1mSDK(str5, "GET");
        aFe1mSDK.AFLogger = 1500;
        return AFKeystoreWrapper(aFe1mSDK, new AFe1lSDK());
    }

    public final AFe1xSDK<String> valueOf(AFa1pSDK aFa1pSDK, String str, AFd1lSDK aFd1lSDK) {
        int i = 2 % 2;
        int i2 = AFLogger + 119;
        f346e = i2 % 128;
        int i3 = i2 % 2;
        try {
            Object[] objArr = {aFa1pSDK, str, aFd1lSDK};
            Object method = AFa1zSDK.afDebugLog.get(384742647);
            if (method == null) {
                method = ((Class) AFa1zSDK.valueOf((AudioTrack.getMaxVolume() > 0.0f ? 1 : (AudioTrack.getMaxVolume() == 0.0f ? 0 : -1)) + 72, (char) ((ViewConfiguration.getJumpTapTimeout() >> 16) + 41260), 35 - TextUtils.indexOf((CharSequence) "", '0', 0, 0))).getMethod("AFInAppEventParameterName", AFa1pSDK.class, String.class, AFd1lSDK.class);
                AFa1zSDK.afDebugLog.put(384742647, method);
            }
            AFe1xSDK<String> aFe1xSDKAFKeystoreWrapper = AFKeystoreWrapper(new AFe1mSDK(aFa1pSDK.unregisterClient, (byte[]) ((Method) method).invoke(null, objArr), "POST", Collections.emptyMap(), aFa1pSDK.AFKeystoreWrapper()), new AFe1nSDK());
            int i4 = f346e + 103;
            AFLogger = i4 % 128;
            int i5 = i4 % 2;
            return aFe1xSDKAFKeystoreWrapper;
        } catch (Throwable th) {
            try {
                Throwable cause = th.getCause();
                if (cause != null) {
                    throw cause;
                }
                throw th;
            } catch (Throwable th2) {
                AFLogger.afErrorLogForExcManagerOnly("AFFinalizer: reflection init failed", th2);
                return null;
            }
        }
    }

    public final AFe1xSDK<Map<String, Object>> AFInAppEventType(String str, String str2) {
        int i = 2 % 2;
        String packageName = this.AFKeystoreWrapper.AFKeystoreWrapper.AFInAppEventParameterName.getPackageName();
        AFd1rSDK aFd1rSDK = this.AFKeystoreWrapper;
        AFe1xSDK<Map<String, Object>> aFe1xSDKAFKeystoreWrapper = AFKeystoreWrapper(AFe1qSDK.AFInAppEventType(packageName, AFb1lSDK.values(aFd1rSDK.AFKeystoreWrapper, aFd1rSDK.AFInAppEventParameterName), str, str2), new AFe1rSDK());
        int i2 = f346e + 39;
        AFLogger = i2 % 128;
        if (i2 % 2 == 0) {
            return aFe1xSDKAFKeystoreWrapper;
        }
        throw null;
    }

    public final AFe1xSDK<String> AFKeystoreWrapper(AFh1tSDK aFh1tSDK) {
        int i = 2 % 2;
        AFe1xSDK<String> aFe1xSDKAFKeystoreWrapper = AFKeystoreWrapper(new AFe1mSDK(aFh1tSDK.unregisterClient, aFh1tSDK.values(), "POST", Collections.emptyMap(), true), new AFe1nSDK());
        int i2 = f346e + 77;
        AFLogger = i2 % 128;
        int i3 = i2 % 2;
        return aFe1xSDKAFKeystoreWrapper;
    }

    public final AFe1xSDK<String> AFInAppEventType(String str, Map<String, String> map, String str2, UUID uuid, String str3) {
        int i = 2 % 2;
        String string = uuid.toString();
        HashMap map2 = new HashMap();
        map2.put("ttl", "-1");
        map2.put("uuid", string);
        map2.put("data", map);
        map2.put("meta", values());
        if (str2 != null) {
            int i2 = f346e + 79;
            AFLogger = i2 % 128;
            if (i2 % 2 != 0) {
                map2.put("brand_domain", str2);
                throw null;
            }
            map2.put("brand_domain", str2);
        }
        String string2 = AFa1oSDK.values((Map<String, ?>) map2).toString();
        HashMap map3 = new HashMap();
        Object[] objArr = new Object[1];
        m792a(12 - Color.blue(0), false, View.MeasureSpec.makeMeasureSpec(0, 0) + 4, 118 - (ViewConfiguration.getScrollBarSize() >> 8), "\u0014\u0015\u0012\u0005￡\u0006ￍ\ufff3\t\u0007\u000e\u0001", objArr);
        map3.put(((String) objArr[0]).intern(), AFKeystoreWrapper(str3, string, "POST", string2));
        StringBuilder sb = new StringBuilder();
        sb.append(String.format(AFInAppEventType, AppsFlyerLib.getInstance().getHostPrefix(), AFb1vSDK.valueOf().getHostName()));
        sb.append("/");
        sb.append(str);
        AFe1xSDK<String> aFe1xSDKAFKeystoreWrapper = AFKeystoreWrapper(new AFe1mSDK(sb.toString(), string2.getBytes(Charset.defaultCharset()), "POST", map3, false), (AFe1kSDK) new AFe1nSDK(), true);
        int i3 = f346e + 23;
        AFLogger = i3 % 128;
        int i4 = i3 % 2;
        return aFe1xSDKAFKeystoreWrapper;
    }

    public final AFe1xSDK<Map<String, String>> values(String str, String str2, UUID uuid, String str3) {
        int i = 2 % 2;
        String string = uuid.toString();
        StringBuilder sb = new StringBuilder();
        sb.append(String.format(AFInAppEventType, AppsFlyerLib.getInstance().getHostPrefix(), AFb1vSDK.valueOf().getHostName()));
        sb.append("/");
        sb.append(str);
        sb.append("?id=");
        sb.append(str2);
        String string2 = sb.toString();
        Map<String, Object> mapValues = values();
        String strValueOf = String.valueOf(mapValues.get("build_number"));
        HashMap map = new HashMap();
        map.put("Af-UUID", uuid.toString());
        map.put("Af-Meta-Sdk-Ver", strValueOf);
        map.put("Af-Meta-Counter", String.valueOf(mapValues.get("counter")));
        map.put("Af-Meta-Model", String.valueOf(mapValues.get(DeviceRequestsHelper.DEVICE_INFO_MODEL)));
        map.put("Af-Meta-Platform", String.valueOf(mapValues.get("platformextension")));
        map.put("Af-Meta-System-Version", String.valueOf(mapValues.get(ServerProtocol.DIALOG_PARAM_SDK_VERSION)));
        Object[] objArr = new Object[1];
        m792a((SystemClock.uptimeMillis() > 0L ? 1 : (SystemClock.uptimeMillis() == 0L ? 0 : -1)) + 11, false, 4 - (ViewConfiguration.getScrollDefaultDelay() >> 16), 118 - (ViewConfiguration.getMaximumDrawingCacheSize() >> 24), "\u0014\u0015\u0012\u0005￡\u0006ￍ\ufff3\t\u0007\u000e\u0001", objArr);
        map.put(((String) objArr[0]).intern(), AFKeystoreWrapper(str3, string, "GET", string, str, str2, strValueOf));
        AFe1xSDK<Map<String, String>> aFe1xSDKAFKeystoreWrapper = AFKeystoreWrapper(new AFe1mSDK(string2, null, "GET", map, false), new AFe1oSDK());
        int i2 = AFLogger + 9;
        f346e = i2 % 128;
        int i3 = i2 % 2;
        return aFe1xSDKAFKeystoreWrapper;
    }

    public final AFe1xSDK<String> AFInAppEventParameterName(String str) {
        int i = 2 % 2;
        AFe1mSDK aFe1mSDK = new AFe1mSDK(str, null, "GET", Collections.emptyMap(), false);
        aFe1mSDK.AFLogger = 10000;
        aFe1mSDK.AFKeystoreWrapper = false;
        AFe1xSDK<String> aFe1xSDKAFKeystoreWrapper = AFKeystoreWrapper(aFe1mSDK, new AFe1nSDK());
        int i2 = f346e + 45;
        AFLogger = i2 % 128;
        int i3 = i2 % 2;
        return aFe1xSDKAFKeystoreWrapper;
    }

    public final AFe1ySDK AFKeystoreWrapper(Map<String, Object> map, String str) throws Throwable {
        int i = 2 % 2;
        int i2 = AFLogger + 21;
        f346e = i2 % 128;
        int i3 = i2 % 2;
        try {
            try {
                Object[] objArr = {map, str};
                Object method = AFa1zSDK.afDebugLog.get(982724414);
                if (method == null) {
                    method = ((Class) AFa1zSDK.valueOf(73 - TextUtils.getOffsetBefore("", 0), (char) ((AudioTrack.getMaxVolume() > 0.0f ? 1 : (AudioTrack.getMaxVolume() == 0.0f ? 0 : -1)) + 41259), TextUtils.indexOf("", "", 0, 0) + 36)).getMethod("values", Map.class, String.class);
                    AFa1zSDK.afDebugLog.put(982724414, method);
                }
                byte[] bArr = (byte[]) ((Method) method).invoke(null, objArr);
                if (bArr != null) {
                    return new AFe1ySDK(this.AFKeystoreWrapper, bArr);
                }
                AFLogger.afErrorLogForExcManagerOnly("AFFinalizer: failed to create bytes", new IllegalArgumentException("failed to create bytes from proxyData"));
                int i4 = AFLogger + 29;
                f346e = i4 % 128;
                int i5 = i4 % 2;
                return null;
            } catch (Throwable th) {
                Throwable cause = th.getCause();
                if (cause != null) {
                    throw cause;
                }
                throw th;
            }
        } catch (Exception e) {
            AFLogger.afErrorLogForExcManagerOnly("AFFinalizer: reflection init failed", e);
            return null;
        }
    }

    private <T> AFe1xSDK<T> AFKeystoreWrapper(AFe1mSDK aFe1mSDK, AFe1kSDK<T> aFe1kSDK) {
        int i = 2 % 2;
        int i2 = f346e + 107;
        AFLogger = i2 % 128;
        int i3 = i2 % 2;
        AFe1xSDK<T> aFe1xSDKAFKeystoreWrapper = AFKeystoreWrapper(aFe1mSDK, aFe1kSDK, valueOf());
        int i4 = f346e + 77;
        AFLogger = i4 % 128;
        int i5 = i4 % 2;
        return aFe1xSDKAFKeystoreWrapper;
    }

    private Map<String, Object> values() {
        int i = 2 % 2;
        HashMap map = new HashMap();
        map.put("build_number", "6.13.0");
        map.put("counter", Integer.valueOf(this.AFKeystoreWrapper.AFInAppEventParameterName.valueOf("appsFlyerCount", 0)));
        map.put(DeviceRequestsHelper.DEVICE_INFO_MODEL, Build.MODEL);
        Object[] objArr = new Object[1];
        m792a((AudioTrack.getMaxVolume() > 0.0f ? 1 : (AudioTrack.getMaxVolume() == 0.0f ? 0 : -1)) + 4, true, (ViewConfiguration.getZoomControlsTimeout() > 0L ? 1 : (ViewConfiguration.getZoomControlsTimeout() == 0L ? 0 : -1)) + 3, 125 - TextUtils.getOffsetAfter("", 0), "\u0007\ufffa\u000b\ufffb�", objArr);
        map.put(((String) objArr[0]).intern(), Build.BRAND);
        map.put(ServerProtocol.DIALOG_PARAM_SDK_VERSION, Integer.toString(Build.VERSION.SDK_INT));
        AFd1rSDK aFd1rSDK = this.AFKeystoreWrapper;
        map.put("app_version_name", AFb1qSDK.AFKeystoreWrapper(aFd1rSDK.AFKeystoreWrapper.AFInAppEventParameterName, aFd1rSDK.AFKeystoreWrapper.AFInAppEventParameterName.getPackageName()));
        map.put("app_id", this.AFKeystoreWrapper.AFKeystoreWrapper.AFInAppEventParameterName.getPackageName());
        map.put("platformextension", new AFb1gSDK().AFInAppEventType());
        int i2 = f346e + 103;
        AFLogger = i2 % 128;
        int i3 = i2 % 2;
        return map;
    }

    private static String AFKeystoreWrapper(String str, String str2, String... strArr) {
        int i = 2 % 2;
        ArrayList arrayList = new ArrayList(Arrays.asList(strArr));
        arrayList.add(1, "v2");
        String strJoin = TextUtils.join("\u2063", (String[]) arrayList.toArray(new String[0]));
        StringBuilder sb = new StringBuilder();
        sb.append(str);
        sb.append(str2);
        sb.append("v2");
        String strAFInAppEventParameterName = AFb1mSDK.AFInAppEventParameterName(strJoin, sb.toString());
        int i2 = f346e + 77;
        AFLogger = i2 % 128;
        int i3 = i2 % 2;
        return strAFInAppEventParameterName;
    }

    private boolean valueOf() {
        int i = 2 % 2;
        int i2 = f346e + 17;
        AFLogger = i2 % 128;
        int i3 = i2 % 2;
        if (this.valueOf.getBoolean(AppsFlyerProperties.HTTP_CACHE, true)) {
            return false;
        }
        int i4 = AFLogger + 17;
        f346e = i4 % 128;
        int i5 = i4 % 2;
        return true;
    }

    private <T> AFe1xSDK<T> AFKeystoreWrapper(AFe1mSDK aFe1mSDK, AFe1kSDK<T> aFe1kSDK, boolean z) {
        int i = 2 % 2;
        aFe1mSDK.AFInAppEventType = z;
        AFe1vSDK aFe1vSDK = this.AFInAppEventParameterName;
        AFe1xSDK<T> aFe1xSDK = new AFe1xSDK<>(aFe1mSDK, aFe1vSDK.values, aFe1vSDK.AFInAppEventParameterName, aFe1kSDK);
        int i2 = f346e + 21;
        AFLogger = i2 % 128;
        if (i2 % 2 == 0) {
            return aFe1xSDK;
        }
        Object obj = null;
        obj.hashCode();
        throw null;
    }

    private static void m792a(int i, boolean z, int i2, int i3, String str, Object[] objArr) {
        int i4 = 2 % 2;
        int i5 = $11 + 65;
        $10 = i5 % 128;
        int i6 = i5 % 2;
        Object charArray = str;
        if (str != null) {
            charArray = str.toCharArray();
        }
        char[] cArr = (char[]) charArray;
        AFj1lSDK aFj1lSDK = new AFj1lSDK();
        char[] cArr2 = new char[i];
        aFj1lSDK.AFKeystoreWrapper = 0;
        while (aFj1lSDK.AFKeystoreWrapper < i) {
            int i7 = $10 + 35;
            $11 = i7 % 128;
            int i8 = i7 % 2;
            aFj1lSDK.values = cArr[aFj1lSDK.AFKeystoreWrapper];
            cArr2[aFj1lSDK.AFKeystoreWrapper] = (char) (aFj1lSDK.values + i3);
            int i9 = aFj1lSDK.AFKeystoreWrapper;
            cArr2[i9] = (char) (cArr2[i9] - ((int) (((long) registerClient) ^ 7776624685611272050L)));
            aFj1lSDK.AFKeystoreWrapper++;
        }
        if (i2 > 0) {
            int i10 = $11 + 25;
            $10 = i10 % 128;
            int i11 = i10 % 2;
            aFj1lSDK.valueOf = i2;
            char[] cArr3 = new char[i];
            System.arraycopy(cArr2, 0, cArr3, 0, i);
            System.arraycopy(cArr3, 0, cArr2, i - aFj1lSDK.valueOf, aFj1lSDK.valueOf);
            System.arraycopy(cArr3, aFj1lSDK.valueOf, cArr2, 0, i - aFj1lSDK.valueOf);
        }
        if (z) {
            char[] cArr4 = new char[i];
            aFj1lSDK.AFKeystoreWrapper = 0;
            while (aFj1lSDK.AFKeystoreWrapper < i) {
                int i12 = $10 + 15;
                $11 = i12 % 128;
                int i13 = i12 % 2;
                cArr4[aFj1lSDK.AFKeystoreWrapper] = cArr2[(i - aFj1lSDK.AFKeystoreWrapper) - 1];
                aFj1lSDK.AFKeystoreWrapper++;
            }
            cArr2 = cArr4;
        }
        objArr[0] = new String(cArr2);
    }
}
