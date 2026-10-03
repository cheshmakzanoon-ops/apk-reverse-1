package com.google.android.material.card2;

import java.util.Comparator;

final class C0299kn implements Comparator<String> {
    C0299kn() {
    }

    public static int m5785(Object obj, Object obj2, Object obj3) {
        if (gggy.m4269() <= 0) {
            return m5787(obj, obj2, obj3);
        }
        return 0;
    }

    public static int m5786(Object obj, Object obj2, Object obj3) {
        if (C0449ye.m9220() <= 0) {
            return ((C0299kn) obj).m960d((String) obj2, (String) obj3);
        }
        return 0;
    }

    public static int m5787(Object obj, Object obj2, Object obj3) {
        if (C0458ze.m10926() <= 0) {
            return m5786((C0299kn) obj, (String) obj2, (String) obj3);
        }
        return 0;
    }

    @Override
    public int compare(String str, String str2) {
        return m5785(this, str, str2);
    }

    public int m960d(String str, String str2) {
        return C0452yh.m9795(str, str2);
    }
}
