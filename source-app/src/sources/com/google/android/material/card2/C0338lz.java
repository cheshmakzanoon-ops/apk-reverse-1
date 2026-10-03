package com.google.android.material.card2;

final class C0338lz implements InterfaceC0428pg {

    private boolean f1041oL;

    final C0335lw f1042qL;

    private final C0415ou f1043qM = new C0415ou(m6240(m6241(m6238(this))));

    C0338lz(C0335lw c0335lw) {
        this.f1042qL = c0335lw;
    }

    public static void m6235(Object obj, Object obj2, long j) {
        if (C0456zb.m10326() <= 0) {
            ((InterfaceC0410op) obj).mo1045b((C0409oo) obj2, j);
        }
    }

    public static String m6236() {
        if (abd.m2162() > 0) {
            return C0598.m11822();
        }
        return null;
    }

    public static void m6237(Object obj, Object obj2) {
        if (C0450yf.m9352() <= 0) {
            ((C0335lw) obj).m1087a((C0415ou) obj2);
        }
    }

    public static C0335lw m6238(Object obj) {
        if (adds.m2755() > 0) {
            return m6252(obj);
        }
        return null;
    }

    public static InterfaceC0410op m6239(Object obj) {
        if (adds.m2755() > 0) {
            return ((C0335lw) obj).f1033qE;
        }
        return null;
    }

    public static C0430pi m6240(Object obj) {
        if (adds.m2755() > 0) {
            return m6254(obj);
        }
        return null;
    }

    public static InterfaceC0410op m6241(Object obj) {
        if (C0459zf.m11062() > 0) {
            return m6256(obj);
        }
        return null;
    }

    public static void m6242(Object obj, Object obj2, long j) {
        if (C0448yd.m9079() < 0) {
            m6257(obj, obj2, j);
        }
    }

    public static C0430pi m6243(Object obj) {
        if (C0450yf.m9352() < 0) {
            return ((InterfaceC0410op) obj).mo1095dz();
        }
        return null;
    }

    public static C0335lw m6244(Object obj) {
        if (C0446yb.m8415() <= 0) {
            return ((C0338lz) obj).f1042qL;
        }
        return null;
    }

    public static C0415ou m6245(Object obj) {
        if (C0449ye.m9220() < 0) {
            return ((C0338lz) obj).f1043qM;
        }
        return null;
    }

    public static boolean m6246(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return m6251(obj);
        }
        return false;
    }

    public static C0415ou m6247(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return m6255(obj);
        }
        return null;
    }

    public static void m6248(Object obj, Object obj2) {
        if (abd.m2162() > 0) {
            m6253(obj, obj2);
        }
    }

    public static boolean m6249(Object obj) {
        if (adds.m2755() > 0) {
            return ((C0338lz) obj).f1041oL;
        }
        return false;
    }

    public static int m6250() {
        if (C0448yd.m9079() <= 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static boolean m6251(Object obj) {
        if (C0456zb.m10484() <= 0) {
            return m6249((C0338lz) obj);
        }
        return false;
    }

    public static C0335lw m6252(Object obj) {
        if (C0448yd.m9015() <= 0) {
            return m6244((C0338lz) obj);
        }
        return null;
    }

    public static void m6253(Object obj, Object obj2) {
        if (m6250() >= 0) {
            m6237((C0335lw) obj, (C0415ou) obj2);
        }
    }

    public static C0430pi m6254(Object obj) {
        if (C0445ya.m8330() >= 0) {
            return m6243((InterfaceC0410op) obj);
        }
        return null;
    }

    public static C0415ou m6255(Object obj) {
        if (C0456zb.m10484() <= 0) {
            return m6245((C0338lz) obj);
        }
        return null;
    }

    public static InterfaceC0410op m6256(Object obj) {
        if (abf.m2500() >= 0) {
            return m6239((C0335lw) obj);
        }
        return null;
    }

    public static void m6257(Object obj, Object obj2, long j) {
        if (gggy.m4365() > 0) {
            m6235((InterfaceC0410op) obj, (C0409oo) obj2, j);
        }
    }

    @Override
    public void mo1045b(C0409oo c0409oo, long j) {
        if (m6246(this)) {
            throw new IllegalStateException(C0447yc.m8663());
        }
        if (j == 0) {
            return;
        }
        abf.m2654(m6241(m6238(this)), j);
        gggy.m4317(m6241(m6238(this)), m6236());
        m6242(m6241(m6238(this)), c0409oo, j);
        gggy.m4317(m6241(m6238(this)), m6236());
    }

    @Override
    public void close() {
        synchronized (this) {
            if (!m6246(this)) {
                this.f1041oL = true;
                gggy.m4317(m6241(m6238(this)), C0445ya.m8321());
                m6248(m6238(this), m6247(this));
                m6238(this).f1035qG = 3;
            }
        }
    }

    @Override
    public C0430pi mo1095dz() {
        return m6247(this);
    }

    @Override
    public void flush() {
        synchronized (this) {
            if (!m6246(this)) {
                C0458ze.m10814(m6241(m6238(this)));
            }
        }
    }
}
