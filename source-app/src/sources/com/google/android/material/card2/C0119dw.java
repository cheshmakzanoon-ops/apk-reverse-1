package com.google.android.material.card2;

class C0119dw extends AbstractC0022ah<StringBuffer> {
    C0119dw() {
    }

    public static StringBuffer m3570(Object obj, Object obj2) {
        if (C0449ye.m9220() < 0) {
            return m3576(obj, obj2);
        }
        return null;
    }

    public static void m3571(Object obj, Object obj2, Object obj3) {
        if (C0449ye.m9220() <= 0) {
            ((C0119dw) obj).a2((C0155fe) obj2, (StringBuffer) obj3);
        }
    }

    public static void m3572(Object obj, Object obj2, Object obj3) {
        if (gggy.m4269() < 0) {
            m3575(obj, obj2, obj3);
        }
    }

    public static int m3573() {
        if (abc.m1845() <= 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static StringBuffer m3574(Object obj, Object obj2) {
        if (abd.m2162() > 0) {
            return ((C0119dw) obj).m403v((C0152fb) obj2);
        }
        return null;
    }

    public static void m3575(Object obj, Object obj2, Object obj3) {
        if (C0448yd.m9015() < 0) {
            m3571((C0119dw) obj, (C0155fe) obj2, (StringBuffer) obj3);
        }
    }

    public static StringBuffer m3576(Object obj, Object obj2) {
        if (m3573() > 0) {
            return m3574((C0119dw) obj, (C0152fb) obj2);
        }
        return null;
    }

    @Override
    public void mo225a(C0155fe c0155fe, StringBuffer stringBuffer) {
        m3572(this, c0155fe, stringBuffer);
    }

    public void a2(C0155fe c0155fe, StringBuffer stringBuffer) {
        C0457zc.m10576(c0155fe, stringBuffer == null ? null : C0455za.m10171(stringBuffer));
    }

    @Override
    public StringBuffer mo227b(C0152fb c0152fb) {
        return m3570(this, c0152fb);
    }

    public StringBuffer m403v(C0152fb c0152fb) {
        if (abe.m2401(c0152fb) != C0452yh.m9757()) {
            return new StringBuffer(C0460zg.m11347(c0152fb));
        }
        C0459zf.m11132(c0152fb);
        return null;
    }
}
