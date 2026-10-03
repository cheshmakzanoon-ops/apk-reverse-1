package com.google.android.material.card2;

class C0139ep extends AbstractC0022ah<Boolean> {
    C0139ep() {
    }

    public static Boolean m3691(Object obj, Object obj2) {
        if (C0452yh.m9798() >= 0) {
            return ((C0139ep) obj).m414F((C0152fb) obj2);
        }
        return null;
    }

    public static void m3692(Object obj, Object obj2, Object obj3) {
        if (C0445ya.m8222() >= 0) {
            ((C0139ep) obj).a2((C0155fe) obj2, (Boolean) obj3);
        }
    }

    public static Boolean m3693(Object obj, Object obj2) {
        if (C0447yc.m8635() >= 0) {
            return m3696(obj, obj2);
        }
        return null;
    }

    public static void m3694(Object obj, Object obj2, Object obj3) {
        if (abc.m1845() < 0) {
            m3695(obj, obj2, obj3);
        }
    }

    public static void m3695(Object obj, Object obj2, Object obj3) {
        if (C0457zc.m10718() <= 0) {
            m3692((C0139ep) obj, (C0155fe) obj2, (Boolean) obj3);
        }
    }

    public static Boolean m3696(Object obj, Object obj2) {
        if (C0456zb.m10484() <= 0) {
            return m3691((C0139ep) obj, (C0152fb) obj2);
        }
        return null;
    }

    public Boolean m414F(C0152fb c0152fb) {
        if (abe.m2401(c0152fb) != C0452yh.m9757()) {
            return C0455za.m10237(C0460zg.m11347(c0152fb));
        }
        C0459zf.m11132(c0152fb);
        return null;
    }

    public void a2(C0155fe c0155fe, Boolean bool) {
        C0457zc.m10576(c0155fe, bool == null ? C0448yd.m8883() : C0450yf.m9390(bool));
    }

    @Override
    public void mo225a(C0155fe c0155fe, Boolean bool) {
        m3694(this, c0155fe, bool);
    }

    @Override
    public Boolean mo227b(C0152fb c0152fb) {
        return m3693(this, c0152fb);
    }
}
