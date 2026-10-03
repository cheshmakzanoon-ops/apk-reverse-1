package com.google.android.material.card2;

import java.util.BitSet;

class C0118dv extends AbstractC0022ah<BitSet> {
    C0118dv() {
    }

    public static BitSet m3559(Object obj, Object obj2) {
        if (adds.m2755() >= 0) {
            return m3568(obj, obj2);
        }
        return null;
    }

    public static void m3560(Object obj) {
        if (abc.m1845() < 0) {
            C0598.m11835(obj);
        }
    }

    public static BitSet m3561(Object obj, Object obj2) {
        if (C0453yj.m10013() > 0) {
            return ((C0118dv) obj).m402u((C0152fb) obj2);
        }
        return null;
    }

    public static int[] m3562() {
        if (C0452yh.m9798() > 0) {
            return C0138eo.f250dN;
        }
        return null;
    }

    public static void m3563(Object obj, Object obj2, Object obj3) {
        if (abe.m2308() <= 0) {
            m3567(obj, obj2, obj3);
        }
    }

    public static String m3564() {
        if (abd.m2162() >= 0) {
            return C0598.m11825();
        }
        return null;
    }

    public static int[] m3565() {
        if (C0460zg.m11287() > 0) {
            return m3569();
        }
        return null;
    }

    public static void m3566(Object obj, Object obj2, Object obj3) {
        if (abe.m2308() < 0) {
            ((C0118dv) obj).a2((C0155fe) obj2, (BitSet) obj3);
        }
    }

    public static void m3567(Object obj, Object obj2, Object obj3) {
        if (abd.m2166() < 0) {
            m3566((C0118dv) obj, (C0155fe) obj2, (BitSet) obj3);
        }
    }

    public static BitSet m3568(Object obj, Object obj2) {
        if (C0453yj.m9996() <= 0) {
            return m3561((C0118dv) obj, (C0152fb) obj2);
        }
        return null;
    }

    public static int[] m3569() {
        if (C0457zc.m10555() > 0) {
            return m3562();
        }
        return null;
    }

    @Override
    public void mo225a(C0155fe c0155fe, BitSet bitSet) {
        m3563(this, c0155fe, bitSet);
    }

    public void a2(C0155fe c0155fe, BitSet bitSet) {
        abf.m2469(c0155fe);
        int iM2372 = abe.m2372(bitSet);
        for (int i = 0; i < iM2372; i++) {
            C0448yd.m9067(c0155fe, abc.m1757(bitSet, i) ? 1 : 0);
        }
        C0450yf.m9574(c0155fe);
    }

    @Override
    public BitSet mo227b(C0152fb c0152fb) {
        return m3559(this, c0152fb);
    }

    public BitSet m402u(C0152fb c0152fb) {
        boolean zM11079;
        BitSet bitSet = new BitSet();
        C0461zs.m11627(c0152fb);
        EnumC0154fd enumC0154fdM2401 = abe.m2401(c0152fb);
        int i = 0;
        while (enumC0154fdM2401 != gggy.m4343()) {
            switch (m3565()[C0456zb.m10476(enumC0154fdM2401)]) {
                case 1:
                    zM11079 = C0461zs.m11572(c0152fb) != 0;
                    break;
                case 2:
                    zM11079 = C0459zf.m11079(c0152fb);
                    break;
                case 3:
                    String strM11347 = C0460zg.m11347(c0152fb);
                    try {
                        zM11079 = C0448yd.m8889(strM11347) != 0;
                    } catch (NumberFormatException e) {
                        throw new C0018ad(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0457zc.m10753()), strM11347)));
                    }
                    break;
                default:
                    throw new C0018ad(abc.m1925(abd.m2090(C0460zg.m11407(new StringBuilder(), m3564()), enumC0154fdM2401)));
            }
            if (zM11079) {
                abd.m1992(bitSet, i);
            }
            i++;
            enumC0154fdM2401 = abe.m2401(c0152fb);
        }
        m3560(c0152fb);
        return bitSet;
    }
}
