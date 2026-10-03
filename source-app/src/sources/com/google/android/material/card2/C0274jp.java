package com.google.android.material.card2;

import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.List;
import javax.annotation.Nullable;

public final class C0274jp {

    @Nullable
    String f719lQ;

    @Nullable
    String f721lV;

    @Nullable
    String f722lY;

    @Nullable
    List<String> f725mb;

    String f726mc = gggy.m4277();

    String f723lZ = gggy.m4277();

    int f720lT = -1;

    final List<String> f724ma = new ArrayList();

    public C0274jp() {
        C0460zg.m11251(abe.m2337(this), gggy.m4277());
    }

    private boolean m761E(String str) {
        return C0452yh.m9583(str, C0452yh.m9669()) || C0457zc.m10547(str, C0459zf.m11151());
    }

    private boolean m762F(String str) {
        return C0452yh.m9583(str, C0458ze.m10940()) || C0457zc.m10547(str, C0450yf.m9373()) || C0457zc.m10547(str, C0448yd.m8981()) || C0457zc.m10547(str, C0460zg.m11378());
    }

    private void m763a(String str, int i, int i2, boolean z, boolean z2) {
        String strM9505 = C0450yf.m9505(str, i, i2, gggy.m4316(), z2, false, false, true, null);
        if (C0448yd.m8910(this, strM9505)) {
            return;
        }
        if (C0461zs.m11585(this, strM9505)) {
            abf.m2456(this);
            return;
        }
        if (C0460zg.m11421((String) gggy.m4400(abe.m2337(this), m5240(abe.m2337(this)) - 1))) {
            C0457zc.m10739(abe.m2337(this), m5240(abe.m2337(this)) - 1, strM9505);
        } else {
            C0460zg.m11251(abe.m2337(this), strM9505);
        }
        if (z) {
            C0460zg.m11251(abe.m2337(this), gggy.m4277());
        }
    }

    private void m764cB() {
        if (!C0460zg.m11421((String) abc.m1794(abe.m2337(this), m5240(abe.m2337(this)) - 1)) || C0452yh.m9618(abe.m2337(this))) {
            C0460zg.m11251(abe.m2337(this), gggy.m4277());
        } else {
            C0457zc.m10739(abe.m2337(this), m5240(abe.m2337(this)) - 1, gggy.m4277());
        }
    }

    private static String m765d(String str, int i, int i2) {
        return C0458ze.m10764(C0449ye.m9284(str, i, i2, false));
    }

    private static int m766e(String str, int i, int i2) {
        try {
            int iM8889 = C0448yd.m8889(C0450yf.m9505(str, i, i2, gggy.m4277(), false, false, false, true, null));
            if (iM8889 <= 0 || iM8889 > 65535) {
                return -1;
            }
            return iM8889;
        } catch (NumberFormatException e) {
            return -1;
        }
    }

    private static int m767f(String str, int i, int i2) {
        int i3 = i;
        while (i3 < i2) {
            switch (C0446yb.m8419(str, i3)) {
                case ':':
                    return i3;
                case '[':
                    break;
                default:
                    continue;
                    i3++;
                    break;
            }
            do {
                i3++;
                if (i3 >= i2) {
                    break;
                }
            } while (C0446yb.m8419(str, i3) != ']');
            i3++;
        }
        return i2;
    }

    private void m768g(String str, int i, int i2) {
        int i3;
        if (i == i2) {
            return;
        }
        char cM8419 = C0446yb.m8419(str, i);
        if (cM8419 == '/' || cM8419 == '\\') {
            C0450yf.m9419(abe.m2337(this));
            C0460zg.m11251(abe.m2337(this), gggy.m4277());
            i3 = i + 1;
        } else {
            C0457zc.m10739(abe.m2337(this), m5240(abe.m2337(this)) - 1, gggy.m4277());
            i3 = i;
        }
        while (i3 < i2) {
            int iM2142 = abd.m2142(str, i3, i2, C0447yc.m8768());
            boolean z = iM2142 < i2;
            abd.m2123(this, str, i3, iM2142, z, true);
            i3 = z ? iM2142 + 1 : iM2142;
        }
    }

    private static int m769h(String str, int i, int i2) {
        if (i2 - i < 2) {
            return -1;
        }
        char cM8419 = C0446yb.m8419(str, i);
        if ((cM8419 < 'a' || cM8419 > 'z') && (cM8419 < 'A' || cM8419 > 'Z')) {
            return -1;
        }
        for (int i3 = i + 1; i3 < i2; i3++) {
            char cM84110 = C0446yb.m8419(str, i3);
            if ((cM84110 < 'a' || cM84110 > 'z') && ((cM84110 < 'A' || cM84110 > 'Z') && !((cM84110 >= '0' && cM84110 <= '9') || cM84110 == '+' || cM84110 == '-' || cM84110 == '.'))) {
                if (cM84110 == ':') {
                    return i3;
                }
                return -1;
            }
        }
        return -1;
    }

    private static int m770i(String str, int i, int i2) {
        int i3 = 0;
        for (int i4 = i; i4 < i2; i4++) {
            char cM8419 = C0446yb.m8419(str, i4);
            if (cM8419 != '\\' && cM8419 != '/') {
                break;
            }
            i3++;
        }
        return i3;
    }

    public static String m5232(Object obj, int i, int i2, boolean z) {
        if (C0457zc.m10735() <= 0) {
            return C0273jo.m741b((String) obj, i, i2, z);
        }
        return null;
    }

    public static String m5233(Object obj, Object obj2, boolean z, boolean z2, boolean z3, boolean z4) {
        if (C0452yh.m9798() >= 0) {
            return C0273jo.m734a((String) obj, (String) obj2, z, z2, z3, z4);
        }
        return null;
    }

    public static void m5234(Object obj, Object obj2, int i, int i2) {
        if (abd.m2162() >= 0) {
            ((C0274jp) obj).m768g((String) obj2, i, i2);
        }
    }

    public static EnumC0275jq m5235() {
        if (adds.m2755() >= 0) {
            return m5283();
        }
        return null;
    }

    public static int m5236(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return ((C0274jp) obj).f720lT;
        }
        return 0;
    }

    public static String m5237(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return ((C0273jo) obj).f711lQ;
        }
        return null;
    }

    public static EnumC0275jq m5238() {
        if (C0450yf.m9352() < 0) {
            return m5297();
        }
        return null;
    }

    public static int m5239(Object obj, int i, int i2) {
        if (adds.m2755() > 0) {
            return m769h((String) obj, i, i2);
        }
        return 0;
    }

    public static int m5240(Object obj) {
        if (C0445ya.m8222() > 0) {
            return C0598.m11824(obj);
        }
        return 0;
    }

    public static EnumC0275jq m5241() {
        if (gggy.m4269() < 0) {
            return EnumC0275jq.f728me;
        }
        return null;
    }

    public static int m5242(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return ((C0274jp) obj).m778cD();
        }
        return 0;
    }

    public static int m5243(Object obj) {
        if (C0452yh.m9798() >= 0) {
            return ((C0273jo) obj).f714lT;
        }
        return 0;
    }

    public static int m5244(Object obj, int i, int i2) {
        if (abf.m2510() < 0) {
            return m767f((String) obj, i, i2);
        }
        return 0;
    }

    public static int m5245() {
        if (abd.m2162() >= 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static EnumC0275jq m5246() {
        if (abd.m2162() > 0) {
            return m5285();
        }
        return null;
    }

    public static String m5247(Object obj, int i, int i2) {
        if (C0449ye.m9220() <= 0) {
            return m765d((String) obj, i, i2);
        }
        return null;
    }

    public static void m5248(Object obj, Object obj2) {
        if (C0448yd.m9079() <= 0) {
            C0273jo.m742b((StringBuilder) obj, (List) obj2);
        }
    }

    public static void m5249(Object obj, Object obj2) {
        if (C0446yb.m8415() < 0) {
            C0273jo.m740a((StringBuilder) obj, (List<String>) obj2);
        }
    }

    public static boolean m5250(Object obj, Object obj2) {
        if (gggy.m4269() < 0) {
            return ((C0274jp) obj).m761E((String) obj2);
        }
        return false;
    }

    public static String m5251(Object obj) {
        if (C0457zc.m10735() < 0) {
            return ((C0274jp) obj).f723lZ;
        }
        return null;
    }

    public static int m5252(Object obj, int i, int i2) {
        if (abe.m2308() < 0) {
            return C0598.m11792(obj, i, i2);
        }
        return 0;
    }

    public static List m5253(Object obj) {
        if (C0452yh.m9798() >= 0) {
            return ((C0274jp) obj).f724ma;
        }
        return null;
    }

    public static EnumC0275jq m5254() {
        if (C0456zb.m10326() < 0) {
            return EnumC0275jq.f731mh;
        }
        return null;
    }

    public static void m5255(Object obj, Object obj2, int i, int i2, boolean z, boolean z2) {
        if (abd.m2162() > 0) {
            ((C0274jp) obj).m763a((String) obj2, i, i2, z, z2);
        }
    }

    public static void m5256(Object obj) {
        if (C0449ye.m9220() <= 0) {
            ((C0274jp) obj).m764cB();
        }
    }

    public static EnumC0275jq m5257() {
        if (C0447yc.m8635() >= 0) {
            return EnumC0275jq.f732mi;
        }
        return null;
    }

    public static EnumC0275jq m5258() {
        if (C0459zf.m11062() > 0) {
            return m5275();
        }
        return null;
    }

    public static int m5259(Object obj, int i, int i2) {
        if (C0447yc.m8635() >= 0) {
            return m766e((String) obj, i, i2);
        }
        return 0;
    }

    public static String m5260(Object obj) {
        if (C0457zc.m10735() < 0) {
            return ((C0274jp) obj).f719lQ;
        }
        return null;
    }

    public static int m5261(Object obj, int i, int i2) {
        if (C0459zf.m11062() > 0) {
            return m770i((String) obj, i, i2);
        }
        return 0;
    }

    public static String m5262(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return ((C0274jp) obj).f721lV;
        }
        return null;
    }

    public static String m5263(Object obj) {
        if (C0451yg.m9580() > 0) {
            return ((C0274jp) obj).f722lY;
        }
        return null;
    }

    public static String m5264(Object obj) {
        if (C0448yd.m9079() < 0) {
            return ((C0273jo) obj).f716lV;
        }
        return null;
    }

    public static EnumC0275jq m5265() {
        if (abe.m2308() <= 0) {
            return m5281();
        }
        return null;
    }

    public static boolean m5266(Object obj, Object obj2) {
        if (C0451yg.m9580() > 0) {
            return ((C0274jp) obj).m762F((String) obj2);
        }
        return false;
    }

    public static EnumC0275jq m5267() {
        if (C0452yh.m9798() >= 0) {
            return EnumC0275jq.f729mf;
        }
        return null;
    }

    public static String m5268(Object obj, int i, int i2, Object obj2, boolean z, boolean z2, boolean z3, boolean z4, Object obj3) {
        if (C0453yj.m10013() >= 0) {
            return C0273jo.m733a((String) obj, i, i2, (String) obj2, z, z2, z3, z4, (Charset) obj3);
        }
        return null;
    }

    public static List m5269(Object obj) {
        if (C0459zf.m11062() > 0) {
            return ((C0274jp) obj).f725mb;
        }
        return null;
    }

    public static EnumC0275jq m5270() {
        if (C0457zc.m10735() < 0) {
            return EnumC0275jq.f730mg;
        }
        return null;
    }

    public static String m5271(Object obj) {
        if (abe.m2308() < 0) {
            return ((C0274jp) obj).f726mc;
        }
        return null;
    }

    public static List m5272(Object obj) {
        if (C0452yh.m9798() > 0) {
            return C0273jo.m732B((String) obj);
        }
        return null;
    }

    public static boolean m5273(Object obj, Object obj2) {
        if (gggy.m4365() > 0) {
            return m5250((C0274jp) obj, (String) obj2);
        }
        return false;
    }

    public static String m5274(Object obj) {
        if (C0459zf.m11053() >= 0) {
            return m5260((C0274jp) obj);
        }
        return null;
    }

    public static EnumC0275jq m5275() {
        if (C0457zc.m10718() <= 0) {
            return m5270();
        }
        return null;
    }

    public static int m5276(Object obj, int i, int i2) {
        if (C0453yj.m9945() < 0) {
            return m5261((String) obj, i, i2);
        }
        return 0;
    }

    public static void m5277(Object obj, Object obj2) {
        if (C0453yj.m10032() >= 0) {
            m5248((StringBuilder) obj, (List) obj2);
        }
    }

    public static void m5278(Object obj) {
        if (C0459zf.m11053() >= 0) {
            m5256((C0274jp) obj);
        }
    }

    public static void m5279(Object obj, Object obj2, int i, int i2) {
        if (C0453yj.m9996() <= 0) {
            m5234((C0274jp) obj, (String) obj2, i, i2);
        }
    }

    public static int m5280(Object obj, int i, int i2) {
        if (C0453yj.m9996() <= 0) {
            return m5239((String) obj, i, i2);
        }
        return 0;
    }

    public static EnumC0275jq m5281() {
        if (C0448yd.m9074() < 0) {
            return m5257();
        }
        return null;
    }

    public static String m5282(Object obj) {
        if (abe.m2321() < 0) {
            return m5263((C0274jp) obj);
        }
        return null;
    }

    public static EnumC0275jq m5283() {
        if (C0447yc.m8786() > 0) {
            return m5267();
        }
        return null;
    }

    public static int m5284(Object obj) {
        if (C0453yj.m9966() > 0) {
            return m5243((C0273jo) obj);
        }
        return 0;
    }

    public static EnumC0275jq m5285() {
        if (m5245() > 0) {
            return m5254();
        }
        return null;
    }

    public static int m5286(Object obj, int i, int i2) {
        if (C0460zg.m11293() >= 0) {
            return m5259((String) obj, i, i2);
        }
        return 0;
    }

    public static String m5287(Object obj, int i, int i2, Object obj2, boolean z, boolean z2, boolean z3, boolean z4, Object obj3) {
        if (C0448yd.m9074() <= 0) {
            return m5268((String) obj, i, i2, (String) obj2, z, z2, z3, z4, (Charset) obj3);
        }
        return null;
    }

    public static boolean m5288(Object obj, Object obj2) {
        if (C0453yj.m10032() >= 0) {
            return m5266((C0274jp) obj, (String) obj2);
        }
        return false;
    }

    public static String m5289(Object obj) {
        if (C0447yc.m8786() > 0) {
            return m5251((C0274jp) obj);
        }
        return null;
    }

    public static int m5290(Object obj, int i, int i2) {
        if (abd.m2021() > 0) {
            return m5244((String) obj, i, i2);
        }
        return 0;
    }

    public static void m5291(Object obj, Object obj2) {
        if (C0457zc.m10718() < 0) {
            m5249((StringBuilder) obj, (List) obj2);
        }
    }

    public static List m5292(Object obj) {
        if (C0456zb.m10484() < 0) {
            return m5253((C0274jp) obj);
        }
        return null;
    }

    public static int m5293(Object obj) {
        if (C0453yj.m9966() >= 0) {
            return m5242((C0274jp) obj);
        }
        return 0;
    }

    public static String m5294(Object obj) {
        if (C0448yd.m9015() < 0) {
            return m5271((C0274jp) obj);
        }
        return null;
    }

    public static String m5295(Object obj) {
        if (C0453yj.m9996() <= 0) {
            return m5237((C0273jo) obj);
        }
        return null;
    }

    public static String m5296(Object obj) {
        if (C0453yj.m9966() > 0) {
            return m5264((C0273jo) obj);
        }
        return null;
    }

    public static EnumC0275jq m5297() {
        if (C0457zc.m10718() <= 0) {
            return m5241();
        }
        return null;
    }

    public static List m5298(Object obj) {
        if (abd.m2021() >= 0) {
            return m5269((C0274jp) obj);
        }
        return null;
    }

    public static String m5299(Object obj, Object obj2, boolean z, boolean z2, boolean z3, boolean z4) {
        if (C0456zb.m10484() <= 0) {
            return m5233((String) obj, (String) obj2, z, z2, z3, z4);
        }
        return null;
    }

    public static String m5300(Object obj, int i, int i2, boolean z) {
        if (abd.m2021() >= 0) {
            return m5232((String) obj, i, i2, z);
        }
        return null;
    }

    public static void m5301(Object obj, Object obj2, int i, int i2, boolean z, boolean z2) {
        if (C0460zg.m11293() >= 0) {
            m5255((C0274jp) obj, (String) obj2, i, i2, z, z2);
        }
    }

    public static int m5302(Object obj) {
        if (C0459zf.m11053() >= 0) {
            return m5236((C0274jp) obj);
        }
        return 0;
    }

    public static String m5303(Object obj, int i, int i2) {
        if (abd.m2166() < 0) {
            return m5247((String) obj, i, i2);
        }
        return null;
    }

    public static String m5304(Object obj) {
        if (abe.m2321() < 0) {
            return m5262((C0274jp) obj);
        }
        return null;
    }

    public static List m5305(Object obj) {
        if (gggy.m4365() > 0) {
            return m5272((String) obj);
        }
        return null;
    }

    public C0274jp m771G(@Nullable String str) {
        this.f725mb = str != null ? C0446yb.m8529(C0452yh.m9648(str, C0459zf.m11023(), true, false, true, true)) : null;
        return this;
    }

    public C0274jp m772H(String str) {
        if (str == null) {
            throw new NullPointerException(C0457zc.m10748());
        }
        String strM9272 = C0449ye.m9272(str, 0, gggy.m4397(str));
        if (strM9272 == null) {
            throw new IllegalArgumentException(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), abf.m2484()), str)));
        }
        this.f719lQ = strM9272;
        return this;
    }

    public C0274jp m773I(String str) {
        if (str == null) {
            throw new NullPointerException(adds.m2874());
        }
        this.f723lZ = C0452yh.m9648(str, C0458ze.m10873(), false, false, false, true);
        return this;
    }

    public C0274jp m774J(String str) {
        if (str == null) {
            throw new NullPointerException(C0449ye.m9286());
        }
        if (C0457zc.m10547(str, abd.m2063())) {
            this.f721lV = abd.m2063();
        } else {
            if (!C0457zc.m10547(str, C0459zf.m11016())) {
                throw new IllegalArgumentException(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), abf.m2485()), str)));
            }
            this.f721lV = C0459zf.m11016();
        }
        return this;
    }

    public C0274jp m775K(String str) {
        if (str == null) {
            throw new NullPointerException(gggy.m4295());
        }
        this.f726mc = C0452yh.m9648(str, C0458ze.m10873(), false, false, false, true);
        return this;
    }

    EnumC0275jq m776b(@Nullable C0273jo c0273jo, String str) {
        boolean z;
        boolean z2;
        int iM10248;
        int iM5252 = m5252(str, 0, gggy.m4397(str));
        int iM8627 = C0447yc.m8627(str, iM5252, gggy.m4397(str));
        if (C0452yh.m9744(str, iM5252, iM8627) != -1) {
            if (C0446yb.m8547(str, true, iM5252, abe.m2295(), 0, 6)) {
                this.f721lV = C0459zf.m11016();
                iM5252 += gggy.m4397(abe.m2295());
            } else {
                if (!C0446yb.m8547(str, true, iM5252, C0460zg.m11308(), 0, 5)) {
                    return m5265();
                }
                this.f721lV = abd.m2063();
                iM5252 += gggy.m4397(C0460zg.m11308());
            }
        } else {
            if (c0273jo == null) {
                return m5258();
            }
            this.f721lV = adds.m2807(c0273jo);
        }
        boolean z3 = false;
        int iM10559 = C0457zc.m10559(str, iM5252, iM8627);
        if (iM10559 >= 2 || c0273jo == null || !C0452yh.m9583(adds.m2807(c0273jo), C0447yc.m8671(this))) {
            int i = iM5252 + iM10559;
            boolean z4 = false;
            while (true) {
                iM5252 = abd.m2142(str, i, iM8627, C0457zc.m10587());
                switch (iM5252 != iM8627 ? C0446yb.m8419(str, iM5252) : (byte) -1) {
                    case -1:
                    case 35:
                    case 47:
                    case 63:
                    case 92:
                        int iM8337 = C0445ya.m8337(str, i, iM5252);
                        if (iM8337 + 1 < iM5252) {
                            this.f719lQ = C0449ye.m9272(str, i, iM8337);
                            this.f720lT = C0459zf.m11103(str, iM8337 + 1, iM5252);
                            if (abc.m1786(this) == -1) {
                                return m5235();
                            }
                        } else {
                            this.f719lQ = C0449ye.m9272(str, i, iM8337);
                            this.f720lT = C0447yc.m8714(C0447yc.m8671(this));
                        }
                        if (C0461zs.m11463(this) == null) {
                            return m5238();
                        }
                        break;
                    case 64:
                        if (z3) {
                            this.f723lZ = abc.m1925(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), abc.m1770(this)), C0448yd.m8927()), C0450yf.m9505(str, i, iM5252, C0458ze.m10873(), true, false, false, true, null)));
                            z = z4;
                        } else {
                            int iM10249 = C0455za.m10248(str, i, iM5252, ':');
                            String strM9505 = C0450yf.m9505(str, i, iM10249, C0458ze.m10873(), true, false, false, true, null);
                            if (z4) {
                                strM9505 = abc.m1925(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), abf.m2431(this)), C0448yd.m8927()), strM9505));
                            }
                            this.f726mc = strM9505;
                            if (iM10249 != iM5252) {
                                this.f723lZ = C0450yf.m9505(str, iM10249 + 1, iM5252, C0458ze.m10873(), true, false, false, true, null);
                                z2 = true;
                            } else {
                                z2 = z3;
                            }
                            z = true;
                            z3 = z2;
                        }
                        i = iM5252 + 1;
                        z4 = z;
                        break;
                    default:
                        break;
                }
            }
        } else {
            this.f726mc = C0447yc.m8655(c0273jo);
            this.f723lZ = C0450yf.m9429(c0273jo);
            this.f719lQ = C0453yj.m9969(c0273jo);
            this.f720lT = C0445ya.m8197(c0273jo);
            C0450yf.m9419(abe.m2337(this));
            C0447yc.m8634(abe.m2337(this), C0446yb.m8484(c0273jo));
            if (iM5252 == iM8627 || C0446yb.m8419(str, iM5252) == '#') {
                abf.m2468(this, C0461zs.m11622(c0273jo));
            }
        }
        int iM2142 = abd.m2142(str, iM5252, iM8627, gggy.m4408());
        abf.m2508(this, str, iM5252, iM2142);
        if (iM2142 >= iM8627 || C0446yb.m8419(str, iM2142) != '?') {
            iM10248 = iM2142;
        } else {
            iM10248 = C0455za.m10248(str, iM2142, iM8627, '#');
            this.f725mb = C0446yb.m8529(C0450yf.m9505(str, iM2142 + 1, iM10248, C0459zf.m11023(), true, false, true, true, null));
        }
        if (iM10248 < iM8627 && C0446yb.m8419(str, iM10248) == '#') {
            this.f722lY = C0450yf.m9505(str, iM10248 + 1, iM8627, gggy.m4277(), true, false, false, false, null);
        }
        return m5246();
    }

    public C0273jo m777cC() {
        if (C0447yc.m8671(this) == null) {
            throw new IllegalStateException(C0449ye.m9286());
        }
        if (C0461zs.m11463(this) == null) {
            throw new IllegalStateException(C0457zc.m10748());
        }
        return new C0273jo(this);
    }

    int m778cD() {
        return abc.m1786(this) != -1 ? abc.m1786(this) : C0447yc.m8714(C0447yc.m8671(this));
    }

    C0274jp m779cE() {
        int iM5240 = m5240(abe.m2337(this));
        for (int i = 0; i < iM5240; i++) {
            C0457zc.m10739(abe.m2337(this), i, C0452yh.m9648((String) gggy.m4400(abe.m2337(this), i), C0455za.m10098(), true, true, false, true));
        }
        if (abc.m1792(this) != null) {
            int iM5241 = m5240(abc.m1792(this));
            for (int i2 = 0; i2 < iM5241; i2++) {
                String str = (String) gggy.m4400(abc.m1792(this), i2);
                if (str != null) {
                    C0457zc.m10739(abc.m1792(this), i2, C0452yh.m9648(str, abd.m2137(), true, true, true, true));
                }
            }
        }
        if (C0459zf.m11215(this) != null) {
            this.f722lY = C0452yh.m9648(C0459zf.m11215(this), gggy.m4412(), true, true, false, false);
        }
        return this;
    }

    public C0274jp m780i(int i) {
        if (i <= 0 || i > 65535) {
            throw new IllegalArgumentException(abc.m1925(adds.m2680(C0460zg.m11407(new StringBuilder(), abd.m2128()), i)));
        }
        this.f720lT = i;
        return this;
    }

    public C0274jp m781k(String str, @Nullable String str2) {
        if (str == null) {
            throw new NullPointerException(C0447yc.m8804());
        }
        if (abc.m1792(this) == null) {
            this.f725mb = new ArrayList();
        }
        C0460zg.m11251(abc.m1792(this), C0452yh.m9648(str, gggy.m4429(), false, false, true, true));
        C0460zg.m11251(abc.m1792(this), str2 != null ? C0452yh.m9648(str2, gggy.m4429(), false, false, true, true) : null);
        return this;
    }

    public String toString() {
        StringBuilder sb = new StringBuilder();
        C0460zg.m11407(sb, C0447yc.m8671(this));
        C0460zg.m11407(sb, adds.m2877());
        if (!C0460zg.m11421(abf.m2431(this)) || !C0460zg.m11421(abc.m1770(this))) {
            C0460zg.m11407(sb, abf.m2431(this));
            if (!C0460zg.m11421(abc.m1770(this))) {
                abe.m2346(sb, ':');
                C0460zg.m11407(sb, abc.m1770(this));
            }
            abe.m2346(sb, '@');
        }
        if (C0458ze.m10892(C0461zs.m11463(this), 58) != -1) {
            abe.m2346(sb, '[');
            C0460zg.m11407(sb, C0461zs.m11463(this));
            abe.m2346(sb, ']');
        } else {
            C0460zg.m11407(sb, C0461zs.m11463(this));
        }
        int iM9033 = C0448yd.m9033(this);
        if (iM9033 != C0447yc.m8714(C0447yc.m8671(this))) {
            abe.m2346(sb, ':');
            adds.m2680(sb, iM9033);
        }
        C0448yd.m9069(sb, abe.m2337(this));
        if (abc.m1792(this) != null) {
            abe.m2346(sb, '?');
            abc.m1796(sb, abc.m1792(this));
        }
        if (C0459zf.m11215(this) != null) {
            abe.m2346(sb, '#');
            C0460zg.m11407(sb, C0459zf.m11215(this));
        }
        return abc.m1925(sb);
    }
}
