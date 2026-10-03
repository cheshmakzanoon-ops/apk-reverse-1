package com.google.android.material.card2;

import java.util.ArrayList;
import java.util.List;

public final class C0272jn {

    final List<String> f708lN = new ArrayList(20);

    private void m724g(String str, String str2) {
        if (str == null) {
            throw new NullPointerException(C0447yc.m8804());
        }
        if (C0460zg.m11421(str)) {
            throw new IllegalArgumentException(C0448yd.m9090());
        }
        int iM4397 = gggy.m4397(str);
        for (int i = 0; i < iM4397; i++) {
            char cM8419 = C0446yb.m8419(str, i);
            if (cM8419 <= ' ' || cM8419 >= 127) {
                throw new IllegalArgumentException(gggy.m4389(C0445ya.m8199(), new Object[]{abd.m2028(cM8419), abd.m2028(i), str}));
            }
        }
        if (str2 == null) {
            throw new NullPointerException(abc.m1925(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0455za.m10246()), str), adds.m2656())));
        }
        int iM4398 = gggy.m4397(str2);
        for (int i2 = 0; i2 < iM4398; i2++) {
            char cM84110 = C0446yb.m8419(str2, i2);
            if ((cM84110 <= 31 && cM84110 != '\t') || cM84110 >= 127) {
                throw new IllegalArgumentException(gggy.m4389(abf.m2413(), new Object[]{abd.m2028(cM84110), abd.m2028(i2), str, str2}));
            }
        }
    }

    public static int m5166(Object obj) {
        if (C0461zs.m11510() < 0) {
            return C0598.m11824(obj);
        }
        return 0;
    }

    public static void m5167(Object obj, Object obj2, Object obj3) {
        if (abd.m2162() >= 0) {
            ((C0272jn) obj).m724g((String) obj2, (String) obj3);
        }
    }

    public static C0272jn m5168(Object obj, Object obj2, Object obj3) {
        if (C0452yh.m9798() >= 0) {
            return ((C0272jn) obj).m727i((String) obj2, (String) obj3);
        }
        return null;
    }

    public static List m5169(Object obj) {
        if (C0453yj.m10013() > 0) {
            return ((C0272jn) obj).f708lN;
        }
        return null;
    }

    public static void m5170(Object obj, Object obj2, Object obj3) {
        if (C0453yj.m9966() > 0) {
            m5167((C0272jn) obj, (String) obj2, (String) obj3);
        }
    }

    public static List m5171(Object obj) {
        if (abe.m2321() <= 0) {
            return m5169((C0272jn) obj);
        }
        return null;
    }

    public static C0272jn m5172(Object obj, Object obj2, Object obj3) {
        if (C0457zc.m10718() <= 0) {
            return m5168((C0272jn) obj, (String) obj2, (String) obj3);
        }
        return null;
    }

    public C0271jm m725cm() {
        return new C0271jm(this);
    }

    public C0272jn m726h(String str, String str2) {
        gggy.m4441(this, str, str2);
        return C0450yf.m9353(this, str, str2);
    }

    C0272jn m727i(String str, String str2) {
        C0460zg.m11251(abd.m2139(this), str);
        C0460zg.m11251(abd.m2139(this), C0450yf.m9463(str2));
        return this;
    }

    public C0272jn m728j(String str, String str2) {
        gggy.m4441(this, str, str2);
        C0459zf.m11161(this, str);
        C0450yf.m9353(this, str, str2);
        return this;
    }

    C0272jn m729x(String str) {
        int iM8467 = C0446yb.m8467(str, C0449ye.m9248(), 1);
        if (iM8467 != -1) {
            return C0450yf.m9353(this, C0447yc.m8745(str, 0, iM8467), abc.m1972(str, iM8467 + 1));
        }
        return C0458ze.m10811(str, C0449ye.m9248()) ? C0450yf.m9353(this, gggy.m4277(), abc.m1972(str, 1)) : C0450yf.m9353(this, gggy.m4277(), str);
    }

    public C0272jn m730y(String str) {
        int i = 0;
        while (true) {
            int i2 = i;
            if (i2 >= m5166(abd.m2139(this))) {
                return this;
            }
            if (C0457zc.m10547(str, (String) gggy.m4400(abd.m2139(this), i2))) {
                abc.m1794(abd.m2139(this), i2);
                abc.m1794(abd.m2139(this), i2);
                i2 -= 2;
            }
            i = i2 + 2;
        }
    }
}
