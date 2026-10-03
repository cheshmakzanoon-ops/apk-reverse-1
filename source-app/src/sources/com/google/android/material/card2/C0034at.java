package com.google.android.material.card2;

import java.io.Serializable;
import java.lang.reflect.Type;
import java.lang.reflect.WildcardType;

final class C0034at implements Serializable, WildcardType {
    private static final long serialVersionUID = 0;

    private final Type f37W;

    private final Type f38X;

    public C0034at(Type[] typeArr, Type[] typeArr2) {
        C0461zs.m11567(typeArr2.length <= 1);
        C0461zs.m11567(typeArr.length == 1);
        if (typeArr2.length != 1) {
            C0456zb.m10406(typeArr[0]);
            m2948(typeArr[0]);
            this.f37W = null;
            this.f38X = abe.m2352(typeArr[0]);
            return;
        }
        C0456zb.m10406(typeArr2[0]);
        m2948(typeArr2[0]);
        C0461zs.m11567(typeArr[0] == Object.class);
        this.f37W = abe.m2352(typeArr2[0]);
        this.f38X = Object.class;
    }

    public static void m2944(Object obj) {
        if (C0446yb.m8415() <= 0) {
            C0031aq.m255d((Type) obj);
        }
    }

    public static Type m2945(Object obj) {
        if (C0446yb.m8415() <= 0) {
            return ((C0034at) obj).f37W;
        }
        return null;
    }

    public static Type[] m2946() {
        if (C0456zb.m10326() <= 0) {
            return C0031aq.f32R;
        }
        return null;
    }

    public static Type m2947(Object obj) {
        if (adds.m2755() > 0) {
            return m2953(obj);
        }
        return null;
    }

    public static void m2948(Object obj) {
        if (C0450yf.m9352() <= 0) {
            m2952(obj);
        }
    }

    public static Type m2949(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return m2955(obj);
        }
        return null;
    }

    public static Type m2950(Object obj) {
        if (gggy.m4269() <= 0) {
            return ((C0034at) obj).f38X;
        }
        return null;
    }

    public static Type[] m2951() {
        if (C0457zc.m10735() < 0) {
            return m2954();
        }
        return null;
    }

    public static void m2952(Object obj) {
        if (abe.m2321() < 0) {
            m2944((Type) obj);
        }
    }

    public static Type m2953(Object obj) {
        if (abd.m2166() < 0) {
            return m2950((C0034at) obj);
        }
        return null;
    }

    public static Type[] m2954() {
        if (C0459zf.m11053() > 0) {
            return m2946();
        }
        return null;
    }

    public static Type m2955(Object obj) {
        if (C0453yj.m9966() >= 0) {
            return m2945((C0034at) obj);
        }
        return null;
    }

    public boolean equals(Object obj) {
        return (obj instanceof WildcardType) && C0448yd.m8888(this, (WildcardType) obj);
    }

    @Override
    public Type[] getLowerBounds() {
        return m2949(this) != null ? new Type[]{m2949(this)} : m2951();
    }

    @Override
    public Type[] getUpperBounds() {
        return new Type[]{m2947(this)};
    }

    public int hashCode() {
        return (m2949(this) != null ? C0446yb.m8544(m2949(this)) + 31 : 1) ^ (C0446yb.m8544(m2947(this)) + 31);
    }

    public String toString() {
        if (m2949(this) != null) {
            return abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0459zf.m11022()), gggy.m4275(m2949(this))));
        }
        return m2947(this) == Object.class ? abe.m2268() : abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), gggy.m4426()), gggy.m4275(m2947(this))));
    }
}
