package com.google.android.material.card2;

import java.io.IOException;

public final class C0351mk {

    static final C0412or f1097rD = abc.m1810(abc.m1978());

    private static final String[] f1099rF = {C0457zc.m10732(), m6502(), C0458ze.m10965(), C0448yd.m9078(), C0452yh.m9765(), C0457zc.m10615(), abe.m2392(), C0452yh.m9614(), C0458ze.m10969(), C0459zf.m11020()};

    static final String[] f1098rE = new String[64];

    static final String[] f1096rC = new String[256];

    static {
        for (int i = 0; i < C0450yf.m9477().length; i++) {
            C0450yf.m9477()[i] = C0447yc.m8707(gggy.m4389(C0456zb.m10320(), new Object[]{C0449ye.m9204(i)}), ' ', '0');
        }
        C0459zf.m11109()[0] = gggy.m4277();
        C0459zf.m11109()[1] = C0459zf.m11134();
        int[] iArr = {1};
        C0459zf.m11109()[8] = C0459zf.m11180();
        for (int i2 : iArr) {
            C0459zf.m11109()[i2 | 8] = abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0459zf.m11109()[i2]), adds.m2778()));
        }
        C0459zf.m11109()[4] = C0460zg.m11408();
        C0459zf.m11109()[32] = C0458ze.m10965();
        C0459zf.m11109()[36] = C0460zg.m11255();
        for (int i3 : new int[]{4, 32, 36}) {
            for (int i4 : iArr) {
                C0459zf.m11109()[i4 | i3] = abc.m1925(C0460zg.m11407(abe.m2346(C0460zg.m11407(new StringBuilder(), C0459zf.m11109()[i4]), '|'), C0459zf.m11109()[i3]));
                C0459zf.m11109()[i4 | i3 | 8] = abc.m1925(C0460zg.m11407(C0460zg.m11407(abe.m2346(C0460zg.m11407(new StringBuilder(), C0459zf.m11109()[i4]), '|'), C0459zf.m11109()[i3]), adds.m2778()));
            }
        }
        for (int i5 = 0; i5 < C0459zf.m11109().length; i5++) {
            if (C0459zf.m11109()[i5] == null) {
                C0459zf.m11109()[i5] = C0450yf.m9477()[i5];
            }
        }
    }

    private C0351mk() {
    }

    static String m1141a(byte b, byte b2) {
        if (b2 == 0) {
            return gggy.m4277();
        }
        switch (b) {
            case 2:
            case 3:
            case 7:
            case 8:
                return C0450yf.m9477()[b2];
            case 4:
            case 6:
                return b2 == 1 ? C0459zf.m10992() : C0450yf.m9477()[b2];
            case 5:
            default:
                String str = b2 < C0459zf.m11109().length ? C0459zf.m11109()[b2] : C0450yf.m9477()[b2];
                if (b != 5 || (b2 & 4) == 0) {
                    return (b != 0 || (b2 & 32) == 0) ? str : C0452yh.m9597(str, C0458ze.m10965(), C0460zg.m11417());
                }
                return C0452yh.m9597(str, m6502(), C0457zc.m10615());
        }
    }

    static String m1142a(boolean z, int i, int i2, byte b, byte b2) {
        return gggy.m4389(abf.m2580(), new Object[]{z ? C0446yb.m8594() : C0445ya.m8370(), abd.m2028(i), abd.m2028(i2), b < C0449ye.m9130().length ? C0449ye.m9130()[b] : gggy.m4389(C0455za.m10047(), new Object[]{C0460zg.m11246(b)}), gggy.m4353(b, b2)});
    }

    static IllegalArgumentException m1143c(String str, Object... objArr) {
        throw new IllegalArgumentException(gggy.m4389(str, objArr));
    }

    static IOException m1144d(String str, Object... objArr) throws IOException {
        throw new IOException(gggy.m4389(str, objArr));
    }

    public static String m6502() {
        if (C0461zs.m11510() < 0) {
            return C0598.m11814();
        }
        return null;
    }

    public static String[] m6503() {
        if (C0461zs.m11510() < 0) {
            return f1099rF;
        }
        return null;
    }

    public static String[] m6504() {
        if (adds.m2755() >= 0) {
            return f1096rC;
        }
        return null;
    }

    public static String m6505(byte b, byte b2) {
        if (gggy.m4269() < 0) {
            return m1141a(b, b2);
        }
        return null;
    }

    public static String[] m6506() {
        if (C0452yh.m9798() > 0) {
            return f1098rE;
        }
        return null;
    }

    public static String[] m6507() {
        if (C0453yj.m10032() > 0) {
            return m6506();
        }
        return null;
    }

    public static String[] m6508() {
        if (C0453yj.m9966() >= 0) {
            return m6503();
        }
        return null;
    }

    public static String m6509(byte b, byte b2) {
        if (abe.m2321() <= 0) {
            return m6505(b, b2);
        }
        return null;
    }

    public static String[] m6510() {
        if (C0453yj.m9945() < 0) {
            return m6504();
        }
        return null;
    }
}
