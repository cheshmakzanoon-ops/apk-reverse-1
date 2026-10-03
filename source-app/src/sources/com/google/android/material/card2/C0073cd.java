package com.google.android.material.card2;

import java.lang.reflect.Method;

class C0073cd extends AbstractC0072cc {

    final Method f118bm;

    final Object f119bn;

    C0073cd(Method method, Object obj) {
        this.f118bm = method;
        this.f119bn = obj;
    }

    public static void m3228(Object obj) {
        if (C0461zs.m11510() <= 0) {
            m3234(obj);
        }
    }

    public static Method m3229(Object obj) {
        if (C0452yh.m9798() > 0) {
            return ((C0073cd) obj).f118bm;
        }
        return null;
    }

    public static Object m3230(Object obj) {
        if (C0457zc.m10735() < 0) {
            return ((C0073cd) obj).f119bn;
        }
        return null;
    }

    public static void m3231(Object obj) {
        if (C0460zg.m11287() > 0) {
            m329h((Class) obj);
        }
    }

    public static Method m3232(Object obj) {
        if (abe.m2308() <= 0) {
            return m3236(obj);
        }
        return null;
    }

    public static Object m3233(Object obj) {
        if (C0452yh.m9798() >= 0) {
            return m3235(obj);
        }
        return null;
    }

    public static void m3234(Object obj) {
        if (C0448yd.m9015() < 0) {
            m3231((Class) obj);
        }
    }

    public static Object m3235(Object obj) {
        if (abe.m2321() < 0) {
            return m3230((C0073cd) obj);
        }
        return null;
    }

    public static Method m3236(Object obj) {
        if (C0456zb.m10484() <= 0) {
            return m3229((C0073cd) obj);
        }
        return null;
    }

    @Override
    public <T> T mo330i(Class<T> cls) {
        m3228(cls);
        return (T) C0446yb.m8446(m3232(this), m3233(this), new Object[]{cls});
    }
}
