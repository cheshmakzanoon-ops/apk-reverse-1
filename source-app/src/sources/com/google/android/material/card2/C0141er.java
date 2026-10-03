package com.google.android.material.card2;

class C0141er extends AbstractC0022ah<Number> {
    C0141er() {
    }

    public static Number m3703(Object obj, Object obj2) {
        if (C0452yh.m9798() > 0) {
            return m3708(obj, obj2);
        }
        return null;
    }

    public static Number m3704(Object obj, Object obj2) {
        if (adds.m2755() >= 0) {
            return ((C0141er) obj).m416d((C0152fb) obj2);
        }
        return null;
    }

    public static void m3705(Object obj, Object obj2, Object obj3) {
        if (abf.m2510() < 0) {
            ((C0141er) obj).a2((C0155fe) obj2, (Number) obj3);
        }
    }

    public static void m3706(Object obj, Object obj2, Object obj3) {
        if (adds.m2755() > 0) {
            m3707(obj, obj2, obj3);
        }
    }

    public static void m3707(Object obj, Object obj2, Object obj3) {
        if (abe.m2321() < 0) {
            m3705((C0141er) obj, (C0155fe) obj2, (Number) obj3);
        }
    }

    public static Number m3708(Object obj, Object obj2) {
        if (C0448yd.m9074() <= 0) {
            return m3704((C0141er) obj, (C0152fb) obj2);
        }
        return null;
    }

    public void a2(C0155fe c0155fe, Number number) {
        C0459zf.m11149(c0155fe, number);
    }

    @Override
    public void mo225a(C0155fe c0155fe, Number number) {
        m3706(this, c0155fe, number);
    }

    @Override
    public Number mo227b(C0152fb c0152fb) {
        return m3703(this, c0152fb);
    }

    public Number m416d(C0152fb c0152fb) {
        if (abe.m2401(c0152fb) == C0452yh.m9757()) {
            C0459zf.m11132(c0152fb);
            return null;
        }
        try {
            return C0457zc.m10556((short) C0461zs.m11572(c0152fb));
        } catch (NumberFormatException e) {
            throw new C0018ad(e);
        }
    }
}
