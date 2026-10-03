package com.google.android.material.card2;

import java.io.IOException;

class C0344md extends AbstractC0337ly {

    private boolean f1057qV;

    final C0335lw f1058qW;

    C0344md(C0335lw c0335lw) {
        super(c0335lw, null);
        this.f1058qW = c0335lw;
    }

    public static boolean m6330(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return ((C0344md) obj).f1037oL;
        }
        return false;
    }

    public static void m6331(Object obj, boolean z, Object obj2) {
        if (abe.m2308() < 0) {
            m6339(obj, z, obj2);
        }
    }

    public static void m6332(Object obj, boolean z, Object obj2) {
        if (C0451yg.m9580() >= 0) {
            ((C0344md) obj).m1094a(z, (IOException) obj2);
        }
    }

    public static boolean m6333(Object obj) {
        if (C0450yf.m9352() < 0) {
            return m6337(obj);
        }
        return false;
    }

    public static boolean m6334(Object obj) {
        if (C0457zc.m10735() < 0) {
            return ((C0344md) obj).f1057qV;
        }
        return false;
    }

    public static int m6335() {
        if (C0449ye.m9220() < 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static boolean m6336(Object obj) {
        if (abc.m1845() <= 0) {
            return m6338(obj);
        }
        return false;
    }

    public static boolean m6337(Object obj) {
        if (C0456zb.m10484() <= 0) {
            return m6334((C0344md) obj);
        }
        return false;
    }

    public static boolean m6338(Object obj) {
        if (m6335() > 0) {
            return m6330((C0344md) obj);
        }
        return false;
    }

    public static void m6339(Object obj, boolean z, Object obj2) {
        if (C0457zc.m10555() >= 0) {
            m6332((C0344md) obj, z, (IOException) obj2);
        }
    }

    @Override
    public long mo966a(C0409oo c0409oo, long j) throws IOException {
        if (j < 0) {
            throw new IllegalArgumentException(abc.m1925(C0458ze.m10777(C0460zg.m11407(new StringBuilder(), adds.m2831()), j)));
        }
        if (m6336(this)) {
            throw new IllegalStateException(C0447yc.m8663());
        }
        if (m6333(this)) {
            return -1L;
        }
        long jMo966a = super.mo966a(c0409oo, j);
        if (jMo966a != -1) {
            return jMo966a;
        }
        this.f1057qV = true;
        m6331(this, true, null);
        return -1L;
    }

    @Override
    public void close() {
        if (m6336(this)) {
            return;
        }
        if (!m6333(this)) {
            m6331(this, false, null);
        }
        this.f1037oL = true;
    }
}
