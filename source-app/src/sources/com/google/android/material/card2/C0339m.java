package com.google.android.material.card2;

class C0339m extends AbstractC0022ah<Number> {

    final C0285k f1044F;

    C0339m(C0285k c0285k) {
        this.f1044F = c0285k;
    }

    public static int m6258() {
        if (C0456zb.m10326() < 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static void m6259(double d) {
        if (abc.m1845() <= 0) {
            C0285k.m848a(d);
        }
    }

    public static Float m6260(Object obj, Object obj2) {
        if (C0461zs.m11510() <= 0) {
            return ((C0339m) obj).m1096c((C0152fb) obj2);
        }
        return null;
    }

    public static Float m6261(Object obj, Object obj2) {
        if (C0445ya.m8222() >= 0) {
            return m6265(obj, obj2);
        }
        return null;
    }

    public static void m6262(Object obj, Object obj2, Object obj3) {
        if (C0460zg.m11287() > 0) {
            ((C0339m) obj).a2((C0155fe) obj2, (Number) obj3);
        }
    }

    public static void m6263(double d) {
        if (abc.m1845() < 0) {
            m6267(d);
        }
    }

    public static void m6264(Object obj, Object obj2, Object obj3) {
        if (C0453yj.m10013() >= 0) {
            m6266(obj, obj2, obj3);
        }
    }

    public static Float m6265(Object obj, Object obj2) {
        if (m6258() >= 0) {
            return m6260((C0339m) obj, (C0152fb) obj2);
        }
        return null;
    }

    public static void m6266(Object obj, Object obj2, Object obj3) {
        if (C0453yj.m9996() <= 0) {
            m6262((C0339m) obj, (C0155fe) obj2, (Number) obj3);
        }
    }

    public static void m6267(double d) {
        if (C0457zc.m10555() >= 0) {
            m6259(d);
        }
    }

    public void a2(C0155fe c0155fe, Number number) {
        if (number == null) {
            C0457zc.m10630(c0155fe);
        } else {
            m6263(C0450yf.m9479(number));
            C0459zf.m11149(c0155fe, number);
        }
    }

    @Override
    public void mo225a(C0155fe c0155fe, Number number) {
        m6264(this, c0155fe, number);
    }

    @Override
    public Number mo227b(C0152fb c0152fb) {
        return m6261(this, c0152fb);
    }

    public Float m1096c(C0152fb c0152fb) {
        if (abe.m2401(c0152fb) != C0452yh.m9757()) {
            return abf.m2605((float) C0459zf.m11040(c0152fb));
        }
        C0459zf.m11132(c0152fb);
        return null;
    }
}
