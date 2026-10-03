package com.google.android.material.card2;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

final class C0348mh {

    static final C0347mg[] f1077rp = {new C0347mg(C0448yd.m9066(), gggy.m4277()), new C0347mg(C0461zs.m11635(), C0453yj.m10028()), new C0347mg(C0461zs.m11635(), C0458ze.m10888()), new C0347mg(C0461zs.m11589(), m6347()), new C0347mg(C0461zs.m11589(), abc.m1939()), new C0347mg(C0450yf.m9499(), abd.m2063()), new C0347mg(C0450yf.m9499(), C0459zf.m11016()), new C0347mg(C0459zf.m11143(), C0450yf.m9409()), new C0347mg(C0459zf.m11143(), gggy.m4381()), new C0347mg(C0459zf.m11143(), C0460zg.m11354()), new C0347mg(C0459zf.m11143(), C0455za.m10229()), new C0347mg(C0459zf.m11143(), C0450yf.m9331()), new C0347mg(C0459zf.m11143(), C0456zb.m10304()), new C0347mg(C0459zf.m11143(), C0450yf.m9354()), new C0347mg(adds.m2752(), gggy.m4277()), new C0347mg(abc.m1774(), C0452yh.m9605()), new C0347mg(abc.m1880(), gggy.m4277()), new C0347mg(C0461zs.m11587(), gggy.m4277()), new C0347mg(C0457zc.m10682(), gggy.m4277()), new C0347mg(abd.m2194(), gggy.m4277()), new C0347mg(C0447yc.m8690(), gggy.m4277()), new C0347mg(C0447yc.m8754(), gggy.m4277()), new C0347mg(C0449ye.m9136(), gggy.m4277()), new C0347mg(adds.m2691(), gggy.m4277()), new C0347mg(adds.m2798(), gggy.m4277()), new C0347mg(abf.m2434(), gggy.m4277()), new C0347mg(abc.m1756(), gggy.m4277()), new C0347mg(C0450yf.m9398(), gggy.m4277()), new C0347mg(abf.m2530(), gggy.m4277()), new C0347mg(abc.m1837(), gggy.m4277()), new C0347mg(C0445ya.m8380(), gggy.m4277()), new C0347mg(abe.m2311(), gggy.m4277()), new C0347mg(C0459zf.m11169(), gggy.m4277()), new C0347mg(C0452yh.m9708(), gggy.m4277()), new C0347mg(C0455za.m10238(), gggy.m4277()), new C0347mg(abc.m1752(), gggy.m4277()), new C0347mg(C0453yj.m9933(), gggy.m4277()), new C0347mg(adds.m2761(), gggy.m4277()), new C0347mg(C0460zg.m11388(), gggy.m4277()), new C0347mg(m6346(), gggy.m4277()), new C0347mg(C0457zc.m10706(), gggy.m4277()), new C0347mg(C0458ze.m10787(), gggy.m4277()), new C0347mg(C0450yf.m9408(), gggy.m4277()), new C0347mg(C0453yj.m9918(), gggy.m4277()), new C0347mg(C0457zc.m10582(), gggy.m4277()), new C0347mg(adds.m2897(), gggy.m4277()), new C0347mg(C0445ya.m8324(), gggy.m4277()), new C0347mg(C0446yb.m8552(), gggy.m4277()), new C0347mg(C0459zf.m11066(), gggy.m4277()), new C0347mg(C0450yf.m9382(), gggy.m4277()), new C0347mg(C0452yh.m9823(), gggy.m4277()), new C0347mg(m6345(), gggy.m4277()), new C0347mg(C0447yc.m8805(), gggy.m4277()), new C0347mg(C0449ye.m9160(), gggy.m4277()), new C0347mg(C0460zg.m11335(), gggy.m4277()), new C0347mg(C0455za.m10130(), gggy.m4277()), new C0347mg(C0450yf.m9446(), gggy.m4277()), new C0347mg(C0459zf.m11001(), gggy.m4277()), new C0347mg(C0452yh.m9644(), gggy.m4277()), new C0347mg(abf.m2619(), gggy.m4277()), new C0347mg(C0458ze.m10776(), gggy.m4277())};

    static final Map<C0412or, Integer> f1076ro = m6343();

    static C0412or m1114a(C0412or c0412or) throws IOException {
        int iM4418 = gggy.m4418(c0412or);
        for (int i = 0; i < iM4418; i++) {
            byte bM8829 = C0447yc.m8829(c0412or, i);
            if (bM8829 >= 65 && bM8829 <= 90) {
                throw new IOException(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), abf.m2462()), C0458ze.m10854(c0412or))));
            }
        }
        return c0412or;
    }

    private static Map<C0412or, Integer> m1115eq() {
        LinkedHashMap linkedHashMap = new LinkedHashMap(m6341().length);
        for (int i = 0; i < m6341().length; i++) {
            if (!adds.m2770(linkedHashMap, C0455za.m10117(m6341()[i]))) {
                C0445ya.m8264(linkedHashMap, C0455za.m10117(m6341()[i]), abd.m2028(i));
            }
        }
        return C0447yc.m8729(linkedHashMap);
    }

    public static C0347mg[] m6341() {
        if (C0459zf.m11062() > 0) {
            return m6349();
        }
        return null;
    }

    public static Map m6342() {
        if (C0456zb.m10326() < 0) {
            return m1115eq();
        }
        return null;
    }

    public static Map m6343() {
        if (adds.m2755() >= 0) {
            return m6348();
        }
        return null;
    }

    public static C0347mg[] m6344() {
        if (C0450yf.m9352() <= 0) {
            return f1077rp;
        }
        return null;
    }

    public static String m6345() {
        if (C0453yj.m10013() > 0) {
            return C0598.m11805();
        }
        return null;
    }

    public static String m6346() {
        if (C0451yg.m9580() >= 0) {
            return C0598.m11861();
        }
        return null;
    }

    public static String m6347() {
        if (C0447yc.m8635() > 0) {
            return C0598.m11901();
        }
        return null;
    }

    public static Map m6348() {
        if (C0447yc.m8786() > 0) {
            return m6342();
        }
        return null;
    }

    public static C0347mg[] m6349() {
        if (abe.m2321() < 0) {
            return m6344();
        }
        return null;
    }
}
