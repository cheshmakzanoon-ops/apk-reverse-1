package com.google.android.material.card2;

import java.util.List;
import java.util.regex.Pattern;

public final class C0327lo {

    private static final Pattern f1007qh = C0461zs.m11638(C0453yj.m9988());

    private static long m1055Y(String str) {
        if (str == null) {
            return -1L;
        }
        try {
            return C0457zc.m10637(str);
        } catch (NumberFormatException e) {
            return -1L;
        }
    }

    public static int m1056a(String str, int i, String str2) {
        int i2 = i;
        while (i2 < gggy.m4397(str) && C0458ze.m10892(str2, C0446yb.m8419(str, i2)) == -1) {
            i2++;
        }
        return i2;
    }

    public static void m1057a(InterfaceC0259ja interfaceC0259ja, C0273jo c0273jo, C0271jm c0271jm) {
        if (interfaceC0259ja == C0453yj.m9922()) {
            return;
        }
        List listM1991 = abd.m1991(c0273jo, c0271jm);
        if (C0452yh.m9618(listM1991)) {
            return;
        }
        C0452yh.m9690(interfaceC0259ja, c0273jo, listM1991);
    }

    public static int m1058c(String str, int i) {
        try {
            long jM10637 = C0457zc.m10637(str);
            if (jM10637 > 2147483647L) {
                return Integer.MAX_VALUE;
            }
            if (jM10637 < 0) {
                return 0;
            }
            return (int) jM10637;
        } catch (NumberFormatException e) {
            return i;
        }
    }

    public static int m1059d(String str, int i) {
        char cM8419;
        int i2 = i;
        while (i2 < gggy.m4397(str) && ((cM8419 = C0446yb.m8419(str, i2)) == ' ' || cM8419 == '\t')) {
            i2++;
        }
        return i2;
    }

    public static long m1060d(C0271jm c0271jm) {
        return C0447yc.m8644(C0460zg.m11320(c0271jm, abf.m2534()));
    }

    public static long m1061h(C0290ke c0290ke) {
        return C0455za.m10221(C0447yc.m8818(c0290ke));
    }

    public static boolean m1062i(C0290ke c0290ke) {
        if (C0452yh.m9583(C0456zb.m10517(C0450yf.m9510(c0290ke)), abe.m2351())) {
            return false;
        }
        int iM9549 = C0450yf.m9549(c0290ke);
        if ((iM9549 >= 100 && iM9549 < 200) || iM9549 == 204 || iM9549 == 304) {
            return abf.m2415(c0290ke) != -1 || C0457zc.m10547(abc.m1898(), C0457zc.m10588(c0290ke, gggy.m4488()));
        }
        return true;
    }

    public static long m6128(Object obj) {
        if (C0461zs.m11510() < 0) {
            return m1055Y((String) obj);
        }
        return 0L;
    }

    public static long m6129(Object obj) {
        if (C0459zf.m11053() > 0) {
            return m6128((String) obj);
        }
        return 0L;
    }
}
