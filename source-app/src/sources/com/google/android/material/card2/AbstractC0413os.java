package com.google.android.material.card2;

public abstract class AbstractC0413os implements InterfaceC0428pg {

    private final InterfaceC0428pg f1307vm;

    public AbstractC0413os(InterfaceC0428pg interfaceC0428pg) {
        if (interfaceC0428pg == null) {
            throw new IllegalArgumentException(C0449ye.m9131());
        }
        this.f1307vm = interfaceC0428pg;
    }

    public static String m7844(Object obj) {
        if (C0448yd.m9079() < 0) {
            return C0598.m11838(obj);
        }
        return null;
    }

    public static InterfaceC0428pg m7845(Object obj) {
        if (abf.m2510() < 0) {
            return ((AbstractC0413os) obj).f1307vm;
        }
        return null;
    }

    public static InterfaceC0428pg m7846(Object obj) {
        if (C0453yj.m9966() >= 0) {
            return m7845((AbstractC0413os) obj);
        }
        return null;
    }

    @Override
    public void mo1045b(C0409oo c0409oo, long j) {
        C0448yd.m8920(C0445ya.m8387(this), c0409oo, j);
    }

    @Override
    public void close() {
        C0453yj.m10006(C0445ya.m8387(this));
    }

    @Override
    public C0430pi mo1095dz() {
        return C0457zc.m10700(C0445ya.m8387(this));
    }

    @Override
    public void flush() {
        C0459zf.m11085(C0445ya.m8387(this));
    }

    public String toString() {
        return abc.m1925(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0458ze.m10951(gggy.m4399(this))), C0445ya.m8400()), m7844(C0445ya.m8387(this))), C0457zc.m10722()));
    }
}
