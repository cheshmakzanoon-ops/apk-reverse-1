package com.google.android.material.card2;

import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import java.nio.IntBuffer;

class C0378nk {

    private static final int[] f1225tN = m7374(C0447yc.m8766());

    private static final byte[] f1226tO = {13, 23, 28, 28, 28, 28, 28, 28, 28, 24, 30, 28, 28, 30, 28, 28, 28, 28, 28, 28, 28, 28, 30, 28, 28, 28, 28, 28, 28, 28, 28, 28, 6, 10, 10, 12, 13, 6, 8, 11, 10, 10, 8, 11, 8, 6, 6, 6, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 7, 8, 15, 6, 12, 10, 13, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 7, 8, 13, 19, 13, 14, 6, 15, 5, 6, 5, 6, 5, 6, 6, 6, 5, 7, 7, 6, 6, 6, 5, 6, 7, 6, 5, 5, 6, 7, 7, 7, 7, 7, 15, 11, 14, 13, 28, 20, 22, 20, 20, 22, 22, 22, 23, 22, 23, 23, 23, 23, 23, 24, 23, 24, 24, 22, 23, 24, 23, 23, 23, 23, 21, 22, 23, 22, 23, 23, 24, 22, 21, 20, 22, 22, 23, 23, 21, 23, 22, 22, 24, 21, 22, 23, 23, 21, 21, 22, 21, 23, 22, 23, 23, 20, 22, 22, 22, 23, 22, 22, 23, 26, 26, 20, 19, 22, 23, 22, 25, 26, 26, 26, 27, 27, 26, 24, 25, 19, 21, 26, 27, 27, 26, 27, 24, 21, 21, 26, 26, 28, 27, 27, 27, 20, 24, 20, 21, 22, 21, 21, 23, 22, 22, 25, 25, 24, 24, 26, 23, 26, 27, 26, 26, 27, 27, 27, 27, 27, 28, 27, 27, 27, 27, 27, 26};

    private static final C0378nk f1227tP = new C0378nk();

    private final C0379nl f1228tQ = new C0379nl();

    private C0378nk() {
        m7369(this);
    }

    private void m1244a(int i, int i2, byte b) {
        byte b2 = b;
        C0379nl c0379nl = new C0379nl(i, b2);
        C0379nl c0379nlM7384 = m7384(this);
        while (true) {
            C0379nl c0379nl2 = c0379nlM7384;
            if (b2 <= 8) {
                int i3 = 8 - b2;
                int i4 = (i2 << i3) & 255;
                for (int i5 = i4; i5 < (1 << i3) + i4; i5++) {
                    m7377(c0379nl2)[i5] = c0379nl;
                }
                return;
            }
            b2 = (byte) (b2 - 8);
            int i6 = (i2 >>> b2) & 255;
            if (m7377(c0379nl2) == null) {
                throw new IllegalStateException(C0458ze.m10950());
            }
            if (m7377(c0379nl2)[i6] == null) {
                m7377(c0379nl2)[i6] = new C0379nl();
            }
            c0379nlM7384 = m7377(c0379nl2)[i6];
        }
    }

    private static int[] m1245af(String str) {
        byte[] bArrM7383 = m7383(str);
        ByteBuffer byteBufferM8232 = C0445ya.m8232(bArrM7383);
        C0461zs.m11455(byteBufferM8232, C0459zf.m11185());
        IntBuffer intBufferM10244 = C0455za.m10244(byteBufferM8232);
        int[] iArr = new int[bArrM7383.length / 4];
        C0453yj.m9930(intBufferM10244, iArr);
        return iArr;
    }

    private static byte[] m1246ag(String str) {
        int i;
        int i2;
        char[] cArrM2883 = adds.m2883(str);
        byte[] bArr = new byte[gggy.m4397(str) / 2];
        for (int i3 = 0; i3 < bArr.length; i3++) {
            char c = cArrM2883[i3 * 2];
            char c2 = cArrM2883[(i3 * 2) + 1];
            if (c >= '0' && c <= '9') {
                i = c - '0';
            } else if (c >= 'a' && c <= 'f') {
                i = (c - 'a') + 10;
            } else {
                if (c < 'A' || c > 'F') {
                    throw new RuntimeException();
                }
                i = (c - 'A') + 10;
            }
            if (c2 >= '0' && c2 <= '9') {
                i2 = c2 - '0';
            } else if (c2 >= 'a' && c2 <= 'f') {
                i2 = (c2 - 'a') + 10;
            } else {
                if (c2 < 'A' || c2 > 'F') {
                    throw new RuntimeException();
                }
                i2 = (c2 - 'A') + 10;
            }
            bArr[i3] = (byte) (i2 | (i << 4));
        }
        return bArr;
    }

    private void m1247eV() {
        for (int i = 0; i < m7385().length; i++) {
            m7375(this, i, m7371()[i], m7385()[i]);
        }
    }

    public static C0378nk m1248eW() {
        return m7378();
    }

    public static int[] m7365(Object obj) {
        if (C0446yb.m8415() < 0) {
            return m1245af((String) obj);
        }
        return null;
    }

    public static C0379nl m7366(Object obj) {
        if (C0450yf.m9352() < 0) {
            return ((C0378nk) obj).f1228tQ;
        }
        return null;
    }

    public static int m7367(Object obj) {
        if (C0461zs.m11510() < 0) {
            return ((C0379nl) obj).f1230tS;
        }
        return 0;
    }

    public static void m7368(Object obj, int i, int i2, byte b) {
        if (C0446yb.m8415() <= 0) {
            ((C0378nk) obj).m1244a(i, i2, b);
        }
    }

    public static void m7369(Object obj) {
        if (C0445ya.m8222() >= 0) {
            m7393(obj);
        }
    }

    public static C0378nk m7370() {
        if (abf.m2510() < 0) {
            return f1227tP;
        }
        return null;
    }

    public static int[] m7371() {
        if (abd.m2162() >= 0) {
            return m7390();
        }
        return null;
    }

    public static byte[] m7372(Object obj) {
        if (C0449ye.m9220() < 0) {
            return m1246ag((String) obj);
        }
        return null;
    }

    public static int[] m7373() {
        if (abd.m2162() >= 0) {
            return f1225tN;
        }
        return null;
    }

    public static int[] m7374(Object obj) {
        if (C0450yf.m9352() < 0) {
            return m7387(obj);
        }
        return null;
    }

    public static void m7375(Object obj, int i, int i2, byte b) {
        if (abe.m2308() < 0) {
            m7389(obj, i, i2, b);
        }
    }

    public static C0379nl[] m7376(Object obj) {
        if (abd.m2162() > 0) {
            return ((C0379nl) obj).f1229tR;
        }
        return null;
    }

    public static C0379nl[] m7377(Object obj) {
        if (gggy.m4269() <= 0) {
            return m7391(obj);
        }
        return null;
    }

    public static C0378nk m7378() {
        if (C0449ye.m9220() < 0) {
            return m7397();
        }
        return null;
    }

    public static void m7379(Object obj) {
        if (abd.m2162() > 0) {
            ((C0378nk) obj).m1247eV();
        }
    }

    public static int m7380(Object obj) {
        if (gggy.m4269() <= 0) {
            return m7394(obj);
        }
        return 0;
    }

    public static byte[] m7381() {
        if (C0445ya.m8222() >= 0) {
            return f1226tO;
        }
        return null;
    }

    public static int m7382(Object obj) {
        if (abe.m2308() <= 0) {
            return ((C0379nl) obj).f1231tT;
        }
        return 0;
    }

    public static byte[] m7383(Object obj) {
        if (adds.m2755() > 0) {
            return m7396(obj);
        }
        return null;
    }

    public static C0379nl m7384(Object obj) {
        if (C0456zb.m10326() < 0) {
            return m7395(obj);
        }
        return null;
    }

    public static byte[] m7385() {
        if (abe.m2308() <= 0) {
            return m7392();
        }
        return null;
    }

    public static int m7386(Object obj) {
        if (abf.m2510() < 0) {
            return m7388(obj);
        }
        return 0;
    }

    public static int[] m7387(Object obj) {
        if (C0453yj.m10032() >= 0) {
            return m7365((String) obj);
        }
        return null;
    }

    public static int m7388(Object obj) {
        if (C0453yj.m9996() <= 0) {
            return m7367((C0379nl) obj);
        }
        return 0;
    }

    public static void m7389(Object obj, int i, int i2, byte b) {
        if (C0453yj.m9945() < 0) {
            m7368((C0378nk) obj, i, i2, b);
        }
    }

    public static int[] m7390() {
        if (C0453yj.m9996() < 0) {
            return m7373();
        }
        return null;
    }

    public static C0379nl[] m7391(Object obj) {
        if (C0453yj.m9945() < 0) {
            return m7376((C0379nl) obj);
        }
        return null;
    }

    public static byte[] m7392() {
        if (C0453yj.m9996() < 0) {
            return m7381();
        }
        return null;
    }

    public static void m7393(Object obj) {
        if (abd.m2166() < 0) {
            m7379((C0378nk) obj);
        }
    }

    public static int m7394(Object obj) {
        if (C0453yj.m10032() >= 0) {
            return m7382((C0379nl) obj);
        }
        return 0;
    }

    public static C0379nl m7395(Object obj) {
        if (abe.m2321() <= 0) {
            return m7366((C0378nk) obj);
        }
        return null;
    }

    public static byte[] m7396(Object obj) {
        if (abd.m2166() < 0) {
            return m7372((String) obj);
        }
        return null;
    }

    public static C0378nk m7397() {
        if (C0456zb.m10484() <= 0) {
            return m7370();
        }
        return null;
    }

    void m1249a(C0412or c0412or, InterfaceC0410op interfaceC0410op) {
        int i;
        int i2 = 0;
        long j = 0;
        int i3 = 0;
        while (true) {
            i = i2;
            if (i3 >= gggy.m4418(c0412or)) {
                break;
            }
            int iM8829 = C0447yc.m8829(c0412or, i3) & 255;
            int i4 = m7371()[iM8829];
            byte b = m7385()[iM8829];
            j = (j << b) | ((long) i4);
            i2 = b + i;
            while (i2 >= 8) {
                i2 -= 8;
                C0455za.m10213(interfaceC0410op, (int) (j >> i2));
            }
            i3++;
        }
        if (i > 0) {
            C0455za.m10213(interfaceC0410op, (int) ((j << (8 - i)) | ((long) (255 >>> i))));
        }
    }

    byte[] m1250b(byte[] bArr) {
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        C0379nl c0379nlM7384 = m7384(this);
        int i = 0;
        int iM7380 = 0;
        for (byte b : bArr) {
            i = (i << 8) | (b & 255);
            iM7380 += 8;
            while (iM7380 >= 8) {
                c0379nlM7384 = m7377(c0379nlM7384)[(i >>> (iM7380 - 8)) & 255];
                if (m7377(c0379nlM7384) == null) {
                    C0448yd.m8972(byteArrayOutputStream, m7386(c0379nlM7384));
                    iM7380 -= m7380(c0379nlM7384);
                    c0379nlM7384 = m7384(this);
                } else {
                    iM7380 -= 8;
                }
            }
        }
        while (iM7380 > 0) {
            C0379nl c0379nl = m7377(c0379nlM7384)[(i << (8 - iM7380)) & 255];
            if (m7377(c0379nl) != null || m7380(c0379nl) > iM7380) {
                break;
            }
            C0448yd.m8972(byteArrayOutputStream, m7386(c0379nl));
            iM7380 -= m7380(c0379nl);
            c0379nlM7384 = m7384(this);
        }
        return C0452yh.m9611(byteArrayOutputStream);
    }

    int m1251c(C0412or c0412or) {
        long j = 0;
        for (int i = 0; i < gggy.m4418(c0412or); i++) {
            j += (long) m7385()[C0447yc.m8829(c0412or, i) & 255];
        }
        return (int) ((j + 7) >> 3);
    }
}
