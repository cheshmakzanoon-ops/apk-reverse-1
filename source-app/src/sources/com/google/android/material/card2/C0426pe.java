package com.google.android.material.card2;

import javax.annotation.Nullable;

final class C0426pe {

    @Nullable
    static C0425pd f1339vI;

    static long f1340vM;

    private C0426pe() {
    }

    static void m1456b(C0425pd c0425pd) {
        if (m8104(c0425pd) != null || m8102(c0425pd) != null) {
            throw new IllegalArgumentException();
        }
        if (m8110(c0425pd)) {
            return;
        }
        synchronized (C0426pe.class) {
            try {
                if (m8105() + 8192 <= 65536) {
                    f1340vM = m8105() + 8192;
                    c0425pd.f1335vI = m8103();
                    c0425pd.f1332ea = 0;
                    c0425pd.f1333eh = 0;
                    f1339vI = c0425pd;
                }
            } catch (Throwable th) {
                throw th;
            }
        }
    }

    static C0425pd m1457gi() {
        synchronized (C0426pe.class) {
            try {
                if (m8103() == null) {
                    return new C0425pd();
                }
                C0425pd c0425pdM8103 = m8103();
                f1339vI = m8104(c0425pdM8103);
                c0425pdM8103.f1335vI = null;
                f1340vM = m8105() - 8192;
                return c0425pdM8103;
            } catch (Throwable th) {
                throw th;
            }
        }
    }

    public static C0425pd m8102(Object obj) {
        if (adds.m2755() >= 0) {
            return m8113(obj);
        }
        return null;
    }

    public static C0425pd m8103() {
        if (C0452yh.m9798() >= 0) {
            return m8114();
        }
        return null;
    }

    public static C0425pd m8104(Object obj) {
        if (C0450yf.m9352() <= 0) {
            return m8116(obj);
        }
        return null;
    }

    public static long m8105() {
        if (abe.m2308() <= 0) {
            return m8115();
        }
        return 0L;
    }

    public static boolean m8106(Object obj) {
        if (C0453yj.m10013() > 0) {
            return ((C0425pd) obj).f1338vL;
        }
        return false;
    }

    public static C0425pd m8107(Object obj) {
        if (C0461zs.m11510() < 0) {
            return ((C0425pd) obj).f1337vK;
        }
        return null;
    }

    public static C0425pd m8108() {
        if (gggy.m4269() <= 0) {
            return f1339vI;
        }
        return null;
    }

    public static C0425pd m8109(Object obj) {
        if (abe.m2308() <= 0) {
            return ((C0425pd) obj).f1335vI;
        }
        return null;
    }

    public static boolean m8110(Object obj) {
        if (abf.m2510() < 0) {
            return m8112(obj);
        }
        return false;
    }

    public static long m8111() {
        if (C0453yj.m10013() > 0) {
            return f1340vM;
        }
        return 0L;
    }

    public static boolean m8112(Object obj) {
        if (C0448yd.m9015() <= 0) {
            return m8106((C0425pd) obj);
        }
        return false;
    }

    public static C0425pd m8113(Object obj) {
        if (gggy.m4365() >= 0) {
            return m8107((C0425pd) obj);
        }
        return null;
    }

    public static C0425pd m8114() {
        if (C0458ze.m10926() <= 0) {
            return m8108();
        }
        return null;
    }

    public static long m8115() {
        if (C0459zf.m11053() >= 0) {
            return m8111();
        }
        return 0L;
    }

    public static C0425pd m8116(Object obj) {
        if (C0445ya.m8330() > 0) {
            return m8109((C0425pd) obj);
        }
        return null;
    }
}
