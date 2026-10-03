package com.ishumei.smantifraud;

public class l11l11lI1lll {
    public static final boolean l1111l111111Il = false;
    public static final String l111l11111I1l = "3.14.3";
    public static final String l111l11111Il = "build1";
    public static final boolean l111l11111lIl = false;
    public static final String l111l1111l1Il = "android";
    public static final String l111l1111lI1l = "api-fp-retry-bj.fengkongcloud.com";
    public static final String l111l1111lIl = "fp-sa-it.fengkongcloud.com";
    public static final String l111l1111llIl = "fp-it.fengkongcloud.com";
    public static final String l11l1111I11l = "fp-na-it-acc.fengkongcloud.com";
    public static final String l11l1111I1l = "api-fp-retry-na.fengkongcloud.com";
    public static final String l11l1111I1ll = "/deviceprofile/v4";
    public static final String l11l1111Il = "/v3/cloudconf";
    public static final int l11l1111Il1l = 30;
    public static final String l11l1111lIIl = "api-fp-retry-sa.fengkongcloud.com";

    public static String l1111l111111Il(String str) {
        str.getClass();
        str.hashCode();
        switch (str) {
            case "bj":
                return "001";
            case "xjp":
                return "010";
            case "fjny":
                return "011";
            default:
                return str;
        }
    }

    public static String l1111l111111Il(String str, boolean z) {
        return l1111l111111Il(z) + l111l11111lIl(str, false) + l11l1111Il;
    }

    public static String l1111l111111Il(boolean z) {
        return z ? "https://" : "http://";
    }

    public static String l111l11111I1l(String str, boolean z) {
        return l1111l111111Il(z) + l111l11111lIl(str, true) + l11l1111I1ll;
    }

    public static String l111l11111Il(String str, boolean z) {
        return l1111l111111Il(z) + l111l11111lIl(str, false) + l11l1111I1ll;
    }

    public static String l111l11111lIl(String str, boolean z) {
        str.getClass();
        if (str.equals(SmAntiFraud.AREA_XJP)) {
            return z ? l11l1111lIIl : l111l1111lIl;
        }
        if (str.equals(SmAntiFraud.AREA_FJNY)) {
            return z ? l11l1111I1l : l11l1111I11l;
        }
        return z ? l111l1111lI1l : l111l1111llIl;
    }
}
