package com.google.android.material.card2;

import java.io.IOException;
import java.lang.ref.Reference;
import java.net.ConnectException;
import java.net.ProtocolException;
import java.net.Proxy;
import java.net.Socket;
import java.net.SocketTimeoutException;
import java.net.UnknownServiceException;
import java.security.cert.X509Certificate;
import java.util.ArrayList;
import java.util.List;
import javax.annotation.Nullable;
import javax.net.ssl.SSLPeerUnverifiedException;
import javax.net.ssl.SSLSocket;

public final class C0314lb extends AbstractC0363mw implements InterfaceC0252iu {

    private EnumC0282jx f958nB;

    private C0270jl f959nw;

    private final C0253iv f962pp;

    private C0354mn f963pq;

    public boolean f965ps;

    private Socket f966pt;

    private final C0294ki f967pu;

    private InterfaceC0410op f968pv;

    private Socket f969pw;

    private InterfaceC0411oq f970px;

    public int f971py;

    public int f960pn = 1;

    public final List<Reference<C0319lg>> f961po = new ArrayList();

    public long f964pr = Long.MAX_VALUE;

    public C0314lb(C0253iv c0253iv, C0294ki c0294ki) {
        this.f962pp = c0253iv;
        this.f967pu = c0294ki;
    }

    private C0286ka m996a(int i, int i2, C0286ka c0286ka, C0273jo c0273jo) throws IOException {
        C0290ke c0290keM10931;
        C0286ka c0286kaM9650 = c0286ka;
        String strM1925 = abc.m1925(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0461zs.m11486()), C0450yf.m9405(c0273jo, true)), C0448yd.m9022()));
        do {
            C0335lw c0335lw = new C0335lw(null, null, C0445ya.m8195(this), adds.m2873(this));
            gggy.m4486(C0452yh.m9606(C0445ya.m8195(this)), i, adds.m2789());
            gggy.m4486(C0447yc.m8706(adds.m2873(this)), i2, adds.m2789());
            C0453yj.m9931(c0335lw, C0460zg.m11265(c0286kaM9650), strM1925);
            C0458ze.m10831(c0335lw);
            c0290keM10931 = C0458ze.m10931(C0450yf.m9535(C0446yb.m8604(c0335lw, false), c0286kaM9650));
            long jM2415 = abf.m2415(c0290keM10931);
            if (jM2415 == -1) {
                jM2415 = 0;
            }
            InterfaceC0429ph interfaceC0429phM8600 = C0446yb.m8600(c0335lw, jM2415);
            gggy.m4296(interfaceC0429phM8600, Integer.MAX_VALUE, adds.m2789());
            C0447yc.m8668(interfaceC0429phM8600);
            switch (C0450yf.m9549(c0290keM10931)) {
                case 200:
                    if (C0450yf.m9578(C0459zf.m11165(C0445ya.m8195(this))) && C0450yf.m9578(C0461zs.m11595(adds.m2873(this)))) {
                        return null;
                    }
                    throw new IOException(C0461zs.m11525());
                case 407:
                    c0286kaM9650 = C0452yh.m9650(C0457zc.m10710(C0448yd.m8875(adds.m2826(this))), adds.m2826(this), c0290keM10931);
                    if (c0286kaM9650 == null) {
                        throw new IOException(abd.m2042());
                    }
                    break;
                default:
                    throw new IOException(abc.m1925(adds.m2680(C0460zg.m11407(new StringBuilder(), C0459zf.m10979()), C0450yf.m9549(c0290keM10931))));
            }
        } while (!C0457zc.m10547(abf.m2592(), C0457zc.m10588(c0290keM10931, m5990())));
        return c0286kaM9650;
    }

    private void m997a(int i, int i2, int i3, InterfaceC0245in interfaceC0245in, AbstractC0264jf abstractC0264jf) {
        C0286ka c0286kaM11391 = C0460zg.m11391(this);
        C0273jo c0273joM9070 = C0448yd.m9070(c0286kaM11391);
        for (int i4 = 0; i4 < 21; i4++) {
            C0456zb.m10429(this, i, i2, interfaceC0245in, abstractC0264jf);
            c0286kaM11391 = adds.m2721(this, i2, i3, c0286kaM11391, c0273joM9070);
            if (c0286kaM11391 == null) {
                return;
            }
            C0455za.m10140(abd.m2111(this));
            this.f966pt = null;
            this.f968pv = null;
            this.f970px = null;
            C0445ya.m8323(abstractC0264jf, interfaceC0245in, C0445ya.m8227(adds.m2826(this)), C0452yh.m9638(adds.m2826(this)), null);
        }
    }

    private void m998a(int i, int i2, InterfaceC0245in interfaceC0245in, AbstractC0264jf abstractC0264jf) throws IOException {
        Proxy proxyM9638 = C0452yh.m9638(adds.m2826(this));
        this.f966pt = (C0452yh.m9590(proxyM9638) == C0460zg.m11283() || C0452yh.m9590(proxyM9638) == abc.m1914()) ? C0449ye.m9207(C0452yh.m9814(C0448yd.m8875(adds.m2826(this)))) : new Socket(proxyM9638);
        abd.m2030(abstractC0264jf, interfaceC0245in, C0445ya.m8227(adds.m2826(this)), proxyM9638);
        C0447yc.m8678(abd.m2111(this), i2);
        try {
            abc.m1876(C0455za.m10101(), abd.m2111(this), C0445ya.m8227(adds.m2826(this)), i);
            try {
                this.f970px = gggy.m4472(C0445ya.m8246(abd.m2111(this)));
                this.f968pv = C0458ze.m10929(C0459zf.m10998(abd.m2111(this)));
            } catch (NullPointerException e) {
                if (C0452yh.m9583(C0459zf.m11217(), abe.m2232(e))) {
                    throw new IOException(e);
                }
            }
        } catch (ConnectException e2) {
            ConnectException connectException = new ConnectException(abc.m1925(abd.m2090(C0460zg.m11407(new StringBuilder(), C0446yb.m8508()), C0445ya.m8227(adds.m2826(this)))));
            C0453yj.m9861(connectException, e2);
            throw connectException;
        }
    }

    private void m999a(C0313la c0313la) throws Throwable {
        Throwable th;
        SSLSocket sSLSocket;
        AssertionError assertionError;
        C0239ih c0239ihM8875 = C0448yd.m8875(adds.m2826(this));
        try {
            SSLSocket sSLSocket2 = (SSLSocket) gggy.m4270(C0455za.m10256(c0239ihM8875), abd.m2111(this), abe.m2260(C0461zs.m11456(c0239ihM8875)), C0457zc.m10643(C0461zs.m11456(c0239ihM8875)), true);
            try {
                C0255ix c0255ixM4357 = gggy.m4357(c0313la, sSLSocket2);
                if (abd.m2054(c0255ixM4357)) {
                    C0460zg.m11252(C0455za.m10101(), sSLSocket2, abe.m2260(C0461zs.m11456(c0239ihM8875)), C0460zg.m11327(c0239ihM8875));
                }
                C0456zb.m10521(sSLSocket2);
                C0270jl c0270jlM10541 = C0457zc.m10541(abe.m2344(sSLSocket2));
                if (!abc.m1853(C0449ye.m9140(c0239ihM8875), abe.m2260(C0461zs.m11456(c0239ihM8875)), abe.m2344(sSLSocket2))) {
                    X509Certificate x509Certificate = (X509Certificate) gggy.m4400(C0445ya.m8358(c0270jlM10541), 0);
                    throw new SSLPeerUnverifiedException(abc.m1925(abd.m2090(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), abc.m1759()), abe.m2260(C0461zs.m11456(c0239ihM8875))), C0450yf.m9445()), C0448yd.m8879(x509Certificate)), C0448yd.m8897()), C0449ye.m9202(C0445ya.m8192(x509Certificate))), abf.m2464()), C0447yc.m8765(x509Certificate))));
                }
                C0456zb.m10354(adds.m2754(c0239ihM8875), abe.m2260(C0461zs.m11456(c0239ihM8875)), C0445ya.m8358(c0270jlM10541));
                String strM11092 = abd.m2054(c0255ixM4357) ? C0459zf.m11092(C0455za.m10101(), sSLSocket2) : null;
                this.f969pw = sSLSocket2;
                this.f970px = gggy.m4472(C0445ya.m8246(C0448yd.m8896(this)));
                this.f968pv = C0458ze.m10929(C0459zf.m10998(C0448yd.m8896(this)));
                this.f959nw = c0270jlM10541;
                this.f958nB = strM11092 != null ? C0447yc.m8788(strM11092) : C0459zf.m11198();
                if (sSLSocket2 != null) {
                    C0450yf.m9360(C0455za.m10101(), sSLSocket2);
                }
            } catch (AssertionError e) {
                assertionError = e;
                sSLSocket = sSLSocket2;
                try {
                    if (!C0456zb.m10287(assertionError)) {
                        throw assertionError;
                    }
                    throw new IOException(assertionError);
                } catch (Throwable th2) {
                    th = th2;
                    if (sSLSocket != null) {
                        C0450yf.m9360(C0455za.m10101(), sSLSocket);
                    }
                    C0455za.m10140(sSLSocket);
                    throw th;
                }
            } catch (Throwable th3) {
                th = th3;
                sSLSocket = sSLSocket2;
                if (sSLSocket != null) {
                    C0450yf.m9360(C0455za.m10101(), sSLSocket);
                }
                C0455za.m10140(sSLSocket);
                throw th;
            }
        } catch (AssertionError e2) {
            assertionError = e2;
            sSLSocket = null;
        } catch (Throwable th4) {
            th = th4;
            sSLSocket = null;
        }
    }

    private void m1000a(C0313la c0313la, InterfaceC0245in interfaceC0245in, AbstractC0264jf abstractC0264jf) {
        if (C0455za.m10256(C0448yd.m8875(adds.m2826(this))) == null) {
            this.f958nB = C0459zf.m11198();
            this.f969pw = abd.m2111(this);
            return;
        }
        C0455za.m10137(abstractC0264jf, interfaceC0245in);
        C0452yh.m9785(this, c0313la);
        C0453yj.m9831(abstractC0264jf, interfaceC0245in, C0447yc.m8640(this));
        if (C0450yf.m9516(this) == gggy.m4498()) {
            C0447yc.m8678(C0448yd.m8896(this), 0);
            this.f963pq = C0455za.m10230(C0452yh.m9769(abe.m2356(new C0362mv(true), C0448yd.m8896(this), abe.m2260(C0461zs.m11456(C0448yd.m8875(adds.m2826(this)))), C0445ya.m8195(this), adds.m2873(this)), this));
            abf.m2427(gggy.m4273(this));
        }
    }

    private C0286ka m1001dN() {
        return C0448yd.m8952(C0446yb.m8510(C0446yb.m8510(C0446yb.m8510(C0458ze.m10923(new C0287kb(), C0461zs.m11456(C0448yd.m8875(adds.m2826(this)))), abf.m2536(), C0450yf.m9405(C0461zs.m11456(C0448yd.m8875(adds.m2826(this))), true)), C0455za.m10151(), C0445ya.m8286()), C0461zs.m11592(), C0460zg.m11291()));
    }

    public static int m5969(Object obj) {
        if (C0456zb.m10326() < 0) {
            return C0598.m11824(obj);
        }
        return 0;
    }

    public static C0286ka m5970(Object obj) {
        if (C0459zf.m11062() > 0) {
            return ((C0314lb) obj).m1001dN();
        }
        return null;
    }

    public static void m5971(Object obj, Object obj2) throws Throwable {
        if (C0457zc.m10735() < 0) {
            ((C0314lb) obj).m999a((C0313la) obj2);
        }
    }

    public static C0430pi m5972(Object obj) {
        if (C0447yc.m8635() > 0) {
            return ((InterfaceC0410op) obj).mo1095dz();
        }
        return null;
    }

    public static EnumC0282jx m5973(Object obj) {
        if (C0450yf.m9352() < 0) {
            return ((C0314lb) obj).f958nB;
        }
        return null;
    }

    public static int m5974() {
        if (C0450yf.m9352() <= 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static C0270jl m5975(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return ((C0314lb) obj).f959nw;
        }
        return null;
    }

    public static InterfaceC0411oq m5976(Object obj) {
        if (C0453yj.m10013() >= 0) {
            return ((C0314lb) obj).f970px;
        }
        return null;
    }

    public static C0253iv m5977(Object obj) {
        if (C0461zs.m11510() < 0) {
            return ((C0314lb) obj).f962pp;
        }
        return null;
    }

    public static Socket m5978(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return ((C0314lb) obj).f966pt;
        }
        return null;
    }

    public static Socket m5979(Object obj) {
        if (C0458ze.m10932() >= 0) {
            return ((C0314lb) obj).f969pw;
        }
        return null;
    }

    public static void m5980(Object obj, int i, int i2, int i3, Object obj2, Object obj3) {
        if (C0459zf.m11062() > 0) {
            ((C0314lb) obj).m997a(i, i2, i3, (InterfaceC0245in) obj2, (AbstractC0264jf) obj3);
        }
    }

    public static C0354mn m5981(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return ((C0314lb) obj).f963pq;
        }
        return null;
    }

    public static void m5982(Object obj, Object obj2) {
        if (C0456zb.m10326() <= 0) {
            C0598.m11904(obj, obj2);
        }
    }

    public static C0294ki m5983(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return ((C0314lb) obj).f967pu;
        }
        return null;
    }

    public static void m5984(Object obj, int i, int i2, Object obj2, Object obj3) throws IOException {
        if (C0445ya.m8222() > 0) {
            ((C0314lb) obj).m998a(i, i2, (InterfaceC0245in) obj2, (AbstractC0264jf) obj3);
        }
    }

    public static int m5985(Object obj) {
        if (abf.m2510() <= 0) {
            return C0598.m11906(obj);
        }
        return 0;
    }

    public static C0430pi m5986(Object obj) {
        if (abd.m2162() > 0) {
            return ((InterfaceC0411oq) obj).mo967dz();
        }
        return null;
    }

    public static C0286ka m5987(Object obj, int i, int i2, Object obj2, Object obj3) {
        if (abc.m1845() < 0) {
            return ((C0314lb) obj).m996a(i, i2, (C0286ka) obj2, (C0273jo) obj3);
        }
        return null;
    }

    public static InterfaceC0410op m5988(Object obj) {
        if (adds.m2755() >= 0) {
            return ((C0314lb) obj).f968pv;
        }
        return null;
    }

    public static void m5989(Object obj, Object obj2, Object obj3, Object obj4) {
        if (C0447yc.m8635() > 0) {
            ((C0314lb) obj).m1000a((C0313la) obj2, (InterfaceC0245in) obj3, (AbstractC0264jf) obj4);
        }
    }

    public static String m5990() {
        if (C0447yc.m8635() > 0) {
            return C0598.m11878();
        }
        return null;
    }

    public static void m5991(Object obj, Object obj2, Object obj3, Object obj4) {
        if (C0453yj.m9945() <= 0) {
            m5989((C0314lb) obj, (C0313la) obj2, (InterfaceC0245in) obj3, (AbstractC0264jf) obj4);
        }
    }

    public static void m5992(Object obj, int i, int i2, Object obj2, Object obj3) {
        if (C0447yc.m8786() >= 0) {
            m5984((C0314lb) obj, i, i2, (InterfaceC0245in) obj2, (AbstractC0264jf) obj3);
        }
    }

    public static Socket m5993(Object obj) {
        if (C0453yj.m9945() <= 0) {
            return m5979((C0314lb) obj);
        }
        return null;
    }

    public static C0294ki m5994(Object obj) {
        if (C0457zc.m10555() > 0) {
            return m5983((C0314lb) obj);
        }
        return null;
    }

    public static C0253iv m5995(Object obj) {
        if (C0460zg.m11293() > 0) {
            return m5977((C0314lb) obj);
        }
        return null;
    }

    public static void m5996(Object obj, Object obj2) throws Throwable {
        if (C0445ya.m8330() >= 0) {
            m5971((C0314lb) obj, (C0313la) obj2);
        }
    }

    public static void m5997(Object obj, int i, int i2, int i3, Object obj2, Object obj3) {
        if (C0459zf.m11053() >= 0) {
            m5980((C0314lb) obj, i, i2, i3, (InterfaceC0245in) obj2, (AbstractC0264jf) obj3);
        }
    }

    public static Socket m5998(Object obj) {
        if (abd.m2021() >= 0) {
            return m5978((C0314lb) obj);
        }
        return null;
    }

    public static C0286ka m5999(Object obj) {
        if (C0456zb.m10484() <= 0) {
            return m5970((C0314lb) obj);
        }
        return null;
    }

    public static C0430pi m6000(Object obj) {
        if (C0448yd.m9015() < 0) {
            return m5986((InterfaceC0411oq) obj);
        }
        return null;
    }

    public static C0286ka m6001(Object obj, int i, int i2, Object obj2, Object obj3) {
        if (C0457zc.m10718() <= 0) {
            return m5987((C0314lb) obj, i, i2, (C0286ka) obj2, (C0273jo) obj3);
        }
        return null;
    }

    public static C0354mn m6002(Object obj) {
        if (m5974() >= 0) {
            return m5981((C0314lb) obj);
        }
        return null;
    }

    public static C0430pi m1002(Object obj) {
        if (C0459zf.m11053() > 0) {
            return m5972((InterfaceC0410op) obj);
        }
        return null;
    }

    public static InterfaceC0411oq m6003(Object obj) {
        if (C0453yj.m10032() >= 0) {
            return m5976((C0314lb) obj);
        }
        return null;
    }

    public static EnumC0282jx m6004(Object obj) {
        if (abe.m2321() < 0) {
            return m5973((C0314lb) obj);
        }
        return null;
    }

    public static C0270jl m6005(Object obj) {
        if (C0457zc.m10718() < 0) {
            return m5975((C0314lb) obj);
        }
        return null;
    }

    public static InterfaceC0410op m6006(Object obj) {
        if (C0460zg.m11293() > 0) {
            return m5988((C0314lb) obj);
        }
        return null;
    }

    public InterfaceC0324ll m1003a(C0279ju c0279ju, InterfaceC0277js interfaceC0277js, C0319lg c0319lg) {
        if (gggy.m4273(this) != null) {
            return new C0352ml(c0279ju, interfaceC0277js, c0319lg, gggy.m4273(this));
        }
        C0447yc.m8678(C0448yd.m8896(this), m5985(interfaceC0277js));
        gggy.m4486(C0452yh.m9606(C0445ya.m8195(this)), m5985(interfaceC0277js), adds.m2789());
        gggy.m4486(C0447yc.m8706(adds.m2873(this)), C0460zg.m11245(interfaceC0277js), adds.m2789());
        return new C0335lw(c0279ju, c0319lg, C0445ya.m8195(this), adds.m2873(this));
    }

    public void m1004a(int i, int i2, int i3, boolean z, InterfaceC0245in interfaceC0245in, AbstractC0264jf abstractC0264jf) {
        C0316ld c0316ld;
        if (C0450yf.m9516(this) != null) {
            throw new IllegalStateException(C0459zf.m11111());
        }
        List listM10590 = C0457zc.m10590(C0448yd.m8875(adds.m2826(this)));
        C0313la c0313la = new C0313la(listM10590);
        if (C0455za.m10256(C0448yd.m8875(adds.m2826(this))) == null) {
            if (!C0458ze.m10847(listM10590, C0459zf.m11122())) {
                throw new C0316ld(new UnknownServiceException(C0449ye.m9270()));
            }
            String strM2260 = abe.m2260(C0461zs.m11456(C0448yd.m8875(adds.m2826(this))));
            if (!C0446yb.m8585(C0455za.m10101(), strM2260)) {
                throw new C0316ld(new UnknownServiceException(abc.m1925(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), abd.m2127()), strM2260), C0447yc.m8800()))));
            }
        }
        C0316ld c0316ld2 = null;
        while (true) {
            try {
                if (abe.m2381(adds.m2826(this))) {
                    adds.m2774(this, i, i2, i3, interfaceC0245in, abstractC0264jf);
                    if (abd.m2111(this) != null) {
                        break;
                    } else {
                        break;
                    }
                }
                C0456zb.m10429(this, i, i2, interfaceC0245in, abstractC0264jf);
                abd.m2170(this, c0313la, interfaceC0245in, abstractC0264jf);
                C0445ya.m8323(abstractC0264jf, interfaceC0245in, C0445ya.m8227(adds.m2826(this)), C0452yh.m9638(adds.m2826(this)), C0450yf.m9516(this));
                break;
            } catch (IOException e) {
                C0455za.m10140(C0448yd.m8896(this));
                C0455za.m10140(abd.m2111(this));
                this.f969pw = null;
                this.f966pt = null;
                this.f970px = null;
                this.f968pv = null;
                this.f959nw = null;
                this.f958nB = null;
                this.f963pq = null;
                C0453yj.m9994(abstractC0264jf, interfaceC0245in, C0445ya.m8227(adds.m2826(this)), C0452yh.m9638(adds.m2826(this)), null, e);
                if (c0316ld2 == null) {
                    c0316ld = new C0316ld(e);
                } else {
                    C0461zs.m11641(c0316ld2, e);
                    c0316ld = c0316ld2;
                }
                if (!z) {
                    throw c0316ld;
                }
                if (!C0449ye.m9113(c0313la, e)) {
                    throw c0316ld;
                }
                c0316ld2 = c0316ld;
            }
        }
        if (abe.m2381(adds.m2826(this)) && abd.m2111(this) == null) {
            throw new C0316ld(new ProtocolException(C0452yh.m9622()));
        }
        if (gggy.m4273(this) != null) {
            synchronized (C0456zb.m10503(this)) {
                this.f960pn = C0452yh.m9755(gggy.m4273(this));
            }
        }
    }

    @Override
    public void mo1005a(C0354mn c0354mn) {
        synchronized (C0456zb.m10503(this)) {
            this.f960pn = C0452yh.m9755(c0354mn);
        }
    }

    @Override
    public void mo1006a(C0373nf c0373nf) {
        m5982(c0373nf, adds.m2844());
    }

    public boolean m1007a(C0239ih c0239ih, @Nullable C0294ki c0294ki) {
        if (m5969(C0457zc.m10705(this)) >= C0445ya.m8244(this) || C0445ya.m8282(this) || !C0458ze.m10896(adds.m2768(), C0448yd.m8875(adds.m2826(this)), c0239ih)) {
            return false;
        }
        if (C0452yh.m9583(abe.m2260(C0461zs.m11456(c0239ih)), abe.m2260(C0461zs.m11456(C0448yd.m8875(C0452yh.m9728(this)))))) {
            return true;
        }
        if (gggy.m4273(this) == null || c0294ki == null || C0452yh.m9590(C0452yh.m9638(c0294ki)) != C0460zg.m11283() || C0452yh.m9590(C0452yh.m9638(adds.m2826(this))) != C0460zg.m11283() || !adds.m2708(C0445ya.m8227(adds.m2826(this)), C0445ya.m8227(c0294ki)) || C0449ye.m9140(C0448yd.m8875(c0294ki)) != C0445ya.m8350() || !C0449ye.m9176(this, C0461zs.m11456(c0239ih))) {
            return false;
        }
        try {
            C0456zb.m10354(adds.m2754(c0239ih), abe.m2260(C0461zs.m11456(c0239ih)), C0445ya.m8358(C0458ze.m10883(this)));
            return true;
        } catch (SSLPeerUnverifiedException e) {
            return false;
        }
    }

    @Override
    public C0294ki mo645bV() {
        return adds.m2826(this);
    }

    public boolean m1008c(C0273jo c0273jo) {
        if (C0457zc.m10643(c0273jo) != C0457zc.m10643(C0461zs.m11456(C0448yd.m8875(adds.m2826(this))))) {
            return false;
        }
        if (C0452yh.m9583(abe.m2260(c0273jo), abe.m2260(C0461zs.m11456(C0448yd.m8875(adds.m2826(this)))))) {
            return true;
        }
        return C0447yc.m8640(this) != null && C0456zb.m10323(C0445ya.m8350(), abe.m2260(c0273jo), (X509Certificate) gggy.m4400(C0445ya.m8358(C0447yc.m8640(this)), 0));
    }

    public boolean m1009dO() {
        return gggy.m4273(this) != null;
    }

    public Socket m1010dP() {
        return C0448yd.m8896(this);
    }

    public C0270jl m1011dn() {
        return C0447yc.m8640(this);
    }

    public boolean m1012l(boolean z) {
        if (adds.m2833(C0448yd.m8896(this)) || C0447yc.m8614(C0448yd.m8896(this)) || C0449ye.m9212(C0448yd.m8896(this))) {
            return false;
        }
        if (gggy.m4273(this) != null) {
            if (C0461zs.m11514(gggy.m4273(this))) {
                return false;
            }
        } else if (z) {
            try {
                int iM2820 = adds.m2820(C0448yd.m8896(this));
                try {
                    C0447yc.m8678(C0448yd.m8896(this), 1);
                    if (C0459zf.m11102(C0445ya.m8195(this))) {
                        C0447yc.m8678(C0448yd.m8896(this), iM2820);
                        return false;
                    }
                    C0447yc.m8678(C0448yd.m8896(this), iM2820);
                    return true;
                } catch (Throwable th) {
                    C0447yc.m8678(C0448yd.m8896(this), iM2820);
                    throw th;
                }
            } catch (SocketTimeoutException e) {
                return true;
            } catch (IOException e2) {
                return false;
            }
        }
        return true;
    }

    public String toString() {
        return abc.m1925(abe.m2346(abd.m2090(C0460zg.m11407(abd.m2090(C0460zg.m11407(abd.m2090(C0460zg.m11407(abd.m2090(C0460zg.m11407(adds.m2680(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0459zf.m11110()), abe.m2260(C0461zs.m11456(C0448yd.m8875(adds.m2826(this))))), C0449ye.m9248()), C0457zc.m10643(C0461zs.m11456(C0448yd.m8875(adds.m2826(this))))), abf.m2601()), C0452yh.m9638(adds.m2826(this))), C0455za.m10155()), C0445ya.m8227(adds.m2826(this))), adds.m2759()), C0447yc.m8640(this) != null ? C0445ya.m8257(C0447yc.m8640(this)) : C0456zb.m10440()), C0450yf.m9492()), C0450yf.m9516(this)), '}'));
    }
}
