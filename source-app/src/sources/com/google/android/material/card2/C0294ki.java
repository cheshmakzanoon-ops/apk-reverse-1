package com.google.android.material.card2;

import java.net.InetSocketAddress;
import java.net.Proxy;
import javax.annotation.Nullable;
import javax.net.ssl.SSLSocketFactory;

public final class C0294ki {

    final C0239ih f874nI;

    final InetSocketAddress f875nJ;

    final Proxy f876nK;

    public C0294ki(C0239ih c0239ih, Proxy proxy, InetSocketAddress inetSocketAddress) {
        if (c0239ih == null) {
            throw new NullPointerException(gggy.m4417());
        }
        if (proxy == null) {
            throw new NullPointerException(abc.m1823());
        }
        if (inetSocketAddress == null) {
            throw new NullPointerException(C0455za.m10251());
        }
        this.f874nI = c0239ih;
        this.f876nK = proxy;
        this.f875nJ = inetSocketAddress;
    }

    public static C0239ih m5739(Object obj) {
        if (adds.m2755() >= 0) {
            return ((C0294ki) obj).f874nI;
        }
        return null;
    }

    public static InetSocketAddress m5740(Object obj) {
        if (C0450yf.m9352() < 0) {
            return ((C0294ki) obj).f875nJ;
        }
        return null;
    }

    public static SSLSocketFactory m5741(Object obj) {
        if (abd.m2162() >= 0) {
            return ((C0239ih) obj).f501ia;
        }
        return null;
    }

    public static Proxy m5742(Object obj) {
        if (C0452yh.m9798() > 0) {
            return ((C0294ki) obj).f876nK;
        }
        return null;
    }

    public static Proxy m5743(Object obj) {
        if (abe.m2321() < 0) {
            return m5742((C0294ki) obj);
        }
        return null;
    }

    public static InetSocketAddress m5744(Object obj) {
        if (C0457zc.m10718() <= 0) {
            return m5740((C0294ki) obj);
        }
        return null;
    }

    public static SSLSocketFactory m5745(Object obj) {
        if (C0457zc.m10555() >= 0) {
            return m5741((C0239ih) obj);
        }
        return null;
    }

    public static C0239ih m5746(Object obj) {
        if (C0447yc.m8786() > 0) {
            return m5739((C0294ki) obj);
        }
        return null;
    }

    public Proxy m921bA() {
        return C0460zg.m11406(this);
    }

    public C0239ih m922dv() {
        return C0459zf.m11164(this);
    }

    public boolean m923dw() {
        return gggy.m4438(C0459zf.m11164(this)) != null && C0452yh.m9590(C0460zg.m11406(this)) == abc.m1914();
    }

    public InetSocketAddress m924dx() {
        return gggy.m4467(this);
    }

    public boolean equals(@Nullable Object obj) {
        return (obj instanceof C0294ki) && adds.m2689(C0459zf.m11164((C0294ki) obj), C0459zf.m11164(this)) && C0461zs.m11598(C0460zg.m11406((C0294ki) obj), C0460zg.m11406(this)) && adds.m2708(gggy.m4467((C0294ki) obj), gggy.m4467(this));
    }

    public int hashCode() {
        int iM10086 = C0455za.m10086(C0459zf.m11164(this));
        return ((((iM10086 + 527) * 31) + abd.m2115(C0460zg.m11406(this))) * 31) + C0452yh.m9629(gggy.m4467(this));
    }

    public String toString() {
        return abc.m1925(C0460zg.m11407(abd.m2090(C0460zg.m11407(new StringBuilder(), C0455za.m10235()), gggy.m4467(this)), C0446yb.m8473()));
    }
}
