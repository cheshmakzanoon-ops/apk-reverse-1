package com.google.android.material.card2;

import java.io.IOException;
import java.net.ProtocolException;

class C0343mc extends AbstractC0337ly {

    private long f1055qR;

    final C0335lw f1056qU;

    C0343mc(C0335lw c0335lw, long j) {
        super(c0335lw, null);
        this.f1056qU = c0335lw;
        this.f1055qR = j;
        if (m6323(this) == 0) {
            m6321(this, true, null);
        }
    }

    public static void m6321(Object obj, boolean z, Object obj2) {
        if (C0448yd.m9079() < 0) {
            m6327(obj, z, obj2);
        }
    }

    public static boolean m6322(Object obj) {
        if (abc.m1845() < 0) {
            return m6329(obj);
        }
        return false;
    }

    public static long m6323(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return m6328(obj);
        }
        return 0L;
    }

    public static void m6324(Object obj, boolean z, Object obj2) {
        if (gggy.m4269() < 0) {
            ((C0343mc) obj).m1094a(z, (IOException) obj2);
        }
    }

    public static boolean m6325(Object obj) {
        if (C0451yg.m9580() > 0) {
            return ((C0343mc) obj).f1037oL;
        }
        return false;
    }

    public static long m6326(Object obj) {
        if (C0461zs.m11510() < 0) {
            return ((C0343mc) obj).f1055qR;
        }
        return 0L;
    }

    public static void m6327(Object obj, boolean z, Object obj2) {
        if (C0453yj.m9945() < 0) {
            m6324((C0343mc) obj, z, (IOException) obj2);
        }
    }

    public static long m6328(Object obj) {
        if (C0457zc.m10555() >= 0) {
            return m6326((C0343mc) obj);
        }
        return 0L;
    }

    public static boolean m6329(Object obj) {
        if (C0453yj.m9996() <= 0) {
            return m6325((C0343mc) obj);
        }
        return false;
    }

    @Override
    public long mo966a(C0409oo c0409oo, long j) throws IOException {
        if (j < 0) {
            throw new IllegalArgumentException(abc.m1925(C0458ze.m10777(C0460zg.m11407(new StringBuilder(), adds.m2831()), j)));
        }
        if (m6322(this)) {
            throw new IllegalStateException(C0447yc.m8663());
        }
        if (m6323(this) == 0) {
            return -1L;
        }
        long jMo966a = super.mo966a(c0409oo, C0450yf.m9495(m6323(this), j));
        if (jMo966a == -1) {
            ProtocolException protocolException = new ProtocolException(C0445ya.m8367());
            m6321(this, false, protocolException);
            throw protocolException;
        }
        this.f1055qR = m6323(this) - jMo966a;
        if (m6323(this) != 0) {
            return jMo966a;
        }
        m6321(this, true, null);
        return jMo966a;
    }

    @Override
    public void close() {
        if (m6322(this)) {
            return;
        }
        if (m6323(this) != 0 && !C0448yd.m9024(this, 100, adds.m2789())) {
            m6321(this, false, null);
        }
        this.f1037oL = true;
    }
}
