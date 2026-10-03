package com.google.android.material.card2;

import java.io.EOFException;
import java.io.IOException;
import java.util.zip.CRC32;
import java.util.zip.Inflater;

public final class C0416ov implements InterfaceC0429ph {

    private final Inflater f1311vq;

    private final C0417ow f1312vr;

    private final InterfaceC0411oq f1314vt;

    private int f1313vs = 0;

    private final CRC32 f1310vp = new CRC32();

    public C0416ov(InterfaceC0429ph interfaceC0429ph) {
        if (interfaceC0429ph == null) {
            throw new IllegalArgumentException(gggy.m4409());
        }
        this.f1311vq = new Inflater(true);
        this.f1314vt = gggy.m4472(interfaceC0429ph);
        this.f1312vr = new C0417ow(adds.m2848(this), C0449ye.m9159(this));
    }

    private void m1431b(C0409oo c0409oo, long j, long j2) {
        long j3 = j2;
        long jM9834 = j;
        C0425pd c0425pdM7852 = m7852(c0409oo);
        while (jM9834 >= C0453yj.m9834(c0425pdM7852) - C0461zs.m11650(c0425pdM7852)) {
            jM9834 -= (long) (C0453yj.m9834(c0425pdM7852) - C0461zs.m11650(c0425pdM7852));
            c0425pdM7852 = m7859(c0425pdM7852);
        }
        while (j3 > 0) {
            int iM11650 = (int) (((long) C0461zs.m11650(c0425pdM7852)) + jM9834);
            int iM9495 = (int) C0450yf.m9495(C0453yj.m9834(c0425pdM7852) - iM11650, j3);
            m7872(adds.m2767(this), gggy.m4428(c0425pdM7852), iM11650, iM9495);
            j3 -= (long) iM9495;
            c0425pdM7852 = m7859(c0425pdM7852);
            jM9834 = 0;
        }
    }

    private void m1432gb() throws EOFException {
        m7854(adds.m2848(this), 10L);
        byte bM11475 = C0461zs.m11475(C0459zf.m11165(adds.m2848(this)), 3L);
        boolean z = ((bM11475 >> 1) & 1) == 1;
        if (z) {
            abf.m2524(this, C0459zf.m11165(adds.m2848(this)), 0L, 10L);
        }
        C0450yf.m9556(this, abf.m2607(), 8075, abc.m1754(adds.m2848(this)));
        C0461zs.m11605(adds.m2848(this), 8L);
        if (((bM11475 >> 2) & 1) == 1) {
            m7854(adds.m2848(this), 2L);
            if (z) {
                abf.m2524(this, C0459zf.m11165(adds.m2848(this)), 0L, 2L);
            }
            short sM10973 = C0458ze.m10973(C0459zf.m11165(adds.m2848(this)));
            m7854(adds.m2848(this), sM10973);
            if (z) {
                abf.m2524(this, C0459zf.m11165(adds.m2848(this)), 0L, sM10973);
            }
            C0461zs.m11605(adds.m2848(this), sM10973);
        }
        if (((bM11475 >> 3) & 1) == 1) {
            long jM11241 = C0460zg.m11241(adds.m2848(this), (byte) 0);
            if (jM11241 == -1) {
                throw new EOFException();
            }
            if (z) {
                abf.m2524(this, C0459zf.m11165(adds.m2848(this)), 0L, 1 + jM11241);
            }
            C0461zs.m11605(adds.m2848(this), 1 + jM11241);
        }
        if (((bM11475 >> 4) & 1) == 1) {
            long jM11242 = C0460zg.m11241(adds.m2848(this), (byte) 0);
            if (jM11242 == -1) {
                throw new EOFException();
            }
            if (z) {
                abf.m2524(this, C0459zf.m11165(adds.m2848(this)), 0L, 1 + jM11242);
            }
            C0461zs.m11605(adds.m2848(this), 1 + jM11242);
        }
        if (z) {
            C0450yf.m9556(this, adds.m2679(), C0453yj.m9871(adds.m2848(this)), (short) C0457zc.m10632(adds.m2767(this)));
            C0453yj.m9979(adds.m2767(this));
        }
    }

    private void m1433gc() {
        C0450yf.m9556(this, C0450yf.m9365(), m7873(adds.m2848(this)), (int) C0457zc.m10632(adds.m2767(this)));
        C0450yf.m9556(this, C0446yb.m8438(), m7873(adds.m2848(this)), (int) abd.m2026(C0449ye.m9159(this)));
    }

    private void m1434o(String str, int i, int i2) throws IOException {
        if (i2 != i) {
            throw new IOException(m7869(C0445ya.m8230(), new Object[]{str, abd.m2028(i2), abd.m2028(i)}));
        }
    }

    public static C0425pd m7852(Object obj) {
        if (C0453yj.m10013() > 0) {
            return m7884(obj);
        }
        return null;
    }

    public static InterfaceC0411oq m7853(Object obj) {
        if (abe.m2308() < 0) {
            return ((C0416ov) obj).f1314vt;
        }
        return null;
    }

    public static void m7854(Object obj, long j) {
        if (C0448yd.m9079() <= 0) {
            C0598.m11851(obj, j);
        }
    }

    public static int m7855(Object obj) {
        if (C0457zc.m10735() < 0) {
            return ((C0416ov) obj).f1313vs;
        }
        return 0;
    }

    public static void m7856(Object obj) throws EOFException {
        if (C0449ye.m9220() < 0) {
            ((C0416ov) obj).m1432gb();
        }
    }

    public static void m7857(Object obj) {
        if (abe.m2308() <= 0) {
            ((C0416ov) obj).m1433gc();
        }
    }

    public static void m7858(Object obj, Object obj2, long j, long j2) {
        if (C0451yg.m9580() > 0) {
            ((C0416ov) obj).m1431b((C0409oo) obj2, j, j2);
        }
    }

    public static C0425pd m7859(Object obj) {
        if (C0456zb.m10326() < 0) {
            return m7876(obj);
        }
        return null;
    }

    public static byte[] m7860(Object obj) {
        if (C0453yj.m10013() >= 0) {
            return ((C0425pd) obj).f1334vH;
        }
        return null;
    }

    public static Inflater m7861(Object obj) {
        if (C0460zg.m11287() > 0) {
            return ((C0416ov) obj).f1311vq;
        }
        return null;
    }

    public static int m7862(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return ((C0425pd) obj).f1332ea;
        }
        return 0;
    }

    public static void m7863(Object obj, Object obj2, int i, int i2) throws IOException {
        if (abd.m2162() >= 0) {
            ((C0416ov) obj).m1434o((String) obj2, i, i2);
        }
    }

    public static int m7864() {
        if (C0456zb.m10326() <= 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static C0417ow m7865(Object obj) {
        if (C0450yf.m9352() < 0) {
            return ((C0416ov) obj).f1312vr;
        }
        return null;
    }

    public static int m7866(Object obj) {
        if (abd.m2162() > 0) {
            return ((C0425pd) obj).f1333eh;
        }
        return 0;
    }

    public static long m7867(Object obj) {
        if (C0459zf.m11062() >= 0) {
            return ((C0409oo) obj).f1300oV;
        }
        return 0L;
    }

    public static C0430pi m7868(Object obj) {
        if (adds.m2755() >= 0) {
            return ((InterfaceC0411oq) obj).mo967dz();
        }
        return null;
    }

    public static String m7869(Object obj, Object obj2) {
        if (abf.m2510() < 0) {
            return C0598.m11903(obj, obj2);
        }
        return null;
    }

    public static C0425pd m7870(Object obj) {
        if (C0450yf.m9352() < 0) {
            return ((C0409oo) obj).f1301vh;
        }
        return null;
    }

    public static C0425pd m7871(Object obj) {
        if (abc.m1845() <= 0) {
            return ((C0425pd) obj).f1335vI;
        }
        return null;
    }

    public static void m7872(Object obj, Object obj2, int i, int i2) {
        if (abd.m2162() >= 0) {
            C0598.m11883(obj, obj2, i, i2);
        }
    }

    public static int m7873(Object obj) {
        if (C0453yj.m10013() > 0) {
            return C0598.m11797(obj);
        }
        return 0;
    }

    public static CRC32 m7874(Object obj) {
        if (abe.m2308() < 0) {
            return ((C0416ov) obj).f1310vp;
        }
        return null;
    }

    public static CRC32 m7875(Object obj) {
        if (C0457zc.m10555() > 0) {
            return m7874((C0416ov) obj);
        }
        return null;
    }

    public static C0425pd m7876(Object obj) {
        if (C0458ze.m10926() <= 0) {
            return m7871((C0425pd) obj);
        }
        return null;
    }

    public static void m7877(Object obj) {
        if (C0456zb.m10484() <= 0) {
            m7857((C0416ov) obj);
        }
    }

    public static void m7878(Object obj, Object obj2, long j, long j2) {
        if (abe.m2321() < 0) {
            m7858((C0416ov) obj, (C0409oo) obj2, j, j2);
        }
    }

    public static int m7879(Object obj) {
        if (m7864() > 0) {
            return m7855((C0416ov) obj);
        }
        return 0;
    }

    public static int m7880(Object obj) {
        if (C0457zc.m10718() < 0) {
            return m7866((C0425pd) obj);
        }
        return 0;
    }

    public static byte[] m7881(Object obj) {
        if (abf.m2500() >= 0) {
            return m7860((C0425pd) obj);
        }
        return null;
    }

    public static int m7882(Object obj) {
        if (C0448yd.m9074() <= 0) {
            return m7862((C0425pd) obj);
        }
        return 0;
    }

    public static Inflater m7883(Object obj) {
        if (abd.m2021() > 0) {
            return m7861((C0416ov) obj);
        }
        return null;
    }

    public static C0425pd m7884(Object obj) {
        if (C0456zb.m10484() < 0) {
            return m7870((C0409oo) obj);
        }
        return null;
    }

    public static C0417ow m7885(Object obj) {
        if (m7864() >= 0) {
            return m7865((C0416ov) obj);
        }
        return null;
    }

    public static void m7886(Object obj) throws EOFException {
        if (C0447yc.m8786() >= 0) {
            m7856((C0416ov) obj);
        }
    }

    public static C0430pi m7887(Object obj) {
        if (C0456zb.m10484() <= 0) {
            return m7868((InterfaceC0411oq) obj);
        }
        return null;
    }

    public static void m7888(Object obj, Object obj2, int i, int i2) {
        if (C0453yj.m9945() <= 0) {
            m7863((C0416ov) obj, (String) obj2, i, i2);
        }
    }

    public static long m7889(Object obj) {
        if (C0453yj.m10032() > 0) {
            return m7867((C0409oo) obj);
        }
        return 0L;
    }

    public static InterfaceC0411oq m7890(Object obj) {
        if (C0456zb.m10484() < 0) {
            return m7853((C0416ov) obj);
        }
        return null;
    }

    @Override
    public long mo966a(C0409oo c0409oo, long j) throws IOException {
        if (j < 0) {
            throw new IllegalArgumentException(abc.m1925(C0458ze.m10777(C0460zg.m11407(new StringBuilder(), adds.m2831()), j)));
        }
        if (j == 0) {
            return 0L;
        }
        if (C0452yh.m9603(this) == 0) {
            C0458ze.m10799(this);
            this.f1313vs = 1;
        }
        if (C0452yh.m9603(this) == 1) {
            long jM8408 = C0446yb.m8408(c0409oo);
            long jM8221 = C0445ya.m8221(C0447yc.m8721(this), c0409oo, j);
            if (jM8221 != -1) {
                abf.m2524(this, c0409oo, jM8408, jM8221);
                return jM8221;
            }
            this.f1313vs = 2;
        }
        if (C0452yh.m9603(this) == 2) {
            C0445ya.m8231(this);
            this.f1313vs = 3;
            if (!C0459zf.m11102(adds.m2848(this))) {
                throw new IOException(C0458ze.m10914());
            }
        }
        return -1L;
    }

    @Override
    public void close() {
        gggy.m4320(C0447yc.m8721(this));
    }

    @Override
    public C0430pi mo967dz() {
        return abe.m2349(adds.m2848(this));
    }
}
