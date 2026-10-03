package com.google.android.material.card2;

import java.util.ArrayDeque;
import java.util.Deque;
import java.util.Iterator;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.SynchronousQueue;
import java.util.concurrent.ThreadPoolExecutor;
import javax.annotation.Nullable;

public final class C0261jc {

    @Nullable
    private ExecutorService f687ls;

    @Nullable
    private Runnable f688lt;

    private int f689lu = 64;

    private int f690lv = 5;

    private final Deque<C0284jz> f691lw = new ArrayDeque();

    private final Deque<C0284jz> f692lx = new ArrayDeque();

    private final Deque<C0283jy> f693ly = new ArrayDeque();

    private int m678a(C0284jz c0284jz) {
        Iterator itM10319 = C0456zb.m10319(C0459zf.m11155(this));
        int i = 0;
        while (C0455za.m10104(itM10319)) {
            if (C0452yh.m9583(abe.m2367((C0284jz) m5114(itM10319)), abe.m2367(c0284jz))) {
                i++;
            }
        }
        return i;
    }

    private <T> void m679a(Deque<T> deque, T t, boolean z) {
        int iM8740;
        Runnable runnableM2571;
        synchronized (this) {
            if (!C0453yj.m9905(deque, t)) {
                throw new AssertionError(m5115());
            }
            if (z) {
                C0457zc.m10719(this);
            }
            iM8740 = C0447yc.m8740(this);
            runnableM2571 = abf.m2571(this);
        }
        if (iM8740 != 0 || runnableM2571 == null) {
            return;
        }
        C0460zg.m11226(runnableM2571);
    }

    private void m680cc() {
        if (C0456zb.m10506(C0459zf.m11155(this)) < abf.m2472(this) && !C0450yf.m9427(C0460zg.m11325(this))) {
            Iterator itM10319 = C0456zb.m10319(C0460zg.m11325(this));
            while (C0455za.m10104(itM10319)) {
                C0284jz c0284jz = (C0284jz) m5114(itM10319);
                if (C0447yc.m8622(this, c0284jz) < abd.m2025(this)) {
                    abf.m2476(itM10319);
                    C0459zf.m11006(C0459zf.m11155(this), c0284jz);
                    abd.m2125(C0455za.m10209(this), c0284jz);
                }
                if (C0456zb.m10506(C0459zf.m11155(this)) >= abf.m2472(this)) {
                    return;
                }
            }
        }
    }

    public static Deque m5104(Object obj) {
        if (C0450yf.m9352() <= 0) {
            return ((C0261jc) obj).f691lw;
        }
        return null;
    }

    public static Deque m5105(Object obj) {
        if (C0460zg.m11287() > 0) {
            return ((C0261jc) obj).f693ly;
        }
        return null;
    }

    public static int m5106(Object obj, Object obj2) {
        if (abe.m2308() < 0) {
            return ((C0261jc) obj).m678a((C0284jz) obj2);
        }
        return 0;
    }

    public static void m5107(Object obj) {
        if (C0459zf.m11062() >= 0) {
            ((C0261jc) obj).m680cc();
        }
    }

    public static Deque m5108(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return ((C0261jc) obj).f692lx;
        }
        return null;
    }

    public static void m5109(Object obj, Object obj2, Object obj3, boolean z) {
        if (abf.m2510() <= 0) {
            ((C0261jc) obj).m679a((Deque) obj2, obj3, z);
        }
    }

    public static ExecutorService m5110(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return ((C0261jc) obj).f687ls;
        }
        return null;
    }

    public static int m5111(Object obj) {
        if (C0452yh.m9798() > 0) {
            return ((C0261jc) obj).f689lu;
        }
        return 0;
    }

    public static int m5112(Object obj) {
        if (C0453yj.m10013() > 0) {
            return ((C0261jc) obj).f690lv;
        }
        return 0;
    }

    public static Runnable m5113(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return ((C0261jc) obj).f688lt;
        }
        return null;
    }

    public static Object m5114(Object obj) {
        if (C0456zb.m10326() < 0) {
            return C0598.m11882(obj);
        }
        return null;
    }

    public static String m5115() {
        if (C0459zf.m11062() > 0) {
            return C0598.m11821();
        }
        return null;
    }

    public static String m5116(Object obj) {
        if (abf.m2510() <= 0) {
            return ((C0284jz) obj).m843ct();
        }
        return null;
    }

    public static void m5117(Object obj, Object obj2, Object obj3, boolean z) {
        if (C0460zg.m11293() >= 0) {
            m5109((C0261jc) obj, (Deque) obj2, obj3, z);
        }
    }

    public static int m5118(Object obj) {
        if (gggy.m4365() >= 0) {
            return m5111((C0261jc) obj);
        }
        return 0;
    }

    public static String m5119(Object obj) {
        if (C0457zc.m10718() <= 0) {
            return m5116((C0284jz) obj);
        }
        return null;
    }

    public static int m5120(Object obj, Object obj2) {
        if (C0453yj.m9996() < 0) {
            return m5106((C0261jc) obj, (C0284jz) obj2);
        }
        return 0;
    }

    public static ExecutorService m5121(Object obj) {
        if (C0457zc.m10555() >= 0) {
            return m5110((C0261jc) obj);
        }
        return null;
    }

    public static Deque m5122(Object obj) {
        if (C0447yc.m8786() >= 0) {
            return m5104((C0261jc) obj);
        }
        return null;
    }

    public static void m5123(Object obj) {
        if (C0453yj.m9945() < 0) {
            m5107((C0261jc) obj);
        }
    }

    public static Runnable m5124(Object obj) {
        if (C0453yj.m10032() > 0) {
            return m5113((C0261jc) obj);
        }
        return null;
    }

    public static int m5125(Object obj) {
        if (C0445ya.m8330() >= 0) {
            return m5112((C0261jc) obj);
        }
        return 0;
    }

    public static Deque m5126(Object obj) {
        if (C0458ze.m10926() <= 0) {
            return m5108((C0261jc) obj);
        }
        return null;
    }

    public static Deque m5127(Object obj) {
        if (C0456zb.m10484() < 0) {
            return m5105((C0261jc) obj);
        }
        return null;
    }

    void m681b(C0284jz c0284jz) {
        synchronized (this) {
            if (C0456zb.m10506(C0459zf.m11155(this)) >= abf.m2472(this) || C0447yc.m8622(this, c0284jz) >= abd.m2025(this)) {
                C0459zf.m11006(C0460zg.m11325(this), c0284jz);
            } else {
                C0459zf.m11006(C0459zf.m11155(this), c0284jz);
                abd.m2125(C0455za.m10209(this), c0284jz);
            }
        }
    }

    void m682c(C0284jz c0284jz) {
        abf.m2455(this, C0459zf.m11155(this), c0284jz, true);
    }

    public ExecutorService m683cd() {
        ExecutorService executorServiceM8915;
        synchronized (this) {
            if (C0448yd.m8915(this) == null) {
                this.f687ls = new ThreadPoolExecutor(0, Integer.MAX_VALUE, 60L, C0446yb.m8507(), new SynchronousQueue(), C0446yb.m8515(abf.m2655(), false));
            }
            executorServiceM8915 = C0448yd.m8915(this);
        }
        return executorServiceM8915;
    }

    public int m684ce() {
        int iM10506;
        int iM10507;
        synchronized (this) {
            iM10506 = C0456zb.m10506(C0459zf.m11155(this));
            iM10507 = C0456zb.m10506(C0455za.m10215(this));
        }
        return iM10506 + iM10507;
    }
}
