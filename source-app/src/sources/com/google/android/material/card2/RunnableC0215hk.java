package com.google.android.material.card2;

import java.io.IOException;

class RunnableC0215hk implements Runnable {

    final C0214hj f426gF;

    private final InterfaceC0210hf f427gG;

    private final String f428gH;

    private final IOException f429gI;

    RunnableC0215hk(C0214hj c0214hj, InterfaceC0210hf interfaceC0210hf, String str, IOException iOException) {
        this.f426gF = c0214hj;
        this.f427gG = interfaceC0210hf;
        this.f428gH = str;
        this.f429gI = iOException;
    }

    public static String m4634(Object obj) {
        if (C0453yj.m10013() >= 0) {
            return m4641(obj);
        }
        return null;
    }

    public static IOException m4635(Object obj) {
        if (gggy.m4269() <= 0) {
            return m4640(obj);
        }
        return null;
    }

    public static IOException m4636(Object obj) {
        if (C0450yf.m9352() < 0) {
            return ((RunnableC0215hk) obj).f429gI;
        }
        return null;
    }

    public static InterfaceC0210hf m4637(Object obj) {
        if (C0457zc.m10735() < 0) {
            return ((RunnableC0215hk) obj).f427gG;
        }
        return null;
    }

    public static InterfaceC0210hf m4638(Object obj) {
        if (adds.m2755() > 0) {
            return m4642(obj);
        }
        return null;
    }

    public static String m4639(Object obj) {
        if (abe.m2308() < 0) {
            return ((RunnableC0215hk) obj).f428gH;
        }
        return null;
    }

    public static IOException m4640(Object obj) {
        if (C0457zc.m10718() <= 0) {
            return m4636((RunnableC0215hk) obj);
        }
        return null;
    }

    public static String m4641(Object obj) {
        if (C0448yd.m9074() < 0) {
            return m4639((RunnableC0215hk) obj);
        }
        return null;
    }

    public static InterfaceC0210hf m4642(Object obj) {
        if (C0447yc.m8786() > 0) {
            return m4637((RunnableC0215hk) obj);
        }
        return null;
    }

    @Override
    public void run() {
        C0460zg.m11359(m4638(this), m4634(this), C0460zg.m11243(m4635(this)));
    }
}
