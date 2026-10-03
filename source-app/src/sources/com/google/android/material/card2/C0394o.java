package com.google.android.material.card2;

import java.util.concurrent.atomic.AtomicLong;

class C0394o extends AbstractC0022ah<AtomicLong> {

    final AbstractC0022ah f1263G;

    C0394o(AbstractC0022ah abstractC0022ah) {
        this.f1263G = abstractC0022ah;
    }

    public static void m7531(Object obj, Object obj2, Object obj3) {
        if (C0453yj.m10013() > 0) {
            ((C0394o) obj).a2((C0155fe) obj2, (AtomicLong) obj3);
        }
    }

    public static AtomicLong m7532(Object obj, Object obj2) {
        if (C0449ye.m9220() <= 0) {
            return m7539(obj, obj2);
        }
        return null;
    }

    public static AtomicLong m7533(Object obj, Object obj2) {
        if (abf.m2510() < 0) {
            return ((C0394o) obj).m1293e((C0152fb) obj2);
        }
        return null;
    }

    public static AbstractC0022ah m7534(Object obj) {
        if (C0450yf.m9352() <= 0) {
            return ((C0394o) obj).f1263G;
        }
        return null;
    }

    public static void m7535(Object obj, Object obj2, Object obj3) {
        if (abd.m2162() >= 0) {
            m7537(obj, obj2, obj3);
        }
    }

    public static AbstractC0022ah m7536(Object obj) {
        if (abf.m2510() < 0) {
            return m7538(obj);
        }
        return null;
    }

    public static void m7537(Object obj, Object obj2, Object obj3) {
        if (abe.m2321() < 0) {
            m7531((C0394o) obj, (C0155fe) obj2, (AtomicLong) obj3);
        }
    }

    public static AbstractC0022ah m7538(Object obj) {
        if (abd.m2021() > 0) {
            return m7534((C0394o) obj);
        }
        return null;
    }

    public static AtomicLong m7539(Object obj, Object obj2) {
        if (C0453yj.m9966() >= 0) {
            return m7533((C0394o) obj, (C0152fb) obj2);
        }
        return null;
    }

    @Override
    public void mo225a(C0155fe c0155fe, AtomicLong atomicLong) {
        m7535(this, c0155fe, atomicLong);
    }

    public void a2(C0155fe c0155fe, AtomicLong atomicLong) {
        C0457zc.m10586(m7536(this), c0155fe, C0456zb.m10500(C0453yj.m9919(atomicLong)));
    }

    @Override
    public AtomicLong mo227b(C0152fb c0152fb) {
        return m7532(this, c0152fb);
    }

    public AtomicLong m1293e(C0152fb c0152fb) {
        return new AtomicLong(abe.m2335((Number) C0447yc.m8683(m7536(this), c0152fb)));
    }
}
