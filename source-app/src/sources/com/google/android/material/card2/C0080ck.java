package com.google.android.material.card2;

import java.lang.reflect.Type;
import java.util.Collection;
import java.util.Iterator;

final class C0080ck<E> extends AbstractC0022ah<Collection<E>> {

    private final InterfaceC0065bw<? extends Collection<E>> f127bv;

    private final AbstractC0022ah<E> f128bw;

    public C0080ck(C0285k c0285k, Type type, AbstractC0022ah<E> abstractC0022ah, InterfaceC0065bw<? extends Collection<E>> interfaceC0065bw) {
        this.f128bw = new C0105di(c0285k, abstractC0022ah, type);
        this.f127bv = interfaceC0065bw;
    }

    public static AbstractC0022ah m3261(Object obj) {
        if (C0453yj.m10013() > 0) {
            return m3273(obj);
        }
        return null;
    }

    public static void m3262(Object obj, Object obj2, Object obj3) {
        if (C0445ya.m8222() > 0) {
            m3271(obj, obj2, obj3);
        }
    }

    public static InterfaceC0065bw m3263(Object obj) {
        if (C0445ya.m8222() > 0) {
            return m3274(obj);
        }
        return null;
    }

    public static AbstractC0022ah m3264(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return ((C0080ck) obj).f128bw;
        }
        return null;
    }

    public static Collection m3265(Object obj, Object obj2) {
        if (C0451yg.m9580() > 0) {
            return m3272(obj, obj2);
        }
        return null;
    }

    public static Collection m3266(Object obj, Object obj2) {
        if (C0460zg.m11287() > 0) {
            return ((C0080ck) obj).m332i((C0152fb) obj2);
        }
        return null;
    }

    public static void m3267(Object obj) {
        if (abe.m2308() <= 0) {
            C0598.m11835(obj);
        }
    }

    public static InterfaceC0065bw m3268(Object obj) {
        if (abc.m1845() < 0) {
            return ((C0080ck) obj).f127bv;
        }
        return null;
    }

    public static Object m3269(Object obj) {
        if (C0461zs.m11510() < 0) {
            return C0598.m11882(obj);
        }
        return null;
    }

    public static void m3270(Object obj, Object obj2, Object obj3) {
        if (C0447yc.m8635() >= 0) {
            ((C0080ck) obj).m331a((C0155fe) obj2, (Collection) obj3);
        }
    }

    public static void m3271(Object obj, Object obj2, Object obj3) {
        if (C0457zc.m10718() <= 0) {
            m3270((C0080ck) obj, (C0155fe) obj2, (Collection) obj3);
        }
    }

    public static Collection m3272(Object obj, Object obj2) {
        if (C0458ze.m10926() <= 0) {
            return m3266((C0080ck) obj, (C0152fb) obj2);
        }
        return null;
    }

    public static AbstractC0022ah m3273(Object obj) {
        if (C0453yj.m9996() <= 0) {
            return m3264((C0080ck) obj);
        }
        return null;
    }

    public static InterfaceC0065bw m3274(Object obj) {
        if (C0458ze.m10926() <= 0) {
            return m3268((C0080ck) obj);
        }
        return null;
    }

    @Override
    public void mo225a(C0155fe c0155fe, Object obj) {
        m3262(this, c0155fe, (Collection) obj);
    }

    public void m331a(C0155fe c0155fe, Collection<E> collection) {
        if (collection == null) {
            C0457zc.m10630(c0155fe);
            return;
        }
        abf.m2469(c0155fe);
        Iterator itM4289 = gggy.m4289(collection);
        while (C0455za.m10104(itM4289)) {
            C0457zc.m10586(m3261(this), c0155fe, m3269(itM4289));
        }
        C0450yf.m9574(c0155fe);
    }

    @Override
    public Object mo227b(C0152fb c0152fb) {
        return m3265(this, c0152fb);
    }

    public Collection<E> m332i(C0152fb c0152fb) {
        if (abe.m2401(c0152fb) == C0452yh.m9757()) {
            C0459zf.m11132(c0152fb);
            return null;
        }
        Collection<E> collection = (Collection) abf.m2542(m3263(this));
        C0461zs.m11627(c0152fb);
        while (C0455za.m10208(c0152fb)) {
            C0459zf.m11126(collection, C0447yc.m8683(m3261(this), c0152fb));
        }
        m3267(c0152fb);
        return collection;
    }
}
