package com.google.android.material.card2;

import java.security.cert.Certificate;
import java.security.cert.X509Certificate;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import javax.annotation.Nullable;
import javax.net.ssl.SSLPeerUnverifiedException;

public final class C0247ip {

    public static final C0247ip f529iu = C0449ye.m9153(new C0248iq());

    @Nullable
    private final AbstractC0400of f530iv;

    private final Set<C0249ir> f531iw;

    C0247ip(Set<C0249ir> set, @Nullable AbstractC0400of abstractC0400of) {
        this.f531iw = set;
        this.f530iv = abstractC0400of;
    }

    static C0412or m633a(X509Certificate x509Certificate) {
        return C0452yh.m9763(C0449ye.m9278(abc.m1836(C0455za.m10115(x509Certificate))));
    }

    public static String m634a(Certificate certificate) {
        if (certificate instanceof X509Certificate) {
            return abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0448yd.m8917()), C0456zb.m10316(C0447yc.m8646((X509Certificate) certificate))));
        }
        throw new IllegalArgumentException(C0447yc.m8611());
    }

    static C0412or m635b(X509Certificate x509Certificate) {
        return C0447yc.m8787(C0449ye.m9278(abc.m1836(C0455za.m10115(x509Certificate))));
    }

    public static Object m4924(Object obj) {
        if (abd.m2162() >= 0) {
            return C0598.m11882(obj);
        }
        return null;
    }

    public static C0412or m4925(Object obj) {
        if (C0453yj.m10013() > 0) {
            return ((C0249ir) obj).f536iz;
        }
        return null;
    }

    public static AbstractC0400of m4926(Object obj) {
        if (C0459zf.m11062() > 0) {
            return ((C0247ip) obj).f530iv;
        }
        return null;
    }

    public static boolean m4927(Object obj, Object obj2) {
        if (C0456zb.m10326() < 0) {
            return ((C0249ir) obj).m640q((String) obj2);
        }
        return false;
    }

    public static List m4928(Object obj, Object obj2) {
        if (C0448yd.m9079() < 0) {
            return ((C0247ip) obj).m638p((String) obj2);
        }
        return null;
    }

    public static String m4929(Object obj) {
        if (C0448yd.m9079() <= 0) {
            return ((C0249ir) obj).f533iA;
        }
        return null;
    }

    public static int m4930(Object obj) {
        if (gggy.m4269() <= 0) {
            return C0598.m11824(obj);
        }
        return 0;
    }

    public static C0412or m4931(Object obj) {
        if (C0452yh.m9798() > 0) {
            return m635b((X509Certificate) obj);
        }
        return null;
    }

    public static Set m4932(Object obj) {
        if (abf.m2510() <= 0) {
            return ((C0247ip) obj).f531iw;
        }
        return null;
    }

    public static C0412or m4933(Object obj) {
        if (C0459zf.m11062() > 0) {
            return m633a((X509Certificate) obj);
        }
        return null;
    }

    public static int m4934() {
        if (C0451yg.m9580() > 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static String m4935(Object obj) {
        if (abf.m2500() >= 0) {
            return m4929((C0249ir) obj);
        }
        return null;
    }

    public static C0412or m4936(Object obj) {
        if (abf.m2500() >= 0) {
            return m4933((X509Certificate) obj);
        }
        return null;
    }

    public static AbstractC0400of m4937(Object obj) {
        if (C0445ya.m8330() > 0) {
            return m4926((C0247ip) obj);
        }
        return null;
    }

    public static C0412or m4938(Object obj) {
        if (m4934() > 0) {
            return m4925((C0249ir) obj);
        }
        return null;
    }

    public static C0412or m4939(Object obj) {
        if (C0453yj.m9996() < 0) {
            return m4931((X509Certificate) obj);
        }
        return null;
    }

    public static Set m4940(Object obj) {
        if (C0445ya.m8330() > 0) {
            return m4932((C0247ip) obj);
        }
        return null;
    }

    public static List m4941(Object obj, Object obj2) {
        if (C0457zc.m10555() >= 0) {
            return m4928((C0247ip) obj, (String) obj2);
        }
        return null;
    }

    public static boolean m4942(Object obj, Object obj2) {
        if (gggy.m4365() > 0) {
            return m4927((C0249ir) obj, (String) obj2);
        }
        return false;
    }

    C0247ip m636a(@Nullable AbstractC0400of abstractC0400of) {
        return C0446yb.m8500(C0447yc.m8681(this), abstractC0400of) ? this : new C0247ip(abc.m1963(this), abstractC0400of);
    }

    public void m637a(String str, List<Certificate> list) {
        List<Certificate> listM8442 = list;
        List listM8862 = C0448yd.m8862(this, str);
        if (C0452yh.m9618(listM8862)) {
            return;
        }
        if (C0447yc.m8681(this) != null) {
            listM8442 = C0446yb.m8442(C0447yc.m8681(this), listM8442, str);
        }
        int iM4930 = m4930(listM8442);
        for (int i = 0; i < iM4930; i++) {
            X509Certificate x509Certificate = (X509Certificate) gggy.m4400(listM8442, i);
            int iM4931 = m4930(listM8862);
            C0412or c0412orM2819 = null;
            int i2 = 0;
            C0412or c0412orM8646 = null;
            while (i2 < iM4931) {
                C0249ir c0249ir = (C0249ir) gggy.m4400(listM8862, i2);
                if (C0452yh.m9583(abf.m2603(c0249ir), C0448yd.m8917())) {
                    if (c0412orM8646 == null) {
                        c0412orM8646 = C0447yc.m8646(x509Certificate);
                    }
                    if (C0459zf.m11211(C0457zc.m10543(c0249ir), c0412orM8646)) {
                        return;
                    }
                } else {
                    if (!C0452yh.m9583(abf.m2603(c0249ir), C0457zc.m10692())) {
                        throw new AssertionError(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0450yf.m9384()), abf.m2603(c0249ir))));
                    }
                    if (c0412orM2819 == null) {
                        c0412orM2819 = adds.m2819(x509Certificate);
                    }
                    if (C0459zf.m11211(C0457zc.m10543(c0249ir), c0412orM2819)) {
                        return;
                    }
                }
                i2++;
                c0412orM2819 = c0412orM2819;
            }
        }
        StringBuilder sbM11407 = C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0445ya.m8306()), C0452yh.m9791());
        int iM4932 = m4930(listM8442);
        for (int i3 = 0; i3 < iM4932; i3++) {
            X509Certificate x509Certificate2 = (X509Certificate) gggy.m4400(listM8442, i3);
            C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(sbM11407, C0461zs.m11543()), C0448yd.m8879(x509Certificate2)), C0455za.m10252()), C0449ye.m9202(C0445ya.m8192(x509Certificate2)));
        }
        C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(sbM11407, C0459zf.m10999()), str), C0449ye.m9248());
        int iM4933 = m4930(listM8862);
        for (int i4 = 0; i4 < iM4933; i4++) {
            abd.m2090(C0460zg.m11407(sbM11407, C0461zs.m11543()), (C0249ir) gggy.m4400(listM8862, i4));
        }
        throw new SSLPeerUnverifiedException(abc.m1925(sbM11407));
    }

    public boolean equals(@Nullable Object obj) {
        if (obj == this) {
            return true;
        }
        return (obj instanceof C0247ip) && C0446yb.m8500(C0447yc.m8681(this), C0447yc.m8681((C0247ip) obj)) && gggy.m4483(abc.m1963(this), abc.m1963((C0247ip) obj));
    }

    public int hashCode() {
        return ((C0447yc.m8681(this) != null ? C0446yb.m8544(C0447yc.m8681(this)) : 0) * 31) + C0455za.m10161(abc.m1963(this));
    }

    List<C0249ir> m638p(String str) {
        List<C0249ir> listM11607 = C0461zs.m11607();
        Iterator itM9939 = C0453yj.m9939(abc.m1963(this));
        List<C0249ir> arrayList = listM11607;
        while (C0455za.m10104(itM9939)) {
            C0249ir c0249ir = (C0249ir) m4924(itM9939);
            if (C0461zs.m11498(c0249ir, str)) {
                if (C0452yh.m9618(arrayList)) {
                    arrayList = new ArrayList<>();
                }
                C0460zg.m11251(arrayList, c0249ir);
            }
        }
        return arrayList;
    }
}
