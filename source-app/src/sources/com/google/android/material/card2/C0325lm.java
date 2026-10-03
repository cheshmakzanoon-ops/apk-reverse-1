package com.google.android.material.card2;

import java.text.DateFormat;
import java.text.ParsePosition;
import java.text.SimpleDateFormat;
import java.util.Date;

public final class C0325lm {

    private static final ThreadLocal<DateFormat> f1006qg = new C0326ln();

    private static final String[] f1005qf = {C0457zc.m10623(), gggy.m4465(), C0455za.m10177(), C0449ye.m9291(), abe.m2389(), abd.m2004(), C0453yj.m9900(), abc.m1948(), abe.m2340(), C0448yd.m8951(), C0453yj.m9848(), abc.m1777(), m6116(), C0457zc.m10545(), C0458ze.m10864()};

    private static final DateFormat[] f1004qe = new DateFormat[C0445ya.m8191().length];

    public static Date m1052X(String str) {
        if (gggy.m4397(str) == 0) {
            return null;
        }
        ParsePosition parsePosition = new ParsePosition(0);
        Date dateM6117 = m6117((DateFormat) C0448yd.m8940(C0450yf.m9422()), str, parsePosition);
        if (m6121(parsePosition) == gggy.m4397(str)) {
            return dateM6117;
        }
        synchronized (C0445ya.m8191()) {
            int length = C0445ya.m8191().length;
            for (int i = 0; i < length; i++) {
                DateFormat simpleDateFormat = C0456zb.m10288()[i];
                if (simpleDateFormat == null) {
                    simpleDateFormat = new SimpleDateFormat(C0445ya.m8191()[i], C0446yb.m8554());
                    C0455za.m10186(simpleDateFormat, C0450yf.m9401());
                    C0456zb.m10288()[i] = simpleDateFormat;
                }
                C0450yf.m9450(parsePosition, 0);
                Date dateM6118 = m6117(simpleDateFormat, str, parsePosition);
                if (m6121(parsePosition) != 0) {
                    return dateM6118;
                }
            }
            return null;
        }
    }

    public static String m1053a(Date date) {
        return abd.m2048((DateFormat) C0448yd.m8940(C0450yf.m9422()), date);
    }

    public static String m6116() {
        if (C0445ya.m8222() > 0) {
            return C0598.m11832();
        }
        return null;
    }

    public static Date m6117(Object obj, Object obj2, Object obj3) {
        if (C0452yh.m9798() >= 0) {
            return C0598.m11888(obj, obj2, obj3);
        }
        return null;
    }

    public static ThreadLocal m6118() {
        if (C0447yc.m8635() >= 0) {
            return f1006qg;
        }
        return null;
    }

    public static DateFormat[] m6119() {
        if (C0456zb.m10326() <= 0) {
            return f1004qe;
        }
        return null;
    }

    public static String[] m6120() {
        if (C0450yf.m9352() <= 0) {
            return f1005qf;
        }
        return null;
    }

    public static int m6121(Object obj) {
        if (C0459zf.m11062() > 0) {
            return C0598.m11898(obj);
        }
        return 0;
    }

    public static ThreadLocal m6122() {
        if (C0453yj.m9966() > 0) {
            return m6118();
        }
        return null;
    }

    public static String[] m6123() {
        if (C0447yc.m8786() > 0) {
            return m6120();
        }
        return null;
    }

    public static DateFormat[] m6124() {
        if (C0453yj.m10032() >= 0) {
            return m6119();
        }
        return null;
    }
}
