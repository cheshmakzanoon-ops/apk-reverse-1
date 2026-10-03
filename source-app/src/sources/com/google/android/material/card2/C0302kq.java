package com.google.android.material.card2;

import java.io.IOException;

public final class C0302kq implements InterfaceC0276jr {

    final InterfaceC0310ky f906oo;

    public C0302kq(InterfaceC0310ky interfaceC0310ky) {
        this.f906oo = interfaceC0310ky;
    }

    static boolean m962W(String str) {
        return (C0457zc.m10547(m5799(), str) || C0457zc.m10547(C0445ya.m8286(), str) || C0457zc.m10547(C0457zc.m10629(), str) || C0457zc.m10547(C0456zb.m10487(), str) || C0457zc.m10547(C0448yd.m9013(), str) || C0457zc.m10547(C0447yc.m8669(), str) || C0457zc.m10547(gggy.m4488(), str) || C0457zc.m10547(C0455za.m10116(), str)) ? false : true;
    }

    private static C0271jm m963a(C0271jm c0271jm, C0271jm c0271jm2) {
        C0272jn c0272jn = new C0272jn();
        int iM11431 = C0460zg.m11431(c0271jm);
        for (int i = 0; i < iM11431; i++) {
            String strM8434 = C0446yb.m8434(c0271jm, i);
            String strM4283 = gggy.m4283(c0271jm, i);
            if ((!C0457zc.m10547(C0458ze.m10785(), strM8434) || !C0458ze.m10811(strM4283, C0453yj.m10017())) && (!C0449ye.m9100(strM8434) || C0460zg.m11320(c0271jm2, strM8434) == null)) {
                C0452yh.m9691(adds.m2768(), c0272jn, strM8434, strM4283);
            }
        }
        int iM11432 = C0460zg.m11431(c0271jm2);
        for (int i2 = 0; i2 < iM11432; i2++) {
            String strM8435 = C0446yb.m8434(c0271jm2, i2);
            if (!C0457zc.m10547(abf.m2534(), strM8435) && C0449ye.m9100(strM8435)) {
                C0452yh.m9691(adds.m2768(), c0272jn, strM8435, gggy.m4283(c0271jm2, i2));
            }
        }
        return C0456zb.m10427(c0272jn);
    }

    private C0290ke m964a(InterfaceC0304ks interfaceC0304ks, C0290ke c0290ke) {
        InterfaceC0428pg interfaceC0428pgM4371;
        if (interfaceC0304ks == null || (interfaceC0428pgM4371 = gggy.m4371(interfaceC0304ks)) == null) {
            return c0290ke;
        }
        return C0458ze.m10931(C0446yb.m8485(abe.m2342(c0290ke), new C0330lr(C0457zc.m10588(c0290ke, m5794()), C0460zg.m11220(C0453yj.m9985(c0290ke)), gggy.m4472(new C0303kr(this, C0455za.m10183(C0453yj.m9985(c0290ke)), interfaceC0304ks, C0458ze.m10929(interfaceC0428pgM4371))))));
    }

    private static C0290ke m965e(C0290ke c0290ke) {
        return (c0290ke == null || C0453yj.m9985(c0290ke) == null) ? c0290ke : C0458ze.m10931(C0446yb.m8485(abe.m2342(c0290ke), null));
    }

    public static String m5794() {
        if (C0451yg.m9580() >= 0) {
            return C0598.m11862();
        }
        return null;
    }

    public static C0271jm m5795(Object obj, Object obj2) {
        if (C0460zg.m11287() >= 0) {
            return m963a((C0271jm) obj, (C0271jm) obj2);
        }
        return null;
    }

    public static AbstractC0292kg m5796() {
        if (C0456zb.m10326() <= 0) {
            return C0598.m11902();
        }
        return null;
    }

    public static boolean m5797(Object obj) {
        if (C0448yd.m9079() < 0) {
            return C0598.m11880(obj);
        }
        return false;
    }

    public static C0290ke m5798(Object obj) {
        if (C0460zg.m11287() > 0) {
            return m965e((C0290ke) obj);
        }
        return null;
    }

    public static String m5799() {
        if (C0458ze.m10932() > 0) {
            return C0598.m11878();
        }
        return null;
    }

    public static InterfaceC0310ky m5800(Object obj) {
        if (adds.m2755() > 0) {
            return ((C0302kq) obj).f906oo;
        }
        return null;
    }

    public static C0290ke m5801(Object obj, Object obj2, Object obj3) {
        if (C0461zs.m11510() < 0) {
            return ((C0302kq) obj).m964a((InterfaceC0304ks) obj2, (C0290ke) obj3);
        }
        return null;
    }

    public static C0286ka m5802(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return C0598.m11789(obj);
        }
        return null;
    }

    public static boolean m5803(Object obj) {
        if (C0450yf.m9352() <= 0) {
            return m962W((String) obj);
        }
        return false;
    }

    public static boolean m5804(Object obj) {
        if (C0460zg.m11293() >= 0) {
            return m5803((String) obj);
        }
        return false;
    }

    public static C0290ke m5805(Object obj, Object obj2, Object obj3) {
        if (abe.m2321() < 0) {
            return m5801((C0302kq) obj, (InterfaceC0304ks) obj2, (C0290ke) obj3);
        }
        return null;
    }

    public static InterfaceC0310ky m5806(Object obj) {
        if (C0453yj.m10032() >= 0) {
            return m5800((C0302kq) obj);
        }
        return null;
    }

    public static C0290ke m5807(Object obj) {
        if (C0445ya.m8330() > 0) {
            return m5798((C0290ke) obj);
        }
        return null;
    }

    public static C0271jm m5808(Object obj, Object obj2) {
        if (C0447yc.m8786() > 0) {
            return m5795((C0271jm) obj, (C0271jm) obj2);
        }
        return null;
    }

    @Override
    public C0290ke mo782a(InterfaceC0277js interfaceC0277js) {
        C0290ke c0290keM2681 = C0448yd.m8905(this) != null ? adds.m2681(C0448yd.m8905(this), m5802(interfaceC0277js)) : null;
        C0305kt c0305ktM8725 = C0447yc.m8725(new C0306ku(C0456zb.m10382(), m5802(interfaceC0277js), c0290keM2681));
        C0286ka c0286kaM2471 = abf.m2471(c0305ktM8725);
        C0290ke c0290keM9294 = C0449ye.m9294(c0305ktM8725);
        if (C0448yd.m8905(this) != null) {
            C0446yb.m8602(C0448yd.m8905(this), c0305ktM8725);
        }
        if (c0290keM2681 != null && c0290keM9294 == null) {
            C0455za.m10070(C0453yj.m9985(c0290keM2681));
        }
        if (c0286kaM2471 == null && c0290keM9294 == null) {
            return C0458ze.m10931(abe.m2235(adds.m2734(C0446yb.m8485(C0457zc.m10741(C0450yf.m9567(C0450yf.m9435(C0450yf.m9535(new C0291kf(), m5802(interfaceC0277js)), C0459zf.m11198()), 504), adds.m2793()), m5796()), -1L), C0456zb.m10382()));
        }
        if (c0286kaM2471 == null) {
            return C0458ze.m10931(adds.m2817(abe.m2342(c0290keM9294), C0450yf.m9547(c0290keM9294)));
        }
        try {
            C0290ke c0290keM2727 = adds.m2727(interfaceC0277js, c0286kaM2471);
            if (c0290keM2727 == null && c0290keM2681 != null) {
                C0455za.m10070(C0453yj.m9985(c0290keM2681));
            }
            if (c0290keM9294 != null) {
                if (C0450yf.m9549(c0290keM2727) == 304) {
                    C0290ke c0290keM10931 = C0458ze.m10931(C0457zc.m10668(adds.m2817(abe.m2235(adds.m2734(C0455za.m10039(abe.m2342(c0290keM9294), C0461zs.m11639(C0447yc.m8818(c0290keM9294), C0447yc.m8818(c0290keM2727))), C0445ya.m8200(c0290keM2727)), C0450yf.m9500(c0290keM2727)), C0450yf.m9547(c0290keM9294)), C0450yf.m9547(c0290keM2727)));
                    C0450yf.m9484(C0453yj.m9985(c0290keM2727));
                    abf.m2626(C0448yd.m8905(this));
                    C0452yh.m9694(C0448yd.m8905(this), c0290keM9294, c0290keM10931);
                    return c0290keM10931;
                }
                C0455za.m10070(C0453yj.m9985(c0290keM9294));
            }
            C0290ke c0290keM10932 = C0458ze.m10931(C0457zc.m10668(adds.m2817(abe.m2342(c0290keM2727), C0450yf.m9547(c0290keM9294)), C0450yf.m9547(c0290keM2727)));
            if (C0448yd.m8905(this) == null) {
                return c0290keM10932;
            }
            if (abe.m2394(c0290keM10932) && C0446yb.m8539(c0290keM10932, c0286kaM2471)) {
                return C0452yh.m9604(this, abc.m1870(C0448yd.m8905(this), c0290keM10932), c0290keM10932);
            }
            if (!m5797(C0456zb.m10517(c0286kaM2471))) {
                return c0290keM10932;
            }
            try {
                abd.m2108(C0448yd.m8905(this), c0286kaM2471);
                return c0290keM10932;
            } catch (IOException e) {
                return c0290keM10932;
            }
        } catch (Throwable th) {
            if (c0290keM2681 != null) {
                C0455za.m10070(C0453yj.m9985(c0290keM2681));
            }
            throw th;
        }
    }
}
