package com.sdkmanager.utils;

import android.app.Activity;
import android.app.ActivityManager;
import android.app.usage.StorageStats;
import android.app.usage.StorageStatsManager;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Build;
import android.os.Looper;
import android.os.Process;
import android.os.SystemClock;
import android.os.storage.StorageManager;
import android.telephony.TelephonyManager;
import android.text.TextUtils;
import android.util.Log;
import com.google.firebase.analytics.FirebaseAnalytics;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import org.json.JSONObject;

public class Device {
    private static final long APP_STORAGE_SIZE_CACHE_EXPIRE_MS = 21600000;
    public static final int DEVICEINFO_UNKNOWN = -1;
    private static final String TAG = "Device";
    private static Activity _mActivity;
    private static final ExecutorService STORAGE_STATS_EXECUTOR = Executors.newSingleThreadExecutor();
    private static volatile String sLastAppStorageSizeJson = "";
    private static volatile long sLastAppStorageSizeTimeMs = 0;
    private static volatile boolean sIsStorageStatsCollecting = false;
    private static Context _context = null;
    private static final FileFilter CPU_FILTER = new FileFilter() {
        @Override
        public boolean accept(File file) {
            String name = file.getName();
            if (!name.startsWith("cpu")) {
                return false;
            }
            for (int i = 3; i < name.length(); i++) {
                if (!Character.isDigit(name.charAt(i))) {
                    return false;
                }
            }
            return true;
        }
    };

    public interface StorageSizeCallback {
        void onResult(String str);
    }

    public static void init(Context context) {
        _context = context;
        _mActivity = (Activity) context;
    }

    public static String getAccountInfo() {
        return "";
    }

    public static String getHandSetInfo() {
        TelephonyManager telephonyManager;
        try {
            String str = "unknown";
            Context context = _context;
            NetworkInfo activeNetworkInfo = null;
            if (context != null) {
                telephonyManager = (TelephonyManager) context.getSystemService("phone");
                ConnectivityManager connectivityManager = (ConnectivityManager) _context.getSystemService("connectivity");
                if (connectivityManager != null) {
                    activeNetworkInfo = connectivityManager.getActiveNetworkInfo();
                }
            } else {
                telephonyManager = null;
            }
            if (activeNetworkInfo != null) {
                if (activeNetworkInfo.getType() == 1) {
                    str = "Wifi";
                } else if (activeNetworkInfo.getType() == 0 && telephonyManager != null) {
                    switch (telephonyManager.getNetworkType()) {
                        case 1:
                        case 2:
                        case 4:
                        case 7:
                        case 11:
                        case 16:
                            str = "2G";
                            break;
                        case 3:
                        case 5:
                        case 6:
                        case 8:
                        case 9:
                        case 10:
                        case 12:
                        case 14:
                        case 15:
                        case 17:
                            str = "3G";
                            break;
                        case 13:
                        case 18:
                            str = "4G";
                            break;
                    }
                }
            }
            StringBuilder sb = new StringBuilder("Model:");
            sb.append(Build.MODEL == null ? "" : Build.MODEL.replace(",", ""));
            sb.append(",SDKVersion:");
            sb.append(Build.VERSION.SDK_INT);
            sb.append(",SYSVersion:");
            sb.append(Build.VERSION.RELEASE == null ? "" : Build.VERSION.RELEASE.replace(",", ""));
            sb.append(",Brand:");
            sb.append(Build.BRAND == null ? "" : Build.BRAND.replace(",", ""));
            sb.append(",SimProvider:");
            sb.append((telephonyManager == null || telephonyManager.getSimOperator() == null) ? "" : telephonyManager.getSimOperator().replace(",", ""));
            sb.append(",NetWork:");
            sb.append(str.replace(",", ""));
            return sb.toString();
        } catch (Exception unused) {
            return "";
        }
    }

    public static long getTotalMemory() {
        ActivityManager.MemoryInfo memoryInfo = new ActivityManager.MemoryInfo();
        ((ActivityManager) _mActivity.getSystemService("activity")).getMemoryInfo(memoryInfo);
        return memoryInfo.totalMem;
    }

    public static int getCPUMaxFreqKHz() {
        int i = -1;
        for (int i2 = 0; i2 < getNumberOfCPUCores(); i2++) {
            try {
                File file = new File("/sys/devices/system/cpu/cpu" + i2 + "/cpufreq/cpuinfo_max_freq");
                if (file.exists() && file.canRead()) {
                    byte[] bArr = new byte[128];
                    FileInputStream fileInputStream = new FileInputStream(file);
                    try {
                        fileInputStream.read(bArr);
                        int i3 = 0;
                        while (Character.isDigit(bArr[i3]) && i3 < 128) {
                            i3++;
                        }
                        int i4 = Integer.parseInt(new String(bArr, 0, i3));
                        Integer numValueOf = Integer.valueOf(i4);
                        numValueOf.getClass();
                        if (i4 > i) {
                            numValueOf.getClass();
                            i = i4;
                        }
                    } catch (NumberFormatException unused) {
                    } catch (Throwable th) {
                        fileInputStream.close();
                        throw th;
                    }
                    fileInputStream.close();
                }
            } catch (IOException unused2) {
                return -1;
            }
        }
        if (i == -1) {
            FileInputStream fileInputStream2 = new FileInputStream("/proc/cpuinfo");
            try {
                int fileForValue = parseFileForValue("cpu MHz", fileInputStream2) * 1000;
                if (fileForValue > i) {
                    i = fileForValue;
                }
            } finally {
                fileInputStream2.close();
            }
        }
        return i;
    }

    public static int getNumberOfCPUCores() {
        try {
            int coresFromFileInfo = getCoresFromFileInfo("/sys/devices/system/cpu/possible");
            if (coresFromFileInfo == -1) {
                coresFromFileInfo = getCoresFromFileInfo("/sys/devices/system/cpu/present");
            }
            return coresFromFileInfo == -1 ? new File("/sys/devices/system/cpu/").listFiles(CPU_FILTER).length : coresFromFileInfo;
        } catch (NullPointerException | SecurityException unused) {
            return -1;
        }
    }

    private static int getCoresFromFileInfo(String str) throws Throwable {
        FileInputStream fileInputStream = null;
        try {
            FileInputStream fileInputStream2 = new FileInputStream(str);
            try {
                BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(fileInputStream2));
                String line = bufferedReader.readLine();
                bufferedReader.close();
                int coresFromFileString = getCoresFromFileString(line);
                try {
                    fileInputStream2.close();
                } catch (IOException unused) {
                }
                return coresFromFileString;
            } catch (IOException unused2) {
                fileInputStream = fileInputStream2;
                if (fileInputStream == null) {
                    return -1;
                }
                try {
                    fileInputStream.close();
                    return -1;
                } catch (IOException unused3) {
                    return -1;
                }
            } catch (Throwable th) {
                th = th;
                fileInputStream = fileInputStream2;
                if (fileInputStream != null) {
                    try {
                        fileInputStream.close();
                    } catch (IOException unused4) {
                    }
                }
                throw th;
            }
        } catch (IOException unused5) {
        } catch (Throwable th2) {
            th = th2;
        }
    }

    private static int getCoresFromFileString(String str) {
        if (str == null || !str.matches("0-[\\d]+$")) {
            return -1;
        }
        return Integer.valueOf(str.substring(2)).intValue() + 1;
    }

    private static int parseFileForValue(String str, FileInputStream fileInputStream) {
        byte[] bArr = new byte[1024];
        try {
            int i = fileInputStream.read(bArr);
            int i2 = 0;
            while (i2 < i) {
                byte b = bArr[i2];
                if (b == 10 || i2 == 0) {
                    if (b == 10) {
                        i2++;
                    }
                    for (int i3 = i2; i3 < i; i3++) {
                        int i4 = i3 - i2;
                        if (bArr[i3] != str.charAt(i4)) {
                            break;
                        }
                        if (i4 == str.length() - 1) {
                            return extractValue(bArr, i3);
                        }
                    }
                }
                i2++;
            }
            return -1;
        } catch (IOException | NumberFormatException unused) {
            return -1;
        }
    }

    private static int extractValue(byte[] bArr, int i) {
        byte b;
        while (i < bArr.length && (b = bArr[i]) != 10) {
            if (Character.isDigit(b)) {
                int i2 = i + 1;
                while (i2 < bArr.length && Character.isDigit(bArr[i2])) {
                    i2++;
                }
                return Integer.parseInt(new String(bArr, 0, i, i2 - i));
            }
            i++;
        }
        return -1;
    }

    public long getAvailMemory() {
        ActivityManager activityManager = (ActivityManager) _mActivity.getSystemService("activity");
        ActivityManager.MemoryInfo memoryInfo = new ActivityManager.MemoryInfo();
        activityManager.getMemoryInfo(memoryInfo);
        return memoryInfo.availMem;
    }

    public static String getBrand() {
        return Build.BRAND;
    }

    public static String getModel() {
        return Build.MODEL;
    }

    public static String getHardWare() {
        try {
            BufferedReader bufferedReader = new BufferedReader(new FileReader("/proc/cpuinfo"));
            String str = "";
            while (true) {
                String line = bufferedReader.readLine();
                if (line == null) {
                    break;
                }
                str = line;
            }
            if (str.contains("Hardware")) {
                return str.split(":\\s+", 2)[1];
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e2) {
            e2.printStackTrace();
        }
        return Build.HARDWARE;
    }

    public static String getAppStorageSizeData(String str) {
        boolean zOptBoolean;
        if (Build.VERSION.SDK_INT < 26) {
            return buildAppStorageUnsupportedJson("api_too_low");
        }
        if (_context == null) {
            return buildAppStorageErrorJson("context_invalid", 0L);
        }
        boolean z = false;
        try {
            zOptBoolean = !TextUtils.isEmpty(str) ? new JSONObject(str).optBoolean("forceRefresh", false) : false;
        } catch (Exception unused) {
        }
        long jCurrentTimeMillis = System.currentTimeMillis();
        if (!TextUtils.isEmpty(sLastAppStorageSizeJson) && jCurrentTimeMillis - sLastAppStorageSizeTimeMs < APP_STORAGE_SIZE_CACHE_EXPIRE_MS) {
            z = true;
        }
        if (!zOptBoolean && z) {
            return sLastAppStorageSizeJson;
        }
        if (Looper.getMainLooper() == Looper.myLooper()) {
            return buildAppStoragePendingJson("main_thread_pending");
        }
        String strCollectAppStorageSizeJson = collectAppStorageSizeJson();
        cacheAppStorageSizeResult(strCollectAppStorageSizeJson);
        return strCollectAppStorageSizeJson;
    }

    public static void requestAppStorageSizeAsync(String str, final StorageSizeCallback storageSizeCallback) {
        if (Build.VERSION.SDK_INT < 26) {
            if (storageSizeCallback != null) {
                storageSizeCallback.onResult(buildAppStorageUnsupportedJson("api_too_low"));
            }
        } else if (_context == null) {
            if (storageSizeCallback != null) {
                storageSizeCallback.onResult(buildAppStorageErrorJson("context_invalid", 0L));
            }
        } else if (!sIsStorageStatsCollecting) {
            sIsStorageStatsCollecting = true;
            STORAGE_STATS_EXECUTOR.submit(new Runnable() {
                @Override
                public void run() {
                    String strBuildAppStorageErrorJson = Device.buildAppStorageErrorJson("unknown", 0L);
                    try {
                        try {
                            strBuildAppStorageErrorJson = Device.collectAppStorageSizeJson();
                            Device.cacheAppStorageSizeResult(strBuildAppStorageErrorJson);
                            boolean unused = Device.sIsStorageStatsCollecting = false;
                            StorageSizeCallback storageSizeCallback2 = storageSizeCallback;
                            if (storageSizeCallback2 != null) {
                                storageSizeCallback2.onResult(strBuildAppStorageErrorJson);
                            }
                        } catch (Exception e) {
                            Log.e(Device.TAG, "collectAppStorageSizeJson async error: " + e);
                            String strBuildAppStorageErrorJson2 = Device.buildAppStorageErrorJson("exception", 0L);
                            boolean unused2 = Device.sIsStorageStatsCollecting = false;
                            StorageSizeCallback storageSizeCallback3 = storageSizeCallback;
                            if (storageSizeCallback3 != null) {
                                storageSizeCallback3.onResult(strBuildAppStorageErrorJson2);
                            }
                        }
                    } catch (Throwable th) {
                        boolean unused3 = Device.sIsStorageStatsCollecting = false;
                        StorageSizeCallback storageSizeCallback4 = storageSizeCallback;
                        if (storageSizeCallback4 != null) {
                            storageSizeCallback4.onResult(strBuildAppStorageErrorJson);
                        }
                        throw th;
                    }
                }
            });
        } else if (storageSizeCallback != null) {
            storageSizeCallback.onResult(buildAppStoragePendingJson("collecting"));
        }
    }

    public static void cacheAppStorageSizeResult(String str) {
        if (TextUtils.isEmpty(str)) {
            return;
        }
        sLastAppStorageSizeJson = str;
        sLastAppStorageSizeTimeMs = System.currentTimeMillis();
    }

    public static String collectAppStorageSizeJson() {
        long jElapsedRealtime = SystemClock.elapsedRealtime();
        JSONObject jSONObject = new JSONObject();
        try {
            if (Build.VERSION.SDK_INT < 26) {
                jSONObject.put("ok", 0);
                jSONObject.put("reason", "api_too_low");
                jSONObject.put("durationMs", SystemClock.elapsedRealtime() - jElapsedRealtime);
                return jSONObject.toString();
            }
            Context context = _context;
            if (context == null) {
                return buildAppStorageErrorJson("context_invalid", SystemClock.elapsedRealtime() - jElapsedRealtime);
            }
            StorageStatsManager storageStatsManagerM406m = Udid$$ExternalSyntheticApiModelOutline0.m406m(context.getSystemService("storagestats"));
            if (storageStatsManagerM406m == null) {
                return buildAppStorageErrorJson("service_null", SystemClock.elapsedRealtime() - jElapsedRealtime);
            }
            String packageName = context.getPackageName();
            ApplicationInfo applicationInfo = context.getPackageManager().getApplicationInfo(packageName, 0);
            StorageStats storageStatsQueryStatsForPackage = storageStatsManagerM406m.queryStatsForPackage(applicationInfo.storageUuid != null ? applicationInfo.storageUuid : StorageManager.UUID_DEFAULT, packageName, Process.myUserHandle());
            long appBytes = storageStatsQueryStatsForPackage.getAppBytes();
            long dataBytes = storageStatsQueryStatsForPackage.getDataBytes();
            long cacheBytes = storageStatsQueryStatsForPackage.getCacheBytes();
            jSONObject.put("ok", 1);
            jSONObject.put("reason", FirebaseAnalytics.Param.SUCCESS);
            jSONObject.put("appBytes", appBytes);
            jSONObject.put("dataBytes", dataBytes);
            jSONObject.put("cacheBytes", cacheBytes);
            jSONObject.put("totalBytes", appBytes + dataBytes + cacheBytes);
            jSONObject.put("durationMs", SystemClock.elapsedRealtime() - jElapsedRealtime);
            return jSONObject.toString();
        } catch (Exception e) {
            Log.e(TAG, "collectAppStorageSizeJson error: " + e);
            return buildAppStorageErrorJson("query_failed", SystemClock.elapsedRealtime() - jElapsedRealtime);
        }
    }

    private static String buildAppStoragePendingJson(String str) {
        JSONObject jSONObject = new JSONObject();
        try {
            jSONObject.put("ok", 0);
            jSONObject.put("reason", str);
        } catch (Exception unused) {
        }
        return jSONObject.toString();
    }

    private static String buildAppStorageUnsupportedJson(String str) {
        JSONObject jSONObject = new JSONObject();
        try {
            jSONObject.put("ok", 0);
            jSONObject.put("reason", str);
        } catch (Exception unused) {
        }
        return jSONObject.toString();
    }

    public static String buildAppStorageErrorJson(String str, long j) {
        JSONObject jSONObject = new JSONObject();
        try {
            jSONObject.put("ok", 0);
            jSONObject.put("reason", str);
            jSONObject.put("durationMs", j);
        } catch (Exception unused) {
        }
        return jSONObject.toString();
    }
}
