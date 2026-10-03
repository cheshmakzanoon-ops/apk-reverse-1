package com.google.android.material.card2;

final class C0249ir {

    final String f533iA;

    final String f534iB;

    final String f535iy;

    final C0412or f536iz;

    public static String m4945(Object obj) {
        if (abc.m1845() <= 0) {
            return m4953(obj);
        }
        return null;
    }

    public static String m4946(Object obj) {
        if (C0453yj.m10013() >= 0) {
            return m4954(obj);
        }
        return null;
    }

    public static C0412or m4947(Object obj) {
        if (abc.m1845() < 0) {
            return ((C0249ir) obj).f536iz;
        }
        return null;
    }

    public static C0412or m4948(Object obj) {
        if (abc.m1845() < 0) {
            return m4956(obj);
        }
        return null;
    }

    public static String m4949(Object obj) {
        if (C0451yg.m9580() > 0) {
            return ((C0249ir) obj).f533iA;
        }
        return null;
    }

    public static String m4950(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return ((C0249ir) obj).f534iB;
        }
        return null;
    }

    public static String m4951(Object obj) {
        if (C0461zs.m11510() < 0) {
            return ((C0249ir) obj).f535iy;
        }
        return null;
    }

    public static String m4952(Object obj) {
        if (C0450yf.m9352() <= 0) {
            return m4955(obj);
        }
        return null;
    }

    public static String m4953(Object obj) {
        if (C0453yj.m9996() < 0) {
            return m4949((C0249ir) obj);
        }
        return null;
    }

    public static String m4954(Object obj) {
        if (C0453yj.m9966() > 0) {
            return m4950((C0249ir) obj);
        }
        return null;
    }

    public static String m4955(Object obj) {
        if (C0445ya.m8330() > 0) {
            return m4951((C0249ir) obj);
        }
        return null;
    }

    public static C0412or m4956(Object obj) {
        if (gggy.m4365() >= 0) {
            return m4947((C0249ir) obj);
        }
        return null;
    }

    public boolean equals(Object obj) {
        return (obj instanceof C0249ir) && C0452yh.m9583(m4946(this), m4946((C0249ir) obj)) && C0452yh.m9583(m4945(this), m4945((C0249ir) obj)) && C0459zf.m11211(m4948(this), m4948((C0249ir) obj));
    }

    public int hashCode() {
        int iM11248 = C0460zg.m11248(m4946(this));
        return ((((iM11248 + 527) * 31) + C0460zg.m11248(m4945(this))) * 31) + C0458ze.m10815(m4948(this));
    }

    boolean m640q(String str) {
        if (!C0458ze.m10811(m4946(this), C0448yd.m9034())) {
            return C0452yh.m9583(str, m4952(this));
        }
        int iM10892 = C0458ze.m10892(str, 46);
        if ((gggy.m4397(str) - iM10892) - 1 == gggy.m4397(m4952(this))) {
            return C0446yb.m8547(str, false, iM10892 + 1, m4952(this), 0, gggy.m4397(m4952(this)));
        }
        return false;
    }

    public String toString() {
        return abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), m4945(this)), C0456zb.m10316(m4948(this))));
    }
}
