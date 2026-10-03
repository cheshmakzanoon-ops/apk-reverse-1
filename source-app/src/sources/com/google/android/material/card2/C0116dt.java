package com.google.android.material.card2;

import java.math.BigInteger;

class C0116dt extends AbstractC0022ah<BigInteger> {
    C0116dt() {
    }

    public static BigInteger m3547(Object obj, Object obj2) {
        if (C0456zb.m10326() <= 0) {
            return ((C0116dt) obj).m400s((C0152fb) obj2);
        }
        return null;
    }

    public static BigInteger m3548(Object obj, Object obj2) {
        if (C0447yc.m8635() > 0) {
            return m3551(obj, obj2);
        }
        return null;
    }

    public static void m3549(Object obj, Object obj2, Object obj3) {
        if (C0448yd.m9079() < 0) {
            m3552(obj, obj2, obj3);
        }
    }

    public static void m3550(Object obj, Object obj2, Object obj3) {
        if (C0457zc.m10735() <= 0) {
            ((C0116dt) obj).a2((C0155fe) obj2, (BigInteger) obj3);
        }
    }

    public static BigInteger m3551(Object obj, Object obj2) {
        if (abe.m2321() < 0) {
            return m3547((C0116dt) obj, (C0152fb) obj2);
        }
        return null;
    }

    public static void m3552(Object obj, Object obj2, Object obj3) {
        if (C0459zf.m11053() >= 0) {
            m3550((C0116dt) obj, (C0155fe) obj2, (BigInteger) obj3);
        }
    }

    @Override
    public void mo225a(C0155fe c0155fe, BigInteger bigInteger) {
        m3549(this, c0155fe, bigInteger);
    }

    public void a2(C0155fe c0155fe, BigInteger bigInteger) {
        C0459zf.m11149(c0155fe, bigInteger);
    }

    @Override
    public BigInteger mo227b(C0152fb c0152fb) {
        return m3548(this, c0152fb);
    }

    public BigInteger m400s(C0152fb c0152fb) {
        if (abe.m2401(c0152fb) == C0452yh.m9757()) {
            C0459zf.m11132(c0152fb);
            return null;
        }
        try {
            return new BigInteger(C0460zg.m11347(c0152fb));
        } catch (NumberFormatException e) {
            throw new C0018ad(e);
        }
    }
}
