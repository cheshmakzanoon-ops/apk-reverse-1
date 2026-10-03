package com.google.android.material.card2;

import java.io.Serializable;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;

final class C0033as implements Serializable, ParameterizedType {
    private static final long serialVersionUID = 0;

    private final Type f34T;

    private final Type f35U;

    private final Type[] f36V;

    public C0033as(Type type, Type type2, Type... typeArr) {
        if (type2 instanceof Class) {
            Class cls = (Class) type2;
            C0461zs.m11567(type != null || (abf.m2612(gggy.m4330(cls)) || abc.m1882(cls) == null));
        }
        this.f34T = type == null ? null : abe.m2352(type);
        this.f35U = abe.m2352(type2);
        this.f36V = (Type[]) m2927(typeArr);
        int length = m2933(this).length;
        for (int i = 0; i < length; i++) {
            C0456zb.m10406(m2933(this)[i]);
            m2936(m2933(this)[i]);
            m2933(this)[i] = abe.m2352(m2933(this)[i]);
        }
    }

    public static Type m2926(Object obj) {
        if (C0446yb.m8415() <= 0) {
            return m2939(obj);
        }
        return null;
    }

    public static Object m2927(Object obj) {
        if (C0451yg.m9580() > 0) {
            return m2942(obj);
        }
        return null;
    }

    public static int m2928(Object obj) {
        if (C0460zg.m11287() > 0) {
            return m2943(obj);
        }
        return 0;
    }

    public static Type m2929(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return m2941(obj);
        }
        return null;
    }

    public static void m2930(Object obj) {
        if (C0461zs.m11510() < 0) {
            C0031aq.m255d((Type) obj);
        }
    }

    public static Type[] m2931(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return ((C0033as) obj).f36V;
        }
        return null;
    }

    public static int m2932(Object obj) {
        if (C0447yc.m8635() > 0) {
            return C0031aq.m254d(obj);
        }
        return 0;
    }

    public static Type[] m2933(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return m2940(obj);
        }
        return null;
    }

    public static Type m2934(Object obj) {
        if (C0458ze.m10932() >= 0) {
            return ((C0033as) obj).f34T;
        }
        return null;
    }

    public static Object m2935(Object obj) {
        if (adds.m2755() >= 0) {
            return ((Type[]) obj).clone();
        }
        return null;
    }

    public static void m2936(Object obj) {
        if (abe.m2308() <= 0) {
            m2938(obj);
        }
    }

    public static Type m2937(Object obj) {
        if (C0451yg.m9580() > 0) {
            return ((C0033as) obj).f35U;
        }
        return null;
    }

    public static void m2938(Object obj) {
        if (C0453yj.m9966() > 0) {
            m2930((Type) obj);
        }
    }

    public static Type m2939(Object obj) {
        if (gggy.m4365() >= 0) {
            return m2937((C0033as) obj);
        }
        return null;
    }

    public static Type[] m2940(Object obj) {
        if (C0453yj.m9945() <= 0) {
            return m2931((C0033as) obj);
        }
        return null;
    }

    public static Type m2941(Object obj) {
        if (C0453yj.m9945() < 0) {
            return m2934((C0033as) obj);
        }
        return null;
    }

    public static Object m2942(Object obj) {
        if (C0456zb.m10484() < 0) {
            return m2935((Type[]) obj);
        }
        return null;
    }

    public static int m2943(Object obj) {
        if (C0448yd.m9015() < 0) {
            return m2932(obj);
        }
        return 0;
    }

    public boolean equals(Object obj) {
        return (obj instanceof ParameterizedType) && C0448yd.m8888(this, (ParameterizedType) obj);
    }

    @Override
    public Type[] getActualTypeArguments() {
        return (Type[]) m2927(m2933(this));
    }

    @Override
    public Type getOwnerType() {
        return m2929(this);
    }

    @Override
    public Type getRawType() {
        return m2926(this);
    }

    public int hashCode() {
        return (C0448yd.m9083(m2933(this)) ^ C0446yb.m8544(m2926(this))) ^ m2928(m2929(this));
    }

    public String toString() {
        int length = m2933(this).length;
        if (length == 0) {
            return gggy.m4275(m2926(this));
        }
        StringBuilder sb = new StringBuilder((length + 1) * 30);
        C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(sb, gggy.m4275(m2926(this))), C0457zc.m10568()), gggy.m4275(m2933(this)[0]));
        for (int i = 1; i < length; i++) {
            C0460zg.m11407(C0460zg.m11407(sb, abf.m2599()), gggy.m4275(m2933(this)[i]));
        }
        return abc.m1925(C0460zg.m11407(sb, abc.m1885()));
    }
}
