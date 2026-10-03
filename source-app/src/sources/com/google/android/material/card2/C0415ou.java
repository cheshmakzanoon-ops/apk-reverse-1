package com.google.android.material.card2;

import java.util.concurrent.TimeUnit;

public class C0415ou extends C0430pi {

    private C0430pi f1309vo;

    public C0415ou(C0430pi c0430pi) {
        if (c0430pi == null) {
            throw new IllegalArgumentException(C0449ye.m9131());
        }
        this.f1309vo = c0430pi;
    }

    public static C0430pi m7850(Object obj) {
        if (C0457zc.m10735() <= 0) {
            return ((C0415ou) obj).f1309vo;
        }
        return null;
    }

    public static C0430pi m7851(Object obj) {
        if (abe.m2321() <= 0) {
            return m7850((C0415ou) obj);
        }
        return null;
    }

    public final C0415ou m1421a(C0430pi c0430pi) {
        if (c0430pi == null) {
            throw new IllegalArgumentException(C0449ye.m9131());
        }
        this.f1309vo = c0430pi;
        return this;
    }

    @Override
    public C0430pi mo1422d(long j, TimeUnit timeUnit) {
        return gggy.m4486(C0450yf.m9383(this), j, timeUnit);
    }

    @Override
    public C0430pi mo1423fU() {
        return C0459zf.m11009(C0450yf.m9383(this));
    }

    @Override
    public C0430pi mo1424fV() {
        return abf.m2529(C0450yf.m9383(this));
    }

    @Override
    public long mo1425fW() {
        return C0452yh.m9631(C0450yf.m9383(this));
    }

    public final C0430pi m1426fX() {
        return C0450yf.m9383(this);
    }

    @Override
    public boolean mo1427fY() {
        return C0448yd.m9046(C0450yf.m9383(this));
    }

    @Override
    public void mo1428fZ() {
        C0456zb.m10377(C0450yf.m9383(this));
    }

    @Override
    public long mo1429ga() {
        return C0448yd.m8941(C0450yf.m9383(this));
    }

    @Override
    public C0430pi mo1430u(long j) {
        return C0448yd.m8901(C0450yf.m9383(this), j);
    }
}
