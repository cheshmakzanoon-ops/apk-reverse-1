package com.google.android.material.card2;

import java.nio.ByteBuffer;

final class C0423pb implements InterfaceC0410op {

    boolean f1326oL;

    public final C0409oo f1327vD = new C0409oo();

    public final InterfaceC0428pg f1328vE;

    C0423pb(InterfaceC0428pg interfaceC0428pg) {
        if (interfaceC0428pg == null) {
            throw new NullPointerException(m8020());
        }
        this.f1328vE = interfaceC0428pg;
    }

    public static InterfaceC0410op m8007(Object obj) {
        if (C0447yc.m8635() > 0) {
            return m8022(obj);
        }
        return null;
    }

    public static void m8008(Object obj) throws Throwable {
        if (C0452yh.m9798() > 0) {
            m8025(obj);
        }
    }

    public static InterfaceC0428pg m8009(Object obj) {
        if (abc.m1845() <= 0) {
            return m8021(obj);
        }
        return null;
    }

    public static void m8010(Object obj) throws Throwable {
        if (C0451yg.m9580() >= 0) {
            C0432pk.m1463a((Throwable) obj);
        }
    }

    public static long m8011(Object obj) {
        if (C0461zs.m11510() < 0) {
            return ((C0409oo) obj).f1300oV;
        }
        return 0L;
    }

    public static boolean m8012(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return m8023(obj);
        }
        return false;
    }

    public static boolean m8013(Object obj) {
        if (C0448yd.m9079() < 0) {
            return ((C0423pb) obj).f1326oL;
        }
        return false;
    }

    public static C0409oo m8014(Object obj) {
        if (adds.m2755() > 0) {
            return ((C0423pb) obj).f1327vD;
        }
        return null;
    }

    public static InterfaceC0428pg m8015(Object obj) {
        if (C0450yf.m9352() < 0) {
            return ((C0423pb) obj).f1328vE;
        }
        return null;
    }

    public static InterfaceC0410op m8016(Object obj) {
        if (C0453yj.m10013() >= 0) {
            return ((C0423pb) obj).mo1385fz();
        }
        return null;
    }

    public static long m8017(Object obj) {
        if (C0459zf.m11062() >= 0) {
            return m8024(obj);
        }
        return 0L;
    }

    public static C0409oo m8018(Object obj) {
        if (abf.m2510() <= 0) {
            return m8026(obj);
        }
        return null;
    }

    public static int m8019() {
        if (C0447yc.m8635() >= 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static String m8020() {
        if (C0461zs.m11510() < 0) {
            return C0598.m11829();
        }
        return null;
    }

    public static InterfaceC0428pg m8021(Object obj) {
        if (C0453yj.m9996() <= 0) {
            return m8015((C0423pb) obj);
        }
        return null;
    }

    public static InterfaceC0410op m8022(Object obj) {
        if (C0448yd.m9074() < 0) {
            return m8016((C0423pb) obj);
        }
        return null;
    }

    public static boolean m8023(Object obj) {
        if (C0445ya.m8330() > 0) {
            return m8013((C0423pb) obj);
        }
        return false;
    }

    public static long m8024(Object obj) {
        if (C0445ya.m8330() >= 0) {
            return m8011((C0409oo) obj);
        }
        return 0L;
    }

    public static void m8025(Object obj) throws Throwable {
        if (m8019() > 0) {
            m8010((Throwable) obj);
        }
    }

    public static C0409oo m8026(Object obj) {
        if (C0453yj.m10032() >= 0) {
            return m8014((C0423pb) obj);
        }
        return null;
    }

    @Override
    public InterfaceC0410op mo1343F(int i) {
        if (m8012(this)) {
            throw new IllegalStateException(C0447yc.m8663());
        }
        C0447yc.m8844(m8018(this), i);
        return m8007(this);
    }

    @Override
    public InterfaceC0410op mo1345H(int i) {
        if (m8012(this)) {
            throw new IllegalStateException(C0447yc.m8663());
        }
        abc.m1923(m8018(this), i);
        return m8007(this);
    }

    @Override
    public InterfaceC0410op mo1347J(int i) {
        if (m8012(this)) {
            throw new IllegalStateException(C0447yc.m8663());
        }
        C0448yd.m9086(m8018(this), i);
        return m8007(this);
    }

    @Override
    public InterfaceC0410op mo1358an(String str) {
        if (m8012(this)) {
            throw new IllegalStateException(C0447yc.m8663());
        }
        C0457zc.m10684(m8018(this), str);
        return m8007(this);
    }

    @Override
    public void mo1045b(C0409oo c0409oo, long j) {
        if (m8012(this)) {
            throw new IllegalStateException(C0447yc.m8663());
        }
        C0458ze.m10826(m8018(this), c0409oo, j);
        m8007(this);
    }

    @Override
    public InterfaceC0410op mo1362c(byte[] bArr, int i, int i2) {
        if (m8012(this)) {
            throw new IllegalStateException(C0447yc.m8663());
        }
        abf.m2562(m8018(this), bArr, i, i2);
        return m8007(this);
    }

    @Override
    public void close() throws Throwable {
        if (m8012(this)) {
            return;
        }
        Throwable th = null;
        try {
            if (m8017(m8018(this)) > 0) {
                C0448yd.m8920(m8009(this), m8018(this), m8017(m8018(this)));
            }
        } catch (Throwable th2) {
            th = th2;
        }
        try {
            C0453yj.m10006(m8009(this));
        } catch (Throwable th3) {
            if (th == null) {
                th = th3;
            }
        }
        this.f1326oL = true;
        if (th != null) {
            m8008(th);
        }
    }

    @Override
    public C0430pi mo1095dz() {
        return C0457zc.m10700(m8009(this));
    }

    @Override
    public InterfaceC0410op mo1367f(byte[] bArr) {
        if (m8012(this)) {
            throw new IllegalStateException(C0447yc.m8663());
        }
        C0453yj.m9824(m8018(this), bArr);
        return m8007(this);
    }

    @Override
    public void flush() {
        if (m8012(this)) {
            throw new IllegalStateException(C0447yc.m8663());
        }
        if (m8017(m8018(this)) > 0) {
            C0448yd.m8920(m8009(this), m8018(this), m8017(m8018(this)));
        }
        C0459zf.m11085(m8009(this));
    }

    @Override
    public C0409oo mo1380fu() {
        return m8018(this);
    }

    @Override
    public InterfaceC0410op mo1385fz() {
        if (m8012(this)) {
            throw new IllegalStateException(C0447yc.m8663());
        }
        long jM8739 = C0447yc.m8739(m8018(this));
        if (jM8739 > 0) {
            C0448yd.m8920(m8009(this), m8018(this), jM8739);
        }
        return this;
    }

    @Override
    public boolean isOpen() {
        return !m8012(this);
    }

    @Override
    public InterfaceC0410op mo1396r(long j) {
        if (m8012(this)) {
            throw new IllegalStateException(C0447yc.m8663());
        }
        abf.m2584(m8018(this), j);
        return m8007(this);
    }

    @Override
    public InterfaceC0410op mo1398t(long j) {
        if (m8012(this)) {
            throw new IllegalStateException(C0447yc.m8663());
        }
        abf.m2564(m8018(this), j);
        return m8007(this);
    }

    public String toString() {
        return abc.m1925(C0460zg.m11407(abd.m2090(C0460zg.m11407(new StringBuilder(), adds.m2899()), m8009(this)), C0457zc.m10722()));
    }

    @Override
    public int write(ByteBuffer byteBuffer) {
        if (m8012(this)) {
            throw new IllegalStateException(C0447yc.m8663());
        }
        int iM8217 = C0445ya.m8217(m8018(this), byteBuffer);
        m8007(this);
        return iM8217;
    }
}
