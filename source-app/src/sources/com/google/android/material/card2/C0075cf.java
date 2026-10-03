package com.google.android.material.card2;

import java.lang.reflect.Method;

class C0075cf extends AbstractC0072cc {

    final Method f122bq;

    C0075cf(Method method) {
        this.f122bq = method;
    }

    public static Method m3247(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return ((C0075cf) obj).f122bq;
        }
        return null;
    }

    public static void m3248(Object obj) {
        if (adds.m2755() >= 0) {
            m3251(obj);
        }
    }

    public static Method m3249(Object obj) {
        if (C0457zc.m10735() < 0) {
            return m3252(obj);
        }
        return null;
    }

    public static void m3250(Object obj) {
        if (adds.m2755() >= 0) {
            m329h((Class) obj);
        }
    }

    public static void m3251(Object obj) {
        if (C0458ze.m10926() < 0) {
            m3250((Class) obj);
        }
    }

    public static Method m3252(Object obj) {
        if (abd.m2166() <= 0) {
            return m3247((C0075cf) obj);
        }
        return null;
    }

    @Override
    public <T> T mo330i(Class<T> cls) {
        m3248(cls);
        return (T) C0446yb.m8446(m3249(this), null, new Object[]{cls, Object.class});
    }
}
