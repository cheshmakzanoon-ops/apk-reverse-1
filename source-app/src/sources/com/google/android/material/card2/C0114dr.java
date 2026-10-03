package com.google.android.material.card2;

class C0114dr extends AbstractC0022ah<String> {
    C0114dr() {
    }

    public static String m3535(Object obj, Object obj2) {
        if (C0457zc.m10735() <= 0) {
            return m3540(obj, obj2);
        }
        return null;
    }

    public static void m3536(Object obj, Object obj2, Object obj3) {
        if (C0457zc.m10735() <= 0) {
            ((C0114dr) obj).a2((C0155fe) obj2, (String) obj3);
        }
    }

    public static void m3537(Object obj, Object obj2, Object obj3) {
        if (adds.m2755() > 0) {
            m3539(obj, obj2, obj3);
        }
    }

    public static String m3538(Object obj, Object obj2) {
        if (C0447yc.m8635() > 0) {
            return ((C0114dr) obj).m398q((C0152fb) obj2);
        }
        return null;
    }

    public static void m3539(Object obj, Object obj2, Object obj3) {
        if (abd.m2166() <= 0) {
            m3536((C0114dr) obj, (C0155fe) obj2, (String) obj3);
        }
    }

    public static String m3540(Object obj, Object obj2) {
        if (C0459zf.m11053() >= 0) {
            return m3538((C0114dr) obj, (C0152fb) obj2);
        }
        return null;
    }

    @Override
    public void mo225a(C0155fe c0155fe, String str) {
        m3537(this, c0155fe, str);
    }

    public void a2(C0155fe c0155fe, String str) {
        C0457zc.m10576(c0155fe, str);
    }

    @Override
    public String mo227b(C0152fb c0152fb) {
        return m3535(this, c0152fb);
    }

    public String m398q(C0152fb c0152fb) {
        EnumC0154fd enumC0154fdM2401 = abe.m2401(c0152fb);
        if (enumC0154fdM2401 != C0452yh.m9757()) {
            return enumC0154fdM2401 == C0450yf.m9431() ? C0460zg.m11273(C0459zf.m11079(c0152fb)) : C0460zg.m11347(c0152fb);
        }
        C0459zf.m11132(c0152fb);
        return null;
    }
}
