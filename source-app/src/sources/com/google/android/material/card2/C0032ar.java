package com.google.android.material.card2;

import java.io.Serializable;
import java.lang.reflect.GenericArrayType;
import java.lang.reflect.Type;

final class C0032ar implements Serializable, GenericArrayType {
    private static final long serialVersionUID = 0;

    private final Type f33S;

    public C0032ar(Type type) {
        this.f33S = abe.m2352(type);
    }

    public static Type m2923(Object obj) {
        if (C0450yf.m9352() <= 0) {
            return m2925(obj);
        }
        return null;
    }

    public static Type m2924(Object obj) {
        if (C0461zs.m11510() < 0) {
            return ((C0032ar) obj).f33S;
        }
        return null;
    }

    public static Type m2925(Object obj) {
        if (C0445ya.m8330() > 0) {
            return m2924((C0032ar) obj);
        }
        return null;
    }

    public boolean equals(Object obj) {
        return (obj instanceof GenericArrayType) && C0448yd.m8888(this, (GenericArrayType) obj);
    }

    @Override
    public Type getGenericComponentType() {
        return m2923(this);
    }

    public int hashCode() {
        return C0446yb.m8544(m2923(this));
    }

    public String toString() {
        return abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), gggy.m4275(m2923(this))), C0455za.m10098()));
    }
}
