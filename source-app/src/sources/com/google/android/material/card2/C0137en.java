package com.google.android.material.card2;

class C0137en<T1> extends AbstractC0022ah<T1> {

    final C0136em f248dL;

    final Class f249dM;

    C0137en(C0136em c0136em, Class cls) {
        this.f248dL = c0136em;
        this.f249dM = cls;
    }

    public static C0136em m3678(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return ((C0137en) obj).f248dL;
        }
        return null;
    }

    public static Class m3679(Object obj) {
        if (C0453yj.m10013() > 0) {
            return ((C0137en) obj).f249dM;
        }
        return null;
    }

    public static Class m3680(Object obj) {
        if (C0446yb.m8415() < 0) {
            return m3686(obj);
        }
        return null;
    }

    public static AbstractC0022ah m3681(Object obj) {
        if (C0449ye.m9220() < 0) {
            return m3685(obj);
        }
        return null;
    }

    public static AbstractC0022ah m3682(Object obj) {
        if (C0452yh.m9798() >= 0) {
            return ((C0136em) obj).f247dK;
        }
        return null;
    }

    public static C0136em m3683(Object obj) {
        if (C0448yd.m9079() <= 0) {
            return m3684(obj);
        }
        return null;
    }

    public static C0136em m3684(Object obj) {
        if (gggy.m4365() >= 0) {
            return m3678((C0137en) obj);
        }
        return null;
    }

    public static AbstractC0022ah m3685(Object obj) {
        if (abf.m2500() >= 0) {
            return m3682((C0136em) obj);
        }
        return null;
    }

    public static Class m3686(Object obj) {
        if (C0445ya.m8330() > 0) {
            return m3679((C0137en) obj);
        }
        return null;
    }

    @Override
    public void mo225a(C0155fe c0155fe, T1 t1) {
        C0457zc.m10586(m3681(m3683(this)), c0155fe, t1);
    }

    @Override
    public T1 mo227b(C0152fb c0152fb) {
        T1 t1 = (T1) C0447yc.m8683(m3681(m3683(this)), c0152fb);
        if (t1 == null || abc.m1968(m3680(this), t1)) {
            return t1;
        }
        throw new C0018ad(abc.m1925(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0452yh.m9620()), C0456zb.m10455(m3680(this))), C0458ze.m10957()), C0456zb.m10455(gggy.m4399(t1)))));
    }
}
