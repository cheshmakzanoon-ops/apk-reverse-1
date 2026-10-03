package com.google.android.material.card2;

import javax.annotation.Nullable;

public final class C0256iy {

    @Nullable
    String[] f669la;

    boolean f670lb;

    boolean f671lc;

    @Nullable
    String[] f672ld;

    public C0256iy(C0255ix c0255ix) {
        this.f671lc = C0457zc.m10750(c0255ix);
        this.f669la = C0459zf.m10994(c0255ix);
        this.f672ld = C0450yf.m9511(c0255ix);
        this.f670lb = abc.m1912(c0255ix);
    }

    C0256iy(boolean z) {
        this.f671lc = z;
    }

    public static boolean m5041(Object obj) {
        if (C0447yc.m8635() > 0) {
            return ((C0255ix) obj).f667lc;
        }
        return false;
    }

    public static String[] m5042(Object obj) {
        if (C0446yb.m8415() <= 0) {
            return ((C0255ix) obj).f665la;
        }
        return null;
    }

    public static Object m5043(Object obj) {
        if (C0459zf.m11062() > 0) {
            return ((String[]) obj).clone();
        }
        return null;
    }

    public static String[] m5044(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return ((C0255ix) obj).f668ld;
        }
        return null;
    }

    public static int m5045() {
        if (C0447yc.m8635() > 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static String m5046(Object obj) {
        if (C0452yh.m9798() > 0) {
            return ((C0250is) obj).f651kM;
        }
        return null;
    }

    public static boolean m5047(Object obj) {
        if (C0452yh.m9798() >= 0) {
            return ((C0256iy) obj).f671lc;
        }
        return false;
    }

    public static String m5048(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return ((EnumC0295kj) obj).f883nR;
        }
        return null;
    }

    public static boolean m5049(Object obj) {
        if (C0456zb.m10326() < 0) {
            return ((C0255ix) obj).f666lb;
        }
        return false;
    }

    public static String[] m5050(Object obj) {
        if (m5045() > 0) {
            return m5042((C0255ix) obj);
        }
        return null;
    }

    public static boolean m5051(Object obj) {
        if (C0453yj.m9945() < 0) {
            return m5041((C0255ix) obj);
        }
        return false;
    }

    public static Object m5052(Object obj) {
        if (C0448yd.m9074() < 0) {
            return m5043((String[]) obj);
        }
        return null;
    }

    public static boolean m5053(Object obj) {
        if (C0445ya.m8330() > 0) {
            return m5049((C0255ix) obj);
        }
        return false;
    }

    public static String[] m5054(Object obj) {
        if (C0453yj.m9945() <= 0) {
            return m5044((C0255ix) obj);
        }
        return null;
    }

    public static String m5055(Object obj) {
        if (abd.m2166() <= 0) {
            return m5046((C0250is) obj);
        }
        return null;
    }

    public static String m5056(Object obj) {
        if (C0453yj.m9966() >= 0) {
            return m5048((EnumC0295kj) obj);
        }
        return null;
    }

    public static boolean m5057(Object obj) {
        if (m5045() > 0) {
            return m5047((C0256iy) obj);
        }
        return false;
    }

    public C0256iy m659a(C0250is... c0250isArr) {
        if (!C0456zb.m10351(this)) {
            throw new IllegalStateException(abc.m1785());
        }
        String[] strArr = new String[c0250isArr.length];
        for (int i = 0; i < c0250isArr.length; i++) {
            strArr[i] = C0447yc.m8696(c0250isArr[i]);
        }
        return abd.m2079(this, strArr);
    }

    public C0256iy m660a(EnumC0295kj... enumC0295kjArr) {
        if (!C0456zb.m10351(this)) {
            throw new IllegalStateException(abf.m2622());
        }
        String[] strArr = new String[enumC0295kjArr.length];
        for (int i = 0; i < enumC0295kjArr.length; i++) {
            strArr[i] = C0460zg.m11334(enumC0295kjArr[i]);
        }
        return abf.m2474(this, strArr);
    }

    public C0256iy m661b(String... strArr) {
        if (!C0456zb.m10351(this)) {
            throw new IllegalStateException(abc.m1785());
        }
        if (strArr.length == 0) {
            throw new IllegalArgumentException(C0446yb.m8603());
        }
        this.f669la = (String[]) C0457zc.m10617(strArr);
        return this;
    }

    public C0256iy m662c(String... strArr) {
        if (!C0456zb.m10351(this)) {
            throw new IllegalStateException(abf.m2622());
        }
        if (strArr.length == 0) {
            throw new IllegalArgumentException(C0456zb.m10474());
        }
        this.f672ld = (String[]) C0457zc.m10617(strArr);
        return this;
    }

    public C0255ix m663ca() {
        return new C0255ix(this);
    }

    public C0256iy m664j(boolean z) {
        if (!C0456zb.m10351(this)) {
            throw new IllegalStateException(C0457zc.m10634());
        }
        this.f670lb = z;
        return this;
    }
}
