package com.google.android.material.card2;

import java.util.AbstractSet;
import java.util.Iterator;
import java.util.Map;

class C0059bq<K, V> extends AbstractSet<Map.Entry<K, V>> {

    final C0057bo f92aV;

    C0059bq(C0057bo c0057bo) {
        this.f92aV = c0057bo;
    }

    public static int m3137(Object obj) {
        if (adds.m2755() > 0) {
            return m3147(obj);
        }
        return 0;
    }

    public static C0064bv m3138(Object obj, Object obj2) {
        if (adds.m2755() > 0) {
            return ((C0057bo) obj).m308a((Map.Entry<?, ?>) obj2);
        }
        return null;
    }

    public static C0057bo m3139(Object obj) {
        if (C0459zf.m11062() > 0) {
            return ((C0059bq) obj).f92aV;
        }
        return null;
    }

    public static C0064bv m3140(Object obj, Object obj2) {
        if (C0445ya.m8222() >= 0) {
            return m3146(obj, obj2);
        }
        return null;
    }

    public static void m3141(Object obj, Object obj2, boolean z) {
        if (abf.m2510() <= 0) {
            ((C0057bo) obj).m309b((C0064bv) obj2, z);
        }
    }

    public static void m3142(Object obj, Object obj2, boolean z) {
        if (abc.m1845() < 0) {
            m3145(obj, obj2, z);
        }
    }

    public static C0057bo m3143(Object obj) {
        if (C0457zc.m10735() < 0) {
            return m3148(obj);
        }
        return null;
    }

    public static int m3144(Object obj) {
        if (abe.m2308() < 0) {
            return ((C0057bo) obj).f91aU;
        }
        return 0;
    }

    public static void m3145(Object obj, Object obj2, boolean z) {
        if (abe.m2321() <= 0) {
            m3141((C0057bo) obj, (C0064bv) obj2, z);
        }
    }

    public static C0064bv m3146(Object obj, Object obj2) {
        if (C0456zb.m10484() <= 0) {
            return m3138((C0057bo) obj, (Map.Entry) obj2);
        }
        return null;
    }

    public static int m3147(Object obj) {
        if (C0453yj.m9966() >= 0) {
            return m3144((C0057bo) obj);
        }
        return 0;
    }

    public static C0057bo m3148(Object obj) {
        if (abd.m2166() <= 0) {
            return m3139((C0059bq) obj);
        }
        return null;
    }

    @Override
    public void clear() {
        C0447yc.m8827(m3143(this));
    }

    @Override
    public boolean contains(Object obj) {
        return (obj instanceof Map.Entry) && m3140(m3143(this), (Map.Entry) obj) != null;
    }

    @Override
    public Iterator<Map.Entry<K, V>> iterator() {
        return new C0060br(this);
    }

    @Override
    public boolean remove(Object obj) {
        C0064bv c0064bvM3140;
        if (!(obj instanceof Map.Entry) || (c0064bvM3140 = m3140(m3143(this), (Map.Entry) obj)) == null) {
            return false;
        }
        m3142(m3143(this), c0064bvM3140, true);
        return true;
    }

    @Override
    public int size() {
        return m3137(m3143(this));
    }
}
