package com.google.android.material.card2;

import java.io.IOException;
import java.net.SocketTimeoutException;

class C0376ni extends C0404oj {

    final C0373nf f1217tG;

    C0376ni(C0373nf c0373nf) {
        this.f1217tG = c0373nf;
    }

    public static C0373nf m7281(Object obj) {
        if (abf.m2510() <= 0) {
            return m7290(obj);
        }
        return null;
    }

    public static int m7282() {
        if (C0446yb.m8415() < 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static Throwable m7283(Object obj, Object obj2) {
        if (C0453yj.m10013() > 0) {
            return C0598.m11826(obj, obj2);
        }
        return null;
    }

    public static boolean m7284(Object obj) {
        if (adds.m2755() >= 0) {
            return ((C0376ni) obj).m1336ft();
        }
        return false;
    }

    public static IOException m7285(Object obj, Object obj2) {
        if (C0458ze.m10932() >= 0) {
            return m7289(obj, obj2);
        }
        return null;
    }

    public static boolean m7286(Object obj) {
        if (C0450yf.m9352() < 0) {
            return m7291(obj);
        }
        return false;
    }

    public static IOException m7287(Object obj, Object obj2) {
        if (gggy.m4269() < 0) {
            return ((C0376ni) obj).mo1225e((IOException) obj2);
        }
        return null;
    }

    public static C0373nf m7288(Object obj) {
        if (C0457zc.m10735() <= 0) {
            return ((C0376ni) obj).f1217tG;
        }
        return null;
    }

    public static IOException m7289(Object obj, Object obj2) {
        if (C0453yj.m10032() >= 0) {
            return m7287((C0376ni) obj, (IOException) obj2);
        }
        return null;
    }

    public static C0373nf m7290(Object obj) {
        if (C0456zb.m10484() <= 0) {
            return m7288((C0376ni) obj);
        }
        return null;
    }

    public static boolean m7291(Object obj) {
        if (m7282() > 0) {
            return m7284((C0376ni) obj);
        }
        return false;
    }

    @Override
    protected IOException mo1225e(IOException iOException) {
        SocketTimeoutException socketTimeoutException = new SocketTimeoutException(abf.m2593());
        if (iOException != null) {
            m7283(socketTimeoutException, iOException);
        }
        return socketTimeoutException;
    }

    public void m1226eR() {
        if (m7286(this)) {
            throw m7285(this, null);
        }
    }

    @Override
    protected void mo1227eS() {
        C0455za.m10191(m7281(this), C0456zb.m10363());
    }
}
