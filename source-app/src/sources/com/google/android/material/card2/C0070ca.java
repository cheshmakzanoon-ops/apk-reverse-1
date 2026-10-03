package com.google.android.material.card2;

import java.io.Writer;

final class C0070ca extends Writer {

    private final Appendable f115bj;

    private final C0071cb f116bk = new C0071cb();

    C0070ca(Appendable appendable) {
        this.f115bj = appendable;
    }

    public static C0071cb m3217(Object obj) {
        if (gggy.m4269() <= 0) {
            return m3221(obj);
        }
        return null;
    }

    public static Appendable m3218(Object obj) {
        if (abd.m2162() >= 0) {
            return ((C0070ca) obj).f115bj;
        }
        return null;
    }

    public static C0071cb m3219(Object obj) {
        if (C0448yd.m9079() <= 0) {
            return ((C0070ca) obj).f116bk;
        }
        return null;
    }

    public static Appendable m3220(Object obj) {
        if (C0458ze.m10932() > 0) {
            return m3222(obj);
        }
        return null;
    }

    public static C0071cb m3221(Object obj) {
        if (C0456zb.m10484() < 0) {
            return m3219((C0070ca) obj);
        }
        return null;
    }

    public static Appendable m3222(Object obj) {
        if (C0460zg.m11293() > 0) {
            return m3218((C0070ca) obj);
        }
        return null;
    }

    @Override
    public void close() {
    }

    @Override
    public void flush() {
    }

    @Override
    public void write(int i) {
        C0456zb.m10291(m3220(this), (char) i);
    }

    @Override
    public void write(char[] cArr, int i, int i2) {
        m3217(this).f117bl = cArr;
        C0446yb.m8579(m3220(this), m3217(this), i, i + i2);
    }
}
