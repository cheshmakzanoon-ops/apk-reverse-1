package com.google.android.material.card2;

import java.io.EOFException;
import java.io.IOException;

public final class C0335lw implements InterfaceC0324ll {

    final C0279ju f1031qC;

    final InterfaceC0410op f1033qE;

    final InterfaceC0411oq f1034qF;

    final C0319lg f1036qH;

    int f1035qG = 0;

    private long f1032qD = 262144;

    public C0335lw(C0279ju c0279ju, C0319lg c0319lg, InterfaceC0411oq interfaceC0411oq, InterfaceC0410op interfaceC0410op) {
        this.f1031qC = c0279ju;
        this.f1036qH = c0319lg;
        this.f1034qF = interfaceC0411oq;
        this.f1033qE = interfaceC0410op;
    }

    private String m1085el() {
        String strM8626 = C0447yc.m8626(C0461zs.m11541(this), abd.m2120(this));
        this.f1032qD = abd.m2120(this) - ((long) gggy.m4397(strM8626));
        return strM8626;
    }

    public static InterfaceC0410op m6191(Object obj) {
        if (C0451yg.m9580() > 0) {
            return ((C0335lw) obj).f1033qE;
        }
        return null;
    }

    public static String m6192() {
        if (C0447yc.m8635() > 0) {
            return C0598.m11862();
        }
        return null;
    }

    public static String m6193() {
        if (C0451yg.m9580() > 0) {
            return C0598.m11822();
        }
        return null;
    }

    public static C0319lg m6194(Object obj) {
        if (gggy.m4269() <= 0) {
            return ((C0335lw) obj).f1036qH;
        }
        return null;
    }

    public static int m6195(Object obj) {
        if (abc.m1845() <= 0) {
            return ((C0335lw) obj).f1035qG;
        }
        return 0;
    }

    public static String m6196(Object obj) {
        if (C0447yc.m8635() > 0) {
            return ((C0335lw) obj).m1085el();
        }
        return null;
    }

    public static long m6197(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return ((C0335lw) obj).f1032qD;
        }
        return 0L;
    }

    public static InterfaceC0411oq m6198(Object obj) {
        if (C0458ze.m10932() >= 0) {
            return ((C0335lw) obj).f1034qF;
        }
        return null;
    }

    public static long m6199(Object obj) {
        if (C0457zc.m10555() > 0) {
            return m6197((C0335lw) obj);
        }
        return 0L;
    }

    public static C0319lg m6200(Object obj) {
        if (C0460zg.m11293() > 0) {
            return m6194((C0335lw) obj);
        }
        return null;
    }

    public static int m6201(Object obj) {
        if (abf.m2500() >= 0) {
            return m6195((C0335lw) obj);
        }
        return 0;
    }

    public static InterfaceC0410op m6202(Object obj) {
        if (C0453yj.m9966() >= 0) {
            return m6191((C0335lw) obj);
        }
        return null;
    }

    public static InterfaceC0411oq m6203(Object obj) {
        if (C0445ya.m8330() > 0) {
            return m6198((C0335lw) obj);
        }
        return null;
    }

    public static String m6204(Object obj) {
        if (C0456zb.m10484() < 0) {
            return m6196((C0335lw) obj);
        }
        return null;
    }

    @Override
    public InterfaceC0428pg mo1046a(C0286ka c0286ka, long j) {
        if (C0457zc.m10547(abc.m1898(), C0453yj.m9986(c0286ka, gggy.m4488()))) {
            return abc.m1747(this);
        }
        if (j != -1) {
            return C0457zc.m10737(this, j);
        }
        throw new IllegalStateException(C0461zs.m11591());
    }

    public void m1086a(C0271jm c0271jm, String str) {
        if (C0457zc.m10636(this) != 0) {
            throw new IllegalStateException(abc.m1925(adds.m2680(C0460zg.m11407(new StringBuilder(), C0456zb.m10299()), C0457zc.m10636(this))));
        }
        gggy.m4317(gggy.m4317(C0449ye.m9188(this), str), m6193());
        int iM11431 = C0460zg.m11431(c0271jm);
        for (int i = 0; i < iM11431; i++) {
            gggy.m4317(gggy.m4317(gggy.m4317(gggy.m4317(C0449ye.m9188(this), C0446yb.m8434(c0271jm, i)), C0455za.m10252()), gggy.m4283(c0271jm, i)), m6193());
        }
        gggy.m4317(C0449ye.m9188(this), m6193());
        this.f1035qG = 1;
    }

    void m1087a(C0415ou c0415ou) {
        C0430pi c0430piM1964 = abc.m1964(c0415ou);
        C0457zc.m10608(c0415ou, abd.m2153());
        C0459zf.m11009(c0430piM1964);
        abf.m2529(c0430piM1964);
    }

    public InterfaceC0428pg m1088e(long j) {
        if (C0457zc.m10636(this) != 1) {
            throw new IllegalStateException(abc.m1925(adds.m2680(C0460zg.m11407(new StringBuilder(), C0456zb.m10299()), C0457zc.m10636(this))));
        }
        this.f1035qG = 2;
        return new C0342mb(this, j);
    }

    @Override
    public void mo1047ed() {
        C0458ze.m10814(C0449ye.m9188(this));
    }

    @Override
    public void mo1048ee() {
        C0458ze.m10814(C0449ye.m9188(this));
    }

    public InterfaceC0428pg m1089em() {
        if (C0457zc.m10636(this) != 1) {
            throw new IllegalStateException(abc.m1925(adds.m2680(C0460zg.m11407(new StringBuilder(), C0456zb.m10299()), C0457zc.m10636(this))));
        }
        this.f1035qG = 2;
        return new C0338lz(this);
    }

    public InterfaceC0429ph m1090en() {
        if (C0457zc.m10636(this) != 4) {
            throw new IllegalStateException(abc.m1925(adds.m2680(C0460zg.m11407(new StringBuilder(), C0456zb.m10299()), C0457zc.m10636(this))));
        }
        if (C0448yd.m8984(this) == null) {
            throw new IllegalStateException(C0447yc.m8798());
        }
        this.f1035qG = 5;
        C0461zs.m11544(C0448yd.m8984(this));
        return new C0344md(this);
    }

    public C0271jm m1091eo() {
        C0272jn c0272jn = new C0272jn();
        while (true) {
            String strM4352 = gggy.m4352(this);
            if (gggy.m4397(strM4352) == 0) {
                return C0456zb.m10427(c0272jn);
            }
            C0447yc.m8840(adds.m2768(), c0272jn, strM4352);
        }
    }

    public InterfaceC0429ph m1092f(long j) {
        if (C0457zc.m10636(this) != 4) {
            throw new IllegalStateException(abc.m1925(adds.m2680(C0460zg.m11407(new StringBuilder(), C0456zb.m10299()), C0457zc.m10636(this))));
        }
        this.f1035qG = 5;
        return new C0343mc(this, j);
    }

    public InterfaceC0429ph m1093f(C0273jo c0273jo) {
        if (C0457zc.m10636(this) != 4) {
            throw new IllegalStateException(abc.m1925(adds.m2680(C0460zg.m11407(new StringBuilder(), C0456zb.m10299()), C0457zc.m10636(this))));
        }
        this.f1035qG = 5;
        return new C0341ma(this, c0273jo);
    }

    @Override
    public AbstractC0292kg mo1049g(C0290ke c0290ke) {
        C0456zb.m10325(C0460zg.m11398(C0448yd.m8984(this)), gggy.m4297(C0448yd.m8984(this)));
        String strM10588 = C0457zc.m10588(c0290ke, m6192());
        if (!abe.m2394(c0290ke)) {
            return new C0330lr(strM10588, 0L, gggy.m4472(C0446yb.m8600(this, 0L)));
        }
        if (C0457zc.m10547(abc.m1898(), C0457zc.m10588(c0290ke, gggy.m4488()))) {
            return new C0330lr(strM10588, -1L, gggy.m4472(C0456zb.m10343(this, C0448yd.m9070(C0450yf.m9510(c0290ke)))));
        }
        long jM2415 = abf.m2415(c0290ke);
        return jM2415 != -1 ? new C0330lr(strM10588, jM2415, gggy.m4472(C0446yb.m8600(this, jM2415))) : new C0330lr(strM10588, -1L, gggy.m4472(C0461zs.m11555(this)));
    }

    @Override
    public void mo1050g(C0286ka c0286ka) {
        C0453yj.m9931(this, C0460zg.m11265(c0286ka), C0447yc.m8814(c0286ka, C0452yh.m9590(C0452yh.m9638(C0452yh.m9728(C0452yh.m9803(C0448yd.m8984(this)))))));
    }

    @Override
    public C0291kf mo1051m(boolean z) throws IOException {
        if (C0457zc.m10636(this) != 1 && C0457zc.m10636(this) != 3) {
            throw new IllegalStateException(abc.m1925(adds.m2680(C0460zg.m11407(new StringBuilder(), C0456zb.m10299()), C0457zc.m10636(this))));
        }
        try {
            C0333lu c0333luM10573 = C0457zc.m10573(gggy.m4352(this));
            C0291kf c0291kfM10039 = C0455za.m10039(C0457zc.m10741(C0450yf.m9567(C0450yf.m9435(new C0291kf(), C0458ze.m10974(c0333luM10573)), C0453yj.m9911(c0333luM10573)), C0447yc.m8616(c0333luM10573)), C0459zf.m11038(this));
            if (z && C0453yj.m9911(c0333luM10573) == 100) {
                return null;
            }
            this.f1035qG = 4;
            return c0291kfM10039;
        } catch (EOFException e) {
            IOException iOException = new IOException(abc.m1925(abd.m2090(C0460zg.m11407(new StringBuilder(), C0448yd.m9056()), C0448yd.m8984(this))));
            abc.m1866(iOException, e);
            throw iOException;
        }
    }
}
