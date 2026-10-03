package com.google.android.material.card2;

import java.io.Serializable;
import java.util.AbstractMap;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;

public final class C0057bo<K, V> extends AbstractMap<K, V> implements Serializable {

    static final boolean f83aM;

    private static final Comparator<Comparable> f84aN;

    Comparator<? super K> f85aO;

    private C0059bq f86aP;

    final C0064bv<K, V> f87aQ;

    private C0061bs f88aR;

    int f89aS;

    C0064bv<K, V> f90aT;

    int f91aU;

    static {
        f83aM = !C0460zg.m11342(C0057bo.class);
        f84aN = new C0058bp();
    }

    public C0057bo() {
        this(C0445ya.m8211());
    }

    public C0057bo(Comparator<? super K> comparator) {
        Comparator<? super K> comparator2 = comparator;
        this.f91aU = 0;
        this.f89aS = 0;
        this.f87aQ = new C0064bv<>();
        this.f85aO = comparator2 == null ? C0445ya.m8211() : comparator2;
    }

    private void m302a(C0064bv<K, V> c0064bv) {
        C0064bv c0064bvM3100 = m3100(c0064bv);
        C0064bv<K, V> c0064bvM3081 = m3081(c0064bv);
        C0064bv<K, V> c0064bvM3101 = m3100(c0064bvM3081);
        C0064bv c0064bvM3082 = m3081(c0064bvM3081);
        c0064bv.f107bi = c0064bvM3101;
        if (c0064bvM3101 != null) {
            c0064bvM3101.f105bg = c0064bv;
        }
        C0452yh.m9681(this, c0064bv, c0064bvM3081);
        c0064bvM3081.f104bf = c0064bv;
        c0064bv.f105bg = c0064bvM3081;
        c0064bv.f102bd = abe.m2377(c0064bvM3100 != null ? C0446yb.m8584(c0064bvM3100) : 0, c0064bvM3101 != null ? C0446yb.m8584(c0064bvM3101) : 0) + 1;
        c0064bvM3081.f102bd = abe.m2377(C0446yb.m8584(c0064bv), c0064bvM3082 != null ? C0446yb.m8584(c0064bvM3082) : 0) + 1;
    }

    private void m303a(C0064bv<K, V> c0064bv, C0064bv<K, V> c0064bv2) {
        C0064bv<K, V> c0064bvM3066 = m3066(c0064bv);
        c0064bv.f105bg = null;
        if (c0064bv2 != null) {
            c0064bv2.f105bg = c0064bvM3066;
        }
        if (c0064bvM3066 == null) {
            this.f90aT = c0064bv2;
            return;
        }
        if (m3100(c0064bvM3066) == c0064bv) {
            c0064bvM3066.f104bf = c0064bv2;
        } else {
            if (!gggy.m4499() && m3081(c0064bvM3066) != c0064bv) {
                throw new AssertionError();
            }
            c0064bvM3066.f107bi = c0064bv2;
        }
    }

    private void m304a(C0064bv<K, V> c0064bv, boolean z) {
        for (C0064bv<K, V> c0064bvM3066 = c0064bv; c0064bvM3066 != null; c0064bvM3066 = m3066(c0064bvM3066)) {
            C0064bv c0064bvM3100 = m3100(c0064bvM3066);
            C0064bv c0064bvM3081 = m3081(c0064bvM3066);
            int iM8584 = c0064bvM3100 != null ? C0446yb.m8584(c0064bvM3100) : 0;
            int iM8585 = c0064bvM3081 != null ? C0446yb.m8584(c0064bvM3081) : 0;
            int i = iM8584 - iM8585;
            if (i == -2) {
                C0064bv c0064bvM3101 = m3100(c0064bvM3081);
                C0064bv c0064bvM3082 = m3081(c0064bvM3081);
                int iM8586 = (c0064bvM3101 != null ? C0446yb.m8584(c0064bvM3101) : 0) - (c0064bvM3082 != null ? C0446yb.m8584(c0064bvM3082) : 0);
                if (iM8586 == -1 || (iM8586 == 0 && !z)) {
                    gggy.m4349(this, c0064bvM3066);
                } else {
                    if (!gggy.m4499() && iM8586 != 1) {
                        throw new AssertionError();
                    }
                    C0457zc.m10729(this, c0064bvM3081);
                    gggy.m4349(this, c0064bvM3066);
                }
                if (z) {
                    return;
                }
            } else if (i == 2) {
                C0064bv c0064bvM3102 = m3100(c0064bvM3100);
                C0064bv c0064bvM3083 = m3081(c0064bvM3100);
                int iM8587 = (c0064bvM3102 != null ? C0446yb.m8584(c0064bvM3102) : 0) - (c0064bvM3083 != null ? C0446yb.m8584(c0064bvM3083) : 0);
                if (iM8587 == 1 || (iM8587 == 0 && !z)) {
                    C0457zc.m10729(this, c0064bvM3066);
                } else {
                    if (!gggy.m4499() && iM8587 != -1) {
                        throw new AssertionError();
                    }
                    gggy.m4349(this, c0064bvM3100);
                    C0457zc.m10729(this, c0064bvM3066);
                }
                if (z) {
                    return;
                }
            } else if (i == 0) {
                c0064bvM3066.f102bd = iM8584 + 1;
                if (z) {
                    return;
                }
            } else {
                if (!gggy.m4499() && i != -1 && i != 1) {
                    throw new AssertionError();
                }
                c0064bvM3066.f102bd = abe.m2377(iM8584, iM8585) + 1;
                if (!z) {
                    return;
                }
            }
        }
    }

    private boolean m305a(Object obj, Object obj2) {
        return obj == obj2 || (obj != null && C0459zf.m11147(obj, obj2));
    }

    private void m306b(C0064bv<K, V> c0064bv) {
        C0064bv<K, V> c0064bvM3100 = m3100(c0064bv);
        C0064bv c0064bvM3081 = m3081(c0064bv);
        C0064bv c0064bvM3101 = m3100(c0064bvM3100);
        C0064bv<K, V> c0064bvM3082 = m3081(c0064bvM3100);
        c0064bv.f104bf = c0064bvM3082;
        if (c0064bvM3082 != null) {
            c0064bvM3082.f105bg = c0064bv;
        }
        C0452yh.m9681(this, c0064bv, c0064bvM3100);
        c0064bvM3100.f107bi = c0064bv;
        c0064bv.f105bg = c0064bvM3100;
        c0064bv.f102bd = abe.m2377(c0064bvM3081 != null ? C0446yb.m8584(c0064bvM3081) : 0, c0064bvM3082 != null ? C0446yb.m8584(c0064bvM3082) : 0) + 1;
        c0064bvM3100.f102bd = abe.m2377(C0446yb.m8584(c0064bv), c0064bvM3101 != null ? C0446yb.m8584(c0064bvM3101) : 0) + 1;
    }

    private Object writeReplace() {
        return new LinkedHashMap(this);
    }

    public static Object m3063(Object obj) {
        if (C0453yj.m10013() >= 0) {
            return ((C0064bv) obj).f100M;
        }
        return null;
    }

    public static C0064bv m3064(Object obj) {
        if (C0461zs.m11510() < 0) {
            return m3119(obj);
        }
        return null;
    }

    public static C0064bv m3065(Object obj, Object obj2) {
        if (C0445ya.m8222() >= 0) {
            return m3115(obj, obj2);
        }
        return null;
    }

    public static C0064bv m3066(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return m3129(obj);
        }
        return null;
    }

    public static C0064bv m3067(Object obj, Object obj2) {
        if (C0449ye.m9220() <= 0) {
            return ((C0057bo) obj).m310e(obj2);
        }
        return null;
    }

    public static boolean m3068(Object obj, Object obj2, Object obj3) {
        if (C0459zf.m11062() > 0) {
            return ((C0057bo) obj).m305a(obj2, obj3);
        }
        return false;
    }

    public static Comparator m3069(Object obj) {
        if (C0450yf.m9352() <= 0) {
            return ((C0057bo) obj).f85aO;
        }
        return null;
    }

    public static void m3070(Object obj, Object obj2) {
        if (abe.m2308() < 0) {
            ((C0057bo) obj).m306b((C0064bv) obj2);
        }
    }

    public static C0064bv m3071(Object obj) {
        if (C0456zb.m10326() < 0) {
            return m3118(obj);
        }
        return null;
    }

    public static C0059bq m3072(Object obj) {
        if (C0448yd.m9079() <= 0) {
            return ((C0057bo) obj).f86aP;
        }
        return null;
    }

    public static C0064bv m3073(Object obj) {
        if (abe.m2308() <= 0) {
            return ((C0057bo) obj).f90aT;
        }
        return null;
    }

    public static void m3074(Object obj, Object obj2, boolean z) {
        if (C0459zf.m11062() > 0) {
            ((C0057bo) obj).m309b((C0064bv) obj2, z);
        }
    }

    public static int m3075() {
        if (C0451yg.m9580() >= 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static boolean m3076() {
        if (abf.m2510() <= 0) {
            return f83aM;
        }
        return false;
    }

    public static C0059bq m3077(Object obj) {
        if (C0445ya.m8222() > 0) {
            return m3120(obj);
        }
        return null;
    }

    public static C0064bv m3078(Object obj) {
        if (abe.m2308() <= 0) {
            return ((C0064bv) obj).f106bh;
        }
        return null;
    }

    public static C0064bv m3079(Object obj, Object obj2) {
        if (abd.m2162() > 0) {
            return ((C0057bo) obj).m311f(obj2);
        }
        return null;
    }

    public static C0064bv m3080(Object obj, Object obj2, boolean z) {
        if (adds.m2755() >= 0) {
            return m3125(obj, obj2, z);
        }
        return null;
    }

    public static C0064bv m3081(Object obj) {
        if (adds.m2755() >= 0) {
            return m3124(obj);
        }
        return null;
    }

    public static void m3082(Object obj, Object obj2, Object obj3) {
        if (abf.m2510() < 0) {
            ((C0057bo) obj).m303a((C0064bv) obj2, (C0064bv) obj3);
        }
    }

    public static int m3083(Object obj) {
        if (adds.m2755() >= 0) {
            return ((C0064bv) obj).f102bd;
        }
        return 0;
    }

    public static Object m3084(Object obj) {
        if (abc.m1845() <= 0) {
            return ((C0064bv) obj).f103be;
        }
        return null;
    }

    public static C0064bv m3085(Object obj, Object obj2) {
        if (C0453yj.m10013() >= 0) {
            return m3117(obj, obj2);
        }
        return null;
    }

    public static int m3086(Object obj) {
        if (C0446yb.m8415() <= 0) {
            return ((C0057bo) obj).f89aS;
        }
        return 0;
    }

    public static C0064bv m3087(Object obj) {
        if (C0461zs.m11510() < 0) {
            return ((C0064bv) obj).f107bi;
        }
        return null;
    }

    public static C0064bv m3088(Object obj) {
        if (C0447yc.m8635() > 0) {
            return m3110(obj);
        }
        return null;
    }

    public static C0061bs m3089(Object obj) {
        if (gggy.m4269() <= 0) {
            return m3123(obj);
        }
        return null;
    }

    public static void m3090(Object obj, Object obj2, boolean z) {
        if (abc.m1845() < 0) {
            ((C0057bo) obj).m304a((C0064bv) obj2, z);
        }
    }

    public static C0064bv m3091(Object obj) {
        if (C0451yg.m9580() > 0) {
            return ((C0064bv) obj).f104bf;
        }
        return null;
    }

    public static C0064bv m3092(Object obj) {
        if (gggy.m4269() < 0) {
            return ((C0057bo) obj).f87aQ;
        }
        return null;
    }

    public static C0064bv m3093(Object obj) {
        if (C0453yj.m10013() > 0) {
            return ((C0064bv) obj).f105bg;
        }
        return null;
    }

    public static void m3094(Object obj, Object obj2) {
        if (C0458ze.m10932() > 0) {
            ((C0057bo) obj).m302a((C0064bv) obj2);
        }
    }

    public static C0064bv m3095(Object obj) {
        if (C0453yj.m10013() > 0) {
            return ((C0064bv) obj).m317G();
        }
        return null;
    }

    public static C0064bv m3096(Object obj) {
        if (C0450yf.m9352() <= 0) {
            return m3111(obj);
        }
        return null;
    }

    public static C0064bv m3097(Object obj) {
        if (C0445ya.m8222() > 0) {
            return ((C0064bv) obj).f101bb;
        }
        return null;
    }

    public static C0064bv m3098(Object obj) {
        if (C0450yf.m9352() <= 0) {
            return m3112(obj);
        }
        return null;
    }

    public static C0064bv m3099(Object obj, Object obj2, boolean z) {
        if (C0459zf.m11062() >= 0) {
            return ((C0057bo) obj).m307a(obj2, z);
        }
        return null;
    }

    public static C0064bv m3100(Object obj) {
        if (abd.m2162() > 0) {
            return m3133(obj);
        }
        return null;
    }

    public static Comparator m3101() {
        if (abe.m2308() < 0) {
            return f84aN;
        }
        return null;
    }

    public static int m3102(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return ((C0057bo) obj).f91aU;
        }
        return 0;
    }

    public static C0061bs m3103(Object obj) {
        if (gggy.m4269() <= 0) {
            return ((C0057bo) obj).f88aR;
        }
        return null;
    }

    public static C0064bv m3104(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return m3113(obj);
        }
        return null;
    }

    public static C0064bv m3105(Object obj) {
        if (C0452yh.m9798() >= 0) {
            return ((C0064bv) obj).m318H();
        }
        return null;
    }

    public static Object m3106(Object obj) {
        if (C0456zb.m10484() <= 0) {
            return m3063((C0064bv) obj);
        }
        return null;
    }

    public static int m3107(Object obj) {
        if (abf.m2500() >= 0) {
            return m3086((C0057bo) obj);
        }
        return 0;
    }

    public static void m3108(Object obj, Object obj2, boolean z) {
        if (C0457zc.m10718() <= 0) {
            m3090((C0057bo) obj, (C0064bv) obj2, z);
        }
    }

    public static void m3109(Object obj, Object obj2) {
        if (C0447yc.m8786() > 0) {
            m3094((C0057bo) obj, (C0064bv) obj2);
        }
    }

    public static C0064bv m3110(Object obj) {
        if (abf.m2500() >= 0) {
            return m3092((C0057bo) obj);
        }
        return null;
    }

    public static C0064bv m3111(Object obj) {
        if (C0456zb.m10484() < 0) {
            return m3078((C0064bv) obj);
        }
        return null;
    }

    public static C0064bv m3112(Object obj) {
        if (abd.m2166() <= 0) {
            return m3073((C0057bo) obj);
        }
        return null;
    }

    public static C0064bv m3113(Object obj) {
        if (C0453yj.m9966() > 0) {
            return m3097((C0064bv) obj);
        }
        return null;
    }

    public static int m3114(Object obj) {
        if (abf.m2500() > 0) {
            return m3083((C0064bv) obj);
        }
        return 0;
    }

    public static C0064bv m3115(Object obj, Object obj2) {
        if (C0459zf.m11053() >= 0) {
            return m3067((C0057bo) obj, obj2);
        }
        return null;
    }

    public static Comparator m3116(Object obj) {
        if (abd.m2166() < 0) {
            return m3069((C0057bo) obj);
        }
        return null;
    }

    public static C0064bv m3117(Object obj, Object obj2) {
        if (C0453yj.m10032() >= 0) {
            return m3079((C0057bo) obj, obj2);
        }
        return null;
    }

    public static C0064bv m3118(Object obj) {
        if (abd.m2166() <= 0) {
            return m3105((C0064bv) obj);
        }
        return null;
    }

    public static C0064bv m3119(Object obj) {
        if (C0460zg.m11293() >= 0) {
            return m3095((C0064bv) obj);
        }
        return null;
    }

    public static C0059bq m3120(Object obj) {
        if (C0457zc.m10718() < 0) {
            return m3072((C0057bo) obj);
        }
        return null;
    }

    public static boolean m3121(Object obj, Object obj2, Object obj3) {
        if (C0456zb.m10484() < 0) {
            return m3068((C0057bo) obj, obj2, obj3);
        }
        return false;
    }

    public static int m3122(Object obj) {
        if (abd.m2166() < 0) {
            return m3102((C0057bo) obj);
        }
        return 0;
    }

    public static C0061bs m3123(Object obj) {
        if (C0458ze.m10926() < 0) {
            return m3103((C0057bo) obj);
        }
        return null;
    }

    public static C0064bv m3124(Object obj) {
        if (abd.m2166() <= 0) {
            return m3087((C0064bv) obj);
        }
        return null;
    }

    public static C0064bv m3125(Object obj, Object obj2, boolean z) {
        if (C0453yj.m10032() > 0) {
            return m3099((C0057bo) obj, obj2, z);
        }
        return null;
    }

    public static Object m3126(Object obj) {
        if (C0448yd.m9015() <= 0) {
            return m3084((C0064bv) obj);
        }
        return null;
    }

    public static boolean m3127() {
        if (m3075() >= 0) {
            return m3076();
        }
        return false;
    }

    public static void m3128(Object obj, Object obj2, boolean z) {
        if (abf.m2500() >= 0) {
            m3074((C0057bo) obj, (C0064bv) obj2, z);
        }
    }

    public static C0064bv m3129(Object obj) {
        if (C0448yd.m9015() <= 0) {
            return m3093((C0064bv) obj);
        }
        return null;
    }

    public static void m3130(Object obj, Object obj2) {
        if (C0456zb.m10484() < 0) {
            m3070((C0057bo) obj, (C0064bv) obj2);
        }
    }

    public static void m3131(Object obj, Object obj2, Object obj3) {
        if (C0456zb.m10484() < 0) {
            m3082((C0057bo) obj, (C0064bv) obj2, (C0064bv) obj3);
        }
    }

    public static Comparator m3132() {
        if (abd.m2021() > 0) {
            return m3101();
        }
        return null;
    }

    public static C0064bv m3133(Object obj) {
        if (C0453yj.m9945() < 0) {
            return m3091((C0064bv) obj);
        }
        return null;
    }

    C0064bv<K, V> m307a(K k, boolean z) {
        int i;
        C0064bv<K, V> c0064bv;
        Comparator comparatorM9846 = C0453yj.m9846(this);
        C0064bv<K, V> c0064bvM3098 = m3098(this);
        if (c0064bvM3098 != null) {
            Comparable comparable = comparatorM9846 == C0445ya.m8211() ? (Comparable) k : null;
            while (true) {
                int iM10734 = comparable != null ? C0457zc.m10734(comparable, abc.m1893(c0064bvM3098)) : C0449ye.m9315(comparatorM9846, k, abc.m1893(c0064bvM3098));
                if (iM10734 == 0) {
                    return c0064bvM3098;
                }
                C0064bv<K, V> c0064bvM3100 = iM10734 < 0 ? m3100(c0064bvM3098) : m3081(c0064bvM3098);
                if (c0064bvM3100 == null) {
                    i = iM10734;
                    break;
                }
                c0064bvM3098 = c0064bvM3100;
            }
        } else {
            i = 0;
        }
        if (!z) {
            return null;
        }
        C0064bv c0064bvM3088 = m3088(this);
        if (c0064bvM3098 != null) {
            c0064bv = new C0064bv<>(c0064bvM3098, k, c0064bvM3088, m3096(c0064bvM3088));
            if (i < 0) {
                c0064bvM3098.f104bf = c0064bv;
            } else {
                c0064bvM3098.f107bi = c0064bv;
            }
            adds.m2843(this, c0064bvM3098, true);
        } else {
            if (comparatorM9846 == C0445ya.m8211() && !(k instanceof Comparable)) {
                throw new ClassCastException(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0456zb.m10455(gggy.m4399(k))), C0456zb.m10356())));
            }
            c0064bv = new C0064bv<>(c0064bvM3098, k, c0064bvM3088, m3096(c0064bvM3088));
            this.f90aT = c0064bv;
        }
        this.f91aU = C0453yj.m9991(this) + 1;
        this.f89aS = abe.m2292(this) + 1;
        return c0064bv;
    }

    C0064bv<K, V> m308a(Map.Entry<?, ?> entry) {
        C0064bv<K, V> c0064bvM3065 = m3065(this, abe.m2338(entry));
        if (c0064bvM3065 != null && abf.m2535(this, C0457zc.m10715(c0064bvM3065), C0455za.m10227(entry))) {
            return c0064bvM3065;
        }
        return null;
    }

    void m309b(C0064bv<K, V> c0064bv, boolean z) {
        int iM8584;
        int iM8585 = 0;
        if (z) {
            m3096(c0064bv).f101bb = m3104(c0064bv);
            m3104(c0064bv).f106bh = m3096(c0064bv);
        }
        C0064bv c0064bvM3100 = m3100(c0064bv);
        C0064bv c0064bvM3081 = m3081(c0064bv);
        C0064bv c0064bvM3066 = m3066(c0064bv);
        if (c0064bvM3100 == null || c0064bvM3081 == null) {
            if (c0064bvM3100 != null) {
                C0452yh.m9681(this, c0064bv, c0064bvM3100);
                c0064bv.f104bf = null;
            } else if (c0064bvM3081 != null) {
                C0452yh.m9681(this, c0064bv, c0064bvM3081);
                c0064bv.f107bi = null;
            } else {
                C0452yh.m9681(this, c0064bv, null);
            }
            adds.m2843(this, c0064bvM3066, false);
            this.f91aU = C0453yj.m9991(this) - 1;
            this.f89aS = abe.m2292(this) + 1;
            return;
        }
        C0064bv<K, V> c0064bvM3071 = C0446yb.m8584(c0064bvM3100) > C0446yb.m8584(c0064bvM3081) ? m3071(c0064bvM3100) : m3064(c0064bvM3081);
        C0455za.m10217(this, c0064bvM3071, false);
        C0064bv<K, V> c0064bvM3101 = m3100(c0064bv);
        if (c0064bvM3101 != null) {
            iM8584 = C0446yb.m8584(c0064bvM3101);
            c0064bvM3071.f104bf = c0064bvM3101;
            c0064bvM3101.f105bg = c0064bvM3071;
            c0064bv.f104bf = null;
        } else {
            iM8584 = 0;
        }
        C0064bv<K, V> c0064bvM3082 = m3081(c0064bv);
        if (c0064bvM3082 != null) {
            iM8585 = C0446yb.m8584(c0064bvM3082);
            c0064bvM3071.f107bi = c0064bvM3082;
            c0064bvM3082.f105bg = c0064bvM3071;
            c0064bv.f107bi = null;
        }
        c0064bvM3071.f102bd = abe.m2377(iM8584, iM8585) + 1;
        C0452yh.m9681(this, c0064bv, c0064bvM3071);
    }

    @Override
    public void clear() {
        this.f90aT = null;
        this.f91aU = 0;
        this.f89aS = abe.m2292(this) + 1;
        C0064bv<K, V> c0064bvM3088 = m3088(this);
        c0064bvM3088.f106bh = c0064bvM3088;
        c0064bvM3088.f101bb = c0064bvM3088;
    }

    @Override
    public boolean containsKey(Object obj) {
        return m3065(this, obj) != null;
    }

    C0064bv<K, V> m310e(Object obj) {
        if (obj == null) {
            return null;
        }
        try {
            return m3080(this, obj, false);
        } catch (ClassCastException e) {
            return null;
        }
    }

    @Override
    public Set<Map.Entry<K, V>> entrySet() {
        C0059bq c0059bqM3077 = m3077(this);
        if (c0059bqM3077 != null) {
            return c0059bqM3077;
        }
        C0059bq c0059bq = new C0059bq(this);
        this.f86aP = c0059bq;
        return c0059bq;
    }

    C0064bv<K, V> m311f(Object obj) {
        C0064bv<K, V> c0064bvM3065 = m3065(this, obj);
        if (c0064bvM3065 != null) {
            C0455za.m10217(this, c0064bvM3065, true);
        }
        return c0064bvM3065;
    }

    @Override
    public V get(Object obj) {
        C0064bv c0064bvM3065 = m3065(this, obj);
        if (c0064bvM3065 != null) {
            return (V) C0457zc.m10715(c0064bvM3065);
        }
        return null;
    }

    @Override
    public Set<K> keySet() {
        C0061bs c0061bsM3089 = m3089(this);
        if (c0061bsM3089 != null) {
            return c0061bsM3089;
        }
        C0061bs c0061bs = new C0061bs(this);
        this.f88aR = c0061bs;
        return c0061bs;
    }

    @Override
    public V put(K k, V v) {
        if (k == null) {
            throw new NullPointerException(C0460zg.m11257());
        }
        C0064bv c0064bvM3080 = m3080(this, k, true);
        V v2 = (V) C0457zc.m10715(c0064bvM3080);
        c0064bvM3080.f100M = v;
        return v2;
    }

    @Override
    public V remove(Object obj) {
        C0064bv c0064bvM3085 = m3085(this, obj);
        if (c0064bvM3085 != null) {
            return (V) C0457zc.m10715(c0064bvM3085);
        }
        return null;
    }

    @Override
    public int size() {
        return C0453yj.m9991(this);
    }
}
