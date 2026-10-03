package com.google.android.material.card2;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Map;

final class C0089ct<K, V> extends AbstractC0022ah<Map<K, V>> {

    private final InterfaceC0065bw<? extends Map<K, V>> f145bN;

    private final AbstractC0022ah<K> f146bO;

    final C0088cs f147bP;

    private final AbstractC0022ah<V> f148bQ;

    public C0089ct(C0088cs c0088cs, C0285k c0285k, Type type, AbstractC0022ah<K> abstractC0022ah, Type type2, AbstractC0022ah<V> abstractC0022ah2, InterfaceC0065bw<? extends Map<K, V>> interfaceC0065bw) {
        this.f147bP = c0088cs;
        this.f146bO = new C0105di(c0285k, abstractC0022ah, type);
        this.f148bQ = new C0105di(c0285k, abstractC0022ah2, type2);
        this.f145bN = interfaceC0065bw;
    }

    private String m371d(AbstractC0441v abstractC0441v) {
        if (!C0447yc.m8733(abstractC0441v)) {
            if (abd.m1998(abstractC0441v)) {
                return C0448yd.m8883();
            }
            throw new AssertionError();
        }
        C0015aa c0015aaM2561 = abf.m2561(abstractC0441v);
        if (adds.m2714(c0015aaM2561)) {
            return C0456zb.m10388(C0448yd.m9060(c0015aaM2561));
        }
        if (m3358(c0015aaM2561)) {
            return C0460zg.m11273(C0457zc.m10717(c0015aaM2561));
        }
        if (C0459zf.m11093(c0015aaM2561)) {
            return abf.m2442(c0015aaM2561);
        }
        throw new AssertionError();
    }

    public static int m3340(Object obj) {
        if (C0446yb.m8415() < 0) {
            return C0598.m11824(obj);
        }
        return 0;
    }

    public static InterfaceC0065bw m3341(Object obj) {
        if (C0452yh.m9798() > 0) {
            return m3360(obj);
        }
        return null;
    }

    public static Object m3342(Object obj) {
        if (C0448yd.m9079() <= 0) {
            return C0598.m11882(obj);
        }
        return null;
    }

    public static boolean m3343(Object obj) {
        if (C0460zg.m11287() > 0) {
            return ((C0088cs) obj).f143bL;
        }
        return false;
    }

    public static AbstractC0022ah m3344(Object obj) {
        if (C0458ze.m10932() > 0) {
            return m3361(obj);
        }
        return null;
    }

    public static void m3345(Object obj, Object obj2, Object obj3) {
        if (C0449ye.m9220() < 0) {
            ((C0089ct) obj).m372a((C0155fe) obj2, (Map) obj3);
        }
    }

    public static AbstractC0022ah m3346(Object obj) {
        if (gggy.m4269() <= 0) {
            return ((C0089ct) obj).f148bQ;
        }
        return null;
    }

    public static AbstractC0022ah m3347(Object obj) {
        if (C0450yf.m9352() <= 0) {
            return m3366(obj);
        }
        return null;
    }

    public static InterfaceC0065bw m3348(Object obj) {
        if (abc.m1845() <= 0) {
            return ((C0089ct) obj).f145bN;
        }
        return null;
    }

    public static void m3349(Object obj, Object obj2, Object obj3) {
        if (C0447yc.m8635() > 0) {
            m3367(obj, obj2, obj3);
        }
    }

    public static AbstractC0022ah m3350(Object obj) {
        if (abe.m2308() < 0) {
            return ((C0089ct) obj).f146bO;
        }
        return null;
    }

    public static String m3351(Object obj, Object obj2) {
        if (gggy.m4269() <= 0) {
            return ((C0089ct) obj).m371d((AbstractC0441v) obj2);
        }
        return null;
    }

    public static Map m3352(Object obj, Object obj2) {
        if (C0458ze.m10932() > 0) {
            return m3363(obj, obj2);
        }
        return null;
    }

    public static C0088cs m3353(Object obj) {
        if (adds.m2755() > 0) {
            return m3365(obj);
        }
        return null;
    }

    public static String m3354(Object obj, Object obj2) {
        if (C0450yf.m9352() < 0) {
            return m3362(obj, obj2);
        }
        return null;
    }

    public static C0088cs m3355(Object obj) {
        if (abe.m2308() < 0) {
            return ((C0089ct) obj).f147bP;
        }
        return null;
    }

    public static boolean m3356(Object obj) {
        if (C0448yd.m9079() < 0) {
            return m3364(obj);
        }
        return false;
    }

    public static Map m3357(Object obj, Object obj2) {
        if (C0446yb.m8415() < 0) {
            return ((C0089ct) obj).m373k((C0152fb) obj2);
        }
        return null;
    }

    public static boolean m3358(Object obj) {
        if (C0458ze.m10932() > 0) {
            return C0598.m11810(obj);
        }
        return false;
    }

    public static void m3359(Object obj) {
        if (C0457zc.m10735() <= 0) {
            C0598.m11835(obj);
        }
    }

    public static InterfaceC0065bw m3360(Object obj) {
        if (C0457zc.m10718() < 0) {
            return m3348((C0089ct) obj);
        }
        return null;
    }

    public static AbstractC0022ah m3361(Object obj) {
        if (C0459zf.m11053() > 0) {
            return m3346((C0089ct) obj);
        }
        return null;
    }

    public static String m3362(Object obj, Object obj2) {
        if (C0458ze.m10926() < 0) {
            return m3351((C0089ct) obj, (AbstractC0441v) obj2);
        }
        return null;
    }

    public static Map m3363(Object obj, Object obj2) {
        if (C0447yc.m8786() >= 0) {
            return m3357((C0089ct) obj, (C0152fb) obj2);
        }
        return null;
    }

    public static boolean m3364(Object obj) {
        if (C0453yj.m9996() < 0) {
            return m3343((C0088cs) obj);
        }
        return false;
    }

    public static C0088cs m3365(Object obj) {
        if (C0459zf.m11053() > 0) {
            return m3355((C0089ct) obj);
        }
        return null;
    }

    public static AbstractC0022ah m3366(Object obj) {
        if (abd.m2166() < 0) {
            return m3350((C0089ct) obj);
        }
        return null;
    }

    public static void m3367(Object obj, Object obj2, Object obj3) {
        if (C0453yj.m9996() <= 0) {
            m3345((C0089ct) obj, (C0155fe) obj2, (Map) obj3);
        }
    }

    @Override
    public void mo225a(C0155fe c0155fe, Object obj) {
        m3349(this, c0155fe, (Map) obj);
    }

    public void m372a(C0155fe c0155fe, Map<K, V> map) {
        int i = 0;
        if (map == null) {
            C0457zc.m10630(c0155fe);
            return;
        }
        if (!m3356(m3353(this))) {
            C0447yc.m8775(c0155fe);
            Iterator itM9939 = C0453yj.m9939(C0446yb.m8477(map));
            while (C0455za.m10104(itM9939)) {
                Map.Entry entry = (Map.Entry) m3342(itM9939);
                C0453yj.m9830(c0155fe, C0456zb.m10388(abe.m2338(entry)));
                C0457zc.m10586(m3344(this), c0155fe, C0455za.m10227(entry));
            }
            C0458ze.m10945(c0155fe);
            return;
        }
        ArrayList arrayList = new ArrayList(C0461zs.m11616(map));
        ArrayList arrayList2 = new ArrayList(C0461zs.m11616(map));
        Iterator itM99310 = C0453yj.m9939(C0446yb.m8477(map));
        boolean z = false;
        while (C0455za.m10104(itM99310)) {
            Map.Entry entry2 = (Map.Entry) m3342(itM99310);
            AbstractC0441v abstractC0441vM11570 = C0461zs.m11570(m3347(this), abe.m2338(entry2));
            C0460zg.m11251(arrayList, abstractC0441vM11570);
            C0460zg.m11251(arrayList2, C0455za.m10227(entry2));
            z = (C0461zs.m11583(abstractC0441vM11570) || C0452yh.m9775(abstractC0441vM11570)) | z;
        }
        if (!z) {
            C0447yc.m8775(c0155fe);
            int iM3340 = m3340(arrayList);
            while (i < iM3340) {
                C0453yj.m9830(c0155fe, m3354(this, (AbstractC0441v) gggy.m4400(arrayList, i)));
                C0457zc.m10586(m3344(this), c0155fe, gggy.m4400(arrayList2, i));
                i++;
            }
            C0458ze.m10945(c0155fe);
            return;
        }
        abf.m2469(c0155fe);
        int iM3341 = m3340(arrayList);
        while (i < iM3341) {
            abf.m2469(c0155fe);
            adds.m2870((AbstractC0441v) gggy.m4400(arrayList, i), c0155fe);
            C0457zc.m10586(m3344(this), c0155fe, gggy.m4400(arrayList2, i));
            C0450yf.m9574(c0155fe);
            i++;
        }
        C0450yf.m9574(c0155fe);
    }

    @Override
    public Object mo227b(C0152fb c0152fb) {
        return m3352(this, c0152fb);
    }

    public Map<K, V> m373k(C0152fb c0152fb) {
        EnumC0154fd enumC0154fdM2401 = abe.m2401(c0152fb);
        if (enumC0154fdM2401 == C0452yh.m9757()) {
            C0459zf.m11132(c0152fb);
            return null;
        }
        Map<K, V> map = (Map) abf.m2542(m3341(this));
        if (enumC0154fdM2401 != C0453yj.m9984()) {
            C0456zb.m10454(c0152fb);
            while (C0455za.m10208(c0152fb)) {
                C0445ya.m8366(C0452yh.m9750(), c0152fb);
                Object objM8683 = C0447yc.m8683(m3347(this), c0152fb);
                if (C0445ya.m8264(map, objM8683, C0447yc.m8683(m3344(this), c0152fb)) != null) {
                    throw new C0018ad(abc.m1925(abd.m2090(C0460zg.m11407(new StringBuilder(), abf.m2494()), objM8683)));
                }
            }
            C0459zf.m11135(c0152fb);
            return map;
        }
        C0461zs.m11627(c0152fb);
        while (C0455za.m10208(c0152fb)) {
            C0461zs.m11627(c0152fb);
            Object objM8684 = C0447yc.m8683(m3347(this), c0152fb);
            if (C0445ya.m8264(map, objM8684, C0447yc.m8683(m3344(this), c0152fb)) != null) {
                throw new C0018ad(abc.m1925(abd.m2090(C0460zg.m11407(new StringBuilder(), abf.m2494()), objM8684)));
            }
            m3359(c0152fb);
        }
        m3359(c0152fb);
        return map;
    }
}
