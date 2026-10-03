package com.google.android.material.card2;

class C0112dp extends AbstractC0022ah<Number> {
    C0112dp() {
    }

    public static void m3520(Object obj, Object obj2, Object obj3) {
        if (adds.m2755() > 0) {
            ((C0112dp) obj).a2((C0155fe) obj2, (Number) obj3);
        }
    }

    public static int[] m3521() {
        if (gggy.m4269() <= 0) {
            return m3527();
        }
        return null;
    }

    public static int[] m3522() {
        if (C0460zg.m11287() >= 0) {
            return C0138eo.f250dN;
        }
        return null;
    }

    public static void m3523(Object obj, Object obj2, Object obj3) {
        if (adds.m2755() > 0) {
            m3528(obj, obj2, obj3);
        }
    }

    public static Number m3524(Object obj, Object obj2) {
        if (C0447yc.m8635() >= 0) {
            return m3526(obj, obj2);
        }
        return null;
    }

    public static Number m3525(Object obj, Object obj2) {
        if (C0460zg.m11287() > 0) {
            return ((C0112dp) obj).m396d((C0152fb) obj2);
        }
        return null;
    }

    public static Number m3526(Object obj, Object obj2) {
        if (abe.m2321() < 0) {
            return m3525((C0112dp) obj, (C0152fb) obj2);
        }
        return null;
    }

    public static int[] m3527() {
        if (abf.m2500() >= 0) {
            return m3522();
        }
        return null;
    }

    public static void m3528(Object obj, Object obj2, Object obj3) {
        if (C0459zf.m11053() >= 0) {
            m3520((C0112dp) obj, (C0155fe) obj2, (Number) obj3);
        }
    }

    public void a2(C0155fe c0155fe, Number number) {
        C0459zf.m11149(c0155fe, number);
    }

    @Override
    public void mo225a(C0155fe c0155fe, Number number) {
        m3523(this, c0155fe, number);
    }

    @Override
    public Number mo227b(C0152fb c0152fb) {
        return m3524(this, c0152fb);
    }

    public Number m396d(C0152fb c0152fb) {
        EnumC0154fd enumC0154fdM2401 = abe.m2401(c0152fb);
        switch (m3521()[C0456zb.m10476(enumC0154fdM2401)]) {
            case 1:
            case 3:
                return new C0056bn(C0460zg.m11347(c0152fb));
            case 2:
            default:
                throw new C0018ad(abc.m1925(abd.m2090(C0460zg.m11407(new StringBuilder(), C0460zg.m11332()), enumC0154fdM2401)));
            case 4:
                C0459zf.m11132(c0152fb);
                return null;
        }
    }
}
