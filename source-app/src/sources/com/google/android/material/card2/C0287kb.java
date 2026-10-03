package com.google.android.material.card2;

import javax.annotation.Nullable;

public class C0287kb {

    C0273jo f837ib;

    AbstractC0288kc f838ni;

    String f839nl;

    Object f840nm;

    C0272jn f841no;

    public C0287kb() {
        this.f839nl = C0453yj.m10028();
        this.f841no = new C0272jn();
    }

    C0287kb(C0286ka c0286ka) {
        this.f837ib = C0458ze.m10790(c0286ka);
        this.f839nl = C0457zc.m10619(c0286ka);
        this.f838ni = C0446yb.m8545(c0286ka);
        this.f840nm = C0450yf.m9532(c0286ka);
        this.f841no = C0445ya.m8205(C0461zs.m11465(c0286ka));
    }

    public static String m5611(Object obj) {
        if (C0453yj.m10013() >= 0) {
            return ((C0286ka) obj).f834nl;
        }
        return null;
    }

    public static Object m5612(Object obj) {
        if (C0452yh.m9798() > 0) {
            return ((C0286ka) obj).f835nm;
        }
        return null;
    }

    public static boolean m5613(Object obj) {
        if (C0452yh.m9798() >= 0) {
            return C0598.m11870(obj);
        }
        return false;
    }

    public static C0273jo m5614(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return C0598.m11798(obj);
        }
        return null;
    }

    public static C0273jo m5615(Object obj) {
        if (C0450yf.m9352() <= 0) {
            return ((C0287kb) obj).f837ib;
        }
        return null;
    }

    public static C0272jn m5616(Object obj) {
        if (abf.m2510() < 0) {
            return ((C0287kb) obj).f841no;
        }
        return null;
    }

    public static AbstractC0288kc m5617(Object obj) {
        if (abd.m2162() >= 0) {
            return ((C0286ka) obj).f831ni;
        }
        return null;
    }

    public static C0271jm m5618(Object obj) {
        if (C0458ze.m10932() >= 0) {
            return ((C0286ka) obj).f833nk;
        }
        return null;
    }

    public static int m5619() {
        if (gggy.m4269() < 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static C0273jo m5620(Object obj) {
        if (abc.m1845() < 0) {
            return ((C0286ka) obj).f836nn;
        }
        return null;
    }

    public static Object m5621(Object obj) {
        if (C0460zg.m11293() > 0) {
            return m5612((C0286ka) obj);
        }
        return null;
    }

    public static AbstractC0288kc m5622(Object obj) {
        if (C0453yj.m9996() < 0) {
            return m5617((C0286ka) obj);
        }
        return null;
    }

    public static String m5623(Object obj) {
        if (abe.m2321() < 0) {
            return m5611((C0286ka) obj);
        }
        return null;
    }

    public static C0272jn m5624(Object obj) {
        if (m5619() >= 0) {
            return m5616((C0287kb) obj);
        }
        return null;
    }

    public static C0271jm m5625(Object obj) {
        if (C0460zg.m11293() >= 0) {
            return m5618((C0286ka) obj);
        }
        return null;
    }

    public static C0273jo m5626(Object obj) {
        if (C0448yd.m9015() <= 0) {
            return m5615((C0287kb) obj);
        }
        return null;
    }

    public static C0273jo m5627(Object obj) {
        if (C0453yj.m9966() > 0) {
            return m5620((C0286ka) obj);
        }
        return null;
    }

    public C0287kb m875O(String str) {
        C0459zf.m11161(C0450yf.m9523(this), str);
        return this;
    }

    public C0287kb m876P(String str) {
        String strM1925 = str;
        if (strM1925 == null) {
            throw new NullPointerException(adds.m2875());
        }
        if (C0446yb.m8547(strM1925, true, 0, C0461zs.m11564(), 0, 3)) {
            strM1925 = abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0460zg.m11308()), abc.m1972(strM1925, 3)));
        } else if (C0446yb.m8547(strM1925, true, 0, C0452yh.m9786(), 0, 4)) {
            strM1925 = abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), abe.m2295()), abc.m1972(strM1925, 4)));
        }
        C0273jo c0273joM5614 = m5614(strM1925);
        if (c0273joM5614 == null) {
            throw new IllegalArgumentException(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0448yd.m9036()), strM1925)));
        }
        return C0458ze.m10923(this, c0273joM5614);
    }

    public C0287kb m877a(String str, @Nullable AbstractC0288kc abstractC0288kc) {
        if (str == null) {
            throw new NullPointerException(C0450yf.m9512());
        }
        if (gggy.m4397(str) == 0) {
            throw new IllegalArgumentException(abd.m2152());
        }
        if (abstractC0288kc != null && !m5613(str)) {
            throw new IllegalArgumentException(abc.m1925(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), adds.m2847()), str), adds.m2782())));
        }
        if (abstractC0288kc == null && C0461zs.m11502(str)) {
            throw new IllegalArgumentException(abc.m1925(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), adds.m2847()), str), C0458ze.m10902())));
        }
        this.f839nl = str;
        this.f838ni = abstractC0288kc;
        return this;
    }

    public C0287kb m878b(C0271jm c0271jm) {
        this.f841no = C0445ya.m8205(c0271jm);
        return this;
    }

    public C0287kb m879b(C0273jo c0273jo) {
        if (c0273jo == null) {
            throw new NullPointerException(adds.m2875());
        }
        this.f837ib = c0273jo;
        return this;
    }

    public C0286ka m880dj() {
        if (C0449ye.m9304(this) == null) {
            throw new IllegalStateException(adds.m2875());
        }
        return new C0286ka(this);
    }

    public C0287kb m881dk() {
        return C0445ya.m8297(this, C0453yj.m10028(), null);
    }

    public C0287kb m882l(String str, String str2) {
        C0448yd.m8954(C0450yf.m9523(this), str, str2);
        return this;
    }
}
