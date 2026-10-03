package com.gme.liteav.base.system;

import android.app.ActivityManager;
import android.content.Context;
import android.content.pm.PackageManager;
import android.content.pm.ServiceInfo;
import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkCapabilities;
import android.net.NetworkInfo;
import android.net.wifi.WifiManager;
import android.os.Process;
import android.telephony.TelephonyManager;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.util.Pair;
import android.view.WindowManager;
import com.gme.liteav.base.ContextUtils;
import com.gme.liteav.base.Log;
import com.gme.liteav.base.annotations.JNINamespace;
import com.gme.liteav.base.p008a.C1003a;
import com.gme.liteav.base.util.C1053e;
import com.gme.liteav.base.util.C1059k;
import com.gme.liteav.base.util.LiteavLog;
import com.unity3d.player.l$a$;
import java.util.ArrayList;
import java.util.List;

@JNINamespace("liteav")
public class LiteavSystemInfo {
    private static final int APP_SYSTEM_METHOD_DEFAULT_GET_INTERVAL_MS = 1000;
    private static final String EXT_KEY_APP_BACKGROUND = "isAppBackground";
    private static final String EXT_KEY_APP_NAME = "appName";
    private static final String EXT_KEY_APP_PACKAGE_NAME = "appPackageName";
    private static final String EXT_KEY_APP_VERSION = "appVersion";
    private static final String EXT_KEY_BUILD_BOARD = "buildBoard";
    private static final String EXT_KEY_BUILD_BRAND = "buildBrand";
    private static final String EXT_KEY_BUILD_HARDWARE = "buildHardware";
    private static final String EXT_KEY_BUILD_MANUFACTURER = "buildManufacturer";
    private static final String EXT_KEY_BUILD_MODEL = "buildModel";
    private static final String EXT_KEY_BUILD_VERSION = "buildVersion";
    private static final String EXT_KEY_BUILD_VERSION_INT = "buildVersionInt";
    private static final int NETWORK_TYPE_2G = 4;
    private static final int NETWORK_TYPE_3G = 3;
    private static final int NETWORK_TYPE_4G = 2;
    private static final int NETWORK_TYPE_5G = 6;
    private static final int NETWORK_TYPE_UNKNOWN = 0;
    private static final int NETWORK_TYPE_WIFI = 1;
    private static final int NETWORK_TYPE_WIRED = 5;
    private static final String TAG = "LiteavBaseSystemInfo";
    private static final C1059k<String> sModel = new C1059k<>(CallableC1033i.m979a());
    private static final C1059k<String> sBrand = new C1059k<>(CallableC1034j.m980a());
    private static final C1059k<String> sManufacturer = new C1059k<>(CallableC1035k.m981a());
    private static final C1059k<String> sHardware = new C1059k<>(CallableC1036l.m982a());
    private static final C1059k<String> sSystemOSVersion = new C1059k<>(CallableC1037m.m983a());
    private static final C1059k<Integer> sSystemOSVersionInt = new C1059k<>(CallableC1038n.m984a());
    private static final C1059k<String> sBoard = new C1059k<>(CallableC1039o.m985a());
    private static final C1059k<String> sAppPackageName = new C1059k<>(CallableC1040p.m986a());
    private static final C1059k<String> sAppName = new C1059k<>(CallableC1028d.m974a());
    private static final C1059k<String> sAppVersion = new C1059k<>(CallableC1029e.m975a());
    private static final C1059k<String> sUUID = new C1059k<>(CallableC1030f.m976a());
    private static final C1059k<String[]> sCpuABIs = new C1059k<>(CallableC1031g.m977a());
    private static int sLastNetworkType = 0;
    private static final C1003a sNetworkTypeThrottler = new C1003a();
    private static int sLastGateway = 0;
    private static final C1003a sGatewayThrottler = new C1003a();
    private static boolean sLastMicPermission = false;
    private static final C1003a sMicPermissionThrottler = new C1003a();
    private static boolean sLastIsBackground = false;
    private static final C1059k<List<Pair<ActivityManager.RunningServiceInfo, ServiceInfo>>> sForegroundServices = new C1059k<>(CallableC1032h.m978a());

    private static native void nativeOnAppBackgroundStateChanged(int i);

    public static boolean setExtID(String str, String str2) {
        if (!TextUtils.isEmpty(str) && !TextUtils.isEmpty(str2)) {
            str.hashCode();
            switch (str) {
                case "isAppBackground":
                    try {
                        C1053e.m1012a(Integer.parseInt(str2) == 1);
                        return true;
                    } catch (Exception e) {
                        Log.m948e(TAG, "set app background state failed. ".concat(String.valueOf(e)), new Object[0]);
                        break;
                    }
                    break;
                case "buildVersion":
                    sSystemOSVersion.m1028a(str2);
                    return true;
                case "appName":
                    sAppName.m1028a(str2);
                    return true;
                case "buildManufacturer":
                    sManufacturer.m1028a(str2);
                    return true;
                case "buildBoard":
                    sBoard.m1028a(str2);
                    return true;
                case "buildBrand":
                    sBrand.m1028a(str2);
                    return true;
                case "buildModel":
                    sModel.m1028a(str2);
                    return true;
                case "appPackageName":
                    sAppPackageName.m1028a(str2);
                    return true;
                case "buildHardware":
                    sHardware.m1028a(str2);
                    return true;
                case "buildVersionInt":
                    try {
                        sSystemOSVersionInt.m1028a(Integer.valueOf(Integer.parseInt(str2)));
                        break;
                    } catch (Exception e2) {
                        e2.printStackTrace();
                    }
                    return true;
                case "appVersion":
                    sAppVersion.m1028a(str2);
                    return true;
                default:
                    return false;
            }
        }
        return false;
    }

    public static String getDeviceUuid() {
        try {
            return sUUID.m1027a();
        } catch (Throwable th) {
            LiteavLog.m995e("LiteavSystemInfo", "getDeviceUuid failed.", th);
            return "";
        }
    }

    public static String getHardware() {
        try {
            return sHardware.m1027a();
        } catch (Throwable th) {
            LiteavLog.m995e("LiteavSystemInfo", "getHardware failed.", th);
            return "";
        }
    }

    public static String getManufacturer() {
        try {
            return sManufacturer.m1027a();
        } catch (Throwable th) {
            LiteavLog.m995e("LiteavSystemInfo", "getManufacturer failed.", th);
            return "";
        }
    }

    public static String getBoard() {
        return sBoard.m1027a();
    }

    public static String getModel() {
        try {
            return sModel.m1027a();
        } catch (Throwable th) {
            LiteavLog.m995e("LiteavSystemInfo", "getModel failed.", th);
            return "";
        }
    }

    public static String getBrand() {
        return sBrand.m1027a();
    }

    public static String getSystemOSVersion() {
        try {
            return sSystemOSVersion.m1027a();
        } catch (Throwable th) {
            LiteavLog.m995e("LiteavSystemInfo", "getSystemOSVersion failed.", th);
            return "";
        }
    }

    public static int getSystemOSVersionInt() {
        try {
            return sSystemOSVersionInt.m1027a().intValue();
        } catch (Throwable th) {
            LiteavLog.m995e("LiteavSystemInfo", "getSystemOSVersionInt failed.", th);
            return 0;
        }
    }

    public static String getAppName() {
        try {
            return sAppName.m1027a();
        } catch (Throwable th) {
            LiteavLog.m995e("LiteavSystemInfo", "getAppName failed.", th);
            return "";
        }
    }

    public static String getAppPackageName() {
        try {
            return sAppPackageName.m1027a();
        } catch (Throwable th) {
            LiteavLog.m995e("LiteavSystemInfo", "getAppPackageName failed.", th);
            return "";
        }
    }

    public static String getAppVersion() {
        try {
            return sAppVersion.m1027a();
        } catch (Throwable th) {
            LiteavLog.m995e("LiteavSystemInfo", "getAppVersion failed.", th);
            return "";
        }
    }

    public static synchronized void listenAppBackgroundState() {
        try {
            C1053e.m1011a().m1018a(C1027c.m972a());
        } catch (Throwable th) {
            LiteavLog.m995e("LiteavSystemInfo", "listenAppBackgroundState failed.", th);
        }
    }

    public static synchronized int getAppThreadSize() {
        ThreadGroup threadGroup;
        try {
            threadGroup = Thread.currentThread().getThreadGroup();
            while (threadGroup.getParent() != null) {
                threadGroup = threadGroup.getParent();
            }
        } catch (Throwable th) {
            LiteavLog.m995e("LiteavSystemInfo", "getAppThreadSize failed.", th);
            return 1;
        }
        return threadGroup.activeCount();
    }

    public static synchronized int getAppBackgroundState() {
        try {
        } catch (Throwable th) {
            LiteavLog.m995e("LiteavSystemInfo", "getAppBackgroundState failed.", th);
            return 0;
        }
        return C1053e.m1011a().m1019b() ? 1 : 0;
    }

    public static synchronized int getNetworkType() {
        try {
            if (sNetworkTypeThrottler.m954a()) {
                sLastNetworkType = getNetworkTypeFromSystem();
            }
        } catch (Throwable th) {
            LiteavLog.m995e("LiteavSystemInfo", "getNetworkType failed.", th);
            return 0;
        }
        return sLastNetworkType;
    }

    private static int getNetworkTypeFromSystem() {
        ConnectivityManager connectivityManager;
        NetworkInfo activeNetworkInfo;
        Context applicationContext = ContextUtils.getApplicationContext();
        if (applicationContext == null || (connectivityManager = (ConnectivityManager) applicationContext.getSystemService("connectivity")) == null) {
            return 0;
        }
        try {
            activeNetworkInfo = connectivityManager.getActiveNetworkInfo();
        } catch (Exception unused) {
            activeNetworkInfo = null;
        }
        if (activeNetworkInfo == null || !activeNetworkInfo.isConnected()) {
            return 0;
        }
        if (activeNetworkInfo.getType() == 9) {
            return 5;
        }
        if (activeNetworkInfo.getType() == 1) {
            return 1;
        }
        if (activeNetworkInfo.getType() != 0) {
            return 0;
        }
        try {
            TelephonyManager telephonyManager = (TelephonyManager) applicationContext.getSystemService("phone");
            if (telephonyManager != null) {
                int networkType = telephonyManager.getNetworkType();
                switch (networkType) {
                    case 1:
                    case 2:
                    case 4:
                    case 7:
                    case 11:
                        return 4;
                    case 3:
                    case 5:
                    case 6:
                    case 8:
                    case 9:
                    case 10:
                    case 12:
                    case 14:
                    case 15:
                        return 3;
                    case 13:
                        return 2;
                    default:
                        if (getSystemOSVersionInt() >= 29 && networkType == 20) {
                            return 6;
                        }
                        break;
                }
            } else {
                return 0;
            }
        } catch (Exception unused2) {
        }
        return 2;
    }

    public static synchronized int getGateway() {
        try {
            if (sGatewayThrottler.m954a()) {
                sLastGateway = getGatewayFromSystem();
            }
        } catch (Throwable th) {
            LiteavLog.m995e("LiteavSystemInfo", "getGateway failed.", th);
            return 0;
        }
        return sLastGateway;
    }

    private static int getGatewayFromSystem() {
        Context applicationContext = ContextUtils.getApplicationContext();
        if (applicationContext == null) {
            return 0;
        }
        try {
            return ((WifiManager) applicationContext.getSystemService("wifi")).getDhcpInfo().gateway;
        } catch (Throwable th) {
            Log.m948e(TAG, "getGateway error " + th.getMessage(), new Object[0]);
            return 0;
        }
    }

    public static synchronized boolean getAudioRecordPermission() {
        try {
            if (sMicPermissionThrottler.m954a()) {
                sLastMicPermission = getAudioRecordPermissionFromSystem();
            }
        } catch (Throwable th) {
            LiteavLog.m995e("LiteavSystemInfo", "getAudioRecordPermission failed.", th);
            return false;
        }
        return sLastMicPermission;
    }

    private static boolean getAudioRecordPermissionFromSystem() {
        Context applicationContext = ContextUtils.getApplicationContext();
        return applicationContext != null && applicationContext.checkPermission("android.permission.RECORD_AUDIO", Process.myPid(), Process.myUid()) == 0;
    }

    public static int[] getScreenSizeInPixels() {
        try {
            int[] iArr = {0, 0};
            Context applicationContext = ContextUtils.getApplicationContext();
            if (applicationContext == null) {
                Log.m948e(TAG, "Context is null.", new Object[0]);
                return iArr;
            }
            WindowManager windowManager = (WindowManager) applicationContext.getSystemService("window");
            if (windowManager == null) {
                Log.m948e(TAG, "WindowManager is null.", new Object[0]);
                return iArr;
            }
            DisplayMetrics displayMetrics = new DisplayMetrics();
            windowManager.getDefaultDisplay().getMetrics(displayMetrics);
            iArr[0] = Math.max(displayMetrics.widthPixels, displayMetrics.heightPixels);
            iArr[1] = Math.min(displayMetrics.widthPixels, displayMetrics.heightPixels);
            return iArr;
        } catch (Throwable th) {
            LiteavLog.m995e("LiteavSystemInfo", "getScreenSizeInPixels failed.", th);
            return null;
        }
    }

    public static String[] getSupportABIs() {
        try {
            return sCpuABIs.m1027a();
        } catch (Throwable th) {
            LiteavLog.m995e("LiteavSystemInfo", "getSupportABIs failed.", th);
            return null;
        }
    }

    public static synchronized String getSystemProperty(String str) {
        String str2;
        str2 = null;
        try {
            Object objInvoke = Class.forName("android.os.SystemProperties").getMethod("get", String.class).invoke(null, str);
            if (objInvoke != null) {
                String str3 = (String) objInvoke;
                try {
                    Log.m949i(TAG, "Get " + str + " property is " + str3, new Object[0]);
                    str2 = str3;
                } catch (Throwable th) {
                    th = th;
                    str2 = str3;
                    Log.m948e(TAG, "Get system property failed. ".concat(String.valueOf(th)), new Object[0]);
                }
            }
        } catch (Throwable th2) {
            th = th2;
        }
        return str2;
    }

    public static synchronized String getProperty(String str) {
        String property;
        try {
            property = System.getProperty(str);
            try {
                Log.m949i(TAG, "Get " + str + " property is " + property, new Object[0]);
            } catch (Throwable th) {
                th = th;
                Log.m948e(TAG, "Get property failed. ".concat(String.valueOf(th)), new Object[0]);
            }
        } catch (Throwable th2) {
            th = th2;
            property = null;
        }
        return property;
    }

    public static void setSDKWorking(boolean z) {
        try {
            C1053e.m1011a().f751a = z;
        } catch (Throwable th) {
            LiteavLog.m995e("LiteavSystemInfo", "setSDKWorking failed.", th);
        }
    }

    public static boolean isForegroundServiceRunning(int i) {
        try {
            boolean zM1019b = C1053e.m1011a().m1019b();
            if (zM1019b != sLastIsBackground) {
                sLastIsBackground = zM1019b;
                sForegroundServices.m1028a(getForegroundServices());
            }
            List<Pair<ActivityManager.RunningServiceInfo, ServiceInfo>> listM1027a = sForegroundServices.m1027a();
            if (listM1027a == null) {
                return false;
            }
            for (Pair<ActivityManager.RunningServiceInfo, ServiceInfo> pair : listM1027a) {
                if (((ActivityManager.RunningServiceInfo) pair.first).foreground && (getSystemOSVersionInt() < 29 || i == 0 || (l$a$.ExternalSyntheticApiModelOutline0.m((ServiceInfo) pair.second) & i) != 0)) {
                    return true;
                }
            }
        } catch (Throwable th) {
            Log.m948e(TAG, "Get foreground service running failed. ", th);
        }
        return false;
    }

    public static List<Pair<ActivityManager.RunningServiceInfo, ServiceInfo>> getForegroundServices() {
        ArrayList arrayList = new ArrayList();
        try {
            Context applicationContext = ContextUtils.getApplicationContext();
            if (applicationContext == null) {
                Log.m948e(TAG, "Context is null.", new Object[0]);
                return arrayList;
            }
            List<ActivityManager.RunningServiceInfo> runningServices = ((ActivityManager) applicationContext.getSystemService("activity")).getRunningServices(Integer.MAX_VALUE);
            if (runningServices == null) {
                return arrayList;
            }
            PackageManager packageManager = applicationContext.getPackageManager();
            for (ActivityManager.RunningServiceInfo runningServiceInfo : runningServices) {
                arrayList.add(Pair.create(runningServiceInfo, packageManager.getServiceInfo(runningServiceInfo.service, 128)));
            }
            return arrayList;
        } catch (Throwable th) {
            Log.m948e(TAG, "Get foreground services failed. ", th);
        }
    }

    public static boolean isVPNActive() {
        ConnectivityManager connectivityManager;
        Network activeNetwork;
        NetworkCapabilities networkCapabilities;
        try {
            Context applicationContext = ContextUtils.getApplicationContext();
            if (applicationContext == null || (connectivityManager = (ConnectivityManager) applicationContext.getSystemService("connectivity")) == null || (activeNetwork = connectivityManager.getActiveNetwork()) == null || (networkCapabilities = connectivityManager.getNetworkCapabilities(activeNetwork)) == null) {
                return false;
            }
            return networkCapabilities.hasTransport(4);
        } catch (Throwable th) {
            LiteavLog.m995e("LiteavSystemInfo", "isVPNActive failed.", th);
            return false;
        }
    }

    public static void onAppBackgroundStateChanged(boolean z) {
        nativeOnAppBackgroundStateChanged(z ? 1 : 0);
    }
}
