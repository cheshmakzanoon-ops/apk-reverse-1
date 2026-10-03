package com.google.android.material.card2;

import java.io.IOException;
import java.util.Set;

class C0360mt extends AbstractRunnableC0297kl {

    final C0354mn f1158sL;

    final C0409oo f1159sM;

    final int f1160sN;

    final boolean f1161sO;

    final int f1162sP;

    C0360mt(C0354mn c0354mn, String str, Object[] objArr, int i, C0409oo c0409oo, int i2, boolean z) {
        super(str, objArr);
        this.f1158sL = c0354mn;
        this.f1162sP = i;
        this.f1159sM = c0409oo;
        this.f1160sN = i2;
        this.f1161sO = z;
    }

    public static Set m6751(Object obj) {
        if (C0449ye.m9220() < 0) {
            return m6776(obj);
        }
        return null;
    }

    public static C0377nj m6752(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return m6771(obj);
        }
        return null;
    }

    public static InterfaceC0381nn m6753(Object obj) {
        if (abe.m2308() < 0) {
            return ((C0354mn) obj).f1132sl;
        }
        return null;
    }

    public static C0377nj m6754(Object obj) {
        if (adds.m2755() >= 0) {
            return ((C0354mn) obj).f1139ss;
        }
        return null;
    }

    public static boolean m6755(Object obj) {
        if (abe.m2308() <= 0) {
            return m6772(obj);
        }
        return false;
    }

    public static Set m6756(Object obj) {
        if (C0457zc.m10735() < 0) {
            return ((C0354mn) obj).f1122sb;
        }
        return null;
    }

    public static C0409oo m6757(Object obj) {
        if (abd.m2162() >= 0) {
            return ((C0360mt) obj).f1159sM;
        }
        return null;
    }

    public static InterfaceC0381nn m6758(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return m6770(obj);
        }
        return null;
    }

    public static void m6759(Object obj, int i, Object obj2) {
        if (C0457zc.m10735() <= 0) {
            ((C0377nj) obj).m1241d(i, (EnumC0346mf) obj2);
        }
    }

    public static int m6760(Object obj) {
        if (abd.m2162() > 0) {
            return ((C0360mt) obj).f1162sP;
        }
        return 0;
    }

    public static void m6761(Object obj, int i, Object obj2) {
        if (C0450yf.m9352() <= 0) {
            m6778(obj, i, obj2);
        }
    }

    public static C0409oo m6762(Object obj) {
        if (C0460zg.m11287() > 0) {
            return m6774(obj);
        }
        return null;
    }

    public static boolean m6763(Object obj) {
        if (C0459zf.m11062() > 0) {
            return ((C0360mt) obj).f1161sO;
        }
        return false;
    }

    public static int m6764(Object obj) {
        if (C0452yh.m9798() >= 0) {
            return m6777(obj);
        }
        return 0;
    }

    public static C0354mn m6765(Object obj) {
        if (C0452yh.m9798() > 0) {
            return m6775(obj);
        }
        return null;
    }

    public static int m6766() {
        if (gggy.m4269() <= 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static int m6767(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return ((C0360mt) obj).f1160sN;
        }
        return 0;
    }

    public static C0354mn m6768(Object obj) {
        if (C0461zs.m11510() < 0) {
            return ((C0360mt) obj).f1158sL;
        }
        return null;
    }

    public static int m6769(Object obj) {
        if (C0448yd.m9079() < 0) {
            return m6773(obj);
        }
        return 0;
    }

    public static InterfaceC0381nn m6770(Object obj) {
        if (gggy.m4365() >= 0) {
            return m6753((C0354mn) obj);
        }
        return null;
    }

    public static C0377nj m6771(Object obj) {
        if (C0459zf.m11053() >= 0) {
            return m6754((C0354mn) obj);
        }
        return null;
    }

    public static boolean m6772(Object obj) {
        if (C0453yj.m9945() <= 0) {
            return m6763((C0360mt) obj);
        }
        return false;
    }

    public static int m6773(Object obj) {
        if (C0453yj.m9945() < 0) {
            return m6760((C0360mt) obj);
        }
        return 0;
    }

    public static C0409oo m6774(Object obj) {
        if (abe.m2321() < 0) {
            return m6757((C0360mt) obj);
        }
        return null;
    }

    public static C0354mn m6775(Object obj) {
        if (C0453yj.m9996() <= 0) {
            return m6768((C0360mt) obj);
        }
        return null;
    }

    public static Set m6776(Object obj) {
        if (m6766() >= 0) {
            return m6756((C0354mn) obj);
        }
        return null;
    }

    public static int m6777(Object obj) {
        if (C0456zb.m10484() <= 0) {
            return m6767((C0360mt) obj);
        }
        return 0;
    }

    public static void m6778(Object obj, int i, Object obj2) {
        if (C0447yc.m8786() > 0) {
            m6759((C0377nj) obj, i, (EnumC0346mf) obj2);
        }
    }

    @Override
    public void mo844dd() {
        try {
            boolean zM2698 = adds.m2698(m6758(m6765(this)), m6769(this), m6762(this), m6764(this), m6755(this));
            if (zM2698) {
                m6761(m6752(m6765(this)), m6769(this), C0456zb.m10363());
            }
            if (zM2698 || m6755(this)) {
                synchronized (m6765(this)) {
                    C0452yh.m9623(m6751(m6765(this)), abd.m2028(m6769(this)));
                }
            }
        } catch (IOException e) {
        }
    }
}
