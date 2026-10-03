package com.google.android.material.card2;

import java.io.IOException;
import java.io.InterruptedIOException;
import java.net.HttpRetryException;
import java.net.ProtocolException;
import java.net.SocketTimeoutException;
import java.security.cert.CertificateException;
import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.SSLHandshakeException;
import javax.net.ssl.SSLPeerUnverifiedException;
import javax.net.ssl.SSLSocketFactory;

public final class C0332lt implements InterfaceC0276jr {

    private Object f1023pP;

    private volatile boolean f1024pQ;

    private C0319lg f1025qs;

    private final C0279ju f1026qx;

    private final boolean f1027qy;

    public C0332lt(C0279ju c0279ju, boolean z) {
        this.f1026qx = c0279ju;
        this.f1027qy = z;
    }

    private boolean m1077a(C0290ke c0290ke, C0273jo c0273jo) {
        C0273jo c0273joM9070 = C0448yd.m9070(C0450yf.m9510(c0290ke));
        return C0452yh.m9583(abe.m2260(c0273joM9070), abe.m2260(c0273jo)) && C0457zc.m10643(c0273joM9070) == C0457zc.m10643(c0273jo) && C0452yh.m9583(C0445ya.m8254(c0273joM9070), C0445ya.m8254(c0273jo));
    }

    private boolean m1078a(IOException iOException, boolean z) {
        if (iOException instanceof ProtocolException) {
            return false;
        }
        if (iOException instanceof InterruptedIOException) {
            return (iOException instanceof SocketTimeoutException) && !z;
        }
        return (((iOException instanceof SSLHandshakeException) && (C0445ya.m8328(iOException) instanceof CertificateException)) || (iOException instanceof SSLPeerUnverifiedException)) ? false : true;
    }

    private boolean m1079a(IOException iOException, boolean z, C0286ka c0286ka) {
        C0452yh.m9797(C0446yb.m8514(this), iOException);
        if (C0447yc.m8796(C0457zc.m10618(this))) {
            return !(z && (C0448yd.m9039(c0286ka) instanceof InterfaceC0334lv)) && C0459zf.m11121(this, iOException, z) && abf.m2576(C0446yb.m8514(this));
        }
        return false;
    }

    private C0239ih m1080e(C0273jo c0273jo) {
        HostnameVerifier hostnameVerifierM9539;
        SSLSocketFactory sSLSocketFactoryM9662;
        C0247ip c0247ipM11073;
        if (C0458ze.m10765(c0273jo)) {
            sSLSocketFactoryM9662 = C0452yh.m9662(C0457zc.m10618(this));
            hostnameVerifierM9539 = C0450yf.m9539(C0457zc.m10618(this));
            c0247ipM11073 = C0459zf.m11073(C0457zc.m10618(this));
        } else {
            hostnameVerifierM9539 = null;
            sSLSocketFactoryM9662 = null;
            c0247ipM11073 = null;
        }
        return new C0239ih(abe.m2260(c0273jo), C0457zc.m10643(c0273jo), C0445ya.m8303(C0457zc.m10618(this)), C0449ye.m9144(C0457zc.m10618(this)), sSLSocketFactoryM9662, hostnameVerifierM9539, c0247ipM11073, gggy.m4286(C0457zc.m10618(this)), C0450yf.m9573(C0457zc.m10618(this)), abe.m2371(C0457zc.m10618(this)), C0457zc.m10641(C0457zc.m10618(this)), C0456zb.m10303(C0457zc.m10618(this)));
    }

    private C0286ka m1081j(C0290ke c0290ke) throws ProtocolException {
        String strM10588;
        C0273jo c0273joM8348;
        if (c0290ke == null) {
            throw new IllegalStateException();
        }
        C0314lb c0314lbM9803 = C0452yh.m9803(C0446yb.m8514(this));
        C0294ki c0294kiM9377 = c0314lbM9803 != null ? C0450yf.m9377(c0314lbM9803) : null;
        int iM9549 = C0450yf.m9549(c0290ke);
        String strM10517 = C0456zb.m10517(C0450yf.m9510(c0290ke));
        switch (iM9549) {
            case 300:
            case 301:
            case 302:
            case 303:
                break;
            case 307:
            case 308:
                if (!C0452yh.m9583(strM10517, C0453yj.m10028()) && !C0452yh.m9583(strM10517, abe.m2351())) {
                    return null;
                }
                break;
            case 401:
                return C0452yh.m9650(m6175(C0457zc.m10618(this)), c0294kiM9377, c0290ke);
            case 407:
                if (C0452yh.m9590(c0294kiM9377 != null ? C0452yh.m9638(c0294kiM9377) : C0450yf.m9573(C0457zc.m10618(this))) != abc.m1914()) {
                    throw new ProtocolException(C0459zf.m11044());
                }
                return C0452yh.m9650(gggy.m4286(C0457zc.m10618(this)), c0294kiM9377, c0290ke);
            case 408:
                if (!C0447yc.m8796(C0457zc.m10618(this)) || (C0448yd.m9039(C0450yf.m9510(c0290ke)) instanceof InterfaceC0334lv)) {
                    return null;
                }
                if (abd.m2056(c0290ke) == null || C0450yf.m9549(abd.m2056(c0290ke)) != 408) {
                    return C0450yf.m9510(c0290ke);
                }
                return null;
            default:
                return null;
        }
        if (!abc.m1763(C0457zc.m10618(this)) || (strM10588 = C0457zc.m10588(c0290ke, C0446yb.m8523())) == null || (c0273joM8348 = C0445ya.m8348(C0448yd.m9070(C0450yf.m9510(c0290ke)), strM10588)) == null) {
            return null;
        }
        if (!C0452yh.m9583(C0445ya.m8254(c0273joM8348), C0445ya.m8254(C0448yd.m9070(C0450yf.m9510(c0290ke)))) && !C0448yd.m9001(C0457zc.m10618(this))) {
            return null;
        }
        C0287kb c0287kbM2428 = abf.m2428(C0450yf.m9510(c0290ke));
        if (m6179(strM10517)) {
            boolean zM2075 = abd.m2075(strM10517);
            if (gggy.m4444(strM10517)) {
                C0445ya.m8297(c0287kbM2428, C0453yj.m10028(), null);
            } else {
                C0445ya.m8297(c0287kbM2428, strM10517, zM2075 ? C0448yd.m9039(C0450yf.m9510(c0290ke)) : null);
            }
            if (!zM2075) {
                abc.m1896(c0287kbM2428, gggy.m4488());
                abc.m1896(c0287kbM2428, abf.m2534());
                abc.m1896(c0287kbM2428, m6180());
            }
        }
        if (!C0446yb.m8466(this, c0290ke, c0273joM8348)) {
            abc.m1896(c0287kbM2428, abd.m2037());
        }
        return C0448yd.m8952(C0458ze.m10923(c0287kbM2428, c0273joM8348));
    }

    public static C0319lg m6166(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return ((C0332lt) obj).f1025qs;
        }
        return null;
    }

    public static C0239ih m6167(Object obj, Object obj2) {
        if (C0451yg.m9580() >= 0) {
            return ((C0332lt) obj).m1080e((C0273jo) obj2);
        }
        return null;
    }

    public static boolean m6168(Object obj, Object obj2, boolean z) {
        if (C0453yj.m10013() >= 0) {
            return ((C0332lt) obj).m1078a((IOException) obj2, z);
        }
        return false;
    }

    public static boolean m6169(Object obj) {
        if (gggy.m4269() <= 0) {
            return ((C0332lt) obj).f1024pQ;
        }
        return false;
    }

    public static Object m6170(Object obj) {
        if (C0453yj.m10013() > 0) {
            return ((C0332lt) obj).f1023pP;
        }
        return null;
    }

    public static boolean m6171(Object obj, Object obj2, Object obj3) {
        if (C0452yh.m9798() > 0) {
            return ((C0332lt) obj).m1077a((C0290ke) obj2, (C0273jo) obj3);
        }
        return false;
    }

    public static C0286ka m6172(Object obj, Object obj2) {
        if (C0457zc.m10735() < 0) {
            return ((C0332lt) obj).m1081j((C0290ke) obj2);
        }
        return null;
    }

    public static C0279ju m6173(Object obj) {
        if (C0450yf.m9352() < 0) {
            return ((C0332lt) obj).f1026qx;
        }
        return null;
    }

    public static boolean m6174(Object obj, Object obj2, boolean z, Object obj3) {
        if (C0460zg.m11287() > 0) {
            return ((C0332lt) obj).m1079a((IOException) obj2, z, (C0286ka) obj3);
        }
        return false;
    }

    public static InterfaceC0240ii m6175(Object obj) {
        if (abe.m2308() <= 0) {
            return C0598.m11864(obj);
        }
        return null;
    }

    public static boolean m6176(Object obj) {
        if (gggy.m4269() < 0) {
            return ((C0332lt) obj).f1027qy;
        }
        return false;
    }

    public static C0286ka m6177(Object obj) {
        if (C0458ze.m10932() > 0) {
            return C0598.m11789(obj);
        }
        return null;
    }

    public static InterfaceC0245in m6178(Object obj) {
        if (adds.m2755() >= 0) {
            return C0598.m11863(obj);
        }
        return null;
    }

    public static boolean m6179(Object obj) {
        if (abe.m2308() <= 0) {
            return C0598.m11870(obj);
        }
        return false;
    }

    public static String m6180() {
        if (C0458ze.m10932() >= 0) {
            return C0598.m11862();
        }
        return null;
    }

    public static C0239ih m6181(Object obj, Object obj2) {
        if (C0458ze.m10926() <= 0) {
            return m6167((C0332lt) obj, (C0273jo) obj2);
        }
        return null;
    }

    public static Object m6182(Object obj) {
        if (gggy.m4365() > 0) {
            return m6170((C0332lt) obj);
        }
        return null;
    }

    public static C0279ju m6183(Object obj) {
        if (abd.m2021() >= 0) {
            return m6173((C0332lt) obj);
        }
        return null;
    }

    public static boolean m6184(Object obj) {
        if (C0453yj.m9996() <= 0) {
            return m6176((C0332lt) obj);
        }
        return false;
    }

    public static boolean m6185(Object obj, Object obj2, boolean z, Object obj3) {
        if (C0453yj.m9945() < 0) {
            return m6174((C0332lt) obj, (IOException) obj2, z, (C0286ka) obj3);
        }
        return false;
    }

    public static boolean m6186(Object obj) {
        if (C0460zg.m11293() >= 0) {
            return m6169((C0332lt) obj);
        }
        return false;
    }

    public static C0319lg m6187(Object obj) {
        if (abd.m2021() >= 0) {
            return m6166((C0332lt) obj);
        }
        return null;
    }

    public static boolean m6188(Object obj, Object obj2, boolean z) {
        if (C0457zc.m10555() > 0) {
            return m6168((C0332lt) obj, (IOException) obj2, z);
        }
        return false;
    }

    public static C0286ka m6189(Object obj, Object obj2) {
        if (C0453yj.m10032() >= 0) {
            return m6172((C0332lt) obj, (C0290ke) obj2);
        }
        return null;
    }

    public static boolean m6190(Object obj, Object obj2, Object obj3) {
        if (abd.m2021() >= 0) {
            return m6171((C0332lt) obj, (C0290ke) obj2, (C0273jo) obj3);
        }
        return false;
    }

    @Override
    public C0290ke mo782a(InterfaceC0277js interfaceC0277js) throws IOException {
        C0286ka c0286kaM6177 = m6177(interfaceC0277js);
        C0329lq c0329lq = (C0329lq) interfaceC0277js;
        InterfaceC0245in interfaceC0245inM6178 = m6178(c0329lq);
        AbstractC0264jf abstractC0264jfM11508 = C0461zs.m11508(c0329lq);
        this.f1025qs = new C0319lg(C0453yj.m10005(C0457zc.m10618(this)), C0447yc.m8807(this, C0448yd.m9070(c0286kaM6177)), interfaceC0245inM6178, abstractC0264jfM11508, abe.m2293(this));
        C0290ke c0290keM10931 = null;
        int i = 0;
        C0286ka c0286ka = c0286kaM6177;
        while (!adds.m2887(this)) {
            try {
                try {
                    C0290ke c0290keM9119 = C0449ye.m9119(c0329lq, c0286ka, C0446yb.m8514(this), null, null);
                    c0290keM10931 = c0290keM10931 != null ? C0458ze.m10931(abd.m2136(abe.m2342(c0290keM9119), C0458ze.m10931(C0446yb.m8485(abe.m2342(c0290keM10931), null)))) : c0290keM9119;
                    C0286ka c0286kaM9958 = C0453yj.m9958(this, c0290keM10931);
                    if (c0286kaM9958 == null) {
                        if (!C0453yj.m10038(this)) {
                            C0461zs.m11651(C0446yb.m8514(this));
                        }
                        return c0290keM10931;
                    }
                    C0455za.m10070(C0453yj.m9985(c0290keM10931));
                    int i2 = i + 1;
                    if (i2 > 20) {
                        C0461zs.m11651(C0446yb.m8514(this));
                        throw new ProtocolException(abc.m1925(adds.m2680(C0460zg.m11407(new StringBuilder(), C0447yc.m8741()), i2)));
                    }
                    if (C0448yd.m9039(c0286kaM9958) instanceof InterfaceC0334lv) {
                        C0461zs.m11651(C0446yb.m8514(this));
                        throw new HttpRetryException(adds.m2812(), C0450yf.m9549(c0290keM10931));
                    }
                    if (!C0446yb.m8466(this, c0290keM10931, C0448yd.m9070(c0286kaM9958))) {
                        C0461zs.m11651(C0446yb.m8514(this));
                        this.f1025qs = new C0319lg(C0453yj.m10005(C0457zc.m10618(this)), C0447yc.m8807(this, C0448yd.m9070(c0286kaM9958)), interfaceC0245inM6178, abstractC0264jfM11508, abe.m2293(this));
                    } else if (abc.m1931(C0446yb.m8514(this)) != null) {
                        throw new IllegalStateException(abc.m1925(C0460zg.m11407(abd.m2090(C0460zg.m11407(new StringBuilder(), abd.m2192()), c0290keM10931), C0450yf.m9481())));
                    }
                    i = i2;
                    c0286ka = c0286kaM9958;
                } catch (C0316ld e) {
                    if (!C0458ze.m10859(this, C0449ye.m9324(e), false, c0286ka)) {
                        throw C0449ye.m9324(e);
                    }
                } catch (IOException e2) {
                    if (!C0458ze.m10859(this, e2, !(e2 instanceof C0345me), c0286ka)) {
                        throw e2;
                    }
                }
            } catch (Throwable th) {
                C0452yh.m9797(C0446yb.m8514(this), null);
                C0461zs.m11651(C0446yb.m8514(this));
                throw th;
            }
        }
        C0461zs.m11651(C0446yb.m8514(this));
        throw new IOException(C0453yj.m9968());
    }

    public boolean m1082da() {
        return adds.m2887(this);
    }

    public void m1083j(Object obj) {
        this.f1023pP = obj;
    }
}
