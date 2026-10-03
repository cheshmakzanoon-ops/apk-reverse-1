package com.google.android.material.card2;

class C0023ai<T> extends AbstractC0022ah<T> {

    final AbstractC0022ah f31Q;

    C0023ai(AbstractC0022ah abstractC0022ah) {
        this.f31Q = abstractC0022ah;
    }

    public static AbstractC0022ah m2900(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return ((C0023ai) obj).f31Q;
        }
        return null;
    }

    public static AbstractC0022ah m2901(Object obj) {
        if (C0450yf.m9352() < 0) {
            return m2902(obj);
        }
        return null;
    }

    public static AbstractC0022ah m2902(Object obj) {
        if (C0457zc.m10718() <= 0) {
            return m2900((C0023ai) obj);
        }
        return null;
    }

    @Override
    public void mo225a(C0155fe c0155fe, T t) {
        if (t == null) {
            C0457zc.m10630(c0155fe);
        } else {
            C0457zc.m10586(m2901(this), c0155fe, t);
        }
    }

    @Override
    public T mo227b(C0152fb c0152fb) {
        if (abe.m2401(c0152fb) != C0452yh.m9757()) {
            return (T) C0447yc.m8683(m2901(this), c0152fb);
        }
        C0459zf.m11132(c0152fb);
        return null;
    }
}
