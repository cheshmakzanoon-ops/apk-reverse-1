package com.google.android.material.card2;

import java.security.cert.X509Certificate;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.Map;
import java.util.Set;
import javax.security.auth.x500.X500Principal;

public final class C0399oe implements InterfaceC0403oi {

    private final Map<X500Principal, Set<X509Certificate>> f1278uN = new LinkedHashMap();

    public C0399oe(X509Certificate... x509CertificateArr) {
        for (X509Certificate x509Certificate : x509CertificateArr) {
            X500Principal x500PrincipalM4314 = gggy.m4314(x509Certificate);
            Object linkedHashSet = (Set) adds.m2889(abe.m2269(this), x500PrincipalM4314);
            if (linkedHashSet == null) {
                linkedHashSet = new LinkedHashSet(1);
                C0445ya.m8264(abe.m2269(this), x500PrincipalM4314, linkedHashSet);
            }
            C0452yh.m9790(linkedHashSet, x509Certificate);
        }
    }

    public static Map m7607(Object obj) {
        if (C0453yj.m10013() >= 0) {
            return ((C0399oe) obj).f1278uN;
        }
        return null;
    }

    public static Object m7608(Object obj) {
        if (C0461zs.m11510() < 0) {
            return C0598.m11882(obj);
        }
        return null;
    }

    public static Map m7609(Object obj) {
        if (C0447yc.m8786() >= 0) {
            return m7607((C0399oe) obj);
        }
        return null;
    }

    @Override
    public X509Certificate mo1286c(X509Certificate x509Certificate) {
        Set set = (Set) adds.m2889(abe.m2269(this), C0459zf.m11017(x509Certificate));
        if (set == null) {
            return null;
        }
        Iterator itM9939 = C0453yj.m9939(set);
        while (C0455za.m10104(itM9939)) {
            X509Certificate x509Certificate2 = (X509Certificate) m7608(itM9939);
            try {
                C0445ya.m8354(x509Certificate, C0455za.m10115(x509Certificate2));
                return x509Certificate2;
            } catch (Exception e) {
            }
        }
        return null;
    }

    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        }
        return (obj instanceof C0399oe) && abd.m2124(abe.m2269((C0399oe) obj), abe.m2269(this));
    }

    public int hashCode() {
        return C0459zf.m11069(abe.m2269(this));
    }
}
