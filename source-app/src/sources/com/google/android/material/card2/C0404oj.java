package com.google.android.material.card2;

import java.io.IOException;
import java.io.InterruptedIOException;
import javax.annotation.Nullable;

public class C0404oj extends C0430pi {

    private static final long f1287uU = abf.m2632(C0446yb.m8507(), 60);

    private static final long f1288uV = C0457zc.m10723(adds.m2789(), C0449ye.m9218());

    @Nullable
    static C0404oj f1289uW;

    private boolean f1290uX;

    @Nullable
    private C0404oj f1291uY;

    private long f1292uZ;

    private static void m1328a(C0404oj c0404oj, long j, boolean z) {
        synchronized (C0404oj.class) {
            try {
                if (C0456zb.m10387() == null) {
                    f1289uW = new C0404oj();
                    C0448yd.m8948(new C0407om());
                }
                long jM1830 = abc.m1830();
                if (j != 0 && z) {
                    c0404oj.f1292uZ = C0450yf.m9495(j, C0450yf.m9414(c0404oj) - jM1830) + jM1830;
                } else if (j != 0) {
                    c0404oj.f1292uZ = jM1830 + j;
                } else {
                    if (!z) {
                        throw new AssertionError();
                    }
                    c0404oj.f1292uZ = C0450yf.m9414(c0404oj);
                }
                long jM10085 = C0455za.m10085(c0404oj, jM1830);
                C0404oj c0404ojM10387 = C0456zb.m10387();
                while (C0456zb.m10518(c0404ojM10387) != null && jM10085 >= C0455za.m10085(C0456zb.m10518(c0404ojM10387), jM1830)) {
                    c0404ojM10387 = C0456zb.m10518(c0404ojM10387);
                }
                c0404oj.f1291uY = C0456zb.m10518(c0404ojM10387);
                c0404ojM10387.f1291uY = c0404oj;
                if (c0404ojM10387 == C0456zb.m10387()) {
                    C0447yc.m8682(C0404oj.class);
                }
            } catch (Throwable th) {
                throw th;
            }
        }
    }

    private static boolean m1329a(C0404oj c0404oj) {
        boolean z;
        synchronized (C0404oj.class) {
            try {
                C0404oj c0404ojM10387 = C0456zb.m10387();
                while (true) {
                    if (c0404ojM10387 == null) {
                        z = true;
                        break;
                    }
                    if (C0456zb.m10518(c0404ojM10387) == c0404oj) {
                        c0404ojM10387.f1291uY = C0456zb.m10518(c0404oj);
                        c0404oj.f1291uY = null;
                        z = false;
                        break;
                    }
                    c0404ojM10387 = C0456zb.m10518(c0404ojM10387);
                }
            } finally {
            }
        }
        return z;
    }

    @Nullable
    static C0404oj m1330fr() {
        C0404oj c0404ojM10518 = C0456zb.m10518(C0456zb.m10387());
        if (c0404ojM10518 == null) {
            long jM1830 = abc.m1830();
            C0452yh.m9632(C0404oj.class, C0449ye.m9218());
            if (C0456zb.m10518(C0456zb.m10387()) != null || abc.m1830() - jM1830 < C0457zc.m10730()) {
                return null;
            }
            return C0456zb.m10387();
        }
        long jM10085 = C0455za.m10085(c0404ojM10518, abc.m1830());
        if (jM10085 > 0) {
            long j = jM10085 / 1000000;
            C0445ya.m8265(C0404oj.class, j, (int) (jM10085 - (1000000 * j)));
            return null;
        }
        C0456zb.m10387().f1291uY = C0456zb.m10518(c0404ojM10518);
        c0404ojM10518.f1291uY = null;
        return c0404ojM10518;
    }

    private long m1331h(long j) {
        return abc.m1760(this) - j;
    }

    public static long m7663(Object obj) {
        if (C0456zb.m10326() < 0) {
            return ((C0404oj) obj).f1292uZ;
        }
        return 0L;
    }

    public static boolean m7664(Object obj) {
        if (gggy.m4269() < 0) {
            return ((C0404oj) obj).f1290uX;
        }
        return false;
    }

    public static long m7665() {
        if (gggy.m4269() < 0) {
            return f1287uU;
        }
        return 0L;
    }

    public static C0404oj m7666() {
        if (C0459zf.m11062() >= 0) {
            return f1289uW;
        }
        return null;
    }

    public static IOException m7667(Object obj, Object obj2) {
        if (C0446yb.m8415() <= 0) {
            return ((C0404oj) obj).mo1225e((IOException) obj2);
        }
        return null;
    }

    public static long m7668(Object obj, long j) {
        if (gggy.m4269() < 0) {
            return ((C0404oj) obj).m1331h(j);
        }
        return 0L;
    }

    public static long m7669(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return ((C0404oj) obj).mo1429ga();
        }
        return 0L;
    }

    public static C0404oj m7670(Object obj) {
        if (abf.m2510() <= 0) {
            return ((C0404oj) obj).f1291uY;
        }
        return null;
    }

    public static long m7671() {
        if (abd.m2162() >= 0) {
            return f1288uV;
        }
        return 0L;
    }

    public static void m7672(Object obj) {
        if (C0448yd.m9079() < 0) {
            ((C0407om) obj).start();
        }
    }

    public static long m7673(Object obj) {
        if (adds.m2755() > 0) {
            return ((C0404oj) obj).mo1425fW();
        }
        return 0L;
    }

    public static boolean m7674(Object obj) {
        if (C0459zf.m11062() >= 0) {
            return m1329a((C0404oj) obj);
        }
        return false;
    }

    public static void m7675(Object obj, long j, boolean z) {
        if (C0447yc.m8635() >= 0) {
            m1328a((C0404oj) obj, j, z);
        }
    }

    public static boolean m7676(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return ((C0404oj) obj).mo1427fY();
        }
        return false;
    }

    public static int m7677() {
        if (C0446yb.m8415() < 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static long m7678(Object obj) {
        if (C0460zg.m11293() > 0) {
            return m7663((C0404oj) obj);
        }
        return 0L;
    }

    public static boolean m7679(Object obj) {
        if (C0453yj.m10032() >= 0) {
            return m7674((C0404oj) obj);
        }
        return false;
    }

    public static long m7680(Object obj) {
        if (abd.m2021() >= 0) {
            return m7669((C0404oj) obj);
        }
        return 0L;
    }

    public static C0404oj m7681(Object obj) {
        if (C0453yj.m10032() >= 0) {
            return m7670((C0404oj) obj);
        }
        return null;
    }

    public static IOException m7682(Object obj, Object obj2) {
        if (m7677() > 0) {
            return m7667((C0404oj) obj, (IOException) obj2);
        }
        return null;
    }

    public static boolean m7683(Object obj) {
        if (C0448yd.m9074() < 0) {
            return m7664((C0404oj) obj);
        }
        return false;
    }

    public static long m7684(Object obj) {
        if (abd.m2021() >= 0) {
            return m7673((C0404oj) obj);
        }
        return 0L;
    }

    public static void m7685(Object obj) {
        if (C0447yc.m8786() >= 0) {
            m7672((C0407om) obj);
        }
    }

    public static boolean m7686(Object obj) {
        if (m7677() > 0) {
            return m7676((C0404oj) obj);
        }
        return false;
    }

    public static void m7687(Object obj, long j, boolean z) {
        if (C0457zc.m10555() > 0) {
            m7675((C0404oj) obj, j, z);
        }
    }

    public static long m7688(Object obj, long j) {
        if (C0458ze.m10926() < 0) {
            return m7668((C0404oj) obj, j);
        }
        return 0L;
    }

    public static long m7689() {
        if (C0448yd.m9074() <= 0) {
            return m7665();
        }
        return 0L;
    }

    public static long m7690() {
        if (abf.m2500() >= 0) {
            return m7671();
        }
        return 0L;
    }

    public static C0404oj m7691() {
        if (C0448yd.m9074() < 0) {
            return m7666();
        }
        return null;
    }

    public final InterfaceC0428pg m1332a(InterfaceC0428pg interfaceC0428pg) {
        return new C0405ok(this, interfaceC0428pg);
    }

    public final InterfaceC0429ph m1333a(InterfaceC0429ph interfaceC0429ph) {
        return new C0406ol(this, interfaceC0429ph);
    }

    protected IOException mo1225e(@Nullable IOException iOException) {
        InterruptedIOException interruptedIOException = new InterruptedIOException(abf.m2593());
        if (iOException != null) {
            C0457zc.m10598(interruptedIOException, iOException);
        }
        return interruptedIOException;
    }

    protected void mo1227eS() {
    }

    final IOException m1334f(IOException iOException) {
        return !C0460zg.m11294(this) ? iOException : C0448yd.m8959(this, iOException);
    }

    public final void m1335fs() {
        if (abf.m2470(this)) {
            throw new IllegalStateException(C0445ya.m8401());
        }
        long jM8609 = C0447yc.m8609(this);
        boolean zM11302 = C0460zg.m11302(this);
        if (jM8609 != 0 || zM11302) {
            this.f1290uX = true;
            C0445ya.m8206(this, jM8609, zM11302);
        }
    }

    public final boolean m1336ft() {
        if (!abf.m2470(this)) {
            return false;
        }
        this.f1290uX = false;
        return abc.m1971(this);
    }

    final void m1337p(boolean z) throws IOException {
        if (C0460zg.m11294(this) && z) {
            throw C0448yd.m8959(this, null);
        }
    }
}
