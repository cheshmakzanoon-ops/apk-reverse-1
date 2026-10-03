package com.ishumei.smantifraud;

import android.app.UiModeManager;
import android.content.Context;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;

public class l11l11Il11ll {
    public static int l1111l111111Il(Context context) {
        try {
            return ((UiModeManager) context.getSystemService("uimode")).getCurrentModeType();
        } catch (Throwable unused) {
            return -1;
        }
    }

    public static HashMap<String, String> l1111l111111Il(boolean z) {
        HashMap<String, String> map = new HashMap<>();
        try {
            Class<?> clsLoadClass = Context.class.getClassLoader().loadClass("android.os.SystemProperties");
            Method method = clsLoadClass.getMethod("get", String.class);
            method.setAccessible(true);
            ArrayList<String> arrayList = new ArrayList();
            arrayList.add("ro.debuggable");
            arrayList.add("ro.boot.hardware");
            arrayList.add("gsm.sim.state");
            arrayList.add("gsm.operator.alpha");
            arrayList.add("sys.usb.state");
            for (String str : arrayList) {
                String str2 = (String) method.invoke(clsLoadClass, str);
                if (str2 != null && !str2.isEmpty()) {
                    map.put(str, str2);
                }
            }
        } catch (Exception unused) {
        }
        return map;
    }
}
