package com.google.android.material.card2;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.security.cert.TrustAnchor;
import java.security.cert.X509Certificate;
import javax.net.ssl.X509TrustManager;

final class C0389nv implements InterfaceC0403oi {

    private final Method f1248uk;

    private final X509TrustManager f1249ul;

    C0389nv(X509TrustManager x509TrustManager, Method method) {
        this.f1248uk = method;
        this.f1249ul = x509TrustManager;
    }

    public static Method m7478(Object obj) {
        if (C0453yj.m10013() > 0) {
            return ((C0389nv) obj).f1248uk;
        }
        return null;
    }

    public static Method m7479(Object obj) {
        if (C0459zf.m11062() > 0) {
            return m7483(obj);
        }
        return null;
    }

    public static X509TrustManager m7480(Object obj) {
        if (C0459zf.m11062() > 0) {
            return m7482(obj);
        }
        return null;
    }

    public static X509TrustManager m7481(Object obj) {
        if (C0445ya.m8222() > 0) {
            return ((C0389nv) obj).f1249ul;
        }
        return null;
    }

    public static X509TrustManager m7482(Object obj) {
        if (C0447yc.m8786() >= 0) {
            return m7481((C0389nv) obj);
        }
        return null;
    }

    public static Method m7483(Object obj) {
        if (C0453yj.m9996() < 0) {
            return m7478((C0389nv) obj);
        }
        return null;
    }

    @Override
    public X509Certificate mo1286c(X509Certificate x509Certificate) {
        try {
            TrustAnchor trustAnchor = (TrustAnchor) C0446yb.m8446(m7479(this), m7480(this), new Object[]{x509Certificate});
            if (trustAnchor != null) {
                return C0458ze.m10857(trustAnchor);
            }
            return null;
        } catch (IllegalAccessException e) {
            throw C0445ya.m8385(C0461zs.m11438(), e);
        } catch (InvocationTargetException e2) {
            return null;
        }
    }

    public boolean equals(Object obj) {
        if (obj != this) {
            if (!(obj instanceof C0389nv)) {
                return false;
            }
            C0389nv c0389nv = (C0389nv) obj;
            if (!C0459zf.m11147(m7480(this), m7480(c0389nv)) || !C0460zg.m11274(m7479(this), m7479(c0389nv))) {
                return false;
            }
        }
        return true;
    }

    public int hashCode() {
        return C0446yb.m8544(m7480(this)) + (C0448yd.m8992(m7479(this)) * 31);
    }
}
