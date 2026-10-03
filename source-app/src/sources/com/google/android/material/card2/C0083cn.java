package com.google.android.material.card2;

import java.lang.annotation.Annotation;

public final class C0083cn implements InterfaceC0024aj {

    private final C0035au f131bz;

    public C0083cn(C0035au c0035au) {
        this.f131bz = c0035au;
    }

    public static C0035au m3281(Object obj) {
        if (C0447yc.m8635() > 0) {
            return ((C0083cn) obj).f131bz;
        }
        return null;
    }

    public static Annotation m3282(Object obj, Object obj2) {
        if (C0447yc.m8635() > 0) {
            return C0598.m11881(obj, obj2);
        }
        return null;
    }

    public static AbstractC0022ah m3283(Object obj, Object obj2, Object obj3, Object obj4, Object obj5) {
        if (C0447yc.m8635() >= 0) {
            return ((C0083cn) obj).m335a((C0035au) obj2, (C0285k) obj3, (C0151fa) obj4, (InterfaceC0026al) obj5);
        }
        return null;
    }

    public static AbstractC0022ah m3284(Object obj, Object obj2, Object obj3, Object obj4, Object obj5) {
        if (C0453yj.m10032() > 0) {
            return m3283((C0083cn) obj, (C0035au) obj2, (C0285k) obj3, (C0151fa) obj4, (InterfaceC0026al) obj5);
        }
        return null;
    }

    public static C0035au m3285(Object obj) {
        if (C0453yj.m9945() < 0) {
            return m3281((C0083cn) obj);
        }
        return null;
    }

    AbstractC0022ah<?> m335a(C0035au c0035au, C0285k c0285k, C0151fa<?> c0151fa, InterfaceC0026al interfaceC0026al) {
        AbstractC0022ah<?> c0102df;
        Object objM2542 = abf.m2542(C0458ze.m10889(c0035au, C0461zs.m11643(C0446yb.m8557(interfaceC0026al))));
        if (objM2542 instanceof AbstractC0022ah) {
            c0102df = (AbstractC0022ah) objM2542;
        } else if (objM2542 instanceof InterfaceC0024aj) {
            c0102df = C0457zc.m10607((InterfaceC0024aj) objM2542, c0285k, c0151fa);
        } else {
            if (!(objM2542 instanceof InterfaceC0017ac) && !(objM2542 instanceof InterfaceC0440u)) {
                throw new IllegalArgumentException(abc.m1925(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0447yc.m8746()), C0456zb.m10455(gggy.m4399(objM2542))), adds.m2666()), C0446yb.m8412(c0151fa)), abd.m2049())));
            }
            c0102df = new C0102df<>(objM2542 instanceof InterfaceC0017ac ? (InterfaceC0017ac) objM2542 : null, objM2542 instanceof InterfaceC0440u ? (InterfaceC0440u) objM2542 : null, c0285k, c0151fa, null);
        }
        return (c0102df == null || !gggy.m4423(interfaceC0026al)) ? c0102df : C0459zf.m11036(c0102df);
    }

    @Override
    public <T> AbstractC0022ah<T> mo229a(C0285k c0285k, C0151fa<T> c0151fa) {
        InterfaceC0026al interfaceC0026al = (InterfaceC0026al) m3282(abc.m1970(c0151fa), InterfaceC0026al.class);
        if (interfaceC0026al == null) {
            return null;
        }
        return C0456zb.m10483(this, abe.m2375(this), c0285k, c0151fa, interfaceC0026al);
    }
}
