package com.google.android.material.card2;

final class C0427pf extends C0412or {

    final transient int[] f1341vN;

    final transient byte[][] f1342vO;

    C0427pf(C0409oo c0409oo, int i) {
        super(null);
        m8121(m8150(c0409oo), 0L, i);
        C0425pd c0425pdM8126 = m8126(c0409oo);
        int iM8145 = 0;
        int i2 = 0;
        while (iM8145 < i) {
            if (m8145(c0425pdM8126) == m8141(c0425pdM8126)) {
                throw new AssertionError(C0450yf.m9457());
            }
            iM8145 += m8145(c0425pdM8126) - m8141(c0425pdM8126);
            i2++;
            c0425pdM8126 = m8131(c0425pdM8126);
        }
        this.f1342vO = new byte[i2][];
        this.f1341vN = new int[i2 * 2];
        C0425pd c0425pdM8127 = m8126(c0409oo);
        int i3 = 0;
        int iM8146 = 0;
        while (iM8146 < i) {
            m8143(this)[i3] = m8118(c0425pdM8127);
            iM8146 += m8145(c0425pdM8127) - m8141(c0425pdM8127);
            if (iM8146 > i) {
                iM8146 = i;
            }
            m8122(this)[i3] = iM8146;
            m8122(this)[m8143(this).length + i3] = m8141(c0425pdM8127);
            c0425pdM8127.f1338vL = true;
            i3++;
            c0425pdM8127 = m8131(c0425pdM8127);
        }
    }

    private int m1458N(int i) {
        int iM9916 = C0453yj.m9916(m8122(this), 0, m8143(this).length, i + 1);
        return iM9916 >= 0 ? iM9916 : iM9916 ^ (-1);
    }

    private C0412or m1459gj() {
        return new C0412or(m8135(this));
    }

    private Object writeReplace() {
        return m8130(this);
    }

    public static int[] m8117(Object obj) {
        if (C0457zc.m10735() <= 0) {
            return ((C0427pf) obj).f1341vN;
        }
        return null;
    }

    public static byte[] m8118(Object obj) {
        if (abe.m2308() < 0) {
            return m8157(obj);
        }
        return null;
    }

    public static int m8119(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return ((C0427pf) obj).f1304dV;
        }
        return 0;
    }

    public static boolean m8120(Object obj, int i, Object obj2, int i2, int i3) {
        if (C0446yb.m8415() < 0) {
            return ((C0427pf) obj).mo1408a(i, (C0412or) obj2, i2, i3);
        }
        return false;
    }

    public static void m8121(long j, long j2, long j3) {
        if (C0459zf.m11062() >= 0) {
            m8159(j, j2, j3);
        }
    }

    public static int[] m8122(Object obj) {
        if (abf.m2510() < 0) {
            return m8156(obj);
        }
        return null;
    }

    public static C0425pd m8123(Object obj) {
        if (C0448yd.m9079() < 0) {
            return m8154(obj);
        }
        return null;
    }

    public static int m8124(Object obj, int i) {
        if (C0460zg.m11287() > 0) {
            return ((C0427pf) obj).m1458N(i);
        }
        return 0;
    }

    public static int m8125(Object obj) {
        if (C0445ya.m8222() > 0) {
            return ((C0427pf) obj).size();
        }
        return 0;
    }

    public static C0425pd m8126(Object obj) {
        if (abc.m1845() <= 0) {
            return m8155(obj);
        }
        return null;
    }

    public static C0425pd m8127(Object obj) {
        if (C0461zs.m11510() < 0) {
            return ((C0425pd) obj).f1337vK;
        }
        return null;
    }

    public static int m8128() {
        if (abe.m2308() < 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static C0425pd m8129(Object obj) {
        if (C0457zc.m10735() < 0) {
            return ((C0425pd) obj).f1335vI;
        }
        return null;
    }

    public static C0412or m8130(Object obj) {
        if (abd.m2162() >= 0) {
            return m8169(obj);
        }
        return null;
    }

    public static C0425pd m8131(Object obj) {
        if (C0448yd.m9079() < 0) {
            return m8165(obj);
        }
        return null;
    }

    public static int m8132(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return m8163(obj);
        }
        return 0;
    }

    public static int m8133(Object obj, int i) {
        if (abc.m1845() < 0) {
            return m8170(obj, i);
        }
        return 0;
    }

    public static C0425pd m8134(Object obj) {
        if (abc.m1845() < 0) {
            return ((C0409oo) obj).f1301vh;
        }
        return null;
    }

    public static byte[] m8135(Object obj) {
        if (C0459zf.m11062() > 0) {
            return m8167(obj);
        }
        return null;
    }

    public static byte[] m8136(Object obj) {
        if (adds.m2755() > 0) {
            return ((C0425pd) obj).f1334vH;
        }
        return null;
    }

    public static byte[] m8137(Object obj) {
        if (C0448yd.m9079() < 0) {
            return ((C0427pf) obj).mo1418fR();
        }
        return null;
    }

    public static int m8138(Object obj) {
        if (C0453yj.m10013() > 0) {
            return ((C0425pd) obj).f1333eh;
        }
        return 0;
    }

    public static boolean m8139(Object obj, int i, Object obj2, int i2, int i3) {
        if (C0446yb.m8415() < 0) {
            return C0432pk.m1464a((byte[]) obj, i, (byte[]) obj2, i2, i3);
        }
        return false;
    }

    public static int m8140(Object obj) {
        if (C0452yh.m9798() >= 0) {
            return m8166(obj);
        }
        return 0;
    }

    public static int m8141(Object obj) {
        if (C0457zc.m10735() < 0) {
            return m8171(obj);
        }
        return 0;
    }

    public static long m8142(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return ((C0409oo) obj).f1300oV;
        }
        return 0L;
    }

    public static byte[][] m8143(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return m8160(obj);
        }
        return null;
    }

    public static C0425pd m8144(Object obj, Object obj2) {
        if (C0456zb.m10326() <= 0) {
            return m8164(obj, obj2);
        }
        return null;
    }

    public static int m8145(Object obj) {
        if (C0448yd.m9079() < 0) {
            return m8162(obj);
        }
        return 0;
    }

    public static byte[][] m8146(Object obj) {
        if (gggy.m4269() < 0) {
            return ((C0427pf) obj).f1342vO;
        }
        return null;
    }

    public static int m8147(Object obj) {
        if (C0458ze.m10932() > 0) {
            return ((C0425pd) obj).f1332ea;
        }
        return 0;
    }

    public static void m8148(long j, long j2, long j3) {
        if (C0450yf.m9352() <= 0) {
            C0432pk.m1462a(j, j2, j3);
        }
    }

    public static C0412or m8149(Object obj) {
        if (C0458ze.m10932() > 0) {
            return ((C0427pf) obj).m1459gj();
        }
        return null;
    }

    public static long m8150(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return m8168(obj);
        }
        return 0L;
    }

    public static boolean m8151(Object obj, int i, Object obj2, int i2, int i3) {
        if (C0460zg.m11287() > 0) {
            return m8158(obj, i, obj2, i2, i3);
        }
        return false;
    }

    public static boolean m8152(Object obj, int i, Object obj2, int i2, int i3) {
        if (C0448yd.m9079() < 0) {
            return m8161(obj, i, obj2, i2, i3);
        }
        return false;
    }

    public static C0425pd m8153(Object obj, Object obj2) {
        if (abd.m2162() > 0) {
            return ((C0425pd) obj).m1451a((C0425pd) obj2);
        }
        return null;
    }

    public static C0425pd m8154(Object obj) {
        if (C0457zc.m10555() >= 0) {
            return m8127((C0425pd) obj);
        }
        return null;
    }

    public static C0425pd m8155(Object obj) {
        if (C0453yj.m9966() > 0) {
            return m8134((C0409oo) obj);
        }
        return null;
    }

    public static int[] m8156(Object obj) {
        if (C0456zb.m10484() < 0) {
            return m8117((C0427pf) obj);
        }
        return null;
    }

    public static byte[] m8157(Object obj) {
        if (C0453yj.m9966() >= 0) {
            return m8136((C0425pd) obj);
        }
        return null;
    }

    public static boolean m8158(Object obj, int i, Object obj2, int i2, int i3) {
        if (C0448yd.m9074() <= 0) {
            return m8139((byte[]) obj, i, (byte[]) obj2, i2, i3);
        }
        return false;
    }

    public static void m8159(long j, long j2, long j3) {
        if (C0453yj.m9966() >= 0) {
            m8148(j, j2, j3);
        }
    }

    public static byte[][] m8160(Object obj) {
        if (abd.m2166() < 0) {
            return m8146((C0427pf) obj);
        }
        return null;
    }

    public static boolean m8161(Object obj, int i, Object obj2, int i2, int i3) {
        if (m8128() > 0) {
            return m8120((C0427pf) obj, i, (C0412or) obj2, i2, i3);
        }
        return false;
    }

    public static int m8162(Object obj) {
        if (C0459zf.m11053() > 0) {
            return m8147((C0425pd) obj);
        }
        return 0;
    }

    public static int m8163(Object obj) {
        if (C0457zc.m10555() > 0) {
            return m8119((C0427pf) obj);
        }
        return 0;
    }

    public static C0425pd m8164(Object obj, Object obj2) {
        if (abe.m2321() < 0) {
            return m8153((C0425pd) obj, (C0425pd) obj2);
        }
        return null;
    }

    public static C0425pd m8165(Object obj) {
        if (C0453yj.m9966() > 0) {
            return m8129((C0425pd) obj);
        }
        return null;
    }

    public static int m8166(Object obj) {
        if (C0453yj.m9966() >= 0) {
            return m8125((C0427pf) obj);
        }
        return 0;
    }

    public static byte[] m8167(Object obj) {
        if (gggy.m4365() >= 0) {
            return m8137((C0427pf) obj);
        }
        return null;
    }

    public static long m8168(Object obj) {
        if (C0453yj.m10032() > 0) {
            return m8142((C0409oo) obj);
        }
        return 0L;
    }

    public static C0412or m8169(Object obj) {
        if (C0453yj.m10032() >= 0) {
            return m8149((C0427pf) obj);
        }
        return null;
    }

    public static int m8170(Object obj, int i) {
        if (C0445ya.m8330() >= 0) {
            return m8124((C0427pf) obj, i);
        }
        return 0;
    }

    public static int m8171(Object obj) {
        if (abe.m2321() <= 0) {
            return m8138((C0425pd) obj);
        }
        return 0;
    }

    @Override
    public byte mo1406L(int i) {
        m8121(m8122(this)[m8143(this).length - 1], i, 1L);
        int iM8133 = m8133(this, i);
        return m8143(this)[iM8133][(i - (iM8133 == 0 ? 0 : m8122(this)[iM8133 - 1])) + m8122(this)[m8143(this).length + iM8133]];
    }

    @Override
    void mo1407a(C0409oo c0409oo) {
        int length = m8143(this).length;
        int i = 0;
        int i2 = 0;
        while (i < length) {
            int i3 = m8122(this)[length + i];
            int i4 = m8122(this)[i];
            C0425pd c0425pd = new C0425pd(m8143(this)[i], i3, (i3 + i4) - i2, true, false);
            if (m8126(c0409oo) == null) {
                c0425pd.f1337vK = c0425pd;
                c0425pd.f1335vI = c0425pd;
                c0409oo.f1301vh = c0425pd;
            } else {
                m8144(m8123(m8126(c0409oo)), c0425pd);
            }
            i++;
            i2 = i4;
        }
        c0409oo.f1300oV = m8150(c0409oo) + ((long) i2);
    }

    @Override
    public boolean mo1408a(int i, C0412or c0412or, int i2, int i3) {
        int i4 = i3;
        int i5 = i2;
        int i6 = i;
        if (i6 < 0 || i6 > m8140(this) - i4) {
            return false;
        }
        int iM8133 = m8133(this, i6);
        while (i4 > 0) {
            int i7 = iM8133 == 0 ? 0 : m8122(this)[iM8133 - 1];
            int iM10520 = C0456zb.m10520(i4, ((m8122(this)[iM8133] - i7) + i7) - i6);
            if (!C0450yf.m9393(c0412or, i5, m8143(this)[iM8133], (i6 - i7) + m8122(this)[m8143(this).length + iM8133], iM10520)) {
                return false;
            }
            i6 += iM10520;
            i5 += iM10520;
            i4 -= iM10520;
            iM8133++;
        }
        return true;
    }

    @Override
    public boolean mo1409a(int i, byte[] bArr, int i2, int i3) {
        int i4 = i3;
        int i5 = i2;
        int i6 = i;
        if (i6 < 0 || i6 > m8140(this) - i4 || i5 < 0 || i5 > bArr.length - i4) {
            return false;
        }
        int iM8133 = m8133(this, i6);
        while (i4 > 0) {
            int i7 = iM8133 == 0 ? 0 : m8122(this)[iM8133 - 1];
            int iM10520 = C0456zb.m10520(i4, ((m8122(this)[iM8133] - i7) + i7) - i6);
            if (!m8151(m8143(this)[iM8133], (i6 - i7) + m8122(this)[m8143(this).length + iM8133], bArr, i5, iM10520)) {
                return false;
            }
            i6 += iM10520;
            i5 += iM10520;
            i4 -= iM10520;
            iM8133++;
        }
        return true;
    }

    @Override
    public C0412or mo1411e(int i, int i2) {
        return gggy.m4354(m8130(this), i, i2);
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        }
        return (obj instanceof C0412or) && gggy.m4418((C0412or) obj) == m8140(this) && m8152(this, 0, (C0412or) obj, 0, m8140(this));
    }

    @Override
    public String mo1413fM() {
        return C0456zb.m10316(m8130(this));
    }

    @Override
    public String mo1414fN() {
        return gggy.m4359(m8130(this));
    }

    @Override
    public C0412or mo1415fO() {
        return C0452yh.m9763(m8130(this));
    }

    @Override
    public C0412or mo1416fP() {
        return C0447yc.m8787(m8130(this));
    }

    @Override
    public C0412or mo1417fQ() {
        return C0457zc.m10755(m8130(this));
    }

    @Override
    public byte[] mo1418fR() {
        byte[] bArr = new byte[m8122(this)[m8143(this).length - 1]];
        int length = m8143(this).length;
        int i = 0;
        int i2 = 0;
        while (i < length) {
            int i3 = m8122(this)[length + i];
            int i4 = m8122(this)[i];
            adds.m2876(m8143(this)[i], i3, bArr, i2, i4 - i2);
            i++;
            i2 = i4;
        }
        return bArr;
    }

    @Override
    public String mo1419fS() {
        return C0458ze.m10854(m8130(this));
    }

    @Override
    public int hashCode() {
        int iM8132 = m8132(this);
        if (iM8132 == 0) {
            iM8132 = 1;
            int length = m8143(this).length;
            int i = 0;
            int i2 = 0;
            while (i2 < length) {
                byte[] bArr = m8143(this)[i2];
                int i3 = m8122(this)[length + i2];
                int i4 = m8122(this)[i2];
                int i5 = iM8132;
                for (int i6 = i3; i6 < (i4 - i) + i3; i6++) {
                    i5 = bArr[i6] + (i5 * 31);
                }
                i = i4;
                i2++;
                iM8132 = i5;
            }
            this.f1304dV = iM8132;
        }
        return iM8132;
    }

    @Override
    public int size() {
        return m8122(this)[m8143(this).length - 1];
    }

    @Override
    public String toString() {
        return C0459zf.m11083(m8130(this));
    }
}
