package com.google.android.material.card2;

import java.util.Set;

class C0361mu extends AbstractRunnableC0297kl {

    final C0354mn f1163sQ;

    final EnumC0346mf f1164sR;

    final int f1165sS;

    C0361mu(C0354mn c0354mn, String str, Object[] objArr, int i, EnumC0346mf enumC0346mf) {
        super(str, objArr);
        this.f1163sQ = c0354mn;
        this.f1165sS = i;
        this.f1164sR = enumC0346mf;
    }

    public static Set m6779(Object obj) {
        if (C0449ye.m9220() < 0) {
            return ((C0354mn) obj).f1122sb;
        }
        return null;
    }

    public static C0354mn m6780(Object obj) {
        if (C0453yj.m10013() >= 0) {
            return m6789(obj);
        }
        return null;
    }

    public static EnumC0346mf m6781(Object obj) {
        if (abd.m2162() >= 0) {
            return m6791(obj);
        }
        return null;
    }

    public static int m6782(Object obj) {
        if (C0451yg.m9580() > 0) {
            return m6790(obj);
        }
        return 0;
    }

    public static InterfaceC0381nn m6783(Object obj) {
        if (C0459zf.m11062() >= 0) {
            return m6793(obj);
        }
        return null;
    }

    public static InterfaceC0381nn m6784(Object obj) {
        if (C0456zb.m10326() < 0) {
            return ((C0354mn) obj).f1132sl;
        }
        return null;
    }

    public static int m6785(Object obj) {
        if (C0457zc.m10735() <= 0) {
            return ((C0361mu) obj).f1165sS;
        }
        return 0;
    }

    public static Set m6786(Object obj) {
        if (C0457zc.m10735() < 0) {
            return m6792(obj);
        }
        return null;
    }

    public static C0354mn m6787(Object obj) {
        if (C0461zs.m11510() < 0) {
            return ((C0361mu) obj).f1163sQ;
        }
        return null;
    }

    public static EnumC0346mf m6788(Object obj) {
        if (gggy.m4269() <= 0) {
            return ((C0361mu) obj).f1164sR;
        }
        return null;
    }

    public static C0354mn m6789(Object obj) {
        if (C0453yj.m9966() >= 0) {
            return m6787((C0361mu) obj);
        }
        return null;
    }

    public static int m6790(Object obj) {
        if (gggy.m4365() >= 0) {
            return m6785((C0361mu) obj);
        }
        return 0;
    }

    public static EnumC0346mf m6791(Object obj) {
        if (C0458ze.m10926() < 0) {
            return m6788((C0361mu) obj);
        }
        return null;
    }

    public static Set m6792(Object obj) {
        if (abe.m2321() <= 0) {
            return m6779((C0354mn) obj);
        }
        return null;
    }

    public static InterfaceC0381nn m6793(Object obj) {
        if (gggy.m4365() >= 0) {
            return m6784((C0354mn) obj);
        }
        return null;
    }

    @Override
    public void mo844dd() {
        abd.m2013(m6783(m6780(this)), m6782(this), m6781(this));
        synchronized (m6780(this)) {
            C0452yh.m9623(m6786(m6780(this)), abd.m2028(m6782(this)));
        }
    }
}
