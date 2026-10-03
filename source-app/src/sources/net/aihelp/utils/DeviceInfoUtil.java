package net.aihelp.utils;

import android.app.ActivityManager;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Build;
import android.os.Environment;
import android.os.StatFs;
import android.telephony.TelephonyManager;
import android.text.TextUtils;
import android.text.format.Formatter;
import android.util.Log;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.Locale;
import net.aihelp.BuildConfig;
import net.aihelp.common.Const;
import net.aihelp.common.CustomConfig;
import net.aihelp.common.UserProfile;
import net.aihelp.config.AIHelpContext;
import net.aihelp.core.net.json.JsonHelper;
import net.aihelp.data.model.init.PrivacyControlEntity;
import okhttp3.internal.p011ws.RealWebSocket;
import org.json.JSONObject;

public class DeviceInfoUtil {
    private static DeviceInfoUtil sInstance;
    private final Context context;

    private DeviceInfoUtil(Context context) {
        this.context = context;
    }

    public static DeviceInfoUtil getInstance() {
        if (sInstance == null) {
            sInstance = new DeviceInfoUtil(AIHelpContext.getInstance().getContext().getApplicationContext());
        }
        return sInstance;
    }

    public int getStatusBarHeight() {
        int identifier = this.context.getResources().getIdentifier("status_bar_height", "dimen", "android");
        if (identifier > 0) {
            return this.context.getResources().getDimensionPixelSize(identifier);
        }
        return 0;
    }

    public String getSimCountryIso() {
        TelephonyManager telephonyManager = (TelephonyManager) this.context.getSystemService("phone");
        if (telephonyManager != null) {
            String simCountryIso = telephonyManager.getSimCountryIso();
            if (!TextUtils.isEmpty(simCountryIso)) {
                return simCountryIso.toUpperCase();
            }
        }
        return Locale.getDefault().getCountry();
    }

    public String getTimeStamp() {
        return new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.ENGLISH).format(new Date());
    }

    public String getAvailMemory() {
        ActivityManager activityManager = (ActivityManager) this.context.getSystemService("activity");
        ActivityManager.MemoryInfo memoryInfo = new ActivityManager.MemoryInfo();
        activityManager.getMemoryInfo(memoryInfo);
        return Formatter.formatFileSize(this.context, memoryInfo.availMem);
    }

    public String getTotalMemory() {
        long j = 0;
        try {
            BufferedReader bufferedReader = new BufferedReader(new FileReader("/proc/meminfo"), 8192);
            String line = bufferedReader.readLine();
            String[] strArrSplit = line.split("\\s+");
            for (String str : strArrSplit) {
                Log.i(line, str + "\t");
            }
            j = ((long) Integer.parseInt(strArrSplit[1])) * RealWebSocket.DEFAULT_MINIMUM_DEFLATE_SIZE;
            bufferedReader.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return Formatter.formatFileSize(this.context, j);
    }

    public String getCarrierName() {
        TelephonyManager telephonyManager = (TelephonyManager) this.context.getSystemService("phone");
        return telephonyManager == null ? "" : telephonyManager.getNetworkOperatorName();
    }

    public String getNetworkType() {
        NetworkInfo activeNetworkInfo;
        try {
            ConnectivityManager connectivityManager = (ConnectivityManager) this.context.getSystemService("connectivity");
            if (connectivityManager != null && (activeNetworkInfo = connectivityManager.getActiveNetworkInfo()) != null) {
                return activeNetworkInfo.getTypeName();
            }
            return "Unknown";
        } catch (SecurityException unused) {
            return null;
        }
    }

    public String getBatteryStatus() {
        Intent intentRegisterReceiver = this.context.registerReceiver(null, new IntentFilter("android.intent.action.BATTERY_CHANGED"));
        if (intentRegisterReceiver == null) {
            return "Not charging";
        }
        int intExtra = intentRegisterReceiver.getIntExtra("status", -1);
        if (intExtra != 2 && intExtra != 5) {
            return "Not charging";
        }
        return "Charging";
    }

    public String getBatteryLevel() {
        Intent intentRegisterReceiver = this.context.registerReceiver(null, new IntentFilter("android.intent.action.BATTERY_CHANGED"));
        if (intentRegisterReceiver == null) {
            return "";
        }
        return ((int) ((intentRegisterReceiver.getIntExtra("level", -1) / intentRegisterReceiver.getIntExtra("scale", -1)) * 100.0f)) + "%";
    }

    public String getTotalDiskSpace() {
        StatFs statFs = new StatFs(Environment.getDataDirectory().getPath());
        return (Math.round(((statFs.getBlockCountLong() * statFs.getBlockSizeLong()) / 1.073741824E9d) * 100.0d) / 100.0d) + "GB";
    }

    public String getRemainDiskSpace() {
        StatFs statFs = new StatFs(Environment.getDataDirectory().getPath());
        return (Math.round(((statFs.getAvailableBlocksLong() * statFs.getBlockSizeLong()) / 1.073741824E9d) * 100.0d) / 100.0d) + "GB";
    }

    private static JSONObject getHostGameInfo(PrivacyControlEntity privacyControlEntity) {
        String packageName;
        String str = "unknown";
        String str2 = "0.0.0";
        try {
            Context context = AIHelpContext.getInstance().getContext();
            packageName = context.getPackageName();
            try {
                ApplicationInfo applicationInfo = context.getPackageManager().getApplicationInfo(packageName, 0);
                str2 = context.getPackageManager().getPackageInfo(packageName, 0).versionName;
                str = (String) context.getPackageManager().getApplicationLabel(applicationInfo);
            } catch (PackageManager.NameNotFoundException e) {
                e = e;
                e.printStackTrace();
            }
        } catch (PackageManager.NameNotFoundException e2) {
            e = e2;
            packageName = "unknown";
        }
        JSONObject jSONObject = new JSONObject();
        if (privacyControlEntity != null) {
            try {
                if (privacyControlEntity.getApplicationIdentifier()) {
                    jSONObject.put("Application_Identifier", packageName);
                }
                if (privacyControlEntity != null && privacyControlEntity.getApplicationVersion()) {
                    jSONObject.put("Application_Version", str2);
                }
                if (privacyControlEntity != null && privacyControlEntity.getApplicationName()) {
                    jSONObject.put("Name", str);
                }
                if (privacyControlEntity != null && privacyControlEntity.getServerId()) {
                    jSONObject.put("ServerId", UserProfile.SERVER_ID);
                }
            } catch (Exception e3) {
                e3.printStackTrace();
            }
        } else {
            if (privacyControlEntity != null) {
                jSONObject.put("Application_Version", str2);
            }
            if (privacyControlEntity != null) {
                jSONObject.put("Name", str);
            }
            if (privacyControlEntity != null) {
                jSONObject.put("ServerId", UserProfile.SERVER_ID);
            }
        }
        return jSONObject;
    }

    private JSONObject getHardwareInfo(PrivacyControlEntity privacyControlEntity) {
        JSONObject jSONObject = new JSONObject();
        try {
            jSONObject.put("DeviceId", DeviceUuidFactory.m137id(this.context));
            if (privacyControlEntity != null && privacyControlEntity.getTotalMemory()) {
                jSONObject.put("totalMemory", getTotalMemory());
            }
            if (privacyControlEntity != null && privacyControlEntity.getAvailableMemory()) {
                jSONObject.put("availableMemory", getAvailMemory());
            }
            if (privacyControlEntity != null && privacyControlEntity.getDeviceModel()) {
                jSONObject.put("Device_Model", String.format("%s %s", Build.MANUFACTURER, Build.MODEL));
            }
            if (privacyControlEntity != null && privacyControlEntity.getFreeSpacePhone()) {
                jSONObject.put("Free_Space", getRemainDiskSpace());
            }
            if (privacyControlEntity != null && privacyControlEntity.getTotalSpacePhone()) {
                jSONObject.put("Total_Space", getTotalDiskSpace());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return jSONObject;
    }

    private JSONObject getOtherInfo(PrivacyControlEntity privacyControlEntity) {
        JSONObject jSONObject = new JSONObject();
        try {
            jSONObject.put("Platform", "android");
            jSONObject.put("Language", Const.ORIGINAL_LANGUAGE);
            jSONObject.put("SDK_Version", BuildConfig.SDK_VERSION);
            if (privacyControlEntity != null && privacyControlEntity.getOsVersion()) {
                jSONObject.put("OS_Version", Build.VERSION.RELEASE);
            }
            if (privacyControlEntity != null && privacyControlEntity.getNetworkType()) {
                jSONObject.put("Network_Type", getNetworkType());
            }
            if (privacyControlEntity != null && privacyControlEntity.getOperator()) {
                jSONObject.put("Carrier", getCarrierName());
            }
            if (privacyControlEntity != null && privacyControlEntity.getCountryCode()) {
                jSONObject.put("Country_Code", getSimCountryIso());
            }
            if (!TextUtils.isEmpty(Const.PUSH_INFO) && Const.PUSH_INFO.contains("|")) {
                String str = Const.PUSH_INFO.split("\\|")[0];
                int i = Integer.parseInt(Const.PUSH_INFO.split("\\|")[1]);
                JSONObject jsonObject = JsonHelper.getJsonObject();
                jsonObject.put("Token", str);
                jsonObject.put("PushTypeId", i);
                jSONObject.put("PushToken", jsonObject);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return jSONObject;
    }

    private String fillStoryNodeToCustomData() {
        if (TextUtils.isEmpty(UserProfile.ENTRANCE_TAGS)) {
            return UserProfile.CUSTOM_DATA;
        }
        try {
            JSONObject jsonObject = JsonHelper.getJsonObject(new JSONObject(UserProfile.CUSTOM_DATA), "elva-custom-metadata");
            String strOptString = JsonHelper.optString(jsonObject, "hs-tags");
            if (TextUtils.isEmpty(strOptString)) {
                insertUserTagsIntoCustomData(jsonObject, UserProfile.ENTRANCE_TAGS);
            } else {
                insertUserTagsIntoCustomData(jsonObject, strOptString + "," + UserProfile.ENTRANCE_TAGS);
            }
            JSONObject jSONObject = new JSONObject();
            jSONObject.put("elva-custom-metadata", jsonObject);
            jSONObject.put("hs-custom-metadata", new JSONObject(jsonObject.toString()));
            return jSONObject.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return UserProfile.CUSTOM_DATA;
        }
    }

    private void insertUserTagsIntoCustomData(JSONObject jSONObject, String str) {
        String[] strArrSplit = str.split(",");
        if (strArrSplit.length > 0) {
            try {
                jSONObject.put("elva-tags", (Object) Arrays.asList(strArrSplit));
                jSONObject.put("hs-tags", str);
            } catch (Exception unused) {
            }
        }
    }

    public String getProxyConfiguration() {
        String property = System.getProperty("http.proxyHost");
        String property2 = System.getProperty("http.proxyPort");
        if (!TextUtils.isEmpty(property) || !TextUtils.isEmpty(property2)) {
            return property + ":" + property2;
        }
        return "";
    }

    public JSONObject getGameInfo() {
        JSONObject jSONObject = new JSONObject();
        try {
            PrivacyControlEntity privacyControlEntity = CustomConfig.CommonSetting.privacyControlData;
            jSONObject.put("APPLICATION", getHostGameInfo(privacyControlEntity));
            jSONObject.put("HARDWARE", getHardwareInfo(privacyControlEntity));
            jSONObject.put("OTHER", getOtherInfo(privacyControlEntity));
            jSONObject.put("CUSTOMDATA", fillStoryNodeToCustomData());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return jSONObject;
    }

    public String getDeviceIdFromCustomData() {
        try {
            return JsonHelper.getJsonObject(new JSONObject(UserProfile.CUSTOM_DATA), "elva-custom-metadata").optString("deviceId");
        } catch (Exception unused) {
            return "";
        }
    }
}
