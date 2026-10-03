package com.google.android.material.card2;

import java.math.BigDecimal;

public final class C0056bn extends Number {

    private final String f82aL;

    public C0056bn(String str) {
        this.f82aL = str;
    }

    private Object writeReplace() {
        return new BigDecimal(gggy.m4318(this));
    }

    public static String m3061(Object obj) {
        if (C0460zg.m11287() > 0) {
            return ((C0056bn) obj).f82aL;
        }
        return null;
    }

    public static String m3062(Object obj) {
        if (abd.m2166() <= 0) {
            return m3061((C0056bn) obj);
        }
        return null;
    }

    @Override
    public double doubleValue() {
        return C0445ya.m8298(gggy.m4318(this));
    }

    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj instanceof C0056bn) {
            C0056bn c0056bn = (C0056bn) obj;
            if (gggy.m4318(this) == gggy.m4318(c0056bn) || C0452yh.m9583(gggy.m4318(this), gggy.m4318(c0056bn))) {
                return true;
            }
        }
        return false;
    }

    @Override
    public float floatValue() {
        return abd.m2190(gggy.m4318(this));
    }

    public int hashCode() {
        return C0460zg.m11248(gggy.m4318(this));
    }

    @Override
    public int intValue() {
        try {
            return C0448yd.m8889(gggy.m4318(this));
        } catch (NumberFormatException e) {
            try {
                return (int) C0457zc.m10637(gggy.m4318(this));
            } catch (NumberFormatException e2) {
                return C0449ye.m9156(new BigDecimal(gggy.m4318(this)));
            }
        }
    }

    @Override
    public long longValue() {
        try {
            return C0457zc.m10637(gggy.m4318(this));
        } catch (NumberFormatException e) {
            return gggy.m4355(new BigDecimal(gggy.m4318(this)));
        }
    }

    public String toString() {
        return gggy.m4318(this);
    }
}
