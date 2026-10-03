package com.google.android.material.card2;

import java.net.Proxy;

public final class C0331ls {
    public static String m1074a(C0286ka c0286ka, Proxy.Type type) {
        StringBuilder sb = new StringBuilder();
        C0460zg.m11407(sb, C0456zb.m10517(c0286ka));
        abe.m2346(sb, ' ');
        if (C0461zs.m11617(c0286ka, type)) {
            abd.m2090(sb, C0448yd.m9070(c0286ka));
        } else {
            C0460zg.m11407(sb, abf.m2473(C0448yd.m9070(c0286ka)));
        }
        C0460zg.m11407(sb, C0448yd.m9022());
        return abc.m1925(sb);
    }

    private static boolean m1075b(C0286ka c0286ka, Proxy.Type type) {
        return !C0455za.m10072(c0286ka) && type == abc.m1914();
    }

    public static String m1076d(C0273jo c0273jo) {
        String strM2414 = abf.m2414(c0273jo);
        String strM11622 = C0461zs.m11622(c0273jo);
        return strM11622 != null ? abc.m1925(C0460zg.m11407(abe.m2346(C0460zg.m11407(new StringBuilder(), strM2414), '?'), strM11622)) : strM2414;
    }

    public static boolean m6163(Object obj, Object obj2) {
        if (C0459zf.m11062() >= 0) {
            return m1075b((C0286ka) obj, (Proxy.Type) obj2);
        }
        return false;
    }

    public static int m6164() {
        if (abf.m2510() <= 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static boolean m6165(Object obj, Object obj2) {
        if (m6164() >= 0) {
            return m6163((C0286ka) obj, (Proxy.Type) obj2);
        }
        return false;
    }
}
