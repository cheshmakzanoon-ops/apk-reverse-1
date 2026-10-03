package com.google.android.material.card2;

import java.security.cert.X509Certificate;
import javax.net.ssl.X509TrustManager;

class C0212hh implements X509TrustManager {

    final C0211hg f420gz;

    C0212hh(C0211hg c0211hg) {
        this.f420gz = c0211hg;
    }

    @Override
    public void checkClientTrusted(X509Certificate[] x509CertificateArr, String str) {
    }

    @Override
    public void checkServerTrusted(X509Certificate[] x509CertificateArr, String str) {
    }

    @Override
    public X509Certificate[] getAcceptedIssuers() {
        return new X509Certificate[0];
    }
}
