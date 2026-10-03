package com.google.android.material.card2;

import java.util.Map;

class C0060br extends AbstractC0063bu {

    final C0059bq f93aW;

    C0060br(C0059bq c0059bq) {
        super(m3152(c0059bq));
        this.f93aW = c0059bq;
    }

    public static C0057bo m3149(Object obj) {
        if (C0448yd.m9079() <= 0) {
            return ((C0059bq) obj).f92aV;
        }
        return null;
    }

    public static C0064bv m3150(Object obj) {
        if (C0445ya.m8222() > 0) {
            return m3158(obj);
        }
        return null;
    }

    public static int m3151() {
        if (C0453yj.m10013() > 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static C0057bo m3152(Object obj) {
        if (C0448yd.m9079() < 0) {
            return m3156(obj);
        }
        return null;
    }

    public static C0064bv m3153(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return ((C0060br) obj).m315F();
        }
        return null;
    }

    public static Map.Entry m3154(Object obj) {
        if (abe.m2308() <= 0) {
            return ((C0060br) obj).m313E();
        }
        return null;
    }

    public static Map.Entry m3155(Object obj) {
        if (adds.m2755() >= 0) {
            return m3157(obj);
        }
        return null;
    }

    public static C0057bo m3156(Object obj) {
        if (C0453yj.m10032() > 0) {
            return m3149((C0059bq) obj);
        }
        return null;
    }

    public static Map.Entry m3157(Object obj) {
        if (abe.m2321() < 0) {
            return m3154((C0060br) obj);
        }
        return null;
    }

    public static C0064bv m3158(Object obj) {
        if (m3151() >= 0) {
            return m3153((C0060br) obj);
        }
        return null;
    }

    public Map.Entry<K, V> m313E() {
        return m3150(this);
    }

    @Override
    public Object next() {
        return m3155(this);
    }
}
