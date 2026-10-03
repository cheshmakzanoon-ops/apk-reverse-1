package cn.thinkingdata.android.utils;

import android.text.TextUtils;

public class C0751b {
    private static String m691a(String str) {
        try {
            Class<?> cls = Class.forName("android.os.SystemProperties");
            return (String) cls.getMethod("get", String.class).invoke(cls, str);
        } catch (Exception unused) {
            return null;
        }
    }

    public static boolean m692a() {
        return m694c() || m693b();
    }

    private static boolean m693b() {
        String strM691a = m691a("ro.product.cpu.abi");
        return (strM691a == null || TextUtils.isEmpty(strM691a) || !strM691a.contains("x86")) ? false : true;
    }

    private static boolean m694c() {
        return "1".equals(m691a("ro.kernel.qemu"));
    }
}
