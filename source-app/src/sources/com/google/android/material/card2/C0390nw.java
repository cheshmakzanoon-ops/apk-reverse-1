package com.google.android.material.card2;

import java.lang.reflect.Method;

final class C0390nw {

    private final Method f1250um;

    private final Method f1251un;

    private final Method f1252uo;

    C0390nw(Method method, Method method2, Method method3) {
        this.f1250um = method;
        this.f1251un = method2;
        this.f1252uo = method3;
    }

    static C0390nw m1287fe() {
        Method methodM11528;
        Method methodM11529;
        Method methodM115210;
        try {
            Class clsM9289 = C0449ye.m9289(C0449ye.m9265());
            methodM11528 = C0461zs.m11528(clsM9289, C0450yf.m9551(), new Class[0]);
            methodM115210 = C0461zs.m11528(clsM9289, C0455za.m10138(), new Class[]{String.class});
            methodM11529 = C0461zs.m11528(clsM9289, adds.m2665(), new Class[0]);
        } catch (Exception e) {
            methodM11528 = null;
            methodM11529 = null;
            methodM115210 = null;
        }
        return new C0390nw(methodM11528, methodM115210, methodM11529);
    }

    public static Method m7484(Object obj) {
        if (C0461zs.m11510() < 0) {
            return ((C0390nw) obj).f1252uo;
        }
        return null;
    }

    public static Method m7485(Object obj) {
        if (gggy.m4269() <= 0) {
            return m7492(obj);
        }
        return null;
    }

    public static Method m7486(Object obj) {
        if (C0458ze.m10932() >= 0) {
            return ((C0390nw) obj).f1250um;
        }
        return null;
    }

    public static Method m7487(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return ((C0390nw) obj).f1251un;
        }
        return null;
    }

    public static Method m7488(Object obj) {
        if (C0446yb.m8415() < 0) {
            return m7490(obj);
        }
        return null;
    }

    public static Method m7489(Object obj) {
        if (abe.m2308() <= 0) {
            return m7491(obj);
        }
        return null;
    }

    public static Method m7490(Object obj) {
        if (abf.m2500() > 0) {
            return m7484((C0390nw) obj);
        }
        return null;
    }

    public static Method m7491(Object obj) {
        if (C0459zf.m11053() >= 0) {
            return m7487((C0390nw) obj);
        }
        return null;
    }

    public static Method m7492(Object obj) {
        if (C0453yj.m10032() >= 0) {
            return m7486((C0390nw) obj);
        }
        return null;
    }

    Object m1288aj(String str) {
        if (m7485(this) != null) {
            try {
                Object objM8446 = C0446yb.m8446(m7485(this), null, new Object[0]);
                C0446yb.m8446(m7489(this), objM8446, new Object[]{str});
                return objM8446;
            } catch (Exception e) {
            }
        }
        return null;
    }

    boolean m1289k(Object obj) {
        if (obj == null) {
            return false;
        }
        try {
            C0446yb.m8446(m7488(this), obj, new Object[0]);
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}
