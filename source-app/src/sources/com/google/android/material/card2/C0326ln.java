package com.google.android.material.card2;

import java.text.DateFormat;
import java.text.SimpleDateFormat;

final class C0326ln extends ThreadLocal<DateFormat> {
    C0326ln() {
    }

    public static DateFormat m6125(Object obj) {
        if (C0457zc.m10735() <= 0) {
            return ((C0326ln) obj).m1054ef();
        }
        return null;
    }

    public static DateFormat m6126(Object obj) {
        if (adds.m2755() > 0) {
            return m6127(obj);
        }
        return null;
    }

    public static DateFormat m6127(Object obj) {
        if (C0453yj.m9945() <= 0) {
            return m6125((C0326ln) obj);
        }
        return null;
    }

    protected DateFormat m1054ef() {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat(abe.m2278(), C0446yb.m8554());
        C0455za.m10245(simpleDateFormat, false);
        C0455za.m10186(simpleDateFormat, C0450yf.m9401());
        return simpleDateFormat;
    }

    @Override
    protected DateFormat initialValue() {
        return m6126(this);
    }
}
