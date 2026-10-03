package com.google.android.material.card2;

import java.nio.charset.Charset;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.annotation.Nullable;

public final class C0278jt {

    @Nullable
    private final String f735ml;

    private final String f736mm;

    private final String f737mn;

    private final String f738mo;

    private static final Pattern f734mk = C0461zs.m11638(C0457zc.m10574());

    private static final Pattern f733mj = C0461zs.m11638(C0459zf.m11213());

    private C0278jt(String str, String str2, String str3, @Nullable String str4) {
        this.f736mm = str;
        this.f738mo = str2;
        this.f737mn = str3;
        this.f735ml = str4;
    }

    @Nullable
    public static C0278jt m788L(String str) {
        Matcher matcherM10828 = C0458ze.m10828(C0445ya.m8375(), str);
        if (!abc.m1824(matcherM10828)) {
            return null;
        }
        String strM9261 = C0449ye.m9261(C0452yh.m9683(matcherM10828, 1), C0446yb.m8554());
        String strM9262 = C0449ye.m9261(C0452yh.m9683(matcherM10828, 2), C0446yb.m8554());
        Matcher matcherM10829 = C0458ze.m10828(C0460zg.m11270(), str);
        String str2 = null;
        for (int iM8997 = C0448yd.m8997(matcherM10828); iM8997 < gggy.m4397(str); iM8997 = C0448yd.m8997(matcherM10829)) {
            adds.m2733(matcherM10829, iM8997, gggy.m4397(str));
            if (!abc.m1824(matcherM10829)) {
                return null;
            }
            String strM9683 = C0452yh.m9683(matcherM10829, 1);
            if (strM9683 != null && C0457zc.m10547(strM9683, C0446yb.m8543())) {
                String strM9684 = C0452yh.m9683(matcherM10829, 2);
                if (strM9684 == null) {
                    strM9684 = C0452yh.m9683(matcherM10829, 3);
                } else if (C0458ze.m10811(strM9684, C0459zf.m11010()) && C0459zf.m11107(strM9684, C0459zf.m11010()) && gggy.m4397(strM9684) > 2) {
                    strM9684 = C0447yc.m8745(strM9684, 1, gggy.m4397(strM9684) - 1);
                }
                if (str2 != null && !C0457zc.m10547(strM9684, str2)) {
                    return null;
                }
                str2 = strM9684;
            }
        }
        return new C0278jt(str, strM9261, strM9262, str2);
    }

    public static Pattern m5306() {
        if (C0456zb.m10326() <= 0) {
            return f734mk;
        }
        return null;
    }

    public static Pattern m5307() {
        if (C0449ye.m9220() <= 0) {
            return f733mj;
        }
        return null;
    }

    public static String m5308(Object obj) {
        if (abe.m2308() < 0) {
            return ((C0278jt) obj).f736mm;
        }
        return null;
    }

    public static String m5309(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return ((C0278jt) obj).f735ml;
        }
        return null;
    }

    public static Pattern m5310() {
        if (C0453yj.m9945() < 0) {
            return m5307();
        }
        return null;
    }

    public static String m5311(Object obj) {
        if (abf.m2500() > 0) {
            return m5309((C0278jt) obj);
        }
        return null;
    }

    public static Pattern m5312() {
        if (C0445ya.m8330() >= 0) {
            return m5306();
        }
        return null;
    }

    public static String m5313(Object obj) {
        if (C0448yd.m9015() <= 0) {
            return m5308((C0278jt) obj);
        }
        return null;
    }

    @Nullable
    public Charset m789a(@Nullable Charset charset) {
        try {
            return C0452yh.m9808(this) != null ? C0457zc.m10654(C0452yh.m9808(this)) : charset;
        } catch (IllegalArgumentException e) {
            return charset;
        }
    }

    @Nullable
    public Charset m790cJ() {
        return C0460zg.m11390(this, null);
    }

    public boolean equals(@Nullable Object obj) {
        return (obj instanceof C0278jt) && C0452yh.m9583(C0458ze.m10808((C0278jt) obj), C0458ze.m10808(this));
    }

    public int hashCode() {
        return C0460zg.m11248(C0458ze.m10808(this));
    }

    public String toString() {
        return C0458ze.m10808(this);
    }
}
