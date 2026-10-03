package com.google.android.material.card2;

import java.net.URI;
import java.net.URISyntaxException;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.List;
import javax.annotation.Nullable;

public final class C0273jo {

    private static final char[] f709lO = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};

    @Nullable
    private final String f710lP;

    final String f711lQ;

    private final String f712lR;

    private final List<String> f713lS;

    final int f714lT;

    @Nullable
    private final List<String> f715lU;

    final String f716lV;

    private final String f717lW;

    private final String f718lX;

    C0273jo(C0274jp c0274jp) {
        this.f716lV = C0450yf.m9544(c0274jp);
        this.f718lX = abc.m1918(C0459zf.m11061(c0274jp), false);
        this.f712lR = abc.m1918(C0446yb.m8522(c0274jp), false);
        this.f711lQ = C0460zg.m11221(c0274jp);
        this.f714lT = abc.m1791(c0274jp);
        this.f713lS = C0461zs.m11467(this, C0456zb.m10393(c0274jp), false);
        this.f715lU = C0461zs.m11439(c0274jp) != null ? C0461zs.m11467(this, C0461zs.m11439(c0274jp), true) : null;
        this.f710lP = C0457zc.m10683(c0274jp) != null ? abc.m1918(C0457zc.m10683(c0274jp), false) : null;
        this.f717lW = C0446yb.m8482(c0274jp);
    }

    @Nullable
    public static C0273jo m731A(String str) {
        C0274jp c0274jp = new C0274jp();
        if (m5199(c0274jp, null, str) == m5193()) {
            return C0449ye.m9107(c0274jp);
        }
        return null;
    }

    static List<String> m732B(String str) {
        ArrayList arrayList = new ArrayList();
        int i = 0;
        while (i <= gggy.m4397(str)) {
            int iM10546 = C0457zc.m10546(str, 38, i);
            if (iM10546 == -1) {
                iM10546 = gggy.m4397(str);
            }
            int iM10547 = C0457zc.m10546(str, 61, i);
            if (iM10547 == -1 || iM10547 > iM10546) {
                C0460zg.m11251(arrayList, C0447yc.m8745(str, i, iM10546));
                C0460zg.m11251(arrayList, null);
            } else {
                C0460zg.m11251(arrayList, C0447yc.m8745(str, i, iM10547));
                C0460zg.m11251(arrayList, C0447yc.m8745(str, iM10547 + 1, iM10546));
            }
            i = iM10546 + 1;
        }
        return arrayList;
    }

    static String m733a(String str, int i, int i2, String str2, boolean z, boolean z2, boolean z3, boolean z4, Charset charset) {
        int iM1937 = i;
        while (iM1937 < i2) {
            int iM10816 = C0458ze.m10816(str, iM1937);
            if (iM10816 < 32 || iM10816 == 127 || ((iM10816 >= 128 && z4) || C0458ze.m10892(str2, iM10816) != -1 || ((iM10816 == 37 && (!z || (z2 && !C0460zg.m11348(str, iM1937, i2)))) || (iM10816 == 43 && z3)))) {
                C0409oo c0409oo = new C0409oo();
                abc.m1815(c0409oo, str, i, iM1937);
                C0460zg.m11372(c0409oo, str, iM1937, i2, str2, z, z2, z3, z4, charset);
                return C0456zb.m10496(c0409oo);
            }
            iM1937 += abc.m1937(iM10816);
        }
        return C0447yc.m8745(str, i, i2);
    }

    static String m734a(String str, String str2, boolean z, boolean z2, boolean z3, boolean z4) {
        return C0459zf.m11172(str, 0, gggy.m4397(str), str2, z, z2, z3, z4, null);
    }

    static String m735a(String str, String str2, boolean z, boolean z2, boolean z3, boolean z4, Charset charset) {
        return C0459zf.m11172(str, 0, gggy.m4397(str), str2, z, z2, z3, z4, charset);
    }

    static String m736a(String str, boolean z) {
        return C0448yd.m9080(str, 0, gggy.m4397(str), z);
    }

    private List<String> m737a(List<String> list, boolean z) {
        int iM5182 = m5182(list);
        ArrayList arrayList = new ArrayList(iM5182);
        for (int i = 0; i < iM5182; i++) {
            String str = (String) gggy.m4400(list, i);
            C0460zg.m11251(arrayList, str != null ? abc.m1918(str, z) : null);
        }
        return abc.m1875(arrayList);
    }

    static void m738a(C0409oo c0409oo, String str, int i, int i2, String str2, boolean z, boolean z2, boolean z3, boolean z4, Charset charset) {
        int iM1937 = i;
        C0409oo c0409oo2 = null;
        while (iM1937 < i2) {
            int iM10816 = C0458ze.m10816(str, iM1937);
            if (!z || (iM10816 != 9 && iM10816 != 10 && iM10816 != 12 && iM10816 != 13)) {
                if (iM10816 == 43 && z3) {
                    C0457zc.m10684(c0409oo, z ? C0460zg.m11344() : C0453yj.m9942());
                } else if (iM10816 < 32 || iM10816 == 127 || ((iM10816 >= 128 && z4) || C0458ze.m10892(str2, iM10816) != -1 || (iM10816 == 37 && (!z || (z2 && !C0460zg.m11348(str, iM1937, i2)))))) {
                    if (c0409oo2 == null) {
                        c0409oo2 = new C0409oo();
                    }
                    if (charset == null || C0450yf.m9449(charset, abc.m1850())) {
                        C0453yj.m10024(c0409oo2, iM10816);
                    } else {
                        C0445ya.m8287(c0409oo2, str, iM1937, abc.m1937(iM10816) + iM1937, charset);
                    }
                    while (!C0450yf.m9578(c0409oo2)) {
                        int iM11394 = C0460zg.m11394(c0409oo2) & 255;
                        C0447yc.m8844(c0409oo, 37);
                        C0447yc.m8844(c0409oo, C0445ya.m8219()[(iM11394 >> 4) & 15]);
                        C0447yc.m8844(c0409oo, C0445ya.m8219()[iM11394 & 15]);
                    }
                } else {
                    C0453yj.m10024(c0409oo, iM10816);
                }
            }
            iM1937 += abc.m1937(iM10816);
        }
    }

    static void m739a(C0409oo c0409oo, String str, int i, int i2, boolean z) {
        int iM1937 = i;
        while (iM1937 < i2) {
            int iM10816 = C0458ze.m10816(str, iM1937);
            if (iM10816 == 37 && iM1937 + 2 < i2) {
                int iM9663 = C0452yh.m9663(C0446yb.m8419(str, iM1937 + 1));
                int iM9664 = C0452yh.m9663(C0446yb.m8419(str, iM1937 + 2));
                if (iM9663 == -1 || iM9664 == -1) {
                    C0453yj.m10024(c0409oo, iM10816);
                } else {
                    C0447yc.m8844(c0409oo, (iM9663 << 4) + iM9664);
                    iM1937 += 2;
                }
            } else if (iM10816 == 43 && z) {
                C0447yc.m8844(c0409oo, 32);
            } else {
                C0453yj.m10024(c0409oo, iM10816);
            }
            iM1937 += abc.m1937(iM10816);
        }
    }

    static void m740a(StringBuilder sb, List<String> list) {
        int iM5182 = m5182(list);
        for (int i = 0; i < iM5182; i += 2) {
            String str = (String) gggy.m4400(list, i);
            String str2 = (String) gggy.m4400(list, i + 1);
            if (i > 0) {
                abe.m2346(sb, '&');
            }
            C0460zg.m11407(sb, str);
            if (str2 != null) {
                abe.m2346(sb, '=');
                C0460zg.m11407(sb, str2);
            }
        }
    }

    static String m741b(String str, int i, int i2, boolean z) {
        for (int i3 = i; i3 < i2; i3++) {
            char cM8419 = C0446yb.m8419(str, i3);
            if (cM8419 == '%' || (cM8419 == '+' && z)) {
                C0409oo c0409oo = new C0409oo();
                abc.m1815(c0409oo, str, i, i3);
                C0456zb.m10451(c0409oo, str, i3, i2, z);
                return C0456zb.m10496(c0409oo);
            }
        }
        return C0447yc.m8745(str, i, i2);
    }

    static void m742b(StringBuilder sb, List<String> list) {
        int iM5182 = m5182(list);
        for (int i = 0; i < iM5182; i++) {
            abe.m2346(sb, '/');
            C0460zg.m11407(sb, (String) gggy.m4400(list, i));
        }
    }

    static boolean m743c(String str, int i, int i2) {
        return i + 2 < i2 && C0446yb.m8419(str, i) == '%' && C0452yh.m9663(C0446yb.m8419(str, i + 1)) != -1 && C0452yh.m9663(C0446yb.m8419(str, i + 2)) != -1;
    }

    public static int m744z(String str) {
        if (C0452yh.m9583(str, abd.m2063())) {
            return 80;
        }
        return C0452yh.m9583(str, C0459zf.m11016()) ? 443 : -1;
    }

    public static String m5173(Object obj) {
        if (gggy.m4269() < 0) {
            return ((C0273jo) obj).f710lP;
        }
        return null;
    }

    public static String m5174(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return ((C0273jo) obj).f716lV;
        }
        return null;
    }

    public static String m5175(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return ((C0274jp) obj).f719lQ;
        }
        return null;
    }

    public static List m5176(Object obj, Object obj2, boolean z) {
        if (C0457zc.m10735() <= 0) {
            return ((C0273jo) obj).m737a((List<String>) obj2, z);
        }
        return null;
    }

    public static String m5177(Object obj) {
        if (C0450yf.m9352() <= 0) {
            return ((C0273jo) obj).f718lX;
        }
        return null;
    }

    public static void m5178(Object obj, Object obj2, int i, int i2, boolean z) {
        if (abf.m2510() <= 0) {
            m739a((C0409oo) obj, (String) obj2, i, i2, z);
        }
    }

    public static String m5179(Object obj) {
        if (adds.m2755() > 0) {
            return ((C0273jo) obj).f712lR;
        }
        return null;
    }

    public static String m5180(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return ((C0274jp) obj).f722lY;
        }
        return null;
    }

    public static char[] m5181() {
        if (C0456zb.m10326() < 0) {
            return f709lO;
        }
        return null;
    }

    public static int m5182(Object obj) {
        if (C0457zc.m10735() <= 0) {
            return C0598.m11824(obj);
        }
        return 0;
    }

    public static List m5183(Object obj) {
        if (C0452yh.m9798() >= 0) {
            return ((C0274jp) obj).f725mb;
        }
        return null;
    }

    public static EnumC0275jq m5184(Object obj, Object obj2, Object obj3) {
        if (abf.m2510() <= 0) {
            return ((C0274jp) obj).m776b((C0273jo) obj2, (String) obj3);
        }
        return null;
    }

    public static void m5185(Object obj, Object obj2, int i, int i2, Object obj3, boolean z, boolean z2, boolean z3, boolean z4, Object obj4) {
        if (C0461zs.m11510() <= 0) {
            m738a((C0409oo) obj, (String) obj2, i, i2, (String) obj3, z, z2, z3, z4, (Charset) obj4);
        }
    }

    public static String m5186(Object obj) {
        if (C0447yc.m8635() > 0) {
            return ((C0273jo) obj).f717lW;
        }
        return null;
    }

    public static boolean m5187(Object obj, int i, int i2) {
        if (abd.m2162() > 0) {
            return m743c((String) obj, i, i2);
        }
        return false;
    }

    public static String m5188(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return ((C0274jp) obj).f726mc;
        }
        return null;
    }

    public static String m5189(Object obj, int i, int i2, boolean z) {
        if (gggy.m4269() <= 0) {
            return m741b((String) obj, i, i2, z);
        }
        return null;
    }

    public static String m5190(Object obj, int i, int i2, Object obj2, boolean z, boolean z2, boolean z3, boolean z4, Object obj3) {
        if (C0445ya.m8222() > 0) {
            return m733a((String) obj, i, i2, (String) obj2, z, z2, z3, z4, (Charset) obj3);
        }
        return null;
    }

    public static String m5191(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return ((C0274jp) obj).f723lZ;
        }
        return null;
    }

    public static String m5192(Object obj, boolean z) {
        if (C0445ya.m8222() >= 0) {
            return m736a((String) obj, z);
        }
        return null;
    }

    public static EnumC0275jq m5193() {
        if (abf.m2510() < 0) {
            return m5224();
        }
        return null;
    }

    public static String m5194(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return ((C0274jp) obj).f721lV;
        }
        return null;
    }

    public static int m5195(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return ((C0274jp) obj).m778cD();
        }
        return 0;
    }

    public static List m5196(Object obj) {
        if (C0459zf.m11062() >= 0) {
            return ((C0273jo) obj).f715lU;
        }
        return null;
    }

    public static void m5197(Object obj, Object obj2) {
        if (C0456zb.m10326() <= 0) {
            m740a((StringBuilder) obj, (List<String>) obj2);
        }
    }

    public static String m5198(Object obj) {
        if (gggy.m4269() < 0) {
            return ((C0273jo) obj).f711lQ;
        }
        return null;
    }

    public static EnumC0275jq m5199(Object obj, Object obj2, Object obj3) {
        if (abe.m2308() <= 0) {
            return m5209(obj, obj2, obj3);
        }
        return null;
    }

    public static int m5200(Object obj) {
        if (abf.m2510() < 0) {
            return ((C0273jo) obj).f714lT;
        }
        return 0;
    }

    public static C0274jp m5201(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return ((C0274jp) obj).m779cE();
        }
        return null;
    }

    public static EnumC0275jq m5202() {
        if (abc.m1845() <= 0) {
            return EnumC0275jq.f731mh;
        }
        return null;
    }

    public static List m5203(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return ((C0274jp) obj).f724ma;
        }
        return null;
    }

    public static int m5204(Object obj) {
        if (C0460zg.m11293() >= 0) {
            return m5195((C0274jp) obj);
        }
        return 0;
    }

    public static String m5205(Object obj) {
        if (C0448yd.m9074() < 0) {
            return m5180((C0274jp) obj);
        }
        return null;
    }

    public static C0274jp m5206(Object obj) {
        if (abd.m2166() < 0) {
            return m5201((C0274jp) obj);
        }
        return null;
    }

    public static String m5207(Object obj) {
        if (C0453yj.m9996() <= 0) {
            return m5194((C0274jp) obj);
        }
        return null;
    }

    public static List m5208(Object obj) {
        if (C0457zc.m10718() <= 0) {
            return m5196((C0273jo) obj);
        }
        return null;
    }

    public static EnumC0275jq m5209(Object obj, Object obj2, Object obj3) {
        if (C0457zc.m10555() >= 0) {
            return m5184((C0274jp) obj, (C0273jo) obj2, (String) obj3);
        }
        return null;
    }

    public static String m5210(Object obj) {
        if (C0453yj.m10032() >= 0) {
            return m5177((C0273jo) obj);
        }
        return null;
    }

    public static String m5211(Object obj) {
        if (C0459zf.m11053() > 0) {
            return m5179((C0273jo) obj);
        }
        return null;
    }

    public static String m5212(Object obj) {
        if (C0460zg.m11293() > 0) {
            return m5191((C0274jp) obj);
        }
        return null;
    }

    public static String m5213(Object obj, int i, int i2, boolean z) {
        if (C0445ya.m8330() >= 0) {
            return m5189((String) obj, i, i2, z);
        }
        return null;
    }

    public static void m5214(Object obj, Object obj2) {
        if (C0457zc.m10718() < 0) {
            m5197((StringBuilder) obj, (List) obj2);
        }
    }

    public static char[] m5215() {
        if (C0453yj.m9966() >= 0) {
            return m5181();
        }
        return null;
    }

    public static String m5216(Object obj, boolean z) {
        if (C0447yc.m8786() > 0) {
            return m5192((String) obj, z);
        }
        return null;
    }

    public static String m5217(Object obj, int i, int i2, Object obj2, boolean z, boolean z2, boolean z3, boolean z4, Object obj3) {
        if (C0453yj.m9945() <= 0) {
            return m5190((String) obj, i, i2, (String) obj2, z, z2, z3, z4, (Charset) obj3);
        }
        return null;
    }

    public static String m5218(Object obj) {
        if (C0459zf.m11053() >= 0) {
            return m5173((C0273jo) obj);
        }
        return null;
    }

    public static String m5219(Object obj) {
        if (C0447yc.m8786() > 0) {
            return m5188((C0274jp) obj);
        }
        return null;
    }

    public static void m5220(Object obj, Object obj2, int i, int i2, boolean z) {
        if (C0448yd.m9074() <= 0) {
            m5178((C0409oo) obj, (String) obj2, i, i2, z);
        }
    }

    public static List m5221(Object obj, Object obj2, boolean z) {
        if (abd.m2021() >= 0) {
            return m5176((C0273jo) obj, (List) obj2, z);
        }
        return null;
    }

    public static String m5222(Object obj) {
        if (C0457zc.m10555() >= 0) {
            return m5198((C0273jo) obj);
        }
        return null;
    }

    public static String m5223(Object obj) {
        if (C0453yj.m9996() < 0) {
            return m5174((C0273jo) obj);
        }
        return null;
    }

    public static EnumC0275jq m5224() {
        if (C0457zc.m10555() >= 0) {
            return m5202();
        }
        return null;
    }

    public static String m5225(Object obj) {
        if (C0448yd.m9074() < 0) {
            return m5175((C0274jp) obj);
        }
        return null;
    }

    public static List m5226(Object obj) {
        if (C0457zc.m10555() >= 0) {
            return m5183((C0274jp) obj);
        }
        return null;
    }

    public static String m5227(Object obj) {
        if (C0458ze.m10926() < 0) {
            return m5186((C0273jo) obj);
        }
        return null;
    }

    public static int m5228(Object obj) {
        if (C0445ya.m8330() > 0) {
            return m5200((C0273jo) obj);
        }
        return 0;
    }

    public static boolean m5229(Object obj, int i, int i2) {
        if (abd.m2166() < 0) {
            return m5187((String) obj, i, i2);
        }
        return false;
    }

    public static void m5230(Object obj, Object obj2, int i, int i2, Object obj3, boolean z, boolean z2, boolean z3, boolean z4, Object obj4) {
        if (C0457zc.m10555() >= 0) {
            m5185((C0409oo) obj, (String) obj2, i, i2, (String) obj3, z, z2, z3, z4, (Charset) obj4);
        }
    }

    public static List m5231(Object obj) {
        if (C0457zc.m10555() >= 0) {
            return m5203((C0274jp) obj);
        }
        return null;
    }

    @Nullable
    public C0274jp m745C(String str) {
        C0274jp c0274jp = new C0274jp();
        if (m5199(c0274jp, this, str) == m5193()) {
            return c0274jp;
        }
        return null;
    }

    @Nullable
    public C0273jo m746D(String str) {
        C0274jp c0274jpM10702 = C0457zc.m10702(this, str);
        if (c0274jpM10702 != null) {
            return C0449ye.m9107(c0274jpM10702);
        }
        return null;
    }

    public URI m747cA() {
        String strM8482 = C0446yb.m8482(C0446yb.m8480(C0456zb.m10504(this)));
        try {
            return new URI(strM8482);
        } catch (URISyntaxException e) {
            try {
                return abd.m2102(C0457zc.m10535(strM8482, abe.m2238(), gggy.m4277()));
            } catch (Exception e2) {
                throw new RuntimeException(e);
            }
        }
    }

    @Nullable
    public String m748cn() {
        if (abc.m1889(this) == null) {
            return null;
        }
        return abc.m1972(C0449ye.m9190(this), C0458ze.m10892(C0449ye.m9190(this), 35) + 1);
    }

    public String m749co() {
        if (C0460zg.m11421(adds.m2676(this))) {
            return gggy.m4277();
        }
        int iM10546 = C0457zc.m10546(C0449ye.m9190(this), 58, gggy.m4397(gggy.m4351(this)) + 3);
        return C0447yc.m8745(C0449ye.m9190(this), iM10546 + 1, C0458ze.m10892(C0449ye.m9190(this), 64));
    }

    public String m750cp() {
        int iM10546 = C0457zc.m10546(C0449ye.m9190(this), 47, gggy.m4397(gggy.m4351(this)) + 3);
        return C0447yc.m8745(C0449ye.m9190(this), iM10546, abd.m2142(C0449ye.m9190(this), iM10546, gggy.m4397(C0449ye.m9190(this)), gggy.m4408()));
    }

    public List<String> m751cq() {
        int iM10546 = C0457zc.m10546(C0449ye.m9190(this), 47, gggy.m4397(gggy.m4351(this)) + 3);
        int iM2142 = abd.m2142(C0449ye.m9190(this), iM10546, gggy.m4397(C0449ye.m9190(this)), gggy.m4408());
        ArrayList arrayList = new ArrayList();
        while (iM10546 < iM2142) {
            int i = iM10546 + 1;
            iM10546 = C0455za.m10248(C0449ye.m9190(this), i, iM2142, '/');
            C0460zg.m11251(arrayList, C0447yc.m8745(C0449ye.m9190(this), i, iM10546));
        }
        return arrayList;
    }

    @Nullable
    public String m752cr() {
        if (adds.m2836(this) == null) {
            return null;
        }
        int iM10892 = C0458ze.m10892(C0449ye.m9190(this), 63) + 1;
        return C0447yc.m8745(C0449ye.m9190(this), iM10892, C0455za.m10248(C0449ye.m9190(this), iM10892, gggy.m4397(C0449ye.m9190(this)), '#'));
    }

    public String m753cs() {
        if (C0460zg.m11421(adds.m2746(this))) {
            return gggy.m4277();
        }
        int iM4397 = gggy.m4397(gggy.m4351(this)) + 3;
        return C0447yc.m8745(C0449ye.m9190(this), iM4397, abd.m2142(C0449ye.m9190(this), iM4397, gggy.m4397(C0449ye.m9190(this)), C0461zs.m11602()));
    }

    public String m754ct() {
        return C0456zb.m10453(this);
    }

    public boolean m755cu() {
        return C0452yh.m9583(gggy.m4351(this), C0459zf.m11016());
    }

    public C0274jp m756cv() {
        C0274jp c0274jp = new C0274jp();
        c0274jp.f721lV = gggy.m4351(this);
        c0274jp.f726mc = C0447yc.m8655(this);
        c0274jp.f723lZ = C0450yf.m9429(this);
        c0274jp.f719lQ = C0456zb.m10453(this);
        c0274jp.f720lT = C0461zs.m11580(this) != C0447yc.m8714(gggy.m4351(this)) ? C0461zs.m11580(this) : -1;
        C0450yf.m9419(C0456zb.m10393(c0274jp));
        C0447yc.m8634(C0456zb.m10393(c0274jp), C0446yb.m8484(this));
        abf.m2468(c0274jp, C0461zs.m11622(this));
        c0274jp.f722lY = C0461zs.m11534(this);
        return c0274jp;
    }

    public int m757cw() {
        return C0461zs.m11580(this);
    }

    @Nullable
    public String m758cx() {
        if (adds.m2836(this) == null) {
            return null;
        }
        StringBuilder sb = new StringBuilder();
        abc.m1811(sb, adds.m2836(this));
        return abc.m1925(sb);
    }

    public String m759cy() {
        return C0453yj.m9903(C0449ye.m9107(abc.m1761(C0459zf.m11163(C0457zc.m10702(this, C0457zc.m10759()), gggy.m4277()), gggy.m4277())));
    }

    public String m760cz() {
        return gggy.m4351(this);
    }

    public boolean equals(@Nullable Object obj) {
        return (obj instanceof C0273jo) && C0452yh.m9583(C0449ye.m9190((C0273jo) obj), C0449ye.m9190(this));
    }

    public int hashCode() {
        return C0460zg.m11248(C0449ye.m9190(this));
    }

    public String toString() {
        return C0449ye.m9190(this);
    }
}
