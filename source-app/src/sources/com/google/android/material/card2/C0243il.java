package com.google.android.material.card2;

import javax.annotation.Nullable;

public final class C0243il {

    @Nullable
    String f508ih;

    private final boolean f509ii;

    private final boolean f510ij;

    private final boolean f511ik;

    private final int f512il;

    private final int f513im;

    private final int f514in;

    private final boolean f515io;

    private final boolean f516ip;

    private final boolean f517iq;

    private final boolean f518ir;

    private final boolean f519is;

    private final int f520it;

    public static final C0243il f507ig = C0450yf.m9418(adds.m2806(new C0244im()));

    public static final C0243il f506if = C0450yf.m9418(C0458ze.m10778(abc.m1750(new C0244im()), Integer.MAX_VALUE, C0446yb.m8507()));

    C0243il(C0244im c0244im) {
        this.f516ip = C0445ya.m8238(c0244im);
        this.f517iq = C0452yh.m9673(c0244im);
        this.f512il = gggy.m4476(c0244im);
        this.f520it = -1;
        this.f510ij = false;
        this.f511ik = false;
        this.f515io = false;
        this.f513im = C0452yh.m9585(c0244im);
        this.f514in = abe.m2390(c0244im);
        this.f519is = abc.m1778(c0244im);
        this.f518ir = C0453yj.m9853(c0244im);
        this.f509ii = gggy.m4419(c0244im);
    }

    private C0243il(boolean z, boolean z2, int i, int i2, boolean z3, boolean z4, boolean z5, int i3, int i4, boolean z6, boolean z7, boolean z8, @Nullable String str) {
        this.f516ip = z;
        this.f517iq = z2;
        this.f512il = i;
        this.f520it = i2;
        this.f510ij = z3;
        this.f511ik = z4;
        this.f515io = z5;
        this.f513im = i3;
        this.f514in = i4;
        this.f519is = z6;
        this.f518ir = z7;
        this.f509ii = z8;
        this.f508ih = str;
    }

    public static C0243il m616a(C0271jm c0271jm) {
        int iM8542;
        int iM8543;
        String strM9463;
        boolean z = false;
        boolean z2 = false;
        int i = -1;
        int i2 = -1;
        boolean z3 = false;
        boolean z4 = false;
        boolean z5 = false;
        int iM8544 = -1;
        int iM8545 = -1;
        boolean z6 = false;
        boolean z7 = false;
        boolean z8 = false;
        boolean z9 = true;
        String str = null;
        int iM11431 = C0460zg.m11431(c0271jm);
        int i3 = 0;
        while (i3 < iM11431) {
            String strM8434 = C0446yb.m8434(c0271jm, i3);
            String strM4283 = gggy.m4283(c0271jm, i3);
            if (!C0457zc.m10547(strM8434, C0459zf.m11003())) {
                if (C0457zc.m10547(strM8434, C0447yc.m8659())) {
                    z9 = false;
                } else {
                    iM8542 = i;
                    iM8543 = i2;
                }
                i3++;
                i = iM8542;
                i2 = iM8543;
            } else if (str != null) {
                z9 = false;
            } else {
                str = strM4283;
            }
            int iM8228 = 0;
            iM8542 = i;
            iM8543 = i2;
            while (iM8228 < gggy.m4397(strM4283)) {
                int iM8229 = C0445ya.m8228(strM4283, iM8228, C0448yd.m8860());
                String strM9464 = C0450yf.m9463(C0447yc.m8745(strM4283, iM8228, iM8229));
                if (iM8229 == gggy.m4397(strM4283) || C0446yb.m8419(strM4283, iM8229) == ',' || C0446yb.m8419(strM4283, iM8229) == ';') {
                    iM8228 = iM8229 + 1;
                    strM9463 = null;
                } else {
                    int iM10512 = C0456zb.m10512(strM4283, iM8229 + 1);
                    if (iM10512 >= gggy.m4397(strM4283) || C0446yb.m8419(strM4283, iM10512) != '\"') {
                        iM8228 = C0445ya.m8228(strM4283, iM10512, C0460zg.m11244());
                        strM9463 = C0450yf.m9463(C0447yc.m8745(strM4283, iM10512, iM8228));
                    } else {
                        int i4 = iM10512 + 1;
                        int iM82210 = C0445ya.m8228(strM4283, i4, C0448yd.m8958());
                        strM9463 = C0447yc.m8745(strM4283, i4, iM82210);
                        iM8228 = iM82210 + 1;
                    }
                }
                if (C0457zc.m10547(C0449ye.m9229(), strM9464)) {
                    z = true;
                } else if (C0457zc.m10547(abd.m2064(), strM9464)) {
                    z2 = true;
                } else if (C0457zc.m10547(C0459zf.m11012(), strM9464)) {
                    iM8542 = C0446yb.m8542(strM9463, -1);
                } else if (C0457zc.m10547(abf.m2429(), strM9464)) {
                    iM8543 = C0446yb.m8542(strM9463, -1);
                } else if (C0457zc.m10547(gggy.m4487(), strM9464)) {
                    z3 = true;
                } else if (C0457zc.m10547(abc.m1758(), strM9464)) {
                    z4 = true;
                } else if (C0457zc.m10547(C0459zf.m11064(), strM9464)) {
                    z5 = true;
                } else if (C0457zc.m10547(C0452yh.m9711(), strM9464)) {
                    iM8544 = C0446yb.m8542(strM9463, Integer.MAX_VALUE);
                } else if (C0457zc.m10547(C0453yj.m9868(), strM9464)) {
                    iM8545 = C0446yb.m8542(strM9463, -1);
                } else if (C0457zc.m10547(abf.m2516(), strM9464)) {
                    z6 = true;
                } else if (C0457zc.m10547(abe.m2320(), strM9464)) {
                    z7 = true;
                } else if (C0457zc.m10547(C0456zb.m10321(), strM9464)) {
                    z8 = true;
                }
            }
            i3++;
            i = iM8542;
            i2 = iM8543;
        }
        return new C0243il(z, z2, i, i2, z3, z4, z5, iM8544, iM8545, z6, z7, z8, !z9 ? null : str);
    }

    private String m617bG() {
        StringBuilder sb = new StringBuilder();
        if (C0461zs.m11540(this)) {
            C0460zg.m11407(sb, C0449ye.m9108());
        }
        if (C0461zs.m11571(this)) {
            C0460zg.m11407(sb, C0458ze.m10852());
        }
        if (abe.m2326(this) != -1) {
            C0460zg.m11407(adds.m2680(C0460zg.m11407(sb, C0457zc.m10605()), abe.m2326(this)), abf.m2599());
        }
        if (C0461zs.m11522(this) != -1) {
            C0460zg.m11407(adds.m2680(C0460zg.m11407(sb, C0453yj.m9921()), C0461zs.m11522(this)), abf.m2599());
        }
        if (C0458ze.m10905(this)) {
            C0460zg.m11407(sb, C0445ya.m8365());
        }
        if (abf.m2515(this)) {
            C0460zg.m11407(sb, gggy.m4413());
        }
        if (abc.m1945(this)) {
            C0460zg.m11407(sb, m4896());
        }
        if (C0456zb.m10365(this) != -1) {
            C0460zg.m11407(adds.m2680(C0460zg.m11407(sb, abd.m2076()), C0456zb.m10365(this)), abf.m2599());
        }
        if (C0459zf.m11094(this) != -1) {
            C0460zg.m11407(adds.m2680(C0460zg.m11407(sb, abe.m2243()), C0459zf.m11094(this)), abf.m2599());
        }
        if (gggy.m4461(this)) {
            C0460zg.m11407(sb, C0446yb.m8532());
        }
        if (C0455za.m10259(this)) {
            C0460zg.m11407(sb, C0447yc.m8782());
        }
        if (C0457zc.m10761(this)) {
            C0460zg.m11407(sb, C0448yd.m9030());
        }
        if (abd.m2036(sb) == 0) {
            return gggy.m4277();
        }
        C0449ye.m9148(sb, abd.m2036(sb) - 2, abd.m2036(sb));
        return abc.m1925(sb);
    }

    public static boolean m4877(Object obj) {
        if (C0460zg.m11287() > 0) {
            return ((C0243il) obj).f516ip;
        }
        return false;
    }

    public static int m4878(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return ((C0244im) obj).f523im;
        }
        return 0;
    }

    public static boolean m4879(Object obj) {
        if (C0459zf.m11062() > 0) {
            return ((C0243il) obj).f515io;
        }
        return false;
    }

    public static int m4880(Object obj) {
        if (abf.m2510() <= 0) {
            return ((C0243il) obj).f520it;
        }
        return 0;
    }

    public static int m4881() {
        if (C0460zg.m11287() >= 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static boolean m4882(Object obj) {
        if (C0446yb.m8415() < 0) {
            return ((C0243il) obj).f518ir;
        }
        return false;
    }

    public static boolean m4883(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return ((C0244im) obj).f525ip;
        }
        return false;
    }

    public static int m4884(Object obj) {
        if (abe.m2308() <= 0) {
            return ((C0243il) obj).f514in;
        }
        return 0;
    }

    public static boolean m4885(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return ((C0243il) obj).f509ii;
        }
        return false;
    }

    public static int m4886(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return ((C0243il) obj).f512il;
        }
        return 0;
    }

    public static boolean m4887(Object obj) {
        if (C0457zc.m10735() < 0) {
            return ((C0243il) obj).f519is;
        }
        return false;
    }

    public static boolean m4888(Object obj) {
        if (C0448yd.m9079() < 0) {
            return ((C0244im) obj).f521ii;
        }
        return false;
    }

    public static int m4889(Object obj) {
        if (gggy.m4269() <= 0) {
            return ((C0244im) obj).f522il;
        }
        return 0;
    }

    public static String m4890(Object obj) {
        if (abe.m2308() < 0) {
            return ((C0243il) obj).m617bG();
        }
        return null;
    }

    public static boolean m4891(Object obj) {
        if (C0461zs.m11510() < 0) {
            return ((C0243il) obj).f517iq;
        }
        return false;
    }

    public static boolean m4892(Object obj) {
        if (abe.m2308() < 0) {
            return ((C0244im) obj).f528is;
        }
        return false;
    }

    public static String m4893(Object obj) {
        if (C0446yb.m8415() < 0) {
            return ((C0243il) obj).f508ih;
        }
        return null;
    }

    public static int m4894(Object obj) {
        if (C0460zg.m11287() > 0) {
            return ((C0244im) obj).f524in;
        }
        return 0;
    }

    public static boolean m4895(Object obj) {
        if (gggy.m4269() <= 0) {
            return ((C0244im) obj).f526iq;
        }
        return false;
    }

    public static String m4896() {
        if (C0451yg.m9580() > 0) {
            return C0598.m11812();
        }
        return null;
    }

    public static int m4897(Object obj) {
        if (abd.m2162() > 0) {
            return ((C0243il) obj).f513im;
        }
        return 0;
    }

    public static boolean m4898(Object obj) {
        if (gggy.m4269() < 0) {
            return ((C0243il) obj).f511ik;
        }
        return false;
    }

    public static boolean m4899(Object obj) {
        if (C0452yh.m9798() > 0) {
            return ((C0244im) obj).f527ir;
        }
        return false;
    }

    public static boolean m4900(Object obj) {
        if (C0457zc.m10735() <= 0) {
            return ((C0243il) obj).f510ij;
        }
        return false;
    }

    public static boolean m4901(Object obj) {
        if (abd.m2166() <= 0) {
            return m4891((C0243il) obj);
        }
        return false;
    }

    public static boolean m4902(Object obj) {
        if (C0453yj.m9945() <= 0) {
            return m4885((C0243il) obj);
        }
        return false;
    }

    public static boolean m4903(Object obj) {
        if (C0457zc.m10555() > 0) {
            return m4887((C0243il) obj);
        }
        return false;
    }

    public static boolean m4904(Object obj) {
        if (m4881() >= 0) {
            return m4895((C0244im) obj);
        }
        return false;
    }

    public static int m4905(Object obj) {
        if (abe.m2321() < 0) {
            return m4889((C0244im) obj);
        }
        return 0;
    }

    public static boolean m4906(Object obj) {
        if (C0460zg.m11293() >= 0) {
            return m4879((C0243il) obj);
        }
        return false;
    }

    public static boolean m4907(Object obj) {
        if (gggy.m4365() > 0) {
            return m4898((C0243il) obj);
        }
        return false;
    }

    public static int m4908(Object obj) {
        if (C0460zg.m11293() >= 0) {
            return m4897((C0243il) obj);
        }
        return 0;
    }

    public static int m4909(Object obj) {
        if (C0459zf.m11053() >= 0) {
            return m4894((C0244im) obj);
        }
        return 0;
    }

    public static int m4910(Object obj) {
        if (C0456zb.m10484() < 0) {
            return m4878((C0244im) obj);
        }
        return 0;
    }

    public static int m4911(Object obj) {
        if (abe.m2321() <= 0) {
            return m4886((C0243il) obj);
        }
        return 0;
    }

    public static String m4912(Object obj) {
        if (C0453yj.m10032() > 0) {
            return m4893((C0243il) obj);
        }
        return null;
    }

    public static String m4913(Object obj) {
        if (C0453yj.m10032() > 0) {
            return m4890((C0243il) obj);
        }
        return null;
    }

    public static boolean m4914(Object obj) {
        if (C0453yj.m9966() > 0) {
            return m4888((C0244im) obj);
        }
        return false;
    }

    public static boolean m4915(Object obj) {
        if (abd.m2166() <= 0) {
            return m4877((C0243il) obj);
        }
        return false;
    }

    public static boolean m4916(Object obj) {
        if (C0458ze.m10926() <= 0) {
            return m4900((C0243il) obj);
        }
        return false;
    }

    public static boolean m4917(Object obj) {
        if (C0459zf.m11053() > 0) {
            return m4892((C0244im) obj);
        }
        return false;
    }

    public static int m4918(Object obj) {
        if (abd.m2166() <= 0) {
            return m4880((C0243il) obj);
        }
        return 0;
    }

    public static int m4919(Object obj) {
        if (C0447yc.m8786() >= 0) {
            return m4884((C0243il) obj);
        }
        return 0;
    }

    public static boolean m4920(Object obj) {
        if (C0459zf.m11053() > 0) {
            return m4899((C0244im) obj);
        }
        return false;
    }

    public static boolean m4921(Object obj) {
        if (C0445ya.m8330() > 0) {
            return m4882((C0243il) obj);
        }
        return false;
    }

    public static boolean m4922(Object obj) {
        if (abd.m2166() < 0) {
            return m4883((C0244im) obj);
        }
        return false;
    }

    public boolean m618bH() {
        return C0457zc.m10761(this);
    }

    public boolean m619bI() {
        return C0458ze.m10905(this);
    }

    public boolean m620bJ() {
        return abf.m2515(this);
    }

    public int m621bK() {
        return abe.m2326(this);
    }

    public int m622bL() {
        return C0456zb.m10365(this);
    }

    public int m623bM() {
        return C0459zf.m11094(this);
    }

    public boolean m624bN() {
        return abc.m1945(this);
    }

    public boolean m625bO() {
        return C0461zs.m11540(this);
    }

    public boolean m626bP() {
        return C0461zs.m11571(this);
    }

    public boolean m627bQ() {
        return gggy.m4461(this);
    }

    public String toString() {
        String strM11620 = C0461zs.m11620(this);
        if (strM11620 != null) {
            return strM11620;
        }
        String strM9444 = C0450yf.m9444(this);
        this.f508ih = strM9444;
        return strM9444;
    }
}
