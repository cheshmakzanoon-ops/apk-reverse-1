package com.google.android.material.card2;

import java.net.URL;

class C0120dx extends AbstractC0022ah<URL> {
    C0120dx() {
    }

    public static URL m3577(Object obj, Object obj2) {
        if (C0459zf.m11062() >= 0) {
            return ((C0120dx) obj).m404w((C0152fb) obj2);
        }
        return null;
    }

    public static void m3578(Object obj, Object obj2, Object obj3) {
        if (C0456zb.m10326() < 0) {
            m3581(obj, obj2, obj3);
        }
    }

    public static void m3579(Object obj, Object obj2, Object obj3) {
        if (C0460zg.m11287() > 0) {
            ((C0120dx) obj).a2((C0155fe) obj2, (URL) obj3);
        }
    }

    public static URL m3580(Object obj, Object obj2) {
        if (C0458ze.m10932() > 0) {
            return m3582(obj, obj2);
        }
        return null;
    }

    public static void m3581(Object obj, Object obj2, Object obj3) {
        if (C0453yj.m9945() < 0) {
            m3579((C0120dx) obj, (C0155fe) obj2, (URL) obj3);
        }
    }

    public static URL m3582(Object obj, Object obj2) {
        if (C0453yj.m9966() >= 0) {
            return m3577((C0120dx) obj, (C0152fb) obj2);
        }
        return null;
    }

    @Override
    public void mo225a(C0155fe c0155fe, URL url) {
        m3578(this, c0155fe, url);
    }

    public void a2(C0155fe c0155fe, URL url) {
        C0457zc.m10576(c0155fe, url == null ? null : C0459zf.m11072(url));
    }

    @Override
    public URL mo227b(C0152fb c0152fb) {
        return m3580(this, c0152fb);
    }

    public URL m404w(C0152fb c0152fb) {
        if (abe.m2401(c0152fb) == C0452yh.m9757()) {
            C0459zf.m11132(c0152fb);
            return null;
        }
        String strM11347 = C0460zg.m11347(c0152fb);
        if (C0452yh.m9583(C0448yd.m8883(), strM11347)) {
            return null;
        }
        return new URL(strM11347);
    }
}
