package com.google.android.material.card2;

class C0111do extends AbstractC0022ah<Number> {
    C0111do() {
    }

    public static Number m3514(Object obj, Object obj2) {
        if (C0449ye.m9220() < 0) {
            return ((C0111do) obj).m395d((C0152fb) obj2);
        }
        return null;
    }

    public static void m3515(Object obj, Object obj2, Object obj3) {
        if (C0458ze.m10932() > 0) {
            ((C0111do) obj).a2((C0155fe) obj2, (Number) obj3);
        }
    }

    public static void m3516(Object obj, Object obj2, Object obj3) {
        if (abd.m2162() > 0) {
            m3519(obj, obj2, obj3);
        }
    }

    public static Number m3517(Object obj, Object obj2) {
        if (abe.m2308() <= 0) {
            return m3518(obj, obj2);
        }
        return null;
    }

    public static Number m3518(Object obj, Object obj2) {
        if (C0453yj.m9945() < 0) {
            return m3514((C0111do) obj, (C0152fb) obj2);
        }
        return null;
    }

    public static void m3519(Object obj, Object obj2, Object obj3) {
        if (C0448yd.m9074() <= 0) {
            m3515((C0111do) obj, (C0155fe) obj2, (Number) obj3);
        }
    }

    public void a2(C0155fe c0155fe, Number number) {
        C0459zf.m11149(c0155fe, number);
    }

    @Override
    public void mo225a(C0155fe c0155fe, Number number) {
        m3516(this, c0155fe, number);
    }

    @Override
    public Number mo227b(C0152fb c0152fb) {
        return m3517(this, c0152fb);
    }

    public Number m395d(C0152fb c0152fb) {
        if (abe.m2401(c0152fb) != C0452yh.m9757()) {
            return abe.m2379(C0459zf.m11040(c0152fb));
        }
        C0459zf.m11132(c0152fb);
        return null;
    }
}
