package com.google.android.material.card2;

class C0071cb implements CharSequence {

    char[] f117bl;

    C0071cb() {
    }

    public static char[] m3223(Object obj) {
        if (C0457zc.m10735() < 0) {
            return ((C0071cb) obj).f117bl;
        }
        return null;
    }

    public static char[] m3224(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return m3225(obj);
        }
        return null;
    }

    public static char[] m3225(Object obj) {
        if (C0453yj.m9966() >= 0) {
            return m3223((C0071cb) obj);
        }
        return null;
    }

    @Override
    public char charAt(int i) {
        return m3224(this)[i];
    }

    @Override
    public int length() {
        return m3224(this).length;
    }

    @Override
    public CharSequence subSequence(int i, int i2) {
        return new String(m3224(this), i, i2 - i);
    }
}
