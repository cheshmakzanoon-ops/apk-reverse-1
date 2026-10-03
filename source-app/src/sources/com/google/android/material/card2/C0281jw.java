package com.google.android.material.card2;

import java.net.Proxy;
import java.net.ProxySelector;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;
import javax.annotation.Nullable;
import javax.net.SocketFactory;
import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.X509TrustManager;

public final class C0281jw {

    @Nullable
    Proxy f773hW;

    @Nullable
    SSLSocketFactory f777ia;

    @Nullable
    InterfaceC0310ky f778ie;

    @Nullable
    AbstractC0400of f779iv;

    @Nullable
    C0242ik f790ms;

    final List<InterfaceC0276jr> f787mS = new ArrayList();

    final List<InterfaceC0276jr> f788mT = new ArrayList();

    C0261jc f794mz = new C0261jc();

    List<EnumC0282jx> f772hV = abf.m2609();

    List<C0255ix> f769hS = C0452yh.m9710();

    InterfaceC0267ji f780mB = C0446yb.m8555(C0460zg.m11285());

    ProxySelector f775hY = C0447yc.m8691();

    InterfaceC0259ja f793my = C0453yj.m9922();

    SocketFactory f776hZ = C0459zf.m11142();

    HostnameVerifier f771hU = C0445ya.m8350();

    C0247ip f768hR = C0461zs.m11482();

    InterfaceC0240ii f774hX = m5467();

    InterfaceC0240ii f789mr = m5467();

    C0253iv f792mw = new C0253iv();

    InterfaceC0262jd f770hT = adds.m2674();

    boolean f782mD = true;

    boolean f781mC = true;

    boolean f785mO = true;

    int f791mv = 10000;

    int f784mN = 10000;

    int f786mR = 10000;

    int f783mI = 0;

    public static List m5465() {
        if (adds.m2755() >= 0) {
            return C0279ju.f739mp;
        }
        return null;
    }

    public static List m5466() {
        if (abc.m1845() <= 0) {
            return C0279ju.f740mq;
        }
        return null;
    }

    public static InterfaceC0240ii m5467() {
        if (C0446yb.m8415() < 0) {
            return C0598.m11886();
        }
        return null;
    }

    public static InterfaceC0267ji m5468(Object obj) {
        if (C0459zf.m11062() > 0) {
            return AbstractC0264jf.m686a((AbstractC0264jf) obj);
        }
        return null;
    }

    public static InterfaceC0267ji m5469(Object obj) {
        if (C0448yd.m9015() <= 0) {
            return m5468((AbstractC0264jf) obj);
        }
        return null;
    }

    public static List m5470() {
        if (C0445ya.m8330() >= 0) {
            return m5465();
        }
        return null;
    }

    public static List m5471() {
        if (C0458ze.m10926() <= 0) {
            return m5466();
        }
        return null;
    }

    public C0281jw m828a(long j, TimeUnit timeUnit) {
        this.f791mv = C0458ze.m10878(abf.m2593(), j, timeUnit);
        return this;
    }

    public C0281jw m829a(HostnameVerifier hostnameVerifier) {
        if (hostnameVerifier == null) {
            throw new NullPointerException(C0449ye.m9317());
        }
        this.f771hU = hostnameVerifier;
        return this;
    }

    public C0281jw m830a(SSLSocketFactory sSLSocketFactory, X509TrustManager x509TrustManager) {
        if (sSLSocketFactory == null) {
            throw new NullPointerException(C0450yf.m9433());
        }
        if (x509TrustManager == null) {
            throw new NullPointerException(C0453yj.m9892());
        }
        this.f777ia = sSLSocketFactory;
        this.f779iv = C0459zf.m11027(x509TrustManager);
        return this;
    }

    public C0281jw m831b(long j, TimeUnit timeUnit) {
        this.f784mN = C0458ze.m10878(abf.m2593(), j, timeUnit);
        return this;
    }

    public C0281jw m832c(long j, TimeUnit timeUnit) {
        this.f786mR = C0458ze.m10878(abf.m2593(), j, timeUnit);
        return this;
    }

    public C0279ju m833cW() {
        return new C0279ju(this);
    }
}
