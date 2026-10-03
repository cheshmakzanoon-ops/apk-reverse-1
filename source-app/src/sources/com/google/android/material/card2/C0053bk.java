package com.google.android.material.card2;

class C0053bk<T> extends AbstractC0022ah<T> {

    private AbstractC0022ah<T> f74I;

    final C0052bj f75aE;

    final C0285k f76aF;

    final boolean f77aG;

    final boolean f78aH;

    final C0151fa f79aI;

    C0053bk(C0052bj c0052bj, boolean z, boolean z2, C0285k c0285k, C0151fa c0151fa) {
        this.f75aE = c0052bj;
        this.f77aG = z;
        this.f78aH = z2;
        this.f76aF = c0285k;
        this.f79aI = c0151fa;
    }

    private AbstractC0022ah<T> m294A() {
        AbstractC0022ah<T> abstractC0022ahM3029 = m3029(this);
        if (abstractC0022ahM3029 != null) {
            return abstractC0022ahM3029;
        }
        AbstractC0022ah<T> abstractC0022ahM8243 = C0445ya.m8243(m3038(this), m3040(this), m3030(this));
        this.f74I = abstractC0022ahM8243;
        return abstractC0022ahM8243;
    }

    public static AbstractC0022ah m3029(Object obj) {
        if (abd.m2162() > 0) {
            return m3047(obj);
        }
        return null;
    }

    public static C0151fa m3030(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return m3045(obj);
        }
        return null;
    }

    public static boolean m3031(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return m3044(obj);
        }
        return false;
    }

    public static C0052bj m3032(Object obj) {
        if (C0450yf.m9352() < 0) {
            return ((C0053bk) obj).f75aE;
        }
        return null;
    }

    public static boolean m3033(Object obj) {
        if (C0450yf.m9352() < 0) {
            return ((C0053bk) obj).f78aH;
        }
        return false;
    }

    public static C0151fa m3034(Object obj) {
        if (C0452yh.m9798() > 0) {
            return ((C0053bk) obj).f79aI;
        }
        return null;
    }

    public static C0285k m3035(Object obj) {
        if (C0446yb.m8415() < 0) {
            return ((C0053bk) obj).f76aF;
        }
        return null;
    }

    public static boolean m3036(Object obj) {
        if (C0460zg.m11287() > 0) {
            return m3048(obj);
        }
        return false;
    }

    public static AbstractC0022ah m3037(Object obj) {
        if (abe.m2308() <= 0) {
            return ((C0053bk) obj).m294A();
        }
        return null;
    }

    public static C0285k m3038(Object obj) {
        if (abd.m2162() >= 0) {
            return m3043(obj);
        }
        return null;
    }

    public static AbstractC0022ah m3039(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return m3049(obj);
        }
        return null;
    }

    public static C0052bj m3040(Object obj) {
        if (C0459zf.m11062() > 0) {
            return m3046(obj);
        }
        return null;
    }

    public static AbstractC0022ah m3041(Object obj) {
        if (C0457zc.m10735() <= 0) {
            return ((C0053bk) obj).f74I;
        }
        return null;
    }

    public static boolean m3042(Object obj) {
        if (abe.m2308() < 0) {
            return ((C0053bk) obj).f77aG;
        }
        return false;
    }

    public static C0285k m3043(Object obj) {
        if (C0456zb.m10484() <= 0) {
            return m3035((C0053bk) obj);
        }
        return null;
    }

    public static boolean m3044(Object obj) {
        if (abe.m2321() <= 0) {
            return m3033((C0053bk) obj);
        }
        return false;
    }

    public static C0151fa m3045(Object obj) {
        if (C0448yd.m9015() <= 0) {
            return m3034((C0053bk) obj);
        }
        return null;
    }

    public static C0052bj m3046(Object obj) {
        if (C0445ya.m8330() > 0) {
            return m3032((C0053bk) obj);
        }
        return null;
    }

    public static AbstractC0022ah m3047(Object obj) {
        if (C0453yj.m9996() <= 0) {
            return m3041((C0053bk) obj);
        }
        return null;
    }

    public static boolean m3048(Object obj) {
        if (C0453yj.m9996() <= 0) {
            return m3042((C0053bk) obj);
        }
        return false;
    }

    public static AbstractC0022ah m3049(Object obj) {
        if (C0458ze.m10926() <= 0) {
            return m3037((C0053bk) obj);
        }
        return null;
    }

    @Override
    public void mo225a(C0155fe c0155fe, T t) {
        if (m3031(this)) {
            C0457zc.m10630(c0155fe);
        } else {
            C0457zc.m10586(m3039(this), c0155fe, t);
        }
    }

    @Override
    public T mo227b(C0152fb c0152fb) {
        if (!m3036(this)) {
            return (T) C0447yc.m8683(m3039(this), c0152fb);
        }
        abc.m1951(c0152fb);
        return null;
    }
}
