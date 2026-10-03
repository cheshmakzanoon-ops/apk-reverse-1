package com.ishumei.smantifraud;

import android.content.Context;
import android.hardware.input.InputManager;
import android.os.Environment;
import android.os.PowerManager;
import android.os.StatFs;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.view.InputDevice;
import android.view.WindowManager;
import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public class l11l111lIll {
    public static List<String> l1111l111111Il() {
        return new ArrayList();
    }

    public static Map<String, String> l1111l111111Il(Context context) {
        HashMap map = new HashMap();
        try {
            InputManager inputManager = (InputManager) context.getSystemService(l111l1111llIl.l111l111llIl);
            int[] inputDeviceIds = inputManager.getInputDeviceIds();
            StringBuilder sb = new StringBuilder();
            StringBuilder sb2 = new StringBuilder();
            for (int i : inputDeviceIds) {
                InputDevice inputDevice = inputManager.getInputDevice(i);
                if (inputDevice != null && inputDevice.toString().contains("Location: external")) {
                    sb.append(inputDevice.getName());
                    sb.append(";");
                    sb2.append(inputDevice.getSources());
                    sb2.append(";");
                }
            }
            if (!TextUtils.isEmpty(sb) || !TextUtils.isEmpty(sb2)) {
                map.put("n", sb.toString());
                map.put(l111l111lIlll.l11l111l1Il, sb2.toString());
            }
        } catch (Throwable unused) {
        }
        return map;
    }

    public static int l111l11111I1l() {
        try {
            File[] fileArrListFiles = new File("/proc").listFiles();
            if (fileArrListFiles == null) {
                return 0;
            }
            return fileArrListFiles.length;
        } catch (Exception unused) {
            return -1;
        }
    }

    public static int l111l11111Il() {
        try {
            return ((PowerManager) l11l11l111Il.l1111l111111Il.getSystemService("power")).isScreenOn() ? 1 : 0;
        } catch (Exception unused) {
            return -1;
        }
    }

    public static String l111l11111lIl() {
        int i;
        int i2;
        Context context = l11l11l111Il.l1111l111111Il;
        if (context == null) {
            return "";
        }
        try {
            DisplayMetrics displayMetrics = new DisplayMetrics();
            ((WindowManager) context.getSystemService("window")).getDefaultDisplay().getMetrics(displayMetrics);
            i = displayMetrics.widthPixels;
            try {
                i2 = displayMetrics.heightPixels;
            } catch (Exception unused) {
                i2 = 0;
            }
        } catch (Exception unused2) {
            i = 0;
        }
        return String.format(Locale.US, "%d,%d", Integer.valueOf(i), Integer.valueOf(i2));
    }

    public static String l111l1111l1Il() {
        int i;
        int i2;
        int i3;
        Context context = l11l11l111Il.l1111l111111Il;
        if (context == null) {
            return "";
        }
        try {
            DisplayMetrics displayMetrics = context.getResources().getDisplayMetrics();
            i = displayMetrics.widthPixels;
            try {
                i2 = displayMetrics.heightPixels;
                try {
                    i3 = displayMetrics.densityDpi;
                } catch (Exception unused) {
                    i3 = 0;
                }
            } catch (Exception unused2) {
                i2 = 0;
            }
        } catch (Exception unused3) {
            i = 0;
            i2 = 0;
        }
        return String.format(Locale.US, "%d,%d,%d", Integer.valueOf(i), Integer.valueOf(i2), Integer.valueOf(i3));
    }

    public static StatFs l111l1111llIl() {
        try {
            return new StatFs(Environment.getExternalStorageDirectory().getPath());
        } catch (Exception unused) {
            return null;
        }
    }
}
