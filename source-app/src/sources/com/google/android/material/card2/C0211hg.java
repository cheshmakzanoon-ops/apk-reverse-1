package com.google.android.material.card2;

import java.security.SecureRandom;
import java.util.Iterator;
import java.util.Map;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

public class C0211hg {

    private static C0211hg f418gy;

    protected C0279ju f419gx;

    public static synchronized C0211hg m576bq() {
        if (C0450yf.m9469() == null) {
            f418gy = new C0211hg();
        }
        return C0450yf.m9469();
    }

    private C0279ju m577br() {
        if (abf.m2631(this) == null) {
            C0281jw c0281jw = new C0281jw();
            try {
                TrustManager[] trustManagerArr = {new C0212hh(this)};
                SSLContext sSLContextM11174 = C0459zf.m11174(C0450yf.m9338());
                gggy.m4433(sSLContextM11174, null, trustManagerArr, new SecureRandom());
                C0445ya.m8371(c0281jw, m4619(sSLContextM11174), (X509TrustManager) trustManagerArr[0]);
                gggy.m4435(c0281jw, 15000L, adds.m2789());
                C0457zc.m10635(c0281jw, 25000L, adds.m2789());
                C0453yj.m9898(c0281jw, 25000L, adds.m2789());
                C0446yb.m8509(c0281jw, new C0213hi(this));
            } catch (Exception e) {
            }
            this.f419gx = C0455za.m10166(c0281jw);
        }
        return abf.m2631(this);
    }

    public static Object m4617(Object obj) {
        if (C0450yf.m9352() < 0) {
            return C0598.m11882(obj);
        }
        return null;
    }

    public static C0273jo m4618(Object obj) {
        if (C0461zs.m11510() < 0) {
            return C0598.m11798(obj);
        }
        return null;
    }

    public static SSLSocketFactory m4619(Object obj) {
        if (abf.m2510() < 0) {
            return C0598.m11830(obj);
        }
        return null;
    }

    public static C0211hg m4620() {
        if (abc.m1845() <= 0) {
            return f418gy;
        }
        return null;
    }

    public static C0279ju m4621(Object obj) {
        if (C0461zs.m11510() < 0) {
            return ((C0211hg) obj).m577br();
        }
        return null;
    }

    public static C0279ju m4622(Object obj) {
        if (C0458ze.m10932() > 0) {
            return ((C0211hg) obj).f419gx;
        }
        return null;
    }

    public static C0279ju m4623(Object obj) {
        if (abd.m2021() > 0) {
            return m4621((C0211hg) obj);
        }
        return null;
    }

    public static C0279ju m4624(Object obj) {
        if (C0448yd.m9015() < 0) {
            return m4622((C0211hg) obj);
        }
        return null;
    }

    public static C0211hg m4625() {
        if (C0460zg.m11293() > 0) {
            return m4620();
        }
        return null;
    }

    public void m578a(C0209he c0209he, String str, String str2, String str3, InterfaceC0210hf interfaceC0210hf) {
        C0287kb c0287kb = new C0287kb();
        C0272jn c0272jn = new C0272jn();
        if (C0460zg.m11263(C0446yb.m8563(c0209he)) > 0) {
            Iterator itM9939 = C0453yj.m9939(C0453yj.m10021(C0446yb.m8563(c0209he)));
            while (C0455za.m10104(itM9939)) {
                Map.Entry entry = (Map.Entry) m4617(itM9939);
                C0458ze.m10775(c0272jn, (String) abe.m2338(entry), C0456zb.m10388(C0455za.m10227(entry)));
            }
        }
        try {
            if (C0461zs.m11448(c0209he) != 0) {
                AbstractC0288kc abstractC0288kcM8318 = C0445ya.m8318(C0445ya.m8204(C0461zs.m11434()), C0449ye.m9167(new C0285k(), adds.m2871(c0209he)));
                if (C0452yh.m9583(str, C0453yj.m10028())) {
                    C0459zf.m11115(C0452yh.m9665(gggy.m4456(c0287kb, str2), C0456zb.m10427(c0272jn)));
                } else {
                    C0445ya.m8297(C0452yh.m9665(gggy.m4456(c0287kb, str2), C0456zb.m10427(c0272jn)), str, abstractC0288kcM8318);
                }
            } else if (C0452yh.m9583(str, C0453yj.m10028())) {
                try {
                    C0274jp c0274jpM10504 = C0456zb.m10504(m4618(str2));
                    if (C0460zg.m11263(adds.m2871(c0209he)) > 0) {
                        Iterator itM99310 = C0453yj.m9939(C0453yj.m10021(adds.m2871(c0209he)));
                        while (C0455za.m10104(itM99310)) {
                            Map.Entry entry2 = (Map.Entry) m4617(itM99310);
                            adds.m2717(c0274jpM10504, (String) abe.m2338(entry2), C0456zb.m10388(C0455za.m10227(entry2)));
                        }
                    }
                    C0459zf.m11115(C0452yh.m9665(C0458ze.m10923(c0287kb, C0449ye.m9107(c0274jpM10504)), C0456zb.m10427(c0272jn)));
                } catch (NullPointerException e) {
                    throw new NullPointerException(abc.m1925(C0460zg.m11407(new StringBuilder(C0448yd.m9036()), str2)));
                }
            } else {
                C0269jk c0269jk = new C0269jk();
                if (C0460zg.m11263(adds.m2871(c0209he)) > 0) {
                    Iterator itM99311 = C0453yj.m9939(C0453yj.m10021(adds.m2871(c0209he)));
                    while (C0455za.m10104(itM99311)) {
                        Map.Entry entry3 = (Map.Entry) m4617(itM99311);
                        abc.m1873(c0269jk, (String) abe.m2338(entry3), C0456zb.m10388(C0455za.m10227(entry3)));
                    }
                }
                C0445ya.m8297(C0452yh.m9665(gggy.m4456(c0287kb, str2), C0456zb.m10427(c0272jn)), str, C0457zc.m10746(c0269jk));
            }
            abd.m2038(C0453yj.m9973(abd.m2173(this), C0448yd.m8952(c0287kb)), new C0214hj(this, c0209he, interfaceC0210hf, str3));
        } catch (Exception e2) {
            C0460zg.m11359(interfaceC0210hf, str3, C0450yf.m9396(e2));
        }
    }
}
