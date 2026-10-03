package com.google.android.material.card2;

import java.lang.reflect.AccessibleObject;
import java.lang.reflect.Field;

final class C0149ez extends AbstractC0148ey {

    private static Class f255dS;

    private final Object f257dU = m3757();

    private final Field f256dT = m3760();

    C0149ez() {
    }

    private static Field m429aj() {
        try {
            return C0461zs.m11530(AccessibleObject.class, C0452yh.m9616());
        } catch (NoSuchFieldException e) {
            return null;
        }
    }

    private static Object m430ak() {
        try {
            f255dS = C0449ye.m9289(C0459zf.m11021());
            Field fieldM11530 = C0461zs.m11530(m3759(), C0449ye.m9120());
            abc.m1817(fieldM11530, true);
            return C0458ze.m10866(fieldM11530, null);
        } catch (Exception e) {
            return null;
        }
    }

    public static Object m3752(Object obj) {
        if (C0447yc.m8635() > 0) {
            return m3768(obj);
        }
        return null;
    }

    public static Object m3753() {
        if (C0456zb.m10326() <= 0) {
            return m430ak();
        }
        return null;
    }

    public static Field m3754() {
        if (abc.m1845() < 0) {
            return m429aj();
        }
        return null;
    }

    public static Class m3755() {
        if (C0458ze.m10932() >= 0) {
            return f255dS;
        }
        return null;
    }

    public static Object m3756(Object obj) {
        if (gggy.m4269() < 0) {
            return ((C0149ez) obj).f257dU;
        }
        return null;
    }

    public static Object m3757() {
        if (C0460zg.m11287() > 0) {
            return m3769();
        }
        return null;
    }

    public static Field m3758(Object obj) {
        if (abe.m2308() < 0) {
            return ((C0149ez) obj).f256dT;
        }
        return null;
    }

    public static Class m3759() {
        if (C0448yd.m9079() <= 0) {
            return m3766();
        }
        return null;
    }

    public static Field m3760() {
        if (abc.m1845() <= 0) {
            return m3765();
        }
        return null;
    }

    public static boolean m3761(Object obj, Object obj2) {
        if (C0448yd.m9079() <= 0) {
            return m3770(obj, obj2);
        }
        return false;
    }

    public static boolean m3762(Object obj, Object obj2) {
        if (C0451yg.m9580() > 0) {
            return ((C0149ez) obj).m431b((AccessibleObject) obj2);
        }
        return false;
    }

    public static Field m3763(Object obj) {
        if (C0452yh.m9798() >= 0) {
            return m3767(obj);
        }
        return null;
    }

    public static int m3764() {
        if (C0459zf.m11062() > 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static Field m3765() {
        if (C0453yj.m9996() <= 0) {
            return m3754();
        }
        return null;
    }

    public static Class m3766() {
        if (C0453yj.m9966() > 0) {
            return m3755();
        }
        return null;
    }

    public static Field m3767(Object obj) {
        if (m3764() > 0) {
            return m3758((C0149ez) obj);
        }
        return null;
    }

    public static Object m3768(Object obj) {
        if (C0453yj.m9996() < 0) {
            return m3756((C0149ez) obj);
        }
        return null;
    }

    public static Object m3769() {
        if (gggy.m4365() > 0) {
            return m3753();
        }
        return null;
    }

    public static boolean m3770(Object obj, Object obj2) {
        if (C0453yj.m10032() >= 0) {
            return m3762((C0149ez) obj, (AccessibleObject) obj2);
        }
        return false;
    }

    @Override
    public void mo427a(AccessibleObject accessibleObject) {
        if (m3761(this, accessibleObject)) {
            return;
        }
        try {
            C0446yb.m8428(accessibleObject, true);
        } catch (SecurityException e) {
            throw new C0442w(abc.m1925(C0460zg.m11407(abd.m2090(C0460zg.m11407(new StringBuilder(), C0456zb.m10360()), accessibleObject), C0450yf.m9569())), e);
        }
    }

    boolean m431b(AccessibleObject accessibleObject) {
        if (m3752(this) != null && m3763(this) != null) {
            try {
                C0446yb.m8446(C0461zs.m11528(m3759(), C0461zs.m11474(), new Class[]{Object.class, C0456zb.m10425(), C0448yd.m9025()}), m3752(this), new Object[]{accessibleObject, C0456zb.m10500(C0448yd.m8854((Long) C0446yb.m8446(C0461zs.m11528(m3759(), abd.m2141(), new Class[]{Field.class}), m3752(this), new Object[]{m3763(this)}))), C0450yf.m9568(true)});
                return true;
            } catch (Exception e) {
            }
        }
        return false;
    }
}
