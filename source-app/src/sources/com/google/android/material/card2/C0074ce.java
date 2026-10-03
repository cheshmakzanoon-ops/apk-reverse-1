package com.google.android.material.card2;

import java.lang.reflect.Method;

class C0074ce extends AbstractC0072cc {

    final int f120bo;

    final Method f121bp;

    C0074ce(Method method, int i) {
        this.f121bp = method;
        this.f120bo = i;
    }

    public static int m3237() {
        if (C0457zc.m10735() < 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static Method m3238(Object obj) {
        if (adds.m2755() > 0) {
            return ((C0074ce) obj).f121bp;
        }
        return null;
    }

    public static void m3239(Object obj) {
        if (gggy.m4269() <= 0) {
            m3244(obj);
        }
    }

    public static int m3240(Object obj) {
        if (C0450yf.m9352() < 0) {
            return ((C0074ce) obj).f120bo;
        }
        return 0;
    }

    public static int m3241(Object obj) {
        if (abd.m2162() > 0) {
            return m3245(obj);
        }
        return 0;
    }

    public static Method m3242(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return m3246(obj);
        }
        return null;
    }

    public static void m3243(Object obj) {
        if (C0450yf.m9352() <= 0) {
            m329h((Class) obj);
        }
    }

    public static void m3244(Object obj) {
        if (C0448yd.m9074() <= 0) {
            m3243((Class) obj);
        }
    }

    public static int m3245(Object obj) {
        if (m3237() >= 0) {
            return m3240((C0074ce) obj);
        }
        return 0;
    }

    public static Method m3246(Object obj) {
        if (C0445ya.m8330() > 0) {
            return m3238((C0074ce) obj);
        }
        return null;
    }

    @Override
    public <T> T mo330i(Class<T> cls) {
        m3239(cls);
        return (T) C0446yb.m8446(m3242(this), null, new Object[]{cls, abd.m2028(m3241(this))});
    }
}
