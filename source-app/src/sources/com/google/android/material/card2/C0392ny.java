package com.google.android.material.card2;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.List;
import javax.net.ssl.SSLSocket;

class C0392ny extends C0396ob {

    private final Class<?> f1255ur;

    private final Method f1256us;

    private final Method f1257ut;

    private final Method f1258uu;

    private final Class<?> f1259uv;

    C0392ny(Method method, Method method2, Method method3, Class<?> cls, Class<?> cls2) {
        this.f1257ut = method;
        this.f1256us = method2;
        this.f1258uu = method3;
        this.f1255ur = cls;
        this.f1259uv = cls2;
    }

    public static C0396ob m1291fc() {
        try {
            Class clsM9289 = C0449ye.m9289(C0448yd.m8977());
            Class clsM92810 = C0449ye.m9289(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0448yd.m8977()), abf.m2457())));
            return new C0392ny(C0461zs.m11528(clsM9289, C0457zc.m10612(), new Class[]{SSLSocket.class, clsM92810}), C0461zs.m11528(clsM9289, C0450yf.m9551(), new Class[]{SSLSocket.class}), C0461zs.m11528(clsM9289, C0450yf.m9533(), new Class[]{SSLSocket.class}), C0449ye.m9289(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0448yd.m8977()), abc.m1883()))), C0449ye.m9289(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0448yd.m8977()), C0457zc.m10616()))));
        } catch (ClassNotFoundException | NoSuchMethodException e) {
            return null;
        }
    }

    public static boolean m7503(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return m7526(obj);
        }
        return false;
    }

    public static String m7504(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return m7523(obj);
        }
        return null;
    }

    public static List m7505(Object obj) {
        if (C0452yh.m9798() >= 0) {
            return m1301f((List) obj);
        }
        return null;
    }

    public static List m7506(Object obj) {
        if (C0459zf.m11062() > 0) {
            return m7521(obj);
        }
        return null;
    }

    public static Method m7507(Object obj) {
        if (C0453yj.m10013() > 0) {
            return ((C0392ny) obj).f1258uu;
        }
        return null;
    }

    public static Method m7508(Object obj) {
        if (adds.m2755() >= 0) {
            return ((C0392ny) obj).f1257ut;
        }
        return null;
    }

    public static String m7509(Object obj) {
        if (abd.m2162() > 0) {
            return ((C0393nz) obj).f1261ux;
        }
        return null;
    }

    public static Method m7510(Object obj) {
        if (adds.m2755() >= 0) {
            return m7524(obj);
        }
        return null;
    }

    public static Method m7511(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return m7525(obj);
        }
        return null;
    }

    public static Class m7512(Object obj) {
        if (C0450yf.m9352() <= 0) {
            return ((C0392ny) obj).f1255ur;
        }
        return null;
    }

    public static Class m7513(Object obj) {
        if (C0459zf.m11062() > 0) {
            return ((C0392ny) obj).f1259uv;
        }
        return null;
    }

    public static Class m7514(Object obj) {
        if (C0445ya.m8222() > 0) {
            return m7519(obj);
        }
        return null;
    }

    public static boolean m7515(Object obj) {
        if (C0456zb.m10326() < 0) {
            return ((C0393nz) obj).f1262uy;
        }
        return false;
    }

    public static Method m7516(Object obj) {
        if (C0452yh.m9798() > 0) {
            return m7520(obj);
        }
        return null;
    }

    public static Class m7517(Object obj) {
        if (gggy.m4269() < 0) {
            return m7522(obj);
        }
        return null;
    }

    public static Method m7518(Object obj) {
        if (C0452yh.m9798() >= 0) {
            return ((C0392ny) obj).f1256us;
        }
        return null;
    }

    public static Class m7519(Object obj) {
        if (abe.m2321() < 0) {
            return m7512((C0392ny) obj);
        }
        return null;
    }

    public static Method m7520(Object obj) {
        if (C0445ya.m8330() > 0) {
            return m7507((C0392ny) obj);
        }
        return null;
    }

    public static List m7521(Object obj) {
        if (C0453yj.m9945() < 0) {
            return m7505((List) obj);
        }
        return null;
    }

    public static Class m7522(Object obj) {
        if (abf.m2500() > 0) {
            return m7513((C0392ny) obj);
        }
        return null;
    }

    public static String m7523(Object obj) {
        if (C0448yd.m9015() <= 0) {
            return m7509((C0393nz) obj);
        }
        return null;
    }

    public static Method m7524(Object obj) {
        if (gggy.m4365() >= 0) {
            return m7508((C0392ny) obj);
        }
        return null;
    }

    public static Method m7525(Object obj) {
        if (C0453yj.m9996() < 0) {
            return m7518((C0392ny) obj);
        }
        return null;
    }

    public static boolean m7526(Object obj) {
        if (C0448yd.m9074() <= 0) {
            return m7515((C0393nz) obj);
        }
        return false;
    }

    @Override
    public void mo1279a(SSLSocket sSLSocket, String str, List<EnumC0282jx> list) {
        List listM7506 = m7506(list);
        try {
            ClassLoader classLoaderM8933 = C0448yd.m8933(C0396ob.class);
            Class clsM7514 = m7514(this);
            Class clsM7517 = m7517(this);
            C0446yb.m8446(m7510(this), null, new Object[]{sSLSocket, abc.m1849(classLoaderM8933, new Class[]{clsM7514, clsM7517}, new C0393nz(listM7506))});
        } catch (IllegalAccessException | InvocationTargetException e) {
            throw C0445ya.m8385(C0460zg.m11401(), e);
        }
    }

    @Override
    public String mo1284d(SSLSocket sSLSocket) {
        try {
            C0393nz c0393nz = (C0393nz) C0448yd.m9082(C0446yb.m8446(m7511(this), null, new Object[]{sSLSocket}));
            if (!m7503(c0393nz) && m7504(c0393nz) == null) {
                C0456zb.m10481(C0455za.m10101(), 4, C0449ye.m9169(), null);
                return null;
            }
            if (m7503(c0393nz)) {
                return null;
            }
            return m7504(c0393nz);
        } catch (IllegalAccessException | InvocationTargetException e) {
            throw C0445ya.m8385(C0457zc.m10661(), e);
        }
    }

    @Override
    public void mo1292e(SSLSocket sSLSocket) {
        try {
            C0446yb.m8446(m7516(this), null, new Object[]{sSLSocket});
        } catch (IllegalAccessException | InvocationTargetException e) {
            throw C0445ya.m8385(C0447yc.m8830(), e);
        }
    }
}
