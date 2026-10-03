package com.google.android.material.card2;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

final class C0349mi {

    C0347mg[] f1078rq;

    int f1079rr;

    int f1080rs;

    private final List<C0347mg> f1081rt;

    private final int f1082ru;

    private int f1083rv;

    int f1084rw;

    private final InterfaceC0411oq f1085rx;

    C0349mi(int i, int i2, InterfaceC0429ph interfaceC0429ph) {
        this.f1081rt = new ArrayList();
        this.f1078rq = new C0347mg[8];
        this.f1084rw = m6386(this).length - 1;
        this.f1080rs = 0;
        this.f1079rr = 0;
        this.f1082ru = i;
        this.f1083rv = i2;
        this.f1085rx = gggy.m4472(interfaceC0429ph);
    }

    C0349mi(int i, InterfaceC0429ph interfaceC0429ph) {
        this(i, i, interfaceC0429ph);
    }

    private void m1116a(int i, C0347mg c0347mg) {
        C0460zg.m11251(m6380(this), c0347mg);
        int iM6392 = m6392(c0347mg);
        if (i != -1) {
            iM6392 -= m6392(m6386(this)[m6368(this, i)]);
        }
        if (iM6392 > m6377(this)) {
            m6385(this);
            return;
        }
        int iM6384 = m6384(this, (m6395(this) + iM6392) - m6377(this));
        if (i == -1) {
            if (m6398(this) + 1 > m6386(this).length) {
                C0347mg[] c0347mgArr = new C0347mg[m6386(this).length * 2];
                adds.m2876(m6386(this), 0, c0347mgArr, m6386(this).length, m6386(this).length);
                this.f1084rw = m6386(this).length - 1;
                this.f1078rq = c0347mgArr;
            }
            int iM6354 = m6354(this);
            this.f1084rw = iM6354 - 1;
            m6386(this)[iM6354] = c0347mg;
            this.f1080rs = m6398(this) + 1;
        } else {
            m6386(this)[iM6384 + m6368(this, i) + i] = c0347mg;
        }
        this.f1079rr = iM6392 + m6395(this);
    }

    private void m1117er() {
        if (m6377(this) < m6395(this)) {
            if (m6377(this) == 0) {
                m6385(this);
            } else {
                m6384(this, m6395(this) - m6377(this));
            }
        }
    }

    private void m1118es() {
        C0450yf.m9455(m6386(this), null);
        this.f1084rw = m6386(this).length - 1;
        this.f1080rs = 0;
        this.f1079rr = 0;
    }

    private int m1119et() {
        return C0446yb.m8575(m6355(this)) & 255;
    }

    private void m1120eu() {
        m6358(this, -1, new C0347mg(m6391(m6394(this)), m6394(this)));
    }

    private void m1121ev() {
        C0460zg.m11251(m6380(this), new C0347mg(m6391(m6394(this)), m6394(this)));
    }

    private int m1122l(int i) {
        return m6354(this) + 1 + i;
    }

    private int m1123m(int i) {
        int iM6392 = i;
        int i2 = 0;
        if (iM6392 > 0) {
            int length = m6386(this).length;
            while (true) {
                length--;
                if (length < m6354(this) || iM6392 <= 0) {
                    break;
                }
                iM6392 -= m6392(m6386(this)[length]);
                this.f1079rr = m6395(this) - m6392(m6386(this)[length]);
                this.f1080rs = m6398(this) - 1;
                i2++;
            }
            adds.m2876(m6386(this), m6354(this) + 1, m6386(this), m6354(this) + 1 + i2, m6398(this));
            this.f1084rw = m6354(this) + i2;
        }
        return i2;
    }

    private C0412or m1124n(int i) {
        return m6388(this, i) ? C0455za.m10117(m6404()[i]) : C0455za.m10117(m6386(this)[m6368(this, i - m6404().length)]);
    }

    private boolean m1125o(int i) {
        return i >= 0 && i <= m6404().length + (-1);
    }

    private void m1126p(int i) throws IOException {
        if (m6388(this, i)) {
            C0460zg.m11251(m6380(this), m6404()[i]);
            return;
        }
        int iM6368 = m6368(this, i - m6404().length);
        if (iM6368 < 0 || iM6368 > m6386(this).length - 1) {
            throw new IOException(abc.m1925(adds.m2680(C0460zg.m11407(new StringBuilder(), C0458ze.m10899()), i + 1)));
        }
        C0460zg.m11251(m6380(this), m6386(this)[iM6368]);
    }

    private void m1127q(int i) {
        m6358(this, -1, new C0347mg(m6403(this, i), m6394(this)));
    }

    private void m1128r(int i) {
        C0460zg.m11251(m6380(this), new C0347mg(m6403(this, i), m6394(this)));
    }

    public static byte[] m6350(Object obj, Object obj2) {
        if (C0448yd.m9079() < 0) {
            return m6427(obj, obj2);
        }
        return null;
    }

    public static int m6351(Object obj, int i) {
        if (gggy.m4269() <= 0) {
            return ((C0349mi) obj).m1122l(i);
        }
        return 0;
    }

    public static void m6352(Object obj) {
        if (abd.m2162() > 0) {
            ((C0349mi) obj).m1117er();
        }
    }

    public static C0378nk m6353() {
        if (adds.m2755() >= 0) {
            return m6435();
        }
        return null;
    }

    public static int m6354(Object obj) {
        if (C0446yb.m8415() < 0) {
            return m6408(obj);
        }
        return 0;
    }

    public static InterfaceC0411oq m6355(Object obj) {
        if (abe.m2308() <= 0) {
            return m6423(obj);
        }
        return null;
    }

    public static void m6356(Object obj) {
        if (C0457zc.m10735() <= 0) {
            m6411(obj);
        }
    }

    public static int m6357(Object obj, int i, int i2) {
        if (C0457zc.m10735() < 0) {
            return m6418(obj, i, i2);
        }
        return 0;
    }

    public static void m6358(Object obj, int i, Object obj2) {
        if (C0460zg.m11287() > 0) {
            m6420(obj, i, obj2);
        }
    }

    public static String m6359() {
        if (abc.m1845() < 0) {
            return C0598.m11891();
        }
        return null;
    }

    public static void m6360(Object obj, int i) {
        if (gggy.m4269() < 0) {
            ((C0349mi) obj).m1128r(i);
        }
    }

    public static byte[] m6361(Object obj, Object obj2) {
        if (abc.m1845() < 0) {
            return ((C0378nk) obj).m1250b((byte[]) obj2);
        }
        return null;
    }

    public static int m6362(Object obj) {
        if (C0447yc.m8635() > 0) {
            return ((C0349mi) obj).f1080rs;
        }
        return 0;
    }

    public static int m6363(Object obj) {
        if (C0458ze.m10932() >= 0) {
            return ((C0349mi) obj).f1084rw;
        }
        return 0;
    }

    public static C0378nk m6364() {
        if (abf.m2510() < 0) {
            return C0378nk.m1248eW();
        }
        return null;
    }

    public static InterfaceC0411oq m6365(Object obj) {
        if (abe.m2308() < 0) {
            return ((C0349mi) obj).f1085rx;
        }
        return null;
    }

    public static int m6366(Object obj) {
        if (C0446yb.m8415() < 0) {
            return ((C0349mi) obj).f1082ru;
        }
        return 0;
    }

    public static C0412or m6367(Object obj) {
        if (C0451yg.m9580() > 0) {
            return C0348mh.m1114a((C0412or) obj);
        }
        return null;
    }

    public static int m6368(Object obj, int i) {
        if (C0456zb.m10326() < 0) {
            return m6430(obj, i);
        }
        return 0;
    }

    public static void m6369(Object obj, int i) throws IOException {
        if (C0446yb.m8415() < 0) {
            m6433(obj, i);
        }
    }

    public static C0347mg[] m6370(Object obj) {
        if (gggy.m4269() < 0) {
            return ((C0349mi) obj).f1078rq;
        }
        return null;
    }

    public static int m6371(Object obj) {
        if (C0458ze.m10932() > 0) {
            return ((C0349mi) obj).f1083rv;
        }
        return 0;
    }

    public static void m6372(Object obj, int i, Object obj2) {
        if (C0461zs.m11510() < 0) {
            ((C0349mi) obj).m1116a(i, (C0347mg) obj2);
        }
    }

    public static void m6373(Object obj) {
        if (adds.m2755() > 0) {
            m6421(obj);
        }
    }

    public static int m6374(Object obj) {
        if (C0450yf.m9352() <= 0) {
            return m6417(obj);
        }
        return 0;
    }

    public static int m6375(Object obj, int i) {
        if (C0461zs.m11510() <= 0) {
            return ((C0349mi) obj).m1123m(i);
        }
        return 0;
    }

    public static void m6376(Object obj, int i) {
        if (C0461zs.m11510() < 0) {
            ((C0349mi) obj).m1127q(i);
        }
    }

    public static int m6377(Object obj) {
        if (C0446yb.m8415() <= 0) {
            return m6424(obj);
        }
        return 0;
    }

    public static void m6378(Object obj) {
        if (C0447yc.m8635() > 0) {
            ((C0349mi) obj).m1121ev();
        }
    }

    public static List m6379(Object obj) {
        if (C0456zb.m10326() < 0) {
            return ((C0349mi) obj).f1081rt;
        }
        return null;
    }

    public static List m6380(Object obj) {
        if (C0458ze.m10932() >= 0) {
            return m6415(obj);
        }
        return null;
    }

    public static void m6381(Object obj) {
        if (C0456zb.m10326() <= 0) {
            ((C0349mi) obj).m1120eu();
        }
    }

    public static void m6382(Object obj, int i) {
        if (C0447yc.m8635() > 0) {
            m6409(obj, i);
        }
    }

    public static void m6383(Object obj) {
        if (abd.m2162() > 0) {
            m6410(obj);
        }
    }

    public static int m6384(Object obj, int i) {
        if (C0451yg.m9580() >= 0) {
            return m6422(obj, i);
        }
        return 0;
    }

    public static void m6385(Object obj) {
        if (C0453yj.m10013() > 0) {
            m6413(obj);
        }
    }

    public static C0347mg[] m6386(Object obj) {
        if (abd.m2162() > 0) {
            return m6431(obj);
        }
        return null;
    }

    public static int m6387(Object obj) {
        if (abd.m2162() > 0) {
            return ((C0349mi) obj).m1119et();
        }
        return 0;
    }

    public static boolean m6388(Object obj, int i) {
        if (abe.m2308() < 0) {
            return m6429(obj, i);
        }
        return false;
    }

    public static C0412or m6389(Object obj, int i) {
        if (C0451yg.m9580() >= 0) {
            return ((C0349mi) obj).m1124n(i);
        }
        return null;
    }

    public static int m6390(Object obj, int i, int i2) {
        if (C0453yj.m10013() >= 0) {
            return ((C0349mi) obj).m1129c(i, i2);
        }
        return 0;
    }

    public static C0412or m6391(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return m6426(obj);
        }
        return null;
    }

    public static int m6392(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return m6434(obj);
        }
        return 0;
    }

    public static void m6393(Object obj, int i) {
        if (C0456zb.m10326() <= 0) {
            m6432(obj, i);
        }
    }

    public static C0412or m6394(Object obj) {
        if (C0445ya.m8222() > 0) {
            return m6416(obj);
        }
        return null;
    }

    public static int m6395(Object obj) {
        if (adds.m2755() > 0) {
            return m6419(obj);
        }
        return 0;
    }

    public static C0347mg[] m6396() {
        if (C0461zs.m11510() < 0) {
            return C0348mh.f1077rp;
        }
        return null;
    }

    public static void m6397(Object obj) {
        if (abd.m2162() >= 0) {
            ((C0349mi) obj).m1118es();
        }
    }

    public static int m6398(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return m6425(obj);
        }
        return 0;
    }

    public static int m6399() {
        if (C0459zf.m11062() > 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static int m6400(Object obj) {
        if (C0446yb.m8415() < 0) {
            return m6428(obj);
        }
        return 0;
    }

    public static int m6401(Object obj) {
        if (C0453yj.m10013() > 0) {
            return ((C0347mg) obj).f1073rl;
        }
        return 0;
    }

    public static boolean m6402(Object obj, int i) {
        if (C0450yf.m9352() <= 0) {
            return ((C0349mi) obj).m1125o(i);
        }
        return false;
    }

    public static C0412or m6403(Object obj, int i) {
        if (C0445ya.m8222() > 0) {
            return m6412(obj, i);
        }
        return null;
    }

    public static C0347mg[] m6404() {
        if (C0451yg.m9580() >= 0) {
            return m6414();
        }
        return null;
    }

    public static C0412or m6405(Object obj) {
        if (C0446yb.m8415() < 0) {
            return ((C0349mi) obj).m1131ex();
        }
        return null;
    }

    public static int m6406(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return ((C0349mi) obj).f1079rr;
        }
        return 0;
    }

    public static void m6407(Object obj, int i) throws IOException {
        if (adds.m2755() > 0) {
            ((C0349mi) obj).m1126p(i);
        }
    }

    public static int m6408(Object obj) {
        if (C0445ya.m8330() > 0) {
            return m6363((C0349mi) obj);
        }
        return 0;
    }

    public static void m6409(Object obj, int i) {
        if (C0448yd.m9074() < 0) {
            m6376((C0349mi) obj, i);
        }
    }

    public static void m6410(Object obj) {
        if (C0453yj.m9996() <= 0) {
            m6352((C0349mi) obj);
        }
    }

    public static void m6411(Object obj) {
        if (abe.m2321() < 0) {
            m6381((C0349mi) obj);
        }
    }

    public static C0412or m6412(Object obj, int i) {
        if (C0448yd.m9015() < 0) {
            return m6389((C0349mi) obj, i);
        }
        return null;
    }

    public static void m6413(Object obj) {
        if (C0453yj.m9966() > 0) {
            m6397((C0349mi) obj);
        }
    }

    public static C0347mg[] m6414() {
        if (abd.m2166() < 0) {
            return m6396();
        }
        return null;
    }

    public static List m6415(Object obj) {
        if (C0453yj.m9966() > 0) {
            return m6379((C0349mi) obj);
        }
        return null;
    }

    public static C0412or m6416(Object obj) {
        if (C0453yj.m9966() > 0) {
            return m6405((C0349mi) obj);
        }
        return null;
    }

    public static int m6417(Object obj) {
        if (C0448yd.m9015() <= 0) {
            return m6387((C0349mi) obj);
        }
        return 0;
    }

    public static int m6418(Object obj, int i, int i2) {
        if (C0453yj.m10032() > 0) {
            return m6390((C0349mi) obj, i, i2);
        }
        return 0;
    }

    public static int m6419(Object obj) {
        if (C0456zb.m10484() < 0) {
            return m6406((C0349mi) obj);
        }
        return 0;
    }

    public static void m6420(Object obj, int i, Object obj2) {
        if (abd.m2166() < 0) {
            m6372((C0349mi) obj, i, (C0347mg) obj2);
        }
    }

    public static void m6421(Object obj) {
        if (m6399() >= 0) {
            m6378((C0349mi) obj);
        }
    }

    public static int m6422(Object obj, int i) {
        if (abe.m2321() <= 0) {
            return m6375((C0349mi) obj, i);
        }
        return 0;
    }

    public static InterfaceC0411oq m6423(Object obj) {
        if (abd.m2021() > 0) {
            return m6365((C0349mi) obj);
        }
        return null;
    }

    public static int m6424(Object obj) {
        if (abd.m2166() < 0) {
            return m6371((C0349mi) obj);
        }
        return 0;
    }

    public static int m6425(Object obj) {
        if (C0457zc.m10555() >= 0) {
            return m6362((C0349mi) obj);
        }
        return 0;
    }

    public static C0412or m6426(Object obj) {
        if (abd.m2166() <= 0) {
            return m6367((C0412or) obj);
        }
        return null;
    }

    public static byte[] m6427(Object obj, Object obj2) {
        if (abd.m2166() <= 0) {
            return m6361((C0378nk) obj, (byte[]) obj2);
        }
        return null;
    }

    public static int m6428(Object obj) {
        if (C0445ya.m8330() >= 0) {
            return m6366((C0349mi) obj);
        }
        return 0;
    }

    public static boolean m6429(Object obj, int i) {
        if (C0453yj.m9945() < 0) {
            return m6402((C0349mi) obj, i);
        }
        return false;
    }

    public static int m6430(Object obj, int i) {
        if (C0453yj.m9966() >= 0) {
            return m6351((C0349mi) obj, i);
        }
        return 0;
    }

    public static C0347mg[] m6431(Object obj) {
        if (C0453yj.m9966() > 0) {
            return m6370((C0349mi) obj);
        }
        return null;
    }

    public static void m6432(Object obj, int i) {
        if (C0457zc.m10718() < 0) {
            m6360((C0349mi) obj, i);
        }
    }

    public static void m6433(Object obj, int i) throws IOException {
        if (C0458ze.m10926() < 0) {
            m6407((C0349mi) obj, i);
        }
    }

    public static int m6434(Object obj) {
        if (gggy.m4365() >= 0) {
            return m6401((C0347mg) obj);
        }
        return 0;
    }

    public static C0378nk m6435() {
        if (C0460zg.m11293() > 0) {
            return m6364();
        }
        return null;
    }

    int m1129c(int i, int i2) {
        int i3 = i2;
        int i4 = i & i3;
        if (i4 < i3) {
            return i4;
        }
        int i5 = 0;
        while (true) {
            int iM6374 = m6374(this);
            if ((iM6374 & 128) == 0) {
                return (iM6374 << i5) + i3;
            }
            i3 += (iM6374 & 127) << i5;
            i5 += 7;
        }
    }

    public List<C0347mg> m1130ew() {
        ArrayList arrayList = new ArrayList(m6380(this));
        C0450yf.m9419(m6380(this));
        return arrayList;
    }

    C0412or m1131ex() {
        int iM6374 = m6374(this);
        boolean z = (iM6374 & 128) == 128;
        int iM6357 = m6357(this, iM6374, 127);
        return z ? C0449ye.m9278(m6350(m6353(), abe.m2250(m6355(this), iM6357))) : C0447yc.m8847(m6355(this), iM6357);
    }

    void m1132ey() {
        while (!C0459zf.m11102(m6355(this))) {
            int iM8575 = C0446yb.m8575(m6355(this)) & 255;
            if (iM8575 == 128) {
                throw new IOException(gggy.m4368());
            }
            if ((iM8575 & 128) == 128) {
                m6369(this, m6357(this, iM8575, 127) - 1);
            } else if (iM8575 == 64) {
                m6356(this);
            } else if ((iM8575 & 64) == 64) {
                m6382(this, m6357(this, iM8575, 63) - 1);
            } else if ((iM8575 & 32) == 32) {
                this.f1083rv = m6357(this, iM8575, 31);
                if (m6377(this) < 0 || m6377(this) > m6400(this)) {
                    throw new IOException(abc.m1925(adds.m2680(C0460zg.m11407(new StringBuilder(), m6359()), m6377(this))));
                }
                m6383(this);
            } else if (iM8575 == 16 || iM8575 == 0) {
                m6373(this);
            } else {
                m6393(this, m6357(this, iM8575, 15) - 1);
            }
        }
    }
}
