package com.google.android.material.card2;

import java.util.Iterator;
import java.util.Map;

class C0130eg extends AbstractC0022ah<AbstractC0441v> {
    C0130eg() {
    }

    public static void m3629(Object obj) {
        if (C0450yf.m9352() < 0) {
            C0598.m11835(obj);
        }
    }

    public static AbstractC0441v m3630(Object obj, Object obj2) {
        if (abd.m2162() >= 0) {
            return m3639(obj, obj2);
        }
        return null;
    }

    public static boolean m3631(Object obj) {
        if (C0448yd.m9079() <= 0) {
            return C0598.m11810(obj);
        }
        return false;
    }

    public static AbstractC0441v m3632(Object obj, Object obj2) {
        if (C0450yf.m9352() < 0) {
            return ((C0130eg) obj).m412E((C0152fb) obj2);
        }
        return null;
    }

    public static void m3633(Object obj, Object obj2, Object obj3) {
        if (C0456zb.m10326() < 0) {
            ((C0130eg) obj).a2((C0155fe) obj2, (AbstractC0441v) obj3);
        }
    }

    public static void m3634(Object obj, Object obj2, Object obj3) {
        if (C0457zc.m10735() <= 0) {
            m3638(obj, obj2, obj3);
        }
    }

    public static int[] m3635() {
        if (adds.m2755() > 0) {
            return m3640();
        }
        return null;
    }

    public static int[] m3636() {
        if (C0457zc.m10735() <= 0) {
            return C0138eo.f250dN;
        }
        return null;
    }

    public static Object m3637(Object obj) {
        if (C0460zg.m11287() > 0) {
            return C0598.m11882(obj);
        }
        return null;
    }

    public static void m3638(Object obj, Object obj2, Object obj3) {
        if (C0448yd.m9015() < 0) {
            m3633((C0130eg) obj, (C0155fe) obj2, (AbstractC0441v) obj3);
        }
    }

    public static AbstractC0441v m3639(Object obj, Object obj2) {
        if (C0456zb.m10484() <= 0) {
            return m3632((C0130eg) obj, (C0152fb) obj2);
        }
        return null;
    }

    public static int[] m3640() {
        if (C0453yj.m9996() < 0) {
            return m3636();
        }
        return null;
    }

    public AbstractC0441v m412E(C0152fb c0152fb) {
        switch (m3635()[C0456zb.m10476(abe.m2401(c0152fb))]) {
            case 1:
                return new C0015aa(new C0056bn(C0460zg.m11347(c0152fb)));
            case 2:
                return new C0015aa(C0450yf.m9568(C0459zf.m11079(c0152fb)));
            case 3:
                return new C0015aa(C0460zg.m11347(c0152fb));
            case 4:
                C0459zf.m11132(c0152fb);
                return C0458ze.m10823();
            case 5:
                C0437s c0437s = new C0437s();
                C0461zs.m11627(c0152fb);
                while (C0455za.m10208(c0152fb)) {
                    C0458ze.m10960(c0437s, m3630(this, c0152fb));
                }
                m3629(c0152fb);
                return c0437s;
            case 6:
                C0444y c0444y = new C0444y();
                C0456zb.m10454(c0152fb);
                while (C0455za.m10208(c0152fb)) {
                    abf.m2652(c0444y, gggy.m4313(c0152fb), m3630(this, c0152fb));
                }
                C0459zf.m11135(c0152fb);
                return c0444y;
            default:
                throw new IllegalArgumentException();
        }
    }

    public void a2(C0155fe c0155fe, AbstractC0441v abstractC0441v) {
        if (abstractC0441v == null || abd.m1998(abstractC0441v)) {
            C0457zc.m10630(c0155fe);
            return;
        }
        if (C0447yc.m8733(abstractC0441v)) {
            C0015aa c0015aaM2561 = abf.m2561(abstractC0441v);
            if (adds.m2714(c0015aaM2561)) {
                C0459zf.m11149(c0155fe, C0448yd.m9060(c0015aaM2561));
                return;
            } else if (m3631(c0015aaM2561)) {
                C0445ya.m8296(c0155fe, C0457zc.m10717(c0015aaM2561));
                return;
            } else {
                C0457zc.m10576(c0155fe, abf.m2442(c0015aaM2561));
                return;
            }
        }
        if (C0461zs.m11583(abstractC0441v)) {
            abf.m2469(c0155fe);
            Iterator itM2368 = abe.m2368(C0450yf.m9417(abstractC0441v));
            while (C0455za.m10104(itM2368)) {
                m3634(this, c0155fe, (AbstractC0441v) m3637(itM2368));
            }
            C0450yf.m9574(c0155fe);
            return;
        }
        if (!C0452yh.m9775(abstractC0441v)) {
            throw new IllegalArgumentException(abc.m1925(abd.m2090(C0460zg.m11407(new StringBuilder(), C0460zg.m11262()), gggy.m4399(abstractC0441v))));
        }
        C0447yc.m8775(c0155fe);
        Iterator itM9939 = C0453yj.m9939(gggy.m4495(C0445ya.m8309(abstractC0441v)));
        while (C0455za.m10104(itM9939)) {
            Map.Entry entry = (Map.Entry) m3637(itM9939);
            C0453yj.m9830(c0155fe, (String) abe.m2338(entry));
            m3634(this, c0155fe, (AbstractC0441v) C0455za.m10227(entry));
        }
        C0458ze.m10945(c0155fe);
    }

    @Override
    public void mo225a(C0155fe c0155fe, AbstractC0441v abstractC0441v) {
        m3634(this, c0155fe, abstractC0441v);
    }

    @Override
    public AbstractC0441v mo227b(C0152fb c0152fb) {
        return m3630(this, c0152fb);
    }
}
