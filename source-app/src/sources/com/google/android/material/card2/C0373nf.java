package com.google.android.material.card2;

import java.io.IOException;
import java.io.InterruptedIOException;
import java.util.ArrayList;
import java.util.List;

public final class C0373nf {

    static final boolean f1192tm;

    long f1193rZ;

    final C0354mn f1195tn;

    private boolean f1197tp;

    final int f1198tq;

    private final List<C0347mg> f1200ts;

    private List<C0347mg> f1201tt;

    final C0374ng f1202tu;

    private final C0375nh f1203tv;

    long f1194sr = 0;

    final C0376ni f1199tr = new C0376ni(this);

    final C0376ni f1204tw = new C0376ni(this);

    EnumC0346mf f1196to = null;

    static {
        f1192tm = !C0460zg.m11342(C0373nf.class);
    }

    C0373nf(int i, C0354mn c0354mn, boolean z, boolean z2, List<C0347mg> list) {
        if (c0354mn == null) {
            throw new NullPointerException(abc.m1933());
        }
        if (list == null) {
            throw new NullPointerException(C0457zc.m10671());
        }
        this.f1198tq = i;
        this.f1195tn = c0354mn;
        this.f1193rZ = abf.m2461(C0461zs.m11582(c0354mn));
        this.f1203tv = new C0375nh(this, abf.m2461(C0452yh.m9741(c0354mn)));
        this.f1202tu = new C0374ng(this);
        m7114(this).f1216ty = z2;
        m7101(this).f1208ty = z;
        this.f1200ts = list;
    }

    private boolean m1203b(EnumC0346mf enumC0346mf) {
        if (!C0447yc.m8781() && C0455za.m10268(this)) {
            throw new AssertionError();
        }
        synchronized (this) {
            if (C0457zc.m10679(this) != null) {
                return false;
            }
            if (C0458ze.m10904(m7114(this)) && abc.m1772(m7101(this))) {
                return false;
            }
            this.f1196to = enumC0346mf;
            abe.m2339(this);
            C0456zb.m10421(C0445ya.m8212(this), C0459zf.m11000(this));
            return true;
        }
    }

    public static void m7098(Object obj, int i, Object obj2) {
        if (C0450yf.m9352() <= 0) {
            ((C0354mn) obj).m1159b(i, (EnumC0346mf) obj2);
        }
    }

    public static boolean m7099(Object obj) {
        if (C0453yj.m10013() > 0) {
            return C0598.m11853(obj);
        }
        return false;
    }

    public static C0376ni m7100(Object obj) {
        if (C0458ze.m10932() > 0) {
            return m7144(obj);
        }
        return null;
    }

    public static C0374ng m7101(Object obj) {
        if (C0457zc.m10735() < 0) {
            return m7140(obj);
        }
        return null;
    }

    public static boolean m7102(Object obj) {
        if (abc.m1845() <= 0) {
            return ((C0373nf) obj).f1197tp;
        }
        return false;
    }

    public static boolean m7103(Object obj) {
        if (C0449ye.m9220() < 0) {
            return ((C0374ng) obj).f1208ty;
        }
        return false;
    }

    public static C0383np m7104(Object obj) {
        if (C0449ye.m9220() < 0) {
            return ((C0354mn) obj).f1129si;
        }
        return null;
    }

    public static long m7105(Object obj) {
        if (C0453yj.m10013() > 0) {
            return ((C0373nf) obj).f1193rZ;
        }
        return 0L;
    }

    public static boolean m7106(Object obj) {
        if (abe.m2308() < 0) {
            return ((C0375nh) obj).f1211oL;
        }
        return false;
    }

    public static C0376ni m7107(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return ((C0373nf) obj).f1204tw;
        }
        return null;
    }

    public static boolean m7108(Object obj, Object obj2) {
        if (C0459zf.m11062() > 0) {
            return ((C0373nf) obj).m1203b((EnumC0346mf) obj2);
        }
        return false;
    }

    public static boolean m7109(Object obj) {
        if (C0448yd.m9079() <= 0) {
            return ((C0375nh) obj).f1216ty;
        }
        return false;
    }

    public static void m7110(Object obj) throws InterruptedIOException {
        if (C0451yg.m9580() > 0) {
            ((C0373nf) obj).m1218eO();
        }
    }

    public static int m7111(Object obj) {
        if (C0456zb.m10326() < 0) {
            return ((C0373nf) obj).f1198tq;
        }
        return 0;
    }

    public static C0354mn m7112(Object obj) {
        if (C0459zf.m11062() > 0) {
            return ((C0373nf) obj).f1195tn;
        }
        return null;
    }

    public static void m7113(Object obj) {
        if (abc.m1845() <= 0) {
            ((C0376ni) obj).m1226eR();
        }
    }

    public static C0375nh m7114(Object obj) {
        if (C0448yd.m9079() < 0) {
            return m7149(obj);
        }
        return null;
    }

    public static void m7115(Object obj, Object obj2) {
        if (adds.m2755() >= 0) {
            C0598.m11904(obj, obj2);
        }
    }

    public static C0373nf m7116(Object obj, int i) {
        if (abf.m2510() <= 0) {
            return ((C0354mn) obj).m1171w(i);
        }
        return null;
    }

    public static C0376ni m7117(Object obj) {
        if (abf.m2510() < 0) {
            return ((C0373nf) obj).f1199tr;
        }
        return null;
    }

    public static void m7118(Object obj, int i, Object obj2) {
        if (C0458ze.m10932() >= 0) {
            ((C0354mn) obj).m1162c(i, (EnumC0346mf) obj2);
        }
    }

    public static C0383np m7119(Object obj) {
        if (abe.m2308() < 0) {
            return ((C0354mn) obj).f1128sh;
        }
        return null;
    }

    public static void m7120(Object obj, Object obj2, long j) {
        if (C0459zf.m11062() >= 0) {
            ((C0375nh) obj).m1224a((InterfaceC0411oq) obj2, j);
        }
    }

    public static boolean m7121() {
        if (abc.m1845() < 0) {
            return f1192tm;
        }
        return false;
    }

    public static void m7122(Object obj) {
        if (adds.m2755() >= 0) {
            ((C0376ni) obj).m1335fs();
        }
    }

    public static int m7123(Object obj) {
        if (C0446yb.m8415() <= 0) {
            return ((C0383np) obj).m1263fb();
        }
        return 0;
    }

    public static int m7124() {
        if (abf.m2510() <= 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static List m7125(Object obj) {
        if (C0450yf.m9352() < 0) {
            return ((C0373nf) obj).f1201tt;
        }
        return null;
    }

    public static EnumC0346mf m7126(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return ((C0373nf) obj).f1196to;
        }
        return null;
    }

    public static C0374ng m7127(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return ((C0373nf) obj).f1202tu;
        }
        return null;
    }

    public static boolean m7128(Object obj) {
        if (C0457zc.m10735() < 0) {
            return ((C0374ng) obj).f1206oL;
        }
        return false;
    }

    public static C0375nh m7129(Object obj) {
        if (abd.m2162() >= 0) {
            return ((C0373nf) obj).f1203tv;
        }
        return null;
    }

    public static boolean m7130(Object obj) {
        if (abd.m2162() >= 0) {
            return ((C0354mn) obj).f1121sa;
        }
        return false;
    }

    public static C0376ni m7131(Object obj) {
        if (C0461zs.m11510() < 0) {
            return m7137(obj);
        }
        return null;
    }

    public static int m7132(Object obj) {
        if (C0458ze.m10926() <= 0) {
            return m7111((C0373nf) obj);
        }
        return 0;
    }

    public static boolean m7133(Object obj) {
        if (C0448yd.m9074() < 0) {
            return m7102((C0373nf) obj);
        }
        return false;
    }

    public static boolean m7134(Object obj) {
        if (C0456zb.m10484() < 0) {
            return m7109((C0375nh) obj);
        }
        return false;
    }

    public static boolean m7135(Object obj) {
        if (abf.m2500() >= 0) {
            return m7103((C0374ng) obj);
        }
        return false;
    }

    public static void m7136(Object obj) {
        if (m7124() > 0) {
            m7122((C0376ni) obj);
        }
    }

    public static C0376ni m7137(Object obj) {
        if (abd.m2166() < 0) {
            return m7117((C0373nf) obj);
        }
        return null;
    }

    public static C0354mn m7138(Object obj) {
        if (C0457zc.m10555() >= 0) {
            return m7112((C0373nf) obj);
        }
        return null;
    }

    public static boolean m7139(Object obj, Object obj2) {
        if (C0459zf.m11053() >= 0) {
            return m7108((C0373nf) obj, (EnumC0346mf) obj2);
        }
        return false;
    }

    public static C0374ng m7140(Object obj) {
        if (C0457zc.m10555() >= 0) {
            return m7127((C0373nf) obj);
        }
        return null;
    }

    public static C0383np m7141(Object obj) {
        if (m7124() >= 0) {
            return m7104((C0354mn) obj);
        }
        return null;
    }

    public static List m7142(Object obj) {
        if (C0458ze.m10926() <= 0) {
            return m7125((C0373nf) obj);
        }
        return null;
    }

    public static EnumC0346mf m7143(Object obj) {
        if (C0453yj.m9945() <= 0) {
            return m7126((C0373nf) obj);
        }
        return null;
    }

    public static C0376ni m7144(Object obj) {
        if (C0453yj.m9945() < 0) {
            return m7107((C0373nf) obj);
        }
        return null;
    }

    public static C0373nf m7145(Object obj, int i) {
        if (C0445ya.m8330() > 0) {
            return m7116((C0354mn) obj, i);
        }
        return null;
    }

    public static boolean m7146(Object obj) {
        if (abe.m2321() <= 0) {
            return m7128((C0374ng) obj);
        }
        return false;
    }

    public static C0383np m7147(Object obj) {
        if (C0453yj.m9966() > 0) {
            return m7119((C0354mn) obj);
        }
        return null;
    }

    public static boolean m7148(Object obj) {
        if (C0453yj.m9966() > 0) {
            return m7130((C0354mn) obj);
        }
        return false;
    }

    public static C0375nh m7149(Object obj) {
        if (C0453yj.m9996() < 0) {
            return m7129((C0373nf) obj);
        }
        return null;
    }

    public static void m7150(Object obj) {
        if (C0453yj.m9996() < 0) {
            m7113((C0376ni) obj);
        }
    }

    public static void m7151(Object obj) {
        if (C0448yd.m9074() < 0) {
            m7110((C0373nf) obj);
        }
    }

    public static int m7152(Object obj) {
        if (C0448yd.m9074() <= 0) {
            return m7123((C0383np) obj);
        }
        return 0;
    }

    public static void m7153(Object obj, int i, Object obj2) {
        if (m7124() >= 0) {
            m7098((C0354mn) obj, i, (EnumC0346mf) obj2);
        }
    }

    public static boolean m7154() {
        if (C0448yd.m9074() < 0) {
            return m7121();
        }
        return false;
    }

    public static boolean m7155(Object obj) {
        if (C0457zc.m10718() < 0) {
            return m7106((C0375nh) obj);
        }
        return false;
    }

    public static void m7156(Object obj, Object obj2, long j) {
        if (abe.m2321() <= 0) {
            m7120((C0375nh) obj, (InterfaceC0411oq) obj2, j);
        }
    }

    public static void m7157(Object obj, int i, Object obj2) {
        if (C0456zb.m10484() <= 0) {
            m7118((C0354mn) obj, i, (EnumC0346mf) obj2);
        }
    }

    public static long m7158(Object obj) {
        if (C0445ya.m8330() >= 0) {
            return m7105((C0373nf) obj);
        }
        return 0L;
    }

    void m1204a(InterfaceC0411oq interfaceC0411oq, int i) {
        if (!C0447yc.m8781() && C0455za.m10268(this)) {
            throw new AssertionError();
        }
        C0460zg.m11277(m7114(this), interfaceC0411oq, i);
    }

    public void m1205c(EnumC0346mf enumC0346mf) {
        if (abf.m2628(this, enumC0346mf)) {
            C0448yd.m8976(C0445ya.m8212(this), C0459zf.m11000(this), enumC0346mf);
        }
    }

    public void m1206d(EnumC0346mf enumC0346mf) {
        if (abf.m2628(this, enumC0346mf)) {
            abd.m2195(C0445ya.m8212(this), C0459zf.m11000(this), enumC0346mf);
        }
    }

    void m1207e(EnumC0346mf enumC0346mf) {
        synchronized (this) {
            if (C0457zc.m10679(this) == null) {
                this.f1196to = enumC0346mf;
                abe.m2339(this);
            }
        }
    }

    void m1208e(List<C0347mg> list) {
        boolean zM8828 = true;
        if (!C0447yc.m8781() && C0455za.m10268(this)) {
            throw new AssertionError();
        }
        synchronized (this) {
            this.f1197tp = true;
            if (C0458ze.m10972(this) == null) {
                this.f1201tt = list;
                zM8828 = C0447yc.m8828(this);
                abe.m2339(this);
            } else {
                ArrayList arrayList = new ArrayList();
                C0447yc.m8634(arrayList, C0458ze.m10972(this));
                C0460zg.m11251(arrayList, null);
                C0447yc.m8634(arrayList, list);
                this.f1201tt = arrayList;
            }
        }
        if (zM8828) {
            return;
        }
        C0456zb.m10421(C0445ya.m8212(this), C0459zf.m11000(this));
    }

    void m1209eF() {
        boolean z;
        boolean zM8828;
        if (!C0447yc.m8781() && C0455za.m10268(this)) {
            throw new AssertionError();
        }
        synchronized (this) {
            z = !C0458ze.m10904(m7114(this)) && abd.m1995(m7114(this)) && (abc.m1772(m7101(this)) || C0450yf.m9502(m7101(this)));
            zM8828 = C0447yc.m8828(this);
        }
        if (z) {
            m7115(this, C0456zb.m10363());
        } else {
            if (zM8828) {
                return;
            }
            C0456zb.m10421(C0445ya.m8212(this), C0459zf.m11000(this));
        }
    }

    void m1210eG() throws IOException {
        if (C0450yf.m9502(m7101(this))) {
            throw new IOException(C0446yb.m8487());
        }
        if (abc.m1772(m7101(this))) {
            throw new IOException(C0445ya.m8295());
        }
        if (C0457zc.m10679(this) != null) {
            throw new C0384nq(C0457zc.m10679(this));
        }
    }

    public int m1211eH() {
        return C0459zf.m11000(this);
    }

    public InterfaceC0428pg m1212eI() {
        synchronized (this) {
            if (!C0455za.m10120(this) && !m7099(this)) {
                throw new IllegalStateException(C0450yf.m9339());
            }
        }
        return m7101(this);
    }

    public InterfaceC0429ph m1213eJ() {
        return m7114(this);
    }

    public boolean m1214eK() {
        return abf.m2543(C0445ya.m8212(this)) == ((C0459zf.m11000(this) & 1) == 1);
    }

    public C0430pi m1215eL() {
        return m7131(this);
    }

    void m1216eM() {
        boolean zM8828;
        if (!C0447yc.m8781() && C0455za.m10268(this)) {
            throw new AssertionError();
        }
        synchronized (this) {
            m7114(this).f1216ty = true;
            zM8828 = C0447yc.m8828(this);
            abe.m2339(this);
        }
        if (zM8828) {
            return;
        }
        C0456zb.m10421(C0445ya.m8212(this), C0459zf.m11000(this));
    }

    public List<C0347mg> m1217eN() {
        List<C0347mg> listM10972;
        synchronized (this) {
            if (!m7099(this)) {
                throw new IllegalStateException(abc.m1927());
            }
            C0458ze.m10971(m7131(this));
            while (C0458ze.m10972(this) == null && C0457zc.m10679(this) == null) {
                try {
                    C0448yd.m8994(this);
                } catch (Throwable th) {
                    gggy.m4474(m7131(this));
                    throw th;
                }
            }
            gggy.m4474(m7131(this));
            listM10972 = C0458ze.m10972(this);
            if (listM10972 == null) {
                throw new C0384nq(C0457zc.m10679(this));
            }
            this.f1201tt = null;
        }
        return listM10972;
    }

    void m1218eO() throws InterruptedIOException {
        try {
            adds.m2868(this);
        } catch (InterruptedException e) {
            throw new InterruptedIOException();
        }
    }

    public C0430pi m1219eP() {
        return m7100(this);
    }

    void m1220g(long j) {
        this.f1193rZ = C0449ye.m9182(this) + j;
        if (j > 0) {
            abe.m2339(this);
        }
    }

    public boolean isOpen() {
        boolean z = false;
        synchronized (this) {
            if (C0457zc.m10679(this) == null && ((!C0458ze.m10904(m7114(this)) && !abd.m1995(m7114(this))) || ((!abc.m1772(m7101(this)) && !C0450yf.m9502(m7101(this))) || !C0455za.m10120(this)))) {
                z = true;
            }
        }
        return z;
    }
}
