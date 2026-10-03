package com.google.android.material.card2;

import java.util.LinkedHashSet;
import java.util.Set;

public final class C0315lc {

    private final Set<C0294ki> f972pz = new LinkedHashSet();

    public static Set m6007(Object obj) {
        if (C0449ye.m9220() < 0) {
            return ((C0315lc) obj).f972pz;
        }
        return null;
    }

    public static Set m6008(Object obj) {
        if (C0457zc.m10555() > 0) {
            return m6007((C0315lc) obj);
        }
        return null;
    }

    public void m1013a(C0294ki c0294ki) {
        synchronized (this) {
            C0452yh.m9623(gggy.m4485(this), c0294ki);
        }
    }

    public void m1014b(C0294ki c0294ki) {
        synchronized (this) {
            C0452yh.m9790(gggy.m4485(this), c0294ki);
        }
    }

    public boolean m1015c(C0294ki c0294ki) {
        boolean zM11513;
        synchronized (this) {
            zM11513 = C0461zs.m11513(gggy.m4485(this), c0294ki);
        }
        return zM11513;
    }
}
