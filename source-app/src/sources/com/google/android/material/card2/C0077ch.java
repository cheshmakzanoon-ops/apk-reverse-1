package com.google.android.material.card2;

import java.util.ArrayList;

public final class C0077ch<E> extends AbstractC0022ah<Object> {

    public static final InterfaceC0024aj f123br = new C0078ci();

    private final Class<E> f124bs;

    private final AbstractC0022ah<E> f125bt;

    public C0077ch(C0285k c0285k, AbstractC0022ah<E> abstractC0022ah, Class<E> cls) {
        this.f125bt = new C0105di(c0285k, abstractC0022ah, cls);
        this.f124bs = cls;
    }

    public static void m3253(Object obj) {
        if (C0450yf.m9352() < 0) {
            C0598.m11835(obj);
        }
    }

    public static int m3254(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return C0598.m11824(obj);
        }
        return 0;
    }

    public static Class m3255(Object obj) {
        if (C0459zf.m11062() > 0) {
            return ((C0077ch) obj).f124bs;
        }
        return null;
    }

    public static AbstractC0022ah m3256(Object obj) {
        if (adds.m2755() >= 0) {
            return ((C0077ch) obj).f125bt;
        }
        return null;
    }

    public static Class m3257(Object obj) {
        if (C0448yd.m9015() < 0) {
            return m3255((C0077ch) obj);
        }
        return null;
    }

    public static AbstractC0022ah m3258(Object obj) {
        if (C0448yd.m9074() <= 0) {
            return m3256((C0077ch) obj);
        }
        return null;
    }

    @Override
    public void mo225a(C0155fe c0155fe, Object obj) {
        if (obj == null) {
            C0457zc.m10630(c0155fe);
            return;
        }
        abf.m2469(c0155fe);
        int iM8751 = C0447yc.m8751(obj);
        for (int i = 0; i < iM8751; i++) {
            C0457zc.m10586(C0460zg.m11419(this), c0155fe, C0450yf.m9548(obj, i));
        }
        C0450yf.m9574(c0155fe);
    }

    @Override
    public Object mo227b(C0152fb c0152fb) {
        if (abe.m2401(c0152fb) == C0452yh.m9757()) {
            C0459zf.m11132(c0152fb);
            return null;
        }
        ArrayList arrayList = new ArrayList();
        C0461zs.m11627(c0152fb);
        while (C0455za.m10208(c0152fb)) {
            C0460zg.m11251(arrayList, C0447yc.m8683(C0460zg.m11419(this), c0152fb));
        }
        m3253(c0152fb);
        int iM3254 = m3254(arrayList);
        Object objM2842 = adds.m2842(C0458ze.m10894(this), iM3254);
        for (int i = 0; i < iM3254; i++) {
            C0461zs.m11526(objM2842, i, gggy.m4400(arrayList, i));
        }
        return objM2842;
    }
}
