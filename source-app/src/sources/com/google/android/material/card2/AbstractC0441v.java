package com.google.android.material.card2;

import java.io.IOException;
import java.io.StringWriter;

public abstract class AbstractC0441v {
    public boolean mo214a() {
        throw new UnsupportedOperationException(C0458ze.m10951(gggy.m4399(this)));
    }

    public double mo215b() {
        throw new UnsupportedOperationException(C0458ze.m10951(gggy.m4399(this)));
    }

    public int mo216c() {
        throw new UnsupportedOperationException(C0458ze.m10951(gggy.m4399(this)));
    }

    public long mo217d() {
        throw new UnsupportedOperationException(C0458ze.m10951(gggy.m4399(this)));
    }

    public Number mo218e() {
        throw new UnsupportedOperationException(C0458ze.m10951(gggy.m4399(this)));
    }

    public String mo219f() {
        throw new UnsupportedOperationException(C0458ze.m10951(gggy.m4399(this)));
    }

    public C0437s m1506g() {
        if (C0461zs.m11583(this)) {
            return (C0437s) this;
        }
        throw new IllegalStateException(abc.m1925(abd.m2090(C0460zg.m11407(new StringBuilder(), abf.m2446()), this)));
    }

    public C0444y m1507h() {
        if (C0452yh.m9775(this)) {
            return (C0444y) this;
        }
        throw new IllegalStateException(abc.m1925(abd.m2090(C0460zg.m11407(new StringBuilder(), abd.m2086()), this)));
    }

    public C0015aa m1508i() {
        if (C0447yc.m8733(this)) {
            return (C0015aa) this;
        }
        throw new IllegalStateException(abc.m1925(abd.m2090(C0460zg.m11407(new StringBuilder(), C0453yj.m9858()), this)));
    }

    public boolean m1509j() {
        return this instanceof C0437s;
    }

    public boolean m1510k() {
        return this instanceof C0443x;
    }

    public boolean m1511l() {
        return this instanceof C0444y;
    }

    public boolean m1512m() {
        return this instanceof C0015aa;
    }

    public String toString() {
        try {
            StringWriter stringWriter = new StringWriter();
            C0155fe c0155fe = new C0155fe(stringWriter);
            C0457zc.m10725(c0155fe, true);
            adds.m2870(this, c0155fe);
            return C0456zb.m10416(stringWriter);
        } catch (IOException e) {
            throw new AssertionError(e);
        }
    }
}
