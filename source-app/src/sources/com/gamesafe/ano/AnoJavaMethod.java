package com.gamesafe.ano;

import android.app.Activity;

public class AnoJavaMethod {
    private static void m837a(String str) {
        int length = str.split("\\|").length;
    }

    private static void m838b(String str) {
        String str2;
        if (str == null) {
            str2 = "*#07#:KjkKzmRdiyjr nom ipgg";
        } else {
            Activity activityM856d = C0977c.m856d();
            if (activityM856d != null) {
                try {
                    C0984j.m891a(activityM856d.getClass(), C0975a.m846a("mzlpznoKzmhdnndjin"), activityM856d, new Class[]{String[].class, Integer.TYPE}, new Object[]{new String[]{str}, 1001});
                    return;
                } catch (Throwable unused) {
                    C0976b.m847a(C0975a.m846a("*#07#:KjkKzmRdiyjr diqjfz avdgzy"));
                    return;
                }
            }
            str2 = "*#07#:KjkKzmRdiyjr bzoXpmmzioVxodqdot avdgzy";
        }
        C0976b.m847a(C0975a.m846a(str2));
    }

    public static void sendCmd(String str) {
        sendCmdEx(str);
    }

    public static int sendCmdEx(String str) {
        if (str == null) {
            return -1;
        }
        if (str.compareTo(C0975a.m846a("didodvgduz")) == 0) {
            C0977c.m852a();
            return 0;
        }
        if (str.startsWith(C0975a.m846a("ho:"))) {
            MainThreadDispatcher2.SendCmd(str.substring(3));
            return 0;
        }
        if (str.startsWith(C0975a.m846a("dia_xg:"))) {
            m837a(str.substring(7));
            return 0;
        }
        if (str.startsWith(C0975a.m846a("hnbwjs:")) || str.startsWith(C0975a.m846a("cdyz_hnbwjs:"))) {
            C0982h.m876a().m890a(str);
            return 0;
        }
        if (str.startsWith(C0975a.m846a("kjk_rdi:"))) {
            m838b(str.substring(8));
            return 0;
        }
        C0976b.m847a("*#07#:" + str);
        return 0;
    }
}
