package cn.thinkingdata.android;

import android.app.ActivityManager;
import android.content.Context;
import android.content.pm.PackageInfo;
import android.graphics.Point;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Build;
import android.os.LocaleList;
import android.os.StatFs;
import android.os.storage.StorageManager;
import android.telephony.TelephonyManager;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.view.Display;
import android.view.WindowManager;
import androidx.compose.ui.graphics.Api26Bitmap$;
import cn.thinkingdata.android.p004p.C0747i;
import cn.thinkingdata.android.utils.C0751b;
import cn.thinkingdata.android.utils.C0758i;
import cn.thinkingdata.android.utils.C0763n;
import cn.thinkingdata.android.utils.C0766q;
import cn.thinkingdata.android.utils.TDLog;
import com.facebook.appevents.AppEventsConstants;
import java.io.File;
import java.lang.reflect.Array;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;
import org.json.JSONObject;

class C0733j {

    private static String f202i = "Android";

    private static String f203j = "2.8.2.3";

    private static C0733j f204k;

    private static final Object f205l = new Object();

    private boolean f206a;

    private long f207b;

    private final TimeZone f208c;

    private String f209d;

    private final Map<String, Object> f210e;

    private final Context f211f;

    private final boolean f212g;

    private String f213h;

    class a extends HashMap<String, String> {
        a() {
            put("46000", "中国移动");
            put("46002", "中国移动");
            put("46007", "中国移动");
            put("46008", "中国移动");
            put("46001", "中国联通");
            put("46006", "中国联通");
            put("46009", "中国联通");
            put("46003", "中国电信");
            put("46005", "中国电信");
            put("46011", "中国电信");
            put("46004", "中国卫通");
            put("46020", "中国铁通");
        }
    }

    private C0733j(Context context, TimeZone timeZone) {
        Context applicationContext = context.getApplicationContext();
        this.f211f = applicationContext;
        this.f208c = timeZone;
        this.f212g = m535a(applicationContext, "android.permission.ACCESS_NETWORK_STATE");
        try {
            PackageInfo packageInfo = context.getPackageManager().getPackageInfo(context.getPackageName(), 0);
            if (!TDPresetProperties.disableList.contains("#app_version")) {
                this.f209d = packageInfo.versionName;
            }
            long j = packageInfo.firstInstallTime;
            this.f207b = j;
            this.f206a = j == packageInfo.lastUpdateTime;
            TDLog.m679d("ThinkingAnalytics.SystemInformation", "First Install Time: " + packageInfo.firstInstallTime);
            TDLog.m679d("ThinkingAnalytics.SystemInformation", "Last Update Time: " + packageInfo.lastUpdateTime);
        } catch (Exception unused) {
            TDLog.m679d("ThinkingAnalytics.SystemInformation", "Exception occurred in getting app version");
        }
        this.f210e = m541f(context);
    }

    private static int m531a(int i, int i2, int i3) {
        return (i == 0 || i == 2) ? i3 : i2;
    }

    public static C0733j m532a(Context context, TimeZone timeZone) {
        C0733j c0733j;
        synchronized (f205l) {
            if (f204k == null) {
                f204k = new C0733j(context, timeZone);
            }
            c0733j = f204k;
        }
        return c0733j;
    }

    private String m533a(Context context, TelephonyManager telephonyManager, ConnectivityManager connectivityManager) {
        int networkType;
        NetworkInfo activeNetworkInfo;
        if (telephonyManager != null) {
            try {
                networkType = (Build.VERSION.SDK_INT < 30 || !m535a(context, "android.permission.READ_PHONE_STATE")) ? telephonyManager.getNetworkType() : telephonyManager.getDataNetworkType();
            } catch (Exception unused) {
                networkType = 0;
            }
        } else {
            networkType = 0;
        }
        if (networkType == 0 && connectivityManager != null && (activeNetworkInfo = connectivityManager.getActiveNetworkInfo()) != null) {
            networkType = activeNetworkInfo.getSubtype();
        }
        switch (networkType) {
            case 1:
            case 2:
            case 4:
            case 7:
            case 11:
                return "2G";
            case 3:
            case 5:
            case 6:
            case 8:
            case 9:
            case 10:
            case 12:
            case 14:
            case 15:
                return "3G";
            case 13:
            case 18:
            case 19:
                return "4G";
            case 16:
            case 17:
            default:
                return "NULL";
            case 20:
                return "5G";
        }
    }

    static void m534a(String str, String str2) {
        if (!TextUtils.isEmpty(str)) {
            f202i = str;
            TDLog.m679d("ThinkingAnalytics.SystemInformation", "#lib has been changed to: " + str);
        }
        if (TextUtils.isEmpty(str2)) {
            return;
        }
        f203j = str2;
        TDLog.m679d("ThinkingAnalytics.SystemInformation", "#lib_version has been changed to: " + str2);
    }

    private boolean m535a(Context context, String str) {
        Class<?> cls;
        try {
            cls = Class.forName("androidx.core.content.ContextCompat");
        } catch (Exception unused) {
            cls = null;
        }
        if (cls == null) {
            try {
                cls = Class.forName("androidx.core.content.ContextCompat");
            } catch (Exception unused2) {
            }
        }
        if (cls == null) {
            return true;
        }
        try {
            if (((Integer) cls.getMethod("checkSelfPermission", Context.class, String.class).invoke(null, context, str)).intValue() == 0) {
                return true;
            }
            TDLog.m687w("ThinkingAnalytics.SystemInformation", "You can fix this by adding the following to your AndroidManifest.xml file:\n<uses-permission android:name=\"" + str + "\" />");
            return false;
        } catch (Exception e) {
            TDLog.m687w("ThinkingAnalytics.SystemInformation", e.toString());
            return true;
        }
    }

    private static int m536b(int i, int i2, int i3) {
        return (i == 0 || i == 2) ? i2 : i3;
    }

    private static String m537b(Context context, boolean z) {
        StorageManager storageManager = (StorageManager) context.getSystemService("storage");
        try {
            Class<?> cls = Class.forName("android.os.storage.StorageVolume");
            Method method = storageManager.getClass().getMethod("getVolumeList", null);
            Method method2 = cls.getMethod(Build.VERSION.SDK_INT < 30 ? "getPath" : "getDirectory", null);
            Method method3 = cls.getMethod("isRemovable", null);
            Object objInvoke = method.invoke(storageManager, null);
            int length = Array.getLength(objInvoke);
            for (int i = 0; i < length; i++) {
                Object obj = Array.get(objInvoke, i);
                String absolutePath = Build.VERSION.SDK_INT < 30 ? (String) method2.invoke(obj, null) : ((File) method2.invoke(obj, null)).getAbsolutePath();
                if (z == ((Boolean) method3.invoke(obj, null)).booleanValue()) {
                    return absolutePath;
                }
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e2) {
            e2.printStackTrace();
        } catch (NoSuchMethodException e3) {
            e3.printStackTrace();
        } catch (InvocationTargetException e4) {
            e4.printStackTrace();
        }
        return null;
    }

    private static String m538c(Context context) {
        a aVar = new a();
        try {
            TelephonyManager telephonyManager = (TelephonyManager) context.getSystemService("phone");
            String simOperator = telephonyManager.getSimOperator();
            if (!TextUtils.isEmpty(simOperator) && aVar.containsKey(simOperator)) {
                return (String) aVar.get(simOperator);
            }
            String simOperatorName = telephonyManager.getSimOperatorName();
            return !TextUtils.isEmpty(simOperatorName) ? simOperatorName : "";
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    public static int[] m539d(Context context) {
        int[] iArr = new int[2];
        try {
            Display defaultDisplay = ((WindowManager) context.getSystemService("window")).getDefaultDisplay();
            int rotation = defaultDisplay.getRotation();
            Point point = new Point();
            defaultDisplay.getRealSize(point);
            int i = point.x;
            int i2 = point.y;
            iArr[0] = m536b(rotation, i, i2);
            iArr[1] = m531a(rotation, i, i2);
        } catch (Exception unused) {
            if (context.getResources() != null) {
                DisplayMetrics displayMetrics = context.getResources().getDisplayMetrics();
                iArr[0] = displayMetrics.widthPixels;
                iArr[1] = displayMetrics.heightPixels;
            }
        }
        return iArr;
    }

    public static C0733j m540e(Context context) {
        C0733j c0733j;
        synchronized (f205l) {
            if (f204k == null) {
                f204k = new C0733j(context, null);
            }
            c0733j = f204k;
        }
        return c0733j;
    }

    private Map<String, Object> m541f(Context context) {
        HashMap map = new HashMap();
        if (!TDPresetProperties.disableList.contains("#lib")) {
            map.put("#lib", f202i);
        }
        if (!TDPresetProperties.disableList.contains("#lib_version")) {
            map.put("#lib_version", f203j);
        }
        if (this.f208c != null && !TDPresetProperties.disableList.contains("#install_time")) {
            map.put("#install_time", new C0763n(new Date(this.f207b), this.f208c).mo699b());
        }
        String strM748b = C0766q.m748b();
        if (!TDPresetProperties.disableList.contains("#os")) {
            map.put("#os", TextUtils.isEmpty(strM748b) ? "Android" : "HarmonyOS");
        }
        if (!TDPresetProperties.disableList.contains("#os_version")) {
            if (TextUtils.isEmpty(strM748b)) {
                strM748b = Build.VERSION.RELEASE;
            }
            map.put("#os_version", strM748b);
        }
        if (!TDPresetProperties.disableList.contains("#bundle_id")) {
            map.put("#bundle_id", C0766q.m750b(context));
        }
        if (!TDPresetProperties.disableList.contains("#manufacturer")) {
            map.put("#manufacturer", Build.MANUFACTURER);
        }
        if (!TDPresetProperties.disableList.contains("#device_model")) {
            map.put("#device_model", Build.MODEL);
        }
        int[] iArrM539d = m539d(context);
        if (!TDPresetProperties.disableList.contains("#screen_width")) {
            map.put("#screen_width", Integer.valueOf(iArrM539d[0]));
        }
        if (!TDPresetProperties.disableList.contains("#screen_height")) {
            map.put("#screen_height", Integer.valueOf(iArrM539d[1]));
        }
        if (!TDPresetProperties.disableList.contains("#carrier")) {
            map.put("#carrier", m538c(context));
        }
        if (!TDPresetProperties.disableList.contains("#device_id")) {
            map.put("#device_id", m545a(context));
        }
        if (!TDPresetProperties.disableList.contains("#system_language")) {
            map.put("#system_language", m544i());
        }
        if (!TextUtils.isEmpty(this.f209d)) {
            map.put("#app_version", this.f209d);
        }
        if (!TDPresetProperties.disableList.contains("#simulator")) {
            map.put("#simulator", Boolean.valueOf(C0751b.m692a()));
        }
        return Collections.unmodifiableMap(map);
    }

    static String m542g() {
        return f202i;
    }

    static String m543h() {
        return f203j;
    }

    private String m544i() {
        return (Build.VERSION.SDK_INT >= 24 ? Api26Bitmap$.ExternalSyntheticApiModelOutline0.m(LocaleList.getDefault(), 0) : Locale.getDefault()).getLanguage();
    }

    String m545a(Context context) {
        C0747i c0747i = new C0747i(new C0731h().m527a(context, "com.thinkingdata.analyse"));
        String strB = c0747i.m678b();
        if (!TextUtils.isEmpty(strB)) {
            return strB;
        }
        Object objM707a = C0758i.m707a(C0758i.m708a("cn.thinkingdata.android.utils.TASensitiveInfo"), "getAndroidID", new Object[]{context}, (Class<?>[]) new Class[]{Context.class});
        String strValueOf = objM707a == null ? "" : String.valueOf(objM707a);
        if (TextUtils.isEmpty(strValueOf)) {
            strValueOf = c0747i.mo674a();
        }
        try {
            if (Integer.parseInt(strValueOf) == 0) {
                strValueOf = c0747i.mo674a();
            }
        } catch (Exception unused) {
        }
        String str = strValueOf;
        c0747i.m677a(str);
        return str;
    }

    public String m546a(Context context, boolean z) {
        if (TextUtils.isEmpty(this.f213h)) {
            this.f213h = m537b(context, z);
        }
        if (TextUtils.isEmpty(this.f213h)) {
            return AppEventsConstants.EVENT_PARAM_VALUE_NO;
        }
        File file = new File(this.f213h);
        if (!file.exists()) {
            return AppEventsConstants.EVENT_PARAM_VALUE_NO;
        }
        StatFs statFs = new StatFs(file.getPath());
        long blockCountLong = statFs.getBlockCountLong();
        long blockSizeLong = statFs.getBlockSizeLong();
        long availableBlocksLong = statFs.getAvailableBlocksLong() * blockSizeLong;
        double dM724a = C0766q.m724a((((blockCountLong * blockSizeLong) / 1024.0d) / 1024.0d) / 1024.0d);
        return C0766q.m724a(((availableBlocksLong / 1024.0d) / 1024.0d) / 1024.0d) + "/" + dM724a;
    }

    public JSONObject m547a() {
        if (this.f210e == null) {
            return new JSONObject();
        }
        JSONObject jSONObject = new JSONObject(this.f210e);
        jSONObject.remove("#lib");
        jSONObject.remove("#lib_version");
        return jSONObject;
    }

    String m548b() {
        return this.f209d;
    }

    public String m549b(Context context) {
        ActivityManager activityManager = (ActivityManager) context.getSystemService("activity");
        ActivityManager.MemoryInfo memoryInfo = new ActivityManager.MemoryInfo();
        activityManager.getMemoryInfo(memoryInfo);
        long j = memoryInfo.totalMem;
        long j2 = memoryInfo.availMem;
        double dM724a = C0766q.m724a(((j / 1024.0d) / 1024.0d) / 1024.0d);
        return C0766q.m724a(((j2 / 1024.0d) / 1024.0d) / 1024.0d) + "/" + dM724a;
    }

    public Map<String, Object> m550c() {
        return this.f210e;
    }

    String m551d() {
        NetworkInfo networkInfo;
        try {
            if (!this.f212g) {
                return "NULL";
            }
            ConnectivityManager connectivityManager = (ConnectivityManager) this.f211f.getSystemService("connectivity");
            return (connectivityManager == null || (networkInfo = connectivityManager.getNetworkInfo(1)) == null || !networkInfo.isConnectedOrConnecting()) ? m533a(this.f211f, (TelephonyManager) this.f211f.getSystemService("phone"), connectivityManager) : "WIFI";
        } catch (Exception unused) {
            return "NULL";
        }
    }

    public boolean m552e() {
        return this.f206a;
    }

    boolean m553f() {
        if (!this.f212g) {
            return false;
        }
        try {
            NetworkInfo activeNetworkInfo = ((ConnectivityManager) this.f211f.getSystemService("connectivity")).getActiveNetworkInfo();
            return activeNetworkInfo != null && activeNetworkInfo.isConnected();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
