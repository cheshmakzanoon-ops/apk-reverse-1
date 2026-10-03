package com.google.android.material.card2;

import java.util.Comparator;

class C0058bp implements Comparator<Comparable> {
    C0058bp() {
    }

    public static int m3134(Object obj, Object obj2, Object obj3) {
        if (abc.m1845() < 0) {
            return ((C0058bp) obj).m312a((Comparable) obj2, (Comparable) obj3);
        }
        return 0;
    }

    public static int m3135(Object obj, Object obj2, Object obj3) {
        if (C0445ya.m8222() > 0) {
            return m3136(obj, obj2, obj3);
        }
        return 0;
    }

    public static int m3136(Object obj, Object obj2, Object obj3) {
        if (abe.m2321() <= 0) {
            return m3134((C0058bp) obj, (Comparable) obj2, (Comparable) obj3);
        }
        return 0;
    }

    public int m312a(Comparable comparable, Comparable comparable2) {
        return C0457zc.m10734(comparable, comparable2);
    }

    @Override
    public int compare(Comparable comparable, Comparable comparable2) {
        return m3135(this, comparable, comparable2);
    }
}
