package com.google.android.material.card2;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;
import javax.annotation.Nullable;

public final class C0271jm {

    private final String[] f707lM;

    C0271jm(C0272jn c0272jn) {
        this.f707lM = (String[]) C0456zb.m10507(abe.m2284(c0272jn), new String[m5159(abe.m2284(c0272jn))]);
    }

    private static String m717a(String[] strArr, String str) {
        for (int length = strArr.length - 2; length >= 0; length -= 2) {
            if (C0457zc.m10547(str, strArr[length])) {
                return strArr[length + 1];
            }
        }
        return null;
    }

    public static int m5159(Object obj) {
        if (abe.m2308() < 0) {
            return C0598.m11824(obj);
        }
        return 0;
    }

    public static String[] m5160(Object obj) {
        if (C0450yf.m9352() < 0) {
            return ((C0271jm) obj).f707lM;
        }
        return null;
    }

    public static List m5161(Object obj) {
        if (abf.m2510() < 0) {
            return ((C0272jn) obj).f708lN;
        }
        return null;
    }

    public static String m5162(Object obj, Object obj2) {
        if (C0446yb.m8415() <= 0) {
            return m717a((String[]) obj, (String) obj2);
        }
        return null;
    }

    public static String[] m5163(Object obj) {
        if (abd.m2166() < 0) {
            return m5160((C0271jm) obj);
        }
        return null;
    }

    public static String m5164(Object obj, Object obj2) {
        if (abd.m2166() < 0) {
            return m5162((String[]) obj, (String) obj2);
        }
        return null;
    }

    public static List m5165(Object obj) {
        if (abd.m2021() > 0) {
            return m5161((C0272jn) obj);
        }
        return null;
    }

    public Set<String> m718ck() {
        TreeSet treeSet = new TreeSet(C0448yd.m8899());
        int iM11431 = C0460zg.m11431(this);
        for (int i = 0; i < iM11431; i++) {
            C0449ye.m9209(treeSet, C0446yb.m8434(this, i));
        }
        return abf.m2620(treeSet);
    }

    public C0272jn m719cl() {
        C0272jn c0272jn = new C0272jn();
        C0458ze.m10804(abe.m2284(c0272jn), C0460zg.m11423(this));
        return c0272jn;
    }

    public boolean equals(@Nullable Object obj) {
        return (obj instanceof C0271jm) && C0456zb.m10410(C0460zg.m11423((C0271jm) obj), C0460zg.m11423(this));
    }

    public String m720g(int i) {
        return C0460zg.m11423(this)[i * 2];
    }

    public String m721h(int i) {
        return C0460zg.m11423(this)[(i * 2) + 1];
    }

    public int hashCode() {
        return C0448yd.m9083(C0460zg.m11423(this));
    }

    public int size() {
        return C0460zg.m11423(this).length / 2;
    }

    public String toString() {
        StringBuilder sb = new StringBuilder();
        int iM11431 = C0460zg.m11431(this);
        for (int i = 0; i < iM11431; i++) {
            C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(sb, C0446yb.m8434(this, i)), C0455za.m10252()), gggy.m4283(this, i)), C0447yc.m8732());
        }
        return abc.m1925(sb);
    }

    @Nullable
    public String m722v(String str) {
        return C0447yc.m8615(C0460zg.m11423(this), str);
    }

    public List<String> m723w(String str) {
        ArrayList arrayList = null;
        int iM11431 = C0460zg.m11431(this);
        for (int i = 0; i < iM11431; i++) {
            if (C0457zc.m10547(str, C0446yb.m8434(this, i))) {
                if (arrayList == null) {
                    arrayList = new ArrayList(2);
                }
                C0460zg.m11251(arrayList, gggy.m4283(this, i));
            }
        }
        return arrayList != null ? abc.m1875(arrayList) : C0461zs.m11607();
    }
}
