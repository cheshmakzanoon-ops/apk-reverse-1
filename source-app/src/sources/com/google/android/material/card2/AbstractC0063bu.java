package com.google.android.material.card2;

import java.util.ConcurrentModificationException;
import java.util.Iterator;
import java.util.NoSuchElementException;

abstract class AbstractC0063bu<T> implements Iterator<T> {

    final C0057bo f99bc;

    C0064bv<K, V> f98bb = m3179(m3182(m3186(this)));

    C0064bv<K, V> f97ba = null;

    int f96aZ = m3181(m3186(this));

    AbstractC0063bu(C0057bo c0057bo) {
        this.f99bc = c0057bo;
    }

    public static C0064bv m3177(Object obj) {
        if (abf.m2510() < 0) {
            return ((C0064bv) obj).f101bb;
        }
        return null;
    }

    public static int m3178() {
        if (abf.m2510() <= 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static C0064bv m3179(Object obj) {
        if (C0449ye.m9220() < 0) {
            return m3198(obj);
        }
        return null;
    }

    public static int m3180(Object obj) {
        if (C0459zf.m11062() >= 0) {
            return m3195(obj);
        }
        return 0;
    }

    public static int m3181(Object obj) {
        if (abd.m2162() > 0) {
            return m314(obj);
        }
        return 0;
    }

    public static C0064bv m3182(Object obj) {
        if (abf.m2510() <= 0) {
            return m3200(obj);
        }
        return null;
    }

    public static int m3183(Object obj) {
        if (C0448yd.m9079() <= 0) {
            return ((AbstractC0063bu) obj).f96aZ;
        }
        return 0;
    }

    public static C0064bv m3184(Object obj) {
        if (C0453yj.m10013() >= 0) {
            return m3197(obj);
        }
        return null;
    }

    public static C0064bv m3185(Object obj) {
        if (C0448yd.m9079() < 0) {
            return ((AbstractC0063bu) obj).f97ba;
        }
        return null;
    }

    public static C0057bo m3186(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return m3194(obj);
        }
        return null;
    }

    public static int m3187(Object obj) {
        if (C0458ze.m10932() >= 0) {
            return ((C0057bo) obj).f89aS;
        }
        return 0;
    }

    public static C0057bo m3188(Object obj) {
        if (C0452yh.m9798() >= 0) {
            return ((AbstractC0063bu) obj).f99bc;
        }
        return null;
    }

    public static C0064bv m3189(Object obj) {
        if (C0453yj.m10013() >= 0) {
            return ((C0057bo) obj).f87aQ;
        }
        return null;
    }

    public static C0064bv m3190(Object obj) {
        if (adds.m2755() >= 0) {
            return ((AbstractC0063bu) obj).f98bb;
        }
        return null;
    }

    public static void m3191(Object obj, Object obj2, boolean z) {
        if (C0445ya.m8222() > 0) {
            m3199(obj, obj2, z);
        }
    }

    public static void m3192(Object obj, Object obj2, boolean z) {
        if (C0451yg.m9580() > 0) {
            ((C0057bo) obj).m309b((C0064bv) obj2, z);
        }
    }

    public static C0064bv m3193(Object obj) {
        if (C0445ya.m8222() > 0) {
            return m3196(obj);
        }
        return null;
    }

    public static C0057bo m3194(Object obj) {
        if (C0448yd.m9015() < 0) {
            return m3188((AbstractC0063bu) obj);
        }
        return null;
    }

    public static int m3195(Object obj) {
        if (C0457zc.m10718() <= 0) {
            return m3183((AbstractC0063bu) obj);
        }
        return 0;
    }

    public static C0064bv m3196(Object obj) {
        if (C0458ze.m10926() < 0) {
            return m3185((AbstractC0063bu) obj);
        }
        return null;
    }

    public static C0064bv m3197(Object obj) {
        if (abe.m2321() <= 0) {
            return m3190((AbstractC0063bu) obj);
        }
        return null;
    }

    public static C0064bv m3198(Object obj) {
        if (m3178() > 0) {
            return m3177((C0064bv) obj);
        }
        return null;
    }

    public static int m314(Object obj) {
        if (C0453yj.m10032() >= 0) {
            return m3187((C0057bo) obj);
        }
        return 0;
    }

    public static void m3199(Object obj, Object obj2, boolean z) {
        if (m3178() > 0) {
            m3192((C0057bo) obj, (C0064bv) obj2, z);
        }
    }

    public static C0064bv m3200(Object obj) {
        if (C0445ya.m8330() > 0) {
            return m3189((C0057bo) obj);
        }
        return null;
    }

    final C0064bv<K, V> m315F() {
        C0064bv c0064bvM3184 = m3184(this);
        if (c0064bvM3184 == m3182(m3186(this))) {
            throw new NoSuchElementException();
        }
        if (m3181(m3186(this)) != m3180(this)) {
            throw new ConcurrentModificationException();
        }
        this.f98bb = m3179(c0064bvM3184);
        this.f97ba = c0064bvM3184;
        return c0064bvM3184;
    }

    @Override
    public final boolean hasNext() {
        return m3184(this) != m3182(m3186(this));
    }

    @Override
    public final void remove() {
        if (m3193(this) == null) {
            throw new IllegalStateException();
        }
        m3191(m3186(this), m3193(this), true);
        this.f97ba = null;
        this.f96aZ = m3181(m3186(this));
    }
}
