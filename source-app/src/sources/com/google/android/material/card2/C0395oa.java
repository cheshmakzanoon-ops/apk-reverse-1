package com.google.android.material.card2;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

class C0395oa<T> {

    private final Class[] f1264uA;

    private final Class<?> f1265uB;

    private final String f1266uz;

    C0395oa(Class<?> cls, String str, Class... clsArr) {
        this.f1265uB = cls;
        this.f1266uz = str;
        this.f1264uA = clsArr;
    }

    private static Method m1294a(Class<?> cls, String str, Class[] clsArr) {
        try {
            Method methodM11528 = C0461zs.m11528(cls, str, clsArr);
            try {
                if ((C0459zf.m11080(methodM11528) & 1) == 0) {
                    return null;
                }
                return methodM11528;
            } catch (NoSuchMethodException e) {
                return methodM11528;
            }
        } catch (NoSuchMethodException e2) {
            return null;
        }
    }

    private Method m1295l(Class<?> cls) {
        if (m7548(this) == null) {
            return null;
        }
        Method methodM7549 = m7549(cls, m7548(this), m7542(this));
        if (methodM7549 == null || m7544(this) == null || gggy.m4342(m7544(this), gggy.m4446(methodM7549))) {
            return methodM7549;
        }
        return null;
    }

    public static Object m7540(Object obj, Object obj2, Object obj3) {
        if (C0458ze.m10932() >= 0) {
            return m7559(obj, obj2, obj3);
        }
        return null;
    }

    public static Class m7541(Object obj) {
        if (C0460zg.m11287() > 0) {
            return ((C0395oa) obj).f1265uB;
        }
        return null;
    }

    public static Class[] m7542(Object obj) {
        if (C0447yc.m8635() > 0) {
            return m7558(obj);
        }
        return null;
    }

    public static Method m7543(Object obj, Object obj2, Object obj3) {
        if (gggy.m4269() < 0) {
            return m1294a((Class) obj, (String) obj2, (Class[]) obj3);
        }
        return null;
    }

    public static Class m7544(Object obj) {
        if (abd.m2162() > 0) {
            return m7556(obj);
        }
        return null;
    }

    public static Object m7545(Object obj, Object obj2, Object obj3) {
        if (C0461zs.m11510() < 0) {
            return m7560(obj, obj2, obj3);
        }
        return null;
    }

    public static String m7546(Object obj) {
        if (C0448yd.m9079() <= 0) {
            return ((C0395oa) obj).f1266uz;
        }
        return null;
    }

    public static Method m7547(Object obj, Object obj2) {
        if (C0449ye.m9220() < 0) {
            return ((C0395oa) obj).m1295l((Class<?>) obj2);
        }
        return null;
    }

    public static String m7548(Object obj) {
        if (C0446yb.m8415() < 0) {
            return m7555(obj);
        }
        return null;
    }

    public static Method m7549(Object obj, Object obj2, Object obj3) {
        if (C0449ye.m9220() <= 0) {
            return m7554(obj, obj2, obj3);
        }
        return null;
    }

    public static Object m7550(Object obj, Object obj2, Object obj3) {
        if (C0449ye.m9220() <= 0) {
            return ((C0395oa) obj).m1297b(obj2, (Object[]) obj3);
        }
        return null;
    }

    public static Class[] m7551(Object obj) {
        if (C0459zf.m11062() >= 0) {
            return ((C0395oa) obj).f1264uA;
        }
        return null;
    }

    public static Object m7552(Object obj, Object obj2, Object obj3) {
        if (abe.m2308() <= 0) {
            return ((C0395oa) obj).m1296a(obj2, (Object[]) obj3);
        }
        return null;
    }

    public static Method m7553(Object obj, Object obj2) {
        if (C0460zg.m11287() > 0) {
            return m7557(obj, obj2);
        }
        return null;
    }

    public static Method m7554(Object obj, Object obj2, Object obj3) {
        if (C0447yc.m8786() >= 0) {
            return m7543((Class) obj, (String) obj2, (Class[]) obj3);
        }
        return null;
    }

    public static String m7555(Object obj) {
        if (C0453yj.m10032() >= 0) {
            return m7546((C0395oa) obj);
        }
        return null;
    }

    public static Class m7556(Object obj) {
        if (abe.m2321() <= 0) {
            return m7541((C0395oa) obj);
        }
        return null;
    }

    public static Method m7557(Object obj, Object obj2) {
        if (C0457zc.m10555() > 0) {
            return m7547((C0395oa) obj, (Class) obj2);
        }
        return null;
    }

    public static Class[] m7558(Object obj) {
        if (C0460zg.m11293() >= 0) {
            return m7551((C0395oa) obj);
        }
        return null;
    }

    public static Object m7559(Object obj, Object obj2, Object obj3) {
        if (abe.m2321() < 0) {
            return m7550((C0395oa) obj, obj2, (Object[]) obj3);
        }
        return null;
    }

    public static Object m7560(Object obj, Object obj2, Object obj3) {
        if (C0460zg.m11293() >= 0) {
            return m7552((C0395oa) obj, obj2, (Object[]) obj3);
        }
        return null;
    }

    public Object m1296a(T t, Object... objArr) {
        Method methodM7553 = m7553(this, gggy.m4399(t));
        if (methodM7553 == null) {
            throw new AssertionError(abc.m1925(abd.m2090(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0452yh.m9596()), m7548(this)), C0446yb.m8535()), t)));
        }
        try {
            return C0446yb.m8446(methodM7553, t, objArr);
        } catch (IllegalAccessException e) {
            AssertionError assertionError = new AssertionError(abc.m1925(abd.m2090(C0460zg.m11407(new StringBuilder(), C0453yj.m9910()), methodM7553)));
            C0461zs.m11520(assertionError, e);
            throw assertionError;
        }
    }

    public Object m1297b(T t, Object... objArr) {
        Method methodM7553 = m7553(this, gggy.m4399(t));
        if (methodM7553 == null) {
            return null;
        }
        try {
            return C0446yb.m8446(methodM7553, t, objArr);
        } catch (IllegalAccessException e) {
            return null;
        }
    }

    public Object m1298c(T t, Object... objArr) {
        try {
            return m7540(this, t, objArr);
        } catch (InvocationTargetException e) {
            Throwable thM9559 = C0450yf.m9559(e);
            if (thM9559 instanceof RuntimeException) {
                throw ((RuntimeException) thM9559);
            }
            AssertionError assertionError = new AssertionError(C0452yh.m9594());
            C0461zs.m11520(assertionError, thM9559);
            throw assertionError;
        }
    }

    public Object m1299d(T t, Object... objArr) {
        try {
            return m7545(this, t, objArr);
        } catch (InvocationTargetException e) {
            Throwable thM9559 = C0450yf.m9559(e);
            if (thM9559 instanceof RuntimeException) {
                throw ((RuntimeException) thM9559);
            }
            AssertionError assertionError = new AssertionError(C0452yh.m9594());
            C0461zs.m11520(assertionError, thM9559);
            throw assertionError;
        }
    }

    public boolean m1300l(T t) {
        return m7553(this, gggy.m4399(t)) != null;
    }
}
