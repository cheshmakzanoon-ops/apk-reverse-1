package com.google.android.material.card2;

import java.util.Map;
import java.util.Set;

public final class C0444y extends AbstractC0441v {

    private final C0057bo<String, AbstractC0441v> f1357L = new C0057bo<>();

    public static C0057bo m8188(Object obj) {
        if (C0445ya.m8222() > 0) {
            return ((C0444y) obj).f1357L;
        }
        return null;
    }

    public static boolean m8189(Object obj, Object obj2) {
        if (adds.m2755() >= 0) {
            return C0598.m11879(obj, obj2);
        }
        return false;
    }

    public static C0057bo m8190(Object obj) {
        if (C0457zc.m10718() < 0) {
            return m8188((C0444y) obj);
        }
        return null;
    }

    public void m1513a(String str, AbstractC0441v abstractC0441v) {
        AbstractC0441v abstractC0441vM10823 = abstractC0441v;
        C0057bo c0057boM9403 = C0450yf.m9403(this);
        if (abstractC0441vM10823 == null) {
            abstractC0441vM10823 = C0458ze.m10823();
        }
        C0448yd.m9064(c0057boM9403, str, abstractC0441vM10823);
    }

    public Set<Map.Entry<String, AbstractC0441v>> entrySet() {
        return C0452yh.m9612(C0450yf.m9403(this));
    }

    public boolean equals(Object obj) {
        return obj == this || ((obj instanceof C0444y) && m8189(C0450yf.m9403((C0444y) obj), C0450yf.m9403(this)));
    }

    public int hashCode() {
        return C0449ye.m9233(C0450yf.m9403(this));
    }
}
