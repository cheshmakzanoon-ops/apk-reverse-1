package com.google.android.material.card2;

class C0133ej implements InterfaceC0024aj {

    final Class f238dB;

    final AbstractC0022ah f239dC;

    C0133ej(Class cls, AbstractC0022ah abstractC0022ah) {
        this.f238dB = cls;
        this.f239dC = abstractC0022ah;
    }

    public static Class m3647(Object obj) {
        if (abd.m2162() > 0) {
            return m3651(obj);
        }
        return null;
    }

    public static AbstractC0022ah m3648(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return ((C0133ej) obj).f239dC;
        }
        return null;
    }

    public static Class m3649(Object obj) {
        if (C0458ze.m10932() >= 0) {
            return ((C0133ej) obj).f238dB;
        }
        return null;
    }

    public static AbstractC0022ah m3650(Object obj) {
        if (gggy.m4269() <= 0) {
            return m3652(obj);
        }
        return null;
    }

    public static Class m3651(Object obj) {
        if (abd.m2166() < 0) {
            return m3649((C0133ej) obj);
        }
        return null;
    }

    public static AbstractC0022ah m3652(Object obj) {
        if (C0445ya.m8330() >= 0) {
            return m3648((C0133ej) obj);
        }
        return null;
    }

    @Override
    public <T> AbstractC0022ah<T> mo229a(C0285k c0285k, C0151fa<T> c0151fa) {
        if (abc.m1970(c0151fa) == m3647(this)) {
            return m3650(this);
        }
        return null;
    }

    public String toString() {
        return abc.m1925(C0460zg.m11407(abd.m2090(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), adds.m2748()), C0456zb.m10455(m3647(this))), abc.m1820()), m3650(this)), C0450yf.m9561()));
    }
}
