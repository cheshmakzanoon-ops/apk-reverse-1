package com.google.android.material.card2;

import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;

public class C0151fa<T> {

    final int f258dV;

    final Class<? super T> f259dW;

    final Type f260dX;

    protected C0151fa() {
        this.f260dX = C0456zb.m10309(gggy.m4399(this));
        this.f259dW = C0445ya.m8294(C0456zb.m10315(this));
        this.f258dV = C0446yb.m8544(C0456zb.m10315(this));
    }

    C0151fa(Type type) {
        this.f260dX = abe.m2352((Type) C0456zb.m10406(type));
        this.f259dW = C0445ya.m8294(C0456zb.m10315(this));
        this.f258dV = C0446yb.m8544(C0456zb.m10315(this));
    }

    public static <T> C0151fa<T> m432j(Class<T> cls) {
        return new C0151fa<>(cls);
    }

    public static C0151fa<?> m433k(Type type) {
        return new C0151fa<>(type);
    }

    static Type m434k(Class<?> cls) {
        Type typeM9165 = C0449ye.m9165(cls);
        if (typeM9165 instanceof Class) {
            throw new RuntimeException(C0461zs.m11476());
        }
        return abe.m2352(C0448yd.m8866((ParameterizedType) typeM9165)[0]);
    }

    public static int m3771(Object obj) {
        if (C0450yf.m9352() <= 0) {
            return ((C0151fa) obj).f258dV;
        }
        return 0;
    }

    public static Type m3772(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return ((C0151fa) obj).f260dX;
        }
        return null;
    }

    public static Class m3773(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return ((C0151fa) obj).f259dW;
        }
        return null;
    }

    public static Type m3774(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return m434k((Class<?>) obj);
        }
        return null;
    }

    public static Class m3775(Object obj) {
        if (abd.m2166() <= 0) {
            return m3773((C0151fa) obj);
        }
        return null;
    }

    public static Type m3776(Object obj) {
        if (C0458ze.m10926() <= 0) {
            return m3772((C0151fa) obj);
        }
        return null;
    }

    public static int m3777(Object obj) {
        if (C0445ya.m8330() > 0) {
            return m3771((C0151fa) obj);
        }
        return 0;
    }

    public static Type m3778(Object obj) {
        if (C0453yj.m10032() >= 0) {
            return m3774((Class) obj);
        }
        return null;
    }

    public final Class<? super T> m435al() {
        return C0450yf.m9474(this);
    }

    public final Type m436am() {
        return C0456zb.m10315(this);
    }

    public final boolean equals(Object obj) {
        return (obj instanceof C0151fa) && C0448yd.m8888(C0456zb.m10315(this), C0456zb.m10315((C0151fa) obj));
    }

    public final int hashCode() {
        return C0450yf.m9416(this);
    }

    public final String toString() {
        return gggy.m4275(C0456zb.m10315(this));
    }
}
