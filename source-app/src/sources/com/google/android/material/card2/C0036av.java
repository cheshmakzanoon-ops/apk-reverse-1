package com.google.android.material.card2;

import java.lang.reflect.Type;

class C0036av<T> implements InterfaceC0065bw<T> {

    final C0035au f41aa;

    final Type f42ab;

    final InterfaceC0434r f43ac;

    C0036av(C0035au c0035au, InterfaceC0434r interfaceC0434r, Type type) {
        this.f41aa = c0035au;
        this.f43ac = interfaceC0434r;
        this.f42ab = type;
    }

    public static InterfaceC0434r m2967(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return ((C0036av) obj).f43ac;
        }
        return null;
    }

    public static Type m2968(Object obj) {
        if (adds.m2755() >= 0) {
            return ((C0036av) obj).f42ab;
        }
        return null;
    }

    public static Type m2969(Object obj) {
        if (C0459zf.m11062() > 0) {
            return m2971(obj);
        }
        return null;
    }

    public static InterfaceC0434r m2970(Object obj) {
        if (C0456zb.m10326() < 0) {
            return m2972(obj);
        }
        return null;
    }

    public static Type m2971(Object obj) {
        if (C0458ze.m10926() <= 0) {
            return m2968((C0036av) obj);
        }
        return null;
    }

    public static InterfaceC0434r m2972(Object obj) {
        if (C0457zc.m10555() >= 0) {
            return m2967((C0036av) obj);
        }
        return null;
    }

    @Override
    public T mo265y() {
        return (T) C0445ya.m8374(m2970(this), m2969(this));
    }
}
