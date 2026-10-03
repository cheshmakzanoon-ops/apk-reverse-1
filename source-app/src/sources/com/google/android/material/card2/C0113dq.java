package com.google.android.material.card2;

class C0113dq extends AbstractC0022ah<Character> {
    C0113dq() {
    }

    public static void m3529(Object obj, Object obj2, Object obj3) {
        if (C0450yf.m9352() < 0) {
            ((C0113dq) obj).a2((C0155fe) obj2, (Character) obj3);
        }
    }

    public static void m3530(Object obj, Object obj2, Object obj3) {
        if (C0461zs.m11510() <= 0) {
            m3534(obj, obj2, obj3);
        }
    }

    public static Character m3531(Object obj, Object obj2) {
        if (C0453yj.m10013() > 0) {
            return ((C0113dq) obj).m397p((C0152fb) obj2);
        }
        return null;
    }

    public static Character m3532(Object obj, Object obj2) {
        if (C0461zs.m11510() <= 0) {
            return m3533(obj, obj2);
        }
        return null;
    }

    public static Character m3533(Object obj, Object obj2) {
        if (abf.m2500() >= 0) {
            return m3531((C0113dq) obj, (C0152fb) obj2);
        }
        return null;
    }

    public static void m3534(Object obj, Object obj2, Object obj3) {
        if (C0453yj.m9966() >= 0) {
            m3529((C0113dq) obj, (C0155fe) obj2, (Character) obj3);
        }
    }

    public void a2(C0155fe c0155fe, Character ch) {
        C0457zc.m10576(c0155fe, ch == null ? null : C0456zb.m10388(ch));
    }

    @Override
    public void mo225a(C0155fe c0155fe, Character ch) {
        m3530(this, c0155fe, ch);
    }

    @Override
    public Character mo227b(C0152fb c0152fb) {
        return m3532(this, c0152fb);
    }

    public Character m397p(C0152fb c0152fb) {
        if (abe.m2401(c0152fb) == C0452yh.m9757()) {
            C0459zf.m11132(c0152fb);
            return null;
        }
        String strM11347 = C0460zg.m11347(c0152fb);
        if (gggy.m4397(strM11347) != 1) {
            throw new C0018ad(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), gggy.m4378()), strM11347)));
        }
        return C0449ye.m9245(C0446yb.m8419(strM11347, 0));
    }
}
