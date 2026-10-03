package com.google.android.material.card2;

import java.nio.charset.Charset;

final class C0432pk {

    public static final Charset f1347vT = C0457zc.m10654(C0461zs.m11549());

    public static int m1460O(int i) {
        return (((-16777216) & i) >>> 24) | ((16711680 & i) >>> 8) | ((65280 & i) << 8) | ((i & 255) << 24);
    }

    public static short m1461a(short s) {
        int i = 65535 & s;
        return (short) (((i & 255) << 8) | ((65280 & i) >>> 8));
    }

    public static void m1462a(long j, long j2, long j3) {
        if ((j2 | j3) < 0 || j2 > j || j - j2 < j3) {
            throw new ArrayIndexOutOfBoundsException(m8179(C0456zb.m10514(), new Object[]{C0456zb.m10500(j), C0456zb.m10500(j2), C0456zb.m10500(j3)}));
        }
    }

    public static void m1463a(Throwable th) throws Throwable {
        m8178(th);
    }

    public static boolean m1464a(byte[] bArr, int i, byte[] bArr2, int i2, int i3) {
        for (int i4 = 0; i4 < i3; i4++) {
            if (bArr[i4 + i] != bArr2[i4 + i2]) {
                return false;
            }
        }
        return true;
    }

    private static <T extends Throwable> void m1465b(Throwable th) throws Throwable {
        throw th;
    }

    public static void m8178(Object obj) throws Throwable {
        if (abf.m2510() <= 0) {
            m8181(obj);
        }
    }

    public static String m8179(Object obj, Object obj2) {
        if (C0453yj.m10013() > 0) {
            return C0598.m11903(obj, obj2);
        }
        return null;
    }

    public static void m8180(Object obj) throws Throwable {
        if (C0450yf.m9352() <= 0) {
            m1465b((Throwable) obj);
        }
    }

    public static void m8181(Object obj) throws Throwable {
        if (C0448yd.m9015() <= 0) {
            m8180((Throwable) obj);
        }
    }
}
