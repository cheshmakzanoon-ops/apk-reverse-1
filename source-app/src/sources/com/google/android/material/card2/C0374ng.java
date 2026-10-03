package com.google.android.material.card2;

import java.io.IOException;
import java.io.InterruptedIOException;

final class C0374ng implements InterfaceC0428pg {

    static final boolean f1205tx;

    boolean f1206oL;

    final C0373nf f1207tA;

    boolean f1208ty;

    private final C0409oo f1209tz = new C0409oo();

    static {
        f1205tx = !C0460zg.m11342(C0373nf.class);
    }

    C0374ng(C0373nf c0373nf) {
        this.f1207tA = c0373nf;
    }

    private void m1221o(boolean z) {
        long jM9495;
        synchronized (m7192(this)) {
            m7171(m7160(m7192(this)));
            while (m7177(m7192(this)) <= 0 && !m7188(this) && !m7165(this) && m7176(m7192(this)) == null) {
                try {
                    m7162(m7192(this));
                } catch (Throwable th) {
                    m7193(m7160(m7192(this)));
                    throw th;
                }
            }
            m7193(m7160(m7192(this)));
            m7164(m7192(this));
            jM9495 = C0450yf.m9495(m7177(m7192(this)), C0455za.m10042(m7169(this)));
            C0373nf c0373nfM7192 = m7192(this);
            c0373nfM7192.f1193rZ = m7177(c0373nfM7192) - jM9495;
        }
        m7171(m7160(m7192(this)));
        try {
            C0452yh.m9643(m7170(m7192(this)), m7186(m7192(this)), z && jM9495 == C0455za.m10042(m7169(this)), m7169(this), jM9495);
        } finally {
            m7193(m7160(m7192(this)));
        }
    }

    public static boolean m7159(Object obj) {
        if (C0453yj.m10013() >= 0) {
            return ((C0374ng) obj).f1208ty;
        }
        return false;
    }

    public static C0376ni m7160(Object obj) {
        if (C0458ze.m10932() > 0) {
            return m7199(obj);
        }
        return null;
    }

    public static C0373nf m7161(Object obj) {
        if (abc.m1845() < 0) {
            return ((C0374ng) obj).f1207tA;
        }
        return null;
    }

    public static void m7162(Object obj) throws InterruptedIOException {
        if (abd.m2162() > 0) {
            m7197(obj);
        }
    }

    public static C0409oo m7163(Object obj) {
        if (C0453yj.m10013() >= 0) {
            return ((C0374ng) obj).f1209tz;
        }
        return null;
    }

    public static void m7164(Object obj) throws IOException {
        if (C0445ya.m8222() >= 0) {
            m7205(obj);
        }
    }

    public static boolean m7165(Object obj) {
        if (C0458ze.m10932() >= 0) {
            return m7196(obj);
        }
        return false;
    }

    public static void m7166(Object obj) {
        if (abe.m2308() < 0) {
            ((C0376ni) obj).m1226eR();
        }
    }

    public static void m7167(Object obj, boolean z) {
        if (C0451yg.m9580() >= 0) {
            m7202(obj, z);
        }
    }

    public static int m7168(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return ((C0373nf) obj).f1198tq;
        }
        return 0;
    }

    public static C0409oo m7169(Object obj) {
        if (C0457zc.m10735() < 0) {
            return m7201(obj);
        }
        return null;
    }

    public static C0354mn m7170(Object obj) {
        if (abc.m1845() < 0) {
            return m7206(obj);
        }
        return null;
    }

    public static void m7171(Object obj) {
        if (C0452yh.m9798() > 0) {
            m7195(obj);
        }
    }

    public static boolean m7172() {
        if (C0453yj.m10013() >= 0) {
            return f1205tx;
        }
        return false;
    }

    public static void m7173(Object obj) throws InterruptedIOException {
        if (C0447yc.m8635() > 0) {
            ((C0373nf) obj).m1218eO();
        }
    }

    public static C0354mn m7174(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return ((C0373nf) obj).f1195tn;
        }
        return null;
    }

    public static C0376ni m7175(Object obj) {
        if (adds.m2755() > 0) {
            return ((C0373nf) obj).f1204tw;
        }
        return null;
    }

    public static EnumC0346mf m7176(Object obj) {
        if (C0459zf.m11062() >= 0) {
            return m7208(obj);
        }
        return null;
    }

    public static long m7177(Object obj) {
        if (C0450yf.m9352() < 0) {
            return m7207(obj);
        }
        return 0L;
    }

    public static boolean m7178(Object obj) {
        if (adds.m2755() > 0) {
            return ((C0374ng) obj).f1206oL;
        }
        return false;
    }

    public static void m7179(Object obj) {
        if (C0449ye.m9220() <= 0) {
            m7194(obj);
        }
    }

    public static int m7180() {
        if (abd.m2162() > 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static boolean m7181() {
        if (C0456zb.m10326() < 0) {
            return m7209();
        }
        return false;
    }

    public static void m7182(Object obj) throws IOException {
        if (C0450yf.m9352() <= 0) {
            ((C0373nf) obj).m1210eG();
        }
    }

    public static C0374ng m7183(Object obj) {
        if (adds.m2755() >= 0) {
            return m7200(obj);
        }
        return null;
    }

    public static void m7184(Object obj, boolean z) {
        if (adds.m2755() > 0) {
            ((C0374ng) obj).m1221o(z);
        }
    }

    public static long m7185(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return ((C0373nf) obj).f1193rZ;
        }
        return 0L;
    }

    public static int m7186(Object obj) {
        if (C0461zs.m11510() < 0) {
            return m7198(obj);
        }
        return 0;
    }

    public static C0374ng m7187(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return ((C0373nf) obj).f1202tu;
        }
        return null;
    }

    public static boolean m7188(Object obj) {
        if (C0453yj.m10013() >= 0) {
            return m7203(obj);
        }
        return false;
    }

    public static void m7189(Object obj) {
        if (abe.m2308() <= 0) {
            ((C0376ni) obj).m1335fs();
        }
    }

    public static void m7190(Object obj) {
        if (abc.m1845() <= 0) {
            ((C0373nf) obj).m1209eF();
        }
    }

    public static EnumC0346mf m7191(Object obj) {
        if (C0452yh.m9798() > 0) {
            return ((C0373nf) obj).f1196to;
        }
        return null;
    }

    public static C0373nf m7192(Object obj) {
        if (gggy.m4269() < 0) {
            return m7210(obj);
        }
        return null;
    }

    public static void m7193(Object obj) {
        if (adds.m2755() > 0) {
            m7204(obj);
        }
    }

    public static void m7194(Object obj) {
        if (C0459zf.m11053() >= 0) {
            m7190((C0373nf) obj);
        }
    }

    public static void m7195(Object obj) {
        if (C0453yj.m9996() < 0) {
            m7189((C0376ni) obj);
        }
    }

    public static boolean m7196(Object obj) {
        if (C0453yj.m10032() >= 0) {
            return m7178((C0374ng) obj);
        }
        return false;
    }

    public static void m7197(Object obj) throws InterruptedIOException {
        if (m7180() > 0) {
            m7173((C0373nf) obj);
        }
    }

    public static int m7198(Object obj) {
        if (m7180() > 0) {
            return m7168((C0373nf) obj);
        }
        return 0;
    }

    public static C0376ni m7199(Object obj) {
        if (C0453yj.m10032() >= 0) {
            return m7175((C0373nf) obj);
        }
        return null;
    }

    public static C0374ng m7200(Object obj) {
        if (C0447yc.m8786() >= 0) {
            return m7187((C0373nf) obj);
        }
        return null;
    }

    public static C0409oo m7201(Object obj) {
        if (C0453yj.m9945() < 0) {
            return m7163((C0374ng) obj);
        }
        return null;
    }

    public static void m7202(Object obj, boolean z) {
        if (C0460zg.m11293() > 0) {
            m7184((C0374ng) obj, z);
        }
    }

    public static boolean m7203(Object obj) {
        if (abd.m2166() < 0) {
            return m7159((C0374ng) obj);
        }
        return false;
    }

    public static void m7204(Object obj) {
        if (C0445ya.m8330() >= 0) {
            m7166((C0376ni) obj);
        }
    }

    public static void m7205(Object obj) throws IOException {
        if (m7180() >= 0) {
            m7182((C0373nf) obj);
        }
    }

    public static C0354mn m7206(Object obj) {
        if (C0459zf.m11053() >= 0) {
            return m7174((C0373nf) obj);
        }
        return null;
    }

    public static long m7207(Object obj) {
        if (C0453yj.m9996() <= 0) {
            return m7185((C0373nf) obj);
        }
        return 0L;
    }

    public static EnumC0346mf m7208(Object obj) {
        if (C0457zc.m10555() > 0) {
            return m7191((C0373nf) obj);
        }
        return null;
    }

    public static boolean m7209() {
        if (C0457zc.m10718() < 0) {
            return m7172();
        }
        return false;
    }

    public static C0373nf m7210(Object obj) {
        if (C0453yj.m10032() > 0) {
            return m7161((C0374ng) obj);
        }
        return null;
    }

    @Override
    public void mo1045b(C0409oo c0409oo, long j) {
        if (!m7181() && C0455za.m10268(m7192(this))) {
            throw new AssertionError();
        }
        C0458ze.m10826(m7169(this), c0409oo, j);
        while (C0455za.m10042(m7169(this)) >= 16384) {
            m7167(this, false);
        }
    }

    @Override
    public void close() {
        if (!m7181() && C0455za.m10268(m7192(this))) {
            throw new AssertionError();
        }
        synchronized (m7192(this)) {
            if (m7165(this)) {
                return;
            }
            if (!m7188(m7183(m7192(this)))) {
                if (C0455za.m10042(m7169(this)) > 0) {
                    while (C0455za.m10042(m7169(this)) > 0) {
                        m7167(this, true);
                    }
                } else {
                    C0452yh.m9643(m7170(m7192(this)), m7186(m7192(this)), true, null, 0L);
                }
            }
            synchronized (m7192(this)) {
                this.f1206oL = true;
            }
            abf.m2440(m7170(m7192(this)));
            m7179(m7192(this));
        }
    }

    @Override
    public C0430pi mo1095dz() {
        return m7160(m7192(this));
    }

    @Override
    public void flush() {
        if (!m7181() && C0455za.m10268(m7192(this))) {
            throw new AssertionError();
        }
        synchronized (m7192(this)) {
            m7164(m7192(this));
        }
        while (C0455za.m10042(m7169(this)) > 0) {
            m7167(this, false);
            abf.m2440(m7170(m7192(this)));
        }
    }
}
