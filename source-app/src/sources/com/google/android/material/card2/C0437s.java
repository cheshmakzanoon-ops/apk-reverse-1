package com.google.android.material.card2;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public final class C0437s extends AbstractC0441v implements Iterable<AbstractC0441v> {

    private final List<AbstractC0441v> f1353J = new ArrayList();

    public static List m8185(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return ((C0437s) obj).f1353J;
        }
        return null;
    }

    public static int m8186(Object obj) {
        if (abf.m2510() <= 0) {
            return C0598.m11824(obj);
        }
        return 0;
    }

    public static List m8187(Object obj) {
        if (C0453yj.m10032() > 0) {
            return m8185((C0437s) obj);
        }
        return null;
    }

    @Override
    public boolean mo214a() {
        if (m8186(C0458ze.m10769(this)) == 1) {
            return C0452yh.m9698((AbstractC0441v) gggy.m4400(C0458ze.m10769(this), 0));
        }
        throw new IllegalStateException();
    }

    @Override
    public double mo215b() {
        if (m8186(C0458ze.m10769(this)) == 1) {
            return C0450yf.m9490((AbstractC0441v) gggy.m4400(C0458ze.m10769(this), 0));
        }
        throw new IllegalStateException();
    }

    public void m1500b(AbstractC0441v abstractC0441v) {
        AbstractC0441v abstractC0441vM10823 = abstractC0441v;
        if (abstractC0441vM10823 == null) {
            abstractC0441vM10823 = C0458ze.m10823();
        }
        C0460zg.m11251(C0458ze.m10769(this), abstractC0441vM10823);
    }

    @Override
    public int mo216c() {
        if (m8186(C0458ze.m10769(this)) == 1) {
            return abd.m1986((AbstractC0441v) gggy.m4400(C0458ze.m10769(this), 0));
        }
        throw new IllegalStateException();
    }

    @Override
    public long mo217d() {
        if (m8186(C0458ze.m10769(this)) == 1) {
            return adds.m2880((AbstractC0441v) gggy.m4400(C0458ze.m10769(this), 0));
        }
        throw new IllegalStateException();
    }

    @Override
    public Number mo218e() {
        if (m8186(C0458ze.m10769(this)) == 1) {
            return C0461zs.m11611((AbstractC0441v) gggy.m4400(C0458ze.m10769(this), 0));
        }
        throw new IllegalStateException();
    }

    public boolean equals(Object obj) {
        return obj == this || ((obj instanceof C0437s) && abd.m2119(C0458ze.m10769((C0437s) obj), C0458ze.m10769(this)));
    }

    @Override
    public String mo219f() {
        if (m8186(C0458ze.m10769(this)) == 1) {
            return C0445ya.m8402((AbstractC0441v) gggy.m4400(C0458ze.m10769(this), 0));
        }
        throw new IllegalStateException();
    }

    public int hashCode() {
        return C0452yh.m9607(C0458ze.m10769(this));
    }

    @Override
    public Iterator<AbstractC0441v> iterator() {
        return C0453yj.m9883(C0458ze.m10769(this));
    }
}
