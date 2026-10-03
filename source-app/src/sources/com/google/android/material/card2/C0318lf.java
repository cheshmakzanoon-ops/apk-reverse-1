package com.google.android.material.card2;

import java.util.ArrayList;
import java.util.List;
import java.util.NoSuchElementException;

public final class C0318lf {

    private int f983pK = 0;

    private final List<C0294ki> f984pL;

    C0318lf(List<C0294ki> list) {
        this.f984pL = list;
    }

    public static int m6046(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return C0598.m11824(obj);
        }
        return 0;
    }

    public static int m6047(Object obj) {
        if (abc.m1845() <= 0) {
            return ((C0318lf) obj).f983pK;
        }
        return 0;
    }

    public static List m6048(Object obj) {
        if (C0453yj.m10013() > 0) {
            return ((C0318lf) obj).f984pL;
        }
        return null;
    }

    public static int m6049(Object obj) {
        if (C0448yd.m9015() <= 0) {
            return m6047((C0318lf) obj);
        }
        return 0;
    }

    public static List m6050(Object obj) {
        if (C0445ya.m8330() >= 0) {
            return m6048((C0318lf) obj);
        }
        return null;
    }

    public List<C0294ki> m1026dU() {
        return new ArrayList(abd.m2087(this));
    }

    public C0294ki m1027dV() {
        if (!C0457zc.m10751(this)) {
            throw new NoSuchElementException();
        }
        List listM2087 = abd.m2087(this);
        int iM10332 = C0456zb.m10332(this);
        this.f983pK = iM10332 + 1;
        return (C0294ki) gggy.m4400(listM2087, iM10332);
    }

    public boolean hasNext() {
        return C0456zb.m10332(this) < m6046(abd.m2087(this));
    }
}
