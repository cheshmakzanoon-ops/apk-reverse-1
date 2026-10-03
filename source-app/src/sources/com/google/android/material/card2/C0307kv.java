package com.google.android.material.card2;

import java.io.Closeable;
import java.io.File;
import java.io.Flushable;
import java.util.LinkedHashMap;
import java.util.concurrent.Executor;
import java.util.regex.Pattern;

public final class C0307kv implements Closeable, Flushable {

    static final boolean f926oI;

    static final Pattern f927oJ;

    private final Runnable f928oK;

    boolean f929oL;

    private final Executor f930oM;

    final InterfaceC0385nr f931oN;

    boolean f932oO;

    InterfaceC0410op f933oP;

    final LinkedHashMap<String, C0309kx> f934oQ;

    private long f935oR;

    boolean f936oS;

    private long f937oT;

    int f938oU;

    private long f939oV;

    final int f940oW;

    static {
        f926oI = !C0460zg.m11342(C0307kv.class);
        f927oJ = C0461zs.m11638(abc.m1958());
    }

    private void m977dH() {
        synchronized (this) {
            if (C0453yj.m9944(this)) {
                throw new IllegalStateException(adds.m2745());
            }
        }
    }

    public static long m5869(Object obj) {
        if (abe.m2308() <= 0) {
            return ((C0307kv) obj).f939oV;
        }
        return 0L;
    }

    public static long m5870(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return ((C0307kv) obj).f937oT;
        }
        return 0L;
    }

    public static int m5871() {
        if (C0448yd.m9079() < 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static boolean m5872(Object obj) {
        if (C0459zf.m11062() > 0) {
            return ((C0307kv) obj).f932oO;
        }
        return false;
    }

    public static C0308kw m5873(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return ((C0309kx) obj).f946pc;
        }
        return null;
    }

    public static boolean m5874(Object obj, Object obj2) {
        if (C0460zg.m11287() > 0) {
            return ((C0307kv) obj).m979a((C0309kx) obj2);
        }
        return false;
    }

    public static long m5875(Object obj) {
        if (C0461zs.m11510() < 0) {
            return ((C0307kv) obj).f935oR;
        }
        return 0L;
    }

    public static void m5876(Object obj) {
        if (C0450yf.m9352() <= 0) {
            ((C0308kw) obj).m984dL();
        }
    }

    public static boolean m5877(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return ((C0309kx) obj).f950pg;
        }
        return false;
    }

    public static boolean m5878(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return ((C0307kv) obj).f929oL;
        }
        return false;
    }

    public static boolean[] m5879(Object obj) {
        if (C0458ze.m10932() >= 0) {
            return ((C0308kw) obj).f944pa;
        }
        return null;
    }

    public static int m5880(Object obj) {
        if (C0459zf.m11062() > 0) {
            return ((C0307kv) obj).f940oW;
        }
        return 0;
    }

    public static Executor m5881(Object obj) {
        if (C0459zf.m11062() >= 0) {
            return ((C0307kv) obj).f930oM;
        }
        return null;
    }

    public static File[] m5882(Object obj) {
        if (C0459zf.m11062() >= 0) {
            return ((C0309kx) obj).f947pd;
        }
        return null;
    }

    public static long[] m5883(Object obj) {
        if (abd.m2162() > 0) {
            return ((C0309kx) obj).f949pf;
        }
        return null;
    }

    public static InterfaceC0410op m5884(Object obj) {
        if (abd.m2162() >= 0) {
            return ((C0307kv) obj).f933oP;
        }
        return null;
    }

    public static Runnable m5885(Object obj) {
        if (abe.m2308() <= 0) {
            return ((C0307kv) obj).f928oK;
        }
        return null;
    }

    public static File[] m5886(Object obj) {
        if (C0457zc.m10735() < 0) {
            return ((C0309kx) obj).f945pb;
        }
        return null;
    }

    public static InterfaceC0385nr m5887(Object obj) {
        if (C0450yf.m9352() <= 0) {
            return ((C0307kv) obj).f931oN;
        }
        return null;
    }

    public static void m5888(Object obj) {
        if (abc.m1845() <= 0) {
            ((InterfaceC0410op) obj).close();
        }
    }

    public static C0309kx m5889(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return m5903(obj);
        }
        return null;
    }

    public static C0309kx m5890(Object obj) {
        if (abe.m2308() < 0) {
            return ((C0308kw) obj).f942oY;
        }
        return null;
    }

    public static void m5891(Object obj, Object obj2) {
        if (C0457zc.m10735() <= 0) {
            ((C0309kx) obj).m985b((InterfaceC0410op) obj2);
        }
    }

    public static String m5892(Object obj) {
        if (C0459zf.m11062() >= 0) {
            return ((C0309kx) obj).f948pe;
        }
        return null;
    }

    public static String m5893() {
        if (gggy.m4269() <= 0) {
            return C0598.m11836();
        }
        return null;
    }

    public static int m5894(Object obj) {
        if (C0450yf.m9352() <= 0) {
            return ((C0307kv) obj).f938oU;
        }
        return 0;
    }

    public static void m5895(Object obj) {
        if (C0445ya.m8222() > 0) {
            ((C0307kv) obj).m982dK();
        }
    }

    public static boolean m5896(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return ((C0307kv) obj).m981dJ();
        }
        return false;
    }

    public static void m5897(Object obj) {
        if (abd.m2162() >= 0) {
            ((C0307kv) obj).m977dH();
        }
    }

    public static LinkedHashMap m5898(Object obj) {
        if (C0450yf.m9352() <= 0) {
            return ((C0307kv) obj).f934oQ;
        }
        return null;
    }

    public static Object m5899(Object obj) {
        if (C0446yb.m8415() < 0) {
            return C0598.m11882(obj);
        }
        return null;
    }

    public static void m5900(Object obj, Object obj2) {
        if (C0458ze.m10926() < 0) {
            m5891((C0309kx) obj, (InterfaceC0410op) obj2);
        }
    }

    public static void m5901(Object obj) {
        if (C0447yc.m8786() > 0) {
            m5876((C0308kw) obj);
        }
    }

    public static boolean m5902(Object obj) {
        if (C0448yd.m9015() < 0) {
            return m5878((C0307kv) obj);
        }
        return false;
    }

    public static C0309kx m5903(Object obj) {
        if (C0457zc.m10718() <= 0) {
            return m5890((C0308kw) obj);
        }
        return null;
    }

    public static Executor m5904(Object obj) {
        if (gggy.m4365() > 0) {
            return m5881((C0307kv) obj);
        }
        return null;
    }

    public static void m5905(Object obj) {
        if (m5871() >= 0) {
            m5897((C0307kv) obj);
        }
    }

    public static boolean m5906(Object obj) {
        if (abe.m2321() < 0) {
            return m5877((C0309kx) obj);
        }
        return false;
    }

    public static boolean[] m5907(Object obj) {
        if (C0458ze.m10926() <= 0) {
            return m5879((C0308kw) obj);
        }
        return null;
    }

    public static long[] m5908(Object obj) {
        if (C0448yd.m9074() <= 0) {
            return m5883((C0309kx) obj);
        }
        return null;
    }

    public static LinkedHashMap m5909(Object obj) {
        if (C0453yj.m9966() > 0) {
            return m5898((C0307kv) obj);
        }
        return null;
    }

    public static InterfaceC0410op m5910(Object obj) {
        if (gggy.m4365() >= 0) {
            return m5884((C0307kv) obj);
        }
        return null;
    }

    public static String m5911(Object obj) {
        if (abf.m2500() > 0) {
            return m5892((C0309kx) obj);
        }
        return null;
    }

    public static Runnable m5912(Object obj) {
        if (C0447yc.m8786() >= 0) {
            return m5885((C0307kv) obj);
        }
        return null;
    }

    public static InterfaceC0385nr m5913(Object obj) {
        if (C0448yd.m9074() < 0) {
            return m5887((C0307kv) obj);
        }
        return null;
    }

    public static void m5914(Object obj) {
        if (abe.m2321() <= 0) {
            m5895((C0307kv) obj);
        }
    }

    public static boolean m5915(Object obj, Object obj2) {
        if (C0457zc.m10555() >= 0) {
            return m5874((C0307kv) obj, (C0309kx) obj2);
        }
        return false;
    }

    public static long m5916(Object obj) {
        if (C0457zc.m10555() >= 0) {
            return m5869((C0307kv) obj);
        }
        return 0L;
    }

    public static int m5917(Object obj) {
        if (abd.m2166() <= 0) {
            return m5894((C0307kv) obj);
        }
        return 0;
    }

    public static long m5918(Object obj) {
        if (C0453yj.m9966() >= 0) {
            return m5875((C0307kv) obj);
        }
        return 0L;
    }

    public static long m5919(Object obj) {
        if (abf.m2500() > 0) {
            return m5870((C0307kv) obj);
        }
        return 0L;
    }

    public static File[] m5920(Object obj) {
        if (C0448yd.m9074() <= 0) {
            return m5882((C0309kx) obj);
        }
        return null;
    }

    public static boolean m5921(Object obj) {
        if (C0448yd.m9074() < 0) {
            return m5896((C0307kv) obj);
        }
        return false;
    }

    public static C0308kw m5922(Object obj) {
        if (C0447yc.m8786() > 0) {
            return m5873((C0309kx) obj);
        }
        return null;
    }

    public static boolean m5923(Object obj) {
        if (C0457zc.m10555() > 0) {
            return m5872((C0307kv) obj);
        }
        return false;
    }

    public static File[] m5924(Object obj) {
        if (abf.m2500() >= 0) {
            return m5886((C0309kx) obj);
        }
        return null;
    }

    public static int m5925(Object obj) {
        if (C0460zg.m11293() > 0) {
            return m5880((C0307kv) obj);
        }
        return 0;
    }

    public static void m5926(Object obj) {
        if (abd.m2021() >= 0) {
            m5888((InterfaceC0410op) obj);
        }
    }

    void m978a(C0308kw c0308kw, boolean z) {
        File file;
        synchronized (this) {
            C0309kx c0309kxM5889 = m5889(c0308kw);
            if (C0461zs.m11645(c0309kxM5889) != c0308kw) {
                throw new IllegalStateException();
            }
            if (!z || abc.m1812(c0309kxM5889)) {
                for (int i = 0; i < C0450yf.m9488(this); i++) {
                    file = C0457zc.m10537(c0309kxM5889)[i];
                    if (z) {
                        abd.m1982(C0447yc.m8777(this), file);
                    } else if (abf.m2449(C0447yc.m8777(this), file)) {
                        File file2 = C0446yb.m8537(c0309kxM5889)[i];
                        C0459zf.m11035(C0447yc.m8777(this), file, file2);
                        long j = C0452yh.m9722(c0309kxM5889)[i];
                        long jM4458 = gggy.m4458(C0447yc.m8777(this), file2);
                        C0452yh.m9722(c0309kxM5889)[i] = jM4458;
                        this.f939oV = (C0453yj.m9953(this) - j) + jM4458;
                    }
                }
                this.f938oU = abe.m2398(this) + 1;
                c0309kxM5889.f946pc = null;
                if (abc.m1812(c0309kxM5889) || z) {
                    c0309kxM5889.f950pg = true;
                    C0455za.m10213(gggy.m4317(C0459zf.m11068(this), adds.m2682()), 32);
                    gggy.m4317(C0459zf.m11068(this), C0449ye.m9181(c0309kxM5889));
                    C0459zf.m11042(c0309kxM5889, C0459zf.m11068(this));
                    C0455za.m10213(C0459zf.m11068(this), 10);
                    if (z) {
                        long jM9935 = C0453yj.m9935(this);
                        this.f937oT = 1 + jM9935;
                        c0309kxM5889.f951ph = jM9935;
                    }
                } else {
                    abd.m1997(abd.m2039(this), C0449ye.m9181(c0309kxM5889));
                    C0455za.m10213(gggy.m4317(C0459zf.m11068(this), m5893()), 32);
                    gggy.m4317(C0459zf.m11068(this), C0449ye.m9181(c0309kxM5889));
                    C0455za.m10213(C0459zf.m11068(this), 10);
                }
                C0458ze.m10814(C0459zf.m11068(this));
                if (C0453yj.m9953(this) <= C0449ye.m9257(this) || C0458ze.m10807(this)) {
                    C0448yd.m8946(C0458ze.m10907(this), C0455za.m10111(this));
                }
            } else {
                for (int i2 = 0; i2 < C0450yf.m9488(this); i2++) {
                    if (!C0455za.m10220(c0308kw)[i2]) {
                        abc.m1753(c0308kw);
                        throw new IllegalStateException(abc.m1925(adds.m2680(C0460zg.m11407(new StringBuilder(), adds.m2719()), i2)));
                    }
                    if (!abf.m2449(C0447yc.m8777(this), C0457zc.m10537(c0309kxM5889)[i2])) {
                        abc.m1753(c0308kw);
                    }
                }
                while (i < C0450yf.m9488(this)) {
                    file = C0457zc.m10537(c0309kxM5889)[i];
                    if (z) {
                        abd.m1982(C0447yc.m8777(this), file);
                    } else if (abf.m2449(C0447yc.m8777(this), file)) {
                        File file3 = C0446yb.m8537(c0309kxM5889)[i];
                        C0459zf.m11035(C0447yc.m8777(this), file, file3);
                        long j2 = C0452yh.m9722(c0309kxM5889)[i];
                        long jM4459 = gggy.m4458(C0447yc.m8777(this), file3);
                        C0452yh.m9722(c0309kxM5889)[i] = jM4459;
                        this.f939oV = (C0453yj.m9953(this) - j2) + jM4459;
                    }
                }
                this.f938oU = abe.m2398(this) + 1;
                c0309kxM5889.f946pc = null;
                if (abc.m1812(c0309kxM5889) || z) {
                    c0309kxM5889.f950pg = true;
                    C0455za.m10213(gggy.m4317(C0459zf.m11068(this), adds.m2682()), 32);
                    gggy.m4317(C0459zf.m11068(this), C0449ye.m9181(c0309kxM5889));
                    C0459zf.m11042(c0309kxM5889, C0459zf.m11068(this));
                    C0455za.m10213(C0459zf.m11068(this), 10);
                    if (z) {
                        long jM9936 = C0453yj.m9935(this);
                        this.f937oT = 1 + jM9936;
                        c0309kxM5889.f951ph = jM9936;
                    }
                } else {
                    abd.m1997(abd.m2039(this), C0449ye.m9181(c0309kxM5889));
                    C0455za.m10213(gggy.m4317(C0459zf.m11068(this), m5893()), 32);
                    gggy.m4317(C0459zf.m11068(this), C0449ye.m9181(c0309kxM5889));
                    C0455za.m10213(C0459zf.m11068(this), 10);
                }
                C0458ze.m10814(C0459zf.m11068(this));
                if (C0453yj.m9953(this) <= C0449ye.m9257(this)) {
                    C0448yd.m8946(C0458ze.m10907(this), C0455za.m10111(this));
                } else {
                    C0448yd.m8946(C0458ze.m10907(this), C0455za.m10111(this));
                }
            }
        }
    }

    boolean m979a(C0309kx c0309kx) {
        if (C0461zs.m11645(c0309kx) != null) {
            C0455za.m10159(C0461zs.m11645(c0309kx));
        }
        for (int i = 0; i < C0450yf.m9488(this); i++) {
            abd.m1982(C0447yc.m8777(this), C0446yb.m8537(c0309kx)[i]);
            this.f939oV = C0453yj.m9953(this) - C0452yh.m9722(c0309kx)[i];
            C0452yh.m9722(c0309kx)[i] = 0;
        }
        this.f938oU = abe.m2398(this) + 1;
        C0455za.m10213(gggy.m4317(C0455za.m10213(gggy.m4317(C0459zf.m11068(this), m5893()), 32), C0449ye.m9181(c0309kx)), 10);
        abd.m1997(abd.m2039(this), C0449ye.m9181(c0309kx));
        if (!C0458ze.m10807(this)) {
            return true;
        }
        C0448yd.m8946(C0458ze.m10907(this), C0455za.m10111(this));
        return true;
    }

    @Override
    public void close() {
        synchronized (this) {
            if (!abf.m2532(this) || C0456zb.m10466(this)) {
                this.f929oL = true;
            } else {
                for (C0309kx c0309kx : (C0309kx[]) C0460zg.m11360(C0456zb.m10306(abd.m2039(this)), new C0309kx[C0449ye.m9206(abd.m2039(this))])) {
                    if (C0461zs.m11645(c0309kx) != null) {
                        abc.m1753(C0461zs.m11645(c0309kx));
                    }
                }
                C0450yf.m9337(this);
                C0446yb.m8432(C0459zf.m11068(this));
                this.f933oP = null;
                this.f929oL = true;
            }
        }
    }

    public boolean m980dI() {
        boolean zM10466;
        synchronized (this) {
            zM10466 = C0456zb.m10466(this);
        }
        return zM10466;
    }

    boolean m981dJ() {
        return abe.m2398(this) >= 2000 && abe.m2398(this) >= C0449ye.m9206(abd.m2039(this));
    }

    void m982dK() {
        while (C0453yj.m9953(this) > C0449ye.m9257(this)) {
            abd.m2093(this, (C0309kx) m5899(gggy.m4289(C0456zb.m10306(abd.m2039(this)))));
        }
        this.f936oS = false;
    }

    @Override
    public void flush() {
        synchronized (this) {
            if (abf.m2532(this)) {
                C0447yc.m8633(this);
                C0450yf.m9337(this);
                C0458ze.m10814(C0459zf.m11068(this));
            }
        }
    }
}
