package cn.thinkingdata.android.utils;

import android.app.ActivityManager;
import android.app.Application;
import android.content.Context;
import android.os.Build;
import android.os.Process;
import android.text.TextUtils;
import java.lang.reflect.Method;
import java.util.List;

public class C0755f {

    private static String f244a = "";

    public static List<ActivityManager.RunningAppProcessInfo> f245b;

    private static String m700a() {
        try {
            Method declaredMethod = Class.forName("android.app.ActivityThread", false, Application.class.getClassLoader()).getDeclaredMethod("currentProcessName", null);
            declaredMethod.setAccessible(true);
            Object objInvoke = declaredMethod.invoke(null, null);
            if (objInvoke instanceof String) {
                return (String) objInvoke;
            }
        } catch (Throwable th) {
            th.printStackTrace();
        }
        return "";
    }

    public static String m701a(Context context) {
        if (!TextUtils.isEmpty(f244a)) {
            return f244a;
        }
        String strM702b = m702b();
        f244a = strM702b;
        if (!TextUtils.isEmpty(strM702b)) {
            return f244a;
        }
        String strM700a = m700a();
        f244a = strM700a;
        if (!TextUtils.isEmpty(strM700a)) {
            return f244a;
        }
        String strM703b = m703b(context);
        f244a = strM703b;
        return strM703b;
    }

    private static String m702b() {
        return Build.VERSION.SDK_INT >= 28 ? Application.getProcessName() : "";
    }

    private static String m703b(Context context) {
        int iMyPid = Process.myPid();
        ActivityManager activityManager = (ActivityManager) context.getSystemService("activity");
        if (activityManager == null) {
            return "";
        }
        if (f245b == null) {
            f245b = activityManager.getRunningAppProcesses();
        }
        List<ActivityManager.RunningAppProcessInfo> list = f245b;
        if (list == null) {
            return "";
        }
        for (ActivityManager.RunningAppProcessInfo runningAppProcessInfo : list) {
            if (runningAppProcessInfo.pid == iMyPid) {
                return runningAppProcessInfo.processName;
            }
        }
        return "";
    }
}
