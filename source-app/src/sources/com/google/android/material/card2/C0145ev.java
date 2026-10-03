package com.google.android.material.card2;

import java.lang.Enum;
import java.util.HashMap;
import java.util.Map;

final class C0145ev<T extends Enum<T>> extends AbstractC0022ah<T> {

    private final Map<String, T> f252dP = new HashMap();

    private final Map<T, String> f251dO = new HashMap();

    public C0145ev(Class<T> cls) {
        try {
            for (Enum r6 : (Enum[]) m3733(cls)) {
                String strM10743 = C0457zc.m10743(r6);
                InterfaceC0027am interfaceC0027am = (InterfaceC0027am) C0445ya.m8331(C0458ze.m10879(cls, strM10743), InterfaceC0027am.class);
                if (interfaceC0027am != null) {
                    strM10743 = C0449ye.m9134(interfaceC0027am);
                    String[] strArrM9680 = C0452yh.m9680(interfaceC0027am);
                    for (String str : strArrM9680) {
                        C0445ya.m8264(m3729(this), str, r6);
                    }
                }
                String str2 = strM10743;
                C0445ya.m8264(m3729(this), str2, r6);
                C0445ya.m8264(m3726(this), r6, str2);
            }
        } catch (NoSuchFieldException e) {
            throw new AssertionError(e);
        }
    }

    public static Map m3726(Object obj) {
        if (C0450yf.m9352() < 0) {
            return m3736(obj);
        }
        return null;
    }

    public static Enum m3727(Object obj, Object obj2) {
        if (C0449ye.m9220() <= 0) {
            return ((C0145ev) obj).m421I((C0152fb) obj2);
        }
        return null;
    }

    public static Map m3728(Object obj) {
        if (C0457zc.m10735() < 0) {
            return ((C0145ev) obj).f251dO;
        }
        return null;
    }

    public static Map m3729(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return m3737(obj);
        }
        return null;
    }

    public static void m3730(Object obj, Object obj2, Object obj3) {
        if (C0447yc.m8635() > 0) {
            ((C0145ev) obj).m422a((C0155fe) obj2, (Enum) obj3);
        }
    }

    public static Enum m3731(Object obj, Object obj2) {
        if (C0452yh.m9798() > 0) {
            return m3738(obj, obj2);
        }
        return null;
    }

    public static void m3732(Object obj, Object obj2, Object obj3) {
        if (C0458ze.m10932() >= 0) {
            m3735(obj, obj2, obj3);
        }
    }

    public static Object[] m3733(Object obj) {
        if (adds.m2755() >= 0) {
            return C0598.m11828(obj);
        }
        return null;
    }

    public static Map m3734(Object obj) {
        if (abe.m2308() <= 0) {
            return ((C0145ev) obj).f252dP;
        }
        return null;
    }

    public static void m3735(Object obj, Object obj2, Object obj3) {
        if (C0453yj.m10032() > 0) {
            m3730((C0145ev) obj, (C0155fe) obj2, (Enum) obj3);
        }
    }

    public static Map m3736(Object obj) {
        if (C0445ya.m8330() > 0) {
            return m3728((C0145ev) obj);
        }
        return null;
    }

    public static Map m3737(Object obj) {
        if (C0453yj.m9996() <= 0) {
            return m3734((C0145ev) obj);
        }
        return null;
    }

    public static Enum m3738(Object obj, Object obj2) {
        if (C0448yd.m9074() <= 0) {
            return m3727((C0145ev) obj, (C0152fb) obj2);
        }
        return null;
    }

    public T m421I(C0152fb c0152fb) {
        if (abe.m2401(c0152fb) != C0452yh.m9757()) {
            return (T) adds.m2889(m3729(this), C0460zg.m11347(c0152fb));
        }
        C0459zf.m11132(c0152fb);
        return null;
    }

    public void m422a(C0155fe c0155fe, T t) {
        C0457zc.m10576(c0155fe, t == null ? null : (String) adds.m2889(m3726(this), t));
    }

    @Override
    public void mo225a(C0155fe c0155fe, Object obj) {
        m3732(this, c0155fe, (Enum) obj);
    }

    @Override
    public Object mo227b(C0152fb c0152fb) {
        return m3731(this, c0152fb);
    }
}
