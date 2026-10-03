package com.google.android.material.card2;

import java.lang.reflect.Type;
import java.util.Collection;

public final class C0079cj implements InterfaceC0024aj {

    private final C0035au f126bu;

    public C0079cj(C0035au c0035au) {
        this.f126bu = c0035au;
    }

    public static C0035au m3259(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return ((C0079cj) obj).f126bu;
        }
        return null;
    }

    public static C0035au m3260(Object obj) {
        if (abf.m2500() >= 0) {
            return m3259((C0079cj) obj);
        }
        return null;
    }

    @Override
    public <T> AbstractC0022ah<T> mo229a(C0285k c0285k, C0151fa<T> c0151fa) {
        Type typeM10432 = C0456zb.m10432(c0151fa);
        Class clsM1970 = abc.m1970(c0151fa);
        if (!gggy.m4342(Collection.class, clsM1970)) {
            return null;
        }
        Type typeM2688 = adds.m2688(typeM10432, clsM1970);
        return new C0080ck(c0285k, typeM2688, abd.m2165(c0285k, C0461zs.m11619(typeM2688)), C0458ze.m10889(C0450yf.m9462(this), c0151fa));
    }
}
