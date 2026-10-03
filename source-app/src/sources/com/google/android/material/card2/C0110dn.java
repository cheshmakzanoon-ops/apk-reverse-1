package com.google.android.material.card2;

class C0110dn extends AbstractC0022ah<Number> {
    C0110dn() {
    }

    public static void m3508(Object obj, Object obj2, Object obj3) {
        if (adds.m2755() > 0) {
            ((C0110dn) obj).a2((C0155fe) obj2, (Number) obj3);
        }
    }

    public static void m3509(Object obj, Object obj2, Object obj3) {
        if (C0461zs.m11510() <= 0) {
            m3513(obj, obj2, obj3);
        }
    }

    public static Number m3510(Object obj, Object obj2) {
        if (C0458ze.m10932() > 0) {
            return m3512(obj, obj2);
        }
        return null;
    }

    public static Number m3511(Object obj, Object obj2) {
        if (C0450yf.m9352() <= 0) {
            return ((C0110dn) obj).m394d((C0152fb) obj2);
        }
        return null;
    }

    public static Number m3512(Object obj, Object obj2) {
        if (C0445ya.m8330() > 0) {
            return m3511((C0110dn) obj, (C0152fb) obj2);
        }
        return null;
    }

    public static void m3513(Object obj, Object obj2, Object obj3) {
        if (abd.m2166() <= 0) {
            m3508((C0110dn) obj, (C0155fe) obj2, (Number) obj3);
        }
    }

    public void a2(C0155fe c0155fe, Number number) {
        C0459zf.m11149(c0155fe, number);
    }

    @Override
    public void mo225a(C0155fe c0155fe, Number number) {
        m3509(this, c0155fe, number);
    }

    @Override
    public Number mo227b(C0152fb c0152fb) {
        return m3510(this, c0152fb);
    }

    public Number m394d(C0152fb c0152fb) {
        if (abe.m2401(c0152fb) != C0452yh.m9757()) {
            return abf.m2605((float) C0459zf.m11040(c0152fb));
        }
        C0459zf.m11132(c0152fb);
        return null;
    }
}
