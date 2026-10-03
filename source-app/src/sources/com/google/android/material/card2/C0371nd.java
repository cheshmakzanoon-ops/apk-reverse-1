package com.google.android.material.card2;

import java.io.IOException;
import java.util.logging.Logger;

final class C0371nd implements InterfaceC0429ph {

    byte f1186tg;

    int f1187th;

    int f1188ti;

    short f1189tj;

    private final InterfaceC0411oq f1190tk;

    int f1191tl;

    C0371nd(InterfaceC0411oq interfaceC0411oq) {
        this.f1190tk = interfaceC0411oq;
    }

    private void m1202eE() throws IOException {
        int iM7068 = m7068(this);
        int iM7082 = m7082(m7059(this));
        this.f1187th = iM7082;
        this.f1188ti = iM7082;
        byte bM8575 = (byte) (C0446yb.m8575(m7059(this)) & 255);
        this.f1186tg = (byte) (C0446yb.m8575(m7059(this)) & 255);
        if (C0450yf.m9421(m7061(), C0447yc.m8836())) {
            C0459zf.m10980(m7061(), m7079(true, m7068(this), m7077(this), bM8575, m7066(this)));
        }
        this.f1191tl = C0458ze.m10834(m7059(this)) & Integer.MAX_VALUE;
        if (bM8575 != 9) {
            throw m7062(gggy.m4480(), new Object[]{C0460zg.m11246(bM8575)});
        }
        if (m7068(this) != iM7068) {
            throw m7062(abc.m1818(), new Object[0]);
        }
    }

    public static InterfaceC0411oq m7059(Object obj) {
        if (abd.m2162() > 0) {
            return m7088(obj);
        }
        return null;
    }

    public static Logger m7060() {
        if (abf.m2510() < 0) {
            return C0370nc.f1181tb;
        }
        return null;
    }

    public static Logger m7061() {
        if (C0445ya.m8222() > 0) {
            return m7094();
        }
        return null;
    }

    public static IOException m7062(Object obj, Object obj2) {
        if (gggy.m4269() < 0) {
            return m7095(obj, obj2);
        }
        return null;
    }

    public static int m7063(Object obj) {
        if (abc.m1845() <= 0) {
            return ((C0371nd) obj).f1191tl;
        }
        return 0;
    }

    public static int m7064(Object obj) {
        if (abc.m1845() < 0) {
            return ((C0371nd) obj).f1188ti;
        }
        return 0;
    }

    public static short m7065(Object obj) {
        if (C0457zc.m10735() < 0) {
            return m7092(obj);
        }
        return (short) 0;
    }

    public static byte m7066(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return m7086(obj);
        }
        return (byte) 0;
    }

    public static C0430pi m7067(Object obj) {
        if (abc.m1845() <= 0) {
            return m7093(obj);
        }
        return null;
    }

    public static int m7068(Object obj) {
        if (abe.m2308() <= 0) {
            return m7087(obj);
        }
        return 0;
    }

    public static byte m7069(Object obj) {
        if (abd.m2162() >= 0) {
            return ((C0371nd) obj).f1186tg;
        }
        return (byte) 0;
    }

    public static long m7070(Object obj, Object obj2, long j) {
        if (abc.m1845() <= 0) {
            return ((InterfaceC0411oq) obj).mo966a((C0409oo) obj2, j);
        }
        return 0L;
    }

    public static IOException m7071(Object obj, Object obj2) {
        if (C0447yc.m8635() > 0) {
            return C0351mk.m1144d((String) obj, (Object[]) obj2);
        }
        return null;
    }

    public static int m7072(Object obj) {
        if (abc.m1845() < 0) {
            return ((C0371nd) obj).f1187th;
        }
        return 0;
    }

    public static short m7073(Object obj) {
        if (C0449ye.m9220() < 0) {
            return ((C0371nd) obj).f1189tj;
        }
        return (short) 0;
    }

    public static void m7074(Object obj) throws IOException {
        if (C0449ye.m9220() <= 0) {
            m7085(obj);
        }
    }

    public static int m7075(Object obj) {
        if (C0453yj.m10013() > 0) {
            return C0370nc.m1188a((InterfaceC0411oq) obj);
        }
        return 0;
    }

    public static void m7076(Object obj) throws IOException {
        if (C0459zf.m11062() > 0) {
            ((C0371nd) obj).m1202eE();
        }
    }

    public static int m7077(Object obj) {
        if (C0461zs.m11510() < 0) {
            return m7091(obj);
        }
        return 0;
    }

    public static C0430pi m7078(Object obj) {
        if (adds.m2755() >= 0) {
            return ((InterfaceC0411oq) obj).mo967dz();
        }
        return null;
    }

    public static String m7079(boolean z, int i, int i2, byte b, byte b2) {
        if (C0449ye.m9220() <= 0) {
            return m7096(z, i, i2, b, b2);
        }
        return null;
    }

    public static int m7080(Object obj) {
        if (abf.m2510() < 0) {
            return m7090(obj);
        }
        return 0;
    }

    public static String m7081(boolean z, int i, int i2, byte b, byte b2) {
        if (abf.m2510() <= 0) {
            return C0351mk.m1142a(z, i, i2, b, b2);
        }
        return null;
    }

    public static int m7082(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return m7089(obj);
        }
        return 0;
    }

    public static InterfaceC0411oq m7083(Object obj) {
        if (adds.m2755() >= 0) {
            return ((C0371nd) obj).f1190tk;
        }
        return null;
    }

    public static long m7084(Object obj, Object obj2, long j) {
        if (C0448yd.m9079() <= 0) {
            return m7097(obj, obj2, j);
        }
        return 0L;
    }

    public static void m7085(Object obj) throws IOException {
        if (C0456zb.m10484() < 0) {
            m7076((C0371nd) obj);
        }
    }

    public static byte m7086(Object obj) {
        if (C0453yj.m9966() > 0) {
            return m7069((C0371nd) obj);
        }
        return (byte) 0;
    }

    public static int m7087(Object obj) {
        if (abd.m2166() <= 0) {
            return m7063((C0371nd) obj);
        }
        return 0;
    }

    public static InterfaceC0411oq m7088(Object obj) {
        if (gggy.m4365() >= 0) {
            return m7083((C0371nd) obj);
        }
        return null;
    }

    public static int m7089(Object obj) {
        if (C0448yd.m9074() < 0) {
            return m7075((InterfaceC0411oq) obj);
        }
        return 0;
    }

    public static int m7090(Object obj) {
        if (C0453yj.m9966() >= 0) {
            return m7072((C0371nd) obj);
        }
        return 0;
    }

    public static int m7091(Object obj) {
        if (C0460zg.m11293() >= 0) {
            return m7064((C0371nd) obj);
        }
        return 0;
    }

    public static short m7092(Object obj) {
        if (C0448yd.m9074() <= 0) {
            return m7073((C0371nd) obj);
        }
        return (short) 0;
    }

    public static C0430pi m7093(Object obj) {
        if (C0457zc.m10555() >= 0) {
            return m7078((InterfaceC0411oq) obj);
        }
        return null;
    }

    public static Logger m7094() {
        if (C0456zb.m10484() <= 0) {
            return m7060();
        }
        return null;
    }

    public static IOException m7095(Object obj, Object obj2) {
        if (C0460zg.m11293() >= 0) {
            return m7071((String) obj, (Object[]) obj2);
        }
        return null;
    }

    public static String m7096(boolean z, int i, int i2, byte b, byte b2) {
        if (C0453yj.m9945() <= 0) {
            return m7081(z, i, i2, b, b2);
        }
        return null;
    }

    public static long m7097(Object obj, Object obj2, long j) {
        if (C0460zg.m11293() > 0) {
            return m7070((InterfaceC0411oq) obj, (C0409oo) obj2, j);
        }
        return 0L;
    }

    @Override
    public long mo966a(C0409oo c0409oo, long j) throws IOException {
        while (m7080(this) == 0) {
            C0461zs.m11605(m7059(this), m7065(this));
            this.f1189tj = (short) 0;
            if ((m7066(this) & 4) != 0) {
                return -1L;
            }
            m7074(this);
        }
        long jM7084 = m7084(m7059(this), c0409oo, C0450yf.m9495(j, m7080(this)));
        if (jM7084 == -1) {
            return -1L;
        }
        this.f1187th = (int) (((long) m7080(this)) - jM7084);
        return jM7084;
    }

    @Override
    public void close() {
    }

    @Override
    public C0430pi mo967dz() {
        return m7067(m7059(this));
    }
}
