package com.google.android.material.card2;

class C0433q<T> extends AbstractC0022ah<T> {

    private AbstractC0022ah<T> f1348I;

    C0433q() {
    }

    public static AbstractC0022ah m8182(Object obj) {
        if (C0459zf.m11062() >= 0) {
            return m8184(obj);
        }
        return null;
    }

    public static AbstractC0022ah m8183(Object obj) {
        if (C0458ze.m10932() > 0) {
            return ((C0433q) obj).f1348I;
        }
        return null;
    }

    public static AbstractC0022ah m8184(Object obj) {
        if (abf.m2500() >= 0) {
            return m8183((C0433q) obj);
        }
        return null;
    }

    @Override
    public void mo225a(C0155fe c0155fe, T t) {
        if (m8182(this) == null) {
            throw new IllegalStateException();
        }
        C0457zc.m10586(m8182(this), c0155fe, t);
    }

    @Override
    public T mo227b(C0152fb c0152fb) {
        if (m8182(this) == null) {
            throw new IllegalStateException();
        }
        return (T) C0447yc.m8683(m8182(this), c0152fb);
    }

    public void m1466c(AbstractC0022ah<T> abstractC0022ah) {
        if (m8182(this) != null) {
            throw new AssertionError();
        }
        this.f1348I = abstractC0022ah;
    }
}
