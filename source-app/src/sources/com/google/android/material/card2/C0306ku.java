package com.google.android.material.card2;

import java.util.Date;

public class C0306ku {

    private Date f914oA;

    private String f915oB;

    final long f916oC;

    private long f917oD;

    final C0286ka f918oE;

    private long f919oF;

    private Date f920oG;

    private String f921oH;

    private int f922ow;

    final C0290ke f923ox;

    private String f924oy;

    private Date f925oz;

    public C0306ku(long j, C0286ka c0286ka, C0290ke c0290ke) {
        this.f922ow = -1;
        this.f916oC = j;
        this.f918oE = c0286ka;
        this.f923ox = c0290ke;
        if (c0290ke != null) {
            this.f919oF = C0445ya.m8200(c0290ke);
            this.f917oD = C0450yf.m9500(c0290ke);
            C0271jm c0271jmM8818 = C0447yc.m8818(c0290ke);
            int iM11431 = C0460zg.m11431(c0271jmM8818);
            for (int i = 0; i < iM11431; i++) {
                String strM8434 = C0446yb.m8434(c0271jmM8818, i);
                String strM4283 = gggy.m4283(c0271jmM8818, i);
                if (C0457zc.m10547(C0445ya.m8215(), strM8434)) {
                    this.f920oG = abd.m2016(strM4283);
                    this.f921oH = strM4283;
                } else if (C0457zc.m10547(C0453yj.m10019(), strM8434)) {
                    this.f925oz = abd.m2016(strM4283);
                } else if (C0457zc.m10547(abc.m1934(), strM8434)) {
                    this.f914oA = abd.m2016(strM4283);
                    this.f915oB = strM4283;
                } else if (C0457zc.m10547(C0457zc.m10602(), strM8434)) {
                    this.f924oy = strM4283;
                } else if (C0457zc.m10547(m5847(), strM8434)) {
                    this.f922ow = C0446yb.m8542(strM4283, -1);
                }
            }
        }
    }

    private static boolean m971d(C0286ka c0286ka) {
        return (C0453yj.m9986(c0286ka, C0456zb.m10324()) == null && C0453yj.m9986(c0286ka, abc.m1926()) == null) ? false : true;
    }

    private long m972dC() {
        long jM8390 = C0446yb.m8553(this) != null ? C0445ya.m8390(0L, abf.m2444(this) - C0461zs.m11479(C0446yb.m8553(this))) : 0L;
        if (C0445ya.m8377(this) != -1) {
            jM8390 = C0445ya.m8390(jM8390, abf.m2632(C0446yb.m8507(), C0445ya.m8377(this)));
        }
        return jM8390 + (abf.m2444(this) - C0457zc.m10539(this)) + (abd.m2116(this) - abf.m2444(this));
    }

    private long m973dD() {
        C0243il c0243ilM4455 = gggy.m4455(adds.m2839(this));
        if (C0455za.m10158(c0243ilM4455) != -1) {
            return abf.m2632(C0446yb.m8507(), C0455za.m10158(c0243ilM4455));
        }
        if (C0456zb.m10314(this) != null) {
            long jM11479 = C0461zs.m11479(C0456zb.m10314(this)) - (C0446yb.m8553(this) != null ? C0461zs.m11479(C0446yb.m8553(this)) : abf.m2444(this));
            if (jM11479 <= 0) {
                jM11479 = 0;
            }
            return jM11479;
        }
        if (C0460zg.m11357(this) == null || C0450yf.m9436(C0448yd.m9070(C0450yf.m9510(adds.m2839(this)))) != null) {
            return 0L;
        }
        long jM114710 = (C0446yb.m8553(this) != null ? C0461zs.m11479(C0446yb.m8553(this)) : C0457zc.m10539(this)) - C0461zs.m11479(C0460zg.m11357(this));
        if (jM114710 > 0) {
            return jM114710 / 10;
        }
        return 0L;
    }

    private C0305kt m974dE() {
        String strM10324;
        String strM1917;
        long jM2632 = 0;
        if (adds.m2839(this) == null) {
            return new C0305kt(C0452yh.m9713(this), null);
        }
        if ((!C0455za.m10072(C0452yh.m9713(this)) || C0452yh.m9767(adds.m2839(this)) != null) && C0446yb.m8539(adds.m2839(this), C0452yh.m9713(this))) {
            C0243il c0243ilM2085 = abd.m2085(C0452yh.m9713(this));
            if (abf.m2613(c0243ilM2085) || C0450yf.m9378(C0452yh.m9713(this))) {
                return new C0305kt(C0452yh.m9713(this), null);
            }
            C0243il c0243ilM4455 = gggy.m4455(adds.m2839(this));
            if (C0449ye.m9269(c0243ilM4455)) {
                return new C0305kt(null, adds.m2839(this));
            }
            long jM9262 = C0449ye.m9262(this);
            long jM11124 = C0459zf.m11124(this);
            if (C0455za.m10158(c0243ilM2085) != -1) {
                jM11124 = C0450yf.m9495(jM11124, abf.m2632(C0446yb.m8507(), C0455za.m10158(c0243ilM2085)));
            }
            long jM2633 = abd.m2062(c0243ilM2085) != -1 ? abf.m2632(C0446yb.m8507(), abd.m2062(c0243ilM2085)) : 0L;
            if (!abd.m2157(c0243ilM4455) && adds.m2788(c0243ilM2085) != -1) {
                jM2632 = abf.m2632(C0446yb.m8507(), adds.m2788(c0243ilM2085));
            }
            if (!abf.m2613(c0243ilM4455) && jM9262 + jM2633 < jM2632 + jM11124) {
                C0291kf c0291kfM2342 = abe.m2342(adds.m2839(this));
                if (jM2633 + jM9262 >= jM11124) {
                    C0447yc.m8735(c0291kfM2342, C0458ze.m10785(), C0461zs.m11527());
                }
                if (jM9262 > 86400000 && C0448yd.m8904(this)) {
                    C0447yc.m8735(c0291kfM2342, C0458ze.m10785(), adds.m2692());
                }
                return new C0305kt(null, C0458ze.m10931(c0291kfM2342));
            }
            if (C0457zc.m10660(this) != null) {
                strM10324 = abc.m1926();
                strM1917 = C0457zc.m10660(this);
            } else if (C0460zg.m11357(this) != null) {
                strM10324 = C0456zb.m10324();
                strM1917 = C0449ye.m9104(this);
            } else {
                if (C0446yb.m8553(this) == null) {
                    return new C0305kt(C0452yh.m9713(this), null);
                }
                strM10324 = C0456zb.m10324();
                strM1917 = abc.m1917(this);
            }
            C0272jn c0272jnM8205 = C0445ya.m8205(C0460zg.m11265(C0452yh.m9713(this)));
            C0452yh.m9691(adds.m2768(), c0272jnM8205, strM10324, strM1917);
            return new C0305kt(C0448yd.m8952(C0452yh.m9665(abf.m2428(C0452yh.m9713(this)), C0456zb.m10427(c0272jnM8205))), adds.m2839(this));
        }
        return new C0305kt(C0452yh.m9713(this), null);
    }

    private boolean m975dF() {
        return C0455za.m10158(gggy.m4455(adds.m2839(this))) == -1 && C0456zb.m10314(this) == null;
    }

    public static long m5833(Object obj) {
        if (C0452yh.m9798() > 0) {
            return ((C0306ku) obj).m973dD();
        }
        return 0L;
    }

    public static boolean m5834(Object obj) {
        if (gggy.m4269() <= 0) {
            return ((C0306ku) obj).m975dF();
        }
        return false;
    }

    public static String m5835(Object obj) {
        if (C0448yd.m9079() < 0) {
            return ((C0306ku) obj).f915oB;
        }
        return null;
    }

    public static String m5836(Object obj) {
        if (C0459zf.m11062() > 0) {
            return ((C0306ku) obj).f921oH;
        }
        return null;
    }

    public static long m5837(Object obj) {
        if (abd.m2162() >= 0) {
            return ((C0306ku) obj).f916oC;
        }
        return 0L;
    }

    public static boolean m5838(Object obj) {
        if (C0445ya.m8222() > 0) {
            return m971d((C0286ka) obj);
        }
        return false;
    }

    public static Date m5839(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return ((C0306ku) obj).f925oz;
        }
        return null;
    }

    public static long m5840(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return ((C0306ku) obj).m972dC();
        }
        return 0L;
    }

    public static C0290ke m5841(Object obj) {
        if (C0458ze.m10932() >= 0) {
            return ((C0306ku) obj).f923ox;
        }
        return null;
    }

    public static C0305kt m5842(Object obj) {
        if (gggy.m4269() <= 0) {
            return ((C0306ku) obj).m974dE();
        }
        return null;
    }

    public static long m5843(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return ((C0306ku) obj).f919oF;
        }
        return 0L;
    }

    public static int m5844(Object obj) {
        if (C0456zb.m10326() < 0) {
            return ((C0306ku) obj).f922ow;
        }
        return 0;
    }

    public static long m5845(Object obj) {
        if (C0453yj.m10013() >= 0) {
            return ((C0306ku) obj).f917oD;
        }
        return 0L;
    }

    public static int m5846() {
        if (abf.m2510() <= 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static String m5847() {
        if (C0461zs.m11510() < 0) {
            return C0598.m11787();
        }
        return null;
    }

    public static String m5848(Object obj) {
        if (abf.m2510() <= 0) {
            return ((C0306ku) obj).f924oy;
        }
        return null;
    }

    public static Date m5849(Object obj) {
        if (adds.m2755() >= 0) {
            return ((C0306ku) obj).f914oA;
        }
        return null;
    }

    public static Date m5850(Object obj) {
        if (C0450yf.m9352() < 0) {
            return ((C0306ku) obj).f920oG;
        }
        return null;
    }

    public static C0286ka m5851(Object obj) {
        if (C0446yb.m8415() <= 0) {
            return ((C0306ku) obj).f918oE;
        }
        return null;
    }

    public static long m5852(Object obj) {
        if (C0453yj.m10032() >= 0) {
            return m5837((C0306ku) obj);
        }
        return 0L;
    }

    public static Date m5853(Object obj) {
        if (C0457zc.m10555() >= 0) {
            return m5839((C0306ku) obj);
        }
        return null;
    }

    public static int m5854(Object obj) {
        if (m5846() >= 0) {
            return m5844((C0306ku) obj);
        }
        return 0;
    }

    public static boolean m5855(Object obj) {
        if (C0459zf.m11053() > 0) {
            return m5834((C0306ku) obj);
        }
        return false;
    }

    public static long m5856(Object obj) {
        if (C0460zg.m11293() >= 0) {
            return m5843((C0306ku) obj);
        }
        return 0L;
    }

    public static Date m5857(Object obj) {
        if (C0459zf.m11053() >= 0) {
            return m5850((C0306ku) obj);
        }
        return null;
    }

    public static boolean m5858(Object obj) {
        if (abe.m2321() <= 0) {
            return m5838((C0286ka) obj);
        }
        return false;
    }

    public static long m5859(Object obj) {
        if (C0453yj.m9966() > 0) {
            return m5845((C0306ku) obj);
        }
        return 0L;
    }

    public static Date m5860(Object obj) {
        if (C0448yd.m9015() < 0) {
            return m5849((C0306ku) obj);
        }
        return null;
    }

    public static long m5861(Object obj) {
        if (C0460zg.m11293() > 0) {
            return m5833((C0306ku) obj);
        }
        return 0L;
    }

    public static C0305kt m5862(Object obj) {
        if (C0460zg.m11293() > 0) {
            return m5842((C0306ku) obj);
        }
        return null;
    }

    public static long m5863(Object obj) {
        if (C0456zb.m10484() < 0) {
            return m5840((C0306ku) obj);
        }
        return 0L;
    }

    public static String m5864(Object obj) {
        if (C0457zc.m10718() < 0) {
            return m5848((C0306ku) obj);
        }
        return null;
    }

    public static C0290ke m5865(Object obj) {
        if (C0453yj.m10032() > 0) {
            return m5841((C0306ku) obj);
        }
        return null;
    }

    public static C0286ka m5866(Object obj) {
        if (C0459zf.m11053() > 0) {
            return m5851((C0306ku) obj);
        }
        return null;
    }

    public static String m5867(Object obj) {
        if (abd.m2021() > 0) {
            return m5836((C0306ku) obj);
        }
        return null;
    }

    public static String m5868(Object obj) {
        if (m5846() >= 0) {
            return m5835((C0306ku) obj);
        }
        return null;
    }

    public C0305kt m976dG() {
        C0305kt c0305ktM9667 = C0452yh.m9667(this);
        return (abf.m2471(c0305ktM9667) == null || !C0460zg.m11353(abd.m2085(C0452yh.m9713(this)))) ? c0305ktM9667 : new C0305kt(null, null);
    }
}
