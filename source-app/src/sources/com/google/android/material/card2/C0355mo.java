package com.google.android.material.card2;

import java.io.IOException;

class C0355mo extends AbstractRunnableC0297kl {

    final C0354mn f1140st;

    final EnumC0346mf f1141su;

    final int f1142sv;

    C0355mo(C0354mn c0354mn, String str, Object[] objArr, int i, EnumC0346mf enumC0346mf) {
        super(str, objArr);
        this.f1140st = c0354mn;
        this.f1142sv = i;
        this.f1141su = enumC0346mf;
    }

    public static void m6660(Object obj, int i, Object obj2) {
        if (C0452yh.m9798() >= 0) {
            m6668(obj, i, obj2);
        }
    }

    public static C0354mn m6661(Object obj) {
        if (C0460zg.m11287() > 0) {
            return ((C0355mo) obj).f1140st;
        }
        return null;
    }

    public static void m6662(Object obj, int i, Object obj2) {
        if (abd.m2162() >= 0) {
            ((C0354mn) obj).m1159b(i, (EnumC0346mf) obj2);
        }
    }

    public static C0354mn m6663(Object obj) {
        if (C0452yh.m9798() > 0) {
            return m6669(obj);
        }
        return null;
    }

    public static int m6664(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return ((C0355mo) obj).f1142sv;
        }
        return 0;
    }

    public static EnumC0346mf m6665(Object obj) {
        if (C0448yd.m9079() < 0) {
            return ((C0355mo) obj).f1141su;
        }
        return null;
    }

    public static EnumC0346mf m6666(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return m6670(obj);
        }
        return null;
    }

    public static int m6667(Object obj) {
        if (C0457zc.m10735() < 0) {
            return m6671(obj);
        }
        return 0;
    }

    public static void m6668(Object obj, int i, Object obj2) {
        if (C0453yj.m9945() < 0) {
            m6662((C0354mn) obj, i, (EnumC0346mf) obj2);
        }
    }

    public static C0354mn m6669(Object obj) {
        if (C0459zf.m11053() >= 0) {
            return m6661((C0355mo) obj);
        }
        return null;
    }

    public static EnumC0346mf m6670(Object obj) {
        if (C0453yj.m9996() < 0) {
            return m6665((C0355mo) obj);
        }
        return null;
    }

    public static int m6671(Object obj) {
        if (C0448yd.m9015() < 0) {
            return m6664((C0355mo) obj);
        }
        return 0;
    }

    @Override
    public void mo844dd() {
        try {
            m6660(m6663(this), m6667(this), m6666(this));
        } catch (IOException e) {
        }
    }
}
