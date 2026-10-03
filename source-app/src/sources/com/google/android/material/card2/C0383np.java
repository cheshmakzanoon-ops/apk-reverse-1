package com.google.android.material.card2;

public final class C0383np {

    private int f1236tY;

    private final int[] f1237tZ = new int[10];

    public static int m7407(Object obj) {
        if (C0450yf.m9352() <= 0) {
            return ((C0383np) obj).f1236tY;
        }
        return 0;
    }

    public static int m7408(Object obj, int i) {
        if (C0457zc.m10735() < 0) {
            return ((C0383np) obj).m1264x(i);
        }
        return 0;
    }

    public static boolean m7409(Object obj, int i) {
        if (C0459zf.m11062() >= 0) {
            return ((C0383np) obj).m1259A(i);
        }
        return false;
    }

    public static int[] m7410(Object obj) {
        if (C0448yd.m9079() <= 0) {
            return ((C0383np) obj).f1237tZ;
        }
        return null;
    }

    public static void m7411(Object obj, int i) {
        if (abd.m2162() > 0) {
            C0598.m11858(obj, i);
        }
    }

    public static C0383np m7412(Object obj, int i, int i2) {
        if (C0451yg.m9580() >= 0) {
            return ((C0383np) obj).m1261d(i, i2);
        }
        return null;
    }

    public static C0383np m7413(Object obj, int i, int i2) {
        if (C0458ze.m10926() < 0) {
            return m7412((C0383np) obj, i, i2);
        }
        return null;
    }

    public static boolean m7414(Object obj, int i) {
        if (C0457zc.m10718() <= 0) {
            return m7409((C0383np) obj, i);
        }
        return false;
    }

    public static int m7415(Object obj, int i) {
        if (C0453yj.m9966() >= 0) {
            return m7408((C0383np) obj, i);
        }
        return 0;
    }

    public static int m7416(Object obj) {
        if (C0453yj.m10032() > 0) {
            return m7407((C0383np) obj);
        }
        return 0;
    }

    public static int[] m7417(Object obj) {
        if (C0448yd.m9015() < 0) {
            return m7410((C0383np) obj);
        }
        return null;
    }

    boolean m1259A(int i) {
        return (C0445ya.m8395(this) & (1 << i)) != 0;
    }

    void m1260c(C0383np c0383np) {
        for (int i = 0; i < 10; i++) {
            if (C0448yd.m8965(c0383np, i)) {
                gggy.m4278(this, i, C0449ye.m9193(c0383np, i));
            }
        }
    }

    void clear() {
        this.f1236tY = 0;
        m7411(C0460zg.m11258(this), 0);
    }

    C0383np m1261d(int i, int i2) {
        if (i >= 0 && i < C0460zg.m11258(this).length) {
            this.f1236tY = C0445ya.m8395(this) | (1 << i);
            C0460zg.m11258(this)[i] = i2;
        }
        return this;
    }

    int m1262fa() {
        if ((C0445ya.m8395(this) & 2) != 0) {
            return C0460zg.m11258(this)[1];
        }
        return -1;
    }

    int m1263fb() {
        if ((C0445ya.m8395(this) & 128) != 0) {
            return C0460zg.m11258(this)[7];
        }
        return 65535;
    }

    int size() {
        return C0447yc.m8749(C0445ya.m8395(this));
    }

    int m1264x(int i) {
        return C0460zg.m11258(this)[i];
    }

    int m1265y(int i) {
        return (C0445ya.m8395(this) & 16) != 0 ? C0460zg.m11258(this)[4] : i;
    }

    int m1266z(int i) {
        return (C0445ya.m8395(this) & 32) != 0 ? C0460zg.m11258(this)[5] : i;
    }
}
