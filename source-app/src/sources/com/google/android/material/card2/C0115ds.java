package com.google.android.material.card2;

import java.math.BigDecimal;

class C0115ds extends AbstractC0022ah<BigDecimal> {
    C0115ds() {
    }

    public static void m3541(Object obj, Object obj2, Object obj3) {
        if (gggy.m4269() <= 0) {
            m3546(obj, obj2, obj3);
        }
    }

    public static void m3542(Object obj, Object obj2, Object obj3) {
        if (C0453yj.m10013() > 0) {
            ((C0115ds) obj).a2((C0155fe) obj2, (BigDecimal) obj3);
        }
    }

    public static BigDecimal m3543(Object obj, Object obj2) {
        if (C0461zs.m11510() < 0) {
            return m3545(obj, obj2);
        }
        return null;
    }

    public static BigDecimal m3544(Object obj, Object obj2) {
        if (gggy.m4269() < 0) {
            return ((C0115ds) obj).m399r((C0152fb) obj2);
        }
        return null;
    }

    public static BigDecimal m3545(Object obj, Object obj2) {
        if (abd.m2166() < 0) {
            return m3544((C0115ds) obj, (C0152fb) obj2);
        }
        return null;
    }

    public static void m3546(Object obj, Object obj2, Object obj3) {
        if (C0457zc.m10555() > 0) {
            m3542((C0115ds) obj, (C0155fe) obj2, (BigDecimal) obj3);
        }
    }

    @Override
    public void mo225a(C0155fe c0155fe, BigDecimal bigDecimal) {
        m3541(this, c0155fe, bigDecimal);
    }

    public void a2(C0155fe c0155fe, BigDecimal bigDecimal) {
        C0459zf.m11149(c0155fe, bigDecimal);
    }

    @Override
    public BigDecimal mo227b(C0152fb c0152fb) {
        return m3543(this, c0152fb);
    }

    public BigDecimal m399r(C0152fb c0152fb) {
        if (abe.m2401(c0152fb) == C0452yh.m9757()) {
            C0459zf.m11132(c0152fb);
            return null;
        }
        try {
            return new BigDecimal(C0460zg.m11347(c0152fb));
        } catch (NumberFormatException e) {
            throw new C0018ad(e);
        }
    }
}
