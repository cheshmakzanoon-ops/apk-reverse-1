package com.google.android.material.card2;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;

public class C0169fs<K, V> {

    private int f324aU;

    private final LinkedHashMap<K, V> f325fa;

    private int f326fb;

    private int f327fc;

    private int f328fd;

    private int f329fe;

    private int f330ff;

    public C0169fs(int i) {
        if (i <= 0) {
            throw new IllegalArgumentException(gggy.m4360());
        }
        this.f326fb = i;
        this.f325fa = new LinkedHashMap<>(0, 0.75f, true);
    }

    private int m491d(K k, V v) {
        int iM10441 = C0456zb.m10441(this, k, v);
        if (iM10441 < 0) {
            throw new IllegalStateException(abc.m1925(abd.m2090(C0460zg.m11407(abd.m2090(C0460zg.m11407(new StringBuilder(), C0460zg.m11385()), k), C0452yh.m9666()), v)));
        }
        return iM10441;
    }

    private void m492f(int i) {
        Object objM2338;
        Object objM10227;
        while (true) {
            synchronized (this) {
                if (C0446yb.m8546(this) < 0 || (m4052(abd.m2010(this)) && C0446yb.m8546(this) != 0)) {
                    break;
                }
                if (C0446yb.m8546(this) <= i || m4052(abd.m2010(this))) {
                    return;
                }
                Map.Entry entry = (Map.Entry) m4053(C0453yj.m9939(m4045(abd.m2010(this))));
                objM2338 = abe.m2338(entry);
                objM10227 = C0455za.m10227(entry);
                abd.m1997(abd.m2010(this), objM2338);
                this.f324aU = C0446yb.m8546(this) - C0453yj.m9838(this, objM2338, objM10227);
                this.f328fd = C0447yc.m8673(this) + 1;
            }
            adds.m2686(this, true, objM2338, objM10227, null);
        }
        throw new IllegalStateException(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0456zb.m10455(gggy.m4399(this))), C0456zb.m10469())));
    }

    public static int m4040(Object obj) {
        if (abc.m1845() < 0) {
            return ((C0169fs) obj).f330ff;
        }
        return 0;
    }

    public static void m4041(Object obj, int i) {
        if (abf.m2510() <= 0) {
            ((C0169fs) obj).m492f(i);
        }
    }

    public static int m4042(Object obj, Object obj2, Object obj3) {
        if (C0446yb.m8415() < 0) {
            return ((C0169fs) obj).mo490b(obj2, obj3);
        }
        return 0;
    }

    public static String m4043(Object obj, Object obj2) {
        if (abf.m2510() <= 0) {
            return C0598.m11903(obj, obj2);
        }
        return null;
    }

    public static int m4044(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return ((C0169fs) obj).f327fc;
        }
        return 0;
    }

    public static Set m4045(Object obj) {
        if (C0460zg.m11287() > 0) {
            return C0598.m11849(obj);
        }
        return null;
    }

    public static int m4046(Object obj) {
        if (C0458ze.m10932() >= 0) {
            return ((C0169fs) obj).f326fb;
        }
        return 0;
    }

    public static int m4047(Object obj) {
        if (C0448yd.m9079() <= 0) {
            return ((C0169fs) obj).f328fd;
        }
        return 0;
    }

    public static int m4048(Object obj) {
        if (C0457zc.m10735() <= 0) {
            return ((C0169fs) obj).f324aU;
        }
        return 0;
    }

    public static int m4049(Object obj, Object obj2, Object obj3) {
        if (C0453yj.m10013() >= 0) {
            return ((C0169fs) obj).m491d(obj2, obj3);
        }
        return 0;
    }

    public static int m4050(Object obj) {
        if (C0461zs.m11510() < 0) {
            return ((C0169fs) obj).f329fe;
        }
        return 0;
    }

    public static void m4051(Object obj, boolean z, Object obj2, Object obj3, Object obj4) {
        if (abf.m2510() < 0) {
            ((C0169fs) obj).m493a(z, obj2, obj3, obj4);
        }
    }

    public static boolean m4052(Object obj) {
        if (gggy.m4269() <= 0) {
            return C0598.m11899(obj);
        }
        return false;
    }

    public static Object m4053(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return C0598.m11882(obj);
        }
        return null;
    }

    public static LinkedHashMap m4054(Object obj) {
        if (C0445ya.m8222() > 0) {
            return ((C0169fs) obj).f325fa;
        }
        return null;
    }

    public static int m4055(Object obj) {
        if (C0453yj.m10032() > 0) {
            return m4044((C0169fs) obj);
        }
        return 0;
    }

    public static int m4056(Object obj) {
        if (C0448yd.m9074() < 0) {
            return m4047((C0169fs) obj);
        }
        return 0;
    }

    public static int m4057(Object obj, Object obj2, Object obj3) {
        if (C0459zf.m11053() >= 0) {
            return m4042((C0169fs) obj, obj2, obj3);
        }
        return 0;
    }

    public static void m4058(Object obj, int i) {
        if (C0457zc.m10718() < 0) {
            m4041((C0169fs) obj, i);
        }
    }

    public static int m4059(Object obj, Object obj2, Object obj3) {
        if (C0458ze.m10926() <= 0) {
            return m4049((C0169fs) obj, obj2, obj3);
        }
        return 0;
    }

    public static void m4060(Object obj, boolean z, Object obj2, Object obj3, Object obj4) {
        if (C0453yj.m9966() > 0) {
            m4051((C0169fs) obj, z, obj2, obj3, obj4);
        }
    }

    public static LinkedHashMap m4061(Object obj) {
        if (C0448yd.m9074() < 0) {
            return m4054((C0169fs) obj);
        }
        return null;
    }

    public static int m4062(Object obj) {
        if (C0445ya.m8330() >= 0) {
            return m4040((C0169fs) obj);
        }
        return 0;
    }

    public static int m4063(Object obj) {
        if (C0453yj.m10032() >= 0) {
            return m4046((C0169fs) obj);
        }
        return 0;
    }

    public static int m4064(Object obj) {
        if (C0459zf.m11053() > 0) {
            return m4048((C0169fs) obj);
        }
        return 0;
    }

    public static int m4065(Object obj) {
        if (C0457zc.m10555() >= 0) {
            return m4050((C0169fs) obj);
        }
        return 0;
    }

    protected void m493a(boolean z, K k, V v, V v2) {
    }

    protected int mo490b(K k, V v) {
        return 1;
    }

    public final V m494c(K k, V v) {
        V v2;
        if (k == null || v == null) {
            throw new NullPointerException(abe.m2279());
        }
        synchronized (this) {
            this.f327fc = C0457zc.m10549(this) + 1;
            this.f324aU = C0446yb.m8546(this) + C0453yj.m9838(this, k, v);
            v2 = (V) C0461zs.m11492(abd.m2010(this), k, v);
            if (v2 != null) {
                this.f324aU = C0446yb.m8546(this) - C0453yj.m9838(this, k, v2);
            }
        }
        if (v2 != null) {
            adds.m2686(this, false, k, v2, v);
        }
        C0445ya.m8258(this, C0450yf.m9428(this));
        return v2;
    }

    public final V m495i(K k) {
        V v;
        if (k == null) {
            throw new NullPointerException(C0460zg.m11257());
        }
        synchronized (this) {
            v = (V) abd.m1997(abd.m2010(this), k);
            if (v != null) {
                this.f324aU = C0446yb.m8546(this) - C0453yj.m9838(this, k, v);
            }
        }
        if (v != null) {
            adds.m2686(this, false, k, v, null);
        }
        return v;
    }

    public final synchronized String toString() {
        String strM4043;
        synchronized (this) {
            int iM11487 = C0461zs.m11487(this) + C0455za.m10119(this);
            strM4043 = m4043(C0455za.m10152(), new Object[]{abd.m2028(C0450yf.m9428(this)), abd.m2028(C0461zs.m11487(this)), abd.m2028(C0455za.m10119(this)), abd.m2028(iM11487 != 0 ? (C0461zs.m11487(this) * 100) / iM11487 : 0)});
        }
        return strM4043;
    }
}
