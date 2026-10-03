package com.google.android.material.card2;

import javax.annotation.Nullable;

final class C0289kd extends AbstractC0288kc {

    final int f842np;

    final byte[] f843nq;

    final C0278jt f844nr;

    final int f845ns;

    C0289kd(C0278jt c0278jt, int i, byte[] bArr, int i2) {
        this.f844nr = c0278jt;
        this.f842np = i;
        this.f843nq = bArr;
        this.f845ns = i2;
    }

    public static int m5628(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return m5636(obj);
        }
        return 0;
    }

    public static C0278jt m5629(Object obj) {
        if (abd.m2162() >= 0) {
            return m5638(obj);
        }
        return null;
    }

    public static C0278jt m5630(Object obj) {
        if (C0450yf.m9352() <= 0) {
            return ((C0289kd) obj).f844nr;
        }
        return null;
    }

    public static int m5631(Object obj) {
        if (C0453yj.m10013() > 0) {
            return ((C0289kd) obj).f845ns;
        }
        return 0;
    }

    public static byte[] m5632(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return ((C0289kd) obj).f843nq;
        }
        return null;
    }

    public static int m5633(Object obj) {
        if (abd.m2162() > 0) {
            return m5639(obj);
        }
        return 0;
    }

    public static int m5634(Object obj) {
        if (C0447yc.m8635() > 0) {
            return ((C0289kd) obj).f842np;
        }
        return 0;
    }

    public static byte[] m5635(Object obj) {
        if (C0460zg.m11287() > 0) {
            return m5637(obj);
        }
        return null;
    }

    public static int m5636(Object obj) {
        if (C0448yd.m9074() < 0) {
            return m5631((C0289kd) obj);
        }
        return 0;
    }

    public static byte[] m5637(Object obj) {
        if (C0453yj.m9996() < 0) {
            return m5632((C0289kd) obj);
        }
        return null;
    }

    public static C0278jt m5638(Object obj) {
        if (abf.m2500() > 0) {
            return m5630((C0289kd) obj);
        }
        return null;
    }

    public static int m5639(Object obj) {
        if (C0447yc.m8786() >= 0) {
            return m5634((C0289kd) obj);
        }
        return 0;
    }

    @Override
    public void mo709a(InterfaceC0410op interfaceC0410op) {
        abe.m2310(interfaceC0410op, m5635(this), m5628(this), m5633(this));
    }

    @Override
    public long mo710cf() {
        return m5633(this);
    }

    @Override
    @Nullable
    public C0278jt mo711cg() {
        return m5629(this);
    }
}
