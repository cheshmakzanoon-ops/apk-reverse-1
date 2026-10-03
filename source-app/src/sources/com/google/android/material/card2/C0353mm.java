package com.google.android.material.card2;

import java.io.IOException;

class C0353mm extends AbstractC0414ot {

    long f1115qI;

    boolean f1116rV;

    final C0352ml f1117rW;

    C0353mm(C0352ml c0352ml, InterfaceC0429ph interfaceC0429ph) {
        super(interfaceC0429ph);
        this.f1117rW = c0352ml;
        this.f1116rV = false;
        this.f1115qI = 0L;
    }

    private void m1147d(IOException iOException) {
        if (m6550(this)) {
            return;
        }
        this.f1116rV = true;
        abf.m2437(m6548(m6547(this)), false, m6547(this), m6549(this), iOException);
    }

    public static long m6543(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return ((C0353mm) obj).f1115qI;
        }
        return 0L;
    }

    public static InterfaceC0429ph m6544(Object obj) {
        if (C0446yb.m8415() < 0) {
            return m6556(obj);
        }
        return null;
    }

    public static C0319lg m6545(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return ((C0352ml) obj).f1114rU;
        }
        return null;
    }

    public static void m6546(Object obj, Object obj2) {
        if (abe.m2308() <= 0) {
            m6558(obj, obj2);
        }
    }

    public static C0352ml m6547(Object obj) {
        if (C0461zs.m11510() < 0) {
            return m6555(obj);
        }
        return null;
    }

    public static C0319lg m6548(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return m6557(obj);
        }
        return null;
    }

    public static long m6549(Object obj) {
        if (C0458ze.m10932() >= 0) {
            return m6560(obj);
        }
        return 0L;
    }

    public static boolean m6550(Object obj) {
        if (abe.m2308() <= 0) {
            return m6559(obj);
        }
        return false;
    }

    public static C0352ml m6551(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return ((C0353mm) obj).f1117rW;
        }
        return null;
    }

    public static void m6552(Object obj, Object obj2) {
        if (gggy.m4269() < 0) {
            ((C0353mm) obj).m1147d((IOException) obj2);
        }
    }

    public static boolean m6553(Object obj) {
        if (C0453yj.m10013() > 0) {
            return ((C0353mm) obj).f1116rV;
        }
        return false;
    }

    public static InterfaceC0429ph m6554(Object obj) {
        if (adds.m2755() >= 0) {
            return ((C0353mm) obj).m1420fT();
        }
        return null;
    }

    public static C0352ml m6555(Object obj) {
        if (abf.m2500() >= 0) {
            return m6551((C0353mm) obj);
        }
        return null;
    }

    public static InterfaceC0429ph m6556(Object obj) {
        if (abe.m2321() < 0) {
            return m6554((C0353mm) obj);
        }
        return null;
    }

    public static C0319lg m6557(Object obj) {
        if (gggy.m4365() > 0) {
            return m6545((C0352ml) obj);
        }
        return null;
    }

    public static void m6558(Object obj, Object obj2) {
        if (abd.m2166() <= 0) {
            m6552((C0353mm) obj, (IOException) obj2);
        }
    }

    public static boolean m6559(Object obj) {
        if (abe.m2321() < 0) {
            return m6553((C0353mm) obj);
        }
        return false;
    }

    public static long m6560(Object obj) {
        if (abd.m2166() < 0) {
            return m6543((C0353mm) obj);
        }
        return 0L;
    }

    @Override
    public long mo966a(C0409oo c0409oo, long j) throws IOException {
        try {
            long jM2209 = abe.m2209(m6544(this), c0409oo, j);
            if (jM2209 > 0) {
                this.f1115qI = m6549(this) + jM2209;
            }
            return jM2209;
        } catch (IOException e) {
            m6546(this, e);
            throw e;
        }
    }

    @Override
    public void close() {
        super.close();
        m6546(this, null);
    }
}
