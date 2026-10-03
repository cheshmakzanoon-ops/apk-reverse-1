package com.google.android.material.card2;

import java.io.IOException;

class C0356mp extends AbstractRunnableC0297kl {

    final C0354mn f1143sw;

    final int f1144sx;

    final long f1145sy;

    C0356mp(C0354mn c0354mn, String str, Object[] objArr, int i, long j) {
        super(str, objArr);
        this.f1143sw = c0354mn;
        this.f1144sx = i;
        this.f1145sy = j;
    }

    public static void m6672(Object obj, int i, long j) {
        if (gggy.m4269() < 0) {
            m6684(obj, i, j);
        }
    }

    public static int m6673(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return ((C0356mp) obj).f1144sx;
        }
        return 0;
    }

    public static C0354mn m6674(Object obj) {
        if (abe.m2308() <= 0) {
            return m6686(obj);
        }
        return null;
    }

    public static void m6675(Object obj, int i, long j) {
        if (C0447yc.m8635() >= 0) {
            ((C0377nj) obj).m1238b(i, j);
        }
    }

    public static C0377nj m6676(Object obj) {
        if (C0450yf.m9352() < 0) {
            return m6685(obj);
        }
        return null;
    }

    public static int m6677(Object obj) {
        if (C0452yh.m9798() > 0) {
            return m6683(obj);
        }
        return 0;
    }

    public static C0354mn m6678(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return ((C0356mp) obj).f1143sw;
        }
        return null;
    }

    public static long m6679(Object obj) {
        if (C0446yb.m8415() <= 0) {
            return ((C0356mp) obj).f1145sy;
        }
        return 0L;
    }

    public static long m6680(Object obj) {
        if (C0452yh.m9798() > 0) {
            return m6682(obj);
        }
        return 0L;
    }

    public static C0377nj m6681(Object obj) {
        if (abd.m2162() >= 0) {
            return ((C0354mn) obj).f1139ss;
        }
        return null;
    }

    public static long m6682(Object obj) {
        if (C0448yd.m9015() <= 0) {
            return m6679((C0356mp) obj);
        }
        return 0L;
    }

    public static int m6683(Object obj) {
        if (C0453yj.m10032() > 0) {
            return m6673((C0356mp) obj);
        }
        return 0;
    }

    public static void m6684(Object obj, int i, long j) {
        if (C0457zc.m10555() >= 0) {
            m6675((C0377nj) obj, i, j);
        }
    }

    public static C0377nj m6685(Object obj) {
        if (C0453yj.m10032() > 0) {
            return m6681((C0354mn) obj);
        }
        return null;
    }

    public static C0354mn m6686(Object obj) {
        if (C0458ze.m10926() <= 0) {
            return m6678((C0356mp) obj);
        }
        return null;
    }

    @Override
    public void mo844dd() {
        try {
            m6672(m6676(m6674(this)), m6677(this), m6680(this));
        } catch (IOException e) {
        }
    }
}
