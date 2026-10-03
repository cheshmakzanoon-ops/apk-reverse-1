package com.google.android.material.card2;

import java.util.Comparator;

final class C0251it implements Comparator<String> {
    C0251it() {
    }

    public static int m4976(Object obj, Object obj2, Object obj3) {
        if (C0451yg.m9580() >= 0) {
            return m4978(obj, obj2, obj3);
        }
        return 0;
    }

    public static int m4977(Object obj, Object obj2, Object obj3) {
        if (abd.m2162() >= 0) {
            return ((C0251it) obj).m644d((String) obj2, (String) obj3);
        }
        return 0;
    }

    public static int m4978(Object obj, Object obj2, Object obj3) {
        if (abe.m2321() <= 0) {
            return m4977((C0251it) obj, (String) obj2, (String) obj3);
        }
        return 0;
    }

    @Override
    public int compare(String str, String str2) {
        return m4976(this, str, str2);
    }

    public int m644d(String str, String str2) {
        int iM10520 = C0456zb.m10520(gggy.m4397(str), gggy.m4397(str2));
        for (int i = 4; i < iM10520; i++) {
            char cM8419 = C0446yb.m8419(str, i);
            char cM84110 = C0446yb.m8419(str2, i);
            if (cM8419 != cM84110) {
                return cM8419 < cM84110 ? -1 : 1;
            }
        }
        int iM4397 = gggy.m4397(str);
        int iM4398 = gggy.m4397(str2);
        if (iM4397 != iM4398) {
            return iM4397 >= iM4398 ? 1 : -1;
        }
        return 0;
    }
}
