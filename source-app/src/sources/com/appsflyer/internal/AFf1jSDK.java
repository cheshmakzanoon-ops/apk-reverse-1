package com.appsflyer.internal;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.os.Build;
import com.appsflyer.AFLogger;
import com.appsflyer.AppsFlyerProperties;
import com.appsflyer.internal.components.network.http.ResponseNetwork;
import com.facebook.devicerequests.internal.DeviceRequestsHelper;
import com.facebook.internal.NativeProtocol;
import com.facebook.internal.ServerProtocol;
import java.text.SimpleDateFormat;
import java.util.Locale;

public final class AFf1jSDK extends AFf1pSDK {
    private static int $10 = 0;
    private static int $11 = 1;
    private static int afDebugLog = 1;
    private static int[] afErrorLog = {-1572071332, 560507912, 743536130, 1394283202, 345505320, -1767483084, 145582697, 903005446, 1125114585, 785216193, -531383726, -1297414986, 254878222, 173739860, 1520982176, -35091883, -21326854, -635172834};
    private static int afVerboseLog;
    private final String afInfoLog;
    private final AFg1qSDK afWarnLog;
    private final AFd1rSDK force;

    private final AFd1lSDK f354v;

    @Override
    protected final void AFInAppEventParameterName(AFa1pSDK aFa1pSDK) {
        int i = 2 % 2;
        int i2 = afDebugLog + 55;
        afVerboseLog = i2 % 128;
        int i3 = i2 % 2;
    }

    @Override
    protected final void values(AFa1pSDK aFa1pSDK) {
        int i = 2 % 2;
        int i2 = afVerboseLog + 29;
        afDebugLog = i2 % 128;
        if (i2 % 2 == 0) {
            int i3 = 66 / 0;
        }
    }

    public AFf1jSDK(String str, AFd1nSDK aFd1nSDK) {
        super(new AFg1pSDK(aFd1nSDK.mo786v().AFInAppEventParameterName), aFd1nSDK, str);
        this.force = aFd1nSDK.AFInAppEventType();
        this.f354v = aFd1nSDK.mo786v();
        this.afInfoLog = str;
        this.afWarnLog = aFd1nSDK.mo783d();
    }

    @Override
    public final void valueOf() {
        int i = 2 % 2;
        super.valueOf();
        ResponseNetwork responseNetwork = this.AFLogger;
        if (responseNetwork != null) {
            int i2 = afDebugLog + 125;
            afVerboseLog = i2 % 128;
            if (i2 % 2 != 0) {
                responseNetwork.isSuccessful();
                throw null;
            }
            if (!responseNetwork.isSuccessful()) {
                return;
            }
            int i3 = afVerboseLog + 79;
            afDebugLog = i3 % 128;
            int i4 = i3 % 2;
            afInfoLog();
            if (i4 == 0) {
                throw null;
            }
        }
    }

    @Override
    protected final void AFInAppEventType(AFa1pSDK aFa1pSDK) throws Throwable {
        int i = 2 % 2;
        super.AFInAppEventType(aFa1pSDK);
        Context context = this.f354v.AFInAppEventParameterName;
        AFb1vSDK aFb1vSDKValueOf = AFb1vSDK.valueOf();
        if (context == null) {
            throw new IllegalStateException("Context is not provided, can't send register request");
        }
        if (aFb1vSDKValueOf.values()) {
            AFLogger.afInfoLog("CustomerUserId not set, Tracking is disabled", true);
            throw new IllegalStateException("CustomerUserId not set, register is not sent");
        }
        PackageManager packageManager = context.getPackageManager();
        try {
            PackageInfo packageInfo = packageManager.getPackageInfo(context.getPackageName(), 0);
            aFa1pSDK.AFKeystoreWrapper("app_version_code", Integer.toString(packageInfo.versionCode));
            aFa1pSDK.AFKeystoreWrapper("app_version_name", packageInfo.versionName);
            aFa1pSDK.AFKeystoreWrapper(NativeProtocol.BRIDGE_ARG_APP_NAME_STRING, packageManager.getApplicationLabel(packageInfo.applicationInfo).toString());
            aFa1pSDK.AFKeystoreWrapper("installDate", AFb1vSDK.valueOf(new SimpleDateFormat("yyyy-MM-dd_HHmmssZ", Locale.US), packageInfo.firstInstallTime));
        } catch (Throwable th) {
            AFLogger.afErrorLog("Exception while collecting application version info.", th);
        }
        this.afWarnLog.values(aFa1pSDK.AFInAppEventType());
        aFa1pSDK.AFInAppEventType().remove("ivc");
        String strAFInAppEventParameterName = AFb1vSDK.AFInAppEventParameterName();
        if (strAFInAppEventParameterName != null) {
            int i2 = afVerboseLog + 71;
            afDebugLog = i2 % 128;
            int i3 = i2 % 2;
            aFa1pSDK.AFKeystoreWrapper("appUserId", strAFInAppEventParameterName);
        }
        try {
            aFa1pSDK.AFKeystoreWrapper(DeviceRequestsHelper.DEVICE_INFO_MODEL, Build.MODEL);
            Object[] objArr = new Object[1];
            m794a(new int[]{-1828101053, 2076585132, -1354017630, -1192853309}, Color.argb(0, 0, 0, 0) + 5, objArr);
            aFa1pSDK.AFKeystoreWrapper(((String) objArr[0]).intern(), Build.BRAND);
        } catch (Throwable th2) {
            AFLogger.afErrorLog("Exception while collecting device brand and model.", th2);
        }
        if (AppsFlyerProperties.getInstance().getBoolean(AppsFlyerProperties.DEVICE_TRACKING_DISABLED, false)) {
            int i4 = afVerboseLog + 97;
            afDebugLog = i4 % 128;
            int i5 = i4 % 2;
            aFa1pSDK.AFKeystoreWrapper(AppsFlyerProperties.DEVICE_TRACKING_DISABLED, ServerProtocol.DIALOG_RETURN_SCOPES_TRUE);
        }
        AFa1aSDK aFa1aSDKAFInAppEventType = AFb1tSDK.AFInAppEventType(context.getContentResolver());
        if (aFa1aSDKAFInAppEventType != null) {
            int i6 = afDebugLog + 37;
            afVerboseLog = i6 % 128;
            int i7 = i6 % 2;
            aFa1pSDK.AFKeystoreWrapper("amazon_aid", aFa1aSDKAFInAppEventType.valueOf);
            aFa1pSDK.AFKeystoreWrapper("amazon_aid_limit", String.valueOf(aFa1aSDKAFInAppEventType.AFInAppEventType));
        }
        String string = AppsFlyerProperties.getInstance().getString("advertiserId");
        Object obj = null;
        if (string != null) {
            int i8 = afVerboseLog + 3;
            afDebugLog = i8 % 128;
            if (i8 % 2 == 0) {
                aFa1pSDK.AFKeystoreWrapper("advertiserId", string);
                obj.hashCode();
                throw null;
            }
            aFa1pSDK.AFKeystoreWrapper("advertiserId", string);
        }
        aFa1pSDK.AFKeystoreWrapper("devkey", ((AFf1tSDK) this).unregisterClient.registerClient);
        aFa1pSDK.AFKeystoreWrapper("uid", AFb1lSDK.values(this.f354v, this.f364w));
        aFa1pSDK.AFKeystoreWrapper("af_gcm_token", this.afInfoLog);
        aFa1pSDK.AFKeystoreWrapper("launch_counter", Integer.toString(this.f364w.valueOf("appsFlyerCount", 0)));
        aFa1pSDK.AFKeystoreWrapper(ServerProtocol.DIALOG_PARAM_SDK_VERSION, Integer.toString(Build.VERSION.SDK_INT));
        String strValues = this.force.values();
        if (strValues != null) {
            aFa1pSDK.AFKeystoreWrapper(AppsFlyerProperties.CHANNEL, strValues);
        }
        int i9 = afVerboseLog + 59;
        afDebugLog = i9 % 128;
        if (i9 % 2 == 0) {
            throw null;
        }
    }

    @Override
    protected final boolean unregisterClient() {
        int i = 2 % 2;
        int i2 = afDebugLog + 33;
        int i3 = i2 % 128;
        afVerboseLog = i3;
        int i4 = i2 % 2;
        int i5 = i3 + 53;
        afDebugLog = i5 % 128;
        if (i5 % 2 == 0) {
            int i6 = 23 / 0;
        }
        return false;
    }

    private void afInfoLog() {
        int i = 2 % 2;
        int i2 = afDebugLog + 35;
        afVerboseLog = i2 % 128;
        int i3 = i2 % 2;
        this.f364w.AFInAppEventParameterName("sentRegisterRequestToAF", true);
        AFLogger.afDebugLog("[register] Successfully registered for Uninstall Tracking");
        int i4 = afDebugLog + 65;
        afVerboseLog = i4 % 128;
        int i5 = i4 % 2;
    }

    private static void m794a(int[] iArr, int i, Object[] objArr) {
        int i2 = 2 % 2;
        AFj1tSDK aFj1tSDK = new AFj1tSDK();
        char[] cArr = new char[4];
        char[] cArr2 = new char[iArr.length * 2];
        int[] iArr2 = afErrorLog;
        if (iArr2 != null) {
            int length = iArr2.length;
            int[] iArr3 = new int[length];
            int i3 = 0;
            while (i3 < length) {
                int i4 = $10 + 41;
                $11 = i4 % 128;
                if (i4 % 2 == 0) {
                    iArr3[i3] = (int) (((long) iArr2[i3]) / (-1493661266463317515L));
                } else {
                    iArr3[i3] = (int) (((long) iArr2[i3]) ^ (-1493661266463317515L));
                    i3++;
                }
            }
            iArr2 = iArr3;
        }
        int length2 = iArr2.length;
        int[] iArr4 = new int[length2];
        int[] iArr5 = afErrorLog;
        if (iArr5 != null) {
            int length3 = iArr5.length;
            int[] iArr6 = new int[length3];
            int i5 = $10 + 119;
            $11 = i5 % 128;
            int i6 = i5 % 2;
            for (int i7 = 0; i7 < length3; i7++) {
                iArr6[i7] = (int) (((long) iArr5[i7]) ^ (-1493661266463317515L));
            }
            iArr5 = iArr6;
        }
        System.arraycopy(iArr5, 0, iArr4, 0, length2);
        aFj1tSDK.AFInAppEventType = 0;
        while (aFj1tSDK.AFInAppEventType < iArr.length) {
            cArr[0] = (char) (iArr[aFj1tSDK.AFInAppEventType] >> 16);
            cArr[1] = (char) iArr[aFj1tSDK.AFInAppEventType];
            cArr[2] = (char) (iArr[aFj1tSDK.AFInAppEventType + 1] >> 16);
            cArr[3] = (char) iArr[aFj1tSDK.AFInAppEventType + 1];
            aFj1tSDK.valueOf = (cArr[0] << 16) + cArr[1];
            aFj1tSDK.AFKeystoreWrapper = (cArr[2] << 16) + cArr[3];
            AFj1tSDK.AFKeystoreWrapper(iArr4);
            for (int i8 = 0; i8 < 16; i8++) {
                aFj1tSDK.valueOf ^= iArr4[i8];
                aFj1tSDK.AFKeystoreWrapper = AFj1tSDK.values(aFj1tSDK.valueOf) ^ aFj1tSDK.AFKeystoreWrapper;
                int i9 = aFj1tSDK.valueOf;
                aFj1tSDK.valueOf = aFj1tSDK.AFKeystoreWrapper;
                aFj1tSDK.AFKeystoreWrapper = i9;
            }
            int i10 = aFj1tSDK.valueOf;
            aFj1tSDK.valueOf = aFj1tSDK.AFKeystoreWrapper;
            aFj1tSDK.AFKeystoreWrapper = i10;
            aFj1tSDK.AFKeystoreWrapper ^= iArr4[16];
            aFj1tSDK.valueOf ^= iArr4[17];
            int i11 = aFj1tSDK.valueOf;
            int i12 = aFj1tSDK.AFKeystoreWrapper;
            cArr[0] = (char) (aFj1tSDK.valueOf >>> 16);
            cArr[1] = (char) aFj1tSDK.valueOf;
            cArr[2] = (char) (aFj1tSDK.AFKeystoreWrapper >>> 16);
            cArr[3] = (char) aFj1tSDK.AFKeystoreWrapper;
            AFj1tSDK.AFKeystoreWrapper(iArr4);
            cArr2[aFj1tSDK.AFInAppEventType * 2] = cArr[0];
            cArr2[(aFj1tSDK.AFInAppEventType * 2) + 1] = cArr[1];
            cArr2[(aFj1tSDK.AFInAppEventType * 2) + 2] = cArr[2];
            cArr2[(aFj1tSDK.AFInAppEventType * 2) + 3] = cArr[3];
            aFj1tSDK.AFInAppEventType += 2;
            int i13 = $11 + 17;
            $10 = i13 % 128;
            int i14 = i13 % 2;
        }
        objArr[0] = new String(cArr2, 0, i);
    }
}
