package com.google.android.material.card2;

import java.util.concurrent.TimeUnit;

public final class C0244im {

    boolean f521ii;

    int f522il = -1;

    int f523im = -1;

    int f524in = -1;

    boolean f525ip;

    boolean f526iq;

    boolean f527ir;

    boolean f528is;

    public static long m4923(Object obj, long j) {
        if (C0460zg.m11287() > 0) {
            return C0598.m11860(obj, j);
        }
        return 0L;
    }

    public C0244im m628a(int i, TimeUnit timeUnit) {
        if (i < 0) {
            throw new IllegalArgumentException(abc.m1925(adds.m2680(C0460zg.m11407(new StringBuilder(), abc.m1944()), i)));
        }
        long jM4923 = m4923(timeUnit, i);
        this.f523im = jM4923 > 2147483647L ? Integer.MAX_VALUE : (int) jM4923;
        return this;
    }

    public C0243il m629bR() {
        return new C0243il(this);
    }

    public C0244im m630bS() {
        this.f525ip = true;
        return this;
    }

    public C0244im m631bT() {
        this.f528is = true;
        return this;
    }
}
