package com.google.android.material.card2;

import java.lang.reflect.Type;

class C0044bb<T> implements InterfaceC0065bw<T> {

    final C0035au f55al;

    final InterfaceC0434r f56am;

    final Type f57an;

    C0044bb(C0035au c0035au, InterfaceC0434r interfaceC0434r, Type type) {
        this.f55al = c0035au;
        this.f56am = interfaceC0434r;
        this.f57an = type;
    }

    public static InterfaceC0434r m2982(Object obj) {
        if (C0448yd.m9079() <= 0) {
            return m2986(obj);
        }
        return null;
    }

    public static Type m2983(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return m2987(obj);
        }
        return null;
    }

    public static Type m2984(Object obj) {
        if (C0456zb.m10326() < 0) {
            return ((C0044bb) obj).f57an;
        }
        return null;
    }

    public static InterfaceC0434r m2985(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return ((C0044bb) obj).f56am;
        }
        return null;
    }

    public static InterfaceC0434r m2986(Object obj) {
        if (abf.m2500() > 0) {
            return m2985((C0044bb) obj);
        }
        return null;
    }

    public static Type m2987(Object obj) {
        if (C0460zg.m11293() >= 0) {
            return m2984((C0044bb) obj);
        }
        return null;
    }

    @Override
    public T mo265y() {
        return (T) C0445ya.m8374(m2982(this), m2983(this));
    }
}
