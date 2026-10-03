package com.google.android.material.card2;

public final class C0102df<T> extends AbstractC0022ah<T> {

    private AbstractC0022ah<T> f173I;

    private final C0104dh f174cp = new C0104dh(this, null);

    private final InterfaceC0440u<T> f175cq;

    final C0285k f176cr;

    private final InterfaceC0017ac<T> f177cs;

    private final InterfaceC0024aj f178ct;

    private final C0151fa<T> f179cu;

    public C0102df(InterfaceC0017ac<T> interfaceC0017ac, InterfaceC0440u<T> interfaceC0440u, C0285k c0285k, C0151fa<T> c0151fa, InterfaceC0024aj interfaceC0024aj) {
        this.f177cs = interfaceC0017ac;
        this.f175cq = interfaceC0440u;
        this.f176cr = c0285k;
        this.f179cu = c0151fa;
        this.f178ct = interfaceC0024aj;
    }

    private AbstractC0022ah<T> m385A() {
        AbstractC0022ah<T> abstractC0022ahM10125 = C0455za.m10125(this);
        if (abstractC0022ahM10125 != null) {
            return abstractC0022ahM10125;
        }
        AbstractC0022ah<T> abstractC0022ahM8243 = C0445ya.m8243(C0453yj.m9874(this), abc.m1950(this), abd.m2024(this));
        this.f173I = abstractC0022ahM8243;
        return abstractC0022ahM8243;
    }

    public static InterfaceC0017ac m3441(Object obj) {
        if (C0448yd.m9079() < 0) {
            return ((C0102df) obj).f177cs;
        }
        return null;
    }

    public static InterfaceC0440u m3442(Object obj) {
        if (abc.m1845() < 0) {
            return ((C0102df) obj).f175cq;
        }
        return null;
    }

    public static C0285k m3443(Object obj) {
        if (C0459zf.m11062() > 0) {
            return ((C0102df) obj).f176cr;
        }
        return null;
    }

    public static AbstractC0022ah m3444(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return ((C0102df) obj).m385A();
        }
        return null;
    }

    public static C0104dh m3445(Object obj) {
        if (abf.m2510() < 0) {
            return ((C0102df) obj).f174cp;
        }
        return null;
    }

    public static InterfaceC0024aj m3446(Object obj) {
        if (C0457zc.m10735() <= 0) {
            return ((C0102df) obj).f178ct;
        }
        return null;
    }

    public static AbstractC0022ah m3447(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return ((C0102df) obj).f173I;
        }
        return null;
    }

    public static C0151fa m3448(Object obj) {
        if (C0453yj.m10013() >= 0) {
            return ((C0102df) obj).f179cu;
        }
        return null;
    }

    public static C0104dh m3449(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return m3457(obj);
        }
        return null;
    }

    public static InterfaceC0024aj m3450(Object obj) {
        if (C0456zb.m10484() < 0) {
            return m3446((C0102df) obj);
        }
        return null;
    }

    public static InterfaceC0017ac m3451(Object obj) {
        if (C0453yj.m9945() < 0) {
            return m3441((C0102df) obj);
        }
        return null;
    }

    public static AbstractC0022ah m3452(Object obj) {
        if (C0460zg.m11293() > 0) {
            return m3447((C0102df) obj);
        }
        return null;
    }

    public static InterfaceC0440u m3453(Object obj) {
        if (C0459zf.m11053() >= 0) {
            return m3442((C0102df) obj);
        }
        return null;
    }

    public static AbstractC0022ah m3454(Object obj) {
        if (C0459zf.m11053() >= 0) {
            return m3444((C0102df) obj);
        }
        return null;
    }

    public static C0285k m3455(Object obj) {
        if (C0457zc.m10555() >= 0) {
            return m3443((C0102df) obj);
        }
        return null;
    }

    public static C0151fa m3456(Object obj) {
        if (C0453yj.m9945() <= 0) {
            return m3448((C0102df) obj);
        }
        return null;
    }

    public static C0104dh m3457(Object obj) {
        if (C0447yc.m8786() >= 0) {
            return m3445((C0102df) obj);
        }
        return null;
    }

    @Override
    public void mo225a(C0155fe c0155fe, T t) {
        if (C0455za.m10228(this) == null) {
            C0457zc.m10586(C0460zg.m11219(this), c0155fe, t);
        } else if (t == null) {
            C0457zc.m10630(c0155fe);
        } else {
            adds.m2870(C0452yh.m9602(C0455za.m10228(this), t, C0456zb.m10432(abd.m2024(this)), m3449(this)), c0155fe);
        }
    }

    @Override
    public T mo227b(C0152fb c0152fb) {
        if (C0456zb.m10486(this) == null) {
            return (T) C0447yc.m8683(C0460zg.m11219(this), c0152fb);
        }
        AbstractC0441v abstractC0441vM11329 = C0460zg.m11329(c0152fb);
        if (abd.m1998(abstractC0441vM11329)) {
            return null;
        }
        return (T) abe.m2406(C0456zb.m10486(this), abstractC0441vM11329, C0456zb.m10432(abd.m2024(this)), m3449(this));
    }
}
