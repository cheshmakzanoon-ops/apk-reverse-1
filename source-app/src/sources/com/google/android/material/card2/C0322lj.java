package com.google.android.material.card2;

import java.net.ProtocolException;

public final class C0322lj implements InterfaceC0276jr {

    private final boolean f1002qc;

    public C0322lj(boolean z) {
        this.f1002qc = z;
    }

    public static String m6100() {
        if (C0460zg.m11287() >= 0) {
            return C0598.m11878();
        }
        return null;
    }

    public static void m6101(Object obj, Object obj2) {
        if (abf.m2510() < 0) {
            C0598.m11873(obj, obj2);
        }
    }

    public static boolean m6102(Object obj) {
        if (abe.m2308() < 0) {
            return C0598.m11870(obj);
        }
        return false;
    }

    public static AbstractC0292kg m6103() {
        if (C0446yb.m8415() <= 0) {
            return C0598.m11902();
        }
        return null;
    }

    public static void m6104(Object obj) {
        if (abd.m2162() > 0) {
            ((InterfaceC0410op) obj).close();
        }
    }

    public static boolean m6105(Object obj) {
        if (gggy.m4269() < 0) {
            return ((C0322lj) obj).f1002qc;
        }
        return false;
    }

    public static C0286ka m6106(Object obj) {
        if (abc.m1845() < 0) {
            return C0598.m11865(obj);
        }
        return null;
    }

    public static long m6107(Object obj) {
        if (adds.m2755() > 0) {
            return ((C0323lk) obj).f1003qd;
        }
        return 0L;
    }

    public static void m6108(Object obj) {
        if (abe.m2308() <= 0) {
            C0598.m11884(obj);
        }
    }

    public static InterfaceC0245in m6109(Object obj) {
        if (C0446yb.m8415() < 0) {
            return C0598.m11863(obj);
        }
        return null;
    }

    public static boolean m6110(Object obj) {
        if (C0459zf.m11053() >= 0) {
            return m6105((C0322lj) obj);
        }
        return false;
    }

    public static void m6111(Object obj) {
        if (C0460zg.m11293() > 0) {
            m6104((InterfaceC0410op) obj);
        }
    }

    public static long m6112(Object obj) {
        if (C0453yj.m9966() >= 0) {
            return m6107((C0323lk) obj);
        }
        return 0L;
    }

    @Override
    public C0290ke mo782a(InterfaceC0277js interfaceC0277js) throws ProtocolException {
        C0291kf c0291kfM1802;
        C0291kf c0291kfM1803 = null;
        C0329lq c0329lq = (C0329lq) interfaceC0277js;
        InterfaceC0324ll interfaceC0324llM2606 = abf.m2606(c0329lq);
        C0319lg c0319lgM10049 = C0455za.m10049(c0329lq);
        C0314lb c0314lb = (C0314lb) gggy.m4436(c0329lq);
        C0286ka c0286kaM6106 = m6106(c0329lq);
        long jM10382 = C0456zb.m10382();
        C0452yh.m9655(C0461zs.m11508(c0329lq), m6109(c0329lq));
        C0460zg.m11349(interfaceC0324llM2606, c0286kaM6106);
        C0457zc.m10733(C0461zs.m11508(c0329lq), m6109(c0329lq), c0286kaM6106);
        if (!m6102(C0456zb.m10517(c0286kaM6106)) || C0448yd.m9039(c0286kaM6106) == null) {
            c0291kfM1802 = null;
        } else {
            if (C0457zc.m10547(C0445ya.m8384(), C0453yj.m9986(c0286kaM6106, gggy.m4373()))) {
                m6108(interfaceC0324llM2606);
                m6101(C0461zs.m11508(c0329lq), m6109(c0329lq));
                c0291kfM1803 = abc.m1802(interfaceC0324llM2606, true);
            }
            if (c0291kfM1803 == null) {
                C0447yc.m8784(C0461zs.m11508(c0329lq), m6109(c0329lq));
                C0323lk c0323lk = new C0323lk(abe.m2374(interfaceC0324llM2606, c0286kaM6106, gggy.m4334(C0448yd.m9039(c0286kaM6106))));
                InterfaceC0410op interfaceC0410opM10929 = C0458ze.m10929(c0323lk);
                C0455za.m10099(C0448yd.m9039(c0286kaM6106), interfaceC0410opM10929);
                abd.m1994(interfaceC0410opM10929);
                abe.m2291(C0461zs.m11508(c0329lq), m6109(c0329lq), C0455za.m10053(c0323lk));
                c0291kfM1802 = c0291kfM1803;
            } else if (C0459zf.m11096(c0314lb)) {
                c0291kfM1802 = c0291kfM1803;
            } else {
                C0461zs.m11544(c0319lgM10049);
                c0291kfM1802 = c0291kfM1803;
            }
        }
        C0450yf.m9524(interfaceC0324llM2606);
        if (c0291kfM1802 == null) {
            m6101(C0461zs.m11508(c0329lq), m6109(c0329lq));
            c0291kfM1802 = abc.m1802(interfaceC0324llM2606, false);
        }
        C0290ke c0290keM10931 = C0458ze.m10931(abe.m2235(adds.m2734(C0459zf.m10996(C0450yf.m9535(c0291kfM1802, c0286kaM6106), C0458ze.m10883(C0452yh.m9803(c0319lgM10049))), jM10382), C0456zb.m10382()));
        abe.m2355(C0461zs.m11508(c0329lq), m6109(c0329lq), c0290keM10931);
        int iM9549 = C0450yf.m9549(c0290keM10931);
        C0290ke c0290keM10932 = (C0455za.m10182(this) && iM9549 == 101) ? C0458ze.m10931(C0446yb.m8485(abe.m2342(c0290keM10931), m6103())) : C0458ze.m10931(C0446yb.m8485(abe.m2342(c0290keM10931), C0455za.m10128(interfaceC0324llM2606, c0290keM10931)));
        if (C0457zc.m10547(abf.m2592(), C0453yj.m9986(C0450yf.m9510(c0290keM10932), m6100())) || C0457zc.m10547(abf.m2592(), C0457zc.m10588(c0290keM10932, m6100()))) {
            C0461zs.m11544(c0319lgM10049);
        }
        if ((iM9549 == 204 || iM9549 == 205) && C0460zg.m11220(C0453yj.m9985(c0290keM10932)) > 0) {
            throw new ProtocolException(abc.m1925(C0458ze.m10777(C0460zg.m11407(adds.m2680(C0460zg.m11407(new StringBuilder(), abd.m2091()), iM9549), adds.m2769()), C0460zg.m11220(C0453yj.m9985(c0290keM10932)))));
        }
        return c0290keM10932;
    }
}
