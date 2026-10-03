package com.google.android.material.card2;

import java.io.IOException;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.Proxy;
import java.net.SocketAddress;
import java.net.SocketException;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.List;
import java.util.NoSuchElementException;

public final class C0317le {

    private final C0239ih f975pC;

    private final InterfaceC0245in f976pD;

    private final AbstractC0264jf f977pE;

    private int f979pG;

    private final C0315lc f982pJ;

    private List<Proxy> f981pI = C0461zs.m11607();

    private List<InetSocketAddress> f978pF = C0461zs.m11607();

    private final List<C0294ki> f980pH = new ArrayList();

    public C0317le(C0239ih c0239ih, C0315lc c0315lc, InterfaceC0245in interfaceC0245in, AbstractC0264jf abstractC0264jf) {
        this.f975pC = c0239ih;
        this.f982pJ = c0315lc;
        this.f976pD = interfaceC0245in;
        this.f977pE = abstractC0264jf;
        C0458ze.m10970(this, C0461zs.m11456(c0239ih), C0448yd.m8922(c0239ih));
    }

    static String m1019a(InetSocketAddress inetSocketAddress) {
        InetAddress inetAddressM2345 = abe.m2345(inetSocketAddress);
        return inetAddressM2345 == null ? C0458ze.m10793(inetSocketAddress) : C0452yh.m9783(inetAddressM2345);
    }

    private void m1020a(C0273jo c0273jo, Proxy proxy) {
        if (proxy != null) {
            this.f981pI = abc.m1886(proxy);
        } else {
            List listM8326 = C0445ya.m8326(C0455za.m10109(C0449ye.m9158(this)), C0450yf.m9358(c0273jo));
            this.f981pI = (listM8326 == null || C0452yh.m9618(listM8326)) ? abe.m2380(new Proxy[]{C0455za.m10122()}) : C0456zb.m10446(listM8326);
        }
        this.f979pG = 0;
    }

    private void m1021a(Proxy proxy) throws SocketException, UnknownHostException {
        String strM2260;
        int iM10643;
        this.f978pF = new ArrayList();
        if (C0452yh.m9590(proxy) == C0460zg.m11283() || C0452yh.m9590(proxy) == C0455za.m10090()) {
            strM2260 = abe.m2260(C0461zs.m11456(C0449ye.m9158(this)));
            iM10643 = C0457zc.m10643(C0461zs.m11456(C0449ye.m9158(this)));
        } else {
            SocketAddress socketAddressM9907 = C0453yj.m9907(proxy);
            if (!(socketAddressM9907 instanceof InetSocketAddress)) {
                throw new IllegalArgumentException(abc.m1925(abd.m2090(C0460zg.m11407(new StringBuilder(), C0450yf.m9543()), gggy.m4399(socketAddressM9907))));
            }
            InetSocketAddress inetSocketAddress = (InetSocketAddress) socketAddressM9907;
            String strM9766 = C0452yh.m9766(inetSocketAddress);
            iM10643 = C0458ze.m10773(inetSocketAddress);
            strM2260 = strM9766;
        }
        if (iM10643 < 1 || iM10643 > 65535) {
            throw new SocketException(abc.m1925(C0460zg.m11407(adds.m2680(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0447yc.m8731()), strM2260), C0449ye.m9248()), iM10643), C0460zg.m11284())));
        }
        if (C0452yh.m9590(proxy) == C0455za.m10090()) {
            C0460zg.m11251(C0455za.m10092(this), C0447yc.m8704(strM2260, iM10643));
            return;
        }
        C0446yb.m8462(abc.m1907(this), C0457zc.m10704(this), strM2260);
        List listM11556 = C0461zs.m11556(C0452yh.m9697(C0449ye.m9158(this)), strM2260);
        if (C0452yh.m9618(listM11556)) {
            throw new UnknownHostException(abc.m1925(C0460zg.m11407(C0460zg.m11407(abd.m2090(new StringBuilder(), C0452yh.m9697(C0449ye.m9158(this))), C0455za.m10272()), strM2260)));
        }
        m6029(abc.m1907(this), C0457zc.m10704(this), strM2260, listM11556);
        int iM6024 = m6024(listM11556);
        for (int i = 0; i < iM6024; i++) {
            C0460zg.m11251(C0455za.m10092(this), new InetSocketAddress((InetAddress) gggy.m4400(listM11556, i), iM10643));
        }
    }

    private boolean m1022dR() {
        return abc.m1976(this) < m6024(C0455za.m10218(this));
    }

    private Proxy m1023dS() throws SocketException {
        if (!C0459zf.m11116(this)) {
            throw new SocketException(abc.m1925(abd.m2090(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0447yc.m8731()), abe.m2260(C0461zs.m11456(C0449ye.m9158(this)))), C0460zg.m11303()), C0455za.m10218(this))));
        }
        List listM10218 = C0455za.m10218(this);
        int iM1976 = abc.m1976(this);
        this.f979pG = iM1976 + 1;
        Proxy proxy = (Proxy) gggy.m4400(listM10218, iM1976);
        C0450yf.m9558(this, proxy);
        return proxy;
    }

    public static InterfaceC0245in m6016(Object obj) {
        if (C0448yd.m9079() < 0) {
            return ((C0317le) obj).f976pD;
        }
        return null;
    }

    public static C0315lc m6017(Object obj) {
        if (C0459zf.m11062() >= 0) {
            return ((C0317le) obj).f982pJ;
        }
        return null;
    }

    public static String m6018(Object obj) {
        if (gggy.m4269() <= 0) {
            return m1019a((InetSocketAddress) obj);
        }
        return null;
    }

    public static AbstractC0264jf m6019(Object obj) {
        if (C0448yd.m9079() <= 0) {
            return ((C0317le) obj).f977pE;
        }
        return null;
    }

    public static void m6020(Object obj, Object obj2, Object obj3) {
        if (C0457zc.m10735() < 0) {
            ((C0317le) obj).m1020a((C0273jo) obj2, (Proxy) obj3);
        }
    }

    public static boolean m6021(Object obj) {
        if (abc.m1845() < 0) {
            return ((C0317le) obj).m1022dR();
        }
        return false;
    }

    public static List m6022(Object obj) {
        if (C0449ye.m9220() < 0) {
            return ((C0317le) obj).f981pI;
        }
        return null;
    }

    public static List m6023(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return ((C0317le) obj).f980pH;
        }
        return null;
    }

    public static int m6024(Object obj) {
        if (abc.m1845() < 0) {
            return C0598.m11824(obj);
        }
        return 0;
    }

    public static void m6025(Object obj, Object obj2) throws SocketException, UnknownHostException {
        if (gggy.m4269() < 0) {
            ((C0317le) obj).m1021a((Proxy) obj2);
        }
    }

    public static List m6026(Object obj) {
        if (adds.m2755() >= 0) {
            return ((C0317le) obj).f978pF;
        }
        return null;
    }

    public static C0239ih m6027(Object obj) {
        if (abf.m2510() < 0) {
            return ((C0317le) obj).f975pC;
        }
        return null;
    }

    public static int m6028(Object obj) {
        if (C0459zf.m11062() >= 0) {
            return ((C0317le) obj).f979pG;
        }
        return 0;
    }

    public static void m6029(Object obj, Object obj2, Object obj3, Object obj4) {
        if (C0453yj.m10013() >= 0) {
            C0598.m11877(obj, obj2, obj3, obj4);
        }
    }

    public static void m6030(Object obj, Object obj2) {
        if (C0445ya.m8222() >= 0) {
            C0598.m11890(obj, obj2);
        }
    }

    public static Proxy m6031(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return ((C0317le) obj).m1023dS();
        }
        return null;
    }

    public static int m6032() {
        if (C0458ze.m10932() > 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static C0239ih m6033(Object obj) {
        if (C0457zc.m10555() > 0) {
            return m6027((C0317le) obj);
        }
        return null;
    }

    public static void m6034(Object obj, Object obj2) {
        if (C0453yj.m9966() >= 0) {
            m6025((C0317le) obj, (Proxy) obj2);
        }
    }

    public static String m6035(Object obj) {
        if (C0448yd.m9015() < 0) {
            return m6018((InetSocketAddress) obj);
        }
        return null;
    }

    public static List m6036(Object obj) {
        if (abd.m2166() <= 0) {
            return m6026((C0317le) obj);
        }
        return null;
    }

    public static Proxy m6037(Object obj) {
        if (C0453yj.m10032() > 0) {
            return m6031((C0317le) obj);
        }
        return null;
    }

    public static boolean m6038(Object obj) {
        if (C0457zc.m10718() < 0) {
            return m6021((C0317le) obj);
        }
        return false;
    }

    public static List m6039(Object obj) {
        if (C0447yc.m8786() >= 0) {
            return m6022((C0317le) obj);
        }
        return null;
    }

    public static void m6040(Object obj, Object obj2, Object obj3) {
        if (C0448yd.m9074() <= 0) {
            m6020((C0317le) obj, (C0273jo) obj2, (Proxy) obj3);
        }
    }

    public static List m6041(Object obj) {
        if (C0460zg.m11293() > 0) {
            return m6023((C0317le) obj);
        }
        return null;
    }

    public static AbstractC0264jf m6042(Object obj) {
        if (m6032() > 0) {
            return m6019((C0317le) obj);
        }
        return null;
    }

    public static int m6043(Object obj) {
        if (C0453yj.m10032() >= 0) {
            return m6028((C0317le) obj);
        }
        return 0;
    }

    public static C0315lc m6044(Object obj) {
        if (abd.m2166() <= 0) {
            return m6017((C0317le) obj);
        }
        return null;
    }

    public static InterfaceC0245in m6045(Object obj) {
        if (C0445ya.m8330() >= 0) {
            return m6016((C0317le) obj);
        }
        return null;
    }

    public void m1024a(C0294ki c0294ki, IOException iOException) {
        if (C0452yh.m9590(C0452yh.m9638(c0294ki)) != C0460zg.m11283() && C0455za.m10109(C0449ye.m9158(this)) != null) {
            C0455za.m10073(C0455za.m10109(C0449ye.m9158(this)), C0450yf.m9358(C0461zs.m11456(C0449ye.m9158(this))), C0453yj.m9907(C0452yh.m9638(c0294ki)), iOException);
        }
        m6030(C0450yf.m9507(this), c0294ki);
    }

    public C0318lf m1025dT() {
        if (!C0449ye.m9210(this)) {
            throw new NoSuchElementException();
        }
        ArrayList arrayList = new ArrayList();
        while (C0459zf.m11116(this)) {
            Proxy proxyM9591 = C0452yh.m9591(this);
            int iM6024 = m6024(C0455za.m10092(this));
            for (int i = 0; i < iM6024; i++) {
                C0294ki c0294ki = new C0294ki(C0449ye.m9158(this), proxyM9591, (InetSocketAddress) gggy.m4400(C0455za.m10092(this), i));
                if (C0445ya.m8373(C0450yf.m9507(this), c0294ki)) {
                    C0460zg.m11251(adds.m2810(this), c0294ki);
                } else {
                    C0460zg.m11251(arrayList, c0294ki);
                }
            }
            if (!C0452yh.m9618(arrayList)) {
                break;
            }
        }
        if (C0452yh.m9618(arrayList)) {
            C0447yc.m8634(arrayList, adds.m2810(this));
            C0450yf.m9419(adds.m2810(this));
        }
        return new C0318lf(arrayList);
    }

    public boolean hasNext() {
        return C0459zf.m11116(this) || !C0452yh.m9618(adds.m2810(this));
    }
}
