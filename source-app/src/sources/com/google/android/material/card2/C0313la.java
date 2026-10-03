package com.google.android.material.card2;

import java.io.IOException;
import java.io.InterruptedIOException;
import java.net.ProtocolException;
import java.net.UnknownServiceException;
import java.security.cert.CertificateException;
import java.util.List;
import javax.net.ssl.SSLHandshakeException;
import javax.net.ssl.SSLPeerUnverifiedException;
import javax.net.ssl.SSLProtocolException;
import javax.net.ssl.SSLSocket;

public final class C0313la {

    private final List<C0255ix> f954pj;

    private boolean f955pk;

    private boolean f956pl;

    private int f957pm = 0;

    public C0313la(List<C0255ix> list) {
        this.f954pj = list;
    }

    private boolean m993b(SSLSocket sSLSocket) {
        int iM9857 = C0453yj.m9857(this);
        while (true) {
            int i = iM9857;
            if (i >= m5961(gggy.m4346(this))) {
                return false;
            }
            if (adds.m2744((C0255ix) gggy.m4400(gggy.m4346(this), i), sSLSocket)) {
                return true;
            }
            iM9857 = i + 1;
        }
    }

    public static int m5957(Object obj) {
        if (C0457zc.m10735() < 0) {
            return ((C0313la) obj).f957pm;
        }
        return 0;
    }

    public static List m5958(Object obj) {
        if (abe.m2308() < 0) {
            return ((C0313la) obj).f954pj;
        }
        return null;
    }

    public static String[] m5959(Object obj) {
        if (C0453yj.m10013() > 0) {
            return C0598.m11855(obj);
        }
        return null;
    }

    public static boolean m5960(Object obj) {
        if (C0450yf.m9352() < 0) {
            return ((C0313la) obj).f956pl;
        }
        return false;
    }

    public static int m5961(Object obj) {
        if (C0448yd.m9079() <= 0) {
            return C0598.m11824(obj);
        }
        return 0;
    }

    public static boolean m5962(Object obj) {
        if (C0458ze.m10932() >= 0) {
            return ((C0313la) obj).f955pk;
        }
        return false;
    }

    public static boolean m5963(Object obj, Object obj2) {
        if (C0452yh.m9798() >= 0) {
            return ((C0313la) obj).m993b((SSLSocket) obj2);
        }
        return false;
    }

    public static boolean m5964(Object obj) {
        if (C0448yd.m9074() < 0) {
            return m5962((C0313la) obj);
        }
        return false;
    }

    public static List m5965(Object obj) {
        if (C0445ya.m8330() >= 0) {
            return m5958((C0313la) obj);
        }
        return null;
    }

    public static int m5966(Object obj) {
        if (C0448yd.m9074() <= 0) {
            return m5957((C0313la) obj);
        }
        return 0;
    }

    public static boolean m5967(Object obj) {
        if (C0453yj.m10032() > 0) {
            return m5960((C0313la) obj);
        }
        return false;
    }

    public static boolean m5968(Object obj, Object obj2) {
        if (C0448yd.m9074() <= 0) {
            return m5963((C0313la) obj, (SSLSocket) obj2);
        }
        return false;
    }

    public boolean m994a(IOException iOException) {
        this.f955pk = true;
        if (!C0446yb.m8416(this) || (iOException instanceof ProtocolException) || (iOException instanceof InterruptedIOException)) {
            return false;
        }
        if (((iOException instanceof SSLHandshakeException) && (C0445ya.m8328(iOException) instanceof CertificateException)) || (iOException instanceof SSLPeerUnverifiedException)) {
            return false;
        }
        return (iOException instanceof SSLHandshakeException) || (iOException instanceof SSLProtocolException);
    }

    public C0255ix m995c(SSLSocket sSLSocket) throws UnknownServiceException {
        C0255ix c0255ix;
        int iM9857 = C0453yj.m9857(this);
        int iM5961 = m5961(gggy.m4346(this));
        int i = iM9857;
        while (true) {
            if (i >= iM5961) {
                c0255ix = null;
                break;
            }
            c0255ix = (C0255ix) gggy.m4400(gggy.m4346(this), i);
            if (adds.m2744(c0255ix, sSLSocket)) {
                this.f957pm = i + 1;
                break;
            }
            i++;
        }
        if (c0255ix == null) {
            throw new UnknownServiceException(abc.m1925(C0460zg.m11407(C0460zg.m11407(abd.m2090(C0460zg.m11407(abd.m2164(C0460zg.m11407(new StringBuilder(), C0445ya.m8399()), C0460zg.m11345(this)), C0448yd.m9053()), gggy.m4346(this)), adds.m2720()), C0461zs.m11560(m5959(sSLSocket)))));
        }
        this.f956pl = C0445ya.m8278(this, sSLSocket);
        C0458ze.m10846(adds.m2768(), c0255ix, sSLSocket, C0460zg.m11345(this));
        return c0255ix;
    }
}
