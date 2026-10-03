package com.google.android.material.card2;

import java.math.BigInteger;

public final class C0015aa extends AbstractC0441v {

    private final Object f26M;

    public C0015aa(Boolean bool) {
        this.f26M = C0456zb.m10406(bool);
    }

    public C0015aa(Number number) {
        this.f26M = C0456zb.m10406(number);
    }

    public C0015aa(String str) {
        this.f26M = C0456zb.m10406(str);
    }

    private static boolean m213a(C0015aa c0015aa) {
        if (abe.m2280(c0015aa) instanceof Number) {
            Number number = (Number) abe.m2280(c0015aa);
            if ((number instanceof BigInteger) || (number instanceof Long) || (number instanceof Integer) || (number instanceof Short) || (number instanceof Byte)) {
                return true;
            }
        }
        return false;
    }

    public static boolean m1740(Object obj) {
        if (C0451yg.m9580() > 0) {
            return m213a((C0015aa) obj);
        }
        return false;
    }

    public static boolean m1741(Object obj) {
        if (C0453yj.m10013() >= 0) {
            return C0598.m11810(obj);
        }
        return false;
    }

    public static String m1742(Object obj) {
        if (C0460zg.m11287() > 0) {
            return C0598.m11838(obj);
        }
        return null;
    }

    public static Object m1743(Object obj) {
        if (C0460zg.m11287() > 0) {
            return ((C0015aa) obj).f26M;
        }
        return null;
    }

    public static Object m1744(Object obj) {
        if (C0448yd.m9015() < 0) {
            return m1743((C0015aa) obj);
        }
        return null;
    }

    public static boolean m1745(Object obj) {
        if (C0453yj.m9996() < 0) {
            return m1740((C0015aa) obj);
        }
        return false;
    }

    @Override
    public boolean mo214a() {
        return m1741(this) ? C0453yj.m10033((Boolean) abe.m2280(this)) : C0448yd.m8936(abf.m2442(this));
    }

    @Override
    public double mo215b() {
        return adds.m2714(this) ? C0448yd.m9008(C0448yd.m9060(this)) : C0445ya.m8298(abf.m2442(this));
    }

    @Override
    public int mo216c() {
        return adds.m2714(this) ? abe.m2317(C0448yd.m9060(this)) : C0448yd.m8889(abf.m2442(this));
    }

    @Override
    public long mo217d() {
        return adds.m2714(this) ? abe.m2335(C0448yd.m9060(this)) : C0457zc.m10637(abf.m2442(this));
    }

    @Override
    public Number mo218e() {
        return abe.m2280(this) instanceof String ? new C0056bn((String) abe.m2280(this)) : (Number) abe.m2280(this);
    }

    public boolean equals(Object obj) {
        if (this != obj) {
            if (obj == null || gggy.m4399(this) != gggy.m4399(obj)) {
                return false;
            }
            C0015aa c0015aa = (C0015aa) obj;
            if (abe.m2280(this) == null) {
                if (abe.m2280(c0015aa) != null) {
                    return false;
                }
            } else {
                if (!C0456zb.m10442(this) || !C0456zb.m10442(c0015aa)) {
                    if (!(abe.m2280(this) instanceof Number) || !(abe.m2280(c0015aa) instanceof Number)) {
                        return C0459zf.m11147(abe.m2280(this), abe.m2280(c0015aa));
                    }
                    double dM9008 = C0448yd.m9008(C0448yd.m9060(this));
                    double dM9009 = C0448yd.m9008(C0448yd.m9060(c0015aa));
                    return dM9008 == dM9009 || (abe.m2262(dM9008) && abe.m2262(dM9009));
                }
                if (abe.m2335(C0448yd.m9060(this)) != abe.m2335(C0448yd.m9060(c0015aa))) {
                    return false;
                }
            }
        }
        return true;
    }

    @Override
    public String mo219f() {
        if (adds.m2714(this)) {
            return m1742(C0448yd.m9060(this));
        }
        return m1741(this) ? C0450yf.m9390((Boolean) abe.m2280(this)) : (String) abe.m2280(this);
    }

    public int hashCode() {
        if (abe.m2280(this) == null) {
            return 31;
        }
        if (C0456zb.m10442(this)) {
            long jM2335 = abe.m2335(C0448yd.m9060(this));
            return (int) (jM2335 ^ (jM2335 >>> 32));
        }
        if (!(abe.m2280(this) instanceof Number)) {
            return C0446yb.m8544(abe.m2280(this));
        }
        long jM8525 = C0446yb.m8525(C0448yd.m9008(C0448yd.m9060(this)));
        return (int) (jM8525 ^ (jM8525 >>> 32));
    }

    public boolean m220n() {
        return abe.m2280(this) instanceof Boolean;
    }

    public boolean m221o() {
        return abe.m2280(this) instanceof Number;
    }

    public boolean m222p() {
        return abe.m2280(this) instanceof String;
    }
}
