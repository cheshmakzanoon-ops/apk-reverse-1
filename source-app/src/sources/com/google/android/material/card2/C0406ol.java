package com.google.android.material.card2;

import java.io.IOException;

class C0406ol implements InterfaceC0429ph {

    final C0404oj f1295vc;

    final InterfaceC0429ph f1296vd;

    C0406ol(C0404oj c0404oj, InterfaceC0429ph interfaceC0429ph) {
        this.f1295vc = c0404oj;
        this.f1296vd = interfaceC0429ph;
    }

    public static IOException m7723(Object obj, Object obj2) {
        if (C0453yj.m10013() > 0) {
            return ((C0404oj) obj).m1334f((IOException) obj2);
        }
        return null;
    }

    public static C0404oj m7724(Object obj) {
        if (C0450yf.m9352() < 0) {
            return m7732(obj);
        }
        return null;
    }

    public static int m7725() {
        if (adds.m2755() > 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static InterfaceC0429ph m7726(Object obj) {
        if (C0460zg.m11287() > 0) {
            return ((C0406ol) obj).f1296vd;
        }
        return null;
    }

    public static IOException m7727(Object obj, Object obj2) {
        if (abc.m1845() < 0) {
            return m7734(obj, obj2);
        }
        return null;
    }

    public static void m7728(Object obj, boolean z) throws IOException {
        if (gggy.m4269() < 0) {
            m7735(obj, z);
        }
    }

    public static C0404oj m7729(Object obj) {
        if (C0448yd.m9079() < 0) {
            return ((C0406ol) obj).f1295vc;
        }
        return null;
    }

    public static InterfaceC0429ph m7730(Object obj) {
        if (C0447yc.m8635() > 0) {
            return m7733(obj);
        }
        return null;
    }

    public static void m7731(Object obj, boolean z) throws IOException {
        if (C0453yj.m10013() >= 0) {
            ((C0404oj) obj).m1337p(z);
        }
    }

    public static C0404oj m7732(Object obj) {
        if (C0453yj.m9945() < 0) {
            return m7729((C0406ol) obj);
        }
        return null;
    }

    public static InterfaceC0429ph m7733(Object obj) {
        if (m7725() >= 0) {
            return m7726((C0406ol) obj);
        }
        return null;
    }

    public static IOException m7734(Object obj, Object obj2) {
        if (C0445ya.m8330() > 0) {
            return m7723((C0404oj) obj, (IOException) obj2);
        }
        return null;
    }

    public static void m7735(Object obj, boolean z) throws IOException {
        if (C0453yj.m9996() < 0) {
            m7731((C0404oj) obj, z);
        }
    }

    @Override
    public long mo966a(C0409oo c0409oo, long j) throws IOException {
        C0459zf.m11193(m7724(this));
        try {
            try {
                long jM2209 = abe.m2209(m7730(this), c0409oo, j);
                m7728(m7724(this), true);
                return jM2209;
            } catch (IOException e) {
                throw m7727(m7724(this), e);
            }
        } catch (Throwable th) {
            m7728(m7724(this), false);
            throw th;
        }
    }

    @Override
    public void close() throws IOException {
        C0459zf.m11193(m7724(this));
        try {
            try {
                C0447yc.m8668(m7730(this));
                m7728(m7724(this), true);
            } catch (IOException e) {
                throw m7727(m7724(this), e);
            }
        } catch (Throwable th) {
            m7728(m7724(this), false);
            throw th;
        }
    }

    @Override
    public C0430pi mo967dz() {
        return m7724(this);
    }

    public String toString() {
        return abc.m1925(C0460zg.m11407(abd.m2090(C0460zg.m11407(new StringBuilder(), C0449ye.m9316()), m7730(this)), C0457zc.m10722()));
    }
}
