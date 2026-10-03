package com.google.android.material.card2;

import java.io.IOException;

abstract class AbstractC0337ly implements InterfaceC0429ph {

    protected boolean f1037oL;

    protected long f1038qI;

    final C0335lw f1039qJ;

    protected final C0415ou f1040qK;

    private AbstractC0337ly(C0335lw c0335lw) {
        this.f1039qJ = c0335lw;
        this.f1040qK = new C0415ou(m6206(m6207(m6216(this))));
        this.f1038qI = 0L;
    }

    AbstractC0337ly(C0335lw c0335lw, C0336lx c0336lx) {
        this(c0335lw);
    }

    public static C0415ou m6205(Object obj) {
        if (C0459zf.m11062() > 0) {
            return ((AbstractC0337ly) obj).f1040qK;
        }
        return null;
    }

    public static C0430pi m6206(Object obj) {
        if (C0447yc.m8635() > 0) {
            return m6230(obj);
        }
        return null;
    }

    public static InterfaceC0411oq m6207(Object obj) {
        if (C0452yh.m9798() > 0) {
            return m6228(obj);
        }
        return null;
    }

    public static C0415ou m6208(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return m6231(obj);
        }
        return null;
    }

    public static int m6209(Object obj) {
        if (C0446yb.m8415() <= 0) {
            return m6232(obj);
        }
        return 0;
    }

    public static C0335lw m6210(Object obj) {
        if (C0446yb.m8415() < 0) {
            return ((AbstractC0337ly) obj).f1039qJ;
        }
        return null;
    }

    public static C0319lg m6211(Object obj) {
        if (C0461zs.m11510() < 0) {
            return ((C0335lw) obj).f1036qH;
        }
        return null;
    }

    public static void m6212(Object obj, boolean z, Object obj2) {
        if (abc.m1845() <= 0) {
            m6233(obj, z, obj2);
        }
    }

    public static C0430pi m6213(Object obj) {
        if (C0446yb.m8415() < 0) {
            return ((InterfaceC0411oq) obj).mo967dz();
        }
        return null;
    }

    public static long m6214(Object obj, Object obj2, long j) {
        if (C0447yc.m8635() >= 0) {
            return m6226(obj, obj2, j);
        }
        return 0L;
    }

    public static int m6215(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return ((C0335lw) obj).f1035qG;
        }
        return 0;
    }

    public static C0335lw m6216(Object obj) {
        if (adds.m2755() > 0) {
            return m6225(obj);
        }
        return null;
    }

    public static void m6217(Object obj, Object obj2) {
        if (abd.m2162() > 0) {
            m6229(obj, obj2);
        }
    }

    public static long m6218(Object obj) {
        if (C0453yj.m10013() > 0) {
            return ((AbstractC0337ly) obj).f1038qI;
        }
        return 0L;
    }

    public static long m6219(Object obj, Object obj2, long j) {
        if (C0460zg.m11287() > 0) {
            return ((InterfaceC0411oq) obj).mo966a((C0409oo) obj2, j);
        }
        return 0L;
    }

    public static long m6220(Object obj) {
        if (C0446yb.m8415() < 0) {
            return m6227(obj);
        }
        return 0L;
    }

    public static C0319lg m6221(Object obj) {
        if (C0460zg.m11287() > 0) {
            return m6234(obj);
        }
        return null;
    }

    public static void m6222(Object obj, Object obj2) {
        if (C0459zf.m11062() >= 0) {
            ((C0335lw) obj).m1087a((C0415ou) obj2);
        }
    }

    public static InterfaceC0411oq m6223(Object obj) {
        if (C0446yb.m8415() < 0) {
            return ((C0335lw) obj).f1034qF;
        }
        return null;
    }

    public static void m6224(Object obj, boolean z, Object obj2) {
        if (C0459zf.m11062() > 0) {
            ((AbstractC0337ly) obj).m1094a(z, (IOException) obj2);
        }
    }

    public static C0335lw m6225(Object obj) {
        if (abe.m2321() <= 0) {
            return m6210((AbstractC0337ly) obj);
        }
        return null;
    }

    public static long m6226(Object obj, Object obj2, long j) {
        if (abd.m2166() <= 0) {
            return m6219((InterfaceC0411oq) obj, (C0409oo) obj2, j);
        }
        return 0L;
    }

    public static long m6227(Object obj) {
        if (C0445ya.m8330() >= 0) {
            return m6218((AbstractC0337ly) obj);
        }
        return 0L;
    }

    public static InterfaceC0411oq m6228(Object obj) {
        if (C0453yj.m10032() > 0) {
            return m6223((C0335lw) obj);
        }
        return null;
    }

    public static void m6229(Object obj, Object obj2) {
        if (C0457zc.m10555() >= 0) {
            m6222((C0335lw) obj, (C0415ou) obj2);
        }
    }

    public static C0430pi m6230(Object obj) {
        if (abf.m2500() > 0) {
            return m6213((InterfaceC0411oq) obj);
        }
        return null;
    }

    public static C0415ou m6231(Object obj) {
        if (C0445ya.m8330() > 0) {
            return m6205((AbstractC0337ly) obj);
        }
        return null;
    }

    public static int m6232(Object obj) {
        if (gggy.m4365() >= 0) {
            return m6215((C0335lw) obj);
        }
        return 0;
    }

    public static void m6233(Object obj, boolean z, Object obj2) {
        if (gggy.m4365() > 0) {
            m6224((AbstractC0337ly) obj, z, (IOException) obj2);
        }
    }

    public static C0319lg m6234(Object obj) {
        if (C0460zg.m11293() >= 0) {
            return m6211((C0335lw) obj);
        }
        return null;
    }

    @Override
    public long mo966a(C0409oo c0409oo, long j) throws IOException {
        try {
            long jM6214 = m6214(m6207(m6216(this)), c0409oo, j);
            if (jM6214 > 0) {
                this.f1038qI = m6220(this) + jM6214;
            }
            return jM6214;
        } catch (IOException e) {
            m6212(this, false, e);
            throw e;
        }
    }

    protected final void m1094a(boolean z, IOException iOException) {
        if (m6209(m6216(this)) == 6) {
            return;
        }
        if (m6209(m6216(this)) != 5) {
            throw new IllegalStateException(abc.m1925(adds.m2680(C0460zg.m11407(new StringBuilder(), C0456zb.m10299()), m6209(m6216(this)))));
        }
        m6217(m6216(this), m6208(this));
        m6216(this).f1035qG = 6;
        if (m6221(m6216(this)) != null) {
            abf.m2437(m6221(m6216(this)), !z, m6216(this), m6220(this), iOException);
        }
    }

    @Override
    public C0430pi mo967dz() {
        return m6208(this);
    }
}
