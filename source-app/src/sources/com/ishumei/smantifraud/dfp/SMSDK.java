package com.ishumei.smantifraud.dfp;

import android.content.Context;
import android.text.TextUtils;
import android.util.Log;
import com.ishumei.smantifraud.SmAntiFraud;
import com.ishumei.smantifraud.l1l11l1I1Il;
import java.io.IOException;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

public class SMSDK {
    private static final String TAG = "Smlog";

    static {
        try {
            System.loadLibrary("smsdk");
        } catch (Throwable th) {
            synchronized (SmAntiFraud.class) {
                l1l11l1I1Il.l111l11111I1l = "libsmsdk.so load failed.;" + th;
                Log.e("Smlog", "libsmsdk.so load failed.", th);
            }
        }
    }

    public static native synchronized void m370d();

    public static native synchronized boolean m371ma();

    public static native synchronized int ma2();

    private static native synchronized long native_u2(String str);

    public static long m372u2(String str) {
        try {
            return native_u2(str);
        } catch (Throwable unused) {
            return 0L;
        }
    }

    private static native synchronized void m373u3(String str);

    public static String m374v1(Context context, String str, String str2, String str3, String str4, String str5, String str6, String str7, long j, Set<String> set, List<byte[]> list) {
        try {
            StringBuilder sb = new StringBuilder();
            if (set != null && !set.isEmpty()) {
                Iterator<String> it = set.iterator();
                while (it.hasNext()) {
                    sb.append(it.next());
                    sb.append(",");
                }
            }
            String str8 = context.getApplicationInfo().sourceDir;
            if (!TextUtils.isEmpty(str8)) {
                m373u3(str8.replace("/base.apk", ""));
            }
            return m376w1(context, str, str2, str3, str4, str5, str6, str7, j, sb.toString(), list);
        } catch (Throwable th) {
            return String.valueOf(th);
        }
    }

    public static String m375v3(Context context, String str, String str2, String str3, String str4) throws Exception {
        try {
            return m377w3(context, str, str2, str3, str4);
        } catch (Throwable unused) {
            return "";
        }
    }

    public static native synchronized String m376w1(Context context, String str, String str2, String str3, String str4, String str5, String str6, String str7, long j, String str8, List<byte[]> list);

    private static native synchronized String m377w3(Context context, String str, String str2, String str3, String str4);

    public static String m378x3(String str, String str2) throws IOException {
        try {
            return m379x4(str2, str);
        } catch (Throwable th) {
            throw new IOException(th);
        }
    }

    private static native synchronized String m379x4(String str, String str2);

    public static String m380x5(String str, String str2) throws IOException {
        try {
            return m381x6(str2, str);
        } catch (Throwable th) {
            throw new IOException(th);
        }
    }

    private static native synchronized String m381x6(String str, String str2);
}
