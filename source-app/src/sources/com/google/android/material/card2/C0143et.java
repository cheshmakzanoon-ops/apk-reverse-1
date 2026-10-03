package com.google.android.material.card2;

import java.util.concurrent.atomic.AtomicInteger;

class C0143et extends AbstractC0022ah<AtomicInteger> {
    C0143et() {
    }

    public static AtomicInteger m3715(Object obj, Object obj2) {
        if (abe.m2308() <= 0) {
            return ((C0143et) obj).m418G((C0152fb) obj2);
        }
        return null;
    }

    public static void m3716(Object obj, Object obj2, Object obj3) {
        if (C0460zg.m11287() >= 0) {
            ((C0143et) obj).a2((C0155fe) obj2, (AtomicInteger) obj3);
        }
    }

    public static AtomicInteger m3717(Object obj, Object obj2) {
        if (C0460zg.m11287() > 0) {
            return m3720(obj, obj2);
        }
        return null;
    }

    public static void m3718(Object obj, Object obj2, Object obj3) {
        if (C0445ya.m8222() > 0) {
            m3719(obj, obj2, obj3);
        }
    }

    public static void m3719(Object obj, Object obj2, Object obj3) {
        if (C0448yd.m9015() <= 0) {
            m3716((C0143et) obj, (C0155fe) obj2, (AtomicInteger) obj3);
        }
    }

    public static AtomicInteger m3720(Object obj, Object obj2) {
        if (abd.m2166() <= 0) {
            return m3715((C0143et) obj, (C0152fb) obj2);
        }
        return null;
    }

    public AtomicInteger m418G(C0152fb c0152fb) {
        try {
            return new AtomicInteger(C0461zs.m11572(c0152fb));
        } catch (NumberFormatException e) {
            throw new C0018ad(e);
        }
    }

    @Override
    public void mo225a(C0155fe c0155fe, AtomicInteger atomicInteger) {
        m3718(this, c0155fe, atomicInteger);
    }

    public void a2(C0155fe c0155fe, AtomicInteger atomicInteger) {
        C0448yd.m9067(c0155fe, C0456zb.m10498(atomicInteger));
    }

    @Override
    public AtomicInteger mo227b(C0152fb c0152fb) {
        return m3717(this, c0152fb);
    }
}
