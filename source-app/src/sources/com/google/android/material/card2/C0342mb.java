package com.google.android.material.card2;

import java.net.ProtocolException;

final class C0342mb implements InterfaceC0428pg {

    private boolean f1051oL;

    private long f1052qR;

    final C0335lw f1053qS;

    private final C0415ou f1054qT = new C0415ou(m6303(m6298(m6312(this))));

    C0342mb(C0335lw c0335lw, long j) {
        this.f1053qS = c0335lw;
        this.f1052qR = j;
    }

    public static C0430pi m6296(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return ((InterfaceC0410op) obj).mo1095dz();
        }
        return null;
    }

    public static C0415ou m6297(Object obj) {
        if (C0448yd.m9079() <= 0) {
            return ((C0342mb) obj).f1054qT;
        }
        return null;
    }

    public static InterfaceC0410op m6298(Object obj) {
        if (abe.m2308() <= 0) {
            return m6320(obj);
        }
        return null;
    }

    public static C0415ou m6299(Object obj) {
        if (C0457zc.m10735() <= 0) {
            return m6318(obj);
        }
        return null;
    }

    public static boolean m6300(Object obj) {
        if (abe.m2308() <= 0) {
            return m6319(obj);
        }
        return false;
    }

    public static C0335lw m6301(Object obj) {
        if (adds.m2755() >= 0) {
            return ((C0342mb) obj).f1053qS;
        }
        return null;
    }

    public static boolean m6302(Object obj) {
        if (C0448yd.m9079() < 0) {
            return ((C0342mb) obj).f1051oL;
        }
        return false;
    }

    public static C0430pi m6303(Object obj) {
        if (abf.m2510() <= 0) {
            return m6316(obj);
        }
        return null;
    }

    public static long m6304(Object obj) {
        if (abf.m2510() <= 0) {
            return ((C0342mb) obj).f1052qR;
        }
        return 0L;
    }

    public static void m6305(Object obj, Object obj2) {
        if (C0450yf.m9352() <= 0) {
            m6314(obj, obj2);
        }
    }

    public static void m6306(Object obj, Object obj2, long j) {
        if (abc.m1845() < 0) {
            ((InterfaceC0410op) obj).mo1045b((C0409oo) obj2, j);
        }
    }

    public static void m6307(Object obj, Object obj2) {
        if (C0458ze.m10932() > 0) {
            ((C0335lw) obj).m1087a((C0415ou) obj2);
        }
    }

    public static InterfaceC0410op m6308(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return ((C0335lw) obj).f1033qE;
        }
        return null;
    }

    public static void m6309(Object obj, Object obj2, long j) {
        if (C0445ya.m8222() > 0) {
            m6317(obj, obj2, j);
        }
    }

    public static int m6310() {
        if (C0456zb.m10326() <= 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static long m6311(Object obj) {
        if (abd.m2162() > 0) {
            return m6313(obj);
        }
        return 0L;
    }

    public static C0335lw m6312(Object obj) {
        if (C0450yf.m9352() <= 0) {
            return m6315(obj);
        }
        return null;
    }

    public static long m6313(Object obj) {
        if (C0458ze.m10926() < 0) {
            return m6304((C0342mb) obj);
        }
        return 0L;
    }

    public static void m6314(Object obj, Object obj2) {
        if (abd.m2166() <= 0) {
            m6307((C0335lw) obj, (C0415ou) obj2);
        }
    }

    public static C0335lw m6315(Object obj) {
        if (C0453yj.m9966() > 0) {
            return m6301((C0342mb) obj);
        }
        return null;
    }

    public static C0430pi m6316(Object obj) {
        if (C0460zg.m11293() >= 0) {
            return m6296((InterfaceC0410op) obj);
        }
        return null;
    }

    public static void m6317(Object obj, Object obj2, long j) {
        if (abf.m2500() >= 0) {
            m6306((InterfaceC0410op) obj, (C0409oo) obj2, j);
        }
    }

    public static C0415ou m6318(Object obj) {
        if (m6310() >= 0) {
            return m6297((C0342mb) obj);
        }
        return null;
    }

    public static boolean m6319(Object obj) {
        if (C0448yd.m9074() <= 0) {
            return m6302((C0342mb) obj);
        }
        return false;
    }

    public static InterfaceC0410op m6320(Object obj) {
        if (C0448yd.m9074() <= 0) {
            return m6308((C0335lw) obj);
        }
        return null;
    }

    @Override
    public void mo1045b(C0409oo c0409oo, long j) throws ProtocolException {
        if (m6300(this)) {
            throw new IllegalStateException(C0447yc.m8663());
        }
        C0450yf.m9366(C0455za.m10042(c0409oo), 0L, j);
        if (j > m6311(this)) {
            throw new ProtocolException(abc.m1925(C0458ze.m10777(C0460zg.m11407(C0458ze.m10777(C0460zg.m11407(new StringBuilder(), abd.m2027()), m6311(this)), C0453yj.m9849()), j)));
        }
        m6309(m6298(m6312(this)), c0409oo, j);
        this.f1052qR = m6311(this) - j;
    }

    @Override
    public void close() throws ProtocolException {
        if (m6300(this)) {
            return;
        }
        this.f1051oL = true;
        if (m6311(this) > 0) {
            throw new ProtocolException(C0445ya.m8367());
        }
        m6305(m6312(this), m6299(this));
        m6312(this).f1035qG = 3;
    }

    @Override
    public C0430pi mo1095dz() {
        return m6299(this);
    }

    @Override
    public void flush() {
        if (m6300(this)) {
            return;
        }
        C0458ze.m10814(m6298(m6312(this)));
    }
}
