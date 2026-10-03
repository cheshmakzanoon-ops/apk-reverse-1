package com.google.android.material.card2;

import java.util.Comparator;
import java.util.List;
import javax.annotation.Nullable;
import javax.net.ssl.SSLSocket;

public final class C0255ix {

    @Nullable
    final String[] f665la;

    final boolean f666lb;

    final boolean f667lc;

    @Nullable
    final String[] f668ld;

    private static final C0250is[] f661kW = {C0456zb.m10281(), abe.m2216(), m5012(), C0448yd.m8867(), C0457zc.m10585(), C0447yc.m8767(), C0446yb.m8437(), m5009(), m5005(), C0460zg.m11317(), C0446yb.m8519(), C0452yh.m9700(), abc.m1767(), abf.m2570(), C0445ya.m8226()};

    public static final C0255ix f664kZ = C0448yd.m8969(adds.m2678(C0455za.m10190(adds.m2857(new C0256iy(true), C0458ze.m10779()), new EnumC0295kj[]{C0452yh.m9705(), C0461zs.m11464(), m5025(), m5006()}), true));

    public static final C0255ix f663kY = C0448yd.m8969(adds.m2678(C0455za.m10190(new C0256iy(C0449ye.m9322()), new EnumC0295kj[]{m5006()}), true));

    public static final C0255ix f662kX = C0448yd.m8969(new C0256iy(false));

    C0255ix(C0256iy c0256iy) {
        this.f667lc = abc.m1746(c0256iy);
        this.f665la = abe.m2300(c0256iy);
        this.f668ld = C0445ya.m8319(c0256iy);
        this.f666lb = C0457zc.m10534(c0256iy);
    }

    private C0255ix m652a(SSLSocket sSLSocket, boolean z) {
        String[] strArrM5015 = abe.m2239(this) != null ? m5015(C0445ya.m8208(), C0448yd.m9026(sSLSocket), abe.m2239(this)) : C0448yd.m9026(sSLSocket);
        String[] strArrM5016 = C0453yj.m9937(this) != null ? m5015(C0457zc.m10693(), m5023(sSLSocket), C0453yj.m9937(this)) : m5023(sSLSocket);
        String[] strArrM9177 = C0449ye.m9177(sSLSocket);
        int iM2821 = adds.m2821(C0445ya.m8208(), strArrM9177, C0446yb.m8571());
        if (z && iM2821 != -1) {
            strArrM5015 = C0453yj.m9902(strArrM5015, strArrM9177[iM2821]);
        }
        return C0448yd.m8969(abf.m2474(abd.m2079(new C0256iy(this), strArrM5015), strArrM5016));
    }

    public static String m5003(Object obj) {
        if (C0445ya.m8222() > 0) {
            return C0598.m11838(obj);
        }
        return null;
    }

    public static List m5004(Object obj) {
        if (gggy.m4269() < 0) {
            return C0250is.m641a((String[]) obj);
        }
        return null;
    }

    public static C0250is m5005() {
        if (C0451yg.m9580() >= 0) {
            return C0598.m11811();
        }
        return null;
    }

    public static EnumC0295kj m5006() {
        if (C0450yf.m9352() < 0) {
            return C0598.m11809();
        }
        return null;
    }

    public static C0256iy m5007(Object obj, Object obj2) {
        if (C0447yc.m8635() > 0) {
            return ((C0256iy) obj).m659a((C0250is[]) obj2);
        }
        return null;
    }

    public static boolean m5008(Object obj) {
        if (abe.m2308() < 0) {
            return ((C0256iy) obj).f670lb;
        }
        return false;
    }

    public static C0250is m5009() {
        if (C0457zc.m10735() < 0) {
            return C0598.m11784();
        }
        return null;
    }

    public static boolean m5010(Object obj) {
        if (C0458ze.m10932() > 0) {
            return ((C0256iy) obj).f671lc;
        }
        return false;
    }

    public static String[] m5011(Object obj) {
        if (abc.m1845() < 0) {
            return ((C0256iy) obj).f672ld;
        }
        return null;
    }

    public static C0250is m5012() {
        if (C0451yg.m9580() > 0) {
            return C0598.m11896();
        }
        return null;
    }

    public static String[] m5013(Object obj) {
        if (C0458ze.m10932() >= 0) {
            return ((C0255ix) obj).f665la;
        }
        return null;
    }

    public static String[] m5014(Object obj) {
        if (abd.m2162() > 0) {
            return ((C0256iy) obj).f669la;
        }
        return null;
    }

    public static String[] m5015(Object obj, Object obj2, Object obj3) {
        if (abf.m2510() < 0) {
            return C0598.m11852(obj, obj2, obj3);
        }
        return null;
    }

    public static C0256iy m5016(Object obj, Object obj2) {
        if (C0453yj.m10013() >= 0) {
            return ((C0256iy) obj).m660a((EnumC0295kj[]) obj2);
        }
        return null;
    }

    public static boolean m5017(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return ((C0255ix) obj).f666lb;
        }
        return false;
    }

    public static List m5018(Object obj) {
        if (C0458ze.m10932() >= 0) {
            return EnumC0295kj.m926a((String[]) obj);
        }
        return null;
    }

    public static C0255ix m5019(Object obj, Object obj2, boolean z) {
        if (C0445ya.m8222() >= 0) {
            return ((C0255ix) obj).m652a((SSLSocket) obj2, z);
        }
        return null;
    }

    public static C0250is[] m5020() {
        if (C0456zb.m10326() < 0) {
            return f661kW;
        }
        return null;
    }

    public static Comparator m5021() {
        if (adds.m2755() >= 0) {
            return C0250is.f538iD;
        }
        return null;
    }

    public static boolean m5022(Object obj) {
        if (abd.m2162() >= 0) {
            return ((C0255ix) obj).f667lc;
        }
        return false;
    }

    public static String[] m5023(Object obj) {
        if (C0460zg.m11287() > 0) {
            return C0598.m11855(obj);
        }
        return null;
    }

    public static String[] m5024(Object obj) {
        if (C0452yh.m9798() > 0) {
            return ((C0255ix) obj).f668ld;
        }
        return null;
    }

    public static EnumC0295kj m5025() {
        if (C0453yj.m10013() >= 0) {
            return C0598.m11788();
        }
        return null;
    }

    public static String[] m5026(Object obj) {
        if (abe.m2321() <= 0) {
            return m5014((C0256iy) obj);
        }
        return null;
    }

    public static String[] m5027(Object obj) {
        if (C0447yc.m8786() >= 0) {
            return m5024((C0255ix) obj);
        }
        return null;
    }

    public static boolean m5028(Object obj) {
        if (C0460zg.m11293() > 0) {
            return m5008((C0256iy) obj);
        }
        return false;
    }

    public static List m5029(Object obj) {
        if (C0448yd.m9074() <= 0) {
            return m5018((String[]) obj);
        }
        return null;
    }

    public static boolean m5030(Object obj) {
        if (C0453yj.m9996() < 0) {
            return m5017((C0255ix) obj);
        }
        return false;
    }

    public static Comparator m5031() {
        if (C0448yd.m9015() < 0) {
            return m5021();
        }
        return null;
    }

    public static C0256iy m5032(Object obj, Object obj2) {
        if (C0456zb.m10484() < 0) {
            return m5016((C0256iy) obj, (EnumC0295kj[]) obj2);
        }
        return null;
    }

    public static boolean m5033(Object obj) {
        if (C0459zf.m11053() > 0) {
            return m5010((C0256iy) obj);
        }
        return false;
    }

    public static String[] m5034(Object obj) {
        if (C0453yj.m10032() >= 0) {
            return m5011((C0256iy) obj);
        }
        return null;
    }

    public static C0255ix m5035(Object obj, Object obj2, boolean z) {
        if (C0453yj.m9945() < 0) {
            return m5019((C0255ix) obj, (SSLSocket) obj2, z);
        }
        return null;
    }

    public static String[] m5036(Object obj) {
        if (C0453yj.m9945() <= 0) {
            return m5013((C0255ix) obj);
        }
        return null;
    }

    public static List m5037(Object obj) {
        if (abd.m2021() >= 0) {
            return m5004((String[]) obj);
        }
        return null;
    }

    public static C0256iy m5038(Object obj, Object obj2) {
        if (abd.m2021() > 0) {
            return m5007((C0256iy) obj, (C0250is[]) obj2);
        }
        return null;
    }

    public static C0250is[] m5039() {
        if (gggy.m4365() > 0) {
            return m5020();
        }
        return null;
    }

    public static boolean m5040(Object obj) {
        if (C0456zb.m10484() <= 0) {
            return m5022((C0255ix) obj);
        }
        return false;
    }

    public boolean m653a(SSLSocket sSLSocket) {
        if (!C0445ya.m8235(this)) {
            return false;
        }
        if (C0453yj.m9937(this) == null || abe.m2231(C0457zc.m10693(), C0453yj.m9937(this), m5023(sSLSocket))) {
            return abe.m2239(this) == null || abe.m2231(C0445ya.m8208(), abe.m2239(this), C0448yd.m9026(sSLSocket));
        }
        return false;
    }

    void m654b(SSLSocket sSLSocket, boolean z) {
        C0255ix c0255ixM1872 = abc.m1872(this, sSLSocket, z);
        if (C0453yj.m9937(c0255ixM1872) != null) {
            abd.m2134(sSLSocket, C0453yj.m9937(c0255ixM1872));
        }
        if (abe.m2239(c0255ixM1872) != null) {
            C0453yj.m9974(sSLSocket, abe.m2239(c0255ixM1872));
        }
    }

    @Nullable
    public List<C0250is> m655bW() {
        if (abe.m2239(this) != null) {
            return gggy.m4459(abe.m2239(this));
        }
        return null;
    }

    public boolean m656bX() {
        return C0445ya.m8235(this);
    }

    public boolean m657bY() {
        return C0456zb.m10308(this);
    }

    @Nullable
    public List<EnumC0295kj> m658bZ() {
        if (C0453yj.m9937(this) != null) {
            return C0452yh.m9598(C0453yj.m9937(this));
        }
        return null;
    }

    public boolean equals(@Nullable Object obj) {
        if (!(obj instanceof C0255ix)) {
            return false;
        }
        if (obj == this) {
            return true;
        }
        C0255ix c0255ix = (C0255ix) obj;
        if (C0445ya.m8235(this) == C0445ya.m8235(c0255ix)) {
            return !C0445ya.m8235(this) || (C0456zb.m10410(abe.m2239(this), abe.m2239(c0255ix)) && C0456zb.m10410(C0453yj.m9937(this), C0453yj.m9937(c0255ix)) && C0456zb.m10308(this) == C0456zb.m10308(c0255ix));
        }
        return false;
    }

    public int hashCode() {
        if (!C0445ya.m8235(this)) {
            return 17;
        }
        int iM9083 = C0448yd.m9083(abe.m2239(this));
        return (C0456zb.m10308(this) ? 0 : 1) + ((((iM9083 + 527) * 31) + C0448yd.m9083(C0453yj.m9937(this))) * 31);
    }

    public String toString() {
        if (!C0445ya.m8235(this)) {
            return C0448yd.m9027();
        }
        return abc.m1925(C0460zg.m11407(abd.m2164(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), gggy.m4388()), abe.m2239(this) != null ? m5003(abc.m1799(this)) : C0455za.m10231()), C0448yd.m9077()), C0453yj.m9937(this) != null ? m5003(C0457zc.m10525(this)) : C0455za.m10231()), C0448yd.m8881()), C0456zb.m10308(this)), C0457zc.m10722()));
    }
}
