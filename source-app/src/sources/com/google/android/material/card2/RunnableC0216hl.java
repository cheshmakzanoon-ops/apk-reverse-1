package com.google.android.material.card2;

import java.util.HashMap;
import java.util.Iterator;

class RunnableC0216hl implements Runnable {

    final C0214hj f430gJ;

    private final C0290ke f431gK;

    private final InterfaceC0210hf f432gL;

    private final String f433gM;

    private final String f434gN;

    RunnableC0216hl(C0214hj c0214hj, C0290ke c0290ke, InterfaceC0210hf interfaceC0210hf, String str, String str2) {
        this.f430gJ = c0214hj;
        this.f431gK = c0290ke;
        this.f432gL = interfaceC0210hf;
        this.f433gM = str;
        this.f434gN = str2;
    }

    public static C0290ke m4643(Object obj) {
        if (C0451yg.m9580() > 0) {
            return m4654(obj);
        }
        return null;
    }

    public static C0290ke m4644(Object obj) {
        if (C0449ye.m9220() < 0) {
            return ((RunnableC0216hl) obj).f431gK;
        }
        return null;
    }

    public static String m4645(Object obj) {
        if (C0460zg.m11287() > 0) {
            return ((RunnableC0216hl) obj).f434gN;
        }
        return null;
    }

    public static InterfaceC0210hf m4646(Object obj) {
        if (C0446yb.m8415() < 0) {
            return m4653(obj);
        }
        return null;
    }

    public static String m4647(Object obj) {
        if (C0459zf.m11062() > 0) {
            return ((RunnableC0216hl) obj).f433gM;
        }
        return null;
    }

    public static String m4648(Object obj) {
        if (C0459zf.m11062() > 0) {
            return m4655(obj);
        }
        return null;
    }

    public static InterfaceC0210hf m4649(Object obj) {
        if (abc.m1845() < 0) {
            return ((RunnableC0216hl) obj).f432gL;
        }
        return null;
    }

    public static String m4650(Object obj) {
        if (C0461zs.m11510() < 0) {
            return m4652(obj);
        }
        return null;
    }

    public static Object m4651(Object obj) {
        if (C0448yd.m9079() <= 0) {
            return C0598.m11882(obj);
        }
        return null;
    }

    public static String m4652(Object obj) {
        if (abd.m2166() < 0) {
            return m4647((RunnableC0216hl) obj);
        }
        return null;
    }

    public static InterfaceC0210hf m4653(Object obj) {
        if (abd.m2166() < 0) {
            return m4649((RunnableC0216hl) obj);
        }
        return null;
    }

    public static C0290ke m4654(Object obj) {
        if (abe.m2321() < 0) {
            return m4644((RunnableC0216hl) obj);
        }
        return null;
    }

    public static String m4655(Object obj) {
        if (C0448yd.m9074() <= 0) {
            return m4645((RunnableC0216hl) obj);
        }
        return null;
    }

    @Override
    public void run() {
        C0271jm c0271jmM8818 = C0447yc.m8818(m4643(this));
        HashMap map = new HashMap();
        Iterator itM9939 = C0453yj.m9939(C0452yh.m9716(c0271jmM8818));
        while (C0455za.m10104(itM9939)) {
            String str = (String) m4651(itM9939);
            C0446yb.m8478(map, str, C0460zg.m11320(c0271jmM8818, str) != null ? C0460zg.m11320(c0271jmM8818, str) : C0448yd.m8883());
        }
        C0460zg.m11341(m4646(this), m4650(this), m4648(this), map);
    }
}
