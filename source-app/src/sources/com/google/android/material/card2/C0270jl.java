package com.google.android.material.card2;

import java.security.cert.Certificate;
import java.util.List;
import javax.annotation.Nullable;
import javax.net.ssl.SSLPeerUnverifiedException;
import javax.net.ssl.SSLSession;

public final class C0270jl {

    private final C0250is f703lI;

    private final List<Certificate> f704lJ;

    private final List<Certificate> f705lK;

    private final EnumC0295kj f706lL;

    private C0270jl(EnumC0295kj enumC0295kj, C0250is c0250is, List<Certificate> list, List<Certificate> list2) {
        this.f706lL = enumC0295kj;
        this.f703lI = c0250is;
        this.f705lK = list;
        this.f704lJ = list2;
    }

    public static C0270jl m714a(SSLSession sSLSession) {
        Certificate[] certificateArrM11340;
        String strM2895 = adds.m2895(sSLSession);
        if (strM2895 == null) {
            throw new IllegalStateException(C0449ye.m9227());
        }
        C0250is c0250isM5153 = m5153(strM2895);
        String strM5150 = m5150(sSLSession);
        if (strM5150 == null) {
            throw new IllegalStateException(gggy.m4454());
        }
        EnumC0295kj enumC0295kjM10674 = C0457zc.m10674(strM5150);
        try {
            certificateArrM11340 = C0460zg.m11340(sSLSession);
        } catch (SSLPeerUnverifiedException e) {
            certificateArrM11340 = null;
        }
        List listM2380 = certificateArrM11340 != null ? abe.m2380(certificateArrM11340) : C0461zs.m11607();
        Certificate[] certificateArrM2517 = abf.m2517(sSLSession);
        return new C0270jl(enumC0295kjM10674, c0250isM5153, listM2380, certificateArrM2517 != null ? abe.m2380(certificateArrM2517) : C0461zs.m11607());
    }

    public static List m5148(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return ((C0270jl) obj).f705lK;
        }
        return null;
    }

    public static List m5149(Object obj) {
        if (C0457zc.m10735() <= 0) {
            return ((C0270jl) obj).f704lJ;
        }
        return null;
    }

    public static String m5150(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return C0598.m11817(obj);
        }
        return null;
    }

    public static C0250is m5151(Object obj) {
        if (C0449ye.m9220() < 0) {
            return ((C0270jl) obj).f703lI;
        }
        return null;
    }

    public static EnumC0295kj m5152(Object obj) {
        if (abc.m1845() < 0) {
            return ((C0270jl) obj).f706lL;
        }
        return null;
    }

    public static C0250is m5153(Object obj) {
        if (adds.m2755() > 0) {
            return C0598.m11827(obj);
        }
        return null;
    }

    public static int m5154(Object obj) {
        if (C0452yh.m9798() > 0) {
            return C0598.m11820(obj);
        }
        return 0;
    }

    public static List m5155(Object obj) {
        if (C0453yj.m10032() > 0) {
            return m5148((C0270jl) obj);
        }
        return null;
    }

    public static EnumC0295kj m5156(Object obj) {
        if (C0447yc.m8786() > 0) {
            return m5152((C0270jl) obj);
        }
        return null;
    }

    public static C0250is m5157(Object obj) {
        if (C0445ya.m8330() > 0) {
            return m5151((C0270jl) obj);
        }
        return null;
    }

    public static List m5158(Object obj) {
        if (C0456zb.m10484() <= 0) {
            return m5149((C0270jl) obj);
        }
        return null;
    }

    public C0250is m715ci() {
        return C0452yh.m9735(this);
    }

    public List<Certificate> m716cj() {
        return C0445ya.m8252(this);
    }

    public boolean equals(@Nullable Object obj) {
        if (!(obj instanceof C0270jl)) {
            return false;
        }
        C0270jl c0270jl = (C0270jl) obj;
        return C0452yh.m9654(C0461zs.m11468(this), C0461zs.m11468(c0270jl)) && C0459zf.m11147(C0452yh.m9735(this), C0452yh.m9735(c0270jl)) && abd.m2119(C0445ya.m8252(this), C0445ya.m8252(c0270jl)) && abd.m2119(C0459zf.m11197(this), C0459zf.m11197(c0270jl));
    }

    public int hashCode() {
        int iM5154 = m5154(C0461zs.m11468(this));
        int iM8544 = C0446yb.m8544(C0452yh.m9735(this));
        return ((((((iM5154 + 527) * 31) + iM8544) * 31) + C0452yh.m9607(C0445ya.m8252(this))) * 31) + C0452yh.m9607(C0459zf.m11197(this));
    }
}
