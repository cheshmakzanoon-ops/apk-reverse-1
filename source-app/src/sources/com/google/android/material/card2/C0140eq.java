package com.google.android.material.card2;

class C0140eq extends AbstractC0022ah<Number> {
    C0140eq() {
    }

    public static Number m3697(Object obj, Object obj2) {
        if (C0456zb.m10326() <= 0) {
            return ((C0140eq) obj).m415d((C0152fb) obj2);
        }
        return null;
    }

    public static Number m3698(Object obj, Object obj2) {
        if (C0456zb.m10326() <= 0) {
            return m3701(obj, obj2);
        }
        return null;
    }

    public static void m3699(Object obj, Object obj2, Object obj3) {
        if (abf.m2510() < 0) {
            ((C0140eq) obj).a2((C0155fe) obj2, (Number) obj3);
        }
    }

    public static void m3700(Object obj, Object obj2, Object obj3) {
        if (C0445ya.m8222() >= 0) {
            m3702(obj, obj2, obj3);
        }
    }

    public static Number m3701(Object obj, Object obj2) {
        if (abf.m2500() >= 0) {
            return m3697((C0140eq) obj, (C0152fb) obj2);
        }
        return null;
    }

    public static void m3702(Object obj, Object obj2, Object obj3) {
        if (C0448yd.m9074() <= 0) {
            m3699((C0140eq) obj, (C0155fe) obj2, (Number) obj3);
        }
    }

    public void a2(C0155fe c0155fe, Number number) {
        C0459zf.m11149(c0155fe, number);
    }

    @Override
    public void mo225a(C0155fe c0155fe, Number number) {
        m3700(this, c0155fe, number);
    }

    @Override
    public Number mo227b(C0152fb c0152fb) {
        return m3698(this, c0152fb);
    }

    public Number m415d(C0152fb c0152fb) {
        if (abe.m2401(c0152fb) == C0452yh.m9757()) {
            C0459zf.m11132(c0152fb);
            return null;
        }
        try {
            return C0460zg.m11246((byte) C0461zs.m11572(c0152fb));
        } catch (NumberFormatException e) {
            throw new C0018ad(e);
        }
    }
}
