package com.google.android.material.card2;

import java.io.File;
import java.io.IOException;

public final class C0308kw {

    private boolean f941oX;

    final C0309kx f942oY;

    final C0307kv f943oZ;

    final boolean[] f944pa;

    public static C0309kx m5927(Object obj) {
        if (C0458ze.m10932() > 0) {
            return m5937(obj);
        }
        return null;
    }

    public static C0307kv m5928(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return ((C0308kw) obj).f943oZ;
        }
        return null;
    }

    public static int m5929(Object obj) {
        if (C0459zf.m11062() >= 0) {
            return ((C0307kv) obj).f940oW;
        }
        return 0;
    }

    public static boolean m5930(Object obj) {
        if (abf.m2510() < 0) {
            return ((C0308kw) obj).f941oX;
        }
        return false;
    }

    public static File[] m5931(Object obj) {
        if (abe.m2308() < 0) {
            return ((C0309kx) obj).f947pd;
        }
        return null;
    }

    public static void m5932(Object obj, Object obj2, boolean z) {
        if (C0452yh.m9798() > 0) {
            ((C0307kv) obj).m978a((C0308kw) obj2, z);
        }
    }

    public static C0309kx m5933(Object obj) {
        if (adds.m2755() >= 0) {
            return ((C0308kw) obj).f942oY;
        }
        return null;
    }

    public static InterfaceC0385nr m5934(Object obj) {
        if (C0459zf.m11062() >= 0) {
            return ((C0307kv) obj).f931oN;
        }
        return null;
    }

    public static C0308kw m5935(Object obj) {
        if (C0453yj.m10013() >= 0) {
            return ((C0309kx) obj).f946pc;
        }
        return null;
    }

    public static void m5936(Object obj, Object obj2, boolean z) {
        if (C0459zf.m11053() >= 0) {
            m5932((C0307kv) obj, (C0308kw) obj2, z);
        }
    }

    public static C0309kx m5937(Object obj) {
        if (C0453yj.m9966() >= 0) {
            return m5933((C0308kw) obj);
        }
        return null;
    }

    public static InterfaceC0385nr m5938(Object obj) {
        if (C0448yd.m9015() <= 0) {
            return m5934((C0307kv) obj);
        }
        return null;
    }

    public static int m5939(Object obj) {
        if (abd.m2166() < 0) {
            return m5929((C0307kv) obj);
        }
        return 0;
    }

    public static C0307kv m5940(Object obj) {
        if (gggy.m4365() >= 0) {
            return m5928((C0308kw) obj);
        }
        return null;
    }

    public static boolean m5941(Object obj) {
        if (C0448yd.m9015() < 0) {
            return m5930((C0308kw) obj);
        }
        return false;
    }

    public static File[] m5942(Object obj) {
        if (C0458ze.m10926() <= 0) {
            return m5931((C0309kx) obj);
        }
        return null;
    }

    public static C0308kw m5943(Object obj) {
        if (C0453yj.m9966() >= 0) {
            return m5935((C0309kx) obj);
        }
        return null;
    }

    public void m983dA() {
        synchronized (C0460zg.m11339(this)) {
            if (abd.m2089(this)) {
                throw new IllegalStateException();
            }
            if (C0461zs.m11629(m5927(this)) == this) {
                C0457zc.m10726(C0460zg.m11339(this), this, false);
            }
            this.f941oX = true;
        }
    }

    void m984dL() {
        if (C0461zs.m11629(m5927(this)) == this) {
            for (int i = 0; i < abd.m2122(C0460zg.m11339(this)); i++) {
                try {
                    abd.m1982(C0453yj.m9972(C0460zg.m11339(this)), C0449ye.m9251(m5927(this))[i]);
                } catch (IOException e) {
                }
            }
            m5927(this).f946pc = null;
        }
    }
}
