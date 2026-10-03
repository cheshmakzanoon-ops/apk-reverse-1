package com.google.android.material.card2;

import java.lang.reflect.Constructor;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.Collection;
import java.util.EnumSet;
import java.util.Map;
import java.util.Queue;
import java.util.Set;
import java.util.SortedMap;
import java.util.SortedSet;
import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.ConcurrentNavigableMap;

public final class C0035au {

    private final AbstractC0148ey f39Y = C0453yj.m10003();

    private final Map<Type, InterfaceC0434r<?>> f40Z;

    public C0035au(Map<Type, InterfaceC0434r<?>> map) {
        this.f40Z = map;
    }

    private <T> InterfaceC0065bw<T> m261c(Class<? super T> cls) {
        try {
            Constructor constructorM11490 = C0461zs.m11490(cls, new Class[0]);
            if (!abf.m2501(constructorM11490)) {
                C0445ya.m8343(C0445ya.m8196(this), constructorM11490);
            }
            return new C0045bc(this, constructorM11490);
        } catch (NoSuchMethodException e) {
            return null;
        }
    }

    private <T> InterfaceC0065bw<T> m262c(Type type, Class<? super T> cls) {
        if (gggy.m4342(Collection.class, cls)) {
            if (gggy.m4342(SortedSet.class, cls)) {
                return new C0046bd(this);
            }
            if (gggy.m4342(EnumSet.class, cls)) {
                return new C0047be(this, type);
            }
            if (gggy.m4342(Set.class, cls)) {
                return new C0048bf(this);
            }
            return gggy.m4342(Queue.class, cls) ? new C0049bg(this) : new C0050bh(this);
        }
        if (!gggy.m4342(Map.class, cls)) {
            return null;
        }
        if (gggy.m4342(ConcurrentNavigableMap.class, cls)) {
            return new C0051bi(this);
        }
        if (gggy.m4342(ConcurrentMap.class, cls)) {
            return new C0037aw(this);
        }
        if (gggy.m4342(SortedMap.class, cls)) {
            return new C0038ax(this);
        }
        return (!(type instanceof ParameterizedType) || gggy.m4342(String.class, abc.m1970(C0461zs.m11619(C0448yd.m8866((ParameterizedType) type)[0])))) ? new C0040az(this) : new C0039ay(this);
    }

    private <T> InterfaceC0065bw<T> m263d(Type type, Class<? super T> cls) {
        return new C0043ba(this, cls, type);
    }

    public static InterfaceC0065bw m2956(Object obj, Object obj2) {
        if (C0447yc.m8635() > 0) {
            return ((C0035au) obj).m261c((Class) obj2);
        }
        return null;
    }

    public static InterfaceC0065bw m2957(Object obj, Object obj2, Object obj3) {
        if (C0447yc.m8635() > 0) {
            return ((C0035au) obj).m263d((Type) obj2, (Class) obj3);
        }
        return null;
    }

    public static AbstractC0148ey m2958(Object obj) {
        if (abe.m2308() < 0) {
            return ((C0035au) obj).f39Y;
        }
        return null;
    }

    public static String m2959(Object obj) {
        if (C0460zg.m11287() > 0) {
            return C0598.m11838(obj);
        }
        return null;
    }

    public static Map m2960(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return ((C0035au) obj).f40Z;
        }
        return null;
    }

    public static InterfaceC0065bw m2961(Object obj, Object obj2, Object obj3) {
        if (C0459zf.m11062() >= 0) {
            return ((C0035au) obj).m262c((Type) obj2, (Class) obj3);
        }
        return null;
    }

    public static Map m2962(Object obj) {
        if (abd.m2021() >= 0) {
            return m2960((C0035au) obj);
        }
        return null;
    }

    public static InterfaceC0065bw m2963(Object obj, Object obj2, Object obj3) {
        if (C0458ze.m10926() <= 0) {
            return m2961((C0035au) obj, (Type) obj2, (Class) obj3);
        }
        return null;
    }

    public static InterfaceC0065bw m2964(Object obj, Object obj2) {
        if (C0448yd.m9074() <= 0) {
            return m2956((C0035au) obj, (Class) obj2);
        }
        return null;
    }

    public static AbstractC0148ey m2965(Object obj) {
        if (C0453yj.m9996() <= 0) {
            return m2958((C0035au) obj);
        }
        return null;
    }

    public static InterfaceC0065bw m2966(Object obj, Object obj2, Object obj3) {
        if (abf.m2500() > 0) {
            return m2957((C0035au) obj, (Type) obj2, (Class) obj3);
        }
        return null;
    }

    public <T> InterfaceC0065bw<T> m264b(C0151fa<T> c0151fa) {
        Type typeM10432 = C0456zb.m10432(c0151fa);
        Class clsM1970 = abc.m1970(c0151fa);
        InterfaceC0434r interfaceC0434r = (InterfaceC0434r) adds.m2889(adds.m2830(this), typeM10432);
        if (interfaceC0434r != null) {
            return new C0036av(this, interfaceC0434r, typeM10432);
        }
        InterfaceC0434r interfaceC0434r2 = (InterfaceC0434r) adds.m2889(adds.m2830(this), clsM1970);
        if (interfaceC0434r2 != null) {
            return new C0044bb(this, interfaceC0434r2, typeM10432);
        }
        InterfaceC0065bw<T> interfaceC0065bwM10528 = C0457zc.m10528(this, clsM1970);
        if (interfaceC0065bwM10528 != null) {
            return interfaceC0065bwM10528;
        }
        InterfaceC0065bw<T> interfaceC0065bwM10412 = C0456zb.m10412(this, typeM10432, clsM1970);
        return interfaceC0065bwM10412 == null ? C0450yf.m9434(this, typeM10432, clsM1970) : interfaceC0065bwM10412;
    }

    public String toString() {
        return m2959(adds.m2830(this));
    }
}
