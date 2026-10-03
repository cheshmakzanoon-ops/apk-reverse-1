package com.google.android.material.card2;

public abstract class AbstractC0414ot implements InterfaceC0429ph {

    private final InterfaceC0429ph f1308vn;

    public AbstractC0414ot(InterfaceC0429ph interfaceC0429ph) {
        if (interfaceC0429ph == null) {
            throw new IllegalArgumentException(C0449ye.m9131());
        }
        this.f1308vn = interfaceC0429ph;
    }

    public static String m7847(Object obj) {
        if (C0449ye.m9220() < 0) {
            return C0598.m11838(obj);
        }
        return null;
    }

    public static InterfaceC0429ph m7848(Object obj) {
        if (C0460zg.m11287() > 0) {
            return ((AbstractC0414ot) obj).f1308vn;
        }
        return null;
    }

    public static InterfaceC0429ph m7849(Object obj) {
        if (C0456zb.m10484() < 0) {
            return m7848((AbstractC0414ot) obj);
        }
        return null;
    }

    @Override
    public long mo966a(C0409oo c0409oo, long j) {
        return abe.m2209(C0449ye.m9186(this), c0409oo, j);
    }

    @Override
    public void close() {
        C0447yc.m8668(C0449ye.m9186(this));
    }

    @Override
    public C0430pi mo967dz() {
        return gggy.m4377(C0449ye.m9186(this));
    }

    public final InterfaceC0429ph m1420fT() {
        return C0449ye.m9186(this);
    }

    public String toString() {
        return abc.m1925(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0458ze.m10951(gggy.m4399(this))), C0445ya.m8400()), m7847(C0449ye.m9186(this))), C0457zc.m10722()));
    }
}
