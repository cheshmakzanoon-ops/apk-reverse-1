package com.google.android.material.card2;

class C0142es extends AbstractC0022ah<Number> {
    C0142es() {
    }

    public static Number m3709(Object obj, Object obj2) {
        if (C0448yd.m9079() <= 0) {
            return ((C0142es) obj).m417d((C0152fb) obj2);
        }
        return null;
    }

    public static Number m3710(Object obj, Object obj2) {
        if (C0449ye.m9220() < 0) {
            return m3713(obj, obj2);
        }
        return null;
    }

    public static void m3711(Object obj, Object obj2, Object obj3) {
        if (C0459zf.m11062() >= 0) {
            ((C0142es) obj).a2((C0155fe) obj2, (Number) obj3);
        }
    }

    public static void m3712(Object obj, Object obj2, Object obj3) {
        if (C0451yg.m9580() >= 0) {
            m3714(obj, obj2, obj3);
        }
    }

    public static Number m3713(Object obj, Object obj2) {
        if (C0453yj.m9966() > 0) {
            return m3709((C0142es) obj, (C0152fb) obj2);
        }
        return null;
    }

    public static void m3714(Object obj, Object obj2, Object obj3) {
        if (C0453yj.m9996() < 0) {
            m3711((C0142es) obj, (C0155fe) obj2, (Number) obj3);
        }
    }

    public void a2(C0155fe c0155fe, Number number) {
        C0459zf.m11149(c0155fe, number);
    }

    @Override
    public void mo225a(C0155fe c0155fe, Number number) {
        m3712(this, c0155fe, number);
    }

    @Override
    public Number mo227b(C0152fb c0152fb) {
        return m3710(this, c0152fb);
    }

    public Number m417d(C0152fb c0152fb) {
        if (abe.m2401(c0152fb) == C0452yh.m9757()) {
            C0459zf.m11132(c0152fb);
            return null;
        }
        try {
            return abd.m2028(C0461zs.m11572(c0152fb));
        } catch (NumberFormatException e) {
            throw new C0018ad(e);
        }
    }
}
