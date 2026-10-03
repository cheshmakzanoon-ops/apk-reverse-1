package com.appsflyer.internal;

import android.app.UiModeManager;
import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.os.Build;
import android.os.Environment;
import android.os.StatFs;
import android.os.SystemClock;
import android.provider.Settings;
import androidx.constraintlayout.core.motion.utils.TypedValues;
import com.appsflyer.AFLogger;
import com.appsflyer.AppsFlyerProperties;
import com.facebook.appevents.UserDataStore;
import com.facebook.devicerequests.internal.DeviceRequestsHelper;
import com.facebook.internal.ServerProtocol;
import j$.util.DesugarTimeZone;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStreamReader;
import java.nio.charset.Charset;
import java.security.NoSuchAlgorithmException;
import java.security.cert.CertificateException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.concurrent.TimeUnit;
import kotlin.Lazy;
import kotlin.LazyKt;
import kotlin.Pair;
import kotlin.TuplesKt;
import kotlin.collections.MapsKt;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.Intrinsics;
import kotlin.text.StringsKt;
import org.json.JSONException;
import org.json.JSONObject;

public final class AFg1nSDK implements AFg1qSDK {
    private static int $10 = 0;
    private static int $11 = 1;
    private static long afErrorLog = 690806083636696051L;
    private static int afRDLog = 0;
    private static int afWarnLog = 1;
    private final AFb1zSDK AFInAppEventParameterName;
    private final AFi1fSDK AFInAppEventType;
    private final AFd1vSDK AFKeystoreWrapper;
    private final AFg1zSDK AFLogger;
    private final AFb1gSDK afInfoLog;
    private final Lazy afVerboseLog;

    private final AFg1bSDK f387d;

    private final AFd1xSDK f388e;
    private final Lazy force;

    private final AFd1lSDK f389i;
    private final AFh1gSDK registerClient;
    private final AFd1rSDK unregisterClient;

    private final AFd1sSDK f390v;
    private final Context valueOf;
    private final AFi1xSDK values;

    private final AFg1sSDK f391w;

    public AFg1nSDK(Context context, AFi1xSDK aFi1xSDK, AFd1vSDK aFd1vSDK, AFi1fSDK aFi1fSDK, AFb1zSDK aFb1zSDK, AFg1bSDK aFg1bSDK, AFd1xSDK aFd1xSDK, AFd1rSDK aFd1rSDK, AFh1gSDK aFh1gSDK, AFg1zSDK aFg1zSDK, AFb1gSDK aFb1gSDK, AFd1lSDK aFd1lSDK, AFg1sSDK aFg1sSDK, AFd1sSDK aFd1sSDK) {
        Intrinsics.checkNotNullParameter(context, "");
        Intrinsics.checkNotNullParameter(aFi1xSDK, "");
        Intrinsics.checkNotNullParameter(aFd1vSDK, "");
        Intrinsics.checkNotNullParameter(aFi1fSDK, "");
        Intrinsics.checkNotNullParameter(aFb1zSDK, "");
        Intrinsics.checkNotNullParameter(aFg1bSDK, "");
        Intrinsics.checkNotNullParameter(aFd1xSDK, "");
        Intrinsics.checkNotNullParameter(aFd1rSDK, "");
        Intrinsics.checkNotNullParameter(aFh1gSDK, "");
        Intrinsics.checkNotNullParameter(aFg1zSDK, "");
        Intrinsics.checkNotNullParameter(aFb1gSDK, "");
        Intrinsics.checkNotNullParameter(aFd1lSDK, "");
        Intrinsics.checkNotNullParameter(aFg1sSDK, "");
        Intrinsics.checkNotNullParameter(aFd1sSDK, "");
        this.valueOf = context;
        this.values = aFi1xSDK;
        this.AFKeystoreWrapper = aFd1vSDK;
        this.AFInAppEventType = aFi1fSDK;
        this.AFInAppEventParameterName = aFb1zSDK;
        this.f387d = aFg1bSDK;
        this.f388e = aFd1xSDK;
        this.unregisterClient = aFd1rSDK;
        this.registerClient = aFh1gSDK;
        this.AFLogger = aFg1zSDK;
        this.afInfoLog = aFb1gSDK;
        this.f389i = aFd1lSDK;
        this.f391w = aFg1sSDK;
        this.f390v = aFd1sSDK;
        this.force = LazyKt.lazy(new Function0<AppsFlyerProperties>() {
            public final AppsFlyerProperties invoke() {
                return AppsFlyerProperties.getInstance();
            }
        });
        this.afVerboseLog = LazyKt.lazy(new Function0<SimpleDateFormat>() {
            public final SimpleDateFormat invoke() {
                return new SimpleDateFormat("yyyy-MM-dd_HHmmssZ", Locale.US);
            }
        });
    }

    private final AppsFlyerProperties AFInAppEventType() {
        int i = 2 % 2;
        int i2 = afRDLog + 15;
        afWarnLog = i2 % 128;
        int i3 = i2 % 2;
        AppsFlyerProperties appsFlyerProperties = (AppsFlyerProperties) this.force.getValue();
        int i4 = afRDLog + 61;
        afWarnLog = i4 % 128;
        if (i4 % 2 == 0) {
            int i5 = 53 / 0;
        }
        return appsFlyerProperties;
    }

    private final SimpleDateFormat AFInAppEventParameterName() {
        int i = 2 % 2;
        int i2 = afRDLog + 47;
        afWarnLog = i2 % 128;
        int i3 = i2 % 2;
        SimpleDateFormat simpleDateFormat = (SimpleDateFormat) this.afVerboseLog.getValue();
        int i4 = afWarnLog + 37;
        afRDLog = i4 % 128;
        int i5 = i4 % 2;
        return simpleDateFormat;
    }

    @Override
    public final void AFInAppEventParameterName(AFa1pSDK aFa1pSDK) {
        Map<String, Object> mapAFInAppEventType;
        int i = 2 % 2;
        int i2 = afWarnLog + 91;
        afRDLog = i2 % 128;
        if (i2 % 2 != 0) {
            Intrinsics.checkNotNullParameter(aFa1pSDK, "");
            mapAFInAppEventType = aFa1pSDK.AFInAppEventType();
            int i3 = 59 / 0;
            if (!(!aFa1pSDK.valueOf())) {
                Intrinsics.checkNotNullExpressionValue(mapAFInAppEventType, "");
                values(mapAFInAppEventType, aFa1pSDK.f295e, this.f390v.AFInAppEventParameterName, this.f390v.AFInAppEventType);
            } else {
                Intrinsics.checkNotNullExpressionValue(mapAFInAppEventType, "");
                String str = aFa1pSDK.AFLogger;
                Intrinsics.checkNotNullExpressionValue(str, "");
                AFInAppEventType(mapAFInAppEventType, str);
            }
        } else {
            Intrinsics.checkNotNullParameter(aFa1pSDK, "");
            mapAFInAppEventType = aFa1pSDK.AFInAppEventType();
            if (aFa1pSDK.valueOf()) {
                Intrinsics.checkNotNullExpressionValue(mapAFInAppEventType, "");
                values(mapAFInAppEventType, aFa1pSDK.f295e, this.f390v.AFInAppEventParameterName, this.f390v.AFInAppEventType);
            } else {
                Intrinsics.checkNotNullExpressionValue(mapAFInAppEventType, "");
                String str2 = aFa1pSDK.AFLogger;
                Intrinsics.checkNotNullExpressionValue(str2, "");
                AFInAppEventType(mapAFInAppEventType, str2);
            }
        }
        getLevel(mapAFInAppEventType);
        afVerboseLog(mapAFInAppEventType);
        afErrorLog(mapAFInAppEventType);
        afWarnLog(mapAFInAppEventType);
        AFVersionDeclaration(mapAFInAppEventType);
        AFKeystoreWrapper(mapAFInAppEventType, aFa1pSDK.valueOf());
        AFLogger$LogLevel(mapAFInAppEventType);
        afLogForce(mapAFInAppEventType);
        valueOf(mapAFInAppEventType, aFa1pSDK);
        mapAFInAppEventType.put("af_events_api", "1");
        int i4 = afRDLog + 73;
        afWarnLog = i4 % 128;
        int i5 = i4 % 2;
    }

    @Override
    public final void AFKeystoreWrapper(Map<String, Object> map, boolean z, Function0<String> function0) {
        int i = 2 % 2;
        int i2 = afWarnLog + 33;
        afRDLog = i2 % 128;
        if (i2 % 2 != 0) {
            Intrinsics.checkNotNullParameter(map, "");
            Intrinsics.checkNotNullParameter(function0, "");
            AFInAppEventParameterName(map);
            registerClient(map);
            afRDLog(map);
            AFInAppEventType(map, z);
            AFInAppEventParameterName(map, function0);
            int i3 = 71 / 0;
        } else {
            Intrinsics.checkNotNullParameter(map, "");
            Intrinsics.checkNotNullParameter(function0, "");
            AFInAppEventParameterName(map);
            registerClient(map);
            afRDLog(map);
            AFInAppEventType(map, z);
            AFInAppEventParameterName(map, function0);
        }
        int i4 = afRDLog + 5;
        afWarnLog = i4 % 128;
        int i5 = i4 % 2;
    }

    private final void AFInAppEventParameterName(Map<String, Object> map) {
        int i = 2 % 2;
        try {
            long j = this.valueOf.getPackageManager().getPackageInfo(this.valueOf.getPackageName(), 0).firstInstallTime;
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd_HHmmssZ", Locale.US);
            simpleDateFormat.setTimeZone(DesugarTimeZone.getTimeZone("UTC"));
            map.put("installDate", simpleDateFormat.format(new Date(j)));
            int i2 = afRDLog + 61;
            afWarnLog = i2 % 128;
            if (i2 % 2 != 0) {
                return;
            }
            Object obj = null;
            obj.hashCode();
            throw null;
        } catch (Exception e) {
            AFLogger.afErrorLog("Exception while collecting install date. ", e);
        }
    }

    private final void registerClient(Map<String, Object> map) {
        PackageInfo packageInfo;
        int i = 2 % 2;
        int i2 = afWarnLog + 93;
        afRDLog = i2 % 128;
        try {
            if (i2 % 2 != 0) {
                packageInfo = this.valueOf.getPackageManager().getPackageInfo(this.valueOf.getPackageName(), 1);
                if (packageInfo.versionCode > this.f388e.valueOf("versionCode", 1)) {
                    this.f388e.AFInAppEventParameterName("versionCode", packageInfo.versionCode);
                    int i3 = afRDLog + 29;
                    afWarnLog = i3 % 128;
                    int i4 = i3 % 2;
                }
            } else {
                packageInfo = this.valueOf.getPackageManager().getPackageInfo(this.valueOf.getPackageName(), 0);
                if (packageInfo.versionCode > this.f388e.valueOf("versionCode", 0)) {
                    this.f388e.AFInAppEventParameterName("versionCode", packageInfo.versionCode);
                    int i5 = afRDLog + 29;
                    afWarnLog = i5 % 128;
                    int i6 = i5 % 2;
                }
            }
            map.put("app_version_code", String.valueOf(packageInfo.versionCode));
            AFd1rSDK aFd1rSDK = this.unregisterClient;
            map.put("app_version_name", AFb1qSDK.AFKeystoreWrapper(aFd1rSDK.AFKeystoreWrapper.AFInAppEventParameterName, aFd1rSDK.AFKeystoreWrapper.AFInAppEventParameterName.getPackageName()));
            map.put("targetSDKver", Integer.valueOf(this.unregisterClient.AFKeystoreWrapper.AFInAppEventParameterName.getApplicationInfo().targetSdkVersion));
            long j = packageInfo.firstInstallTime;
            long j2 = packageInfo.lastUpdateTime;
            map.put("date1", AFInAppEventParameterName().format(new Date(j)));
            map.put("date2", AFInAppEventParameterName().format(new Date(j2)));
            Object[] objArr = new Object[1];
            m805a("ᯫᮍ搹蜬けற墜羁ꐛ⒘잻烓撍\ue53bؾ녮┆ꖨ䚷", 1 - Color.argb(0, 0, 0, 0), objArr);
            String strIntern = ((String) objArr[0]).intern();
            SimpleDateFormat simpleDateFormatAFInAppEventParameterName = AFInAppEventParameterName();
            Intrinsics.checkNotNullExpressionValue(simpleDateFormatAFInAppEventParameterName, "");
            map.put(strIntern, AFKeystoreWrapper(simpleDateFormatAFInAppEventParameterName));
        } catch (Throwable th) {
            AFLogger.afErrorLog("Exception while collecting app version data ", th, true);
        }
    }

    @Override
    public final void values(AFa1pSDK aFa1pSDK) {
        int i = 2 % 2;
        int i2 = afWarnLog + 9;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        Intrinsics.checkNotNullParameter(aFa1pSDK, "");
        Map<String, Object> mapAFInAppEventType = aFa1pSDK.AFInAppEventType();
        Intrinsics.checkNotNullExpressionValue(mapAFInAppEventType, "");
        AFInAppEventParameterName(mapAFInAppEventType, aFa1pSDK.valueOf());
        AFInAppEventType(aFa1pSDK);
        AFLogger(mapAFInAppEventType);
        afDebugLog(mapAFInAppEventType);
        values(mapAFInAppEventType);
        valueOf(mapAFInAppEventType, this.f390v.valueOf);
        afErrorLogForExcManagerOnly(mapAFInAppEventType);
        mapAFInAppEventType.put("cell", MapsKt.mapOf(new Pair[]{TuplesKt.to("mcc", Integer.valueOf(this.valueOf.getResources().getConfiguration().mcc)), TuplesKt.to("mnc", Integer.valueOf(this.valueOf.getResources().getConfiguration().mnc))}));
        mapAFInAppEventType.put("sig", values());
        mapAFInAppEventType.put("last_boot_time", Long.valueOf(valueOf()));
        mapAFInAppEventType.put("disk", registerClient());
        int i4 = afRDLog + 7;
        afWarnLog = i4 % 128;
        if (i4 % 2 == 0) {
            int i5 = 47 / 0;
        }
    }

    private final void AFInAppEventType(AFa1pSDK aFa1pSDK) {
        int i = 2 % 2;
        int i2 = afRDLog + 67;
        afWarnLog = i2 % 128;
        Object obj = null;
        if (i2 % 2 != 0) {
            if (!aFa1pSDK.valueOf()) {
                try {
                    aFa1pSDK.AFInAppEventType().putAll(this.AFInAppEventType.AFKeystoreWrapper());
                    return;
                } catch (Exception e) {
                    AFLogger.afErrorLogForExcManagerOnly("error while getting sensors data", e);
                    StringBuilder sb = new StringBuilder("Unexpected exception from AFSensorManager: ");
                    sb.append(e.getMessage());
                    AFLogger.afRDLog(sb.toString());
                }
            }
            int i3 = afRDLog + 49;
            afWarnLog = i3 % 128;
            if (i3 % 2 != 0) {
                return;
            }
            obj.hashCode();
            throw null;
        }
        aFa1pSDK.valueOf();
        obj.hashCode();
        throw null;
    }

    @Override
    public final void AFInAppEventType(Map<String, Object> map) {
        int i = 2 % 2;
        Intrinsics.checkNotNullParameter(map, "");
        String string = AFInAppEventType().getString(AppsFlyerProperties.APP_ID);
        if (string != null) {
            map.put(AppsFlyerProperties.APP_ID, string);
        }
        String string2 = AFInAppEventType().getString(AppsFlyerProperties.CURRENCY_CODE);
        if (string2 != null) {
            if (string2.length() != 3) {
                StringBuilder sb = new StringBuilder("WARNING: currency code should be 3 characters!!! '");
                sb.append(string2);
                sb.append("' is not a legal value.");
                String string3 = sb.toString();
                Intrinsics.checkNotNullExpressionValue(string3, "");
                AFLogger.afWarnLog(string3);
            }
            map.put("currency", string2);
        }
        String string4 = AFInAppEventType().getString(AppsFlyerProperties.IS_UPDATE);
        if (string4 != null) {
            map.put("isUpdate", string4);
        }
        String string5 = AFInAppEventType().getString(AppsFlyerProperties.ADDITIONAL_CUSTOM_DATA);
        Object obj = null;
        if (string5 != null) {
            int i2 = afRDLog + 53;
            afWarnLog = i2 % 128;
            if (i2 % 2 == 0) {
                map.put("customData", string5);
                obj.hashCode();
                throw null;
            }
            map.put("customData", string5);
        }
        String string6 = AFInAppEventType().getString(AppsFlyerProperties.APP_USER_ID);
        if (string6 != null) {
            map.put("appUserId", string6);
        }
        String string7 = AFInAppEventType().getString(AppsFlyerProperties.USER_EMAILS);
        if (string7 != null) {
            int i3 = afRDLog + 43;
            afWarnLog = i3 % 128;
            if (i3 % 2 == 0) {
                map.put("user_emails", string7);
                obj.hashCode();
                throw null;
            }
            map.put("user_emails", string7);
        }
        AFc1aSDK aFc1aSDK = this.f390v.AFKeystoreWrapper;
        if (aFc1aSDK != null) {
            int i4 = afRDLog + 91;
            afWarnLog = i4 % 128;
            int i5 = i4 % 2;
            String[] strArr = aFc1aSDK.AFKeystoreWrapper;
            if (strArr != null) {
                int i6 = afRDLog + 13;
                afWarnLog = i6 % 128;
                if (i6 % 2 != 0) {
                    map.put("sharing_filter", strArr);
                } else {
                    map.put("sharing_filter", strArr);
                    int i7 = 32 / 0;
                }
            }
        }
    }

    private String values() throws NoSuchAlgorithmException, PackageManager.NameNotFoundException, CertificateException {
        int i = 2 % 2;
        int i2 = afWarnLog + 99;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        String strAFInAppEventParameterName = AFb1qSDK.AFInAppEventParameterName(this.valueOf.getApplicationContext().getPackageManager(), this.valueOf.getApplicationContext().getPackageName());
        int i4 = afRDLog + 69;
        afWarnLog = i4 % 128;
        if (i4 % 2 != 0) {
            return strAFInAppEventParameterName;
        }
        throw null;
    }

    private static long valueOf() {
        int i = 2 % 2;
        int i2 = afRDLog + 63;
        afWarnLog = i2 % 128;
        long jCurrentTimeMillis = i2 % 2 == 0 ? System.currentTimeMillis() + SystemClock.elapsedRealtime() : System.currentTimeMillis() - SystemClock.elapsedRealtime();
        int i3 = afRDLog + 37;
        afWarnLog = i3 % 128;
        int i4 = i3 % 2;
        return jCurrentTimeMillis;
    }

    @Override
    public final long AFKeystoreWrapper() {
        int i = 2 % 2;
        int i2 = afWarnLog + 57;
        afRDLog = i2 % 128;
        if (i2 % 2 == 0) {
            return System.currentTimeMillis();
        }
        System.currentTimeMillis();
        throw null;
    }

    private static String registerClient() {
        int i = 2 % 2;
        StatFs statFs = new StatFs(Environment.getDataDirectory().getAbsolutePath());
        long blockSizeLong = statFs.getBlockSizeLong();
        long availableBlocksLong = statFs.getAvailableBlocksLong() * blockSizeLong;
        long blockCountLong = statFs.getBlockCountLong() * blockSizeLong;
        int i2 = afRDLog + 89;
        afWarnLog = i2 % 128;
        int i3 = i2 % 2;
        double dPow = Math.pow(2.0d, 20.0d);
        StringBuilder sb = new StringBuilder();
        sb.append((long) (availableBlocksLong / dPow));
        sb.append('/');
        sb.append((long) (blockCountLong / dPow));
        String string = sb.toString();
        int i4 = afWarnLog + 83;
        afRDLog = i4 % 128;
        int i5 = i4 % 2;
        return string;
    }

    private void AFKeystoreWrapper(Map<String, Object> map, boolean z) {
        int i = 2 % 2;
        int i2 = afRDLog + 21;
        afWarnLog = i2 % 128;
        Object obj = null;
        if (i2 % 2 == 0) {
            Intrinsics.checkNotNullParameter(map, "");
            map.put("platformextension", this.afInfoLog.AFInAppEventType());
            throw null;
        }
        Intrinsics.checkNotNullParameter(map, "");
        map.put("platformextension", this.afInfoLog.AFInAppEventType());
        if (z) {
            map.put("platform_extension_v2", this.values.AFInAppEventType());
        }
        int i3 = afRDLog + 11;
        afWarnLog = i3 % 128;
        if (i3 % 2 != 0) {
            return;
        }
        obj.hashCode();
        throw null;
    }

    private void AFInAppEventParameterName(Map<String, Object> map, boolean z) {
        int i = 2 % 2;
        Intrinsics.checkNotNullParameter(map, "");
        HashMap map2 = new HashMap();
        map2.put("cpu_abi", AFInAppEventType("ro.product.cpu.abi"));
        map2.put("cpu_abi2", AFInAppEventType("ro.product.cpu.abi2"));
        map2.put("arch", AFInAppEventType("os.arch"));
        map2.put("build_display_id", AFInAppEventType("ro.build.display.id"));
        if (z) {
            int i2 = afRDLog + 99;
            afWarnLog = i2 % 128;
            if (i2 % 2 == 0) {
                unregisterClient(map2);
                if (this.unregisterClient.AFInAppEventParameterName.valueOf("appsFlyerCount", 0) <= 2) {
                    map2.putAll(this.AFInAppEventType.AFInAppEventType());
                    int i3 = afWarnLog + 125;
                    afRDLog = i3 % 128;
                    int i4 = i3 % 2;
                }
            } else {
                unregisterClient(map2);
                if (this.unregisterClient.AFInAppEventParameterName.valueOf("appsFlyerCount", 0) <= 2) {
                    map2.putAll(this.AFInAppEventType.AFInAppEventType());
                    int i5 = afWarnLog + 125;
                    afRDLog = i5 % 128;
                    int i6 = i5 % 2;
                }
            }
        }
        map2.put("dim", this.AFInAppEventParameterName.AFKeystoreWrapper(this.valueOf));
        map.put("deviceData", map2);
    }

    @Override
    public final void values(Map<String, Object> map) {
        AFh1eSDK aFh1eSDKAFInAppEventParameterName;
        String str;
        int i = 2 % 2;
        Intrinsics.checkNotNullParameter(map, "");
        AFh1cSDK aFh1cSDK = this.registerClient.AFKeystoreWrapper;
        Object obj = null;
        if (aFh1cSDK != null) {
            int i2 = afRDLog + 3;
            afWarnLog = i2 % 128;
            if (i2 % 2 == 0) {
                aFh1cSDK.AFInAppEventParameterName();
                throw null;
            }
            aFh1eSDKAFInAppEventParameterName = aFh1cSDK.AFInAppEventParameterName();
        } else {
            aFh1eSDKAFInAppEventParameterName = null;
        }
        if (aFh1eSDKAFInAppEventParameterName != null) {
            map.put("network", aFh1eSDKAFInAppEventParameterName.values);
            map.put("ivc", Boolean.valueOf(aFh1eSDKAFInAppEventParameterName.AFInAppEventType()));
            if (!(!AFInAppEventType().getBoolean(AppsFlyerProperties.DISABLE_NETWORK_DATA, false))) {
                return;
            }
            int i3 = afWarnLog + 31;
            afRDLog = i3 % 128;
            if (i3 % 2 != 0) {
                str = aFh1eSDKAFInAppEventParameterName.AFKeystoreWrapper;
                int i4 = 60 / 0;
                if (str != null) {
                    map.put("operator", str);
                }
            } else {
                str = aFh1eSDKAFInAppEventParameterName.AFKeystoreWrapper;
                if (str != null) {
                    map.put("operator", str);
                }
            }
            String str2 = aFh1eSDKAFInAppEventParameterName.valueOf;
            if (str2 != null) {
                map.put("carrier", str2);
                int i5 = afRDLog + 11;
                afWarnLog = i5 % 128;
                if (i5 % 2 != 0) {
                    return;
                }
                obj.hashCode();
                throw null;
            }
        }
    }

    @Override
    public final void AFKeystoreWrapper(Map<String, Object> map) {
        boolean z;
        int i = 2 % 2;
        int i2 = afWarnLog + 117;
        afRDLog = i2 % 128;
        if (i2 % 2 != 0) {
            Intrinsics.checkNotNullParameter(map, "");
            AFInAppEventType().getString("advertiserId");
            throw null;
        }
        Intrinsics.checkNotNullParameter(map, "");
        if (AFInAppEventType().getString("advertiserId") == null) {
            int i3 = afWarnLog + 83;
            afRDLog = i3 % 128;
            int i4 = i3 % 2;
            AFb1tSDK.valueOf(this.valueOf, map);
            if (AFInAppEventType().getString("advertiserId") != null) {
                int i5 = afRDLog + 23;
                afWarnLog = i5 % 128;
                int i6 = i5 % 2;
                z = true;
            } else {
                z = false;
            }
            map.put("GAID_retry", String.valueOf(z));
        }
    }

    @Override
    public final void valueOf(Map<String, Object> map, int i, int i2) {
        boolean z;
        int i3 = 2 % 2;
        int i4 = afWarnLog + 19;
        afRDLog = i4 % 128;
        int i5 = i4 % 2;
        Intrinsics.checkNotNullParameter(map, "");
        map.put("counter", String.valueOf(i));
        map.put("iaecounter", String.valueOf(i2));
        if (AFLogger()) {
            z = false;
        } else {
            int i6 = afRDLog + 15;
            afWarnLog = i6 % 128;
            int i7 = i6 % 2;
            z = true;
        }
        map.put("isFirstCall", String.valueOf(z));
    }

    @Override
    public final void valueOf(Map<String, Object> map) throws JSONException {
        int i = 2 % 2;
        Intrinsics.checkNotNullParameter(map, "");
        if (this.f390v.values != null) {
            int i2 = afWarnLog + 57;
            afRDLog = i2 % 128;
            int i3 = i2 % 2;
            if (map.get("af_deeplink") == null) {
                JSONObject jSONObject = new JSONObject(this.f390v.values);
                jSONObject.put("isPush", ServerProtocol.DIALOG_RETURN_SCOPES_TRUE);
                map.put("af_deeplink", jSONObject.toString());
            } else {
                int i4 = afWarnLog + 113;
                afRDLog = i4 % 128;
                int i5 = i4 % 2;
                AFLogger.afDebugLog("Skip 'af' payload as deeplink was found by path");
            }
        }
    }

    @Override
    public final void valueOf(AFa1pSDK aFa1pSDK) {
        boolean z;
        int i = 2 % 2;
        Intrinsics.checkNotNullParameter(aFa1pSDK, "");
        Map<String, Object> mapAFInAppEventType = aFa1pSDK.AFInAppEventType();
        Intrinsics.checkNotNullExpressionValue(mapAFInAppEventType, "");
        mapAFInAppEventType.put("open_referrer", aFa1pSDK.AFInAppEventType);
        String str = aFa1pSDK.f294d;
        if (str != null) {
            int i2 = afRDLog + 43;
            afWarnLog = i2 % 128;
            if (i2 % 2 == 0) {
                StringsKt.isBlank(str);
                Object obj = null;
                obj.hashCode();
                throw null;
            }
            if (StringsKt.isBlank(str)) {
                int i3 = afWarnLog + 33;
                afRDLog = i3 % 128;
                int i4 = i3 % 2;
                z = true;
            } else {
                z = false;
            }
        } else {
            int i5 = afWarnLog + 33;
            afRDLog = i5 % 128;
            int i6 = i5 % 2;
            z = true;
        }
        if (!z) {
            int i7 = afWarnLog + 83;
            afRDLog = i7 % 128;
            int i8 = i7 % 2;
            mapAFInAppEventType.put("af_web_referrer", aFa1pSDK.f294d);
        }
        int i9 = afRDLog + 35;
        afWarnLog = i9 % 128;
        int i10 = i9 % 2;
    }

    private final void unregisterClient(Map<String, Object> map) {
        int i = 2 % 2;
        AFd1vSDK.AFa1ySDK aFa1ySDKAFInAppEventParameterName = this.AFKeystoreWrapper.AFInAppEventParameterName(this.valueOf);
        float f = aFa1ySDKAFInAppEventParameterName.values;
        String str = aFa1ySDKAFInAppEventParameterName.AFKeystoreWrapper;
        map.put("btl", String.valueOf(f));
        if (str != null) {
            int i2 = afWarnLog + 13;
            afRDLog = i2 % 128;
            int i3 = i2 % 2;
            map.put("btch", str);
            if (i3 != 0) {
                Object obj = null;
                obj.hashCode();
                throw null;
            }
        }
        int i4 = afRDLog + 39;
        afWarnLog = i4 % 128;
        int i5 = i4 % 2;
    }

    private void m809e(Map<String, Object> map) {
        int i = 2 % 2;
        int i2 = afRDLog + 87;
        afWarnLog = i2 % 128;
        int i3 = i2 % 2;
        Intrinsics.checkNotNullParameter(map, "");
        String string = AFInAppEventType().getString(AppsFlyerProperties.ONELINK_ID);
        String string2 = AFInAppEventType().getString(AppsFlyerProperties.ONELINK_VERSION);
        Object obj = null;
        if (string != null) {
            int i4 = afWarnLog + 121;
            afRDLog = i4 % 128;
            if (i4 % 2 != 0) {
                map.put("onelink_id", string);
                throw null;
            }
            map.put("onelink_id", string);
        }
        if (string2 != null) {
            int i5 = afRDLog + 123;
            afWarnLog = i5 % 128;
            int i6 = i5 % 2;
            map.put("onelink_ver", string2);
            if (i6 == 0) {
                obj.hashCode();
                throw null;
            }
        }
        int i7 = afRDLog + 119;
        afWarnLog = i7 % 128;
        int i8 = i7 % 2;
    }

    private void m807d(Map<String, ? extends Object> map) {
        int i = 2 % 2;
        Intrinsics.checkNotNullParameter(map, "");
        AFg1bSDK aFg1bSDK = this.f387d;
        HashMap map2 = new HashMap(aFg1bSDK.AFInAppEventType);
        aFg1bSDK.AFInAppEventType.clear();
        this.f387d.AFKeystoreWrapper.AFKeystoreWrapper("gcd");
        Intrinsics.checkNotNullExpressionValue(map2, "");
        boolean z = false;
        if (!map2.isEmpty()) {
            int i2 = afRDLog + 55;
            afWarnLog = i2 % 128;
            if (i2 % 2 != 0) {
                z = true;
            }
        }
        if (!z) {
            return;
        }
        int i3 = afRDLog + 21;
        afWarnLog = i3 % 128;
        int i4 = i3 % 2;
        Map<String, Object> mapAFInAppEventType = AFb1vSDK.AFInAppEventType(map);
        Intrinsics.checkNotNullExpressionValue(mapAFInAppEventType, "");
        mapAFInAppEventType.put("gcd", map2);
    }

    private void AFInAppEventType(Map<String, Object> map, String str) {
        int i = 2 % 2;
        int i2 = afWarnLog + 99;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        Intrinsics.checkNotNullParameter(map, "");
        Intrinsics.checkNotNullParameter(str, "");
        try {
            String strValueOf = this.f388e.valueOf("prev_event_name", (String) null);
            if (strValueOf != null) {
                JSONObject jSONObject = new JSONObject();
                jSONObject.put("prev_event_timestamp", this.f388e.AFInAppEventType("prev_event_timestamp", -1L));
                jSONObject.put("prev_event_name", strValueOf);
                map.put("prev_event", jSONObject);
            }
            this.f388e.values("prev_event_name", str);
            this.f388e.AFInAppEventParameterName("prev_event_timestamp", System.currentTimeMillis());
            int i4 = afRDLog + 3;
            afWarnLog = i4 % 128;
            if (i4 % 2 == 0) {
                int i5 = 5 / 0;
            }
        } catch (Exception e) {
            AFLogger.afErrorLog("Error while processing previous event.", e);
        }
    }

    private String m808e() {
        int i = 2 % 2;
        int i2 = afRDLog + 33;
        afWarnLog = i2 % 128;
        String strM806d = null;
        if (i2 % 2 != 0) {
            if (!this.f388e.AFInAppEventParameterName("INSTALL_STORE")) {
                strM806d = unregisterClient() ? m806d() : null;
                this.f388e.values("INSTALL_STORE", strM806d);
                return strM806d;
            }
            int i3 = afWarnLog + 113;
            afRDLog = i3 % 128;
            if (i3 % 2 == 0) {
                return this.f388e.valueOf("INSTALL_STORE", (String) null);
            }
            this.f388e.valueOf("INSTALL_STORE", (String) null);
            strM806d.hashCode();
            throw null;
        }
        this.f388e.AFInAppEventParameterName("INSTALL_STORE");
        strM806d.hashCode();
        throw null;
    }

    private String m806d() {
        int i = 2 % 2;
        String string = AFInAppEventType().getString(AppsFlyerProperties.AF_STORE_FROM_API);
        if (string == null) {
            int i2 = afRDLog + 97;
            afWarnLog = i2 % 128;
            int i3 = i2 % 2;
            string = valueOf("AF_STORE");
        }
        int i4 = afWarnLog + 85;
        afRDLog = i4 % 128;
        if (i4 % 2 == 0) {
            return string;
        }
        Object obj = null;
        obj.hashCode();
        throw null;
    }

    private String AFKeystoreWrapper(SimpleDateFormat simpleDateFormat) {
        int i = 2 % 2;
        Intrinsics.checkNotNullParameter(simpleDateFormat, "");
        String strValueOf = this.f388e.valueOf("appsFlyerFirstInstall", (String) null);
        if (strValueOf == null) {
            int i2 = afRDLog + 73;
            afWarnLog = i2 % 128;
            if (i2 % 2 == 0) {
                unregisterClient();
                throw null;
            }
            if (unregisterClient()) {
                AFLogger.afDebugLog("AppsFlyer: first launch detected");
                strValueOf = simpleDateFormat.format(new Date());
            } else {
                int i3 = afWarnLog + 9;
                afRDLog = i3 % 128;
                int i4 = i3 % 2;
                strValueOf = "";
            }
            this.f388e.values("appsFlyerFirstInstall", strValueOf);
        }
        AFg1mSDK.i$default(AFLogger.INSTANCE, AFg1hSDK.GENERAL, "AppsFlyer: first launch date: ".concat(String.valueOf(strValueOf)), false, 4, null);
        Intrinsics.checkNotNullExpressionValue(strValueOf, "");
        return strValueOf;
    }

    private boolean unregisterClient() {
        int i = 2 % 2;
        int i2 = afRDLog + 111;
        afWarnLog = i2 % 128;
        int i3 = i2 % 2;
        if (!this.f388e.AFInAppEventParameterName("appsFlyerCount")) {
            int i4 = afRDLog + 31;
            afWarnLog = i4 % 128;
            return i4 % 2 != 0;
        }
        int i5 = afRDLog + 95;
        afWarnLog = i5 % 128;
        if (i5 % 2 != 0) {
            return false;
        }
        Object obj = null;
        obj.hashCode();
        throw null;
    }

    private boolean AFLogger() {
        int i = 2 % 2;
        int i2 = afWarnLog + 87;
        afRDLog = i2 % 128;
        Object obj = null;
        if (i2 % 2 != 0) {
            Boolean.parseBoolean(this.f388e.valueOf("sentSuccessfully", (String) null));
            throw null;
        }
        boolean z = Boolean.parseBoolean(this.f388e.valueOf("sentSuccessfully", (String) null));
        int i3 = afWarnLog + 123;
        afRDLog = i3 % 128;
        if (i3 % 2 == 0) {
            return z;
        }
        obj.hashCode();
        throw null;
    }

    private String m810i() {
        String strValueOf;
        int i = 2 % 2;
        int i2 = afRDLog + 53;
        afWarnLog = i2 % 128;
        Object obj = null;
        if (i2 % 2 != 0) {
            String string = AFInAppEventType().getString("preInstallName");
            if (string == null) {
                if (this.f388e.AFInAppEventParameterName("preInstallName")) {
                    int i3 = afWarnLog + 113;
                    afRDLog = i3 % 128;
                    if (i3 % 2 != 0) {
                        this.f388e.valueOf("preInstallName", (String) null);
                        throw null;
                    }
                    strValueOf = this.f388e.valueOf("preInstallName", (String) null);
                } else {
                    if (unregisterClient()) {
                        int i4 = afRDLog + 97;
                        afWarnLog = i4 % 128;
                        int i5 = i4 % 2;
                        string = m814w();
                        if (string == null) {
                            int i6 = afRDLog + 71;
                            afWarnLog = i6 % 128;
                            int i7 = i6 % 2;
                            string = valueOf("AF_PRE_INSTALL_NAME");
                        }
                    }
                    if (string != null) {
                        int i8 = afRDLog + 115;
                        afWarnLog = i8 % 128;
                        if (i8 % 2 == 0) {
                            this.f388e.values("preInstallName", string);
                            int i9 = 92 / 0;
                        } else {
                            this.f388e.values("preInstallName", string);
                        }
                    }
                    strValueOf = string;
                }
                if (strValueOf != null) {
                    AFInAppEventType().set("preInstallName", strValueOf);
                }
                return strValueOf;
            }
            int i10 = afRDLog + 87;
            afWarnLog = i10 % 128;
            if (i10 % 2 != 0) {
                return string;
            }
            obj.hashCode();
            throw null;
        }
        AFInAppEventType().getString("preInstallName");
        throw null;
    }

    private void valueOf(Map<String, Object> map, String str) {
        int i = 2 % 2;
        Intrinsics.checkNotNullParameter(map, "");
        if (AFInAppEventType().getBoolean(AppsFlyerProperties.DEVICE_TRACKING_DISABLED, false)) {
            int i2 = afWarnLog + 83;
            afRDLog = i2 % 128;
            if (i2 % 2 == 0) {
                map.put(AppsFlyerProperties.DEVICE_TRACKING_DISABLED, ServerProtocol.DIALOG_RETURN_SCOPES_TRUE);
                return;
            } else {
                map.put(AppsFlyerProperties.DEVICE_TRACKING_DISABLED, ServerProtocol.DIALOG_RETURN_SCOPES_TRUE);
                throw null;
            }
        }
        Object objValueOf = this.AFLogger.valueOf(this.f388e);
        String str2 = (CharSequence) objValueOf;
        if (str2 != null && str2.length() != 0) {
            int i3 = afRDLog + 37;
            afWarnLog = i3 % 128;
            if (i3 % 2 == 0) {
                map.put("imei", objValueOf);
                throw null;
            }
            map.put("imei", objValueOf);
            int i4 = afWarnLog + 119;
            afRDLog = i4 % 128;
            if (i4 % 2 != 0) {
                int i5 = 4 / 3;
            }
        }
        String strAFInAppEventParameterName = AFInAppEventParameterName(str);
        if (strAFInAppEventParameterName != null) {
            this.f388e.values("androidIdCached", strAFInAppEventParameterName);
            map.put("android_id", strAFInAppEventParameterName);
        } else {
            AFLogger.afInfoLog("Android ID was not collected.");
        }
        AFa1aSDK aFa1aSDKAFInAppEventParameterName = AFb1tSDK.AFInAppEventParameterName(this.valueOf);
        if (aFa1aSDKAFInAppEventParameterName != null) {
            LinkedHashMap linkedHashMap = new LinkedHashMap();
            Boolean bool = aFa1aSDKAFInAppEventParameterName.values;
            Intrinsics.checkNotNullExpressionValue(bool, "");
            linkedHashMap.put("isManual", bool);
            String str3 = aFa1aSDKAFInAppEventParameterName.valueOf;
            Intrinsics.checkNotNullExpressionValue(str3, "");
            linkedHashMap.put("val", str3);
            Boolean bool2 = aFa1aSDKAFInAppEventParameterName.AFInAppEventType;
            if (bool2 != null) {
                linkedHashMap.put("isLat", bool2);
            }
            map.put("oaid", linkedHashMap);
        }
    }

    private final String AFInAppEventParameterName(String str) {
        int i;
        int i2 = 2 % 2;
        if (AFInAppEventType().getBoolean(AppsFlyerProperties.COLLECT_ANDROID_ID, false)) {
            String str2 = str;
            if (str2 != null) {
                int i3 = afWarnLog + 85;
                afRDLog = i3 % 128;
                int i4 = i3 % 2;
                if (str2.length() != 0) {
                    if (str != null) {
                        i = afRDLog + 85;
                        afWarnLog = i % 128;
                        if (i % 2 == 0) {
                            return str;
                        }
                        int i5 = 82 / 0;
                        return str;
                    }
                }
            }
            int i6 = afRDLog + 99;
            afWarnLog = i6 % 128;
            int i7 = i6 % 2;
            if (force()) {
                return m812v();
            }
        } else if (str != null) {
            i = afRDLog + 85;
            afWarnLog = i % 128;
            if (i % 2 == 0) {
                return str;
            }
            int i8 = 82 / 0;
            return str;
        }
        return null;
    }

    private final String m812v() {
        int i = 2 % 2;
        String strValueOf = this.f388e.valueOf("androidIdCached", (String) null);
        try {
            String string = Settings.Secure.getString(this.valueOf.getContentResolver(), "android_id");
            if (string != null) {
                int i2 = afWarnLog + 17;
                afRDLog = i2 % 128;
                int i3 = i2 % 2;
                return string;
            }
        } catch (Exception e) {
            AFLogger.afErrorLog(e.getMessage(), e);
        }
        if (strValueOf == null) {
            return null;
        }
        int i4 = afRDLog + 119;
        afWarnLog = i4 % 128;
        int i5 = i4 % 2;
        AFLogger.afDebugLog("use cached AndroidId: ".concat(String.valueOf(strValueOf)));
        return strValueOf;
    }

    private static void AFLogger(Map<String, Object> map) {
        int i = 2 % 2;
        int i2 = afWarnLog + 17;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        Intrinsics.checkNotNullParameter(map, "");
        Object[] objArr = new Object[1];
        m805a("ᐕᑷ勀\udb91뇐㵓в\ufe1d꯵", Color.argb(0, 0, 0, 0) + 1, objArr);
        map.put(((String) objArr[0]).intern(), Build.BRAND);
        map.put(DeviceRequestsHelper.DEVICE_INFO_DEVICE, Build.DEVICE);
        map.put("product", Build.PRODUCT);
        map.put(ServerProtocol.DIALOG_PARAM_SDK_VERSION, String.valueOf(Build.VERSION.SDK_INT));
        map.put(DeviceRequestsHelper.DEVICE_INFO_MODEL, Build.MODEL);
        map.put("deviceType", Build.TYPE);
        int i4 = afWarnLog + 43;
        afRDLog = i4 % 128;
        int i5 = i4 % 2;
    }

    private void values(Map<String, Object> map, String str, String str2, AFc1bSDK aFc1bSDK) {
        int i = 2 % 2;
        Intrinsics.checkNotNullParameter(map, "");
        if (unregisterClient()) {
            int i2 = afRDLog + 123;
            afWarnLog = i2 % 128;
            if (i2 % 2 == 0) {
                afInfoLog(map);
                m811i(map);
                m813v(map);
                AFc1vSDK.AFKeystoreWrapper(this.f389i, this.f388e);
                int i3 = 20 / 0;
            } else {
                afInfoLog(map);
                m811i(map);
                m813v(map);
                AFc1vSDK.AFKeystoreWrapper(this.f389i, this.f388e);
            }
        }
        m815w(map);
        m809e(map);
        m807d(map);
        AFInAppEventParameterName(map, str2);
        AFKeystoreWrapper(map, str);
        force(map);
        if (aFc1bSDK != null) {
            int i4 = afRDLog + 7;
            afWarnLog = i4 % 128;
            int i5 = i4 % 2;
            aFc1bSDK.values(map);
            int i6 = afRDLog + 95;
            afWarnLog = i6 % 128;
            if (i6 % 2 == 0) {
                throw null;
            }
        }
    }

    private final void afInfoLog(Map<String, Object> map) {
        int i = 2 % 2;
        int i2 = afWarnLog + 3;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        if (AFInAppEventType().isOtherSdkStringDisabled()) {
            return;
        }
        int i4 = afWarnLog + 79;
        afRDLog = i4 % 128;
        if (i4 % 2 == 0) {
            map.put("batteryLevel", String.valueOf(this.AFKeystoreWrapper.AFInAppEventParameterName(this.valueOf).values));
        } else {
            map.put("batteryLevel", String.valueOf(this.AFKeystoreWrapper.AFInAppEventParameterName(this.valueOf).values));
            int i5 = 62 / 0;
        }
    }

    private final void m811i(Map<String, Object> map) {
        int i = 2 % 2;
        UiModeManager uiModeManager = (UiModeManager) this.valueOf.getSystemService(UiModeManager.class);
        if (uiModeManager != null && uiModeManager.getCurrentModeType() == 4) {
            int i2 = afWarnLog + 37;
            afRDLog = i2 % 128;
            int i3 = i2 % 2;
            map.put("tv", Boolean.TRUE);
        }
        int i4 = afRDLog + 27;
        afWarnLog = i4 % 128;
        if (i4 % 2 == 0) {
            int i5 = 8 / 0;
        }
    }

    private final void m813v(Map<String, Object> map) {
        int i = 2 % 2;
        if (AFg1iSDK.AFKeystoreWrapper(this.valueOf)) {
            int i2 = afWarnLog + 107;
            afRDLog = i2 % 128;
            int i3 = i2 % 2;
            map.put("inst_app", Boolean.TRUE);
            int i4 = afWarnLog + 39;
            afRDLog = i4 % 128;
            int i5 = i4 % 2;
        }
    }

    private void m815w(Map<String, Object> map) {
        long jAFInAppEventType;
        long jCurrentTimeMillis;
        long seconds;
        int i;
        int i2 = 2 % 2;
        int i3 = afRDLog + 57;
        afWarnLog = i3 % 128;
        if (i3 % 2 == 0) {
            Intrinsics.checkNotNullParameter(map, "");
            jAFInAppEventType = this.f388e.AFInAppEventType("AppsFlyerTimePassedSincePrevLaunch", 1L);
            jCurrentTimeMillis = System.currentTimeMillis();
            this.f388e.AFInAppEventParameterName("AppsFlyerTimePassedSincePrevLaunch", jCurrentTimeMillis);
            if (jAFInAppEventType > 0) {
                seconds = TimeUnit.MILLISECONDS.toSeconds(jCurrentTimeMillis - jAFInAppEventType);
                i = afWarnLog + 93;
                afRDLog = i % 128;
                if (i % 2 != 0) {
                    int i4 = 2 / 3;
                }
            } else {
                seconds = -1;
            }
        } else {
            Intrinsics.checkNotNullParameter(map, "");
            jAFInAppEventType = this.f388e.AFInAppEventType("AppsFlyerTimePassedSincePrevLaunch", 0L);
            jCurrentTimeMillis = System.currentTimeMillis();
            this.f388e.AFInAppEventParameterName("AppsFlyerTimePassedSincePrevLaunch", jCurrentTimeMillis);
            if (jAFInAppEventType > 0) {
                seconds = TimeUnit.MILLISECONDS.toSeconds(jCurrentTimeMillis - jAFInAppEventType);
                i = afWarnLog + 93;
                afRDLog = i % 128;
                if (i % 2 != 0) {
                    int i5 = 2 / 3;
                }
            } else {
                seconds = -1;
            }
        }
        map.put("timepassedsincelastlaunch", String.valueOf(seconds));
        int i6 = afRDLog + 39;
        afWarnLog = i6 % 128;
        if (i6 % 2 == 0) {
            throw null;
        }
    }

    private static void AFInAppEventParameterName(Map<String, Object> map, String str) {
        int i = 2 % 2;
        int i2 = afWarnLog + 7;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        Intrinsics.checkNotNullParameter(map, "");
        if (str != null) {
            map.put("phone", str);
            int i4 = afWarnLog + 61;
            afRDLog = i4 % 128;
            int i5 = i4 % 2;
        }
        int i6 = afRDLog + 123;
        afWarnLog = i6 % 128;
        if (i6 % 2 == 0) {
            int i7 = 70 / 0;
        }
    }

    private void AFKeystoreWrapper(Map<String, Object> map, String str) {
        int i = 2 % 2;
        int i2 = afRDLog + 55;
        afWarnLog = i2 % 128;
        int i3 = i2 % 2;
        Intrinsics.checkNotNullParameter(map, "");
        String str2 = str;
        if (str2 != null && str2.length() != 0) {
            map.put("referrer", str);
        }
        String strValueOf = this.f388e.valueOf("extraReferrers", (String) null);
        if (strValueOf != null) {
            map.put("extraReferrers", strValueOf);
            int i4 = afWarnLog + 41;
            afRDLog = i4 % 128;
            if (i4 % 2 != 0) {
                int i5 = 4 % 3;
            }
        }
        String referrer = AFInAppEventType().getReferrer(this.f388e);
        String str3 = referrer;
        if (str3 != null) {
            int i6 = afRDLog + 93;
            afWarnLog = i6 % 128;
            int i7 = i6 % 2;
            if (str3.length() == 0) {
                return;
            }
            int i8 = afWarnLog + 7;
            afRDLog = i8 % 128;
            if (i8 % 2 != 0) {
                map.get("referrer");
                throw null;
            }
            if (map.get("referrer") == null) {
                map.put("referrer", referrer);
            }
        }
    }

    private void force(Map<String, Object> map) {
        long j;
        int i = 2 % 2;
        int i2 = afWarnLog + 99;
        afRDLog = i2 % 128;
        if (i2 % 2 != 0) {
            Intrinsics.checkNotNullParameter(map, "");
            j = this.f387d.f379i;
            if (j == 0) {
                return;
            }
        } else {
            Intrinsics.checkNotNullParameter(map, "");
            j = this.f387d.f379i;
            if (j == 0) {
                return;
            }
        }
        map.put("prev_session_dur", Long.valueOf(j));
        int i3 = afRDLog + 71;
        afWarnLog = i3 % 128;
        int i4 = i3 % 2;
    }

    private static void afVerboseLog(Map<String, Object> map) {
        int i = 2 % 2;
        int i2 = afRDLog + 53;
        afWarnLog = i2 % 128;
        int i3 = i2 % 2;
        Intrinsics.checkNotNullParameter(map, "");
        AFc1vSDK aFc1vSDK = AFc1vSDK.INSTANCE;
        Object objAFInAppEventParameterName = AFc1vSDK.AFInAppEventParameterName();
        AFc1vSDK aFc1vSDK2 = AFc1vSDK.INSTANCE;
        String strAFKeystoreWrapper = AFc1vSDK.AFKeystoreWrapper();
        if (objAFInAppEventParameterName != null) {
            int i4 = afWarnLog + 67;
            afRDLog = i4 % 128;
            int i5 = i4 % 2;
            if (strAFKeystoreWrapper == null || Integer.parseInt(strAFKeystoreWrapper) <= 0) {
                return;
            }
            int i6 = afRDLog + 95;
            afWarnLog = i6 % 128;
            if (i6 % 2 != 0) {
                map.put("reinstallCounter", strAFKeystoreWrapper);
                map.put("originalAppsflyerId", objAFInAppEventParameterName);
            } else {
                map.put("reinstallCounter", strAFKeystoreWrapper);
                map.put("originalAppsflyerId", objAFInAppEventParameterName);
                Object obj = null;
                obj.hashCode();
                throw null;
            }
        }
    }

    private void afErrorLog(Map<String, Object> map) {
        int i = 2 % 2;
        int i2 = afWarnLog + 39;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        Intrinsics.checkNotNullParameter(map, "");
        map.putAll(this.f391w.AFInAppEventParameterName());
        int i4 = afRDLog + 81;
        afWarnLog = i4 % 128;
        if (i4 % 2 == 0) {
            int i5 = 87 / 0;
        }
    }

    private void afWarnLog(Map<String, Object> map) {
        int i = 2 % 2;
        int i2 = afRDLog + 25;
        afWarnLog = i2 % 128;
        int i3 = i2 % 2;
        Intrinsics.checkNotNullParameter(map, "");
        String string = AFInAppEventType().getString(AppsFlyerProperties.EXTENSION);
        String str = string;
        if (str == null || str.length() == 0) {
            return;
        }
        int i4 = afWarnLog + 115;
        afRDLog = i4 % 128;
        int i5 = i4 % 2;
        map.put(AppsFlyerProperties.EXTENSION, string);
    }

    private void afRDLog(Map<String, Object> map) {
        int i = 2 % 2;
        int i2 = afWarnLog + 47;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        Intrinsics.checkNotNullParameter(map, "");
        String strValues = this.unregisterClient.values();
        String strValueOf = valueOf(this.f388e, strValues);
        boolean z = false;
        boolean z2 = (strValueOf == null || Intrinsics.areEqual(strValueOf, strValues)) ? false : true;
        if (strValueOf == null) {
            int i4 = afWarnLog + 87;
            afRDLog = i4 % 128;
            int i5 = i4 % 2;
            if (strValues != null) {
                z = true;
            }
        }
        if (!z2) {
            int i6 = afWarnLog + 27;
            afRDLog = i6 % 128;
            int i7 = i6 % 2;
            if (z) {
                map.put("af_latestchannel", strValues);
            }
        } else {
            map.put("af_latestchannel", strValues);
        }
        String strM808e = m808e();
        if (strM808e != null) {
            Locale locale = Locale.getDefault();
            Intrinsics.checkNotNullExpressionValue(locale, "");
            Object lowerCase = strM808e.toLowerCase(locale);
            Intrinsics.checkNotNullExpressionValue(lowerCase, "");
            map.put("af_installstore", lowerCase);
        }
        String strM810i = m810i();
        if (strM810i != null) {
            Locale locale2 = Locale.getDefault();
            Intrinsics.checkNotNullExpressionValue(locale2, "");
            Object lowerCase2 = strM810i.toLowerCase(locale2);
            Intrinsics.checkNotNullExpressionValue(lowerCase2, "");
            map.put("af_preinstall_name", lowerCase2);
        }
        String strM806d = m806d();
        if (strM806d != null) {
            int i8 = afRDLog + 125;
            afWarnLog = i8 % 128;
            int i9 = i8 % 2;
            Locale locale3 = Locale.getDefault();
            Intrinsics.checkNotNullExpressionValue(locale3, "");
            Object lowerCase3 = strM806d.toLowerCase(locale3);
            Intrinsics.checkNotNullExpressionValue(lowerCase3, "");
            map.put("af_currentstore", lowerCase3);
        }
    }

    private static void AFInAppEventType(Map<String, Object> map, boolean z) {
        int i = 2 % 2;
        int i2 = afWarnLog + 63;
        afRDLog = i2 % 128;
        if (i2 % 2 == 0) {
            Intrinsics.checkNotNullParameter(map, "");
            map.put("af_preinstalled", String.valueOf(z));
        } else {
            Intrinsics.checkNotNullParameter(map, "");
            map.put("af_preinstalled", String.valueOf(z));
            Object obj = null;
            obj.hashCode();
            throw null;
        }
    }

    private static void afDebugLog(Map<String, Object> map) {
        int i = 2 % 2;
        int i2 = afWarnLog + 3;
        afRDLog = i2 % 128;
        try {
            if (i2 % 2 != 0) {
                Intrinsics.checkNotNullParameter(map, "");
                map.put("lang", Locale.getDefault().getDisplayLanguage());
                throw null;
            }
            Intrinsics.checkNotNullParameter(map, "");
            map.put("lang", Locale.getDefault().getDisplayLanguage());
            try {
                map.put("lang_code", Locale.getDefault().getLanguage());
                int i3 = afWarnLog + 29;
                afRDLog = i3 % 128;
                int i4 = i3 % 2;
            } catch (Exception e) {
                AFLogger.afErrorLog("Exception while collecting display language code. ", e);
            }
            try {
                map.put(UserDataStore.COUNTRY, Locale.getDefault().getCountry());
            } catch (Exception e2) {
                AFLogger.afErrorLog("Exception while collecting country name. ", e2);
            }
        } catch (Exception e3) {
            AFLogger.afErrorLog("Exception while collecting display language name. ", e3);
        }
    }

    private void AFVersionDeclaration(Map<String, Object> map) {
        int i = 2 % 2;
        int i2 = afWarnLog + 79;
        afRDLog = i2 % 128;
        try {
            if (i2 % 2 != 0) {
                Intrinsics.checkNotNullParameter(map, "");
                AFb1lSDK.values(this.f389i, this.f388e);
                throw null;
            }
            Intrinsics.checkNotNullParameter(map, "");
            String strValues = AFb1lSDK.values(this.f389i, this.f388e);
            if (strValues != null) {
                int i3 = afRDLog + 81;
                afWarnLog = i3 % 128;
                if (i3 % 2 != 0) {
                    map.put("uid", strValues);
                    return;
                } else {
                    map.put("uid", strValues);
                    int i4 = 29 / 0;
                    return;
                }
            }
            int i5 = afWarnLog + 21;
            afRDLog = i5 % 128;
            int i6 = i5 % 2;
        } catch (Throwable th) {
            StringBuilder sb = new StringBuilder("ERROR: could not get uid ");
            sb.append(th.getMessage());
            String string = sb.toString();
            Intrinsics.checkNotNullExpressionValue(string, "");
            AFLogger.afErrorLog(string, th);
        }
    }

    private void AFLogger$LogLevel(Map<String, Object> map) {
        int i = 2 % 2;
        int i2 = afRDLog + TypedValues.TYPE_TARGET;
        afWarnLog = i2 % 128;
        if (i2 % 2 == 0) {
            Intrinsics.checkNotNullParameter(map, "");
            AFLogger.afDebugLog("didConfigureTokenRefreshService=".concat(String.valueOf(AFg1tSDK.valueOf(this.valueOf))));
            Object obj = null;
            obj.hashCode();
            throw null;
        }
        Intrinsics.checkNotNullParameter(map, "");
        boolean zValueOf = AFg1tSDK.valueOf(this.valueOf);
        AFLogger.afDebugLog("didConfigureTokenRefreshService=".concat(String.valueOf(zValueOf)));
        if (!zValueOf) {
            map.put("tokenRefreshConfigured", Boolean.FALSE);
            int i3 = afRDLog + 81;
            afWarnLog = i3 % 128;
            int i4 = i3 % 2;
        }
        map.put("registeredUninstall", Boolean.valueOf(AFg1tSDK.values(this.f388e)));
    }

    private void afErrorLogForExcManagerOnly(Map<String, Object> map) {
        int i = 2 % 2;
        int i2 = afWarnLog + 33;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        Intrinsics.checkNotNullParameter(map, "");
        AFa1aSDK aFa1aSDKAFInAppEventType = AFb1tSDK.AFInAppEventType(this.valueOf.getContentResolver());
        if (aFa1aSDKAFInAppEventType != null) {
            int i4 = afRDLog + 49;
            afWarnLog = i4 % 128;
            int i5 = i4 % 2;
            map.put("amazon_aid", aFa1aSDKAFInAppEventType.valueOf);
            map.put("amazon_aid_limit", String.valueOf(aFa1aSDKAFInAppEventType.AFInAppEventType));
            int i6 = afRDLog + 9;
            afWarnLog = i6 % 128;
            int i7 = i6 % 2;
        }
    }

    private void afLogForce(Map<String, Object> map) {
        int i = 2 % 2;
        int i2 = afWarnLog + 107;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        Intrinsics.checkNotNullParameter(map, "");
        if (this.f388e.AFInAppEventParameterName("is_stop_tracking_used")) {
            int i4 = afWarnLog + 19;
            afRDLog = i4 % 128;
            if (i4 % 2 == 0) {
                map.put("istu", String.valueOf(this.f388e.valueOf("is_stop_tracking_used")));
            } else {
                map.put("istu", String.valueOf(this.f388e.valueOf("is_stop_tracking_used")));
                int i5 = 30 / 0;
            }
        }
    }

    private void getLevel(Map<String, Object> map) {
        int i = 2 % 2;
        Intrinsics.checkNotNullParameter(map, "");
        String str = this.AFLogger.registerClient;
        String str2 = str;
        if (str2 != null) {
            int i2 = afWarnLog + 87;
            afRDLog = i2 % 128;
            Object obj = null;
            if (i2 % 2 != 0) {
                str2.length();
                obj.hashCode();
                throw null;
            }
            if (str2.length() == 0) {
                return;
            }
            int i3 = afWarnLog + 83;
            afRDLog = i3 % 128;
            int i4 = i3 % 2;
            map.put("appsflyerKey", str);
            if (i4 != 0) {
                throw null;
            }
            int i5 = afRDLog + 125;
            afWarnLog = i5 % 128;
            int i6 = i5 % 2;
        }
    }

    private void AFInAppEventParameterName(Map<String, Object> map, Function0<String> function0) {
        String str;
        Object objInvoke;
        int i = 2 % 2;
        int i2 = afWarnLog + 99;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        Intrinsics.checkNotNullParameter(map, "");
        Intrinsics.checkNotNullParameter(function0, "");
        Object obj = null;
        if (AFInAppEventType().getBoolean(AppsFlyerProperties.COLLECT_FACEBOOK_ATTR_ID, true)) {
            int i4 = afRDLog + 107;
            afWarnLog = i4 % 128;
            try {
                if (i4 % 2 == 0) {
                    this.valueOf.getPackageManager().getApplicationInfo("com.facebook.katana", 0);
                    objInvoke = function0.invoke();
                } else {
                    this.valueOf.getPackageManager().getApplicationInfo("com.facebook.katana", 0);
                    objInvoke = function0.invoke();
                }
                str = (String) objInvoke;
            } catch (PackageManager.NameNotFoundException e) {
                AFLogger.afErrorLogForExcManagerOnly("com.facebook.katana not found", e, true);
                AFLogger.afWarnLog("Exception while collecting facebook's attribution ID. ");
                str = null;
            } catch (Throwable th) {
                AFLogger.afErrorLog("Exception while collecting facebook's attribution ID. ", th);
                str = null;
            }
            if (str != null) {
                int i5 = afRDLog + 65;
                afWarnLog = i5 % 128;
                if (i5 % 2 == 0) {
                    map.put("fb", str);
                    throw null;
                }
                map.put("fb", str);
            }
        }
        int i6 = afWarnLog + 63;
        afRDLog = i6 % 128;
        if (i6 % 2 == 0) {
            return;
        }
        obj.hashCode();
        throw null;
    }

    private static String valueOf(AFd1xSDK aFd1xSDK, String str) {
        int i = 2 % 2;
        int i2 = afRDLog + 75;
        afWarnLog = i2 % 128;
        Object obj = null;
        if (i2 % 2 != 0) {
            String strValueOf = aFd1xSDK.valueOf("CACHED_CHANNEL", (String) null);
            if (strValueOf != null) {
                int i3 = afWarnLog + 1;
                afRDLog = i3 % 128;
                int i4 = i3 % 2;
                return strValueOf;
            }
            aFd1xSDK.values("CACHED_CHANNEL", str);
            int i5 = afWarnLog + 57;
            afRDLog = i5 % 128;
            int i6 = i5 % 2;
            return str;
        }
        aFd1xSDK.valueOf("CACHED_CHANNEL", (String) null);
        obj.hashCode();
        throw null;
    }

    private static String AFInAppEventType(String str) {
        int i = 2 % 2;
        int i2 = afWarnLog + 19;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        Object obj = null;
        try {
            Object objInvoke = Class.forName("android.os.SystemProperties").getMethod("get", String.class).invoke(null, str);
            if (objInvoke != null) {
                String str2 = (String) objInvoke;
                int i4 = afRDLog + 49;
                afWarnLog = i4 % 128;
                if (i4 % 2 != 0) {
                    return str2;
                }
                obj.hashCode();
                throw null;
            }
            throw new NullPointerException("null cannot be cast to non-null type kotlin.String");
        } catch (Throwable th) {
            AFLogger.afErrorLog(th.getMessage(), th);
            return null;
        }
    }

    private final String valueOf(String str) {
        int i = 2 % 2;
        int i2 = afWarnLog + 93;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        String strValues = this.unregisterClient.values(str);
        int i4 = afWarnLog + 99;
        afRDLog = i4 % 128;
        int i5 = i4 % 2;
        return strValues;
    }

    private final String m814w() {
        int i = 2 % 2;
        File fileValues = values(AFInAppEventType("ro.appsflyer.preinstall.path"));
        Object obj = null;
        if (values(fileValues)) {
            int i2 = afRDLog + 27;
            afWarnLog = i2 % 128;
            if (i2 % 2 == 0) {
                values(valueOf("AF_PRE_INSTALL_PATH"));
                obj.hashCode();
                throw null;
            }
            fileValues = values(valueOf("AF_PRE_INSTALL_PATH"));
        }
        if (values(fileValues)) {
            fileValues = values("/data/local/tmp/pre_install.appsflyer");
        }
        if (values(fileValues)) {
            fileValues = values("/etc/pre_install.appsflyer");
        }
        if (values(fileValues)) {
            int i3 = afRDLog + 33;
            afWarnLog = i3 % 128;
            int i4 = i3 % 2;
            return null;
        }
        String packageName = this.valueOf.getPackageName();
        Intrinsics.checkNotNullExpressionValue(packageName, "");
        String strAFInAppEventType = AFInAppEventType(fileValues, packageName);
        int i5 = afWarnLog + 103;
        afRDLog = i5 % 128;
        int i6 = i5 % 2;
        return strAFInAppEventType;
    }

    private static File values(String str) {
        int i = 2 % 2;
        int i2 = afWarnLog + 43;
        afRDLog = i2 % 128;
        try {
            if (i2 % 2 == 0) {
                if (str != null && StringsKt.trim(str).toString().length() > 0) {
                    return new File(StringsKt.trim(str).toString());
                }
                int i3 = afRDLog + 103;
                afWarnLog = i3 % 128;
                if (i3 % 2 != 0) {
                    return null;
                }
                throw null;
            }
            throw null;
        } catch (Throwable th) {
            AFLogger.afErrorLog(th.getMessage(), th);
        }
    }

    private static boolean values(File file) {
        int i = 2 % 2;
        int i2 = afWarnLog;
        int i3 = i2 + 61;
        afRDLog = i3 % 128;
        int i4 = i3 % 2;
        if (file != null) {
            int i5 = i2 + 19;
            afRDLog = i5 % 128;
            if (i5 % 2 != 0) {
                file.exists();
                Object obj = null;
                obj.hashCode();
                throw null;
            }
            if (!(!file.exists())) {
                return false;
            }
        }
        return true;
    }

    private static String AFInAppEventType(File file, String str) {
        InputStreamReader inputStreamReader;
        int i = 2 % 2;
        int i2 = afRDLog + 113;
        afWarnLog = i2 % 128;
        Object obj = null;
        if (i2 % 2 == 0) {
            obj.hashCode();
            throw null;
        }
        try {
            try {
                if (file == null) {
                    return null;
                }
                try {
                    Properties properties = new Properties();
                    inputStreamReader = new InputStreamReader(new FileInputStream(file), Charset.defaultCharset());
                    try {
                        properties.load(inputStreamReader);
                        AFLogger.afInfoLog("Found PreInstall property!");
                        String property = properties.getProperty(str);
                        try {
                            inputStreamReader.close();
                        } catch (Throwable th) {
                            AFLogger.afErrorLog(th.getMessage(), th);
                        }
                        return property;
                    } catch (FileNotFoundException unused) {
                        StringBuilder sb = new StringBuilder("PreInstall file wasn't found: ");
                        sb.append(file.getAbsolutePath());
                        AFLogger.afDebugLog(sb.toString());
                        if (inputStreamReader != null) {
                            inputStreamReader.close();
                            int i3 = afRDLog + 59;
                            afWarnLog = i3 % 128;
                            int i4 = i3 % 2;
                        }
                        int i5 = afRDLog + 69;
                        afWarnLog = i5 % 128;
                        int i6 = i5 % 2;
                        return null;
                    } catch (Throwable th2) {
                        th = th2;
                        AFLogger.afErrorLog(th.getMessage(), th);
                        if (inputStreamReader != null) {
                            inputStreamReader.close();
                        }
                        int i7 = afRDLog + 69;
                        afWarnLog = i7 % 128;
                        int i8 = i7 % 2;
                        return null;
                    }
                } catch (FileNotFoundException unused2) {
                    inputStreamReader = null;
                } catch (Throwable th3) {
                    th = th3;
                    inputStreamReader = null;
                }
            } catch (Throwable th4) {
                AFLogger.afErrorLog(th4.getMessage(), th4);
            }
        } catch (Throwable th5) {
            if (inputStreamReader == null) {
                int i9 = afWarnLog + 93;
                afRDLog = i9 % 128;
                if (i9 % 2 != 0) {
                    int i10 = 3 / 3;
                }
            } else {
                try {
                    inputStreamReader.close();
                } catch (Throwable th6) {
                    AFLogger.afErrorLog(th6.getMessage(), th6);
                }
            }
            throw th5;
        }
        int i11 = afRDLog + 69;
        afWarnLog = i11 % 128;
        int i12 = i11 % 2;
        return null;
    }

    private final boolean force() {
        int i = 2 % 2;
        if (AFInAppEventType().getBoolean(AppsFlyerProperties.COLLECT_ANDROID_ID_FORCE_BY_USER, false) || AFInAppEventType().getBoolean(AppsFlyerProperties.COLLECT_IMEI_FORCE_BY_USER, false)) {
            int i2 = afRDLog + 73;
            afWarnLog = i2 % 128;
            int i3 = i2 % 2;
            return true;
        }
        int i4 = afWarnLog + 103;
        afRDLog = i4 % 128;
        int i5 = i4 % 2;
        AFb1vSDK.valueOf();
        if (i5 != 0) {
            AFb1vSDK.values(this.valueOf);
            Object obj = null;
            obj.hashCode();
            throw null;
        }
        if (!AFb1vSDK.values(this.valueOf)) {
            return true;
        }
        int i6 = afRDLog + 3;
        afWarnLog = i6 % 128;
        int i7 = i6 % 2;
        return false;
    }

    private static void valueOf(Map<String, Object> map, AFa1pSDK aFa1pSDK) {
        Intrinsics.checkNotNullParameter(map, "");
        Intrinsics.checkNotNullParameter(aFa1pSDK, "");
        String str = aFa1pSDK.AFLogger;
        if (str != null) {
            map.put("eventName", str);
            map.put("eventValue", new JSONObject(aFa1pSDK.AFInAppEventParameterName == null ? new HashMap() : aFa1pSDK.AFInAppEventParameterName).toString());
        }
    }

    private static void m805a(String str, int i, Object[] objArr) {
        int i2 = 2 % 2;
        Object charArray = str;
        if (str != null) {
            int i3 = $10 + 83;
            $11 = i3 % 128;
            if (i3 % 2 == 0) {
                int i4 = 62 / 0;
                charArray = str.toCharArray();
            } else {
                charArray = str.toCharArray();
            }
        }
        AFj1oSDK aFj1oSDK = new AFj1oSDK();
        char[] cArrValues = AFj1oSDK.values(afErrorLog ^ 8631014522124598290L, (char[]) charArray, i);
        aFj1oSDK.AFKeystoreWrapper = 4;
        while (aFj1oSDK.AFKeystoreWrapper < cArrValues.length) {
            int i5 = $11 + 65;
            $10 = i5 % 128;
            int i6 = i5 % 2;
            aFj1oSDK.AFInAppEventParameterName = aFj1oSDK.AFKeystoreWrapper - 4;
            cArrValues[aFj1oSDK.AFKeystoreWrapper] = (char) (((long) (cArrValues[aFj1oSDK.AFKeystoreWrapper] ^ cArrValues[aFj1oSDK.AFKeystoreWrapper % 4])) ^ (((long) aFj1oSDK.AFInAppEventParameterName) * (afErrorLog ^ 8631014522124598290L)));
            aFj1oSDK.AFKeystoreWrapper++;
        }
        objArr[0] = new String(cArrValues, 4, cArrValues.length - 4);
    }
}
