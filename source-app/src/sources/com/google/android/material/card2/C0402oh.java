package com.google.android.material.card2;

import java.security.cert.CertificateParsingException;
import java.security.cert.X509Certificate;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.SSLException;
import javax.net.ssl.SSLSession;

public final class C0402oh implements HostnameVerifier {

    public static final C0402oh f1286uT = new C0402oh();

    private C0402oh() {
    }

    private static List<String> m1322a(X509Certificate x509Certificate, int i) {
        Integer num;
        String str;
        ArrayList arrayList = new ArrayList();
        try {
            Collection collectionM10380 = C0456zb.m10380(x509Certificate);
            if (collectionM10380 == null) {
                return C0461zs.m11607();
            }
            Iterator itM4289 = gggy.m4289(collectionM10380);
            while (C0455za.m10104(itM4289)) {
                List list = (List) m7656(itM4289);
                if (list != null && m7657(list) >= 2 && (num = (Integer) gggy.m4400(list, 0)) != null && m7652(num) == i && (str = (String) gggy.m4400(list, 1)) != null) {
                    C0460zg.m11251(arrayList, str);
                }
            }
            return arrayList;
        } catch (CertificateParsingException e) {
            return C0461zs.m11607();
        }
    }

    private boolean m1323a(String str, X509Certificate x509Certificate) {
        String strM11361;
        String strM9261 = C0449ye.m9261(str, C0446yb.m8554());
        List listM9963 = C0453yj.m9963(x509Certificate, 2);
        int iM7657 = m7657(listM9963);
        boolean z = false;
        int i = 0;
        while (i < iM7657) {
            if (gggy.m4329(this, strM9261, (String) gggy.m4400(listM9963, i))) {
                return true;
            }
            i++;
            z = true;
        }
        if (z || (strM11361 = C0460zg.m11361(new C0401og(gggy.m4314(x509Certificate)), C0459zf.m10985())) == null) {
            return false;
        }
        return gggy.m4329(this, strM9261, strM11361);
    }

    private boolean m1324b(String str, X509Certificate x509Certificate) {
        List listM9963 = C0453yj.m9963(x509Certificate, 7);
        int iM7657 = m7657(listM9963);
        for (int i = 0; i < iM7657; i++) {
            if (C0457zc.m10547(str, (String) gggy.m4400(listM9963, i))) {
                return true;
            }
        }
        return false;
    }

    public static List<String> m1325d(X509Certificate x509Certificate) {
        List listM9963 = C0453yj.m9963(x509Certificate, 7);
        List listM9964 = C0453yj.m9963(x509Certificate, 2);
        ArrayList arrayList = new ArrayList(m7657(listM9963) + m7657(listM9964));
        C0447yc.m8634(arrayList, listM9963);
        C0447yc.m8634(arrayList, listM9964);
        return arrayList;
    }

    public static int m7652(Object obj) {
        if (C0457zc.m10735() <= 0) {
            return C0598.m11854(obj);
        }
        return 0;
    }

    public static boolean m7653(Object obj, Object obj2, Object obj3) {
        if (C0457zc.m10735() <= 0) {
            return ((C0402oh) obj).m1324b((String) obj2, (X509Certificate) obj3);
        }
        return false;
    }

    public static List m7654(Object obj, int i) {
        if (C0461zs.m11510() <= 0) {
            return m1322a((X509Certificate) obj, i);
        }
        return null;
    }

    public static boolean m7655(Object obj, Object obj2, Object obj3) {
        if (C0461zs.m11510() < 0) {
            return ((C0402oh) obj).m1323a((String) obj2, (X509Certificate) obj3);
        }
        return false;
    }

    public static Object m7656(Object obj) {
        if (C0460zg.m11287() > 0) {
            return C0598.m11882(obj);
        }
        return null;
    }

    public static int m7657(Object obj) {
        if (abf.m2510() < 0) {
            return C0598.m11824(obj);
        }
        return 0;
    }

    public static String m7658(Object obj, Object obj2) {
        if (C0456zb.m10326() <= 0) {
            return ((C0401og) obj).m1321al((String) obj2);
        }
        return null;
    }

    public static List m7659(Object obj, int i) {
        if (gggy.m4365() > 0) {
            return m7654((X509Certificate) obj, i);
        }
        return null;
    }

    public static String m7660(Object obj, Object obj2) {
        if (C0457zc.m10718() < 0) {
            return m7658((C0401og) obj, (String) obj2);
        }
        return null;
    }

    public static boolean m7661(Object obj, Object obj2, Object obj3) {
        if (C0456zb.m10484() <= 0) {
            return m7655((C0402oh) obj, (String) obj2, (X509Certificate) obj3);
        }
        return false;
    }

    public static boolean m7662(Object obj, Object obj2, Object obj3) {
        if (abe.m2321() < 0) {
            return m7653((C0402oh) obj, (String) obj2, (X509Certificate) obj3);
        }
        return false;
    }

    public boolean m1326c(String str, X509Certificate x509Certificate) {
        return C0453yj.m9993(str) ? C0450yf.m9453(this, str, x509Certificate) : C0450yf.m9395(this, str, x509Certificate);
    }

    public boolean m1327o(String str, String str2) {
        String strM1925 = str2;
        String strM1926 = str;
        if (strM1926 == null || gggy.m4397(strM1926) == 0 || C0458ze.m10811(strM1926, C0452yh.m9669()) || C0459zf.m11107(strM1926, C0458ze.m10940()) || strM1925 == null || gggy.m4397(strM1925) == 0 || C0458ze.m10811(strM1925, C0452yh.m9669()) || C0459zf.m11107(strM1925, C0458ze.m10940())) {
            return false;
        }
        if (!C0459zf.m11107(strM1926, C0452yh.m9669())) {
            strM1926 = abc.m1925(abe.m2346(C0460zg.m11407(new StringBuilder(), strM1926), '.'));
        }
        if (!C0459zf.m11107(strM1925, C0452yh.m9669())) {
            strM1925 = abc.m1925(abe.m2346(C0460zg.m11407(new StringBuilder(), strM1925), '.'));
        }
        String strM9261 = C0449ye.m9261(strM1925, C0446yb.m8554());
        if (!C0446yb.m8589(strM9261, C0456zb.m10391())) {
            return C0452yh.m9583(strM1926, strM9261);
        }
        if (!C0458ze.m10811(strM9261, C0448yd.m9034()) || C0457zc.m10546(strM9261, 42, 1) != -1 || gggy.m4397(strM1926) < gggy.m4397(strM9261) || C0452yh.m9583(C0448yd.m9034(), strM9261)) {
            return false;
        }
        String strM1972 = abc.m1972(strM9261, 1);
        if (!C0459zf.m11107(strM1926, strM1972)) {
            return false;
        }
        int iM4397 = gggy.m4397(strM1926) - gggy.m4397(strM1972);
        return iM4397 <= 0 || C0455za.m10102(strM1926, 46, iM4397 + (-1)) == -1;
    }

    @Override
    public boolean verify(String str, SSLSession sSLSession) {
        try {
            return C0456zb.m10323(this, str, (X509Certificate) C0460zg.m11340(sSLSession)[0]);
        } catch (SSLException e) {
            return false;
        }
    }
}
