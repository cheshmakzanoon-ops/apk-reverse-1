package com.google.android.material.card2;

import java.io.ObjectInputStream;
import java.io.ObjectStreamClass;
import java.lang.reflect.Field;
import java.lang.reflect.Method;

public abstract class AbstractC0072cc {
    public static AbstractC0072cc m328I() {
        try {
            Class clsM9289 = C0449ye.m9289(C0459zf.m11021());
            Field fieldM11530 = C0461zs.m11530(clsM9289, C0449ye.m9120());
            abc.m1817(fieldM11530, true);
            return new C0073cd(C0461zs.m11528(clsM9289, C0449ye.m9298(), new Class[]{Class.class}), C0458ze.m10866(fieldM11530, null));
        } catch (Exception e) {
            try {
                Method methodM3227 = m3227(ObjectStreamClass.class, C0458ze.m10900(), new Class[]{Class.class});
                C0455za.m10162(methodM3227, true);
                int iM3226 = m3226((Integer) C0446yb.m8446(methodM3227, null, new Object[]{Object.class}));
                Method methodM3228 = m3227(ObjectStreamClass.class, abf.m2608(), new Class[]{Class.class, C0459zf.m11089()});
                C0455za.m10162(methodM3228, true);
                return new C0074ce(methodM3228, iM3226);
            } catch (Exception e2) {
                try {
                    Method methodM3229 = m3227(ObjectInputStream.class, abf.m2608(), new Class[]{Class.class, Class.class});
                    C0455za.m10162(methodM3229, true);
                    return new C0075cf(methodM3229);
                } catch (Exception e3) {
                    return new C0076cg();
                }
            }
        }
    }

    static void m329h(Class<?> cls) {
        int iM4330 = gggy.m4330(cls);
        if (C0456zb.m10318(iM4330)) {
            throw new UnsupportedOperationException(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0452yh.m9689()), C0456zb.m10455(cls))));
        }
        if (abd.m2171(iM4330)) {
            throw new UnsupportedOperationException(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0456zb.m10344()), C0456zb.m10455(cls))));
        }
    }

    public static int m3226(Object obj) {
        if (C0453yj.m10013() > 0) {
            return C0598.m11854(obj);
        }
        return 0;
    }

    public static Method m3227(Object obj, Object obj2, Object obj3) {
        if (C0461zs.m11510() < 0) {
            return C0598.m11845(obj, obj2, obj3);
        }
        return null;
    }

    public abstract <T> T mo330i(Class<T> cls);
}
