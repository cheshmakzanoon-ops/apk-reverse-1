package com.google.android.material.card2;

public final class C0054bl {

    private static final int f80aJ = C0445ya.m8256();

    private static int m295B() {
        return gggy.m4450(C0449ye.m9228(C0449ye.m9208()));
    }

    public static int m296C() {
        return C0453yj.m9877();
    }

    public static boolean m297D() {
        return C0453yj.m9877() >= 9;
    }

    private static int m298b(String str) {
        try {
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < gggy.m4397(str); i++) {
                char cM8419 = C0446yb.m8419(str, i);
                if (!C0448yd.m9018(cM8419)) {
                    break;
                }
                abe.m2346(sb, cM8419);
            }
            return C0448yd.m8889(abc.m1925(sb));
        } catch (NumberFormatException e) {
            return -1;
        }
    }

    static int m299c(String str) {
        int iM11374 = C0460zg.m11374(str);
        if (iM11374 == -1) {
            iM11374 = C0456zb.m10292(str);
        }
        if (iM11374 == -1) {
            return 6;
        }
        return iM11374;
    }

    private static int m300d(String str) {
        try {
            String[] strArrM10771 = C0458ze.m10771(str, C0456zb.m10482());
            int iM8889 = C0448yd.m8889(strArrM10771[0]);
            return (iM8889 != 1 || strArrM10771.length <= 1) ? iM8889 : C0448yd.m8889(strArrM10771[1]);
        } catch (NumberFormatException e) {
            return -1;
        }
    }

    public static int m3050(Object obj) {
        if (C0448yd.m9079() < 0) {
            return m298b((String) obj);
        }
        return 0;
    }

    public static int m3051() {
        if (abe.m2308() < 0) {
            return f80aJ;
        }
        return 0;
    }

    public static int m3052() {
        if (abe.m2308() < 0) {
            return m295B();
        }
        return 0;
    }

    public static int m3053(Object obj) {
        if (abd.m2162() >= 0) {
            return m300d((String) obj);
        }
        return 0;
    }

    public static int m3054(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return m299c((String) obj);
        }
        return 0;
    }

    public static int m3055() {
        if (C0448yd.m9079() <= 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static int m3056() {
        if (abe.m2321() < 0) {
            return m3051();
        }
        return 0;
    }

    public static int m3057(Object obj) {
        if (C0453yj.m10032() > 0) {
            return m3054((String) obj);
        }
        return 0;
    }

    public static int m3058() {
        if (C0453yj.m9945() <= 0) {
            return m3052();
        }
        return 0;
    }

    public static int m3059(Object obj) {
        if (m3055() >= 0) {
            return m3053((String) obj);
        }
        return 0;
    }

    public static int m3060(Object obj) {
        if (abd.m2021() > 0) {
            return m3050((String) obj);
        }
        return 0;
    }
}
