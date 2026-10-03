package com.google.android.material.card2;

import java.net.Proxy;
import java.net.ProxySelector;
import java.util.List;
import javax.annotation.Nullable;
import javax.net.SocketFactory;
import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.SSLSocketFactory;

public final class C0239ih {

    @Nullable
    final C0247ip f492hR;

    final List<C0255ix> f493hS;

    final InterfaceC0262jd f494hT;

    @Nullable
    final HostnameVerifier f495hU;

    final List<EnumC0282jx> f496hV;

    @Nullable
    final Proxy f497hW;

    final InterfaceC0240ii f498hX;

    final ProxySelector f499hY;

    final SocketFactory f500hZ;

    @Nullable
    final SSLSocketFactory f501ia;

    final C0273jo f502ib;

    public C0239ih(String str, int i, InterfaceC0262jd interfaceC0262jd, SocketFactory socketFactory, @Nullable SSLSocketFactory sSLSocketFactory, @Nullable HostnameVerifier hostnameVerifier, @Nullable C0247ip c0247ip, InterfaceC0240ii interfaceC0240ii, @Nullable Proxy proxy, List<EnumC0282jx> list, List<C0255ix> list2, ProxySelector proxySelector) {
        this.f502ib = C0449ye.m9107(C0456zb.m10464(C0450yf.m9528(C0445ya.m8388(new C0274jp(), sSLSocketFactory != null ? C0459zf.m11016() : abd.m2063()), str), i));
        if (interfaceC0262jd == null) {
            throw new NullPointerException(C0460zg.m11288());
        }
        this.f494hT = interfaceC0262jd;
        if (socketFactory == null) {
            throw new NullPointerException(C0452yh.m9754());
        }
        this.f500hZ = socketFactory;
        if (interfaceC0240ii == null) {
            throw new NullPointerException(abe.m2259());
        }
        this.f498hX = interfaceC0240ii;
        if (list == null) {
            throw new NullPointerException(C0458ze.m10862());
        }
        this.f496hV = C0456zb.m10446(list);
        if (list2 == null) {
            throw new NullPointerException(C0460zg.m11410());
        }
        this.f493hS = C0456zb.m10446(list2);
        if (proxySelector == null) {
            throw new NullPointerException(abf.m2424());
        }
        this.f499hY = proxySelector;
        this.f497hW = proxy;
        this.f501ia = sSLSocketFactory;
        this.f495hU = hostnameVerifier;
        this.f492hR = c0247ip;
    }

    public static C0247ip m4851(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return ((C0239ih) obj).f492hR;
        }
        return null;
    }

    public static Proxy m4852(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return ((C0239ih) obj).f497hW;
        }
        return null;
    }

    public static InterfaceC0262jd m4853(Object obj) {
        if (C0448yd.m9079() <= 0) {
            return ((C0239ih) obj).f494hT;
        }
        return null;
    }

    public static List m4854(Object obj) {
        if (abe.m2308() < 0) {
            return ((C0239ih) obj).f496hV;
        }
        return null;
    }

    public static SocketFactory m4855(Object obj) {
        if (abf.m2510() < 0) {
            return ((C0239ih) obj).f500hZ;
        }
        return null;
    }

    public static HostnameVerifier m4856(Object obj) {
        if (abc.m1845() <= 0) {
            return ((C0239ih) obj).f495hU;
        }
        return null;
    }

    public static ProxySelector m4857(Object obj) {
        if (abd.m2162() > 0) {
            return ((C0239ih) obj).f499hY;
        }
        return null;
    }

    public static C0273jo m4858(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return ((C0239ih) obj).f502ib;
        }
        return null;
    }

    public static boolean m4859(Object obj, Object obj2) {
        if (C0452yh.m9798() >= 0) {
            return ((C0239ih) obj).m603a((C0239ih) obj2);
        }
        return false;
    }

    public static SSLSocketFactory m4860(Object obj) {
        if (C0453yj.m10013() > 0) {
            return ((C0239ih) obj).f501ia;
        }
        return null;
    }

    public static InterfaceC0240ii m4861(Object obj) {
        if (C0459zf.m11062() > 0) {
            return ((C0239ih) obj).f498hX;
        }
        return null;
    }

    public static List m4862(Object obj) {
        if (C0452yh.m9798() > 0) {
            return ((C0239ih) obj).f493hS;
        }
        return null;
    }

    public static C0247ip m4863(Object obj) {
        if (C0453yj.m9966() > 0) {
            return m4851((C0239ih) obj);
        }
        return null;
    }

    public static boolean m4864(Object obj, Object obj2) {
        if (C0457zc.m10718() < 0) {
            return m4859((C0239ih) obj, (C0239ih) obj2);
        }
        return false;
    }

    public static InterfaceC0240ii m4865(Object obj) {
        if (C0457zc.m10555() > 0) {
            return m4861((C0239ih) obj);
        }
        return null;
    }

    public static ProxySelector m4866(Object obj) {
        if (C0445ya.m8330() > 0) {
            return m4857((C0239ih) obj);
        }
        return null;
    }

    public static Proxy m4867(Object obj) {
        if (C0447yc.m8786() > 0) {
            return m4852((C0239ih) obj);
        }
        return null;
    }

    public static C0273jo m4868(Object obj) {
        if (C0458ze.m10926() <= 0) {
            return m4858((C0239ih) obj);
        }
        return null;
    }

    public static SocketFactory m4869(Object obj) {
        if (C0453yj.m9966() >= 0) {
            return m4855((C0239ih) obj);
        }
        return null;
    }

    public static List m4870(Object obj) {
        if (C0457zc.m10718() < 0) {
            return m4862((C0239ih) obj);
        }
        return null;
    }

    public static HostnameVerifier m4871(Object obj) {
        if (C0453yj.m10032() >= 0) {
            return m4856((C0239ih) obj);
        }
        return null;
    }

    public static SSLSocketFactory m4872(Object obj) {
        if (C0453yj.m9996() < 0) {
            return m4860((C0239ih) obj);
        }
        return null;
    }

    public static List m4873(Object obj) {
        if (C0453yj.m9996() <= 0) {
            return m4854((C0239ih) obj);
        }
        return null;
    }

    public static InterfaceC0262jd m4874(Object obj) {
        if (abd.m2166() < 0) {
            return m4853((C0239ih) obj);
        }
        return null;
    }

    boolean m603a(C0239ih c0239ih) {
        return C0459zf.m11147(C0455za.m10233(this), C0455za.m10233(c0239ih)) && C0459zf.m11147(C0461zs.m11561(this), C0461zs.m11561(c0239ih)) && abd.m2119(C0456zb.m10367(this), C0456zb.m10367(c0239ih)) && abd.m2119(C0452yh.m9723(this), C0452yh.m9723(c0239ih)) && C0459zf.m11147(C0459zf.m10977(this), C0459zf.m10977(c0239ih)) && C0446yb.m8500(C0456zb.m10312(this), C0456zb.m10312(c0239ih)) && C0446yb.m8500(C0448yd.m8957(this), C0448yd.m8957(c0239ih)) && C0446yb.m8500(C0449ye.m9325(this), C0449ye.m9325(c0239ih)) && C0446yb.m8500(C0453yj.m10026(this), C0453yj.m10026(c0239ih)) && C0457zc.m10643(C0461zs.m11456(this)) == C0457zc.m10643(C0461zs.m11456(c0239ih));
    }

    @Nullable
    public Proxy m604bA() {
        return C0456zb.m10312(this);
    }

    public InterfaceC0240ii m605bB() {
        return C0461zs.m11561(this);
    }

    public ProxySelector m606bC() {
        return C0459zf.m10977(this);
    }

    public SocketFactory m607bD() {
        return C0449ye.m9110(this);
    }

    @Nullable
    public SSLSocketFactory m608bE() {
        return C0448yd.m8957(this);
    }

    public C0273jo m609bF() {
        return abe.m2362(this);
    }

    @Nullable
    public C0247ip m610bv() {
        return C0453yj.m10026(this);
    }

    public List<C0255ix> m611bw() {
        return C0452yh.m9723(this);
    }

    public InterfaceC0262jd m612bx() {
        return C0455za.m10233(this);
    }

    @Nullable
    public HostnameVerifier m613by() {
        return C0449ye.m9325(this);
    }

    public List<EnumC0282jx> m614bz() {
        return C0456zb.m10367(this);
    }

    public boolean equals(@Nullable Object obj) {
        return (obj instanceof C0239ih) && abc.m1858(abe.m2362(this), abe.m2362((C0239ih) obj)) && C0456zb.m10362(this, (C0239ih) obj);
    }

    public int hashCode() {
        int iM9527 = C0450yf.m9527(abe.m2362(this));
        int iM8544 = C0446yb.m8544(C0455za.m10233(this));
        int iM8545 = C0446yb.m8544(C0461zs.m11561(this));
        int iM9607 = C0452yh.m9607(C0456zb.m10367(this));
        int iM9608 = C0452yh.m9607(C0452yh.m9723(this));
        int iM8546 = C0446yb.m8544(C0459zf.m10977(this));
        int iM2115 = C0456zb.m10312(this) != null ? abd.m2115(C0456zb.m10312(this)) : 0;
        int iM8547 = C0448yd.m8957(this) != null ? C0446yb.m8544(C0448yd.m8957(this)) : 0;
        return ((((((iM2115 + ((((((((((((iM9527 + 527) * 31) + iM8544) * 31) + iM8545) * 31) + iM9607) * 31) + iM9608) * 31) + iM8546) * 31)) * 31) + iM8547) * 31) + (C0449ye.m9325(this) != null ? C0446yb.m8544(C0449ye.m9325(this)) : 0)) * 31) + (C0453yj.m10026(this) != null ? abf.m2636(C0453yj.m10026(this)) : 0);
    }

    public String toString() {
        StringBuilder sbM2680 = adds.m2680(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0459zf.m11176()), abe.m2260(abe.m2362(this))), C0449ye.m9248()), C0457zc.m10643(abe.m2362(this)));
        if (C0456zb.m10312(this) != null) {
            abd.m2090(C0460zg.m11407(sbM2680, abf.m2601()), C0456zb.m10312(this));
        } else {
            abd.m2090(C0460zg.m11407(sbM2680, C0449ye.m9187()), C0459zf.m10977(this));
        }
        C0460zg.m11407(sbM2680, C0446yb.m8473());
        return abc.m1925(sbM2680);
    }
}
