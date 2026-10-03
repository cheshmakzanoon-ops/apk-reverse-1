package com.google.android.material.card2;

class C0109dm extends AbstractC0022ah<Number> {
    C0109dm() {
    }

    public static void m3502(Object obj, Object obj2, Object obj3) {
        if (C0460zg.m11287() >= 0) {
            m3507(obj, obj2, obj3);
        }
    }

    public static Number m3503(Object obj, Object obj2) {
        if (C0449ye.m9220() <= 0) {
            return m3506(obj, obj2);
        }
        return null;
    }

    public static void m3504(Object obj, Object obj2, Object obj3) {
        if (C0452yh.m9798() > 0) {
            ((C0109dm) obj).a2((C0155fe) obj2, (Number) obj3);
        }
    }

    public static Number m3505(Object obj, Object obj2) {
        if (C0460zg.m11287() >= 0) {
            return ((C0109dm) obj).m393d((C0152fb) obj2);
        }
        return null;
    }

    public static Number m3506(Object obj, Object obj2) {
        if (C0453yj.m10032() > 0) {
            return m3505((C0109dm) obj, (C0152fb) obj2);
        }
        return null;
    }

    public static void m3507(Object obj, Object obj2, Object obj3) {
        if (abd.m2021() > 0) {
            m3504((C0109dm) obj, (C0155fe) obj2, (Number) obj3);
        }
    }

    public void a2(C0155fe c0155fe, Number number) {
        C0459zf.m11149(c0155fe, number);
    }

    @Override
    public void mo225a(C0155fe c0155fe, Number number) {
        m3502(this, c0155fe, number);
    }

    @Override
    public Number mo227b(C0152fb c0152fb) {
        return m3503(this, c0152fb);
    }

    public Number m393d(C0152fb c0152fb) {
        if (abe.m2401(c0152fb) == C0452yh.m9757()) {
            C0459zf.m11132(c0152fb);
            return null;
        }
        try {
            return C0456zb.m10500(abc.m1868(c0152fb));
        } catch (NumberFormatException e) {
            throw new C0018ad(e);
        }
    }
}
