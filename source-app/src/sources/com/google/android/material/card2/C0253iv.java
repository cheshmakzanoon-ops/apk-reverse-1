package com.google.android.material.card2;

import java.lang.ref.Reference;
import java.net.Socket;
import java.util.ArrayDeque;
import java.util.Deque;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.Executor;
import java.util.concurrent.SynchronousQueue;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;
import javax.annotation.Nullable;

public final class C0253iv {

    static final boolean f652kN;

    private static final Executor f653kO;

    private final Runnable f654kP;

    boolean f655kQ;

    private final Deque<C0314lb> f656kR;

    private final long f657kS;

    private final int f658kT;

    final C0315lc f659kU;

    static {
        f652kN = !C0460zg.m11342(C0253iv.class);
        f653kO = new ThreadPoolExecutor(0, Integer.MAX_VALUE, 60L, C0446yb.m8507(), new SynchronousQueue(), C0446yb.m8515(C0460zg.m11414(), true));
    }

    public C0253iv() {
        this(5, 5L, C0445ya.m8394());
    }

    public C0253iv(int i, long j, TimeUnit timeUnit) {
        this.f654kP = new RunnableC0254iw(this);
        this.f656kR = new ArrayDeque();
        this.f659kU = new C0315lc();
        this.f658kT = i;
        this.f657kS = C0457zc.m10723(timeUnit, j);
        if (j <= 0) {
            throw new IllegalArgumentException(abc.m1925(C0458ze.m10777(C0460zg.m11407(new StringBuilder(), C0447yc.m8613()), j)));
        }
    }

    private int m646a(C0314lb c0314lb, long j) {
        List listM10705 = C0457zc.m10705(c0314lb);
        int i = 0;
        while (i < m4988(listM10705)) {
            Reference reference = (Reference) gggy.m4400(listM10705, i);
            if (gggy.m4348(reference) != null) {
                i++;
            } else {
                abf.m2554(C0455za.m10101(), abc.m1925(C0460zg.m11407(abd.m2090(C0460zg.m11407(new StringBuilder(), C0453yj.m9998()), C0461zs.m11456(C0448yd.m8875(C0452yh.m9728(c0314lb)))), C0452yh.m9816())), C0450yf.m9496((C0320lh) reference));
                abc.m1794(listM10705, i);
                c0314lb.f965ps = true;
                if (C0452yh.m9618(listM10705)) {
                    c0314lb.f964pr = j - C0457zc.m10562(this);
                    return 0;
                }
            }
        }
        return m4988(listM10705);
    }

    public static int m4979(Object obj, Object obj2, long j) {
        if (C0448yd.m9079() <= 0) {
            return ((C0253iv) obj).m646a((C0314lb) obj2, j);
        }
        return 0;
    }

    public static long m4980(Object obj) {
        if (C0446yb.m8415() <= 0) {
            return ((C0253iv) obj).f657kS;
        }
        return 0L;
    }

    public static Deque m4981(Object obj) {
        if (abf.m2510() <= 0) {
            return ((C0253iv) obj).f656kR;
        }
        return null;
    }

    public static Runnable m4982(Object obj) {
        if (C0452yh.m9798() > 0) {
            return ((C0253iv) obj).f654kP;
        }
        return null;
    }

    public static Executor m4983() {
        if (C0461zs.m11510() < 0) {
            return f653kO;
        }
        return null;
    }

    public static boolean m4984() {
        if (abd.m2162() >= 0) {
            return f652kN;
        }
        return false;
    }

    public static boolean m4985(Object obj) {
        if (C0461zs.m11510() < 0) {
            return ((C0253iv) obj).f655kQ;
        }
        return false;
    }

    public static int m4986(Object obj) {
        if (C0457zc.m10735() <= 0) {
            return ((C0253iv) obj).f658kT;
        }
        return 0;
    }

    public static Object m4987(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return C0598.m11882(obj);
        }
        return null;
    }

    public static int m4988(Object obj) {
        if (abc.m1845() < 0) {
            return C0598.m11824(obj);
        }
        return 0;
    }

    public static int m4989(Object obj, Object obj2, long j) {
        if (C0447yc.m8786() >= 0) {
            return m4979((C0253iv) obj, (C0314lb) obj2, j);
        }
        return 0;
    }

    public static int m4990(Object obj) {
        if (C0453yj.m10032() >= 0) {
            return m4986((C0253iv) obj);
        }
        return 0;
    }

    public static Runnable m4991(Object obj) {
        if (C0448yd.m9074() <= 0) {
            return m4982((C0253iv) obj);
        }
        return null;
    }

    public static boolean m4992() {
        if (C0448yd.m9015() < 0) {
            return m4984();
        }
        return false;
    }

    public static long m4993(Object obj) {
        if (abd.m2021() > 0) {
            return m4980((C0253iv) obj);
        }
        return 0L;
    }

    public static Deque m4994(Object obj) {
        if (C0457zc.m10555() >= 0) {
            return m4981((C0253iv) obj);
        }
        return null;
    }

    public static Executor m4995() {
        if (abe.m2321() < 0) {
            return m4983();
        }
        return null;
    }

    public static boolean m4996(Object obj) {
        if (C0458ze.m10926() < 0) {
            return m4985((C0253iv) obj);
        }
        return false;
    }

    @Nullable
    C0314lb m647a(C0239ih c0239ih, C0319lg c0319lg, C0294ki c0294ki) {
        if (!C0445ya.m8210() && !C0455za.m10268(this)) {
            throw new AssertionError();
        }
        Iterator itM10319 = C0456zb.m10319(gggy.m4367(this));
        while (C0455za.m10104(itM10319)) {
            C0314lb c0314lb = (C0314lb) m4987(itM10319);
            if (C0449ye.m9201(c0314lb, c0239ih, c0294ki)) {
                adds.m2856(c0319lg, c0314lb, true);
                return c0314lb;
            }
        }
        return null;
    }

    @Nullable
    Socket m648a(C0239ih c0239ih, C0319lg c0319lg) {
        if (!C0445ya.m8210() && !C0455za.m10268(this)) {
            throw new AssertionError();
        }
        Iterator itM10319 = C0456zb.m10319(gggy.m4367(this));
        while (C0455za.m10104(itM10319)) {
            C0314lb c0314lb = (C0314lb) m4987(itM10319);
            if (C0449ye.m9201(c0314lb, c0239ih, null) && C0459zf.m11096(c0314lb) && c0314lb != C0452yh.m9803(c0319lg)) {
                return C0457zc.m10553(c0319lg, c0314lb);
            }
        }
        return null;
    }

    boolean m649a(C0314lb c0314lb) {
        if (!C0445ya.m8210() && !C0455za.m10268(this)) {
            throw new AssertionError();
        }
        if (C0445ya.m8282(c0314lb) || C0460zg.m11432(this) == 0) {
            C0453yj.m9905(gggy.m4367(this), c0314lb);
            return true;
        }
        abe.m2339(this);
        return false;
    }

    long m650b(long j) {
        long j2 = Long.MIN_VALUE;
        synchronized (this) {
            Iterator itM10319 = C0456zb.m10319(gggy.m4367(this));
            C0314lb c0314lb = null;
            int i = 0;
            int i2 = 0;
            while (C0455za.m10104(itM10319)) {
                C0314lb c0314lb2 = (C0314lb) m4987(itM10319);
                if (abf.m2435(this, c0314lb2, j) > 0) {
                    i2++;
                } else {
                    i++;
                    long jM8667 = j - C0447yc.m8667(c0314lb2);
                    if (jM8667 > j2) {
                        c0314lb = c0314lb2;
                        j2 = jM8667;
                    }
                }
            }
            if (j2 >= C0457zc.m10562(this) || i > C0460zg.m11432(this)) {
                C0453yj.m9905(gggy.m4367(this), c0314lb);
                C0455za.m10140(C0458ze.m10803(c0314lb));
                return 0L;
            }
            if (i > 0) {
                return C0457zc.m10562(this) - j2;
            }
            if (i2 > 0) {
                return C0457zc.m10562(this);
            }
            this.f655kQ = false;
            return -1L;
        }
    }

    void m651b(C0314lb c0314lb) {
        if (!C0445ya.m8210() && !C0455za.m10268(this)) {
            throw new AssertionError();
        }
        if (!C0447yc.m8808(this)) {
            this.f655kQ = true;
            C0448yd.m8946(adds.m2658(), C0448yd.m9081(this));
        }
        C0459zf.m11006(gggy.m4367(this), c0314lb);
    }
}
