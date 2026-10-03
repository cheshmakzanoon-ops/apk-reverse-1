package com.google.android.material.card2;

import java.util.Currency;

class C0125eb extends AbstractC0022ah<Currency> {
    C0125eb() {
    }

    public static void m3601(Object obj, Object obj2, Object obj3) {
        if (C0459zf.m11062() >= 0) {
            ((C0125eb) obj).a2((C0155fe) obj2, (Currency) obj3);
        }
    }

    public static void m3602(Object obj, Object obj2, Object obj3) {
        if (C0459zf.m11062() >= 0) {
            m3606(obj, obj2, obj3);
        }
    }

    public static Currency m3603(Object obj, Object obj2) {
        if (C0450yf.m9352() <= 0) {
            return m3605(obj, obj2);
        }
        return null;
    }

    public static Currency m3604(Object obj, Object obj2) {
        if (C0458ze.m10932() >= 0) {
            return ((C0125eb) obj).m408A((C0152fb) obj2);
        }
        return null;
    }

    public static Currency m3605(Object obj, Object obj2) {
        if (abd.m2166() <= 0) {
            return m3604((C0125eb) obj, (C0152fb) obj2);
        }
        return null;
    }

    public static void m3606(Object obj, Object obj2, Object obj3) {
        if (abf.m2500() > 0) {
            m3601((C0125eb) obj, (C0155fe) obj2, (Currency) obj3);
        }
    }

    public Currency m408A(C0152fb c0152fb) {
        return C0455za.m10069(C0460zg.m11347(c0152fb));
    }

    @Override
    public void mo225a(C0155fe c0155fe, Currency currency) {
        m3602(this, c0155fe, currency);
    }

    public void a2(C0155fe c0155fe, Currency currency) {
        C0457zc.m10576(c0155fe, C0447yc.m8623(currency));
    }

    @Override
    public Currency mo227b(C0152fb c0152fb) {
        return m3603(this, c0152fb);
    }
}
