package com.google.android.material.card2;

import java.lang.reflect.Type;
import java.util.Map;

public final class C0088cs implements InterfaceC0024aj {

    final boolean f143bL;

    private final C0035au f144bM;

    public C0088cs(C0035au c0035au, boolean z) {
        this.f144bM = c0035au;
        this.f143bL = z;
    }

    private AbstractC0022ah<?> m370a(C0285k c0285k, Type type) {
        return (type == C0448yd.m9025() || type == Boolean.class) ? adds.m2802() : abd.m2165(c0285k, C0461zs.m11619(type));
    }

    public static C0035au m3336(Object obj) {
        if (abf.m2510() < 0) {
            return ((C0088cs) obj).f144bM;
        }
        return null;
    }

    public static AbstractC0022ah m3337(Object obj, Object obj2, Object obj3) {
        if (C0458ze.m10932() > 0) {
            return ((C0088cs) obj).m370a((C0285k) obj2, (Type) obj3);
        }
        return null;
    }

    public static AbstractC0022ah m3338(Object obj, Object obj2, Object obj3) {
        if (abf.m2500() >= 0) {
            return m3337((C0088cs) obj, (C0285k) obj2, (Type) obj3);
        }
        return null;
    }

    public static C0035au m3339(Object obj) {
        if (C0456zb.m10484() < 0) {
            return m3336((C0088cs) obj);
        }
        return null;
    }

    @Override
    public <T> AbstractC0022ah<T> mo229a(C0285k c0285k, C0151fa<T> c0151fa) {
        Type typeM10432 = C0456zb.m10432(c0151fa);
        if (!gggy.m4342(Map.class, abc.m1970(c0151fa))) {
            return null;
        }
        Type[] typeArrM11276 = C0460zg.m11276(typeM10432, C0445ya.m8294(typeM10432));
        return new C0089ct(this, c0285k, typeArrM11276[0], C0448yd.m8953(this, c0285k, typeArrM11276[0]), typeArrM11276[1], abd.m2165(c0285k, C0461zs.m11619(typeArrM11276[1])), C0458ze.m10889(abc.m1840(this), c0151fa));
    }
}
