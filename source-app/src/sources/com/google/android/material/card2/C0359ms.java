package com.google.android.material.card2;

import java.io.IOException;
import java.util.List;
import java.util.Set;

class C0359ms extends AbstractRunnableC0297kl {

    final C0354mn f1154sH;

    final boolean f1155sI;

    final List f1156sJ;

    final int f1157sK;

    C0359ms(C0354mn c0354mn, String str, Object[] objArr, int i, List list, boolean z) {
        super(str, objArr);
        this.f1154sH = c0354mn;
        this.f1157sK = i;
        this.f1156sJ = list;
        this.f1155sI = z;
    }

    public static void m6727(Object obj, int i, Object obj2) {
        if (C0449ye.m9220() < 0) {
            m6744(obj, i, obj2);
        }
    }

    public static Set m6728(Object obj) {
        if (abe.m2308() <= 0) {
            return ((C0354mn) obj).f1122sb;
        }
        return null;
    }

    public static Set m6729(Object obj) {
        if (C0460zg.m11287() > 0) {
            return m6745(obj);
        }
        return null;
    }

    public static C0354mn m6730(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return m6746(obj);
        }
        return null;
    }

    public static int m6731(Object obj) {
        if (abc.m1845() <= 0) {
            return m6748(obj);
        }
        return 0;
    }

    public static int m6732(Object obj) {
        if (gggy.m4269() < 0) {
            return ((C0359ms) obj).f1157sK;
        }
        return 0;
    }

    public static List m6733(Object obj) {
        if (gggy.m4269() < 0) {
            return m6747(obj);
        }
        return null;
    }

    public static C0354mn m6734(Object obj) {
        if (C0461zs.m11510() < 0) {
            return ((C0359ms) obj).f1154sH;
        }
        return null;
    }

    public static boolean m6735(Object obj) {
        if (C0457zc.m10735() < 0) {
            return m6750(obj);
        }
        return false;
    }

    public static InterfaceC0381nn m6736(Object obj) {
        if (C0446yb.m8415() <= 0) {
            return ((C0354mn) obj).f1132sl;
        }
        return null;
    }

    public static void m6737(Object obj, int i, Object obj2) {
        if (C0453yj.m10013() > 0) {
            ((C0377nj) obj).m1241d(i, (EnumC0346mf) obj2);
        }
    }

    public static boolean m6738(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return ((C0359ms) obj).f1155sI;
        }
        return false;
    }

    public static C0377nj m6739(Object obj) {
        if (C0457zc.m10735() < 0) {
            return ((C0354mn) obj).f1139ss;
        }
        return null;
    }

    public static InterfaceC0381nn m6740(Object obj) {
        if (adds.m2755() > 0) {
            return m6743(obj);
        }
        return null;
    }

    public static C0377nj m6741(Object obj) {
        if (C0446yb.m8415() < 0) {
            return m6749(obj);
        }
        return null;
    }

    public static List m6742(Object obj) {
        if (C0450yf.m9352() <= 0) {
            return ((C0359ms) obj).f1156sJ;
        }
        return null;
    }

    public static InterfaceC0381nn m6743(Object obj) {
        if (C0458ze.m10926() <= 0) {
            return m6736((C0354mn) obj);
        }
        return null;
    }

    public static void m6744(Object obj, int i, Object obj2) {
        if (C0453yj.m10032() > 0) {
            m6737((C0377nj) obj, i, (EnumC0346mf) obj2);
        }
    }

    public static Set m6745(Object obj) {
        if (abf.m2500() > 0) {
            return m6728((C0354mn) obj);
        }
        return null;
    }

    public static C0354mn m6746(Object obj) {
        if (C0453yj.m9966() >= 0) {
            return m6734((C0359ms) obj);
        }
        return null;
    }

    public static List m6747(Object obj) {
        if (C0459zf.m11053() >= 0) {
            return m6742((C0359ms) obj);
        }
        return null;
    }

    public static int m6748(Object obj) {
        if (C0460zg.m11293() >= 0) {
            return m6732((C0359ms) obj);
        }
        return 0;
    }

    public static C0377nj m6749(Object obj) {
        if (C0459zf.m11053() >= 0) {
            return m6739((C0354mn) obj);
        }
        return null;
    }

    public static boolean m6750(Object obj) {
        if (abd.m2166() <= 0) {
            return m6738((C0359ms) obj);
        }
        return false;
    }

    @Override
    public void mo844dd() {
        boolean zM4493 = gggy.m4493(m6740(m6730(this)), m6731(this), m6733(this), m6735(this));
        if (zM4493) {
            try {
                m6727(m6741(m6730(this)), m6731(this), C0456zb.m10363());
            } catch (IOException e) {
                return;
            }
        }
        if (zM4493 || m6735(this)) {
            synchronized (m6730(this)) {
                try {
                    C0452yh.m9623(m6729(m6730(this)), abd.m2028(m6731(this)));
                } catch (Throwable th) {
                    throw th;
                }
            }
        }
    }
}
