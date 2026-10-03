package com.google.android.material.card2;

import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;

class C0047be<T> implements InterfaceC0065bw<T> {

    final C0035au f61ar;

    final Type f62as;

    C0047be(C0035au c0035au, Type type) {
        this.f61ar = c0035au;
        this.f62as = type;
    }

    public static String m2991(Object obj) {
        if (gggy.m4269() < 0) {
            return C0598.m11838(obj);
        }
        return null;
    }

    public static Type m2992(Object obj) {
        if (C0461zs.m11510() < 0) {
            return m2994(obj);
        }
        return null;
    }

    public static Type m2993(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return ((C0047be) obj).f62as;
        }
        return null;
    }

    public static Type m2994(Object obj) {
        if (C0448yd.m9074() <= 0) {
            return m2993((C0047be) obj);
        }
        return null;
    }

    @Override
    public T mo265y() {
        if (!(m2992(this) instanceof ParameterizedType)) {
            throw new C0442w(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0449ye.m9172()), m2991(m2992(this)))));
        }
        Type type = C0448yd.m8866((ParameterizedType) m2992(this))[0];
        if (type instanceof Class) {
            return (T) abd.m2055((Class) type);
        }
        throw new C0442w(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0449ye.m9172()), m2991(m2992(this)))));
    }
}
