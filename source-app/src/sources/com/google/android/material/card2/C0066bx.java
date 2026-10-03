package com.google.android.material.card2;

import java.text.DateFormat;
import java.text.SimpleDateFormat;

public class C0066bx {
    private static String m319a(int i) {
        switch (i) {
            case 0:
                return C0450yf.m9519();
            case 1:
                return C0458ze.m10895();
            case 2:
                return C0445ya.m8273();
            case 3:
                return C0458ze.m10911();
            default:
                throw new IllegalArgumentException(abc.m1925(adds.m2680(C0460zg.m11407(new StringBuilder(), C0445ya.m8305()), i)));
        }
    }

    public static DateFormat m320a(int i, int i2) {
        return new SimpleDateFormat(abc.m1925(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), abd.m2149(i)), C0448yd.m9049()), C0459zf.m11098(i2))), C0446yb.m8554());
    }

    private static String m321b(int i) {
        switch (i) {
            case 0:
            case 1:
                return C0458ze.m10850();
            case 2:
                return abe.m2319();
            case 3:
                return C0456zb.m10352();
            default:
                throw new IllegalArgumentException(abc.m1925(adds.m2680(C0460zg.m11407(new StringBuilder(), C0445ya.m8305()), i)));
        }
    }

    public static String m3213(int i) {
        if (C0446yb.m8415() <= 0) {
            return m319a(i);
        }
        return null;
    }

    public static String m3214(int i) {
        if (C0456zb.m10326() < 0) {
            return m321b(i);
        }
        return null;
    }

    public static String m3215(int i) {
        if (C0460zg.m11293() >= 0) {
            return m3214(i);
        }
        return null;
    }

    public static String m3216(int i) {
        if (C0453yj.m10032() > 0) {
            return m3213(i);
        }
        return null;
    }
}
