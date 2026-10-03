package com.google.android.material.card2;

import java.util.List;
import java.util.Map;

final class C0350mj {

    private int f1086rA;

    private final boolean f1087rB;

    C0347mg[] f1088rq;

    int f1089rr;

    int f1090rs;

    int f1091ru;

    int f1092rv;

    int f1093rw;

    private boolean f1094ry;

    private final C0409oo f1095rz;

    C0350mj(int i, boolean z, C0409oo c0409oo) {
        this.f1086rA = Integer.MAX_VALUE;
        this.f1088rq = new C0347mg[8];
        this.f1093rw = m6455(this).length - 1;
        this.f1090rs = 0;
        this.f1089rr = 0;
        this.f1091ru = i;
        this.f1092rv = i;
        this.f1087rB = z;
        this.f1095rz = c0409oo;
    }

    C0350mj(C0409oo c0409oo) {
        this(4096, true, c0409oo);
    }

    private void m1133a(C0347mg c0347mg) {
        int iM6456 = m6456(c0347mg);
        if (iM6456 > m6478(this)) {
            m6465(this);
            return;
        }
        m6479(this, (m6439(this) + iM6456) - m6478(this));
        if (m6451(this) + 1 > m6455(this).length) {
            C0347mg[] c0347mgArr = new C0347mg[m6455(this).length * 2];
            adds.m2876(m6455(this), 0, c0347mgArr, m6455(this).length, m6455(this).length);
            this.f1093rw = m6455(this).length - 1;
            this.f1088rq = c0347mgArr;
        }
        int iM6454 = m6454(this);
        this.f1093rw = iM6454 - 1;
        m6455(this)[iM6454] = c0347mg;
        this.f1090rs = m6451(this) + 1;
        this.f1089rr = iM6456 + m6439(this);
    }

    private void m1134er() {
        if (m6478(this) < m6439(this)) {
            if (m6478(this) == 0) {
                m6465(this);
            } else {
                m6479(this, m6439(this) - m6478(this));
            }
        }
    }

    private void m1135es() {
        C0450yf.m9455(m6455(this), null);
        this.f1093rw = m6455(this).length - 1;
        this.f1090rs = 0;
        this.f1089rr = 0;
    }

    private int m1136m(int i) {
        int iM6456 = i;
        int i2 = 0;
        if (iM6456 > 0) {
            int length = m6455(this).length;
            while (true) {
                length--;
                if (length < m6454(this) || iM6456 <= 0) {
                    break;
                }
                iM6456 -= m6456(m6455(this)[length]);
                this.f1089rr = m6439(this) - m6456(m6455(this)[length]);
                this.f1090rs = m6451(this) - 1;
                i2++;
            }
            adds.m2876(m6455(this), m6454(this) + 1, m6455(this), m6454(this) + 1 + i2, m6451(this));
            C0452yh.m9800(m6455(this), m6454(this) + 1, m6454(this) + 1 + i2, null);
            this.f1093rw = m6454(this) + i2;
        }
        return i2;
    }

    public static Map m6436() {
        if (C0452yh.m9798() >= 0) {
            return m6501();
        }
        return null;
    }

    public static void m6437(Object obj, Object obj2, Object obj3) {
        if (C0459zf.m11062() > 0) {
            m6482(obj, obj2, obj3);
        }
    }

    public static void m6438(Object obj) {
        if (abd.m2162() >= 0) {
            m6481(obj);
        }
    }

    public static int m6439(Object obj) {
        if (C0445ya.m8222() > 0) {
            return m6492(obj);
        }
        return 0;
    }

    public static C0378nk m6440() {
        if (C0457zc.m10735() <= 0) {
            return C0378nk.m1248eW();
        }
        return null;
    }

    public static void m6441(Object obj, Object obj2) {
        if (C0453yj.m10013() >= 0) {
            m6483(obj, obj2);
        }
    }

    public static void m6442(Object obj, Object obj2) {
        if (adds.m2755() > 0) {
            ((C0350mj) obj).m1138b((C0412or) obj2);
        }
    }

    public static void m6443(Object obj, int i, int i2, int i3) {
        if (C0452yh.m9798() >= 0) {
            m6499(obj, i, i2, i3);
        }
    }

    public static void m6444(Object obj) {
        if (C0460zg.m11287() > 0) {
            ((C0350mj) obj).m1135es();
        }
    }

    public static C0409oo m6445(Object obj) {
        if (C0452yh.m9798() >= 0) {
            return ((C0350mj) obj).f1095rz;
        }
        return null;
    }

    public static void m6446(Object obj, int i, int i2, int i3) {
        if (C0445ya.m8222() > 0) {
            ((C0350mj) obj).m1137a(i, i2, i3);
        }
    }

    public static C0347mg[] m6447() {
        if (C0459zf.m11062() > 0) {
            return C0348mh.f1077rp;
        }
        return null;
    }

    public static int m6448(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return C0598.m11824(obj);
        }
        return 0;
    }

    public static int m6449() {
        if (C0456zb.m10326() <= 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static int m6450(Object obj) {
        if (C0459zf.m11062() >= 0) {
            return ((C0347mg) obj).f1073rl;
        }
        return 0;
    }

    public static int m6451(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return m6487(obj);
        }
        return 0;
    }

    public static int m6452(Object obj) {
        if (abd.m2162() > 0) {
            return ((C0350mj) obj).f1092rv;
        }
        return 0;
    }

    public static int m6453(Object obj) {
        if (abc.m1845() < 0) {
            return ((C0350mj) obj).f1086rA;
        }
        return 0;
    }

    public static int m6454(Object obj) {
        if (abe.m2308() < 0) {
            return m6497(obj);
        }
        return 0;
    }

    public static C0347mg[] m6455(Object obj) {
        if (C0452yh.m9798() > 0) {
            return m6495(obj);
        }
        return null;
    }

    public static int m6456(Object obj) {
        if (gggy.m4269() < 0) {
            return m6500(obj);
        }
        return 0;
    }

    public static C0347mg[] m6457(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return ((C0350mj) obj).f1088rq;
        }
        return null;
    }

    public static int m6458(Object obj, int i) {
        if (C0458ze.m10932() >= 0) {
            return ((C0350mj) obj).m1136m(i);
        }
        return 0;
    }

    public static int m6459(Object obj) {
        if (abd.m2162() >= 0) {
            return ((C0350mj) obj).f1093rw;
        }
        return 0;
    }

    public static int m6460(Object obj) {
        if (adds.m2755() > 0) {
            return m6485(obj);
        }
        return 0;
    }

    public static boolean m6461(Object obj) {
        if (abe.m2308() < 0) {
            return m6484(obj);
        }
        return false;
    }

    public static void m6462(Object obj) {
        if (C0457zc.m10735() < 0) {
            ((C0350mj) obj).m1134er();
        }
    }

    public static void m6463(Object obj, Object obj2) {
        if (C0452yh.m9798() >= 0) {
            m6496(obj, obj2);
        }
    }

    public static C0409oo m6464(Object obj) {
        if (gggy.m4269() < 0) {
            return m6498(obj);
        }
        return null;
    }

    public static void m6465(Object obj) {
        if (C0446yb.m8415() < 0) {
            m6489(obj);
        }
    }

    public static void m6466(Object obj, Object obj2) {
        if (C0449ye.m9220() < 0) {
            ((C0350mj) obj).m1133a((C0347mg) obj2);
        }
    }

    public static boolean m6467(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return ((C0350mj) obj).f1087rB;
        }
        return false;
    }

    public static int m6468(Object obj, Object obj2) {
        if (abd.m2162() > 0) {
            return m6486(obj, obj2);
        }
        return 0;
    }

    public static void m6469(Object obj, Object obj2, Object obj3) {
        if (C0451yg.m9580() > 0) {
            ((C0378nk) obj).m1249a((C0412or) obj2, (InterfaceC0410op) obj3);
        }
    }

    public static boolean m6470(Object obj) {
        if (C0461zs.m11510() < 0) {
            return m6490(obj);
        }
        return false;
    }

    public static boolean m6471(Object obj) {
        if (adds.m2755() >= 0) {
            return ((C0350mj) obj).f1094ry;
        }
        return false;
    }

    public static int m6472(Object obj) {
        if (abf.m2510() < 0) {
            return ((C0350mj) obj).f1090rs;
        }
        return 0;
    }

    public static int m6473(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return ((C0350mj) obj).f1089rr;
        }
        return 0;
    }

    public static int m6474(Object obj, Object obj2) {
        if (C0452yh.m9798() >= 0) {
            return ((C0378nk) obj).m1251c((C0412or) obj2);
        }
        return 0;
    }

    public static int m6475(Object obj) {
        if (C0459zf.m11062() > 0) {
            return C0598.m11854(obj);
        }
        return 0;
    }

    public static C0378nk m6476() {
        if (abf.m2510() < 0) {
            return m6491();
        }
        return null;
    }

    public static C0347mg[] m6477() {
        if (abf.m2510() <= 0) {
            return m6493();
        }
        return null;
    }

    public static int m6478(Object obj) {
        if (C0447yc.m8635() > 0) {
            return m6494(obj);
        }
        return 0;
    }

    public static int m6479(Object obj, int i) {
        if (adds.m2755() > 0) {
            return m6488(obj, i);
        }
        return 0;
    }

    public static Map m6480() {
        if (C0445ya.m8222() > 0) {
            return C0348mh.f1076ro;
        }
        return null;
    }

    public static void m6481(Object obj) {
        if (m6449() > 0) {
            m6462((C0350mj) obj);
        }
    }

    public static void m6482(Object obj, Object obj2, Object obj3) {
        if (m6449() >= 0) {
            m6469((C0378nk) obj, (C0412or) obj2, (InterfaceC0410op) obj3);
        }
    }

    public static void m6483(Object obj, Object obj2) {
        if (C0448yd.m9015() < 0) {
            m6466((C0350mj) obj, (C0347mg) obj2);
        }
    }

    public static boolean m6484(Object obj) {
        if (C0448yd.m9074() <= 0) {
            return m6471((C0350mj) obj);
        }
        return false;
    }

    public static int m6485(Object obj) {
        if (C0456zb.m10484() <= 0) {
            return m6453((C0350mj) obj);
        }
        return 0;
    }

    public static int m6486(Object obj, Object obj2) {
        if (C0453yj.m9996() < 0) {
            return m6474((C0378nk) obj, (C0412or) obj2);
        }
        return 0;
    }

    public static int m6487(Object obj) {
        if (C0453yj.m9996() <= 0) {
            return m6472((C0350mj) obj);
        }
        return 0;
    }

    public static int m6488(Object obj, int i) {
        if (C0448yd.m9074() <= 0) {
            return m6458((C0350mj) obj, i);
        }
        return 0;
    }

    public static void m6489(Object obj) {
        if (C0457zc.m10718() < 0) {
            m6444((C0350mj) obj);
        }
    }

    public static boolean m6490(Object obj) {
        if (C0448yd.m9074() < 0) {
            return m6467((C0350mj) obj);
        }
        return false;
    }

    public static C0378nk m6491() {
        if (C0453yj.m9996() <= 0) {
            return m6440();
        }
        return null;
    }

    public static int m6492(Object obj) {
        if (C0460zg.m11293() > 0) {
            return m6473((C0350mj) obj);
        }
        return 0;
    }

    public static C0347mg[] m6493() {
        if (C0458ze.m10926() < 0) {
            return m6447();
        }
        return null;
    }

    public static int m6494(Object obj) {
        if (C0460zg.m11293() > 0) {
            return m6452((C0350mj) obj);
        }
        return 0;
    }

    public static C0347mg[] m6495(Object obj) {
        if (C0453yj.m9996() <= 0) {
            return m6457((C0350mj) obj);
        }
        return null;
    }

    public static void m6496(Object obj, Object obj2) {
        if (C0453yj.m10032() > 0) {
            m6442((C0350mj) obj, (C0412or) obj2);
        }
    }

    public static int m6497(Object obj) {
        if (abf.m2500() >= 0) {
            return m6459((C0350mj) obj);
        }
        return 0;
    }

    public static C0409oo m6498(Object obj) {
        if (C0453yj.m9966() > 0) {
            return m6445((C0350mj) obj);
        }
        return null;
    }

    public static void m6499(Object obj, int i, int i2, int i3) {
        if (C0447yc.m8786() >= 0) {
            m6446((C0350mj) obj, i, i2, i3);
        }
    }

    public static int m6500(Object obj) {
        if (abd.m2166() < 0) {
            return m6450((C0347mg) obj);
        }
        return 0;
    }

    public static Map m6501() {
        if (C0448yd.m9015() < 0) {
            return m6480();
        }
        return null;
    }

    void m1137a(int i, int i2, int i3) {
        if (i < i2) {
            C0447yc.m8844(m6464(this), i3 | i);
            return;
        }
        C0447yc.m8844(m6464(this), i3 | i2);
        int i4 = i - i2;
        while (i4 >= 128) {
            C0447yc.m8844(m6464(this), (i4 & 127) | 128);
            i4 >>>= 7;
        }
        C0447yc.m8844(m6464(this), i4);
    }

    void m1138b(C0412or c0412or) {
        if (!m6470(this) || m6468(m6476(), c0412or) >= gggy.m4418(c0412or)) {
            m6443(this, gggy.m4418(c0412or), 127, 0);
            C0461zs.m11451(m6464(this), c0412or);
            return;
        }
        C0409oo c0409oo = new C0409oo();
        m6437(m6476(), c0412or, c0409oo);
        C0412or c0412orM2525 = abf.m2525(c0409oo);
        m6443(this, gggy.m4418(c0412orM2525), 127, 128);
        C0461zs.m11451(m6464(this), c0412orM2525);
    }

    void m1139c(List<C0347mg> list) {
        int iM6454;
        int iM6455;
        if (m6461(this)) {
            if (m6460(this) < m6478(this)) {
                m6443(this, m6460(this), 31, 32);
            }
            this.f1094ry = false;
            this.f1086rA = Integer.MAX_VALUE;
            m6443(this, m6478(this), 31, 32);
        }
        int iM6448 = m6448(list);
        for (int i = 0; i < iM6448; i++) {
            C0347mg c0347mg = (C0347mg) gggy.m4400(list, i);
            C0412or c0412orM10755 = C0457zc.m10755(C0455za.m10117(c0347mg));
            C0412or c0412orM10967 = C0458ze.m10967(c0347mg);
            Integer num = (Integer) adds.m2889(m6436(), c0412orM10755);
            if (num != null) {
                int iM6475 = m6475(num) + 1;
                if (iM6475 <= 1 || iM6475 >= 8) {
                    iM6454 = iM6475;
                    iM6455 = -1;
                } else if (C0446yb.m8500(C0458ze.m10967(m6477()[iM6475 - 1]), c0412orM10967)) {
                    iM6454 = iM6475;
                    iM6455 = iM6475;
                } else if (C0446yb.m8500(C0458ze.m10967(m6477()[iM6475]), c0412orM10967)) {
                    iM6455 = iM6475 + 1;
                    iM6454 = iM6475;
                } else {
                    iM6454 = iM6475;
                    iM6455 = -1;
                }
            } else {
                iM6454 = -1;
                iM6455 = -1;
            }
            if (iM6455 == -1) {
                int length = m6455(this).length;
                for (int iM6456 = m6454(this) + 1; iM6456 < length; iM6456++) {
                    if (C0446yb.m8500(C0455za.m10117(m6455(this)[iM6456]), c0412orM10755)) {
                        if (C0446yb.m8500(C0458ze.m10967(m6455(this)[iM6456]), c0412orM10967)) {
                            iM6455 = (iM6456 - m6454(this)) + m6477().length;
                            break;
                        } else if (iM6454 == -1) {
                            iM6454 = (iM6456 - m6454(this)) + m6477().length;
                        }
                    }
                }
            }
            if (iM6455 != -1) {
                m6443(this, iM6455, 127, 128);
            } else if (iM6454 == -1) {
                C0447yc.m8844(m6464(this), 64);
                m6463(this, c0412orM10755);
                m6463(this, c0412orM10967);
                m6441(this, c0347mg);
            } else if (!C0456zb.m10340(c0412orM10755, C0446yb.m8403()) || C0459zf.m11211(C0448yd.m9066(), c0412orM10755)) {
                m6443(this, iM6454, 63, 64);
                m6463(this, c0412orM10967);
                m6441(this, c0347mg);
            } else {
                m6443(this, iM6454, 15, 0);
                m6463(this, c0412orM10967);
            }
        }
    }

    void m1140s(int i) {
        this.f1091ru = i;
        int iM10520 = C0456zb.m10520(i, 16384);
        if (m6478(this) == iM10520) {
            return;
        }
        if (iM10520 < m6478(this)) {
            this.f1086rA = C0456zb.m10520(m6460(this), iM10520);
        }
        this.f1094ry = true;
        this.f1092rv = iM10520;
        m6438(this);
    }
}
