package com.google.android.material.card2;

import java.util.Iterator;
import java.util.Map;

public final class C0095cz<T> extends AbstractC0022ah<T> {

    private final Map<String, AbstractC0097da> f164cg;

    private final InterfaceC0065bw<T> f165ch;

    C0095cz(InterfaceC0065bw<T> interfaceC0065bw, Map<String, AbstractC0097da> map) {
        this.f165ch = interfaceC0065bw;
        this.f164cg = map;
    }

    public static boolean m3422(Object obj, Object obj2) {
        if (C0445ya.m8222() >= 0) {
            return ((AbstractC0097da) obj).mo381h(obj2);
        }
        return false;
    }

    public static InterfaceC0065bw m3423(Object obj) {
        if (C0450yf.m9352() <= 0) {
            return ((C0095cz) obj).f165ch;
        }
        return null;
    }

    public static Object m3424(Object obj) {
        if (C0461zs.m11510() < 0) {
            return C0598.m11882(obj);
        }
        return null;
    }

    public static String m3425(Object obj) {
        if (C0453yj.m10013() > 0) {
            return ((AbstractC0097da) obj).f167cj;
        }
        return null;
    }

    public static void m3426(Object obj, Object obj2, Object obj3) {
        if (C0453yj.m10013() > 0) {
            ((AbstractC0097da) obj).mo380a((C0155fe) obj2, obj3);
        }
    }

    public static void m3427(Object obj, Object obj2, Object obj3) {
        if (C0446yb.m8415() <= 0) {
            ((AbstractC0097da) obj).mo379a((C0152fb) obj2, obj3);
        }
    }

    public static boolean m3428(Object obj) {
        if (C0449ye.m9220() < 0) {
            return ((AbstractC0097da) obj).f166ci;
        }
        return false;
    }

    public static Map m3429(Object obj) {
        if (C0446yb.m8415() <= 0) {
            return ((C0095cz) obj).f164cg;
        }
        return null;
    }

    public static Map m3430(Object obj) {
        if (C0459zf.m11053() > 0) {
            return m3429((C0095cz) obj);
        }
        return null;
    }

    public static String m3431(Object obj) {
        if (C0458ze.m10926() < 0) {
            return m3425((AbstractC0097da) obj);
        }
        return null;
    }

    public static boolean m3432(Object obj) {
        if (abd.m2021() > 0) {
            return m3428((AbstractC0097da) obj);
        }
        return false;
    }

    public static boolean m3433(Object obj, Object obj2) {
        if (C0453yj.m9945() <= 0) {
            return m3422((AbstractC0097da) obj, obj2);
        }
        return false;
    }

    public static void m3434(Object obj, Object obj2, Object obj3) {
        if (C0448yd.m9015() < 0) {
            m3427((AbstractC0097da) obj, (C0152fb) obj2, obj3);
        }
    }

    public static void m3435(Object obj, Object obj2, Object obj3) {
        if (C0448yd.m9074() < 0) {
            m3426((AbstractC0097da) obj, (C0155fe) obj2, obj3);
        }
    }

    public static InterfaceC0065bw m3436(Object obj) {
        if (C0448yd.m9074() <= 0) {
            return m3423((C0095cz) obj);
        }
        return null;
    }

    @Override
    public void mo225a(C0155fe c0155fe, T t) {
        if (t == null) {
            C0457zc.m10630(c0155fe);
            return;
        }
        C0447yc.m8775(c0155fe);
        try {
            Iterator itM4289 = gggy.m4289(C0457zc.m10625(C0460zg.m11239(this)));
            while (C0455za.m10104(itM4289)) {
                AbstractC0097da abstractC0097da = (AbstractC0097da) m3424(itM4289);
                if (C0453yj.m9964(abstractC0097da, t)) {
                    C0453yj.m9830(c0155fe, abd.m1989(abstractC0097da));
                    C0452yh.m9732(abstractC0097da, c0155fe, t);
                }
            }
            C0458ze.m10945(c0155fe);
        } catch (IllegalAccessException e) {
            throw new AssertionError(e);
        }
    }

    @Override
    public T mo227b(C0152fb c0152fb) {
        if (abe.m2401(c0152fb) == C0452yh.m9757()) {
            C0459zf.m11132(c0152fb);
            return null;
        }
        T t = (T) abf.m2542(C0458ze.m10956(this));
        try {
            C0456zb.m10454(c0152fb);
            while (C0455za.m10208(c0152fb)) {
                AbstractC0097da abstractC0097da = (AbstractC0097da) adds.m2889(C0460zg.m11239(this), gggy.m4313(c0152fb));
                if (abstractC0097da == null || !abc.m1755(abstractC0097da)) {
                    abc.m1951(c0152fb);
                } else {
                    gggy.m4463(abstractC0097da, c0152fb, t);
                }
            }
            C0459zf.m11135(c0152fb);
            return t;
        } catch (IllegalAccessException e) {
            throw new AssertionError(e);
        } catch (IllegalStateException e2) {
            throw new C0018ad(e2);
        }
    }
}
