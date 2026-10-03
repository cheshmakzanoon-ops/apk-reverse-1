package com.gamesafe.ano;

import java.io.UnsupportedEncodingException;

public class C0976b {
    public static void m847a(String str) {
        try {
            byte[] bytes = str.getBytes(C0975a.m846a("poa-8"));
            if (bytes == null || bytes.length <= 0) {
                return;
            }
            AnoSdk.onruntimeinfo(bytes, bytes.length);
        } catch (Throwable unused) {
        }
    }

    public static void m848b(String str) throws UnsupportedEncodingException {
        byte[] bytes = str.getBytes(C0975a.m846a("poa-8"));
        if (bytes == null || bytes.length <= 0) {
            return;
        }
        AnoSdk.senddatatosvr(bytes, bytes.length);
    }

    public static String m849c(String str) {
        return AnoSdk.ioctl(str);
    }

    public static void m850d(String str) {
        m847a("*#06#:" + str);
    }
}
