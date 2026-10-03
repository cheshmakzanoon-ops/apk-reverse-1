package com.google.android.material.card2;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.List;
import javax.net.ssl.SSLParameters;
import javax.net.ssl.SSLSocket;

final class C0391nx extends C0396ob {

    final Method f1253up;

    final Method f1254uq;

    C0391nx(Method method, Method method2) {
        this.f1254uq = method;
        this.f1253up = method2;
    }

    public static C0391nx m1290ff() {
        try {
            return new C0391nx(C0461zs.m11528(SSLParameters.class, C0461zs.m11615(), new Class[]{String[].class}), C0461zs.m11528(SSLSocket.class, C0446yb.m8591(), new Class[0]));
        } catch (NoSuchMethodException e) {
            return null;
        }
    }

    public static Method m7493(Object obj) {
        if (abf.m2510() <= 0) {
            return ((C0391nx) obj).f1253up;
        }
        return null;
    }

    public static List m7494(Object obj) {
        if (C0453yj.m10013() > 0) {
            return m7501(obj);
        }
        return null;
    }

    public static List m7495(Object obj) {
        if (C0448yd.m9079() <= 0) {
            return m1301f((List) obj);
        }
        return null;
    }

    public static Method m7496(Object obj) {
        if (C0461zs.m11510() < 0) {
            return m7500(obj);
        }
        return null;
    }

    public static Method m7497(Object obj) {
        if (C0446yb.m8415() <= 0) {
            return m7502(obj);
        }
        return null;
    }

    public static Method m7498(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return ((C0391nx) obj).f1254uq;
        }
        return null;
    }

    public static int m7499(Object obj) {
        if (gggy.m4269() <= 0) {
            return C0598.m11824(obj);
        }
        return 0;
    }

    public static Method m7500(Object obj) {
        if (C0460zg.m11293() > 0) {
            return m7493((C0391nx) obj);
        }
        return null;
    }

    public static List m7501(Object obj) {
        if (C0453yj.m10032() > 0) {
            return m7495((List) obj);
        }
        return null;
    }

    public static Method m7502(Object obj) {
        if (C0457zc.m10555() > 0) {
            return m7498((C0391nx) obj);
        }
        return null;
    }

    @Override
    public void mo1279a(SSLSocket sSLSocket, String str, List<EnumC0282jx> list) {
        try {
            SSLParameters sSLParametersM8874 = C0448yd.m8874(sSLSocket);
            List listM7494 = m7494(list);
            C0446yb.m8446(m7497(this), sSLParametersM8874, new Object[]{C0456zb.m10507(listM7494, new String[m7499(listM7494)])});
            C0455za.m10046(sSLSocket, sSLParametersM8874);
        } catch (IllegalAccessException | InvocationTargetException e) {
            throw C0445ya.m8385(gggy.m4370(), e);
        }
    }

    @Override
    public String mo1284d(SSLSocket sSLSocket) {
        try {
            String str = (String) C0446yb.m8446(m7496(this), sSLSocket, new Object[0]);
            if (str == null || C0452yh.m9583(str, gggy.m4277())) {
                return null;
            }
            return str;
        } catch (IllegalAccessException | InvocationTargetException e) {
            throw C0445ya.m8385(adds.m2741(), e);
        }
    }
}
