package com.google.android.material.card2;

class C0312l extends AbstractC0022ah<Number> {

    final C0285k f953E;

    C0312l(C0285k c0285k) {
        this.f953E = c0285k;
    }

    public static void m5948(Object obj, Object obj2, Object obj3) {
        if (C0452yh.m9798() >= 0) {
            ((C0312l) obj).a2((C0155fe) obj2, (Number) obj3);
        }
    }

    public static Double m5949(Object obj, Object obj2) {
        if (C0453yj.m10013() >= 0) {
            return ((C0312l) obj).m992a((C0152fb) obj2);
        }
        return null;
    }

    public static void m5950(double d) {
        if (C0457zc.m10735() < 0) {
            m5955(d);
        }
    }

    public static void m5951(double d) {
        if (adds.m2755() >= 0) {
            C0285k.m848a(d);
        }
    }

    public static void m5952(Object obj, Object obj2, Object obj3) {
        if (abf.m2510() < 0) {
            m5956(obj, obj2, obj3);
        }
    }

    public static Double m5953(Object obj, Object obj2) {
        if (C0445ya.m8222() > 0) {
            return m5954(obj, obj2);
        }
        return null;
    }

    public static Double m5954(Object obj, Object obj2) {
        if (C0456zb.m10484() <= 0) {
            return m5949((C0312l) obj, (C0152fb) obj2);
        }
        return null;
    }

    public static void m5955(double d) {
        if (C0448yd.m9074() <= 0) {
            m5951(d);
        }
    }

    public static void m5956(Object obj, Object obj2, Object obj3) {
        if (gggy.m4365() >= 0) {
            m5948((C0312l) obj, (C0155fe) obj2, (Number) obj3);
        }
    }

    public Double m992a(C0152fb c0152fb) {
        if (abe.m2401(c0152fb) != C0452yh.m9757()) {
            return abe.m2379(C0459zf.m11040(c0152fb));
        }
        C0459zf.m11132(c0152fb);
        return null;
    }

    public void a2(C0155fe c0155fe, Number number) {
        if (number == null) {
            C0457zc.m10630(c0155fe);
        } else {
            m5950(C0448yd.m9008(number));
            C0459zf.m11149(c0155fe, number);
        }
    }

    @Override
    public void mo225a(C0155fe c0155fe, Number number) {
        m5952(this, c0155fe, number);
    }

    @Override
    public Number mo227b(C0152fb c0152fb) {
        return m5953(this, c0152fb);
    }
}
