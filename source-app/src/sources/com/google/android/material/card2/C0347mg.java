package com.google.android.material.card2;

public final class C0347mg {

    final int f1073rl;

    public final C0412or f1074rm;

    public final C0412or f1075rn;

    public static final C0412or f1067rf = abc.m1810(C0449ye.m9248());

    public static final C0412or f1068rg = abc.m1810(abe.m2263());

    public static final C0412or f1070ri = abc.m1810(abf.m2544());

    public static final C0412or f1071rj = abc.m1810(m6340());

    public static final C0412or f1072rk = abc.m1810(C0456zb.m10290());

    public static final C0412or f1069rh = abc.m1810(C0457zc.m10655());

    public C0347mg(C0412or c0412or, C0412or c0412or2) {
        this.f1074rm = c0412or;
        this.f1075rn = c0412or2;
        this.f1073rl = gggy.m4418(c0412or) + 32 + gggy.m4418(c0412or2);
    }

    public C0347mg(C0412or c0412or, String str) {
        this(c0412or, abc.m1810(str));
    }

    public C0347mg(String str, String str2) {
        this(abc.m1810(str), abc.m1810(str2));
    }

    public static String m6340() {
        if (abd.m2162() >= 0) {
            return C0598.m11866();
        }
        return null;
    }

    public boolean equals(Object obj) {
        if (!(obj instanceof C0347mg)) {
            return false;
        }
        C0347mg c0347mg = (C0347mg) obj;
        return C0459zf.m11211(C0455za.m10117(this), C0455za.m10117(c0347mg)) && C0459zf.m11211(C0458ze.m10967(this), C0458ze.m10967(c0347mg));
    }

    public int hashCode() {
        return ((C0458ze.m10815(C0455za.m10117(this)) + 527) * 31) + C0458ze.m10815(C0458ze.m10967(this));
    }

    public String toString() {
        return gggy.m4389(gggy.m4333(), new Object[]{C0458ze.m10854(C0455za.m10117(this)), C0458ze.m10854(C0458ze.m10967(this))});
    }
}
