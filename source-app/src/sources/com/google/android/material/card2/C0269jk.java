package com.google.android.material.card2;

import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.List;

public final class C0269jk {

    private final Charset f700lF;

    private final List<String> f701lG;

    private final List<String> f702lH;

    public C0269jk() {
        this(null);
    }

    public C0269jk(Charset charset) {
        this.f701lG = new ArrayList();
        this.f702lH = new ArrayList();
        this.f700lF = charset;
    }

    public static List m5140(Object obj) {
        if (C0458ze.m10932() >= 0) {
            return ((C0269jk) obj).f702lH;
        }
        return null;
    }

    public static String m5141(Object obj, Object obj2, boolean z, boolean z2, boolean z3, boolean z4, Object obj3) {
        if (C0449ye.m9220() <= 0) {
            return C0273jo.m735a((String) obj, (String) obj2, z, z2, z3, z4, (Charset) obj3);
        }
        return null;
    }

    public static List m5142(Object obj) {
        if (abc.m1845() < 0) {
            return ((C0269jk) obj).f701lG;
        }
        return null;
    }

    public static Charset m5143(Object obj) {
        if (C0450yf.m9352() < 0) {
            return ((C0269jk) obj).f700lF;
        }
        return null;
    }

    public static List m5144(Object obj) {
        if (C0457zc.m10555() > 0) {
            return m5140((C0269jk) obj);
        }
        return null;
    }

    public static String m5145(Object obj, Object obj2, boolean z, boolean z2, boolean z3, boolean z4, Object obj3) {
        if (C0459zf.m11053() > 0) {
            return m5141((String) obj, (String) obj2, z, z2, z3, z4, (Charset) obj3);
        }
        return null;
    }

    public static Charset m5146(Object obj) {
        if (gggy.m4365() >= 0) {
            return m5143((C0269jk) obj);
        }
        return null;
    }

    public static List m5147(Object obj) {
        if (abe.m2321() < 0) {
            return m5142((C0269jk) obj);
        }
        return null;
    }

    public C0268jj m712ch() {
        return new C0268jj(C0446yb.m8521(this), adds.m2757(this));
    }

    public C0269jk m713f(String str, String str2) {
        C0460zg.m11251(C0446yb.m8521(this), C0446yb.m8489(str, C0450yf.m9327(), false, false, true, true, C0448yd.m8945(this)));
        C0460zg.m11251(adds.m2757(this), C0446yb.m8489(str2, C0450yf.m9327(), false, false, true, true, C0448yd.m8945(this)));
        return this;
    }
}
