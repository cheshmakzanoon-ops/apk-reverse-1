package com.google.android.material.card2;

import java.util.ArrayList;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.annotation.Nullable;

public final class C0257iz {

    private final String f677li;

    private final long f678lj;

    private final boolean f679lk;

    private final boolean f680ll;

    private final String f681lm;

    private final String f682ln;

    private final boolean f683lo;

    private final boolean f684lp;

    private final String f685lq;

    private static final Pattern f676lh = C0461zs.m11638(C0448yd.m8853());

    private static final Pattern f674lf = C0461zs.m11638(C0446yb.m8586());

    private static final Pattern f673le = C0461zs.m11638(C0449ye.m9309());

    private static final Pattern f675lg = C0461zs.m11638(C0453yj.m9860());

    private C0257iz(String str, String str2, long j, String str3, String str4, boolean z, boolean z2, boolean z3, boolean z4) {
        this.f681lm = str;
        this.f685lq = str2;
        this.f678lj = j;
        this.f677li = str3;
        this.f682ln = str4;
        this.f684lp = z;
        this.f680ll = z2;
        this.f679lk = z3;
        this.f683lo = z4;
    }

    private static int m665a(String str, int i, int i2, boolean z) {
        for (int i3 = i; i3 < i2; i3++) {
            char cM8419 = C0446yb.m8419(str, i3);
            if (((cM8419 < ' ' && cM8419 != '\t') || cM8419 >= 127 || (cM8419 >= '0' && cM8419 <= '9') || ((cM8419 >= 'a' && cM8419 <= 'z') || ((cM8419 >= 'A' && cM8419 <= 'Z') || cM8419 == ':'))) == (!z)) {
                return i3;
            }
        }
        return i2;
    }

    @Nullable
    static C0257iz m666a(long j, C0273jo c0273jo, String str) {
        long j2;
        String strM8745;
        String strM8237;
        int iM4397 = gggy.m4397(str);
        int iM10248 = C0455za.m10248(str, 0, iM4397, ';');
        int iM10249 = C0455za.m10248(str, 0, iM10248, '=');
        if (iM10249 == iM10248) {
            return null;
        }
        String strM2399 = abe.m2399(str, 0, iM10249);
        if (C0460zg.m11421(strM2399) || abf.m2641(strM2399) != -1) {
            return null;
        }
        String strM23910 = abe.m2399(str, iM10249 + 1, iM10248);
        if (abf.m2641(strM23910) != -1) {
            return null;
        }
        long jM8590 = 253402300799999L;
        long jM10157 = -1;
        String str2 = null;
        String str3 = null;
        boolean z = false;
        boolean z2 = false;
        boolean z3 = true;
        boolean z4 = false;
        int i = iM10248 + 1;
        while (i < iM4397) {
            int iM102410 = C0455za.m10248(str, i, iM4397, ';');
            int iM102411 = C0455za.m10248(str, i, iM102410, '=');
            String strM23911 = abe.m2399(str, i, iM102411);
            String strM23912 = iM102411 < iM102410 ? abe.m2399(str, iM102411 + 1, iM102410) : gggy.m4277();
            if (C0457zc.m10547(strM23911, abc.m1752())) {
                try {
                    jM8590 = C0446yb.m8590(strM23912, 0, gggy.m4397(strM23912));
                    z4 = true;
                    strM23912 = str3;
                    strM8237 = str2;
                } catch (IllegalArgumentException e) {
                    strM23912 = str3;
                    strM8237 = str2;
                }
            } else if (C0457zc.m10547(strM23911, C0459zf.m11012())) {
                try {
                    jM10157 = C0455za.m10157(strM23912);
                    z4 = true;
                    strM23912 = str3;
                    strM8237 = str2;
                } catch (NumberFormatException e2) {
                    strM23912 = str3;
                    strM8237 = str2;
                }
            } else if (C0457zc.m10547(strM23911, C0458ze.m10946())) {
                try {
                    strM8237 = C0445ya.m8237(strM23912);
                    z3 = false;
                    strM23912 = str3;
                } catch (IllegalArgumentException e3) {
                    strM23912 = str3;
                    strM8237 = str2;
                }
            } else if (C0457zc.m10547(strM23911, C0452yh.m9753())) {
                strM8237 = str2;
            } else if (C0457zc.m10547(strM23911, abe.m2198())) {
                z = true;
                strM23912 = str3;
                strM8237 = str2;
            } else if (C0457zc.m10547(strM23911, C0453yj.m9951())) {
                z2 = true;
                strM23912 = str3;
                strM8237 = str2;
            } else {
                strM23912 = str3;
                strM8237 = str2;
            }
            i = iM102410 + 1;
            str2 = strM8237;
            str3 = strM23912;
        }
        if (jM10157 == Long.MIN_VALUE) {
            j2 = Long.MIN_VALUE;
        } else if (jM10157 != -1) {
            j2 = (jM10157 <= 9223372036854775L ? 1000 * jM10157 : Long.MAX_VALUE) + j;
            if (j2 < j || j2 > 253402300799999L) {
                j2 = 253402300799999L;
            }
        } else {
            j2 = jM8590;
        }
        String strM2260 = abe.m2260(c0273jo);
        if (str2 == null) {
            str2 = strM2260;
        } else if (!abe.m2219(strM2260, str2)) {
            return null;
        }
        if (gggy.m4397(strM2260) != gggy.m4397(str2) && C0450yf.m9424(C0447yc.m8831(), str2) == null) {
            return null;
        }
        if (str3 == null || !C0458ze.m10811(str3, m5079())) {
            String strM2414 = abf.m2414(c0273jo);
            int iM9592 = C0452yh.m9592(strM2414, 47);
            strM8745 = iM9592 != 0 ? C0447yc.m8745(strM2414, 0, iM9592) : m5079();
        } else {
            strM8745 = str3;
        }
        return new C0257iz(strM2399, strM23910, j2, str2, strM8745, z, z2, z3, z4);
    }

    @Nullable
    public static C0257iz m667a(C0273jo c0273jo, String str) {
        return C0453yj.m9886(C0456zb.m10382(), c0273jo, str);
    }

    public static List<C0257iz> m668a(C0273jo c0273jo, C0271jm c0271jm) {
        ArrayList arrayList;
        List listM10211 = C0455za.m10211(c0271jm, C0453yj.m9896());
        ArrayList arrayList2 = null;
        int iM5059 = m5059(listM10211);
        int i = 0;
        while (i < iM5059) {
            C0257iz c0257izM5073 = m5073(c0273jo, (String) gggy.m4400(listM10211, i));
            if (c0257izM5073 == null) {
                arrayList = arrayList2;
            } else {
                arrayList = arrayList2 == null ? new ArrayList() : arrayList2;
                C0460zg.m11251(arrayList, c0257izM5073);
            }
            i++;
            arrayList2 = arrayList;
        }
        return arrayList2 != null ? abc.m1875(arrayList2) : C0461zs.m11607();
    }

    private static long m669b(String str, int i, int i2) {
        int iM4338 = gggy.m4338(str, i, i2, false);
        int iM8889 = -1;
        int iM88810 = -1;
        int iM88811 = -1;
        int iM88812 = -1;
        int iM8885 = -1;
        int iM88813 = -1;
        Matcher matcherM10828 = C0458ze.m10828(C0452yh.m9664(), str);
        while (iM4338 < i2) {
            int iM4339 = gggy.m4338(str, iM4338 + 1, i2, true);
            adds.m2733(matcherM10828, iM4338, iM4339);
            if (iM8889 == -1 && C0447yc.m8825(C0446yb.m8411(matcherM10828, C0452yh.m9664()))) {
                iM8889 = C0448yd.m8889(C0452yh.m9683(matcherM10828, 1));
                iM88810 = C0448yd.m8889(C0452yh.m9683(matcherM10828, 2));
                iM88811 = C0448yd.m8889(C0452yh.m9683(matcherM10828, 3));
            } else if (iM88812 == -1 && C0447yc.m8825(C0446yb.m8411(matcherM10828, adds.m2695()))) {
                iM88812 = C0448yd.m8889(C0452yh.m9683(matcherM10828, 1));
            } else if (iM8885 == -1 && C0447yc.m8825(C0446yb.m8411(matcherM10828, C0445ya.m8339()))) {
                iM8885 = C0448yd.m8885(C0458ze.m10800(C0445ya.m8339()), C0449ye.m9261(C0452yh.m9683(matcherM10828, 1), C0446yb.m8554())) / 4;
            } else if (iM88813 == -1 && C0447yc.m8825(C0446yb.m8411(matcherM10828, C0452yh.m9609()))) {
                iM88813 = C0448yd.m8889(C0452yh.m9683(matcherM10828, 1));
            }
            iM4338 = gggy.m4338(str, iM4339 + 1, i2, false);
        }
        if (iM88813 >= 70 && iM88813 <= 99) {
            iM88813 += 1900;
        }
        if (iM88813 >= 0 && iM88813 <= 69) {
            iM88813 += 2000;
        }
        if (iM88813 < 1601) {
            throw new IllegalArgumentException();
        }
        if (iM8885 == -1) {
            throw new IllegalArgumentException();
        }
        if (iM88812 < 1 || iM88812 > 31) {
            throw new IllegalArgumentException();
        }
        if (iM8889 < 0 || iM8889 > 23) {
            throw new IllegalArgumentException();
        }
        if (iM88810 < 0 || iM88810 > 59) {
            throw new IllegalArgumentException();
        }
        if (iM88811 < 0 || iM88811 > 59) {
            throw new IllegalArgumentException();
        }
        GregorianCalendar gregorianCalendar = new GregorianCalendar(C0450yf.m9401());
        C0460zg.m11316(gregorianCalendar, false);
        m5072(gregorianCalendar, 1, iM88813);
        m5072(gregorianCalendar, 2, iM8885 - 1);
        m5072(gregorianCalendar, 5, iM88812);
        m5072(gregorianCalendar, 11, iM8889);
        m5072(gregorianCalendar, 12, iM88810);
        m5072(gregorianCalendar, 13, iM88811);
        m5072(gregorianCalendar, 14, 0);
        return C0447yc.m8679(gregorianCalendar);
    }

    private static boolean m670e(String str, String str2) {
        if (C0452yh.m9583(str, str2)) {
            return true;
        }
        return C0459zf.m11107(str, str2) && C0446yb.m8419(str, (gggy.m4397(str) - gggy.m4397(str2)) + (-1)) == '.' && !C0453yj.m9993(str);
    }

    private static String m671s(String str) {
        String strM1972 = str;
        if (C0459zf.m11107(strM1972, C0452yh.m9669())) {
            throw new IllegalArgumentException();
        }
        if (C0458ze.m10811(strM1972, C0452yh.m9669())) {
            strM1972 = abc.m1972(strM1972, 1);
        }
        String strM10764 = C0458ze.m10764(strM1972);
        if (strM10764 == null) {
            throw new IllegalArgumentException();
        }
        return strM10764;
    }

    private static long m672t(String str) {
        try {
            long jM10637 = C0457zc.m10637(str);
            if (jM10637 <= 0) {
                return Long.MIN_VALUE;
            }
            return jM10637;
        } catch (NumberFormatException e) {
            if (C0456zb.m10372(str, adds.m2780())) {
                return !C0458ze.m10811(str, gggy.m4481()) ? Long.MAX_VALUE : Long.MIN_VALUE;
            }
            throw e;
        }
    }

    public static String m5058(Object obj) {
        if (C0453yj.m10013() > 0) {
            return ((C0257iz) obj).f677li;
        }
        return null;
    }

    public static int m5059(Object obj) {
        if (C0447yc.m8635() > 0) {
            return C0598.m11824(obj);
        }
        return 0;
    }

    public static String m5060(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return ((C0257iz) obj).f681lm;
        }
        return null;
    }

    public static String m5061(Object obj) {
        if (C0450yf.m9352() < 0) {
            return C0598.m11800(obj);
        }
        return null;
    }

    public static boolean m5062(Object obj, Object obj2) {
        if (C0460zg.m11287() > 0) {
            return m670e((String) obj, (String) obj2);
        }
        return false;
    }

    public static Pattern m5063() {
        if (abe.m2308() <= 0) {
            return f675lg;
        }
        return null;
    }

    public static String m5064(Object obj) {
        if (C0452yh.m9798() >= 0) {
            return m671s((String) obj);
        }
        return null;
    }

    public static boolean m5065(Object obj) {
        if (abd.m2162() > 0) {
            return ((C0257iz) obj).f680ll;
        }
        return false;
    }

    public static Pattern m5066() {
        if (C0456zb.m10326() <= 0) {
            return f674lf;
        }
        return null;
    }

    public static String m5067(Object obj) {
        if (C0458ze.m10932() > 0) {
            return ((C0257iz) obj).f682ln;
        }
        return null;
    }

    public static Pattern m5068() {
        if (C0457zc.m10735() < 0) {
            return f676lh;
        }
        return null;
    }

    public static long m5069(Object obj) {
        if (C0461zs.m11510() < 0) {
            return m672t((String) obj);
        }
        return 0L;
    }

    public static Pattern m5070() {
        if (abd.m2162() >= 0) {
            return f673le;
        }
        return null;
    }

    public static boolean m5071(Object obj) {
        if (abd.m2162() > 0) {
            return ((C0257iz) obj).f684lp;
        }
        return false;
    }

    public static void m5072(Object obj, int i, int i2) {
        if (abc.m1845() < 0) {
            C0598.m11908(obj, i, i2);
        }
    }

    public static C0257iz m5073(Object obj, Object obj2) {
        if (C0452yh.m9798() > 0) {
            return C0598.m11848(obj, obj2);
        }
        return null;
    }

    public static C0257iz m5074(long j, Object obj, Object obj2) {
        if (abd.m2162() >= 0) {
            return m666a(j, (C0273jo) obj, (String) obj2);
        }
        return null;
    }

    public static String m5075(Object obj) {
        if (adds.m2755() > 0) {
            return ((C0257iz) obj).f685lq;
        }
        return null;
    }

    public static int m5076() {
        if (adds.m2755() > 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static String m5077(Object obj, boolean z) {
        if (abc.m1845() <= 0) {
            return ((C0257iz) obj).m674k(z);
        }
        return null;
    }

    public static long m5078(Object obj) {
        if (C0450yf.m9352() < 0) {
            return ((C0257iz) obj).f678lj;
        }
        return 0L;
    }

    public static String m5079() {
        if (C0445ya.m8222() >= 0) {
            return C0598.m11901();
        }
        return null;
    }

    public static long m5080(Object obj, int i, int i2) {
        if (abc.m1845() <= 0) {
            return m669b((String) obj, i, i2);
        }
        return 0L;
    }

    public static boolean m5081(Object obj) {
        if (C0458ze.m10932() >= 0) {
            return ((C0257iz) obj).f683lo;
        }
        return false;
    }

    public static boolean m5082(Object obj) {
        if (abe.m2308() < 0) {
            return ((C0257iz) obj).f679lk;
        }
        return false;
    }

    public static int m5083(Object obj, int i, int i2, boolean z) {
        if (abd.m2162() > 0) {
            return m665a((String) obj, i, i2, z);
        }
        return 0;
    }

    public static Pattern m5084() {
        if (C0459zf.m11053() >= 0) {
            return m5066();
        }
        return null;
    }

    public static boolean m5085(Object obj) {
        if (C0448yd.m9074() < 0) {
            return m5071((C0257iz) obj);
        }
        return false;
    }

    public static long m5086(Object obj) {
        if (C0457zc.m10555() > 0) {
            return m5078((C0257iz) obj);
        }
        return 0L;
    }

    public static boolean m5087(Object obj, Object obj2) {
        if (C0448yd.m9074() < 0) {
            return m5062((String) obj, (String) obj2);
        }
        return false;
    }

    public static boolean m5088(Object obj) {
        if (C0453yj.m9996() < 0) {
            return m5081((C0257iz) obj);
        }
        return false;
    }

    public static boolean m5089(Object obj) {
        if (C0458ze.m10926() <= 0) {
            return m5065((C0257iz) obj);
        }
        return false;
    }

    public static String m5090(Object obj) {
        if (C0448yd.m9015() < 0) {
            return m5064((String) obj);
        }
        return null;
    }

    public static C0257iz m5091(long j, Object obj, Object obj2) {
        if (C0457zc.m10555() > 0) {
            return m5074(j, (C0273jo) obj, (String) obj2);
        }
        return null;
    }

    public static Pattern m5092() {
        if (abd.m2021() >= 0) {
            return m5068();
        }
        return null;
    }

    public static Pattern m5093() {
        if (C0460zg.m11293() >= 0) {
            return m5070();
        }
        return null;
    }

    public static Pattern m5094() {
        if (C0460zg.m11293() > 0) {
            return m5063();
        }
        return null;
    }

    public static String m5095(Object obj) {
        if (C0448yd.m9074() < 0) {
            return m5060((C0257iz) obj);
        }
        return null;
    }

    public static int m5096(Object obj, int i, int i2, boolean z) {
        if (abe.m2321() < 0) {
            return m5083((String) obj, i, i2, z);
        }
        return 0;
    }

    public static boolean m5097(Object obj) {
        if (m5076() > 0) {
            return m5082((C0257iz) obj);
        }
        return false;
    }

    public static String m5098(Object obj) {
        if (C0448yd.m9074() < 0) {
            return m5075((C0257iz) obj);
        }
        return null;
    }

    public static String m5099(Object obj) {
        if (C0456zb.m10484() < 0) {
            return m5067((C0257iz) obj);
        }
        return null;
    }

    public static long m5100(Object obj) {
        if (abd.m2166() < 0) {
            return m5069((String) obj);
        }
        return 0L;
    }

    public static String m5101(Object obj, boolean z) {
        if (m5076() > 0) {
            return m5077((C0257iz) obj, z);
        }
        return null;
    }

    public static String m5102(Object obj) {
        if (C0457zc.m10718() <= 0) {
            return m5058((C0257iz) obj);
        }
        return null;
    }

    public static long m5103(Object obj, int i, int i2) {
        if (C0456zb.m10484() <= 0) {
            return m5080((String) obj, i, i2);
        }
        return 0L;
    }

    public String m673cb() {
        return C0455za.m10179(this);
    }

    public boolean equals(@Nullable Object obj) {
        if (!(obj instanceof C0257iz)) {
            return false;
        }
        C0257iz c0257iz = (C0257iz) obj;
        return C0452yh.m9583(C0455za.m10179(c0257iz), C0455za.m10179(this)) && C0452yh.m9583(C0457zc.m10639(c0257iz), C0457zc.m10639(this)) && C0452yh.m9583(C0449ye.m9214(c0257iz), C0449ye.m9214(this)) && C0452yh.m9583(abe.m2273(c0257iz), abe.m2273(this)) && C0449ye.m9123(c0257iz) == C0449ye.m9123(this) && C0449ye.m9279(c0257iz) == C0449ye.m9279(this) && C0455za.m10164(c0257iz) == C0455za.m10164(this) && C0459zf.m10981(c0257iz) == C0459zf.m10981(this) && C0446yb.m8425(c0257iz) == C0446yb.m8425(this);
    }

    public int hashCode() {
        int iM11248 = C0460zg.m11248(C0455za.m10179(this));
        int iM11249 = C0460zg.m11248(C0457zc.m10639(this));
        int iM112410 = C0460zg.m11248(C0449ye.m9214(this));
        int iM112411 = C0460zg.m11248(abe.m2273(this));
        int iM9123 = (int) (C0449ye.m9123(this) ^ (C0449ye.m9123(this) >>> 32));
        int i = C0449ye.m9279(this) ? 0 : 1;
        int i2 = C0455za.m10164(this) ? 0 : 1;
        return ((((((i + ((((((((((iM11248 + 527) * 31) + iM11249) * 31) + iM112410) * 31) + iM112411) * 31) + iM9123) * 31)) * 31) + i2) * 31) + (C0459zf.m10981(this) ? 0 : 1)) * 31) + (C0446yb.m8425(this) ? 0 : 1);
    }

    String m674k(boolean z) {
        StringBuilder sb = new StringBuilder();
        C0460zg.m11407(sb, C0455za.m10179(this));
        abe.m2346(sb, '=');
        C0460zg.m11407(sb, C0457zc.m10639(this));
        if (C0459zf.m10981(this)) {
            if (C0449ye.m9123(this) == Long.MIN_VALUE) {
                C0460zg.m11407(sb, abc.m1940());
            } else {
                C0460zg.m11407(C0460zg.m11407(sb, C0452yh.m9651()), m5061(new Date(C0449ye.m9123(this))));
            }
        }
        if (!C0446yb.m8425(this)) {
            C0460zg.m11407(sb, abe.m2363());
            if (z) {
                C0460zg.m11407(sb, C0452yh.m9669());
            }
            C0460zg.m11407(sb, C0449ye.m9214(this));
        }
        C0460zg.m11407(C0460zg.m11407(sb, C0458ze.m10825()), abe.m2273(this));
        if (C0449ye.m9279(this)) {
            C0460zg.m11407(sb, C0452yh.m9794());
        }
        if (C0455za.m10164(this)) {
            C0460zg.m11407(sb, C0461zs.m11499());
        }
        return abc.m1925(sb);
    }

    public String toString() {
        return C0449ye.m9247(this, false);
    }

    public String m675w() {
        return C0457zc.m10639(this);
    }
}
