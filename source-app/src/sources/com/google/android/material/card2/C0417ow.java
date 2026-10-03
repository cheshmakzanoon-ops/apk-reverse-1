package com.google.android.material.card2;

import java.io.EOFException;
import java.io.IOException;
import java.util.zip.DataFormatException;
import java.util.zip.Inflater;

public final class C0417ow implements InterfaceC0429ph {

    private boolean f1315oL;

    private int f1316vu;

    private final Inflater f1317vv;

    private final InterfaceC0411oq f1318vw;

    C0417ow(InterfaceC0411oq interfaceC0411oq, Inflater inflater) {
        if (interfaceC0411oq == null) {
            throw new IllegalArgumentException(gggy.m4409());
        }
        if (inflater == null) {
            throw new IllegalArgumentException(C0446yb.m8506());
        }
        this.f1318vw = interfaceC0411oq;
        this.f1317vv = inflater;
    }

    private void m1435gd() {
        if (C0456zb.m10373(this) == 0) {
            return;
        }
        int iM10373 = C0456zb.m10373(this) - C0447yc.m8658(C0448yd.m8857(this));
        this.f1316vu = C0456zb.m10373(this) - iM10373;
        C0461zs.m11605(C0447yc.m8817(this), iM10373);
    }

    public static Inflater m7891(Object obj) {
        if (C0458ze.m10932() > 0) {
            return ((C0417ow) obj).f1317vv;
        }
        return null;
    }

    public static int m7892(Object obj) {
        if (C0447yc.m8635() > 0) {
            return ((C0425pd) obj).f1332ea;
        }
        return 0;
    }

    public static void m7893(Object obj) {
        if (C0456zb.m10326() < 0) {
            ((InterfaceC0411oq) obj).close();
        }
    }

    public static int m7894(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return ((C0425pd) obj).f1333eh;
        }
        return 0;
    }

    public static int m7895() {
        if (C0457zc.m10735() < 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static long m7896(Object obj) {
        if (gggy.m4269() <= 0) {
            return ((C0409oo) obj).f1300oV;
        }
        return 0L;
    }

    public static C0425pd m7897(Object obj, int i) {
        if (C0446yb.m8415() < 0) {
            return ((C0409oo) obj).m1341D(i);
        }
        return null;
    }

    public static C0425pd m7898(Object obj, int i) {
        if (C0456zb.m10326() < 0) {
            return m7914(obj, i);
        }
        return null;
    }

    public static C0425pd m7899(Object obj) {
        if (abd.m2162() >= 0) {
            return ((C0409oo) obj).f1301vh;
        }
        return null;
    }

    public static byte[] m7900(Object obj) {
        if (C0458ze.m10932() >= 0) {
            return ((C0425pd) obj).f1334vH;
        }
        return null;
    }

    public static C0425pd m7901(Object obj) {
        if (C0460zg.m11287() > 0) {
            return m7912(obj);
        }
        return null;
    }

    public static void m7902(Object obj) {
        if (C0461zs.m11510() < 0) {
            ((C0417ow) obj).m1435gd();
        }
    }

    public static void m7903(Object obj) {
        if (gggy.m4269() < 0) {
            C0426pe.m1456b((C0425pd) obj);
        }
    }

    public static int m7904(Object obj) {
        if (abf.m2510() < 0) {
            return ((C0417ow) obj).f1316vu;
        }
        return 0;
    }

    public static boolean m7905(Object obj) {
        if (abe.m2308() <= 0) {
            return ((C0417ow) obj).f1315oL;
        }
        return false;
    }

    public static InterfaceC0411oq m7906(Object obj) {
        if (C0457zc.m10735() <= 0) {
            return ((C0417ow) obj).f1318vw;
        }
        return null;
    }

    public static C0425pd m7907(Object obj) {
        if (C0447yc.m8635() > 0) {
            return m7917(obj);
        }
        return null;
    }

    public static C0425pd m7908(Object obj) {
        if (C0448yd.m9079() <= 0) {
            return ((C0425pd) obj).m1454gg();
        }
        return null;
    }

    public static C0430pi m7909(Object obj) {
        if (adds.m2755() >= 0) {
            return ((InterfaceC0411oq) obj).mo967dz();
        }
        return null;
    }

    public static Inflater m7910(Object obj) {
        if (C0459zf.m11053() > 0) {
            return m7891((C0417ow) obj);
        }
        return null;
    }

    public static InterfaceC0411oq m7911(Object obj) {
        if (C0453yj.m9945() < 0) {
            return m7906((C0417ow) obj);
        }
        return null;
    }

    public static C0425pd m7912(Object obj) {
        if (C0457zc.m10718() <= 0) {
            return m7908((C0425pd) obj);
        }
        return null;
    }

    public static byte[] m7913(Object obj) {
        if (abf.m2500() >= 0) {
            return m7900((C0425pd) obj);
        }
        return null;
    }

    public static C0425pd m7914(Object obj, int i) {
        if (abe.m2321() <= 0) {
            return m7897((C0409oo) obj, i);
        }
        return null;
    }

    public static boolean m7915(Object obj) {
        if (C0453yj.m9996() <= 0) {
            return m7905((C0417ow) obj);
        }
        return false;
    }

    public static void m7916(Object obj) {
        if (C0456zb.m10484() < 0) {
            m7902((C0417ow) obj);
        }
    }

    public static C0425pd m7917(Object obj) {
        if (abf.m2500() > 0) {
            return m7899((C0409oo) obj);
        }
        return null;
    }

    public static int m7918(Object obj) {
        if (C0445ya.m8330() >= 0) {
            return m7904((C0417ow) obj);
        }
        return 0;
    }

    public static void m7919(Object obj) {
        if (C0453yj.m9996() < 0) {
            m7893((InterfaceC0411oq) obj);
        }
    }

    public static int m7920(Object obj) {
        if (abe.m2321() <= 0) {
            return m7894((C0425pd) obj);
        }
        return 0;
    }

    public static long m7921(Object obj) {
        if (m7895() > 0) {
            return m7896((C0409oo) obj);
        }
        return 0L;
    }

    public static int m7922(Object obj) {
        if (C0459zf.m11053() > 0) {
            return m7892((C0425pd) obj);
        }
        return 0;
    }

    public static void m7923(Object obj) {
        if (abd.m2166() <= 0) {
            m7903((C0425pd) obj);
        }
    }

    public static C0430pi m7924(Object obj) {
        if (C0460zg.m11293() >= 0) {
            return m7909((InterfaceC0411oq) obj);
        }
        return null;
    }

    @Override
    public long mo966a(C0409oo c0409oo, long j) throws IOException {
        boolean zM11236;
        if (j < 0) {
            throw new IllegalArgumentException(abc.m1925(C0458ze.m10777(C0460zg.m11407(new StringBuilder(), adds.m2831()), j)));
        }
        if (adds.m2813(this)) {
            throw new IllegalStateException(C0447yc.m8663());
        }
        if (j == 0) {
            return 0L;
        }
        do {
            zM11236 = C0460zg.m11236(this);
            try {
                C0425pd c0425pdM7898 = m7898(c0409oo, 1);
                int iM10417 = C0456zb.m10417(C0448yd.m8857(this), C0460zg.m11377(c0425pdM7898), C0458ze.m10876(c0425pdM7898), (int) C0450yf.m9495(j, 8192 - C0458ze.m10876(c0425pdM7898)));
                if (iM10417 > 0) {
                    c0425pdM7898.f1332ea = C0458ze.m10876(c0425pdM7898) + iM10417;
                    c0409oo.f1300oV = abc.m1959(c0409oo) + ((long) iM10417);
                    return iM10417;
                }
                if (C0455za.m10054(C0448yd.m8857(this)) || abf.m2639(C0448yd.m8857(this))) {
                    C0449ye.m9106(this);
                    if (C0452yh.m9801(c0425pdM7898) == C0458ze.m10876(c0425pdM7898)) {
                        c0409oo.f1301vh = m7901(c0425pdM7898);
                        abe.m2403(c0425pdM7898);
                    }
                    return -1L;
                }
            } catch (DataFormatException e) {
                throw new IOException(e);
            }
        } while (!zM11236);
        throw new EOFException(C0460zg.m11428());
    }

    @Override
    public void close() {
        if (adds.m2813(this)) {
            return;
        }
        C0449ye.m9297(C0448yd.m8857(this));
        this.f1315oL = true;
        abe.m2272(C0447yc.m8817(this));
    }

    @Override
    public C0430pi mo967dz() {
        return C0460zg.m11281(C0447yc.m8817(this));
    }

    public final boolean m1436ge() {
        if (!C0456zb.m10485(C0448yd.m8857(this))) {
            return false;
        }
        C0449ye.m9106(this);
        if (C0447yc.m8658(C0448yd.m8857(this)) != 0) {
            throw new IllegalStateException(abe.m2268());
        }
        if (C0459zf.m11102(C0447yc.m8817(this))) {
            return true;
        }
        C0425pd c0425pdM7907 = m7907(C0459zf.m11165(C0447yc.m8817(this)));
        this.f1316vu = C0458ze.m10876(c0425pdM7907) - C0452yh.m9801(c0425pdM7907);
        abd.m2159(C0448yd.m8857(this), C0460zg.m11377(c0425pdM7907), C0452yh.m9801(c0425pdM7907), C0456zb.m10373(this));
        return false;
    }
}
