package com.google.android.material.card2;

import java.net.URI;
import java.net.URISyntaxException;

class C0121dy extends AbstractC0022ah<URI> {
    C0121dy() {
    }

    public static void m3583(Object obj, Object obj2, Object obj3) {
        if (C0451yg.m9580() >= 0) {
            m3588(obj, obj2, obj3);
        }
    }

    public static URI m3584(Object obj, Object obj2) {
        if (abc.m1845() <= 0) {
            return m3587(obj, obj2);
        }
        return null;
    }

    public static void m3585(Object obj, Object obj2, Object obj3) {
        if (C0457zc.m10735() <= 0) {
            ((C0121dy) obj).a2((C0155fe) obj2, (URI) obj3);
        }
    }

    public static URI m3586(Object obj, Object obj2) {
        if (C0450yf.m9352() < 0) {
            return ((C0121dy) obj).m405x((C0152fb) obj2);
        }
        return null;
    }

    public static URI m3587(Object obj, Object obj2) {
        if (C0457zc.m10555() >= 0) {
            return m3586((C0121dy) obj, (C0152fb) obj2);
        }
        return null;
    }

    public static void m3588(Object obj, Object obj2, Object obj3) {
        if (abd.m2021() > 0) {
            m3585((C0121dy) obj, (C0155fe) obj2, (URI) obj3);
        }
    }

    @Override
    public void mo225a(C0155fe c0155fe, URI uri) {
        m3583(this, c0155fe, uri);
    }

    public void a2(C0155fe c0155fe, URI uri) {
        C0457zc.m10576(c0155fe, uri == null ? null : C0447yc.m8737(uri));
    }

    @Override
    public URI mo227b(C0152fb c0152fb) {
        return m3584(this, c0152fb);
    }

    public URI m405x(C0152fb c0152fb) {
        if (abe.m2401(c0152fb) == C0452yh.m9757()) {
            C0459zf.m11132(c0152fb);
            return null;
        }
        try {
            String strM11347 = C0460zg.m11347(c0152fb);
            if (C0452yh.m9583(C0448yd.m8883(), strM11347)) {
                return null;
            }
            return new URI(strM11347);
        } catch (URISyntaxException e) {
            throw new C0442w(e);
        }
    }
}
