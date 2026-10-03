package com.google.android.material.card2;

import android.content.Context;
import android.graphics.Bitmap;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;

final class C0175fy extends AbstractC0179gb {

    static final boolean f348fx;

    final String f349fA;

    final int f350fB;

    final int f351fC;

    final String f352fy;

    final Context f353fz;

    static {
        f348fx = !C0460zg.m11342(C0174fx.class);
    }

    C0175fy(String str, Context context, String str2, int i, int i2) {
        super(null);
        this.f352fy = str;
        this.f353fz = context;
        this.f349fA = str2;
        this.f350fB = i;
        this.f351fC = i2;
    }

    public static String m4134(Object obj) {
        if (C0446yb.m8415() < 0) {
            return m4149(obj);
        }
        return null;
    }

    public static String m4135(Object obj) {
        if (C0459zf.m11062() >= 0) {
            return ((C0175fy) obj).f349fA;
        }
        return null;
    }

    public static Context m4136(Object obj) {
        if (C0461zs.m11510() < 0) {
            return m4151(obj);
        }
        return null;
    }

    public static Context m4137(Object obj) {
        if (abd.m2162() > 0) {
            return ((C0175fy) obj).f353fz;
        }
        return null;
    }

    public static String m4138(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return ((C0175fy) obj).f352fy;
        }
        return null;
    }

    public static boolean m4139() {
        if (adds.m2755() >= 0) {
            return f348fx;
        }
        return false;
    }

    public static int m4140(Object obj) {
        if (C0451yg.m9580() > 0) {
            return m4153(obj);
        }
        return 0;
    }

    public static Bitmap m4141(Object obj, Object obj2, Object obj3, int i, int i2) {
        if (C0445ya.m8222() > 0) {
            return abf.m2519((Context) obj, (String) obj2, (String) obj3, i, i2);
        }
        return null;
    }

    public static int m4142(Object obj) {
        if (C0459zf.m11062() >= 0) {
            return m4150(obj);
        }
        return 0;
    }

    public static int m4143(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return ((C0175fy) obj).f351fC;
        }
        return 0;
    }

    public static String m4144(Object obj) {
        if (C0461zs.m11510() < 0) {
            return m4154(obj);
        }
        return null;
    }

    public static boolean m4145() {
        if (C0450yf.m9352() <= 0) {
            return m4148();
        }
        return false;
    }

    public static int m4146(Object obj) {
        if (C0451yg.m9580() > 0) {
            return ((C0175fy) obj).f350fB;
        }
        return 0;
    }

    public static Bitmap m4147(Object obj, Object obj2, Object obj3, int i, int i2) {
        if (C0459zf.m11062() > 0) {
            return m4152(obj, obj2, obj3, i, i2);
        }
        return null;
    }

    public static boolean m4148() {
        if (C0448yd.m9015() < 0) {
            return m4139();
        }
        return false;
    }

    public static String m4149(Object obj) {
        if (C0456zb.m10484() <= 0) {
            return m4138((C0175fy) obj);
        }
        return null;
    }

    public static int m4150(Object obj) {
        if (abf.m2500() > 0) {
            return m4146((C0175fy) obj);
        }
        return 0;
    }

    public static Context m4151(Object obj) {
        if (C0447yc.m8786() >= 0) {
            return m4137((C0175fy) obj);
        }
        return null;
    }

    public static Bitmap m4152(Object obj, Object obj2, Object obj3, int i, int i2) {
        if (abd.m2021() > 0) {
            return m4141((Context) obj, (String) obj2, (String) obj3, i, i2);
        }
        return null;
    }

    public static int m4153(Object obj) {
        if (C0453yj.m10032() > 0) {
            return m4143((C0175fy) obj);
        }
        return 0;
    }

    public static String m4154(Object obj) {
        if (abf.m2500() >= 0) {
            return m4135((C0175fy) obj);
        }
        return null;
    }

    @Override
    public void mo496a(InterfaceC0171fu interfaceC0171fu, InputStream inputStream, String str) {
        String str2 = str;
        try {
            try {
                if (!m4145() && inputStream != null && str2 != null) {
                    throw new AssertionError();
                }
                if (inputStream == null && str2 == null) {
                    if (interfaceC0171fu == null || abe.m2353(interfaceC0171fu)) {
                        return;
                    }
                    C0448yd.m8996(new File(m4134(this)));
                    return;
                }
                String strM4134 = m4134(this);
                if (inputStream != null) {
                    BufferedInputStream bufferedInputStream = new BufferedInputStream(inputStream, 8192);
                    BufferedOutputStream bufferedOutputStream = new BufferedOutputStream(new FileOutputStream(m4134(this)), 8192);
                    abc.m1769(bufferedInputStream, bufferedOutputStream);
                    abe.m2359(bufferedOutputStream);
                    str2 = strM4134;
                }
                this.f364fN = m4147(m4136(this), m4144(this), str2, m4142(this), m4140(this));
                if (interfaceC0171fu == null || abe.m2353(interfaceC0171fu)) {
                    return;
                }
                C0448yd.m8996(new File(m4134(this)));
            } catch (Exception e) {
                C0448yd.m8996(new File(m4134(this)));
                if (interfaceC0171fu == null || abe.m2353(interfaceC0171fu)) {
                    return;
                }
                C0448yd.m8996(new File(m4134(this)));
            }
        } catch (Throwable th) {
            if (interfaceC0171fu != null && !abe.m2353(interfaceC0171fu)) {
                C0448yd.m8996(new File(m4134(this)));
            }
            throw th;
        }
    }
}
