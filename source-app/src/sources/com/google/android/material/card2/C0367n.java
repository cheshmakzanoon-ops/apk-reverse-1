package com.google.android.material.card2;

class C0367n extends AbstractC0022ah<Number> {
    C0367n() {
    }

    public static void m6918(Object obj, Object obj2, Object obj3) {
        if (abd.m2162() > 0) {
            ((C0367n) obj).a2((C0155fe) obj2, (Number) obj3);
        }
    }

    public static String m6919(Object obj) {
        if (C0460zg.m11287() > 0) {
            return C0598.m11838(obj);
        }
        return null;
    }

    public static Number m6920(Object obj, Object obj2) {
        if (C0457zc.m10735() < 0) {
            return ((C0367n) obj).m1186d((C0152fb) obj2);
        }
        return null;
    }

    public static void m6921(Object obj, Object obj2, Object obj3) {
        if (C0449ye.m9220() <= 0) {
            m6923(obj, obj2, obj3);
        }
    }

    public static Number m6922(Object obj, Object obj2) {
        if (C0451yg.m9580() >= 0) {
            return m6924(obj, obj2);
        }
        return null;
    }

    public static void m6923(Object obj, Object obj2, Object obj3) {
        if (C0453yj.m9996() <= 0) {
            m6918((C0367n) obj, (C0155fe) obj2, (Number) obj3);
        }
    }

    public static Number m6924(Object obj, Object obj2) {
        if (abf.m2500() >= 0) {
            return m6920((C0367n) obj, (C0152fb) obj2);
        }
        return null;
    }

    public void a2(C0155fe c0155fe, Number number) {
        if (number == null) {
            C0457zc.m10630(c0155fe);
        } else {
            C0457zc.m10576(c0155fe, m6919(number));
        }
    }

    @Override
    public void mo225a(C0155fe c0155fe, Number number) {
        m6921(this, c0155fe, number);
    }

    @Override
    public Number mo227b(C0152fb c0152fb) {
        return m6922(this, c0152fb);
    }

    public Number m1186d(C0152fb c0152fb) {
        if (abe.m2401(c0152fb) != C0452yh.m9757()) {
            return C0456zb.m10500(abc.m1868(c0152fb));
        }
        C0459zf.m11132(c0152fb);
        return null;
    }
}
