package com.google.android.material.card2;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.security.cert.Certificate;
import java.security.cert.X509Certificate;
import java.util.List;
import javax.net.ssl.SSLPeerUnverifiedException;

final class C0388nu extends AbstractC0400of {

    private final Method f1246ui;

    private final Object f1247uj;

    C0388nu(Object obj, Method method) {
        this.f1247uj = obj;
        this.f1246ui = method;
    }

    public static Object m7471(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return ((C0388nu) obj).f1247uj;
        }
        return null;
    }

    public static int m7472(Object obj) {
        if (C0450yf.m9352() < 0) {
            return C0598.m11824(obj);
        }
        return 0;
    }

    public static Method m7473(Object obj) {
        if (C0450yf.m9352() < 0) {
            return ((C0388nu) obj).f1246ui;
        }
        return null;
    }

    public static Object m7474(Object obj) {
        if (C0458ze.m10932() > 0) {
            return m7476(obj);
        }
        return null;
    }

    public static Method m7475(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return m7477(obj);
        }
        return null;
    }

    public static Object m7476(Object obj) {
        if (C0460zg.m11293() >= 0) {
            return m7471((C0388nu) obj);
        }
        return null;
    }

    public static Method m7477(Object obj) {
        if (C0447yc.m8786() >= 0) {
            return m7473((C0388nu) obj);
        }
        return null;
    }

    @Override
    public List<Certificate> mo1285a(List<Certificate> list, String str) throws SSLPeerUnverifiedException {
        try {
            return (List) C0446yb.m8446(m7475(this), m7474(this), new Object[]{(X509Certificate[]) C0456zb.m10507(list, new X509Certificate[m7472(list)]), C0448yd.m8907(), str});
        } catch (IllegalAccessException e) {
            throw new AssertionError(e);
        } catch (InvocationTargetException e2) {
            SSLPeerUnverifiedException sSLPeerUnverifiedException = new SSLPeerUnverifiedException(C0449ye.m9295(e2));
            C0453yj.m9997(sSLPeerUnverifiedException, e2);
            throw sSLPeerUnverifiedException;
        }
    }

    public boolean equals(Object obj) {
        return obj instanceof C0388nu;
    }

    public int hashCode() {
        return 0;
    }
}
