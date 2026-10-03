package com.google.android.material.card2;

class C0136em implements InterfaceC0024aj {

    final Class f246dJ;

    final AbstractC0022ah f247dK;

    C0136em(Class cls, AbstractC0022ah abstractC0022ah) {
        this.f246dJ = cls;
        this.f247dK = abstractC0022ah;
    }

    public static AbstractC0022ah m3672(Object obj) {
        if (C0450yf.m9352() <= 0) {
            return ((C0136em) obj).f247dK;
        }
        return null;
    }

    public static AbstractC0022ah m3673(Object obj) {
        if (C0450yf.m9352() <= 0) {
            return m3677(obj);
        }
        return null;
    }

    public static Class m3674(Object obj) {
        if (C0449ye.m9220() < 0) {
            return ((C0136em) obj).f246dJ;
        }
        return null;
    }

    public static Class m3675(Object obj) {
        if (C0458ze.m10932() >= 0) {
            return m3676(obj);
        }
        return null;
    }

    public static Class m3676(Object obj) {
        if (abd.m2166() < 0) {
            return m3674((C0136em) obj);
        }
        return null;
    }

    public static AbstractC0022ah m3677(Object obj) {
        if (gggy.m4365() >= 0) {
            return m3672((C0136em) obj);
        }
        return null;
    }

    @Override
    public <T2> AbstractC0022ah<T2> mo229a(C0285k c0285k, C0151fa<T2> c0151fa) {
        Class clsM1970 = abc.m1970(c0151fa);
        if (gggy.m4342(m3675(this), clsM1970)) {
            return new C0137en(this, clsM1970);
        }
        return null;
    }

    public String toString() {
        return abc.m1925(C0460zg.m11407(abd.m2090(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0452yh.m9770()), C0456zb.m10455(m3675(this))), abc.m1820()), m3673(this)), C0450yf.m9561()));
    }
}
