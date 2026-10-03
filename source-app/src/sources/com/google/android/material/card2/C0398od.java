package com.google.android.material.card2;

import java.security.GeneralSecurityException;
import java.security.cert.Certificate;
import java.security.cert.X509Certificate;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import javax.net.ssl.SSLPeerUnverifiedException;

public final class C0398od extends AbstractC0400of {

    private final InterfaceC0403oi f1277uM;

    public C0398od(InterfaceC0403oi interfaceC0403oi) {
        this.f1277uM = interfaceC0403oi;
    }

    private boolean m1312a(X509Certificate x509Certificate, X509Certificate x509Certificate2) {
        if (!C0455za.m10145(C0455za.m10052(x509Certificate), C0445ya.m8192(x509Certificate2))) {
            return false;
        }
        try {
            C0445ya.m8354(x509Certificate, C0455za.m10115(x509Certificate2));
            return true;
        } catch (GeneralSecurityException e) {
            return false;
        }
    }

    public static int m7601(Object obj) {
        if (abc.m1845() < 0) {
            return C0598.m11824(obj);
        }
        return 0;
    }

    public static Object m7602(Object obj) {
        if (C0457zc.m10735() <= 0) {
            return C0598.m11882(obj);
        }
        return null;
    }

    public static boolean m7603(Object obj, Object obj2, Object obj3) {
        if (C0456zb.m10326() <= 0) {
            return ((C0398od) obj).m1312a((X509Certificate) obj2, (X509Certificate) obj3);
        }
        return false;
    }

    public static InterfaceC0403oi m7604(Object obj) {
        if (abf.m2510() < 0) {
            return ((C0398od) obj).f1277uM;
        }
        return null;
    }

    public static boolean m7605(Object obj, Object obj2, Object obj3) {
        if (C0457zc.m10555() > 0) {
            return m7603((C0398od) obj, (X509Certificate) obj2, (X509Certificate) obj3);
        }
        return false;
    }

    public static InterfaceC0403oi m7606(Object obj) {
        if (abf.m2500() >= 0) {
            return m7604((C0398od) obj);
        }
        return null;
    }

    @Override
    public List<Certificate> mo1285a(List<Certificate> list, String str) throws SSLPeerUnverifiedException {
        X509Certificate x509Certificate;
        boolean z;
        ArrayDeque arrayDeque = new ArrayDeque(list);
        ArrayList arrayList = new ArrayList();
        C0460zg.m11251(arrayList, C0457zc.m10532(arrayDeque));
        boolean z2 = false;
        for (int i = 0; i < 9; i++) {
            X509Certificate x509Certificate2 = (X509Certificate) gggy.m4400(arrayList, m7601(arrayList) - 1);
            X509Certificate x509CertificateM9254 = C0449ye.m9254(C0453yj.m9960(this), x509Certificate2);
            if (x509CertificateM9254 != null) {
                if (m7601(arrayList) > 1 || !C0447yc.m8802(x509Certificate2, x509CertificateM9254)) {
                    C0460zg.m11251(arrayList, x509CertificateM9254);
                }
                if (gggy.m4372(this, x509CertificateM9254, x509CertificateM9254)) {
                    return arrayList;
                }
                z = true;
                z2 = z;
            } else {
                Iterator itM10319 = C0456zb.m10319(arrayDeque);
                do {
                    if (!C0455za.m10104(itM10319)) {
                        if (!z2) {
                            throw new SSLPeerUnverifiedException(abc.m1925(abd.m2090(C0460zg.m11407(new StringBuilder(), gggy.m4327()), x509Certificate2)));
                        }
                        return arrayList;
                    }
                    x509Certificate = (X509Certificate) m7602(itM10319);
                } while (!gggy.m4372(this, x509Certificate2, x509Certificate));
                abf.m2476(itM10319);
                C0460zg.m11251(arrayList, x509Certificate);
                z = z2;
                z2 = z;
            }
        }
        throw new SSLPeerUnverifiedException(abc.m1925(abd.m2090(C0460zg.m11407(new StringBuilder(), C0449ye.m9168()), arrayList)));
    }

    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        }
        return (obj instanceof C0398od) && C0459zf.m11147(C0453yj.m9960((C0398od) obj), C0453yj.m9960(this));
    }

    public int hashCode() {
        return C0446yb.m8544(C0453yj.m9960(this));
    }
}
