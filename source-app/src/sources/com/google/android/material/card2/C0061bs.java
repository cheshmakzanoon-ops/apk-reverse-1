package com.google.android.material.card2;

import java.util.AbstractSet;
import java.util.Iterator;

final class C0061bs<K> extends AbstractSet<K> {

    final C0057bo f94aX;

    C0061bs(C0057bo c0057bo) {
        this.f94aX = c0057bo;
    }

    public static int m3159(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return ((C0057bo) obj).f91aU;
        }
        return 0;
    }

    public static C0057bo m3160(Object obj) {
        if (C0457zc.m10735() < 0) {
            return m3167(obj);
        }
        return null;
    }

    public static C0057bo m3161(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return ((C0061bs) obj).f94aX;
        }
        return null;
    }

    public static C0064bv m3162(Object obj, Object obj2) {
        if (C0447yc.m8635() >= 0) {
            return m3166(obj, obj2);
        }
        return null;
    }

    public static int m3163(Object obj) {
        if (C0456zb.m10326() < 0) {
            return m3165(obj);
        }
        return 0;
    }

    public static C0064bv m3164(Object obj, Object obj2) {
        if (abf.m2510() < 0) {
            return ((C0057bo) obj).m311f(obj2);
        }
        return null;
    }

    public static int m3165(Object obj) {
        if (abf.m2500() > 0) {
            return m3159((C0057bo) obj);
        }
        return 0;
    }

    public static C0064bv m3166(Object obj, Object obj2) {
        if (C0457zc.m10718() <= 0) {
            return m3164((C0057bo) obj, obj2);
        }
        return null;
    }

    public static C0057bo m3167(Object obj) {
        if (gggy.m4365() > 0) {
            return m3161((C0061bs) obj);
        }
        return null;
    }

    @Override
    public void clear() {
        C0447yc.m8827(m3160(this));
    }

    @Override
    public boolean contains(Object obj) {
        return C0449ye.m9145(m3160(this), obj);
    }

    @Override
    public Iterator<K> iterator() {
        return new C0062bt(this);
    }

    @Override
    public boolean remove(Object obj) {
        return m3162(m3160(this), obj) != null;
    }

    @Override
    public int size() {
        return m3163(m3160(this));
    }
}
