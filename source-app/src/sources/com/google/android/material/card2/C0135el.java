package com.google.android.material.card2;

class C0135el implements InterfaceC0024aj {

    final Class f243dG;

    final Class f244dH;

    final AbstractC0022ah f245dI;

    C0135el(Class cls, Class cls2, AbstractC0022ah abstractC0022ah) {
        this.f243dG = cls;
        this.f244dH = cls2;
        this.f245dI = abstractC0022ah;
    }

    public static Class m3662(Object obj) {
        if (C0453yj.m10013() > 0) {
            return ((C0135el) obj).f243dG;
        }
        return null;
    }

    public static AbstractC0022ah m3663(Object obj) {
        if (adds.m2755() >= 0) {
            return ((C0135el) obj).f245dI;
        }
        return null;
    }

    public static Class m3664(Object obj) {
        if (C0459zf.m11062() >= 0) {
            return ((C0135el) obj).f244dH;
        }
        return null;
    }

    public static Class m3665(Object obj) {
        if (C0458ze.m10932() >= 0) {
            return m3671(obj);
        }
        return null;
    }

    public static Class m3666(Object obj) {
        if (gggy.m4269() < 0) {
            return m3669(obj);
        }
        return null;
    }

    public static AbstractC0022ah m3667(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return m3670(obj);
        }
        return null;
    }

    public static int m3668() {
        if (C0446yb.m8415() <= 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static Class m3669(Object obj) {
        if (m3668() >= 0) {
            return m3664((C0135el) obj);
        }
        return null;
    }

    public static AbstractC0022ah m3670(Object obj) {
        if (m3668() >= 0) {
            return m3663((C0135el) obj);
        }
        return null;
    }

    public static Class m3671(Object obj) {
        if (C0448yd.m9015() < 0) {
            return m3662((C0135el) obj);
        }
        return null;
    }

    @Override
    public <T> AbstractC0022ah<T> mo229a(C0285k c0285k, C0151fa<T> c0151fa) {
        Class clsM1970 = abc.m1970(c0151fa);
        if (clsM1970 == m3665(this) || clsM1970 == m3666(this)) {
            return m3667(this);
        }
        return null;
    }

    public String toString() {
        return abc.m1925(C0460zg.m11407(abd.m2090(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), adds.m2748()), C0456zb.m10455(m3665(this))), C0460zg.m11344()), C0456zb.m10455(m3666(this))), abc.m1820()), m3667(this)), C0450yf.m9561()));
    }
}
