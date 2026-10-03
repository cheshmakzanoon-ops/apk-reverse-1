package com.google.android.material.card2;

class C0131eh extends AbstractC0022ah<Boolean> {
    C0131eh() {
    }

    public static Boolean m3641(Object obj, Object obj2) {
        if (C0460zg.m11287() >= 0) {
            return m3646(obj, obj2);
        }
        return null;
    }

    public static void m3642(Object obj, Object obj2, Object obj3) {
        if (abf.m2510() <= 0) {
            m3645(obj, obj2, obj3);
        }
    }

    public static void m3643(Object obj, Object obj2, Object obj3) {
        if (C0460zg.m11287() > 0) {
            ((C0131eh) obj).a2((C0155fe) obj2, (Boolean) obj3);
        }
    }

    public static Boolean m3644(Object obj, Object obj2) {
        if (C0461zs.m11510() <= 0) {
            return ((C0131eh) obj).m413F((C0152fb) obj2);
        }
        return null;
    }

    public static void m3645(Object obj, Object obj2, Object obj3) {
        if (C0445ya.m8330() > 0) {
            m3643((C0131eh) obj, (C0155fe) obj2, (Boolean) obj3);
        }
    }

    public static Boolean m3646(Object obj, Object obj2) {
        if (C0453yj.m10032() >= 0) {
            return m3644((C0131eh) obj, (C0152fb) obj2);
        }
        return null;
    }

    public Boolean m413F(C0152fb c0152fb) {
        EnumC0154fd enumC0154fdM2401 = abe.m2401(c0152fb);
        if (enumC0154fdM2401 != C0452yh.m9757()) {
            return enumC0154fdM2401 == abc.m1941() ? C0450yf.m9568(C0448yd.m8936(C0460zg.m11347(c0152fb))) : C0450yf.m9568(C0459zf.m11079(c0152fb));
        }
        C0459zf.m11132(c0152fb);
        return null;
    }

    public void a2(C0155fe c0155fe, Boolean bool) {
        C0457zc.m10688(c0155fe, bool);
    }

    @Override
    public void mo225a(C0155fe c0155fe, Boolean bool) {
        m3642(this, c0155fe, bool);
    }

    @Override
    public Boolean mo227b(C0152fb c0152fb) {
        return m3641(this, c0152fb);
    }
}
