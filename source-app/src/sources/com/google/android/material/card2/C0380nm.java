package com.google.android.material.card2;

import java.util.concurrent.CountDownLatch;

final class C0380nm {

    private final CountDownLatch f1232tU = new CountDownLatch(1);

    private long f1234tW = -1;

    private long f1233tV = -1;

    C0380nm() {
    }

    public static long m7398(Object obj) {
        if (gggy.m4269() <= 0) {
            return m7404(obj);
        }
        return 0L;
    }

    public static CountDownLatch m7399(Object obj) {
        if (C0457zc.m10735() < 0) {
            return m7405(obj);
        }
        return null;
    }

    public static CountDownLatch m7400(Object obj) {
        if (abe.m2308() <= 0) {
            return ((C0380nm) obj).f1232tU;
        }
        return null;
    }

    public static long m7401(Object obj) {
        if (C0453yj.m10013() > 0) {
            return m7406(obj);
        }
        return 0L;
    }

    public static long m7402(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return ((C0380nm) obj).f1234tW;
        }
        return 0L;
    }

    public static long m7403(Object obj) {
        if (abd.m2162() > 0) {
            return ((C0380nm) obj).f1233tV;
        }
        return 0L;
    }

    public static long m7404(Object obj) {
        if (gggy.m4365() > 0) {
            return m7402((C0380nm) obj);
        }
        return 0L;
    }

    public static CountDownLatch m7405(Object obj) {
        if (C0456zb.m10484() < 0) {
            return m7400((C0380nm) obj);
        }
        return null;
    }

    public static long m7406(Object obj) {
        if (abd.m2166() <= 0) {
            return m7403((C0380nm) obj);
        }
        return 0L;
    }

    void m1252eX() {
        if (m7401(this) != -1 || m7398(this) == -1) {
            throw new IllegalStateException();
        }
        this.f1233tV = m7398(this) - 1;
        gggy.m4437(m7399(this));
    }

    void m1253eY() {
        if (m7401(this) != -1 || m7398(this) == -1) {
            throw new IllegalStateException();
        }
        this.f1233tV = abc.m1830();
        gggy.m4437(m7399(this));
    }

    void m1254eZ() {
        if (m7398(this) != -1) {
            throw new IllegalStateException();
        }
        this.f1234tW = abc.m1830();
    }
}
