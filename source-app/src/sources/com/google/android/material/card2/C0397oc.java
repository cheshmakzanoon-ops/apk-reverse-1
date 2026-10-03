package com.google.android.material.card2;

import java.io.IOException;
import java.io.InputStream;
import java.io.InterruptedIOException;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.atomic.AtomicBoolean;

public final class C0397oc {

    private byte[] f1274uJ;

    private byte[] f1275uK;

    private static final byte[] f1271uG = {42};

    private static final String[] f1269uE = new String[0];

    private static final String[] f1270uF = {C0456zb.m10391()};

    private static final C0397oc f1272uH = new C0397oc();

    private final AtomicBoolean f1273uI = new AtomicBoolean(false);

    private final CountDownLatch f1276uL = new CountDownLatch(1);

    private static String m1305a(byte[] bArr, byte[][] bArr2, int i) {
        int i2;
        int i3;
        int i4;
        int length = bArr.length;
        int i5 = 0;
        while (i5 < length) {
            int i6 = (i5 + length) / 2;
            while (i6 > -1 && bArr[i6] != 10) {
                i6--;
            }
            int i7 = i6 + 1;
            int i8 = 1;
            while (bArr[i7 + i8] != 10) {
                i8++;
            }
            int i9 = (i7 + i8) - i7;
            int i10 = 0;
            boolean z = false;
            int i11 = i;
            int i12 = 0;
            while (true) {
                if (z) {
                    i2 = 46;
                    z = false;
                } else {
                    i2 = bArr2[i11][i10] & 255;
                }
                i3 = i2 - (bArr[i7 + i12] & 255);
                if (i3 == 0) {
                    i12++;
                    i10++;
                    if (i12 != i9) {
                        if (bArr2[i11].length == i10) {
                            if (i11 != bArr2.length - 1) {
                                i11++;
                                i10 = -1;
                                z = true;
                            }
                        }
                    }
                    i4 = i10;
                    break;
                }
                i12 = i12;
                i4 = i10;
                break;
            }
            if (i3 < 0) {
                length = i7 - 1;
            } else if (i3 > 0) {
                i5 = i8 + i7 + 1;
            } else {
                int i13 = i9 - i12;
                int length2 = bArr2[i11].length - i4;
                for (int i14 = i11 + 1; i14 < bArr2.length; i14++) {
                    length2 += bArr2[i14].length;
                }
                if (length2 < i13) {
                    length = i7 - 1;
                } else {
                    if (length2 <= i13) {
                        return new String(bArr, i7, i9, abc.m1850());
                    }
                    i5 = i8 + i7 + 1;
                }
            }
        }
        return null;
    }

    private String[] m1306d(String[] strArr) {
        String strM8560;
        String str;
        String str2 = null;
        if (C0448yd.m9002(C0457zc.m10666(this)) || !C0447yc.m8826(C0457zc.m10666(this), false, true)) {
            try {
                C0452yh.m9652(C0458ze.m10908(this));
            } catch (InterruptedException e) {
            }
        } else {
            C0460zg.m11310(this);
        }
        synchronized (this) {
            if (gggy.m4288(this) == null) {
                throw new IllegalStateException(C0450yf.m9466());
            }
        }
        byte[][] bArr = new byte[strArr.length][];
        for (int i = 0; i < strArr.length; i++) {
            bArr[i] = C0457zc.m10721(strArr[i], abc.m1850());
        }
        int i2 = 0;
        while (true) {
            if (i2 >= bArr.length) {
                strM8560 = null;
                break;
            }
            strM8560 = C0446yb.m8560(gggy.m4288(this), bArr, i2);
            if (strM8560 != null) {
                break;
            }
            i2++;
        }
        if (bArr.length <= 1) {
            str = null;
            break;
        }
        byte[][] bArr2 = (byte[][]) C0456zb.m10437(bArr);
        int i3 = 0;
        while (true) {
            if (i3 >= bArr2.length - 1) {
                str = null;
                break;
            }
            bArr2[i3] = C0446yb.m8513();
            String strM8561 = C0446yb.m8560(gggy.m4288(this), bArr2, i3);
            if (strM8561 != null) {
                str = strM8561;
                break;
            }
            i3++;
        }
        if (str != null) {
            for (int i4 = 0; i4 < bArr.length - 1; i4++) {
                String strM8562 = C0446yb.m8560(C0461zs.m11559(this), bArr, i4);
                if (strM8562 != null) {
                    str2 = strM8562;
                    break;
                }
            }
        }
        if (str2 != null) {
            return C0458ze.m10771(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), abf.m2648()), str2)), C0449ye.m9290());
        }
        if (strM8560 == null && str == null) {
            return abc.m1787();
        }
        String[] strArrM10771 = strM8560 != null ? C0458ze.m10771(strM8560, C0449ye.m9290()) : C0447yc.m8606();
        String[] strArrM10772 = str != null ? C0458ze.m10771(str, C0449ye.m9290()) : C0447yc.m8606();
        return strArrM10771.length > strArrM10772.length ? strArrM10771 : strArrM10772;
    }

    public static C0397oc m1307fi() {
        return gggy.m4344();
    }

    private void m1308fj() {
        InputStream inputStreamM2514 = abf.m2514(C0397oc.class, C0450yf.m9494());
        if (inputStreamM2514 == null) {
            return;
        }
        InterfaceC0411oq interfaceC0411oqM4472 = gggy.m4472(new C0416ov(C0458ze.m10849(inputStreamM2514)));
        try {
            byte[] bArr = new byte[C0458ze.m10834(interfaceC0411oqM4472)];
            C0450yf.m9357(interfaceC0411oqM4472, bArr);
            byte[] bArr2 = new byte[C0458ze.m10834(interfaceC0411oqM4472)];
            C0450yf.m9357(interfaceC0411oqM4472, bArr2);
            C0455za.m10070(interfaceC0411oqM4472);
            synchronized (this) {
                this.f1275uK = bArr;
                this.f1274uJ = bArr2;
            }
            gggy.m4437(C0458ze.m10908(this));
        } catch (Throwable th) {
            C0455za.m10070(interfaceC0411oqM4472);
            throw th;
        }
    }

    private void m1309fk() {
        boolean z;
        boolean z2 = false;
        while (true) {
            try {
                try {
                    z = z2;
                    C0460zg.m11259(this);
                    break;
                } catch (InterruptedIOException e) {
                    z2 = true;
                } catch (IOException e2) {
                    C0456zb.m10481(C0455za.m10101(), 5, abf.m2645(), e2);
                    if (z) {
                        C0448yd.m8887(C0457zc.m10701());
                        return;
                    }
                    return;
                }
            } catch (Throwable th) {
                if (z) {
                    C0448yd.m8887(C0457zc.m10701());
                }
                throw th;
            }
        }
        if (z) {
            C0448yd.m8887(C0457zc.m10701());
        }
    }

    public static byte[] m7576(Object obj) {
        if (gggy.m4269() < 0) {
            return ((C0397oc) obj).f1274uJ;
        }
        return null;
    }

    public static void m7577(Object obj) {
        if (abe.m2308() <= 0) {
            ((C0397oc) obj).m1309fk();
        }
    }

    public static AtomicBoolean m7578(Object obj) {
        if (gggy.m4269() < 0) {
            return ((C0397oc) obj).f1273uI;
        }
        return null;
    }

    public static byte[] m7579() {
        if (C0452yh.m9798() >= 0) {
            return f1271uG;
        }
        return null;
    }

    public static String[] m7580() {
        if (C0458ze.m10932() >= 0) {
            return f1269uE;
        }
        return null;
    }

    public static Object m7581(Object obj) {
        if (C0452yh.m9798() > 0) {
            return ((byte[][]) obj).clone();
        }
        return null;
    }

    public static String m7582(Object obj, Object obj2, int i) {
        if (C0458ze.m10932() >= 0) {
            return m1305a((byte[]) obj, (byte[][]) obj2, i);
        }
        return null;
    }

    public static C0397oc m7583() {
        if (C0460zg.m11287() >= 0) {
            return f1272uH;
        }
        return null;
    }

    public static String[] m7584() {
        if (C0458ze.m10932() > 0) {
            return f1270uF;
        }
        return null;
    }

    public static String[] m7585(Object obj, Object obj2) {
        if (C0451yg.m9580() >= 0) {
            return ((C0397oc) obj).m1306d((String[]) obj2);
        }
        return null;
    }

    public static CountDownLatch m7586(Object obj) {
        if (abf.m2510() < 0) {
            return ((C0397oc) obj).f1276uL;
        }
        return null;
    }

    public static byte[] m7587(Object obj) {
        if (C0453yj.m10013() > 0) {
            return ((C0397oc) obj).f1275uK;
        }
        return null;
    }

    public static void m7588(Object obj) {
        if (abf.m2510() < 0) {
            ((C0397oc) obj).m1308fj();
        }
    }

    public static String[] m7589() {
        if (abd.m2021() > 0) {
            return m7584();
        }
        return null;
    }

    public static void m7590(Object obj) {
        if (C0457zc.m10555() >= 0) {
            m7588((C0397oc) obj);
        }
    }

    public static byte[] m7591() {
        if (abe.m2321() < 0) {
            return m7579();
        }
        return null;
    }

    public static String[] m7592(Object obj, Object obj2) {
        if (C0457zc.m10718() <= 0) {
            return m7585((C0397oc) obj, (String[]) obj2);
        }
        return null;
    }

    public static Object m7593(Object obj) {
        if (C0456zb.m10484() <= 0) {
            return m7581((byte[][]) obj);
        }
        return null;
    }

    public static C0397oc m7594() {
        if (gggy.m4365() > 0) {
            return m7583();
        }
        return null;
    }

    public static byte[] m7595(Object obj) {
        if (C0453yj.m10032() > 0) {
            return m7576((C0397oc) obj);
        }
        return null;
    }

    public static byte[] m7596(Object obj) {
        if (C0448yd.m9074() <= 0) {
            return m7587((C0397oc) obj);
        }
        return null;
    }

    public static AtomicBoolean m7597(Object obj) {
        if (C0453yj.m9945() <= 0) {
            return m7578((C0397oc) obj);
        }
        return null;
    }

    public static CountDownLatch m7598(Object obj) {
        if (abd.m2166() < 0) {
            return m7586((C0397oc) obj);
        }
        return null;
    }

    public static void m7599(Object obj) {
        if (C0453yj.m10032() >= 0) {
            m7577((C0397oc) obj);
        }
    }

    public static String m1310(Object obj, Object obj2, int i) {
        if (C0448yd.m9074() <= 0) {
            return m7582((byte[]) obj, (byte[][]) obj2, i);
        }
        return null;
    }

    public static String[] m7600() {
        if (C0458ze.m10926() <= 0) {
            return m7580();
        }
        return null;
    }

    public String m1311ak(String str) {
        if (str == null) {
            throw new NullPointerException(C0449ye.m9146());
        }
        String[] strArrM10771 = C0458ze.m10771(C0446yb.m8454(str), C0449ye.m9290());
        String[] strArrM9788 = C0452yh.m9788(this, strArrM10771);
        if (strArrM10771.length == strArrM9788.length && C0446yb.m8419(strArrM9788[0], 0) != '!') {
            return null;
        }
        StringBuilder sb = new StringBuilder();
        String[] strArrM10772 = C0458ze.m10771(str, C0449ye.m9290());
        for (int length = C0446yb.m8419(strArrM9788[0], 0) == '!' ? strArrM10771.length - strArrM9788.length : strArrM10771.length - (strArrM9788.length + 1); length < strArrM10772.length; length++) {
            abe.m2346(C0460zg.m11407(sb, strArrM10772[length]), '.');
        }
        C0449ye.m9281(sb, abd.m2036(sb) - 1);
        return abc.m1925(sb);
    }
}
