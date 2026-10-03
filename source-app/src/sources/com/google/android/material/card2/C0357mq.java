package com.google.android.material.card2;

import java.io.IOException;

class C0357mq extends AbstractRunnableC0297kl {

    final int f1146sA;

    final int f1147sB;

    final C0380nm f1148sC;

    final boolean f1149sD;

    final C0354mn f1150sz;

    C0357mq(C0354mn c0354mn, String str, Object[] objArr, boolean z, int i, int i2, C0380nm c0380nm) {
        super(str, objArr);
        this.f1150sz = c0354mn;
        this.f1149sD = z;
        this.f1146sA = i;
        this.f1147sB = i2;
        this.f1148sC = c0380nm;
    }

    public static int m6687(Object obj) {
        if (abc.m1845() <= 0) {
            return m6699(obj);
        }
        return 0;
    }

    public static C0380nm m6688(Object obj) {
        if (C0459zf.m11062() >= 0) {
            return m6704(obj);
        }
        return null;
    }

    public static int m6689(Object obj) {
        if (C0459zf.m11062() > 0) {
            return ((C0357mq) obj).f1147sB;
        }
        return 0;
    }

    public static boolean m6690(Object obj) {
        if (abf.m2510() <= 0) {
            return ((C0357mq) obj).f1149sD;
        }
        return false;
    }

    public static void m6691(Object obj, boolean z, int i, int i2, Object obj2) {
        if (abd.m2162() > 0) {
            m6701(obj, z, i, i2, obj2);
        }
    }

    public static int m6692(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return m6703(obj);
        }
        return 0;
    }

    public static C0354mn m6693(Object obj) {
        if (C0452yh.m9798() >= 0) {
            return m6700(obj);
        }
        return null;
    }

    public static C0380nm m6694(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return ((C0357mq) obj).f1148sC;
        }
        return null;
    }

    public static int m6695(Object obj) {
        if (C0457zc.m10735() <= 0) {
            return ((C0357mq) obj).f1146sA;
        }
        return 0;
    }

    public static boolean m6696(Object obj) {
        if (C0453yj.m10013() >= 0) {
            return m6702(obj);
        }
        return false;
    }

    public static C0354mn m6697(Object obj) {
        if (C0459zf.m11062() > 0) {
            return ((C0357mq) obj).f1150sz;
        }
        return null;
    }

    public static void m6698(Object obj, boolean z, int i, int i2, Object obj2) {
        if (C0453yj.m10013() > 0) {
            ((C0354mn) obj).m1157a(z, i, i2, (C0380nm) obj2);
        }
    }

    public static int m6699(Object obj) {
        if (C0457zc.m10718() <= 0) {
            return m6689((C0357mq) obj);
        }
        return 0;
    }

    public static C0354mn m6700(Object obj) {
        if (abf.m2500() >= 0) {
            return m6697((C0357mq) obj);
        }
        return null;
    }

    public static void m6701(Object obj, boolean z, int i, int i2, Object obj2) {
        if (gggy.m4365() >= 0) {
            m6698((C0354mn) obj, z, i, i2, (C0380nm) obj2);
        }
    }

    public static boolean m6702(Object obj) {
        if (abd.m2166() < 0) {
            return m6690((C0357mq) obj);
        }
        return false;
    }

    public static int m6703(Object obj) {
        if (C0448yd.m9074() < 0) {
            return m6695((C0357mq) obj);
        }
        return 0;
    }

    public static C0380nm m6704(Object obj) {
        if (C0460zg.m11293() > 0) {
            return m6694((C0357mq) obj);
        }
        return null;
    }

    @Override
    public void mo844dd() {
        try {
            m6691(m6693(this), m6696(this), m6692(this), m6687(this), m6688(this));
        } catch (IOException e) {
        }
    }
}
