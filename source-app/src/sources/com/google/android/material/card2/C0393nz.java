package com.google.android.material.card2;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.util.List;

class C0393nz implements InvocationHandler {

    private final List<String> f1260uw;

    String f1261ux;

    boolean f1262uy;

    C0393nz(List<String> list) {
        this.f1260uw = list;
    }

    public static int m7527(Object obj) {
        if (C0460zg.m11287() > 0) {
            return C0598.m11824(obj);
        }
        return 0;
    }

    public static List m7528(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return m7530(obj);
        }
        return null;
    }

    public static List m7529(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return ((C0393nz) obj).f1260uw;
        }
        return null;
    }

    public static List m7530(Object obj) {
        if (abd.m2166() <= 0) {
            return m7529((C0393nz) obj);
        }
        return null;
    }

    @Override
    public Object invoke(Object obj, Method method, Object[] objArr) {
        Object[] objArrM8536 = objArr;
        String strM8475 = C0446yb.m8475(method);
        Class clsM4446 = gggy.m4446(method);
        if (objArrM8536 == null) {
            objArrM8536 = C0446yb.m8536();
        }
        if (C0452yh.m9583(strM8475, abc.m1805()) && C0448yd.m9025() == clsM4446) {
            return C0450yf.m9568(true);
        }
        if (C0452yh.m9583(strM8475, C0460zg.m11299()) && C0453yj.m9837() == clsM4446) {
            this.f1262uy = true;
            return null;
        }
        if (C0452yh.m9583(strM8475, C0457zc.m10736()) && objArrM8536.length == 0) {
            return m7528(this);
        }
        if ((!C0452yh.m9583(strM8475, C0458ze.m10939()) && !C0452yh.m9583(strM8475, C0457zc.m10554())) || String.class != clsM4446 || objArrM8536.length != 1 || !(objArrM8536[0] instanceof List)) {
            if ((!C0452yh.m9583(strM8475, C0458ze.m10783()) && !C0452yh.m9583(strM8475, C0458ze.m10766())) || objArrM8536.length != 1) {
                return C0446yb.m8446(method, this, objArrM8536);
            }
            this.f1261ux = (String) objArrM8536[0];
            return null;
        }
        List list = (List) objArrM8536[0];
        int iM7527 = m7527(list);
        for (int i = 0; i < iM7527; i++) {
            if (C0458ze.m10847(m7528(this), gggy.m4400(list, i))) {
                String str = (String) gggy.m4400(list, i);
                this.f1261ux = str;
                return str;
            }
        }
        String str2 = (String) gggy.m4400(m7528(this), 0);
        this.f1261ux = str2;
        return str2;
    }
}
