package com.google.android.material.card2;

import java.lang.reflect.Type;

class C0043ba<T> implements InterfaceC0065bw<T> {

    final C0035au f51ah;

    private final AbstractC0072cc f52ai = C0458ze.m10913();

    final Class f53aj;

    final Type f54ak;

    C0043ba(C0035au c0035au, Class cls, Type type) {
        this.f51ah = c0035au;
        this.f53aj = cls;
        this.f54ak = type;
    }

    public static Class m2973(Object obj) {
        if (C0450yf.m9352() < 0) {
            return m2981(obj);
        }
        return null;
    }

    public static Class m2974(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return ((C0043ba) obj).f53aj;
        }
        return null;
    }

    public static AbstractC0072cc m2975(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return ((C0043ba) obj).f52ai;
        }
        return null;
    }

    public static AbstractC0072cc m2976(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return m2979(obj);
        }
        return null;
    }

    public static Type m2977(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return m2980(obj);
        }
        return null;
    }

    public static Type m2978(Object obj) {
        if (C0459zf.m11062() > 0) {
            return ((C0043ba) obj).f54ak;
        }
        return null;
    }

    public static AbstractC0072cc m2979(Object obj) {
        if (C0458ze.m10926() < 0) {
            return m2975((C0043ba) obj);
        }
        return null;
    }

    public static Type m2980(Object obj) {
        if (C0460zg.m11293() > 0) {
            return m2978((C0043ba) obj);
        }
        return null;
    }

    public static Class m2981(Object obj) {
        if (gggy.m4365() > 0) {
            return m2974((C0043ba) obj);
        }
        return null;
    }

    @Override
    public T mo265y() {
        try {
            return (T) C0456zb.m10430(m2976(this), m2973(this));
        } catch (Exception e) {
            throw new RuntimeException(abc.m1925(C0460zg.m11407(abd.m2090(C0460zg.m11407(new StringBuilder(), C0445ya.m8285()), m2977(this)), C0453yj.m9962())), e);
        }
    }
}
