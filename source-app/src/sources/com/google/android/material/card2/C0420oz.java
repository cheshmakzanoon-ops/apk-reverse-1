package com.google.android.material.card2;

import java.io.IOException;
import java.io.InputStream;

final class C0420oz implements InterfaceC0429ph {

    final InputStream f1322vA;

    final C0430pi f1323vB;

    C0420oz(C0430pi c0430pi, InputStream inputStream) {
        this.f1323vB = c0430pi;
        this.f1322vA = inputStream;
    }

    public static byte[] m7964(Object obj) {
        if (C0447yc.m8635() > 0) {
            return m7985(obj);
        }
        return null;
    }

    public static boolean m7965(Object obj) {
        if (C0453yj.m10013() > 0) {
            return m7984(obj);
        }
        return false;
    }

    public static C0425pd m7966(Object obj, int i) {
        if (C0456zb.m10326() <= 0) {
            return ((C0409oo) obj).m1341D(i);
        }
        return null;
    }

    public static int m7967() {
        if (C0456zb.m10326() < 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static int m7968(Object obj) {
        if (abe.m2308() <= 0) {
            return m7982(obj);
        }
        return 0;
    }

    public static C0425pd m7969(Object obj, int i) {
        if (C0445ya.m8222() >= 0) {
            return m7979(obj, i);
        }
        return null;
    }

    public static C0430pi m7970(Object obj) {
        if (C0458ze.m10932() >= 0) {
            return m7981(obj);
        }
        return null;
    }

    public static long m7971(Object obj) {
        if (gggy.m4269() < 0) {
            return ((C0409oo) obj).f1300oV;
        }
        return 0L;
    }

    public static int m7972(Object obj) {
        if (abe.m2308() < 0) {
            return ((C0425pd) obj).f1332ea;
        }
        return 0;
    }

    public static InputStream m7973(Object obj) {
        if (C0450yf.m9352() <= 0) {
            return m7980(obj);
        }
        return null;
    }

    public static InputStream m7974(Object obj) {
        if (C0450yf.m9352() < 0) {
            return ((C0420oz) obj).f1322vA;
        }
        return null;
    }

    public static C0430pi m7975(Object obj) {
        if (C0445ya.m8222() > 0) {
            return ((C0420oz) obj).f1323vB;
        }
        return null;
    }

    public static long m7976(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return m7983(obj);
        }
        return 0L;
    }

    public static boolean m7977(Object obj) {
        if (abf.m2510() < 0) {
            return C0418ox.m1440a((AssertionError) obj);
        }
        return false;
    }

    public static byte[] m7978(Object obj) {
        if (abf.m2510() <= 0) {
            return ((C0425pd) obj).f1334vH;
        }
        return null;
    }

    public static C0425pd m7979(Object obj, int i) {
        if (abf.m2500() > 0) {
            return m7966((C0409oo) obj, i);
        }
        return null;
    }

    public static InputStream m7980(Object obj) {
        if (C0457zc.m10555() > 0) {
            return m7974((C0420oz) obj);
        }
        return null;
    }

    public static C0430pi m7981(Object obj) {
        if (C0456zb.m10484() <= 0) {
            return m7975((C0420oz) obj);
        }
        return null;
    }

    public static int m7982(Object obj) {
        if (m7967() >= 0) {
            return m7972((C0425pd) obj);
        }
        return 0;
    }

    public static long m7983(Object obj) {
        if (C0457zc.m10555() > 0) {
            return m7971((C0409oo) obj);
        }
        return 0L;
    }

    public static boolean m7984(Object obj) {
        if (gggy.m4365() > 0) {
            return m7977((AssertionError) obj);
        }
        return false;
    }

    public static byte[] m7985(Object obj) {
        if (C0453yj.m9945() <= 0) {
            return m7978((C0425pd) obj);
        }
        return null;
    }

    @Override
    public long mo966a(C0409oo c0409oo, long j) throws IOException {
        if (j < 0) {
            throw new IllegalArgumentException(abc.m1925(C0458ze.m10777(C0460zg.m11407(new StringBuilder(), adds.m2831()), j)));
        }
        if (j == 0) {
            return 0L;
        }
        try {
            C0456zb.m10377(m7970(this));
            C0425pd c0425pdM7969 = m7969(c0409oo, 1);
            int iM10347 = C0456zb.m10347(m7973(this), m7964(c0425pdM7969), m7968(c0425pdM7969), (int) C0450yf.m9495(j, 8192 - m7968(c0425pdM7969)));
            if (iM10347 == -1) {
                return -1L;
            }
            c0425pdM7969.f1332ea = m7968(c0425pdM7969) + iM10347;
            c0409oo.f1300oV = m7976(c0409oo) + ((long) iM10347);
            return iM10347;
        } catch (AssertionError e) {
            if (m7965(e)) {
                throw new IOException(e);
            }
            throw e;
        }
    }

    @Override
    public void close() {
        abf.m2477(m7973(this));
    }

    @Override
    public C0430pi mo967dz() {
        return m7970(this);
    }

    public String toString() {
        return abc.m1925(C0460zg.m11407(abd.m2090(C0460zg.m11407(new StringBuilder(), C0461zs.m11531()), m7973(this)), C0457zc.m10722()));
    }
}
