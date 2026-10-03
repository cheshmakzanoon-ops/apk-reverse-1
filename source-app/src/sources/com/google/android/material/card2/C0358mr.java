package com.google.android.material.card2;

import java.io.IOException;
import java.util.List;
import java.util.Set;

class C0358mr extends AbstractRunnableC0297kl {

    final C0354mn f1151sE;

    final List f1152sF;

    final int f1153sG;

    C0358mr(C0354mn c0354mn, String str, Object[] objArr, int i, List list) {
        super(str, objArr);
        this.f1151sE = c0354mn;
        this.f1153sG = i;
        this.f1152sF = list;
    }

    public static Set m6705(Object obj) {
        if (C0448yd.m9079() < 0) {
            return ((C0354mn) obj).f1122sb;
        }
        return null;
    }

    public static int m6706(Object obj) {
        if (abe.m2308() < 0) {
            return ((C0358mr) obj).f1153sG;
        }
        return 0;
    }

    public static C0354mn m6707(Object obj) {
        if (abc.m1845() <= 0) {
            return ((C0358mr) obj).f1151sE;
        }
        return null;
    }

    public static int m6708(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return m6725(obj);
        }
        return 0;
    }

    public static C0354mn m6709(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return m6723(obj);
        }
        return null;
    }

    public static List m6710(Object obj) {
        if (C0458ze.m10932() >= 0) {
            return m6721(obj);
        }
        return null;
    }

    public static void m6711(Object obj, int i, Object obj2) {
        if (abd.m2162() > 0) {
            m6722(obj, i, obj2);
        }
    }

    public static C0377nj m6712(Object obj) {
        if (C0448yd.m9079() < 0) {
            return m6724(obj);
        }
        return null;
    }

    public static void m6713(Object obj, int i, Object obj2) {
        if (C0446yb.m8415() < 0) {
            ((C0377nj) obj).m1241d(i, (EnumC0346mf) obj2);
        }
    }

    public static List m6714(Object obj) {
        if (gggy.m4269() < 0) {
            return ((C0358mr) obj).f1152sF;
        }
        return null;
    }

    public static InterfaceC0381nn m6715(Object obj) {
        if (abd.m2162() > 0) {
            return ((C0354mn) obj).f1132sl;
        }
        return null;
    }

    public static InterfaceC0381nn m6716(Object obj) {
        if (abd.m2162() > 0) {
            return m6726(obj);
        }
        return null;
    }

    public static Set m6717(Object obj) {
        if (C0446yb.m8415() < 0) {
            return m6720(obj);
        }
        return null;
    }

    public static C0377nj m6718(Object obj) {
        if (C0456zb.m10326() < 0) {
            return ((C0354mn) obj).f1139ss;
        }
        return null;
    }

    public static int m6719() {
        if (C0459zf.m11062() >= 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static Set m6720(Object obj) {
        if (C0453yj.m9996() <= 0) {
            return m6705((C0354mn) obj);
        }
        return null;
    }

    public static List m6721(Object obj) {
        if (C0459zf.m11053() >= 0) {
            return m6714((C0358mr) obj);
        }
        return null;
    }

    public static void m6722(Object obj, int i, Object obj2) {
        if (m6719() >= 0) {
            m6713((C0377nj) obj, i, (EnumC0346mf) obj2);
        }
    }

    public static C0354mn m6723(Object obj) {
        if (C0448yd.m9074() < 0) {
            return m6707((C0358mr) obj);
        }
        return null;
    }

    public static C0377nj m6724(Object obj) {
        if (C0448yd.m9074() <= 0) {
            return m6718((C0354mn) obj);
        }
        return null;
    }

    public static int m6725(Object obj) {
        if (C0458ze.m10926() < 0) {
            return m6706((C0358mr) obj);
        }
        return 0;
    }

    public static InterfaceC0381nn m6726(Object obj) {
        if (gggy.m4365() > 0) {
            return m6715((C0354mn) obj);
        }
        return null;
    }

    @Override
    public void mo844dd() {
        if (C0450yf.m9534(m6716(m6709(this)), m6708(this), m6710(this))) {
            try {
                m6711(m6712(m6709(this)), m6708(this), C0456zb.m10363());
                synchronized (m6709(this)) {
                    C0452yh.m9623(m6717(m6709(this)), abd.m2028(m6708(this)));
                }
            } catch (IOException e) {
            }
        }
    }
}
