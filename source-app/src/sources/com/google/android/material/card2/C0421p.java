package com.google.android.material.card2;

import java.util.ArrayList;
import java.util.concurrent.atomic.AtomicLongArray;

class C0421p extends AbstractC0022ah<AtomicLongArray> {

    final AbstractC0022ah f1324H;

    C0421p(AbstractC0022ah abstractC0022ah) {
        this.f1324H = abstractC0022ah;
    }

    public static AtomicLongArray m7986(Object obj, Object obj2) {
        if (C0448yd.m9079() < 0) {
            return m7997(obj, obj2);
        }
        return null;
    }

    public static AtomicLongArray m7987(Object obj, Object obj2) {
        if (C0461zs.m11510() < 0) {
            return ((C0421p) obj).m1446f((C0152fb) obj2);
        }
        return null;
    }

    public static AbstractC0022ah m7988(Object obj) {
        if (adds.m2755() >= 0) {
            return m7996(obj);
        }
        return null;
    }

    public static void m7989(Object obj, int i, long j) {
        if (C0460zg.m11287() >= 0) {
            C0598.m11816(obj, i, j);
        }
    }

    public static void m7990(Object obj, Object obj2, Object obj3) {
        if (gggy.m4269() <= 0) {
            ((C0421p) obj).a2((C0155fe) obj2, (AtomicLongArray) obj3);
        }
    }

    public static void m7991(Object obj) {
        if (C0459zf.m11062() >= 0) {
            C0598.m11835(obj);
        }
    }

    public static AbstractC0022ah m7992(Object obj) {
        if (C0461zs.m11510() < 0) {
            return ((C0421p) obj).f1324H;
        }
        return null;
    }

    public static void m7993(Object obj, Object obj2, Object obj3) {
        if (C0452yh.m9798() > 0) {
            m7995(obj, obj2, obj3);
        }
    }

    public static int m7994(Object obj) {
        if (C0453yj.m10013() >= 0) {
            return C0598.m11824(obj);
        }
        return 0;
    }

    public static void m7995(Object obj, Object obj2, Object obj3) {
        if (C0457zc.m10555() > 0) {
            m7990((C0421p) obj, (C0155fe) obj2, (AtomicLongArray) obj3);
        }
    }

    public static AbstractC0022ah m7996(Object obj) {
        if (C0445ya.m8330() >= 0) {
            return m7992((C0421p) obj);
        }
        return null;
    }

    public static AtomicLongArray m7997(Object obj, Object obj2) {
        if (C0453yj.m9945() <= 0) {
            return m7987((C0421p) obj, (C0152fb) obj2);
        }
        return null;
    }

    @Override
    public void mo225a(C0155fe c0155fe, AtomicLongArray atomicLongArray) {
        m7993(this, c0155fe, atomicLongArray);
    }

    public void a2(C0155fe c0155fe, AtomicLongArray atomicLongArray) {
        abf.m2469(c0155fe);
        int iM11453 = C0461zs.m11453(atomicLongArray);
        for (int i = 0; i < iM11453; i++) {
            C0457zc.m10586(m7988(this), c0155fe, C0456zb.m10500(C0458ze.m10924(atomicLongArray, i)));
        }
        C0450yf.m9574(c0155fe);
    }

    @Override
    public AtomicLongArray mo227b(C0152fb c0152fb) {
        return m7986(this, c0152fb);
    }

    public AtomicLongArray m1446f(C0152fb c0152fb) {
        ArrayList arrayList = new ArrayList();
        C0461zs.m11627(c0152fb);
        while (C0455za.m10208(c0152fb)) {
            C0460zg.m11251(arrayList, C0456zb.m10500(abe.m2335((Number) C0447yc.m8683(m7988(this), c0152fb))));
        }
        m7991(c0152fb);
        int iM7994 = m7994(arrayList);
        AtomicLongArray atomicLongArray = new AtomicLongArray(iM7994);
        for (int i = 0; i < iM7994; i++) {
            m7989(atomicLongArray, i, C0448yd.m8854((Long) gggy.m4400(arrayList, i)));
        }
        return atomicLongArray;
    }
}
