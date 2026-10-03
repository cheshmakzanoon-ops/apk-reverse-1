package com.sdkmanager.utils;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.provider.Settings;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.DisplayCutout;
import android.view.WindowInsets;
import com.google.common.base.Ascii;
import com.google.common.primitives.UnsignedBytes;
import com.ishumei.smantifraud.l111l1111lI1l;
import com.sdkmanager.AppUtilManager;
import com.sdkmanager.SdkManager;
import j$.util.DesugarTimeZone;
import java.io.File;
import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.UUID;

public class Udid {
    private static final String KEY_SUID = "im30sysuuid";
    private static final String KEY_UUID = "uuid";
    public static boolean isNewInstallDevice;
    private static String[] known_files = {"/sys/qemu_trace", "/system/bin/qemu-props"};

    private static String getUuid() {
        try {
            String string = Settings.System.getString(AppUtilManager.getInstance().getCurActivity().getContentResolver(), KEY_UUID);
            try {
                return TextUtils.isEmpty(string) ? "" : string;
            } catch (Throwable unused) {
                return string;
            }
        } catch (Throwable unused2) {
            return "";
        }
    }

    public static String getSUid() {
        return getUuid();
    }

    private static String getReUid() {
        return AppUtilManager.getInstance().getCurActivity().getSharedPreferences(".loginfo", 0).getString(l111l1111lI1l.l11l1111Il1l, "");
    }

    public static void saveUid(String str) {
        SharedPreferences.Editor editorEdit = AppUtilManager.getInstance().getCurActivity().getSharedPreferences(".loginfo", 0).edit();
        editorEdit.putString(l111l1111lI1l.l11l1111Il1l, str);
        editorEdit.putBoolean("isGM", false);
        editorEdit.putLong("lastLoginTime", new GregorianCalendar(DesugarTimeZone.getTimeZone("GMT")).getTime().getTime());
        editorEdit.putString("deviceId", UUID.randomUUID().toString());
        try {
            editorEdit.commit();
        } catch (Exception unused) {
            Log.d("Liudi Test", "uuid writing system failed");
        }
    }

    public static String getAccountManagerInfo() {
        return "";
    }

    public static String getUid() {
        Activity curActivity = AppUtilManager.getInstance().getCurActivity();
        String strGetGaid = SdkManager.getInstance().GetGaid();
        if (strGetGaid == null || strGetGaid.equals("")) {
            strGetGaid = Settings.System.getString(curActivity.getContentResolver(), "android_id");
        }
        saveUid(strGetGaid);
        return strGetGaid;
    }

    public static String getSerialId() {
        try {
            String str = Build.SERIAL;
            return str == null ? "" : str;
        } catch (Exception unused) {
            return "error";
        }
    }

    public static String getDeviceInfo() {
        try {
            DisplayMetrics displayMetrics = new DisplayMetrics();
            AppUtilManager.getInstance().getCurActivity().getWindowManager().getDefaultDisplay().getMetrics(displayMetrics);
            StringBuffer stringBuffer = new StringBuffer();
            stringBuffer.append(Build.BOARD + " ");
            stringBuffer.append(Build.HARDWARE + " ");
            stringBuffer.append(Build.BRAND + " ");
            stringBuffer.append(Build.CPU_ABI + " ");
            stringBuffer.append(Build.CPU_ABI2 + " ");
            stringBuffer.append(Build.DEVICE + " ");
            stringBuffer.append(Build.MANUFACTURER + " ");
            stringBuffer.append(Build.SERIAL + " ");
            stringBuffer.append(Build.PRODUCT + " ");
            stringBuffer.append(displayMetrics.widthPixels + " ");
            stringBuffer.append(displayMetrics.heightPixels + " ");
            stringBuffer.append(displayMetrics.densityDpi + " ");
            stringBuffer.append(Build.FINGERPRINT + " ");
            stringBuffer.append(Build.MANUFACTURER + " ");
            stringBuffer.append(Build.MODEL + " ");
            return stringBuffer.toString();
        } catch (Exception unused) {
            return "error";
        }
    }

    public static String getAndroidScreenNotch() {
        WindowInsets rootWindowInsets;
        DisplayCutout displayCutout;
        List boundingRects;
        if (Build.VERSION.SDK_INT < 28 || (rootWindowInsets = AppUtilManager.getInstance().getCurActivity().getWindow().getDecorView().getRootWindowInsets()) == null || (displayCutout = rootWindowInsets.getDisplayCutout()) == null || (boundingRects = displayCutout.getBoundingRects()) == null || boundingRects.size() <= 0) {
            return "";
        }
        return ((("" + displayCutout.getSafeInsetLeft() + ";") + displayCutout.getSafeInsetRight() + ";") + displayCutout.getSafeInsetTop() + ";") + displayCutout.getSafeInsetBottom();
    }

    public static Boolean CheckEmulatorBuild() {
        try {
            String str = Build.BOARD;
            String str2 = Build.BRAND;
            String str3 = Build.DEVICE;
            String str4 = Build.HARDWARE;
            String str5 = Build.MODEL;
            String str6 = Build.PRODUCT;
            String str7 = Build.SERIAL;
            if (str.equals("unknown") || str2.equals("generic") || str3.equals("generic") || str5.equals("sdk") || str6.equals("sdk") || str4.equals("goldfish") || str7 == null || str7.equals("unknown") || str7.isEmpty() || Build.FINGERPRINT.startsWith("generic") || Build.FINGERPRINT.toLowerCase().contains("vbox") || Build.FINGERPRINT.toLowerCase().contains("test-keys") || Build.MODEL.contains("google_sdk") || Build.MODEL.contains("Emulator") || Build.MODEL.contains("Android SDK built for x86") || Build.MANUFACTURER.contains("Genymotion") || ((Build.BRAND.startsWith("generic") && Build.DEVICE.startsWith("generic")) || "google_sdk".equals(Build.PRODUCT))) {
                Log.v("Result:", "Find Emulator by EmulatorBuild!");
                return true;
            }
            Log.v("Result:", "Not Find Emulator by EmulatorBuild!");
            return false;
        } catch (Exception unused) {
            return true;
        }
    }

    public static Boolean CheckEmulatorFiles() {
        int i = 0;
        while (true) {
            String[] strArr = known_files;
            if (i < strArr.length) {
                if (new File(strArr[i]).exists()) {
                    Log.v("Result:", "Find Emulator Files!");
                    return true;
                }
                i++;
            } else {
                Log.v("Result:", "Not Find Emulator Files!");
                return false;
            }
        }
    }

    public static String generateHighVersionUUID() {
        String strStringMD5 = "empty";
        try {
            DisplayMetrics displayMetrics = new DisplayMetrics();
            AppUtilManager.getInstance().getCurActivity().getWindowManager().getDefaultDisplay().getMetrics(displayMetrics);
            StringBuffer stringBuffer = new StringBuffer();
            stringBuffer.append(Build.BOARD);
            stringBuffer.append(Build.BRAND);
            stringBuffer.append(Build.CPU_ABI);
            stringBuffer.append(Build.CPU_ABI2);
            stringBuffer.append(Build.DEVICE);
            stringBuffer.append(Build.MANUFACTURER);
            stringBuffer.append(Build.SERIAL);
            stringBuffer.append(Build.PRODUCT);
            stringBuffer.append(displayMetrics.widthPixels);
            stringBuffer.append(displayMetrics.heightPixels);
            stringBuffer.append(displayMetrics.densityDpi);
            strStringMD5 = MD5.stringMD5(stringBuffer.toString());
            System.out.println("zym generateUUID deviceid: " + strStringMD5);
            return strStringMD5;
        } catch (Exception e) {
            System.out.println("zym generateUUID " + e.toString());
            return strStringMD5;
        }
    }

    public static String generateUUID(Context context) {
        boolean zBooleanValue;
        boolean zBooleanValue2 = false;
        SharedPreferences sharedPreferences = context.getSharedPreferences("xcuuid", 0);
        if (sharedPreferences != null && sharedPreferences.getString(KEY_UUID, "") != null && sharedPreferences.getString(KEY_UUID, "").trim().length() > 0) {
            return sharedPreferences.getString(KEY_UUID, "");
        }
        try {
            zBooleanValue = CheckEmulatorBuild().booleanValue();
            try {
                zBooleanValue2 = CheckEmulatorFiles().booleanValue();
            } catch (Exception e) {
                e = e;
                Log.e("error", e.getMessage());
            }
        } catch (Exception e2) {
            e = e2;
            zBooleanValue = false;
        }
        String strReplaceAll = UUID.randomUUID().toString().replaceAll("-", "");
        if (zBooleanValue) {
            strReplaceAll = "emula_" + strReplaceAll;
        }
        if (!zBooleanValue2) {
            return strReplaceAll;
        }
        return "filemula_" + strReplaceAll;
    }

    public static String getMacAddr(Context context) {
        return ((WifiManager) context.getSystemService("wifi")).getConnectionInfo().getMacAddress();
    }

    public static String getUidForCpb() {
        return KEY_UUID;
    }

    public static String SHA1(String str) {
        try {
            MessageDigest messageDigest = MessageDigest.getInstance("SHA-1");
            messageDigest.update(str.getBytes());
            return toHexString(messageDigest.digest());
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return "";
        }
    }

    public static String toHexString(byte[] bArr) {
        if (bArr == null) {
            return null;
        }
        StringBuilder sb = new StringBuilder(bArr.length * 2);
        for (byte b : bArr) {
            String string = Integer.toString(b & UnsignedBytes.MAX_VALUE, 16);
            if (string.length() == 1) {
                string = "0" + string;
            }
            sb.append(string);
        }
        return sb.toString();
    }

    public static class MD5 {
        public static String getMD5Str(String str) {
            try {
                MessageDigest messageDigest = MessageDigest.getInstance("MD5");
                messageDigest.reset();
                messageDigest.update(str.getBytes("UTF-8"));
                byte[] bArrDigest = messageDigest.digest();
                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < bArrDigest.length; i++) {
                    if (Integer.toHexString(bArrDigest[i] & UnsignedBytes.MAX_VALUE).length() == 1) {
                        sb.append("0");
                        sb.append(Integer.toHexString(bArrDigest[i] & UnsignedBytes.MAX_VALUE));
                    } else {
                        sb.append(Integer.toHexString(bArrDigest[i] & UnsignedBytes.MAX_VALUE));
                    }
                }
                return sb.toString();
            } catch (UnsupportedEncodingException e) {
                throw new RuntimeException(e);
            } catch (NoSuchAlgorithmException e2) {
                throw new RuntimeException(e2);
            }
        }

        public static String getMD5Str2(String str) {
            try {
                MessageDigest messageDigest = MessageDigest.getInstance("MD5");
                messageDigest.reset();
                messageDigest.update(str.getBytes());
                return new BigInteger(1, messageDigest.digest()).toString(16);
            } catch (NoSuchAlgorithmException e) {
                e.printStackTrace();
                return "";
            }
        }

        public static String stringMD5(String str) {
            try {
                MessageDigest messageDigest = MessageDigest.getInstance("MD5");
                messageDigest.update(str.getBytes());
                return byteArrayToHex(messageDigest.digest());
            } catch (NoSuchAlgorithmException unused) {
                return null;
            }
        }

        public static String byteArrayToHex(byte[] bArr) {
            char[] cArr = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};
            char[] cArr2 = new char[bArr.length * 2];
            int i = 0;
            for (byte b : bArr) {
                int i2 = i + 1;
                cArr2[i] = cArr[(b >>> 4) & 15];
                i += 2;
                cArr2[i2] = cArr[b & Ascii.f89SI];
            }
            return new String(cArr2).toLowerCase();
        }
    }
}
