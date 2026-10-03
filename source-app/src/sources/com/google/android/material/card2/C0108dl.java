package com.google.android.material.card2;

import java.util.ArrayList;
import java.util.concurrent.atomic.AtomicIntegerArray;

class C0108dl extends AbstractC0022ah<AtomicIntegerArray> {
    C0108dl() {
    }

    public static int m3491(Object obj) {
        if (C0458ze.m10932() > 0) {
            return C0598.m11803(obj);
        }
        return 0;
    }

    public static AtomicIntegerArray m3492(Object obj, Object obj2) {
        if (adds.m2755() > 0) {
            return ((C0108dl) obj).m392o((C0152fb) obj2);
        }
        return null;
    }

    public static int m3493(Object obj) {
        if (abf.m2510() <= 0) {
            return C0598.m11854(obj);
        }
        return 0;
    }

    public static int m3494() {
        if (C0446yb.m8415() < 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static AtomicIntegerArray m3495(Object obj, Object obj2) {
        if (abf.m2510() <= 0) {
            return m3500(obj, obj2);
        }
        return null;
    }

    public static int m3496(Object obj) {
        if (C0457zc.m10735() <= 0) {
            return C0598.m11824(obj);
        }
        return 0;
    }

    public static void m3497(Object obj, Object obj2, Object obj3) {
        if (C0448yd.m9079() <= 0) {
            m3501(obj, obj2, obj3);
        }
    }

    public static void m3498(Object obj, Object obj2, Object obj3) {
        if (abc.m1845() <= 0) {
            ((C0108dl) obj).a2((C0155fe) obj2, (AtomicIntegerArray) obj3);
        }
    }

    public static void m3499(Object obj) {
        if (C0460zg.m11287() >= 0) {
            C0598.m11835(obj);
        }
    }

    public static AtomicIntegerArray m3500(Object obj, Object obj2) {
        if (m3494() >= 0) {
            return m3492((C0108dl) obj, (C0152fb) obj2);
        }
        return null;
    }

    public static void m3501(Object obj, Object obj2, Object obj3) {
        if (C0457zc.m10555() >= 0) {
            m3498((C0108dl) obj, (C0155fe) obj2, (AtomicIntegerArray) obj3);
        }
    }

    @Override
    public void mo225a(C0155fe c0155fe, AtomicIntegerArray atomicIntegerArray) {
        m3497(this, c0155fe, atomicIntegerArray);
    }

    public void a2(C0155fe c0155fe, AtomicIntegerArray atomicIntegerArray) {
        abf.m2469(c0155fe);
        int iM3491 = m3491(atomicIntegerArray);
        for (int i = 0; i < iM3491; i++) {
            C0448yd.m9067(c0155fe, C0459zf.m11140(atomicIntegerArray, i));
        }
        C0450yf.m9574(c0155fe);
    }

    @Override
    public AtomicIntegerArray mo227b(C0152fb c0152fb) {
        return m3495(this, c0152fb);
    }

    public AtomicIntegerArray m392o(C0152fb c0152fb) {
        ArrayList arrayList = new ArrayList();
        C0461zs.m11627(c0152fb);
        while (C0455za.m10208(c0152fb)) {
            try {
                C0460zg.m11251(arrayList, abd.m2028(C0461zs.m11572(c0152fb)));
            } catch (NumberFormatException e) {
                throw new C0018ad(e);
            }
        }
        m3499(c0152fb);
        int iM3496 = m3496(arrayList);
        AtomicIntegerArray atomicIntegerArray = new AtomicIntegerArray(iM3496);
        for (int i = 0; i < iM3496; i++) {
            C0458ze.m10953(atomicIntegerArray, i, m3493((Integer) gggy.m4400(arrayList, i)));
        }
        return atomicIntegerArray;
    }
}
