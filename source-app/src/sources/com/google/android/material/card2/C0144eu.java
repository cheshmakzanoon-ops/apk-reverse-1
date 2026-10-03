package com.google.android.material.card2;

import java.util.concurrent.atomic.AtomicBoolean;

class C0144eu extends AbstractC0022ah<AtomicBoolean> {
    C0144eu() {
    }

    public static void m3721(Object obj, Object obj2, Object obj3) {
        if (C0450yf.m9352() <= 0) {
            ((C0144eu) obj).a2((C0155fe) obj2, (AtomicBoolean) obj3);
        }
    }

    public static void m3722(Object obj, Object obj2, Object obj3) {
        if (C0447yc.m8635() >= 0) {
            m3725(obj, obj2, obj3);
        }
    }

    public static AtomicBoolean m3723(Object obj, Object obj2) {
        if (C0460zg.m11287() >= 0) {
            return m419(obj, obj2);
        }
        return null;
    }

    public static AtomicBoolean m3724(Object obj, Object obj2) {
        if (adds.m2755() > 0) {
            return ((C0144eu) obj).m420H((C0152fb) obj2);
        }
        return null;
    }

    public static void m3725(Object obj, Object obj2, Object obj3) {
        if (abf.m2500() > 0) {
            m3721((C0144eu) obj, (C0155fe) obj2, (AtomicBoolean) obj3);
        }
    }

    public static AtomicBoolean m419(Object obj, Object obj2) {
        if (gggy.m4365() > 0) {
            return m3724((C0144eu) obj, (C0152fb) obj2);
        }
        return null;
    }

    public AtomicBoolean m420H(C0152fb c0152fb) {
        return new AtomicBoolean(C0459zf.m11079(c0152fb));
    }

    @Override
    public void mo225a(C0155fe c0155fe, AtomicBoolean atomicBoolean) {
        m3722(this, c0155fe, atomicBoolean);
    }

    public void a2(C0155fe c0155fe, AtomicBoolean atomicBoolean) {
        C0445ya.m8296(c0155fe, C0448yd.m9002(atomicBoolean));
    }

    @Override
    public AtomicBoolean mo227b(C0152fb c0152fb) {
        return m3723(this, c0152fb);
    }
}
