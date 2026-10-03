package com.google.android.material.card2;

import java.util.Map;

final class C0064bv<K, V> implements Map.Entry<K, V> {

    V f100M;

    C0064bv<K, V> f101bb;

    int f102bd;

    final K f103be;

    C0064bv<K, V> f104bf;

    C0064bv<K, V> f105bg;

    C0064bv<K, V> f106bh;

    C0064bv<K, V> f107bi;

    C0064bv() {
        this.f103be = null;
        this.f106bh = this;
        this.f101bb = this;
    }

    C0064bv(C0064bv<K, V> c0064bv, K k, C0064bv<K, V> c0064bv2, C0064bv<K, V> c0064bv3) {
        this.f105bg = c0064bv;
        this.f103be = k;
        this.f102bd = 1;
        this.f101bb = c0064bv2;
        this.f106bh = c0064bv3;
        c0064bv3.f101bb = this;
        c0064bv2.f106bh = this;
    }

    public static Object m3201(Object obj) {
        if (abe.m2308() < 0) {
            return m316(obj);
        }
        return null;
    }

    public static C0064bv m3202(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return ((C0064bv) obj).f107bi;
        }
        return null;
    }

    public static int m3203() {
        if (C0451yg.m9580() > 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static Object m3204(Object obj) {
        if (C0448yd.m9079() < 0) {
            return ((C0064bv) obj).f103be;
        }
        return null;
    }

    public static Object m3205(Object obj) {
        if (C0459zf.m11062() > 0) {
            return ((C0064bv) obj).f100M;
        }
        return null;
    }

    public static C0064bv m3206(Object obj) {
        if (C0446yb.m8415() <= 0) {
            return ((C0064bv) obj).f104bf;
        }
        return null;
    }

    public static C0064bv m3207(Object obj) {
        if (gggy.m4269() < 0) {
            return m3210(obj);
        }
        return null;
    }

    public static Object m3208(Object obj) {
        if (C0459zf.m11062() >= 0) {
            return m3211(obj);
        }
        return null;
    }

    public static C0064bv m3209(Object obj) {
        if (C0448yd.m9079() < 0) {
            return m3212(obj);
        }
        return null;
    }

    public static C0064bv m3210(Object obj) {
        if (C0457zc.m10555() >= 0) {
            return m3202((C0064bv) obj);
        }
        return null;
    }

    public static Object m3211(Object obj) {
        if (C0448yd.m9074() <= 0) {
            return m3204((C0064bv) obj);
        }
        return null;
    }

    public static Object m316(Object obj) {
        if (m3203() > 0) {
            return m3205((C0064bv) obj);
        }
        return null;
    }

    public static C0064bv m3212(Object obj) {
        if (C0448yd.m9074() <= 0) {
            return m3206((C0064bv) obj);
        }
        return null;
    }

    public C0064bv<K, V> m317G() {
        C0064bv<K, V> c0064bv = this;
        for (C0064bv<K, V> c0064bvM3209 = m3209(c0064bv); c0064bvM3209 != null; c0064bvM3209 = m3209(c0064bvM3209)) {
            c0064bv = c0064bvM3209;
        }
        return c0064bv;
    }

    public C0064bv<K, V> m318H() {
        C0064bv<K, V> c0064bv = this;
        for (C0064bv<K, V> c0064bvM3207 = m3207(c0064bv); c0064bvM3207 != null; c0064bvM3207 = m3207(c0064bvM3207)) {
            c0064bv = c0064bvM3207;
        }
        return c0064bv;
    }

    @Override
    public boolean equals(Object obj) {
        if (!(obj instanceof Map.Entry)) {
            return false;
        }
        Map.Entry entry = (Map.Entry) obj;
        if (m3208(this) == null) {
            if (abe.m2338(entry) != null) {
                return false;
            }
        } else if (!C0459zf.m11147(m3208(this), abe.m2338(entry))) {
            return false;
        }
        if (m3201(this) == null) {
            if (C0455za.m10227(entry) != null) {
                return false;
            }
        } else if (!C0459zf.m11147(m3201(this), C0455za.m10227(entry))) {
            return false;
        }
        return true;
    }

    @Override
    public K getKey() {
        return (K) m3208(this);
    }

    @Override
    public V getValue() {
        return (V) m3201(this);
    }

    @Override
    public int hashCode() {
        return (m3208(this) == null ? 0 : C0446yb.m8544(m3208(this))) ^ (m3201(this) != null ? C0446yb.m8544(m3201(this)) : 0);
    }

    @Override
    public V setValue(V v) {
        V v2 = (V) m3201(this);
        this.f100M = v;
        return v2;
    }

    public String toString() {
        return abc.m1925(abd.m2090(C0460zg.m11407(abd.m2090(new StringBuilder(), m3208(this)), C0452yh.m9666()), m3201(this)));
    }
}
