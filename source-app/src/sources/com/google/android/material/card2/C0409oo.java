package com.google.android.material.card2;

import java.io.EOFException;
import java.nio.ByteBuffer;
import java.nio.channels.ByteChannel;
import java.nio.charset.Charset;
import javax.annotation.Nullable;

public final class C0409oo implements Cloneable, ByteChannel, InterfaceC0410op, InterfaceC0411oq {

    private static final byte[] f1299vg = {48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 97, 98, 99, 100, 101, 102};

    long f1300oV;

    @Nullable
    C0425pd f1301vh;

    public static void m7756(Object obj) {
        if (abe.m2308() <= 0) {
            C0426pe.m1456b((C0425pd) obj);
        }
    }

    public static C0425pd m7757(Object obj) {
        if (C0456zb.m10326() < 0) {
            return ((C0425pd) obj).f1335vI;
        }
        return null;
    }

    public static C0425pd m7758(Object obj) {
        if (abc.m1845() < 0) {
            return m7811(obj);
        }
        return null;
    }

    public static C0425pd m7759(Object obj, int i) {
        if (C0445ya.m8222() >= 0) {
            return m7801(obj, i);
        }
        return null;
    }

    public static C0425pd m7760(Object obj) {
        if (abf.m2510() < 0) {
            return m7805(obj);
        }
        return null;
    }

    public static C0425pd m7761(Object obj) {
        if (abe.m2308() <= 0) {
            return m7812(obj);
        }
        return null;
    }

    public static int m7762(Object obj) {
        if (adds.m2755() > 0) {
            return C0598.m11799(obj);
        }
        return 0;
    }

    public static C0425pd m7763(Object obj, int i) {
        if (C0459zf.m11062() >= 0) {
            return ((C0409oo) obj).m1341D(i);
        }
        return null;
    }

    public static long m7764(Object obj) {
        if (C0460zg.m11287() > 0) {
            return ((C0409oo) obj).f1300oV;
        }
        return 0L;
    }

    public static C0425pd m7765(Object obj) {
        if (abd.m2162() >= 0) {
            return m7797(obj);
        }
        return null;
    }

    public static byte[] m7766(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return ((C0425pd) obj).f1334vH;
        }
        return null;
    }

    public static C0425pd m7767(Object obj) {
        if (abd.m2162() > 0) {
            return ((C0425pd) obj).m1454gg();
        }
        return null;
    }

    public static String m7768() {
        if (C0457zc.m10735() <= 0) {
            return C0598.m11894();
        }
        return null;
    }

    public static C0425pd m7769(Object obj, Object obj2) {
        if (abd.m2162() >= 0) {
            return ((C0425pd) obj).m1451a((C0425pd) obj2);
        }
        return null;
    }

    public static C0425pd m7770(Object obj) {
        if (adds.m2755() > 0) {
            return ((C0425pd) obj).f1337vK;
        }
        return null;
    }

    public static C0425pd m7771() {
        if (abe.m2308() < 0) {
            return C0426pe.m1457gi();
        }
        return null;
    }

    public static short m7772(short s) {
        if (C0459zf.m11062() >= 0) {
            return C0432pk.m1461a(s);
        }
        return (short) 0;
    }

    public static void m7773(Object obj, Object obj2) {
        if (C0456zb.m10326() < 0) {
            ((C0412or) obj).mo1407a((C0409oo) obj2);
        }
    }

    public static int m7774(long j) {
        if (abd.m2162() > 0) {
            return C0598.m11839(j);
        }
        return 0;
    }

    public static void m7775(Object obj) {
        if (abf.m2510() < 0) {
            ((C0425pd) obj).m1453gf();
        }
    }

    public static String m7776(Object obj, Object obj2) {
        if (C0461zs.m11510() < 0) {
            return C0598.m11903(obj, obj2);
        }
        return null;
    }

    public static String m7777(Object obj, long j) {
        if (C0450yf.m9352() <= 0) {
            return ((C0409oo) obj).m1390m(j);
        }
        return null;
    }

    public static C0425pd m7778(Object obj, Object obj2) {
        if (C0460zg.m11287() >= 0) {
            return m7808(obj, obj2);
        }
        return null;
    }

    public static C0425pd m7779(Object obj, int i) {
        if (C0446yb.m8415() < 0) {
            return ((C0425pd) obj).m1450M(i);
        }
        return null;
    }

    public static int m7780(Object obj) {
        if (abf.m2510() < 0) {
            return ((C0425pd) obj).f1333eh;
        }
        return 0;
    }

    public static boolean m7781(Object obj) {
        if (abc.m1845() < 0) {
            return ((C0425pd) obj).f1338vL;
        }
        return false;
    }

    public static C0425pd m7782() {
        if (C0448yd.m9079() <= 0) {
            return m7796();
        }
        return null;
    }

    public static String m7783() {
        if (C0450yf.m9352() <= 0) {
            return C0598.m11829();
        }
        return null;
    }

    public static byte[] m7784() {
        if (C0461zs.m11510() < 0) {
            return f1299vg;
        }
        return null;
    }

    public static C0425pd m7785(Object obj) {
        if (C0461zs.m11510() < 0) {
            return ((C0409oo) obj).f1301vh;
        }
        return null;
    }

    public static boolean m7786(Object obj) {
        if (C0452yh.m9798() > 0) {
            return ((C0425pd) obj).f1336vJ;
        }
        return false;
    }

    public static C0425pd m7787(Object obj) {
        if (C0451yg.m9580() > 0) {
            return ((C0425pd) obj).m1455gh();
        }
        return null;
    }

    public static int m7788(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return ((C0425pd) obj).f1332ea;
        }
        return 0;
    }

    public static int m7789(int i) {
        if (gggy.m4269() <= 0) {
            return C0432pk.m1460O(i);
        }
        return 0;
    }

    public static C0412or m7790(Object obj, int i) {
        if (abf.m2510() < 0) {
            return C0598.m11818(obj, i);
        }
        return null;
    }

    public static C0425pd m7791(Object obj, int i) {
        if (C0459zf.m11062() > 0) {
            return m7804(obj, i);
        }
        return null;
    }

    public static C0425pd m7792(Object obj) {
        if (C0447yc.m8635() > 0) {
            return m7813(obj);
        }
        return null;
    }

    public static void m7793(Object obj, Object obj2, int i) {
        if (C0445ya.m8222() >= 0) {
            ((C0425pd) obj).m1452a((C0425pd) obj2, i);
        }
    }

    public static void m7794(long j, long j2, long j3) {
        if (abf.m2510() < 0) {
            C0432pk.m1462a(j, j2, j3);
        }
    }

    public static Charset m7795() {
        if (adds.m2755() >= 0) {
            return C0432pk.f1347vT;
        }
        return null;
    }

    public static C0425pd m7796() {
        if (C0447yc.m8786() >= 0) {
            return m7771();
        }
        return null;
    }

    public static C0425pd m7797(Object obj) {
        if (C0453yj.m9966() > 0) {
            return m7757((C0425pd) obj);
        }
        return null;
    }

    public static short m7798(short s) {
        if (C0453yj.m9966() >= 0) {
            return m7772(s);
        }
        return (short) 0;
    }

    public static void m7799(Object obj, Object obj2, int i) {
        if (C0448yd.m9015() < 0) {
            m7793((C0425pd) obj, (C0425pd) obj2, i);
        }
    }

    public static boolean m7800(Object obj) {
        if (C0456zb.m10484() <= 0) {
            return m7786((C0425pd) obj);
        }
        return false;
    }

    public static C0425pd m7801(Object obj, int i) {
        if (C0453yj.m10032() > 0) {
            return m7779((C0425pd) obj, i);
        }
        return null;
    }

    public static int m7802(Object obj) {
        if (C0456zb.m10484() < 0) {
            return m7788((C0425pd) obj);
        }
        return 0;
    }

    public static Charset m7803() {
        if (C0447yc.m8786() > 0) {
            return m7795();
        }
        return null;
    }

    public static C0425pd m7804(Object obj, int i) {
        if (abd.m2021() >= 0) {
            return m7763((C0409oo) obj, i);
        }
        return null;
    }

    public static C0425pd m7805(Object obj) {
        if (C0456zb.m10484() <= 0) {
            return m7770((C0425pd) obj);
        }
        return null;
    }

    public static void m7806(Object obj) {
        if (abd.m2166() <= 0) {
            m7775((C0425pd) obj);
        }
    }

    public static String m7807(Object obj, long j) {
        if (C0453yj.m10032() > 0) {
            return m7777((C0409oo) obj, j);
        }
        return null;
    }

    public static C0425pd m7808(Object obj, Object obj2) {
        if (C0447yc.m8786() >= 0) {
            return m7769((C0425pd) obj, (C0425pd) obj2);
        }
        return null;
    }

    public static long m7809(Object obj) {
        if (C0447yc.m8786() >= 0) {
            return m7764((C0409oo) obj);
        }
        return 0L;
    }

    public static void m7810(Object obj, Object obj2) {
        if (C0448yd.m9074() < 0) {
            m7773((C0412or) obj, (C0409oo) obj2);
        }
    }

    public static C0425pd m7811(Object obj) {
        if (abe.m2321() < 0) {
            return m7785((C0409oo) obj);
        }
        return null;
    }

    public static C0425pd m7812(Object obj) {
        if (C0460zg.m11293() >= 0) {
            return m7787((C0425pd) obj);
        }
        return null;
    }

    public static C0425pd m7813(Object obj) {
        if (C0456zb.m10484() <= 0) {
            return m7767((C0425pd) obj);
        }
        return null;
    }

    public static byte[] m7814() {
        if (C0460zg.m11293() >= 0) {
            return m7784();
        }
        return null;
    }

    public static int m7815(int i) {
        if (abf.m2500() >= 0) {
            return m7789(i);
        }
        return 0;
    }

    public static int m7816(Object obj) {
        if (C0453yj.m9996() < 0) {
            return m7780((C0425pd) obj);
        }
        return 0;
    }

    public static byte[] m7817(Object obj) {
        if (C0453yj.m9996() < 0) {
            return m7766((C0425pd) obj);
        }
        return null;
    }

    public static void m7818(Object obj) {
        if (gggy.m4365() >= 0) {
            m7756((C0425pd) obj);
        }
    }

    public static boolean m7819(Object obj) {
        if (C0457zc.m10718() < 0) {
            return m7781((C0425pd) obj);
        }
        return false;
    }

    public static void m7820(long j, long j2, long j3) {
        if (C0453yj.m9966() >= 0) {
            m7794(j, j2, j3);
        }
    }

    public final C0412or m1340C(int i) {
        return i == 0 ? abe.m2357() : new C0427pf(this, i);
    }

    C0425pd m1341D(int i) {
        if (i < 1 || i > 8192) {
            throw new IllegalArgumentException();
        }
        if (m7758(this) != null) {
            C0425pd c0425pdM7760 = m7760(m7758(this));
            return (C0452yh.m9759(c0425pdM7760) + i > 8192 || !abf.m2548(c0425pdM7760)) ? m7778(c0425pdM7760, m7782()) : c0425pdM7760;
        }
        this.f1301vh = m7782();
        C0425pd c0425pdM7758 = m7758(this);
        C0425pd c0425pdM7759 = m7758(this);
        C0425pd c0425pdM77510 = m7758(this);
        c0425pdM7759.f1337vK = c0425pdM77510;
        c0425pdM7758.f1335vI = c0425pdM77510;
        return c0425pdM77510;
    }

    public C0409oo m1342E(int i) {
        C0425pd c0425pdM7791 = m7791(this, 1);
        byte[] bArrM2630 = abf.m2630(c0425pdM7791);
        int iM9759 = C0452yh.m9759(c0425pdM7791);
        c0425pdM7791.f1332ea = iM9759 + 1;
        bArrM2630[iM9759] = (byte) i;
        this.f1300oV = C0456zb.m10439(this) + 1;
        return this;
    }

    @Override
    public InterfaceC0410op mo1343F(int i) {
        return C0447yc.m8844(this, i);
    }

    public C0409oo m1344G(int i) {
        C0425pd c0425pdM7791 = m7791(this, 4);
        byte[] bArrM2630 = abf.m2630(c0425pdM7791);
        int iM9759 = C0452yh.m9759(c0425pdM7791);
        int i2 = iM9759 + 1;
        bArrM2630[iM9759] = (byte) ((i >>> 24) & 255);
        int i3 = i2 + 1;
        bArrM2630[i2] = (byte) ((i >>> 16) & 255);
        int i4 = i3 + 1;
        bArrM2630[i3] = (byte) ((i >>> 8) & 255);
        bArrM2630[i4] = (byte) (i & 255);
        c0425pdM7791.f1332ea = i4 + 1;
        this.f1300oV = C0456zb.m10439(this) + 4;
        return this;
    }

    @Override
    public InterfaceC0410op mo1345H(int i) {
        return abc.m1923(this, i);
    }

    public C0409oo m1346I(int i) {
        C0425pd c0425pdM7791 = m7791(this, 2);
        byte[] bArrM2630 = abf.m2630(c0425pdM7791);
        int iM9759 = C0452yh.m9759(c0425pdM7791);
        int i2 = iM9759 + 1;
        bArrM2630[iM9759] = (byte) ((i >>> 8) & 255);
        bArrM2630[i2] = (byte) (i & 255);
        c0425pdM7791.f1332ea = i2 + 1;
        this.f1300oV = C0456zb.m10439(this) + 2;
        return this;
    }

    @Override
    public InterfaceC0410op mo1347J(int i) {
        return C0448yd.m9086(this, i);
    }

    public C0409oo m1348K(int i) {
        if (i < 128) {
            C0447yc.m8844(this, i);
        } else if (i < 2048) {
            C0447yc.m8844(this, (i >> 6) | 192);
            C0447yc.m8844(this, (i & 63) | 128);
        } else if (i < 65536) {
            if (i < 55296 || i > 57343) {
                C0447yc.m8844(this, (i >> 12) | 224);
                C0447yc.m8844(this, ((i >> 6) & 63) | 128);
                C0447yc.m8844(this, (i & 63) | 128);
            } else {
                C0447yc.m8844(this, 63);
            }
        } else {
            if (i > 1114111) {
                throw new IllegalArgumentException(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0453yj.m9947()), C0447yc.m8791(i))));
            }
            C0447yc.m8844(this, (i >> 18) | 240);
            C0447yc.m8844(this, ((i >> 12) & 63) | 128);
            C0447yc.m8844(this, ((i >> 6) & 63) | 128);
            C0447yc.m8844(this, (i & 63) | 128);
        }
        return this;
    }

    public int m1349a(byte[] bArr, int i, int i2) {
        C0445ya.m8392(bArr.length, i, i2);
        C0425pd c0425pdM7758 = m7758(this);
        if (c0425pdM7758 == null) {
            return -1;
        }
        int iM10520 = C0456zb.m10520(i2, C0452yh.m9759(c0425pdM7758) - C0445ya.m8250(c0425pdM7758));
        adds.m2876(abf.m2630(c0425pdM7758), C0445ya.m8250(c0425pdM7758), bArr, i, iM10520);
        c0425pdM7758.f1333eh = C0445ya.m8250(c0425pdM7758) + iM10520;
        this.f1300oV = C0456zb.m10439(this) - ((long) iM10520);
        if (C0445ya.m8250(c0425pdM7758) != C0452yh.m9759(c0425pdM7758)) {
            return iM10520;
        }
        this.f1301vh = m7792(c0425pdM7758);
        C0461zs.m11552(c0425pdM7758);
        return iM10520;
    }

    @Override
    public long mo1350a(byte b) {
        return C0458ze.m10877(this, b, 0L, Long.MAX_VALUE);
    }

    public long m1351a(byte b, long j, long j2) {
        C0425pd c0425pdM7758;
        long jM9759;
        long j3;
        byte[] bArrM2630;
        int iM9495;
        int iM8250;
        long jM10439 = j2;
        long j4 = j;
        if (j4 < 0 || jM10439 < j4) {
            throw new IllegalArgumentException(m7776(abf.m2604(), new Object[]{C0456zb.m10500(C0456zb.m10439(this)), C0456zb.m10500(j4), C0456zb.m10500(jM10439)}));
        }
        if (jM10439 > C0456zb.m10439(this)) {
            jM10439 = C0456zb.m10439(this);
        }
        if (j4 == jM10439 || (c0425pdM7758 = m7758(this)) == null) {
            return -1L;
        }
        if (C0456zb.m10439(this) - j4 < j4) {
            jM9759 = C0456zb.m10439(this);
            while (jM9759 > j4) {
                c0425pdM7758 = m7760(c0425pdM7758);
                jM9759 -= (long) (C0452yh.m9759(c0425pdM7758) - C0445ya.m8250(c0425pdM7758));
            }
        } else {
            jM9759 = 0;
            while (true) {
                long jM97510 = ((long) (C0452yh.m9759(c0425pdM7758) - C0445ya.m8250(c0425pdM7758))) + jM9759;
                if (jM97510 >= j4) {
                    break;
                }
                c0425pdM7758 = m7765(c0425pdM7758);
                jM9759 = jM97510;
            }
            while (true) {
                j3 = jM9759;
                if (j3 < jM10439) {
                    return -1L;
                }
                bArrM2630 = abf.m2630(c0425pdM7758);
                iM9495 = (int) C0450yf.m9495(C0452yh.m9759(c0425pdM7758), (((long) C0445ya.m8250(c0425pdM7758)) + jM10439) - j3);
                for (iM8250 = (int) ((((long) C0445ya.m8250(c0425pdM7758)) + j4) - j3); iM8250 < iM9495; iM8250++) {
                    if (bArrM2630[iM8250] == b) {
                        return ((long) (iM8250 - C0445ya.m8250(c0425pdM7758))) + j3;
                    }
                }
                jM9759 = ((long) (C0452yh.m9759(c0425pdM7758) - C0445ya.m8250(c0425pdM7758))) + j3;
                c0425pdM7758 = m7765(c0425pdM7758);
                j4 = jM9759;
            }
        }
        while (true) {
            j3 = jM9759;
            if (j3 < jM10439) {
                return -1L;
            }
            bArrM2630 = abf.m2630(c0425pdM7758);
            iM9495 = (int) C0450yf.m9495(C0452yh.m9759(c0425pdM7758), (((long) C0445ya.m8250(c0425pdM7758)) + jM10439) - j3);
            while (iM8250 < iM9495) {
                if (bArrM2630[iM8250] == b) {
                    return ((long) (iM8250 - C0445ya.m8250(c0425pdM7758))) + j3;
                }
            }
            jM9759 = ((long) (C0452yh.m9759(c0425pdM7758) - C0445ya.m8250(c0425pdM7758))) + j3;
            c0425pdM7758 = m7765(c0425pdM7758);
            j4 = jM9759;
        }
    }

    @Override
    public long mo966a(C0409oo c0409oo, long j) {
        if (c0409oo == null) {
            throw new IllegalArgumentException(m7783());
        }
        if (j < 0) {
            throw new IllegalArgumentException(abc.m1925(C0458ze.m10777(C0460zg.m11407(new StringBuilder(), adds.m2831()), j)));
        }
        if (C0456zb.m10439(this) == 0) {
            return -1L;
        }
        long jM10439 = j > C0456zb.m10439(this) ? C0456zb.m10439(this) : j;
        C0458ze.m10826(c0409oo, this, jM10439);
        return jM10439;
    }

    public final C0409oo m1352a(C0409oo c0409oo, long j, long j2) {
        long jM9759 = j2;
        long jM97510 = j;
        if (c0409oo == null) {
            throw new IllegalArgumentException(C0456zb.m10307());
        }
        C0445ya.m8392(C0456zb.m10439(this), jM97510, jM9759);
        if (jM9759 != 0) {
            c0409oo.f1300oV = C0456zb.m10439(c0409oo) + jM9759;
            C0425pd c0425pdM7758 = m7758(this);
            while (jM97510 >= C0452yh.m9759(c0425pdM7758) - C0445ya.m8250(c0425pdM7758)) {
                jM97510 -= (long) (C0452yh.m9759(c0425pdM7758) - C0445ya.m8250(c0425pdM7758));
                c0425pdM7758 = m7765(c0425pdM7758);
            }
            while (jM9759 > 0) {
                C0425pd c0425pdM7761 = m7761(c0425pdM7758);
                c0425pdM7761.f1333eh = (int) (((long) C0445ya.m8250(c0425pdM7761)) + jM97510);
                c0425pdM7761.f1332ea = C0456zb.m10520(C0445ya.m8250(c0425pdM7761) + ((int) jM9759), C0452yh.m9759(c0425pdM7761));
                if (m7758(c0409oo) == null) {
                    c0425pdM7761.f1337vK = c0425pdM7761;
                    c0425pdM7761.f1335vI = c0425pdM7761;
                    c0409oo.f1301vh = c0425pdM7761;
                } else {
                    m7778(m7760(m7758(c0409oo)), c0425pdM7761);
                }
                jM9759 -= (long) (C0452yh.m9759(c0425pdM7761) - C0445ya.m8250(c0425pdM7761));
                c0425pdM7758 = m7765(c0425pdM7758);
                jM97510 = 0;
            }
        }
        return this;
    }

    public C0409oo m1353a(String str, int i, int i2, Charset charset) {
        if (str == null) {
            throw new IllegalArgumentException(C0457zc.m10529());
        }
        if (i < 0) {
            throw new IllegalAccessError(abc.m1925(adds.m2680(C0460zg.m11407(new StringBuilder(), C0455za.m10240()), i)));
        }
        if (i2 < i) {
            throw new IllegalArgumentException(abc.m1925(adds.m2680(C0460zg.m11407(adds.m2680(C0460zg.m11407(new StringBuilder(), C0457zc.m10592()), i2), gggy.m4302()), i)));
        }
        if (i2 > gggy.m4397(str)) {
            throw new IllegalArgumentException(abc.m1925(adds.m2680(C0460zg.m11407(adds.m2680(C0460zg.m11407(new StringBuilder(), C0447yc.m8837()), i2), C0458ze.m10839()), gggy.m4397(str))));
        }
        if (charset == null) {
            throw new IllegalArgumentException(m7768());
        }
        if (C0450yf.m9449(charset, C0457zc.m10665())) {
            return abc.m1815(this, str, i, i2);
        }
        byte[] bArrM10721 = C0457zc.m10721(C0447yc.m8745(str, i, i2), charset);
        return abf.m2562(this, bArrM10721, 0, bArrM10721.length);
    }

    public String m1354a(long j, Charset charset) {
        C0445ya.m8392(C0456zb.m10439(this), 0L, j);
        if (charset == null) {
            throw new IllegalArgumentException(m7768());
        }
        if (j > 2147483647L) {
            throw new IllegalArgumentException(abc.m1925(C0458ze.m10777(C0460zg.m11407(new StringBuilder(), C0452yh.m9613()), j)));
        }
        if (j == 0) {
            return gggy.m4277();
        }
        C0425pd c0425pdM7758 = m7758(this);
        if (((long) C0445ya.m8250(c0425pdM7758)) + j > C0452yh.m9759(c0425pdM7758)) {
            return new String(C0458ze.m10884(this, j), charset);
        }
        String str = new String(abf.m2630(c0425pdM7758), C0445ya.m8250(c0425pdM7758), (int) j, charset);
        c0425pdM7758.f1333eh = (int) (((long) C0445ya.m8250(c0425pdM7758)) + j);
        this.f1300oV = C0456zb.m10439(this) - j;
        if (C0445ya.m8250(c0425pdM7758) != C0452yh.m9759(c0425pdM7758)) {
            return str;
        }
        this.f1301vh = m7792(c0425pdM7758);
        C0461zs.m11552(c0425pdM7758);
        return str;
    }

    @Override
    public boolean mo1355a(long j, C0412or c0412or) {
        return abc.m1784(this, j, c0412or, 0, gggy.m4418(c0412or));
    }

    public boolean m1356a(long j, C0412or c0412or, int i, int i2) {
        if (j < 0 || i < 0 || i2 < 0 || C0456zb.m10439(this) - j < i2 || gggy.m4418(c0412or) - i < i2) {
            return false;
        }
        for (int i3 = 0; i3 < i2; i3++) {
            if (C0461zs.m11475(this, ((long) i3) + j) != C0447yc.m8829(c0412or, i + i3)) {
                return false;
            }
        }
        return true;
    }

    public C0409oo m1357am(String str) {
        return abc.m1815(this, str, 0, gggy.m4397(str));
    }

    @Override
    public InterfaceC0410op mo1358an(String str) {
        return C0457zc.m10684(this, str);
    }

    public long m1359b(InterfaceC0429ph interfaceC0429ph) {
        if (interfaceC0429ph == null) {
            throw new IllegalArgumentException(gggy.m4409());
        }
        long j = 0;
        while (true) {
            long jM2209 = abe.m2209(interfaceC0429ph, this, 8192L);
            if (jM2209 == -1) {
                return j;
            }
            j += jM2209;
        }
    }

    public C0409oo m1360b(byte[] bArr, int i, int i2) {
        int i3 = i;
        if (bArr == null) {
            throw new IllegalArgumentException(gggy.m4409());
        }
        C0445ya.m8392(bArr.length, i3, i2);
        int i4 = i3 + i2;
        while (i3 < i4) {
            C0425pd c0425pdM7791 = m7791(this, 1);
            int iM10520 = C0456zb.m10520(i4 - i3, 8192 - C0452yh.m9759(c0425pdM7791));
            adds.m2876(bArr, i3, abf.m2630(c0425pdM7791), C0452yh.m9759(c0425pdM7791), iM10520);
            i3 += iM10520;
            c0425pdM7791.f1332ea = iM10520 + C0452yh.m9759(c0425pdM7791);
        }
        this.f1300oV = C0456zb.m10439(this) + ((long) i2);
        return this;
    }

    @Override
    public String mo1361b(Charset charset) {
        try {
            return C0459zf.m11210(this, C0456zb.m10439(this), charset);
        } catch (EOFException e) {
            throw new AssertionError(e);
        }
    }

    @Override
    public void mo1045b(C0409oo c0409oo, long j) {
        long j2 = j;
        if (c0409oo == null) {
            throw new IllegalArgumentException(gggy.m4409());
        }
        if (c0409oo == this) {
            throw new IllegalArgumentException(C0446yb.m8417());
        }
        C0445ya.m8392(C0456zb.m10439(c0409oo), 0L, j2);
        while (j2 > 0) {
            if (j2 < C0452yh.m9759(m7758(c0409oo)) - C0445ya.m8250(m7758(c0409oo))) {
                C0425pd c0425pdM7760 = m7758(this) != null ? m7760(m7758(this)) : null;
                if (c0425pdM7760 != null && abf.m2548(c0425pdM7760)) {
                    if ((((long) C0452yh.m9759(c0425pdM7760)) + j2) - ((long) (C0459zf.m11043(c0425pdM7760) ? 0 : C0445ya.m8250(c0425pdM7760))) <= 8192) {
                        C0459zf.m11051(m7758(c0409oo), c0425pdM7760, (int) j2);
                        c0409oo.f1300oV = C0456zb.m10439(c0409oo) - j2;
                        this.f1300oV = C0456zb.m10439(this) + j2;
                        return;
                    }
                }
                c0409oo.f1301vh = m7759(m7758(c0409oo), (int) j2);
            }
            C0425pd c0425pdM7758 = m7758(c0409oo);
            long jM9759 = C0452yh.m9759(c0425pdM7758) - C0445ya.m8250(c0425pdM7758);
            c0409oo.f1301vh = m7792(c0425pdM7758);
            if (m7758(this) == null) {
                this.f1301vh = c0425pdM7758;
                C0425pd c0425pdM7759 = m7758(this);
                C0425pd c0425pdM77510 = m7758(this);
                C0425pd c0425pdM77511 = m7758(this);
                c0425pdM77510.f1337vK = c0425pdM77511;
                c0425pdM7759.f1335vI = c0425pdM77511;
            } else {
                C0449ye.m9150(m7778(m7760(m7758(this)), c0425pdM7758));
            }
            c0409oo.f1300oV = C0456zb.m10439(c0409oo) - jM9759;
            this.f1300oV = C0456zb.m10439(this) + jM9759;
            j2 -= jM9759;
        }
    }

    @Override
    public InterfaceC0410op mo1362c(byte[] bArr, int i, int i2) {
        return abf.m2562(this, bArr, i, i2);
    }

    public Object clone() {
        return gggy.m4405(this);
    }

    @Override
    public void close() {
    }

    public C0409oo m1363d(C0412or c0412or) {
        if (c0412or == null) {
            throw new IllegalArgumentException(C0459zf.m11081());
        }
        adds.m2781(c0412or, this);
        return this;
    }

    @Override
    public void mo1364d(byte[] bArr) throws EOFException {
        int i = 0;
        while (i < bArr.length) {
            int iM9577 = C0450yf.m9577(this, bArr, i, bArr.length - i);
            if (iM9577 == -1) {
                throw new EOFException();
            }
            i += iM9577;
        }
    }

    @Override
    public C0430pi mo1095dz() {
        return abd.m2153();
    }

    public C0409oo m1365e(byte[] bArr) {
        if (bArr == null) {
            throw new IllegalArgumentException(gggy.m4409());
        }
        return abf.m2562(this, bArr, 0, bArr.length);
    }

    public boolean equals(Object obj) {
        long j = 0;
        if (this == obj) {
            return true;
        }
        if (!(obj instanceof C0409oo)) {
            return false;
        }
        C0409oo c0409oo = (C0409oo) obj;
        if (C0456zb.m10439(this) != C0456zb.m10439(c0409oo)) {
            return false;
        }
        if (C0456zb.m10439(this) == 0) {
            return true;
        }
        C0425pd c0425pdM7758 = m7758(this);
        C0425pd c0425pdM7759 = m7758(c0409oo);
        int iM8250 = C0445ya.m8250(c0425pdM7758);
        int iM8251 = C0445ya.m8250(c0425pdM7759);
        while (j < C0456zb.m10439(this)) {
            long jM10520 = C0456zb.m10520(C0452yh.m9759(c0425pdM7758) - iM8250, C0452yh.m9759(c0425pdM7759) - iM8251);
            int i = 0;
            while (i < jM10520) {
                if (abf.m2630(c0425pdM7758)[iM8250] != abf.m2630(c0425pdM7759)[iM8251]) {
                    return false;
                }
                i++;
                iM8251++;
                iM8250++;
            }
            if (iM8250 == C0452yh.m9759(c0425pdM7758)) {
                c0425pdM7758 = m7765(c0425pdM7758);
                iM8250 = C0445ya.m8250(c0425pdM7758);
            }
            if (iM8251 == C0452yh.m9759(c0425pdM7759)) {
                c0425pdM7759 = m7765(c0425pdM7759);
                iM8251 = C0445ya.m8250(c0425pdM7759);
            }
            j += jM10520;
        }
        return true;
    }

    public C0412or m1366ex() {
        return new C0412or(C0457zc.m10533(this));
    }

    @Override
    public InterfaceC0410op mo1367f(byte[] bArr) {
        return C0453yj.m9824(this, bArr);
    }

    @Override
    public boolean mo1368fA() {
        return C0456zb.m10439(this) == 0;
    }

    @Override
    public byte mo1369fB() {
        if (C0456zb.m10439(this) == 0) {
            throw new IllegalStateException(C0455za.m10139());
        }
        C0425pd c0425pdM7758 = m7758(this);
        int iM8250 = C0445ya.m8250(c0425pdM7758);
        int iM9759 = C0452yh.m9759(c0425pdM7758);
        int i = iM8250 + 1;
        byte b = abf.m2630(c0425pdM7758)[iM8250];
        this.f1300oV = C0456zb.m10439(this) - 1;
        if (i == iM9759) {
            this.f1301vh = m7792(c0425pdM7758);
            C0461zs.m11552(c0425pdM7758);
        } else {
            c0425pdM7758.f1333eh = i;
        }
        return b;
    }

    public byte[] m1370fC() {
        try {
            return C0458ze.m10884(this, C0456zb.m10439(this));
        } catch (EOFException e) {
            throw new AssertionError(e);
        }
    }

    @Override
    public long mo1371fD() {
        int i;
        int i2 = 0;
        if (C0456zb.m10439(this) == 0) {
            throw new IllegalStateException(C0455za.m10139());
        }
        long j = 0;
        boolean z = false;
        do {
            C0425pd c0425pdM7758 = m7758(this);
            byte[] bArrM2630 = abf.m2630(c0425pdM7758);
            int iM8250 = C0445ya.m8250(c0425pdM7758);
            int iM9759 = C0452yh.m9759(c0425pdM7758);
            i2 = i2;
            while (iM8250 < iM9759) {
                byte b = bArrM2630[iM8250];
                if (b >= 48 && b <= 57) {
                    i = b - 48;
                } else if (b >= 97 && b <= 102) {
                    i = (b - 97) + 10;
                } else {
                    if (b < 65 || b > 70) {
                        if (i2 != 0) {
                            z = true;
                            break;
                        }
                        throw new NumberFormatException(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), gggy.m4494()), C0447yc.m8791(b))));
                    }
                    i = (b - 65) + 10;
                }
                if (((-1152921504606846976L) & j) != 0) {
                    throw new NumberFormatException(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), gggy.m4335()), C0456zb.m10496(C0447yc.m8844(abf.m2564(new C0409oo(), j), b)))));
                }
                j = (j << 4) | ((long) i);
                i2++;
                iM8250++;
            }
            if (iM8250 == iM9759) {
                this.f1301vh = m7792(c0425pdM7758);
                C0461zs.m11552(c0425pdM7758);
            } else {
                c0425pdM7758.f1333eh = iM8250;
            }
            if (z) {
                break;
            }
        } while (m7758(this) != null);
        this.f1300oV = C0456zb.m10439(this) - ((long) i2);
        return j;
    }

    @Override
    public int mo1372fE() {
        if (C0456zb.m10439(this) < 4) {
            throw new IllegalStateException(abc.m1925(C0458ze.m10777(C0460zg.m11407(new StringBuilder(), C0446yb.m8520()), C0456zb.m10439(this))));
        }
        C0425pd c0425pdM7758 = m7758(this);
        int iM8250 = C0445ya.m8250(c0425pdM7758);
        int iM9759 = C0452yh.m9759(c0425pdM7758);
        if (iM9759 - iM8250 < 4) {
            return ((C0460zg.m11394(this) & 255) << 24) | ((C0460zg.m11394(this) & 255) << 16) | ((C0460zg.m11394(this) & 255) << 8) | (C0460zg.m11394(this) & 255);
        }
        byte[] bArrM2630 = abf.m2630(c0425pdM7758);
        int i = iM8250 + 1;
        int i2 = i + 1;
        int i3 = i2 + 1;
        int i4 = i3 + 1;
        int i5 = ((bArrM2630[iM8250] & 255) << 24) | ((bArrM2630[i] & 255) << 16) | ((bArrM2630[i2] & 255) << 8) | (bArrM2630[i3] & 255);
        this.f1300oV = C0456zb.m10439(this) - 4;
        if (i4 != iM9759) {
            c0425pdM7758.f1333eh = i4;
            return i5;
        }
        this.f1301vh = m7792(c0425pdM7758);
        C0461zs.m11552(c0425pdM7758);
        return i5;
    }

    @Override
    public int mo1373fF() {
        return C0449ye.m9276(C0448yd.m8872(this));
    }

    @Override
    public short mo1374fG() {
        if (C0456zb.m10439(this) < 2) {
            throw new IllegalStateException(abc.m1925(C0458ze.m10777(C0460zg.m11407(new StringBuilder(), C0460zg.m11261()), C0456zb.m10439(this))));
        }
        C0425pd c0425pdM7758 = m7758(this);
        int iM8250 = C0445ya.m8250(c0425pdM7758);
        int iM9759 = C0452yh.m9759(c0425pdM7758);
        if (iM9759 - iM8250 < 2) {
            return (short) (((C0460zg.m11394(this) & 255) << 8) | (C0460zg.m11394(this) & 255));
        }
        byte[] bArrM2630 = abf.m2630(c0425pdM7758);
        int i = iM8250 + 1;
        byte b = bArrM2630[iM8250];
        int i2 = i + 1;
        byte b2 = bArrM2630[i];
        this.f1300oV = C0456zb.m10439(this) - 2;
        if (i2 == iM9759) {
            this.f1301vh = m7792(c0425pdM7758);
            C0461zs.m11552(c0425pdM7758);
        } else {
            c0425pdM7758.f1333eh = i2;
        }
        return (short) (((b & 255) << 8) | (b2 & 255));
    }

    @Override
    public short mo1375fH() {
        return abc.m1890(C0457zc.m10536(this));
    }

    public String m1376fI() {
        try {
            return C0459zf.m11210(this, C0456zb.m10439(this), C0457zc.m10665());
        } catch (EOFException e) {
            throw new AssertionError(e);
        }
    }

    @Override
    public String mo1377fJ() {
        return C0452yh.m9584(this, Long.MAX_VALUE);
    }

    public final long m1378fK() {
        return C0456zb.m10439(this);
    }

    public final C0412or m1379fL() {
        if (C0456zb.m10439(this) > 2147483647L) {
            throw new IllegalArgumentException(abc.m1925(C0458ze.m10777(C0460zg.m11407(new StringBuilder(), C0456zb.m10465()), C0456zb.m10439(this))));
        }
        return m7790(this, (int) C0456zb.m10439(this));
    }

    @Override
    public void flush() {
    }

    @Override
    public C0409oo mo1380fu() {
        return this;
    }

    public final void m1381fv() {
        try {
            adds.m2735(this, C0456zb.m10439(this));
        } catch (EOFException e) {
            throw new AssertionError(e);
        }
    }

    public C0409oo m1382fw() {
        C0409oo c0409oo = new C0409oo();
        if (C0456zb.m10439(this) != 0) {
            c0409oo.f1301vh = m7761(m7758(this));
            C0425pd c0425pdM7758 = m7758(c0409oo);
            C0425pd c0425pdM7759 = m7758(c0409oo);
            C0425pd c0425pdM77510 = m7758(c0409oo);
            c0425pdM7759.f1337vK = c0425pdM77510;
            c0425pdM7758.f1335vI = c0425pdM77510;
            for (C0425pd c0425pdM7765 = m7765(m7758(this)); c0425pdM7765 != m7758(this); c0425pdM7765 = m7765(c0425pdM7765)) {
                m7778(m7760(m7758(c0409oo)), m7761(c0425pdM7765));
            }
            c0409oo.f1300oV = C0456zb.m10439(this);
        }
        return c0409oo;
    }

    public final long m1383fx() {
        long jM10439 = C0456zb.m10439(this);
        if (jM10439 == 0) {
            return 0L;
        }
        C0425pd c0425pdM7760 = m7760(m7758(this));
        return (C0452yh.m9759(c0425pdM7760) >= 8192 || !abf.m2548(c0425pdM7760)) ? jM10439 : jM10439 - ((long) (C0452yh.m9759(c0425pdM7760) - C0445ya.m8250(c0425pdM7760)));
    }

    public C0409oo m1384fy() {
        return this;
    }

    @Override
    public InterfaceC0410op mo1385fz() {
        return C0448yd.m8864(this);
    }

    public int hashCode() {
        C0425pd c0425pdM7758 = m7758(this);
        if (c0425pdM7758 == null) {
            return 0;
        }
        int i = 1;
        C0425pd c0425pdM7765 = c0425pdM7758;
        while (true) {
            int iM9759 = C0452yh.m9759(c0425pdM7765);
            int i2 = i;
            for (int iM8250 = C0445ya.m8250(c0425pdM7765); iM8250 < iM9759; iM8250++) {
                i2 = (i2 * 31) + abf.m2630(c0425pdM7765)[iM8250];
            }
            c0425pdM7765 = m7765(c0425pdM7765);
            if (c0425pdM7765 == m7758(this)) {
                return i2;
            }
            i = i2;
        }
    }

    public final byte m1386i(long j) {
        long j2 = j;
        C0445ya.m8392(C0456zb.m10439(this), j2, 1L);
        if (C0456zb.m10439(this) - j2 > j2) {
            C0425pd c0425pdM7758 = m7758(this);
            while (true) {
                int iM9759 = C0452yh.m9759(c0425pdM7758) - C0445ya.m8250(c0425pdM7758);
                if (j2 < iM9759) {
                    return abf.m2630(c0425pdM7758)[C0445ya.m8250(c0425pdM7758) + ((int) j2)];
                }
                j2 -= (long) iM9759;
                c0425pdM7758 = m7765(c0425pdM7758);
            }
        } else {
            long jM10439 = j2 - C0456zb.m10439(this);
            C0425pd c0425pdM7760 = m7760(m7758(this));
            while (true) {
                jM10439 += (long) (C0452yh.m9759(c0425pdM7760) - C0445ya.m8250(c0425pdM7760));
                if (jM10439 >= 0) {
                    return abf.m2630(c0425pdM7760)[C0445ya.m8250(c0425pdM7760) + ((int) jM10439)];
                }
                c0425pdM7760 = m7760(c0425pdM7760);
            }
        }
    }

    @Override
    public boolean isOpen() {
        return true;
    }

    @Override
    public byte[] mo1387j(long j) {
        C0445ya.m8392(C0456zb.m10439(this), 0L, j);
        if (j > 2147483647L) {
            throw new IllegalArgumentException(abc.m1925(C0458ze.m10777(C0460zg.m11407(new StringBuilder(), C0452yh.m9613()), j)));
        }
        byte[] bArr = new byte[(int) j];
        C0447yc.m8843(this, bArr);
        return bArr;
    }

    @Override
    public C0412or mo1388k(long j) {
        return new C0412or(C0458ze.m10884(this, j));
    }

    public String m1389l(long j) {
        return C0459zf.m11210(this, j, C0457zc.m10665());
    }

    String m1390m(long j) {
        if (j <= 0 || C0461zs.m11475(this, j - 1) != 13) {
            String strM8498 = C0446yb.m8498(this, j);
            adds.m2735(this, 1L);
            return strM8498;
        }
        String strM8499 = C0446yb.m8498(this, j - 1);
        adds.m2735(this, 2L);
        return strM8499;
    }

    public C0409oo m1391n(String str, int i, int i2) {
        int i3;
        int i4 = i;
        if (str == null) {
            throw new IllegalArgumentException(C0457zc.m10529());
        }
        if (i4 < 0) {
            throw new IllegalArgumentException(abc.m1925(adds.m2680(C0460zg.m11407(new StringBuilder(), C0455za.m10240()), i4)));
        }
        if (i2 < i4) {
            throw new IllegalArgumentException(abc.m1925(adds.m2680(C0460zg.m11407(adds.m2680(C0460zg.m11407(new StringBuilder(), C0457zc.m10592()), i2), gggy.m4302()), i4)));
        }
        if (i2 > gggy.m4397(str)) {
            throw new IllegalArgumentException(abc.m1925(adds.m2680(C0460zg.m11407(adds.m2680(C0460zg.m11407(new StringBuilder(), C0447yc.m8837()), i2), C0458ze.m10839()), gggy.m4397(str))));
        }
        while (i4 < i2) {
            char cM8419 = C0446yb.m8419(str, i4);
            if (cM8419 < 128) {
                C0425pd c0425pdM7791 = m7791(this, 1);
                byte[] bArrM2630 = abf.m2630(c0425pdM7791);
                int iM9759 = C0452yh.m9759(c0425pdM7791) - i4;
                int iM10520 = C0456zb.m10520(i2, 8192 - iM9759);
                bArrM2630[iM9759 + i4] = (byte) cM8419;
                i3 = i4 + 1;
                while (i3 < iM10520) {
                    char cM84110 = C0446yb.m8419(str, i3);
                    if (cM84110 >= 128) {
                        break;
                    }
                    bArrM2630[iM9759 + i3] = (byte) cM84110;
                    i3++;
                }
                int iM97510 = (i3 + iM9759) - C0452yh.m9759(c0425pdM7791);
                c0425pdM7791.f1332ea = C0452yh.m9759(c0425pdM7791) + iM97510;
                this.f1300oV = C0456zb.m10439(this) + ((long) iM97510);
            } else if (cM8419 < 2048) {
                C0447yc.m8844(this, (cM8419 >> 6) | 192);
                C0447yc.m8844(this, (cM8419 & '?') | 128);
                i3 = i4 + 1;
            } else if (cM8419 < 55296 || cM8419 > 57343) {
                C0447yc.m8844(this, (cM8419 >> '\f') | 224);
                C0447yc.m8844(this, ((cM8419 >> 6) & 63) | 128);
                C0447yc.m8844(this, (cM8419 & '?') | 128);
                i3 = i4 + 1;
            } else {
                char cM84111 = i4 + 1 < i2 ? C0446yb.m8419(str, i4 + 1) : (char) 0;
                if (cM8419 > 56319 || cM84111 < 56320 || cM84111 > 57343) {
                    C0447yc.m8844(this, 63);
                    i4++;
                } else {
                    int i5 = ((cM84111 & (-56321)) | ((cM8419 & (-55297)) << 10)) + 65536;
                    C0447yc.m8844(this, (i5 >> 18) | 240);
                    C0447yc.m8844(this, ((i5 >> 12) & 63) | 128);
                    C0447yc.m8844(this, ((i5 >> 6) & 63) | 128);
                    C0447yc.m8844(this, (i5 & 63) | 128);
                    i3 = i4 + 2;
                }
            }
            i4 = i3;
        }
        return this;
    }

    @Override
    public String mo1392n(long j) throws EOFException {
        if (j < 0) {
            throw new IllegalArgumentException(abc.m1925(C0458ze.m10777(C0460zg.m11407(new StringBuilder(), C0457zc.m10690()), j)));
        }
        long j2 = j != Long.MAX_VALUE ? j + 1 : Long.MAX_VALUE;
        long jM10877 = C0458ze.m10877(this, (byte) 10, 0L, j2);
        if (jM10877 != -1) {
            return C0452yh.m9692(this, jM10877);
        }
        if (j2 < C0455za.m10042(this) && C0461zs.m11475(this, j2 - 1) == 13 && C0461zs.m11475(this, j2) == 10) {
            return C0452yh.m9692(this, j2);
        }
        C0409oo c0409oo = new C0409oo();
        C0445ya.m8253(this, c0409oo, 0L, C0450yf.m9495(32L, C0455za.m10042(this)));
        throw new EOFException(abc.m1925(abe.m2346(C0460zg.m11407(C0460zg.m11407(C0458ze.m10777(C0460zg.m11407(new StringBuilder(), C0453yj.m9923()), C0450yf.m9495(C0455za.m10042(this), j)), C0446yb.m8517()), gggy.m4359(abf.m2525(c0409oo))), (char) 8230)));
    }

    @Override
    public void mo1393o(long j) throws EOFException {
        if (C0456zb.m10439(this) < j) {
            throw new EOFException();
        }
    }

    @Override
    public void mo1394p(long j) throws EOFException {
        long j2 = j;
        while (j2 > 0) {
            if (m7758(this) == null) {
                throw new EOFException();
            }
            int iM9495 = (int) C0450yf.m9495(j2, C0452yh.m9759(m7758(this)) - C0445ya.m8250(m7758(this)));
            this.f1300oV = C0456zb.m10439(this) - ((long) iM9495);
            j2 -= (long) iM9495;
            C0425pd c0425pdM7758 = m7758(this);
            c0425pdM7758.f1333eh = iM9495 + C0445ya.m8250(c0425pdM7758);
            if (C0445ya.m8250(m7758(this)) == C0452yh.m9759(m7758(this))) {
                C0425pd c0425pdM7759 = m7758(this);
                this.f1301vh = m7792(c0425pdM7759);
                C0461zs.m11552(c0425pdM7759);
            }
        }
    }

    public C0409oo m1395q(long j) {
        long j2;
        boolean z;
        int i;
        if (j == 0) {
            return C0447yc.m8844(this, 48);
        }
        if (j < 0) {
            j2 = -j;
            if (j2 < 0) {
                return C0457zc.m10684(this, abd.m2181());
            }
            z = true;
        } else {
            j2 = j;
            z = false;
        }
        if (j2 < 100000000) {
            if (j2 < 10000) {
                if (j2 < 100) {
                    i = j2 < 10 ? 1 : 2;
                } else {
                    i = j2 < 1000 ? 3 : 4;
                }
            } else if (j2 < 1000000) {
                i = j2 < 100000 ? 5 : 6;
            } else {
                i = j2 < 10000000 ? 7 : 8;
            }
        } else if (j2 < 1000000000000L) {
            if (j2 < 10000000000L) {
                i = j2 < 1000000000 ? 9 : 10;
            } else {
                i = j2 < 100000000000L ? 11 : 12;
            }
        } else if (j2 < 1000000000000000L) {
            if (j2 < 10000000000000L) {
                i = 13;
            } else {
                i = j2 < 100000000000000L ? 14 : 15;
            }
        } else if (j2 < 100000000000000000L) {
            i = j2 < 10000000000000000L ? 16 : 17;
        } else {
            i = j2 < 1000000000000000000L ? 18 : 19;
        }
        if (z) {
            i++;
        }
        C0425pd c0425pdM7791 = m7791(this, i);
        byte[] bArrM2630 = abf.m2630(c0425pdM7791);
        int iM9759 = C0452yh.m9759(c0425pdM7791) + i;
        while (j2 != 0) {
            iM9759--;
            bArrM2630[iM9759] = C0461zs.m11517()[(int) (j2 % 10)];
            j2 /= 10;
        }
        if (z) {
            bArrM2630[iM9759 - 1] = 45;
        }
        c0425pdM7791.f1332ea = C0452yh.m9759(c0425pdM7791) + i;
        this.f1300oV = ((long) i) + C0456zb.m10439(this);
        return this;
    }

    @Override
    public InterfaceC0410op mo1396r(long j) {
        return abf.m2584(this, j);
    }

    @Override
    public int read(ByteBuffer byteBuffer) {
        C0425pd c0425pdM7758 = m7758(this);
        if (c0425pdM7758 == null) {
            return -1;
        }
        int iM10520 = C0456zb.m10520(m7762(byteBuffer), C0452yh.m9759(c0425pdM7758) - C0445ya.m8250(c0425pdM7758));
        abc.m1790(byteBuffer, abf.m2630(c0425pdM7758), C0445ya.m8250(c0425pdM7758), iM10520);
        c0425pdM7758.f1333eh = C0445ya.m8250(c0425pdM7758) + iM10520;
        this.f1300oV = C0456zb.m10439(this) - ((long) iM10520);
        if (C0445ya.m8250(c0425pdM7758) != C0452yh.m9759(c0425pdM7758)) {
            return iM10520;
        }
        this.f1301vh = m7792(c0425pdM7758);
        C0461zs.m11552(c0425pdM7758);
        return iM10520;
    }

    public C0409oo m1397s(long j) {
        long j2 = j;
        if (j2 == 0) {
            return C0447yc.m8844(this, 48);
        }
        int iM7774 = (m7774(C0453yj.m9976(j2)) / 4) + 1;
        C0425pd c0425pdM7791 = m7791(this, iM7774);
        byte[] bArrM2630 = abf.m2630(c0425pdM7791);
        int iM9759 = C0452yh.m9759(c0425pdM7791);
        for (int iM97510 = (C0452yh.m9759(c0425pdM7791) + iM7774) - 1; iM97510 >= iM9759; iM97510--) {
            bArrM2630[iM97510] = C0461zs.m11517()[(int) (15 & j2)];
            j2 >>>= 4;
        }
        c0425pdM7791.f1332ea = C0452yh.m9759(c0425pdM7791) + iM7774;
        this.f1300oV = ((long) iM7774) + C0456zb.m10439(this);
        return this;
    }

    @Override
    public InterfaceC0410op mo1398t(long j) {
        return abf.m2564(this, j);
    }

    public String toString() {
        return C0459zf.m11083(abe.m2289(this));
    }

    @Override
    public int write(ByteBuffer byteBuffer) {
        if (byteBuffer == null) {
            throw new IllegalArgumentException(gggy.m4409());
        }
        int iM7762 = m7762(byteBuffer);
        int i = iM7762;
        while (i > 0) {
            C0425pd c0425pdM7791 = m7791(this, 1);
            int iM10520 = C0456zb.m10520(i, 8192 - C0452yh.m9759(c0425pdM7791));
            C0453yj.m9835(byteBuffer, abf.m2630(c0425pdM7791), C0452yh.m9759(c0425pdM7791), iM10520);
            i -= iM10520;
            c0425pdM7791.f1332ea = iM10520 + C0452yh.m9759(c0425pdM7791);
        }
        this.f1300oV = C0456zb.m10439(this) + ((long) iM7762);
        return iM7762;
    }
}
