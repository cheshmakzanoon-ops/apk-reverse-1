package com.google.android.material.card2;

import java.net.InetSocketAddress;
import java.net.Socket;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import javax.net.ssl.SSLSocket;
import javax.net.ssl.X509TrustManager;

public class C0396ob {

    private static final C0396ob f1267uC = C0460zg.m11424();

    private static final Logger f1268uD = C0460zg.m11225(C0456zb.m10455(C0279ju.class));

    public static List<String> m1301f(List<EnumC0282jx> list) {
        ArrayList arrayList = new ArrayList(m7568(list));
        int iM7568 = m7568(list);
        for (int i = 0; i < iM7568; i++) {
            EnumC0282jx enumC0282jx = (EnumC0282jx) gggy.m4400(list, i);
            if (enumC0282jx != adds.m2783()) {
                C0460zg.m11251(arrayList, C0460zg.m11228(enumC0282jx));
            }
        }
        return arrayList;
    }

    private static C0396ob m1302fg() {
        C0396ob c0396obM9323 = C0449ye.m9323();
        if (c0396obM9323 != null) {
            return c0396obM9323;
        }
        C0391nx c0391nxM7566 = m7566();
        if (c0391nxM7566 != null) {
            return c0391nxM7566;
        }
        C0396ob c0396obM10075 = C0455za.m10075();
        return c0396obM10075 == null ? new C0396ob() : c0396obM10075;
    }

    public static C0396ob m1303fh() {
        return gggy.m4347();
    }

    static byte[] m1304g(List<EnumC0282jx> list) {
        C0409oo c0409oo = new C0409oo();
        int iM7568 = m7568(list);
        for (int i = 0; i < iM7568; i++) {
            EnumC0282jx enumC0282jx = (EnumC0282jx) gggy.m4400(list, i);
            if (enumC0282jx != adds.m2783()) {
                C0447yc.m8844(c0409oo, gggy.m4397(C0460zg.m11228(enumC0282jx)));
                C0457zc.m10684(c0409oo, C0460zg.m11228(enumC0282jx));
            }
        }
        return C0457zc.m10533(c0409oo);
    }

    public static C0391nx m7561() {
        if (abe.m2308() <= 0) {
            return C0391nx.m1290ff();
        }
        return null;
    }

    public static C0396ob m7562() {
        if (C0460zg.m11287() >= 0) {
            return f1267uC;
        }
        return null;
    }

    public static C0396ob m7563() {
        if (abf.m2510() < 0) {
            return C0387nt.m1273fc();
        }
        return null;
    }

    public static Logger m7564() {
        if (C0458ze.m10932() > 0) {
            return f1268uD;
        }
        return null;
    }

    public static int m7565() {
        if (C0446yb.m8415() < 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static C0391nx m7566() {
        if (C0452yh.m9798() > 0) {
            return m7574();
        }
        return null;
    }

    public static C0396ob m7567() {
        if (C0451yg.m9580() >= 0) {
            return C0392ny.m1291fc();
        }
        return null;
    }

    public static int m7568(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return C0598.m11824(obj);
        }
        return 0;
    }

    public static C0396ob m7569() {
        if (C0456zb.m10326() < 0) {
            return m1302fg();
        }
        return null;
    }

    public static C0396ob m7570() {
        if (C0460zg.m11293() >= 0) {
            return m7569();
        }
        return null;
    }

    public static C0396ob m7571() {
        if (m7565() > 0) {
            return m7562();
        }
        return null;
    }

    public static C0396ob m7572() {
        if (C0448yd.m9074() < 0) {
            return m7563();
        }
        return null;
    }

    public static C0396ob m7573() {
        if (C0460zg.m11293() > 0) {
            return m7567();
        }
        return null;
    }

    public static C0391nx m7574() {
        if (C0453yj.m9966() > 0) {
            return m7561();
        }
        return null;
    }

    public static Logger m7575() {
        if (m7565() > 0) {
            return m7564();
        }
        return null;
    }

    public void mo1276a(int i, String str, Throwable th) {
        C0455za.m10051(C0447yc.m8719(), i == 5 ? C0455za.m10136() : C0446yb.m8576(), str, th);
    }

    public void mo1277a(String str, Object obj) {
        String strM1925 = str;
        if (obj == null) {
            strM1925 = abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), strM1925), abe.m2400()));
        }
        C0456zb.m10481(this, 5, strM1925, (Throwable) obj);
    }

    public void mo1278a(Socket socket, InetSocketAddress inetSocketAddress, int i) {
        C0452yh.m9737(socket, inetSocketAddress, i);
    }

    public void mo1279a(SSLSocket sSLSocket, String str, List<EnumC0282jx> list) {
    }

    public Object mo1280ah(String str) {
        if (C0450yf.m9421(C0447yc.m8719(), C0447yc.m8836())) {
            return new Throwable(str);
        }
        return null;
    }

    public boolean mo1281ai(String str) {
        return true;
    }

    public AbstractC0400of mo1282b(X509TrustManager x509TrustManager) {
        return new C0398od(abd.m2018(this, x509TrustManager));
    }

    public InterfaceC0403oi mo1283c(X509TrustManager x509TrustManager) {
        return new C0399oe(abd.m2140(x509TrustManager));
    }

    public String mo1284d(SSLSocket sSLSocket) {
        return null;
    }

    public void mo1292e(SSLSocket sSLSocket) {
    }
}
