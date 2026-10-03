package com.google.android.material.card2;

import java.lang.reflect.Field;

class C0094cy extends AbstractC0097da {

    final C0093cx f157bZ;

    final C0285k f158ca;

    final Field f159cb;

    final C0151fa f160cc;

    final boolean f161cd;

    final boolean f162ce;

    final AbstractC0022ah f163cf;

    C0094cy(C0093cx c0093cx, String str, boolean z, boolean z2, Field field, boolean z3, AbstractC0022ah abstractC0022ah, C0285k c0285k, C0151fa c0151fa, boolean z4) {
        super(str, z, z2);
        this.f157bZ = c0093cx;
        this.f159cb = field;
        this.f162ce = z3;
        this.f163cf = abstractC0022ah;
        this.f158ca = c0285k;
        this.f160cc = c0151fa;
        this.f161cd = z4;
    }

    public static C0285k m3400(Object obj) {
        if (C0451yg.m9580() > 0) {
            return m3418(obj);
        }
        return null;
    }

    public static boolean m3401(Object obj) {
        if (C0448yd.m9079() < 0) {
            return ((C0094cy) obj).f162ce;
        }
        return false;
    }

    public static boolean m3402(Object obj) {
        if (C0453yj.m10013() >= 0) {
            return ((C0094cy) obj).f161cd;
        }
        return false;
    }

    public static AbstractC0022ah m3403(Object obj) {
        if (C0453yj.m10013() > 0) {
            return ((C0094cy) obj).f163cf;
        }
        return null;
    }

    public static AbstractC0022ah m3404(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return m3416(obj);
        }
        return null;
    }

    public static boolean m3405(Object obj) {
        if (C0445ya.m8222() > 0) {
            return m3421(obj);
        }
        return false;
    }

    public static Field m3406(Object obj) {
        if (C0457zc.m10735() < 0) {
            return m3417(obj);
        }
        return null;
    }

    public static int m3407() {
        if (abe.m2308() <= 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static boolean m3408(Object obj) {
        if (C0456zb.m10326() < 0) {
            return ((C0094cy) obj).f168ck;
        }
        return false;
    }

    public static boolean m3409(Object obj) {
        if (C0447yc.m8635() > 0) {
            return m3415(obj);
        }
        return false;
    }

    public static C0151fa m3410(Object obj) {
        if (C0451yg.m9580() > 0) {
            return ((C0094cy) obj).f160cc;
        }
        return null;
    }

    public static boolean m3411(Object obj) {
        if (C0458ze.m10932() > 0) {
            return m3420(obj);
        }
        return false;
    }

    public static Field m3412(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return ((C0094cy) obj).f159cb;
        }
        return null;
    }

    public static C0151fa m3413(Object obj) {
        if (C0448yd.m9079() < 0) {
            return m3419(obj);
        }
        return null;
    }

    public static C0285k m3414(Object obj) {
        if (abd.m2162() >= 0) {
            return ((C0094cy) obj).f158ca;
        }
        return null;
    }

    public static boolean m3415(Object obj) {
        if (C0453yj.m9966() > 0) {
            return m3408((C0094cy) obj);
        }
        return false;
    }

    public static AbstractC0022ah m3416(Object obj) {
        if (gggy.m4365() >= 0) {
            return m3403((C0094cy) obj);
        }
        return null;
    }

    public static Field m3417(Object obj) {
        if (C0459zf.m11053() > 0) {
            return m3412((C0094cy) obj);
        }
        return null;
    }

    public static C0285k m3418(Object obj) {
        if (abd.m2166() <= 0) {
            return m3414((C0094cy) obj);
        }
        return null;
    }

    public static C0151fa m3419(Object obj) {
        if (m3407() >= 0) {
            return m3410((C0094cy) obj);
        }
        return null;
    }

    public static boolean m3420(Object obj) {
        if (abe.m2321() <= 0) {
            return m3402((C0094cy) obj);
        }
        return false;
    }

    public static boolean m3421(Object obj) {
        if (C0445ya.m8330() >= 0) {
            return m3401((C0094cy) obj);
        }
        return false;
    }

    @Override
    void mo379a(C0152fb c0152fb, Object obj) {
        Object objM8683 = C0447yc.m8683(m3404(this), c0152fb);
        if (objM8683 == null && m3411(this)) {
            return;
        }
        C0449ye.m9215(m3406(this), obj, objM8683);
    }

    @Override
    void mo380a(C0155fe c0155fe, Object obj) {
        C0457zc.m10586(m3405(this) ? m3404(this) : new C0105di(m3400(this), m3404(this), C0456zb.m10432(m3413(this))), c0155fe, C0458ze.m10866(m3406(this), obj));
    }

    @Override
    public boolean mo381h(Object obj) {
        return m3409(this) && C0458ze.m10866(m3406(this), obj) != obj;
    }
}
