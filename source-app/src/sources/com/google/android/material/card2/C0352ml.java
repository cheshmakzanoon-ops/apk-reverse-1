package com.google.android.material.card2;

import java.net.ProtocolException;
import java.util.ArrayList;
import java.util.List;

public final class C0352ml implements InterfaceC0324ll {

    private final InterfaceC0277js f1110rQ;

    private final C0279ju f1111rR;

    private final C0354mn f1112rS;

    private C0373nf f1113rT;

    final C0319lg f1114rU;

    private static final C0412or f1100rG = abc.m1810(C0452yh.m9802());

    private static final C0412or f1102rI = abc.m1810(adds.m2761());

    private static final C0412or f1105rL = abc.m1810(C0449ye.m9118());

    private static final C0412or f1106rM = abc.m1810(adds.m2673());

    private static final C0412or f1108rO = abc.m1810(C0450yf.m9446());

    private static final C0412or f1107rN = abc.m1810(abe.m2286());

    private static final C0412or f1101rH = abc.m1810(C0456zb.m10282());

    private static final C0412or f1109rP = abc.m1810(C0447yc.m8665());

    private static final List<C0412or> f1103rJ = abe.m2380(new C0412or[]{abe.m2298(), abd.m2000(), adds.m2701(), abd.m2106(), C0457zc.m10640(), C0452yh.m9782(), C0455za.m10180(), C0459zf.m11168(), C0461zs.m11635(), C0461zs.m11589(), C0450yf.m9499(), C0448yd.m9066()});

    private static final List<C0412or> f1104rK = abe.m2380(new C0412or[]{abe.m2298(), abd.m2000(), adds.m2701(), abd.m2106(), C0457zc.m10640(), C0452yh.m9782(), C0455za.m10180(), C0459zf.m11168()});

    public C0352ml(C0279ju c0279ju, InterfaceC0277js interfaceC0277js, C0319lg c0319lg, C0354mn c0354mn) {
        this.f1111rR = c0279ju;
        this.f1110rQ = interfaceC0277js;
        this.f1114rU = c0319lg;
        this.f1112rS = c0354mn;
    }

    public static C0291kf m1145d(List<C0347mg> list) throws ProtocolException {
        C0272jn c0272jn;
        C0272jn c0272jn2 = new C0272jn();
        int iM6514 = m6514(list);
        C0333lu c0333luM10573 = null;
        int i = 0;
        while (i < iM6514) {
            C0347mg c0347mg = (C0347mg) gggy.m4400(list, i);
            if (c0347mg != null) {
                C0412or c0412orM10117 = C0455za.m10117(c0347mg);
                String strM10854 = C0458ze.m10854(C0458ze.m10967(c0347mg));
                if (C0459zf.m11211(c0412orM10117, C0459zf.m11143())) {
                    c0333luM10573 = C0457zc.m10573(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), gggy.m4466()), strM10854)));
                    c0272jn = c0272jn2;
                } else if (C0458ze.m10847(abd.m2097(), c0412orM10117)) {
                    c0272jn = c0272jn2;
                } else {
                    C0452yh.m9691(adds.m2768(), c0272jn2, C0458ze.m10854(c0412orM10117), strM10854);
                    c0272jn = c0272jn2;
                }
            } else if (c0333luM10573 == null || C0453yj.m9911(c0333luM10573) != 100) {
                c0272jn = c0272jn2;
            } else {
                c0272jn = new C0272jn();
                c0333luM10573 = null;
            }
            i++;
            c0272jn2 = c0272jn;
        }
        if (c0333luM10573 == null) {
            throw new ProtocolException(C0461zs.m11596());
        }
        return C0455za.m10039(C0457zc.m10741(C0450yf.m9567(C0450yf.m9435(new C0291kf(), gggy.m4498()), C0453yj.m9911(c0333luM10573)), C0447yc.m8616(c0333luM10573)), C0456zb.m10427(c0272jn2));
    }

    public static List<C0347mg> m1146h(C0286ka c0286ka) {
        C0271jm c0271jmM11265 = C0460zg.m11265(c0286ka);
        ArrayList arrayList = new ArrayList(C0460zg.m11431(c0271jmM11265) + 4);
        C0460zg.m11251(arrayList, new C0347mg(C0461zs.m11635(), C0456zb.m10517(c0286ka)));
        C0460zg.m11251(arrayList, new C0347mg(C0461zs.m11589(), abf.m2473(C0448yd.m9070(c0286ka))));
        String strM9986 = C0453yj.m9986(c0286ka, abf.m2536());
        if (strM9986 != null) {
            C0460zg.m11251(arrayList, new C0347mg(C0448yd.m9066(), strM9986));
        }
        C0460zg.m11251(arrayList, new C0347mg(C0450yf.m9499(), C0445ya.m8254(C0448yd.m9070(c0286ka))));
        int iM11431 = C0460zg.m11431(c0271jmM11265);
        for (int i = 0; i < iM11431; i++) {
            C0412or c0412orM1810 = abc.m1810(C0449ye.m9261(C0446yb.m8434(c0271jmM11265, i), C0446yb.m8554()));
            if (!C0458ze.m10847(C0460zg.m11399(), c0412orM1810)) {
                C0460zg.m11251(arrayList, new C0347mg(c0412orM1810, gggy.m4283(c0271jmM11265, i)));
            }
        }
        return arrayList;
    }

    public static C0412or m6511() {
        if (C0460zg.m11287() > 0) {
            return f1101rH;
        }
        return null;
    }

    public static C0373nf m6512(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return ((C0352ml) obj).f1113rT;
        }
        return null;
    }

    public static List m6513() {
        if (C0456zb.m10326() < 0) {
            return f1104rK;
        }
        return null;
    }

    public static int m6514(Object obj) {
        if (adds.m2755() >= 0) {
            return C0598.m11824(obj);
        }
        return 0;
    }

    public static String m6515() {
        if (adds.m2755() > 0) {
            return C0598.m11862();
        }
        return null;
    }

    public static C0354mn m6516(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return ((C0352ml) obj).f1112rS;
        }
        return null;
    }

    public static int m6517(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return C0598.m11906(obj);
        }
        return 0;
    }

    public static C0319lg m6518(Object obj) {
        if (C0447yc.m8635() > 0) {
            return ((C0352ml) obj).f1114rU;
        }
        return null;
    }

    public static C0412or m6519() {
        if (abe.m2308() <= 0) {
            return f1107rN;
        }
        return null;
    }

    public static C0412or m6520() {
        if (abc.m1845() < 0) {
            return f1109rP;
        }
        return null;
    }

    public static int m6521() {
        if (abd.m2162() >= 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static C0412or m6522() {
        if (C0461zs.m11510() <= 0) {
            return f1106rM;
        }
        return null;
    }

    public static List m6523() {
        if (C0452yh.m9798() >= 0) {
            return f1103rJ;
        }
        return null;
    }

    public static InterfaceC0277js m6524(Object obj) {
        if (abd.m2162() > 0) {
            return ((C0352ml) obj).f1110rQ;
        }
        return null;
    }

    public static C0412or m6525() {
        if (C0450yf.m9352() <= 0) {
            return f1102rI;
        }
        return null;
    }

    public static C0412or m6526() {
        if (C0453yj.m10013() > 0) {
            return f1100rG;
        }
        return null;
    }

    public static C0412or m6527() {
        if (C0452yh.m9798() > 0) {
            return f1105rL;
        }
        return null;
    }

    public static C0412or m6528() {
        if (C0446yb.m8415() < 0) {
            return f1108rO;
        }
        return null;
    }

    public static InterfaceC0277js m6529(Object obj) {
        if (C0458ze.m10926() <= 0) {
            return m6524((C0352ml) obj);
        }
        return null;
    }

    public static List m6530() {
        if (C0453yj.m9966() >= 0) {
            return m6523();
        }
        return null;
    }

    public static List m6531() {
        if (abe.m2321() <= 0) {
            return m6513();
        }
        return null;
    }

    public static C0412or m6532() {
        if (C0458ze.m10926() < 0) {
            return m6526();
        }
        return null;
    }

    public static C0412or m6533() {
        if (m6521() >= 0) {
            return m6527();
        }
        return null;
    }

    public static C0373nf m6534(Object obj) {
        if (gggy.m4365() >= 0) {
            return m6512((C0352ml) obj);
        }
        return null;
    }

    public static C0412or m6535() {
        if (C0456zb.m10484() < 0) {
            return m6522();
        }
        return null;
    }

    public static C0412or m6536() {
        if (abd.m2166() <= 0) {
            return m6520();
        }
        return null;
    }

    public static C0412or m6537() {
        if (C0453yj.m10032() >= 0) {
            return m6528();
        }
        return null;
    }

    public static C0354mn m6538(Object obj) {
        if (gggy.m4365() > 0) {
            return m6516((C0352ml) obj);
        }
        return null;
    }

    public static C0319lg m6539(Object obj) {
        if (abd.m2166() <= 0) {
            return m6518((C0352ml) obj);
        }
        return null;
    }

    public static C0412or m6540() {
        if (abd.m2166() < 0) {
            return m6519();
        }
        return null;
    }

    public static C0412or m6541() {
        if (C0448yd.m9015() <= 0) {
            return m6511();
        }
        return null;
    }

    public static C0412or m6542() {
        if (C0457zc.m10555() > 0) {
            return m6525();
        }
        return null;
    }

    @Override
    public InterfaceC0428pg mo1046a(C0286ka c0286ka, long j) {
        return C0449ye.m9199(C0457zc.m10591(this));
    }

    @Override
    public void mo1047ed() {
        C0453yj.m10006(C0449ye.m9199(C0457zc.m10591(this)));
    }

    @Override
    public void mo1048ee() {
        abf.m2440(C0445ya.m8202(this));
    }

    @Override
    public AbstractC0292kg mo1049g(C0290ke c0290ke) {
        C0456zb.m10325(C0460zg.m11398(gggy.m4484(this)), gggy.m4297(gggy.m4484(this)));
        return new C0330lr(C0457zc.m10588(c0290ke, m6515()), abf.m2415(c0290ke), gggy.m4472(new C0353mm(this, C0449ye.m9105(C0457zc.m10591(this)))));
    }

    @Override
    public void mo1050g(C0286ka c0286ka) {
        if (C0457zc.m10591(this) != null) {
            return;
        }
        this.f1113rT = abe.m2213(C0445ya.m8202(this), C0459zf.m11123(c0286ka), C0448yd.m9039(c0286ka) != null);
        gggy.m4486(abf.m2418(C0457zc.m10591(this)), m6517(C0453yj.m9978(this)), adds.m2789());
        gggy.m4486(C0456zb.m10447(C0457zc.m10591(this)), C0460zg.m11245(C0453yj.m9978(this)), adds.m2789());
    }

    @Override
    public C0291kf mo1051m(boolean z) {
        C0291kf c0291kfM11300 = C0460zg.m11300(abf.m2595(C0457zc.m10591(this)));
        if (z && C0458ze.m10772(adds.m2768(), c0291kfM11300) == 100) {
            return null;
        }
        return c0291kfM11300;
    }
}
