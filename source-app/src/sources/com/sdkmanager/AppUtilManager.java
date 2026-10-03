package com.sdkmanager;

import android.app.Activity;
import android.app.ActivityManager;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageInfo;
import android.database.Cursor;
import android.net.Uri;
import android.os.BatteryManager;
import android.os.Build;
import android.os.Environment;
import android.os.Looper;
import android.os.PowerManager;
import android.provider.MediaStore;
import android.telephony.TelephonyManager;
import android.text.TextUtils;
import android.util.Log;
import androidx.core.app.ActivityCompat;
import com.example.updateandinstall.UpdateManager;
import com.google.common.base.Ascii;
import com.google.firebase.analytics.FirebaseAnalytics;
import com.head.TakePhotoController;
import com.sdkmanager.utils.Device;
import com.sdkmanager.utils.Udid;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;
import org.json.JSONObject;

public class AppUtilManager {
    private static int CurLoginPlatform = 0;
    private static final String GPPackageName = "com.fun.lastwar.gp";
    private static volatile AppUtilManager Instance = null;
    private static final int REQUEST_CODE_ASK_SDCARD = 10;
    public static final String TAG = "AppUtilManager";
    private Activity mActivity;
    private String randomId;
    private String temporaryCacheFile = "";
    private boolean needCropPhoto = true;

    public static AppUtilManager getInstance() {
        AppUtilManager appUtilManager = Instance;
        if (appUtilManager == null) {
            synchronized (AppUtilManager.class) {
                appUtilManager = Instance;
                if (appUtilManager == null) {
                    appUtilManager = new AppUtilManager();
                    Instance = appUtilManager;
                }
            }
        }
        return appUtilManager;
    }

    public void init(Activity activity) {
        this.mActivity = activity;
    }

    public Activity getCurActivity() {
        return this.mActivity;
    }

    public static boolean isAppInForeground(Context context) {
        List<ActivityManager.RunningAppProcessInfo> runningAppProcesses = ((ActivityManager) context.getSystemService("activity")).getRunningAppProcesses();
        try {
            Field declaredField = ActivityManager.RunningAppProcessInfo.class.getDeclaredField("processState");
            for (ActivityManager.RunningAppProcessInfo runningAppProcessInfo : runningAppProcesses) {
                if (runningAppProcessInfo.importance == 100 && runningAppProcessInfo.importanceReasonCode == 0) {
                    try {
                        int i = declaredField.getInt(runningAppProcessInfo);
                        Integer numValueOf = Integer.valueOf(i);
                        if (numValueOf != null) {
                            numValueOf.getClass();
                            if (i == 2 && runningAppProcessInfo.processName.equals(context.getPackageName())) {
                                return true;
                            }
                        } else {
                            continue;
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
            return false;
        } catch (Exception e2) {
            e2.printStackTrace();
            return false;
        }
    }

    public void onRequestPermissionsResult(int i, String[] strArr, int[] iArr) {
        Log.d(TAG, "onRequestPermissionsResult  requestCode = " + i);
        if (i == 10) {
            try {
                if (SdkManager.getInstance().getSdkListener() != null) {
                    SdkManager.getInstance().getSdkListener().SendDataToGame("PermissionRecv", "");
                }
            } catch (Exception unused) {
                return;
            }
        }
        TakePhotoController.getInstance().onRequestPermissionsResult(i, strArr, iArr);
    }

    public void onActivityResult(int i, int i2, Intent intent) {
        TakePhotoController.getInstance().onActivityResult(i, i2, intent);
    }

    private void SendHeadImgUrl(String str) {
        try {
            JSONObject jSONObject = new JSONObject();
            jSONObject.put("1", str);
            SdkManager.getInstance().getSdkListener().SendDataToGame("getHeadImgUrl", jSONObject.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void copyTextToClipboard(String str) {
        if (Looper.myLooper() == null) {
            Looper.prepare();
        }
        ((ClipboardManager) this.mActivity.getSystemService("clipboard")).setPrimaryClip(ClipData.newPlainText("simple text", str));
    }

    public boolean checkSDCardAvailable() {
        try {
            return "mounted".equals(Environment.getExternalStorageState());
        } catch (Exception unused) {
            return false;
        }
    }

    private String getGpSdCacheDir() {
        return Environment.getExternalStorageDirectory().getAbsolutePath() + "/com.fun.lastwar.debug/";
    }

    private String getSdCacheDir() {
        return getGpSdCacheDir();
    }

    public void saveDataToSdcard(String str, String str2) {
        if (checkSDCardAvailable()) {
            String sdCacheDir = getSdCacheDir();
            File file = new File(sdCacheDir);
            if (!file.exists()) {
                file.mkdirs();
            }
            try {
                FileWriter fileWriter = new FileWriter(sdCacheDir + str2);
                fileWriter.write(str);
                fileWriter.close();
            } catch (Throwable th) {
                th.printStackTrace();
            }
        }
    }

    public String getPublishChannel() {
        try {
            String string = this.mActivity.getPackageManager().getApplicationInfo(this.mActivity.getPackageName(), 128).metaData.getString("CHANNEL");
            return (string == null || string.isEmpty()) ? "market_global" : string;
        } catch (Exception e) {
            e.printStackTrace();
            return "market_global";
        }
    }

    public void SendDataToNative(String str, String str2) {
        byte b;
        if (str == null || str.equals("") || str2 == null || str2.equals("")) {
            return;
        }
        try {
            JSONObject jSONObject = new JSONObject(str2);
            switch (str.hashCode()) {
                case -658105019:
                    if (!str.equals("PM_saveDataToSdCard")) {
                        b = -1;
                    } else {
                        b = 0;
                    }
                    break;
                case -525226384:
                    if (!str.equals("PM_OnUploadPhoto")) {
                        b = -1;
                    } else {
                        b = 1;
                    }
                    break;
                case 418409119:
                    if (!str.equals("PM_OnUploadSelectPhotos")) {
                        b = -1;
                    } else {
                        b = 2;
                    }
                    break;
                case 916235383:
                    if (!str.equals("PM_copyTextToClipboard")) {
                        b = -1;
                    } else {
                        b = 3;
                    }
                    break;
                default:
                    b = -1;
                    break;
            }
            if (b == 0) {
                saveDataToSdcard(jSONObject.getString("data"), jSONObject.getString("filename"));
                return;
            }
            if (b == 1) {
                TakePhotoController.getInstance().OnUploadPhoto(jSONObject.optString("uid", ""), jSONObject.optInt("code", -1), jSONObject.optInt("idx", 0), jSONObject.optInt("photoResolutionLimit", TakePhotoController.photoResolutionLimit), jSONObject.optInt("photoFileSizeLimit", TakePhotoController.photoFileSizeLimit), jSONObject.optInt("suitableResolutionSizeBig", (int) TakePhotoController.suitableResolutionSizeBig), jSONObject.optInt("suitableResolutionSizeSmall", (int) TakePhotoController.suitableResolutionSizeSmall));
                return;
            }
            if (b == 2) {
                TakePhotoController.getInstance().OnUploadPhotos(jSONObject.optString("uid", ""), jSONObject.optInt("code", -1), jSONObject.optInt("idx", 0), jSONObject.optInt("photoResolutionLimit", TakePhotoController.photoResolutionLimit), jSONObject.optInt("photoFileSizeLimit", TakePhotoController.photoFileSizeLimit), jSONObject.optInt("suitableResolutionSizeBig", (int) TakePhotoController.suitableResolutionSizeBig), jSONObject.optInt("suitableResolutionSizeSmall", (int) TakePhotoController.suitableResolutionSizeSmall), jSONObject.optInt("maxNum", 1));
                return;
            }
            if (b != 3) {
                return;
            }
            try {
                copyTextToClipboard(jSONObject.getString(FirebaseAnalytics.Param.CONTENT));
            } catch (Exception e) {
                e.printStackTrace();
            }
        } catch (Exception e2) {
            e2.printStackTrace();
        }
    }

    private boolean addPermission(List<String> list, String str) {
        if (this.mActivity.checkSelfPermission(str) == 0) {
            return true;
        }
        list.add(str);
        return !this.mActivity.shouldShowRequestPermissionRationale(str);
    }

    public void requestSdPermit() {
        if (this.mActivity.getApplicationInfo().targetSdkVersion >= 30) {
            SdkManager.getInstance().getSdkListener().SendDataToGame("PermissionRecv", "");
            return;
        }
        ArrayList arrayList = new ArrayList();
        ArrayList arrayList2 = new ArrayList();
        if (!addPermission(arrayList2, "android.permission.WRITE_EXTERNAL_STORAGE")) {
            arrayList.add("storage");
        }
        if (!addPermission(arrayList2, "android.permission.READ_EXTERNAL_STORAGE")) {
            arrayList.add("read storage");
        }
        if (arrayList2.size() > 0) {
            if (arrayList.size() > 0) {
                this.mActivity.requestPermissions((String[]) arrayList2.toArray(new String[arrayList2.size()]), 10);
                return;
            } else {
                this.mActivity.requestPermissions((String[]) arrayList2.toArray(new String[arrayList2.size()]), 10);
                return;
            }
        }
        SdkManager.getInstance().getSdkListener().SendDataToGame("PermissionRecv", "");
    }

    public String GetDataFromNative(String str, String str2) {
        if (str == null || str.equals("")) {
            return "";
        }
        str.hashCode();
        byte b = -1;
        switch (str.hashCode()) {
            case -1134965682:
                if (str.equals("PM_checkDownloadApk")) {
                    b = 0;
                }
                break;
            case -1106788582:
                if (str.equals("PM_generateHighVersionUUID")) {
                    b = 1;
                }
                break;
            case -502804919:
                if (str.equals("PM_getDatFromFile")) {
                    b = 2;
                }
                break;
            case -494937287:
                if (str.equals("PM_requestSdPermit")) {
                    b = 3;
                }
                break;
            case -420335823:
                if (str.equals("PM_getPowerSaveMode")) {
                    b = 4;
                }
                break;
            case -201005115:
                if (str.equals("PM_getBatteryVoltage")) {
                    b = 5;
                }
                break;
            case -84349885:
                if (str.equals("PM_getSerialID")) {
                    b = 6;
                }
                break;
            case 293554656:
                if (str.equals("PM_getBatteryCurrent")) {
                    b = 7;
                }
                break;
            case 392039250:
                if (str.equals("PM_DoInitGooglePay")) {
                    b = 8;
                }
                break;
            case 898044159:
                if (str.equals("PM_getBatteryRemainCapacity")) {
                    b = 9;
                }
                break;
            case 1150260264:
                if (str.equals("PM_getPublishChannel")) {
                    b = 10;
                }
                break;
            case 1400603649:
                if (str.equals("PM_CheckSelfPermission")) {
                    b = Ascii.f93VT;
                }
                break;
            case 1547391975:
                if (str.equals("PM_getSimOperator")) {
                    b = Ascii.f82FF;
                }
                break;
            case 1698035474:
                if (str.equals("PM_getSimOperatorName")) {
                    b = Ascii.f80CR;
                }
                break;
            case 1765991473:
                if (str.equals("PM_getVersionCode")) {
                    b = Ascii.f90SO;
                }
                break;
            case 1876275725:
                if (str.equals("PM_getHandSetInfo")) {
                    b = Ascii.f89SI;
                }
                break;
            case 1923985752:
                if (str.equals("PM_getDeviceInfo")) {
                    b = Ascii.DLE;
                }
                break;
            case 1924301940:
                if (str.equals("PM_getDeviceUDID")) {
                    b = 17;
                }
                break;
            case 1943229895:
                if (str.equals("PM_getAccountInfo")) {
                    b = Ascii.DC2;
                }
                break;
            case 2029728559:
                if (str.equals("PM_GetPermit")) {
                    b = 19;
                }
                break;
            case 2039204017:
                if (str.equals("PM_getAndroidScreenNotch")) {
                    b = Ascii.DC4;
                }
                break;
        }
        switch (b) {
            case 0:
                UpdateManager.getInstance().CheckCnApkDownload(0);
                return "";
            case 1:
                return Udid.generateHighVersionUUID();
            case 2:
                return getDataFromFile(str2);
            case 3:
                requestSdPermit();
                return "";
            case 4:
                return getPowerSaveMode();
            case 5:
                return getBatteryVoltage();
            case 6:
                return Udid.getSerialId();
            case 7:
                return getBatteryCurrent();
            case 8:
                SdkManager.getInstance().InitGooglePay();
                return "";
            case 9:
                return getBatteryRemainCapacity();
            case 10:
                return getPublishChannel();
            case 11:
                if (str2 == null || str2 == "") {
                    return "";
                }
                return Integer.toString(ActivityCompat.checkSelfPermission(this.mActivity, str2));
            case 12:
                return getSimOperator();
            case 13:
                return getSimOperatorName();
            case 14:
                return getVersionCode();
            case 15:
                return Device.getHandSetInfo();
            case 16:
                return Udid.getDeviceInfo();
            case 17:
                return Udid.getUid();
            case 18:
                return Device.getAccountInfo();
            case 19:
                if (str2 == null || str2 == "") {
                    return "";
                }
                return TakePhotoController.getInstance().GetCurPermission(Integer.valueOf(str2).intValue());
            case 20:
                return Udid.getAndroidScreenNotch();
            default:
                return "";
        }
    }

    public String getDataFromFile(String str) {
        if (checkSDCardAvailable()) {
            String sdCacheDir = getSdCacheDir();
            try {
                if (!new File(sdCacheDir).exists()) {
                    return "";
                }
                BufferedReader bufferedReader = new BufferedReader(new FileReader(sdCacheDir + str));
                String line = bufferedReader.readLine();
                bufferedReader.close();
                return line;
            } catch (Throwable th) {
                th.printStackTrace();
            }
        }
        return "";
    }

    private void Error(String str) {
        Log.e(TAG, str);
    }

    private void Debug(String str) {
        Log.i(TAG, str);
    }

    public Uri getImageContentUri(File file) {
        if (Build.VERSION.SDK_INT >= 24) {
            String absolutePath = file.getAbsolutePath();
            Cursor cursorQuery = this.mActivity.getContentResolver().query(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, new String[]{"_id"}, "_data=? ", new String[]{absolutePath}, null);
            Uri uriWithAppendedPath = null;
            if (cursorQuery != null) {
                try {
                    if (cursorQuery.moveToFirst()) {
                        int i = cursorQuery.getInt(cursorQuery.getColumnIndex("_id"));
                        uriWithAppendedPath = Uri.withAppendedPath(Uri.parse("content://media/external/images/media"), "" + i);
                        cursorQuery.close();
                    } else if (file.exists()) {
                        ContentValues contentValues = new ContentValues();
                        contentValues.put("_data", absolutePath);
                        uriWithAppendedPath = this.mActivity.getContentResolver().insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, contentValues);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    return uriWithAppendedPath;
                }
            } else if (file.exists()) {
                ContentValues contentValues2 = new ContentValues();
                contentValues2.put("_data", absolutePath);
                uriWithAppendedPath = this.mActivity.getContentResolver().insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, contentValues2);
            }
            return uriWithAppendedPath;
        }
        return Uri.fromFile(file);
    }

    public String getImagePath(Uri uri) {
        String string = null;
        if (uri == null) {
            return null;
        }
        String scheme = uri.getScheme();
        if (scheme == null) {
            return uri.getPath();
        }
        if ("file".equals(scheme)) {
            return uri.getPath();
        }
        if (!FirebaseAnalytics.Param.CONTENT.equals(scheme)) {
            return null;
        }
        Cursor cursorQuery = this.mActivity.getContentResolver().query(uri, new String[]{"_data"}, null, null, null);
        if (cursorQuery != null) {
            try {
                if (cursorQuery.moveToFirst()) {
                    string = cursorQuery.getString(cursorQuery.getColumnIndexOrThrow("_data"));
                }
            } catch (Exception e) {
                e.printStackTrace();
                return string;
            }
        }
        cursorQuery.close();
        return string;
    }

    public void CopyFile(String str, String str2) throws Throwable {
        FileOutputStream fileOutputStream;
        FileInputStream fileInputStream = null;
        try {
            try {
                File file = new File(str);
                if (file.exists()) {
                    FileInputStream fileInputStream2 = new FileInputStream(file);
                    try {
                        byte[] bArr = new byte[1024];
                        fileOutputStream = new FileOutputStream(str2);
                        while (fileInputStream2.read(bArr) != -1) {
                            try {
                                fileOutputStream.write(bArr);
                            } catch (Exception e) {
                                e = e;
                                fileInputStream = fileInputStream2;
                                try {
                                    e.printStackTrace();
                                    if (fileInputStream != null) {
                                        fileInputStream.close();
                                    }
                                    if (fileOutputStream != null) {
                                        fileOutputStream.close();
                                        return;
                                    }
                                    return;
                                } catch (Throwable th) {
                                    th = th;
                                    if (fileInputStream != null) {
                                        try {
                                            fileInputStream.close();
                                            if (fileOutputStream != null) {
                                                fileOutputStream.close();
                                            }
                                        } catch (Exception e2) {
                                            e2.printStackTrace();
                                            throw th;
                                        }
                                    } else if (fileOutputStream != null) {
                                        fileOutputStream.close();
                                    }
                                    throw th;
                                }
                            } catch (Throwable th2) {
                                th = th2;
                                fileInputStream = fileInputStream2;
                                if (fileInputStream != null) {
                                    fileInputStream.close();
                                    if (fileOutputStream != null) {
                                        fileOutputStream.close();
                                    }
                                } else if (fileOutputStream != null) {
                                    fileOutputStream.close();
                                }
                                throw th;
                            }
                        }
                        fileInputStream = fileInputStream2;
                    } catch (Exception e3) {
                        e = e3;
                        fileOutputStream = null;
                    } catch (Throwable th3) {
                        th = th3;
                        fileOutputStream = null;
                    }
                } else {
                    fileOutputStream = null;
                }
                if (fileInputStream != null) {
                    fileInputStream.close();
                }
                if (fileOutputStream != null) {
                    fileOutputStream.close();
                }
            } catch (Exception e4) {
                e4.printStackTrace();
            }
        } catch (Exception e5) {
            e = e5;
            fileOutputStream = null;
        } catch (Throwable th4) {
            th = th4;
            fileOutputStream = null;
        }
    }

    private String getSimOperator() {
        try {
            TelephonyManager telephonyManager = (TelephonyManager) this.mActivity.getSystemService("phone");
            if (telephonyManager == null) {
                return "null";
            }
            if (telephonyManager.getSimState() != 5) {
                return "not-ready";
            }
            return telephonyManager.getSimOperator();
        } catch (Exception unused) {
            return "";
        }
    }

    private String getSimOperatorName() {
        try {
            TelephonyManager telephonyManager = (TelephonyManager) this.mActivity.getSystemService("phone");
            if (telephonyManager == null) {
                return "null";
            }
            if (telephonyManager.getSimState() != 5) {
                return "not-ready";
            }
            return telephonyManager.getSimOperatorName();
        } catch (Exception unused) {
            return "";
        }
    }

    public String getInternalDir() {
        Activity activity = this.mActivity;
        if (activity == null) {
            return "not found";
        }
        return activity.getFilesDir().getAbsolutePath();
    }

    public String getExternalDir() {
        Activity activity = this.mActivity;
        if (activity == null) {
            return "not found";
        }
        return activity.getExternalFilesDir(null).getAbsolutePath();
    }

    public String getSdCardStatus() {
        Activity activity = this.mActivity;
        if (activity == null) {
            return "";
        }
        String str = String.format("external %s, internal %s", activity.getExternalFilesDir(null).getAbsolutePath(), this.mActivity.getFilesDir().getAbsolutePath());
        if (checkSDCardAvailable()) {
            return str + "Have SD Permit";
        }
        return str + "not have sd permit";
    }

    public String getVersionCode() {
        try {
            Activity activity = this.mActivity;
            if (activity == null) {
                return "";
            }
            PackageInfo packageInfo = activity.getPackageManager().getPackageInfo(this.mActivity.getPackageName(), 16384);
            String str = packageInfo.versionName;
            return String.valueOf(packageInfo.versionCode);
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    public String getUidFromStorage() {
        if (Build.VERSION.SDK_INT < 30 && checkSDCardAvailable()) {
            String sdCacheDir = getSdCacheDir();
            try {
                new File(sdCacheDir);
                BufferedReader bufferedReader = new BufferedReader(new FileReader(sdCacheDir + "uid.txt"));
                String line = bufferedReader.readLine();
                bufferedReader.close();
                return line;
            } catch (Throwable unused) {
            }
        }
        return "";
    }

    public String GetRandomId() {
        if (TextUtils.isEmpty(this.randomId)) {
            this.randomId = Udid.getUid();
        }
        return this.randomId;
    }

    private String getBatteryVoltage() {
        Intent intentRegisterReceiver = this.mActivity.registerReceiver(null, new IntentFilter("android.intent.action.BATTERY_CHANGED"));
        return String.valueOf(intentRegisterReceiver != null ? ((double) intentRegisterReceiver.getIntExtra("voltage", -1)) / 1000.0d : -1.0d);
    }

    private String getBatteryCurrent() {
        BatteryManager batteryManager = (BatteryManager) this.mActivity.getSystemService("batterymanager");
        if (batteryManager == null) {
            return "-1";
        }
        return String.valueOf(((double) batteryManager.getIntProperty(2)) / 1000000.0d);
    }

    private String getBatteryRemainCapacity() {
        BatteryManager batteryManager = (BatteryManager) this.mActivity.getSystemService("batterymanager");
        if (batteryManager == null) {
            return "-1";
        }
        return String.valueOf(batteryManager.getIntProperty(4));
    }

    private String getPowerSaveMode() {
        PowerManager powerManager = (PowerManager) this.mActivity.getSystemService("power");
        if (powerManager == null || !powerManager.isPowerSaveMode()) {
            return "false";
        }
        return "true";
    }
}
