package com.google.android.material.card2;

import java.util.List;

public final class C0321li implements InterfaceC0276jr {

    private final InterfaceC0259ja f1001qb;

    public C0321li(InterfaceC0259ja interfaceC0259ja) {
        this.f1001qb = interfaceC0259ja;
    }

    private String m1044b(List<C0257iz> list) {
        StringBuilder sb = new StringBuilder();
        int iM6094 = m6094(list);
        for (int i = 0; i < iM6094; i++) {
            if (i > 0) {
                C0460zg.m11407(sb, C0456zb.m10381());
            }
            C0257iz c0257iz = (C0257iz) gggy.m4400(list, i);
            C0460zg.m11407(abe.m2346(C0460zg.m11407(sb, C0458ze.m10830(c0257iz)), '='), abd.m2193(c0257iz));
        }
        return abc.m1925(sb);
    }

    public static List m6091(Object obj, Object obj2) {
        if (C0456zb.m10326() <= 0) {
            return C0598.m11887(obj, obj2);
        }
        return null;
    }

    public static String m6092() {
        if (C0449ye.m9220() < 0) {
            return C0598.m11862();
        }
        return null;
    }

    public static String m6093() {
        if (adds.m2755() >= 0) {
            return C0598.m11878();
        }
        return null;
    }

    public static int m6094(Object obj) {
        if (C0458ze.m10932() > 0) {
            return C0598.m11824(obj);
        }
        return 0;
    }

    public static InterfaceC0259ja m6095(Object obj) {
        if (C0453yj.m10013() > 0) {
            return ((C0321li) obj).f1001qb;
        }
        return null;
    }

    public static C0286ka m6096(Object obj) {
        if (abf.m2510() <= 0) {
            return C0598.m11789(obj);
        }
        return null;
    }

    public static String m6097(Object obj, Object obj2) {
        if (abf.m2510() <= 0) {
            return ((C0321li) obj).m1044b((List) obj2);
        }
        return null;
    }

    public static String m6098(Object obj, Object obj2) {
        if (gggy.m4365() >= 0) {
            return m6097((C0321li) obj, (List) obj2);
        }
        return null;
    }

    public static InterfaceC0259ja m6099(Object obj) {
        if (abe.m2321() <= 0) {
            return m6095((C0321li) obj);
        }
        return null;
    }

    @Override
    public C0290ke mo782a(InterfaceC0277js interfaceC0277js) {
        boolean z = false;
        C0286ka c0286kaM6096 = m6096(interfaceC0277js);
        C0287kb c0287kbM2428 = abf.m2428(c0286kaM6096);
        AbstractC0288kc abstractC0288kcM9039 = C0448yd.m9039(c0286kaM6096);
        if (abstractC0288kcM9039 != null) {
            C0278jt c0278jtM11076 = C0459zf.m11076(abstractC0288kcM9039);
            if (c0278jtM11076 != null) {
                C0446yb.m8510(c0287kbM2428, m6092(), abe.m2204(c0278jtM11076));
            }
            long jM4334 = gggy.m4334(abstractC0288kcM9039);
            if (jM4334 != -1) {
                C0446yb.m8510(c0287kbM2428, abf.m2534(), C0450yf.m9420(jM4334));
                abc.m1896(c0287kbM2428, gggy.m4488());
            } else {
                C0446yb.m8510(c0287kbM2428, gggy.m4488(), abc.m1898());
                abc.m1896(c0287kbM2428, abf.m2534());
            }
        }
        if (C0453yj.m9986(c0286kaM6096, abf.m2536()) == null) {
            C0446yb.m8510(c0287kbM2428, abf.m2536(), C0450yf.m9405(C0448yd.m9070(c0286kaM6096), false));
        }
        if (C0453yj.m9986(c0286kaM6096, m6093()) == null) {
            C0446yb.m8510(c0287kbM2428, m6093(), C0445ya.m8286());
        }
        if (C0453yj.m9986(c0286kaM6096, adds.m2715()) == null && C0453yj.m9986(c0286kaM6096, C0446yb.m8502()) == null) {
            z = true;
            C0446yb.m8510(c0287kbM2428, adds.m2715(), C0448yd.m8978());
        }
        List listM6091 = m6091(C0461zs.m11628(this), C0448yd.m9070(c0286kaM6096));
        if (!C0452yh.m9618(listM6091)) {
            C0446yb.m8510(c0287kbM2428, adds.m2825(), C0456zb.m10348(this, listM6091));
        }
        if (C0453yj.m9986(c0286kaM6096, C0461zs.m11592()) == null) {
            C0446yb.m8510(c0287kbM2428, C0461zs.m11592(), C0460zg.m11291());
        }
        C0290ke c0290keM2727 = adds.m2727(interfaceC0277js, C0448yd.m8952(c0287kbM2428));
        C0450yf.m9332(C0461zs.m11628(this), C0448yd.m9070(c0286kaM6096), C0447yc.m8818(c0290keM2727));
        C0291kf c0291kfM9535 = C0450yf.m9535(abe.m2342(c0290keM2727), c0286kaM6096);
        if (z && C0457zc.m10547(C0448yd.m8978(), C0457zc.m10588(c0290keM2727, abf.m2503())) && abe.m2394(c0290keM2727)) {
            C0416ov c0416ov = new C0416ov(C0455za.m10183(C0453yj.m9985(c0290keM2727)));
            C0455za.m10039(c0291kfM9535, C0456zb.m10427(C0459zf.m11161(C0459zf.m11161(C0445ya.m8205(C0447yc.m8818(c0290keM2727)), abf.m2503()), abf.m2534())));
            C0446yb.m8485(c0291kfM9535, new C0330lr(C0457zc.m10588(c0290keM2727, m6092()), -1L, gggy.m4472(c0416ov)));
        }
        return C0458ze.m10931(c0291kfM9535);
    }
}
