package com.google.android.material.card2;

class C0117du extends AbstractC0022ah<StringBuilder> {
    C0117du() {
    }

    public static void m3553(Object obj, Object obj2, Object obj3) {
        if (C0452yh.m9798() > 0) {
            m3557(obj, obj2, obj3);
        }
    }

    public static void m3554(Object obj, Object obj2, Object obj3) {
        if (C0453yj.m10013() > 0) {
            ((C0117du) obj).a2((C0155fe) obj2, (StringBuilder) obj3);
        }
    }

    public static StringBuilder m3555(Object obj, Object obj2) {
        if (abf.m2510() < 0) {
            return ((C0117du) obj).m401t((C0152fb) obj2);
        }
        return null;
    }

    public static StringBuilder m3556(Object obj, Object obj2) {
        if (C0458ze.m10932() >= 0) {
            return m3558(obj, obj2);
        }
        return null;
    }

    public static void m3557(Object obj, Object obj2, Object obj3) {
        if (C0460zg.m11293() >= 0) {
            m3554((C0117du) obj, (C0155fe) obj2, (StringBuilder) obj3);
        }
    }

    public static StringBuilder m3558(Object obj, Object obj2) {
        if (C0457zc.m10555() >= 0) {
            return m3555((C0117du) obj, (C0152fb) obj2);
        }
        return null;
    }

    @Override
    public void mo225a(C0155fe c0155fe, StringBuilder sb) {
        m3553(this, c0155fe, sb);
    }

    public void a2(C0155fe c0155fe, StringBuilder sb) {
        C0457zc.m10576(c0155fe, sb == null ? null : abc.m1925(sb));
    }

    @Override
    public StringBuilder mo227b(C0152fb c0152fb) {
        return m3556(this, c0152fb);
    }

    public StringBuilder m401t(C0152fb c0152fb) {
        if (abe.m2401(c0152fb) != C0452yh.m9757()) {
            return new StringBuilder(C0460zg.m11347(c0152fb));
        }
        C0459zf.m11132(c0152fb);
        return null;
    }
}
