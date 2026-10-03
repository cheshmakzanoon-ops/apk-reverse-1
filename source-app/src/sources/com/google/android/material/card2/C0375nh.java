package com.google.android.material.card2;

import java.io.EOFException;
import java.io.IOException;
import java.io.InterruptedIOException;

final class C0375nh implements InterfaceC0429ph {

    static final boolean f1210tB;

    boolean f1211oL;

    private final long f1212tC;

    final C0373nf f1215tF;

    boolean f1216ty;

    private final C0409oo f1214tE = new C0409oo();

    private final C0409oo f1213tD = new C0409oo();

    static {
        f1210tB = !C0460zg.m11342(C0373nf.class);
    }

    C0375nh(C0373nf c0373nf, long j) {
        this.f1215tF = c0373nf;
        this.f1212tC = j;
    }

    private void m1222dH() throws IOException {
        if (m7230(this)) {
            throw new IOException(C0446yb.m8487());
        }
        if (m7212(m7233(this)) != null) {
            throw new C0384nq(m7212(m7233(this)));
        }
    }

    private void m1223eQ() {
        m7224(m7213(m7233(this)));
        while (C0455za.m10042(m7246(this)) == 0 && !m7239(this) && !m7230(this) && m7212(m7233(this)) == null) {
            try {
                m7219(m7233(this));
            } catch (Throwable th) {
                m7221(m7213(m7233(this)));
                throw th;
            }
        }
        m7221(m7213(m7233(this)));
    }

    public static C0409oo m7211(Object obj) {
        if (C0457zc.m10735() < 0) {
            return ((C0375nh) obj).f1213tD;
        }
        return null;
    }

    public static EnumC0346mf m7212(Object obj) {
        if (adds.m2755() > 0) {
            return m7276(obj);
        }
        return null;
    }

    public static C0376ni m7213(Object obj) {
        if (gggy.m4269() <= 0) {
            return m7263(obj);
        }
        return null;
    }

    public static void m7214(Object obj) {
        if (C0451yg.m9580() >= 0) {
            m7272(obj);
        }
    }

    public static C0409oo m7215(Object obj) {
        if (C0445ya.m8222() > 0) {
            return m7273(obj);
        }
        return null;
    }

    public static long m7216(Object obj) {
        if (C0450yf.m9352() < 0) {
            return ((C0375nh) obj).f1212tC;
        }
        return 0L;
    }

    public static void m7217(Object obj) {
        if (C0453yj.m10013() > 0) {
            ((C0376ni) obj).m1226eR();
        }
    }

    public static void m7218(Object obj) {
        if (C0446yb.m8415() <= 0) {
            ((C0375nh) obj).m1223eQ();
        }
    }

    public static void m7219(Object obj) throws InterruptedIOException {
        if (C0456zb.m10326() < 0) {
            m7266(obj);
        }
    }

    public static C0354mn m7220(Object obj) {
        if (C0446yb.m8415() < 0) {
            return ((C0373nf) obj).f1195tn;
        }
        return null;
    }

    public static void m7221(Object obj) {
        if (C0451yg.m9580() >= 0) {
            m7267(obj);
        }
    }

    public static long m7222(Object obj, Object obj2, long j) {
        if (adds.m2755() >= 0) {
            return m7268(obj, obj2, j);
        }
        return 0L;
    }

    public static long m7223(Object obj) {
        if (adds.m2755() > 0) {
            return ((C0354mn) obj).f1138sr;
        }
        return 0L;
    }

    public static void m7224(Object obj) {
        if (C0460zg.m11287() >= 0) {
            m7280(obj);
        }
    }

    public static void m7225(Object obj) throws IOException {
        if (abe.m2308() < 0) {
            ((C0375nh) obj).m1222dH();
        }
    }

    public static C0354mn m7226(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return m7277(obj);
        }
        return null;
    }

    public static EnumC0346mf m7227(Object obj) {
        if (gggy.m4269() <= 0) {
            return ((C0373nf) obj).f1196to;
        }
        return null;
    }

    public static void m7228(Object obj) throws InterruptedIOException {
        if (C0456zb.m10326() < 0) {
            ((C0373nf) obj).m1218eO();
        }
    }

    public static boolean m7229(Object obj) {
        if (abd.m2162() > 0) {
            return ((C0375nh) obj).f1216ty;
        }
        return false;
    }

    public static boolean m7230(Object obj) {
        if (abd.m2162() > 0) {
            return m7262(obj);
        }
        return false;
    }

    public static int m7231(Object obj) {
        if (abd.m2162() >= 0) {
            return m7271(obj);
        }
        return 0;
    }

    public static long m7232(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return m7270(obj);
        }
        return 0L;
    }

    public static C0373nf m7233(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return m7274(obj);
        }
        return null;
    }

    public static long m7234(Object obj) {
        if (C0452yh.m9798() >= 0) {
            return m7264(obj);
        }
        return 0L;
    }

    public static void m7235(Object obj, int i, long j) {
        if (C0451yg.m9580() >= 0) {
            ((C0354mn) obj).m1150a(i, j);
        }
    }

    public static int m7236() {
        if (C0453yj.m10013() > 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static void m7237(Object obj) {
        if (adds.m2755() >= 0) {
            m7275(obj);
        }
    }

    public static int m7238(Object obj) {
        if (C0448yd.m9079() < 0) {
            return ((C0373nf) obj).f1198tq;
        }
        return 0;
    }

    public static boolean m7239(Object obj) {
        if (C0445ya.m8222() > 0) {
            return m7260(obj);
        }
        return false;
    }

    public static void m7240(Object obj) throws IOException {
        if (adds.m2755() >= 0) {
            m7278(obj);
        }
    }

    public static long m7241(Object obj, Object obj2, long j) {
        if (abc.m1845() < 0) {
            return ((InterfaceC0411oq) obj).mo966a((C0409oo) obj2, j);
        }
        return 0L;
    }

    public static void m7242(Object obj, int i, long j) {
        if (C0448yd.m9079() < 0) {
            m7265(obj, i, j);
        }
    }

    public static C0383np m7243(Object obj) {
        if (adds.m2755() > 0) {
            return ((C0354mn) obj).f1128sh;
        }
        return null;
    }

    public static void m7244(Object obj) {
        if (C0447yc.m8635() > 0) {
            ((C0376ni) obj).m1335fs();
        }
    }

    public static long m7245(Object obj) {
        if (C0459zf.m11062() >= 0) {
            return ((C0373nf) obj).f1194sr;
        }
        return 0L;
    }

    public static C0409oo m7246(Object obj) {
        if (C0446yb.m8415() <= 0) {
            return m7279(obj);
        }
        return null;
    }

    public static C0409oo m7247(Object obj) {
        if (abe.m2308() < 0) {
            return ((C0375nh) obj).f1214tE;
        }
        return null;
    }

    public static void m7248(Object obj) {
        if (C0460zg.m11287() >= 0) {
            ((C0373nf) obj).m1209eF();
        }
    }

    public static int m7249(Object obj) {
        if (abf.m2510() <= 0) {
            return m7261(obj);
        }
        return 0;
    }

    public static int m7250(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return ((C0383np) obj).m1263fb();
        }
        return 0;
    }

    public static long m7251(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return m7258(obj);
        }
        return 0L;
    }

    public static C0373nf m7252(Object obj) {
        if (C0453yj.m10013() > 0) {
            return ((C0375nh) obj).f1215tF;
        }
        return null;
    }

    public static boolean m7253() {
        if (C0451yg.m9580() > 0) {
            return m7259();
        }
        return false;
    }

    public static C0376ni m7254(Object obj) {
        if (C0457zc.m10735() <= 0) {
            return ((C0373nf) obj).f1199tr;
        }
        return null;
    }

    public static C0383np m7255(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return m7269(obj);
        }
        return null;
    }

    public static boolean m7256(Object obj) {
        if (gggy.m4269() < 0) {
            return ((C0375nh) obj).f1211oL;
        }
        return false;
    }

    public static boolean m7257() {
        if (C0458ze.m10932() > 0) {
            return f1210tB;
        }
        return false;
    }

    public static long m7258(Object obj) {
        if (C0453yj.m9945() < 0) {
            return m7245((C0373nf) obj);
        }
        return 0L;
    }

    public static boolean m7259() {
        if (C0460zg.m11293() >= 0) {
            return m7257();
        }
        return false;
    }

    public static boolean m7260(Object obj) {
        if (C0448yd.m9074() < 0) {
            return m7229((C0375nh) obj);
        }
        return false;
    }

    public static int m7261(Object obj) {
        if (C0459zf.m11053() > 0) {
            return m7238((C0373nf) obj);
        }
        return 0;
    }

    public static boolean m7262(Object obj) {
        if (m7236() > 0) {
            return m7256((C0375nh) obj);
        }
        return false;
    }

    public static C0376ni m7263(Object obj) {
        if (C0453yj.m9966() > 0) {
            return m7254((C0373nf) obj);
        }
        return null;
    }

    public static long m7264(Object obj) {
        if (C0453yj.m9996() <= 0) {
            return m7216((C0375nh) obj);
        }
        return 0L;
    }

    public static void m7265(Object obj, int i, long j) {
        if (C0448yd.m9074() <= 0) {
            m7235((C0354mn) obj, i, j);
        }
    }

    public static void m7266(Object obj) throws InterruptedIOException {
        if (C0460zg.m11293() > 0) {
            m7228((C0373nf) obj);
        }
    }

    public static void m7267(Object obj) {
        if (gggy.m4365() >= 0) {
            m7217((C0376ni) obj);
        }
    }

    public static long m7268(Object obj, Object obj2, long j) {
        if (C0459zf.m11053() >= 0) {
            return m7241((InterfaceC0411oq) obj, (C0409oo) obj2, j);
        }
        return 0L;
    }

    public static C0383np m7269(Object obj) {
        if (C0458ze.m10926() < 0) {
            return m7243((C0354mn) obj);
        }
        return null;
    }

    public static long m7270(Object obj) {
        if (C0453yj.m9996() <= 0) {
            return m7223((C0354mn) obj);
        }
        return 0L;
    }

    public static int m7271(Object obj) {
        if (C0453yj.m9996() <= 0) {
            return m7250((C0383np) obj);
        }
        return 0;
    }

    public static void m7272(Object obj) {
        if (abe.m2321() < 0) {
            m7218((C0375nh) obj);
        }
    }

    public static C0409oo m7273(Object obj) {
        if (C0459zf.m11053() > 0) {
            return m7247((C0375nh) obj);
        }
        return null;
    }

    public static C0373nf m7274(Object obj) {
        if (m7236() >= 0) {
            return m7252((C0375nh) obj);
        }
        return null;
    }

    public static void m7275(Object obj) {
        if (C0453yj.m10032() > 0) {
            m7248((C0373nf) obj);
        }
    }

    public static EnumC0346mf m7276(Object obj) {
        if (C0448yd.m9015() <= 0) {
            return m7227((C0373nf) obj);
        }
        return null;
    }

    public static C0354mn m7277(Object obj) {
        if (abd.m2021() >= 0) {
            return m7220((C0373nf) obj);
        }
        return null;
    }

    public static void m7278(Object obj) throws IOException {
        if (abd.m2166() <= 0) {
            m7225((C0375nh) obj);
        }
    }

    public static C0409oo m7279(Object obj) {
        if (C0460zg.m11293() > 0) {
            return m7211((C0375nh) obj);
        }
        return null;
    }

    public static void m7280(Object obj) {
        if (gggy.m4365() >= 0) {
            m7244((C0376ni) obj);
        }
    }

    @Override
    public long mo966a(C0409oo c0409oo, long j) {
        long jM11087;
        if (j < 0) {
            throw new IllegalArgumentException(abc.m1925(C0458ze.m10777(C0460zg.m11407(new StringBuilder(), adds.m2831()), j)));
        }
        synchronized (m7233(this)) {
            m7214(this);
            m7240(this);
            if (C0455za.m10042(m7246(this)) == 0) {
                jM11087 = -1;
            } else {
                jM11087 = C0459zf.m11087(m7246(this), c0409oo, C0450yf.m9495(j, C0455za.m10042(m7246(this))));
                C0373nf c0373nfM7233 = m7233(this);
                c0373nfM7233.f1194sr = m7251(c0373nfM7233) + jM11087;
                if (m7251(m7233(this)) >= m7231(m7255(m7226(m7233(this)))) / 2) {
                    m7242(m7226(m7233(this)), m7249(m7233(this)), m7251(m7233(this)));
                    m7233(this).f1194sr = 0L;
                }
                synchronized (m7226(m7233(this))) {
                    C0354mn c0354mnM7226 = m7226(m7233(this));
                    c0354mnM7226.f1138sr = m7232(c0354mnM7226) + jM11087;
                    if (m7232(m7226(m7233(this))) >= m7231(m7255(m7226(m7233(this)))) / 2) {
                        m7242(m7226(m7233(this)), 0, m7232(m7226(m7233(this))));
                        m7226(m7233(this)).f1138sr = 0L;
                    }
                }
            }
        }
        return jM11087;
    }

    void m1224a(InterfaceC0411oq interfaceC0411oq, long j) {
        boolean zM7239;
        boolean z;
        long j2 = j;
        if (!m7253() && C0455za.m10268(m7233(this))) {
            throw new AssertionError();
        }
        while (j2 > 0) {
            synchronized (m7233(this)) {
                zM7239 = m7239(this);
                z = C0455za.m10042(m7246(this)) + j2 > m7234(this);
            }
            if (z) {
                C0461zs.m11605(interfaceC0411oq, j2);
                C0455za.m10191(m7233(this), gggy.m4462());
                return;
            }
            if (zM7239) {
                C0461zs.m11605(interfaceC0411oq, j2);
                return;
            }
            long jM7222 = m7222(interfaceC0411oq, m7215(this), j2);
            if (jM7222 == -1) {
                throw new EOFException();
            }
            j2 -= jM7222;
            synchronized (m7233(this)) {
                boolean z2 = C0455za.m10042(m7246(this)) == 0;
                abf.m2581(m7246(this), m7215(this));
                if (z2) {
                    abe.m2339(m7233(this));
                }
            }
        }
    }

    @Override
    public void close() {
        synchronized (m7233(this)) {
            this.f1211oL = true;
            C0461zs.m11454(m7246(this));
            abe.m2339(m7233(this));
        }
        m7237(m7233(this));
    }

    @Override
    public C0430pi mo967dz() {
        return m7213(m7233(this));
    }
}
