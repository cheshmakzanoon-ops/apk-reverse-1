package com.google.android.material.card2;

import java.util.ArrayList;

public final class C0090cu extends AbstractC0022ah<Object> {

    public static final InterfaceC0024aj f149bR = new C0091cv();

    private final C0285k f150bS;

    C0090cu(C0285k c0285k) {
        this.f150bS = c0285k;
    }

    public static C0285k m3368(Object obj) {
        if (adds.m2755() >= 0) {
            return ((C0090cu) obj).f150bS;
        }
        return null;
    }

    public static void m3369(Object obj) {
        if (C0451yg.m9580() > 0) {
            C0598.m11835(obj);
        }
    }

    public static int[] m3370() {
        if (C0457zc.m10735() < 0) {
            return C0092cw.f151bT;
        }
        return null;
    }

    public static C0285k m3371(Object obj) {
        if (C0460zg.m11293() >= 0) {
            return m3368((C0090cu) obj);
        }
        return null;
    }

    public static int[] m3372() {
        if (C0453yj.m9996() < 0) {
            return m3370();
        }
        return null;
    }

    @Override
    public void mo225a(C0155fe c0155fe, Object obj) {
        if (obj == null) {
            C0457zc.m10630(c0155fe);
            return;
        }
        AbstractC0022ah abstractC0022ahM2506 = abf.m2506(abc.m1789(this), gggy.m4399(obj));
        if (!(abstractC0022ahM2506 instanceof C0090cu)) {
            C0457zc.m10586(abstractC0022ahM2506, c0155fe, obj);
        } else {
            C0447yc.m8775(c0155fe);
            C0458ze.m10945(c0155fe);
        }
    }

    @Override
    public Object mo227b(C0152fb c0152fb) {
        switch (abc.m1967()[C0456zb.m10476(abe.m2401(c0152fb))]) {
            case 1:
                ArrayList arrayList = new ArrayList();
                C0461zs.m11627(c0152fb);
                while (C0455za.m10208(c0152fb)) {
                    C0460zg.m11251(arrayList, adds.m2794(this, c0152fb));
                }
                m3369(c0152fb);
                return arrayList;
            case 2:
                C0057bo c0057bo = new C0057bo();
                C0456zb.m10454(c0152fb);
                while (C0455za.m10208(c0152fb)) {
                    C0445ya.m8264(c0057bo, gggy.m4313(c0152fb), adds.m2794(this, c0152fb));
                }
                C0459zf.m11135(c0152fb);
                return c0057bo;
            case 3:
                return C0460zg.m11347(c0152fb);
            case 4:
                return abe.m2379(C0459zf.m11040(c0152fb));
            case 5:
                return C0450yf.m9568(C0459zf.m11079(c0152fb));
            case 6:
                C0459zf.m11132(c0152fb);
                return null;
            default:
                throw new IllegalStateException();
        }
    }
}
