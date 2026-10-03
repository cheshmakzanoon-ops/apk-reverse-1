package com.google.android.material.card2;

import java.lang.reflect.Field;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public final class C0093cx implements InterfaceC0024aj {

    private final AbstractC0148ey f152bU = C0453yj.m10003();

    private final C0035au f153bV;

    private final C0052bj f154bW;

    private final InterfaceC0258j f155bX;

    private final C0083cn f156bY;

    public C0093cx(C0035au c0035au, InterfaceC0258j interfaceC0258j, C0052bj c0052bj, C0083cn c0083cn) {
        this.f153bV = c0035au;
        this.f155bX = interfaceC0258j;
        this.f154bW = c0052bj;
        this.f156bY = c0083cn;
    }

    private AbstractC0097da m374a(C0285k c0285k, Field field, String str, C0151fa<?> c0151fa, boolean z, boolean z2) {
        boolean zM2324 = abe.m2324(abc.m1970(c0151fa));
        InterfaceC0026al interfaceC0026al = (InterfaceC0026al) C0445ya.m8331(field, InterfaceC0026al.class);
        AbstractC0022ah abstractC0022ahM8570 = interfaceC0026al != null ? C0446yb.m8570(C0449ye.m9305(this), abd.m2029(this), c0285k, c0151fa, interfaceC0026al) : null;
        boolean z3 = abstractC0022ahM8570 != null;
        if (abstractC0022ahM8570 == null) {
            abstractC0022ahM8570 = abd.m2165(c0285k, c0151fa);
        }
        return new C0094cy(this, str, z, z2, field, z3, abstractC0022ahM8570, c0285k, c0151fa, zM2324);
    }

    private Map<String, AbstractC0097da> m375a(C0285k c0285k, C0151fa<?> c0151fa, Class<?> cls) {
        Class<?> clsM1970 = cls;
        C0151fa<?> c0151faM11619 = c0151fa;
        LinkedHashMap linkedHashMap = new LinkedHashMap();
        if (!abf.m2602(clsM1970)) {
            Type typeM10432 = C0456zb.m10432(c0151faM11619);
            while (clsM1970 != Object.class) {
                for (Field field : gggy.m4448(clsM1970)) {
                    boolean zM10368 = C0456zb.m10368(this, field, true);
                    boolean zM10369 = C0456zb.m10368(this, field, false);
                    if (zM10368 || zM10369) {
                        C0445ya.m8343(C0460zg.m11418(this), field);
                        Type typeM1956 = abc.m1956(C0456zb.m10432(c0151faM11619), clsM1970, C0456zb.m10355(field));
                        List listM4311 = gggy.m4311(this, field);
                        AbstractC0097da abstractC0097da = null;
                        int iM3380 = m3380(listM4311);
                        for (int i = 0; i < iM3380; i++) {
                            String str = (String) gggy.m4400(listM4311, i);
                            if (i != 0) {
                                zM10368 = false;
                            }
                            AbstractC0097da abstractC0097da2 = (AbstractC0097da) C0445ya.m8264(linkedHashMap, str, m3382(this, c0285k, field, str, C0461zs.m11619(typeM1956), zM10368, zM10369));
                            if (abstractC0097da != null) {
                                abstractC0097da2 = abstractC0097da;
                            }
                            abstractC0097da = abstractC0097da2;
                        }
                        if (abstractC0097da != null) {
                            throw new IllegalArgumentException(abc.m1925(C0460zg.m11407(C0460zg.m11407(abd.m2090(new StringBuilder(), typeM10432), abe.m2304()), C0446yb.m8423(abstractC0097da))));
                        }
                    }
                }
                c0151faM11619 = C0461zs.m11619(abc.m1956(C0456zb.m10432(c0151faM11619), clsM1970, C0449ye.m9165(clsM1970)));
                clsM1970 = abc.m1970(c0151faM11619);
            }
        }
        return linkedHashMap;
    }

    static boolean m376a(Field field, boolean z, C0052bj c0052bj) {
        return (C0447yc.m8651(c0052bj, abc.m1764(field), z) || abc.m1947(c0052bj, field, z)) ? false : true;
    }

    private List<String> m377b(Field field) {
        InterfaceC0027am interfaceC0027am = (InterfaceC0027am) C0445ya.m8331(field, InterfaceC0027am.class);
        if (interfaceC0027am == null) {
            return abc.m1886(C0453yj.m9897(C0446yb.m8483(this), field));
        }
        String strM9134 = C0449ye.m9134(interfaceC0027am);
        String[] strArrM9680 = C0452yh.m9680(interfaceC0027am);
        if (strArrM9680.length == 0) {
            return abc.m1886(strM9134);
        }
        ArrayList arrayList = new ArrayList(strArrM9680.length + 1);
        C0460zg.m11251(arrayList, strM9134);
        for (String str : strArrM9680) {
            C0460zg.m11251(arrayList, str);
        }
        return arrayList;
    }

    public static boolean m3376(Object obj, boolean z, Object obj2) {
        if (C0452yh.m9798() >= 0) {
            return m376a((Field) obj, z, (C0052bj) obj2);
        }
        return false;
    }

    public static AbstractC0148ey m3377(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return ((C0093cx) obj).f152bU;
        }
        return null;
    }

    public static C0052bj m3378(Object obj) {
        if (C0457zc.m10735() < 0) {
            return ((C0093cx) obj).f154bW;
        }
        return null;
    }

    public static List m3379(Object obj, Object obj2) {
        if (C0458ze.m10932() > 0) {
            return ((C0093cx) obj).m377b((Field) obj2);
        }
        return null;
    }

    public static int m3380(Object obj) {
        if (abc.m1845() < 0) {
            return C0598.m11824(obj);
        }
        return 0;
    }

    public static C0035au m3381(Object obj) {
        if (C0452yh.m9798() >= 0) {
            return ((C0093cx) obj).f153bV;
        }
        return null;
    }

    public static AbstractC0097da m3382(Object obj, Object obj2, Object obj3, Object obj4, Object obj5, boolean z, boolean z2) {
        if (C0450yf.m9352() <= 0) {
            return m3395(obj, obj2, obj3, obj4, obj5, z, z2);
        }
        return null;
    }

    public static C0083cn m3383(Object obj) {
        if (C0457zc.m10735() < 0) {
            return ((C0093cx) obj).f156bY;
        }
        return null;
    }

    public static Map m3384(Object obj, Object obj2, Object obj3, Object obj4) {
        if (C0446yb.m8415() <= 0) {
            return ((C0093cx) obj).m375a((C0285k) obj2, (C0151fa<?>) obj3, (Class<?>) obj4);
        }
        return null;
    }

    public static String m3385(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return ((AbstractC0097da) obj).f167cj;
        }
        return null;
    }

    public static AbstractC0022ah m3386(Object obj, Object obj2, Object obj3, Object obj4, Object obj5) {
        if (abc.m1845() < 0) {
            return ((C0083cn) obj).m335a((C0035au) obj2, (C0285k) obj3, (C0151fa) obj4, (InterfaceC0026al) obj5);
        }
        return null;
    }

    public static AbstractC0097da m3387(Object obj, Object obj2, Object obj3, Object obj4, Object obj5, boolean z, boolean z2) {
        if (C0461zs.m11510() < 0) {
            return ((C0093cx) obj).m374a((C0285k) obj2, (Field) obj3, (String) obj4, (C0151fa) obj5, z, z2);
        }
        return null;
    }

    public static InterfaceC0258j m3388(Object obj) {
        if (abd.m2162() >= 0) {
            return ((C0093cx) obj).f155bX;
        }
        return null;
    }

    public static C0035au m3389(Object obj) {
        if (C0453yj.m9966() >= 0) {
            return m3381((C0093cx) obj);
        }
        return null;
    }

    public static C0083cn m3390(Object obj) {
        if (gggy.m4365() > 0) {
            return m3383((C0093cx) obj);
        }
        return null;
    }

    public static Map m3391(Object obj, Object obj2, Object obj3, Object obj4) {
        if (C0453yj.m10032() > 0) {
            return m3384((C0093cx) obj, (C0285k) obj2, (C0151fa) obj3, (Class) obj4);
        }
        return null;
    }

    public static AbstractC0022ah m3392(Object obj, Object obj2, Object obj3, Object obj4, Object obj5) {
        if (C0458ze.m10926() <= 0) {
            return m3386((C0083cn) obj, (C0035au) obj2, (C0285k) obj3, (C0151fa) obj4, (InterfaceC0026al) obj5);
        }
        return null;
    }

    public static InterfaceC0258j m3393(Object obj) {
        if (C0458ze.m10926() < 0) {
            return m3388((C0093cx) obj);
        }
        return null;
    }

    public static List m3394(Object obj, Object obj2) {
        if (C0457zc.m10718() <= 0) {
            return m3379((C0093cx) obj, (Field) obj2);
        }
        return null;
    }

    public static AbstractC0097da m3395(Object obj, Object obj2, Object obj3, Object obj4, Object obj5, boolean z, boolean z2) {
        if (abe.m2321() <= 0) {
            return m3387((C0093cx) obj, (C0285k) obj2, (Field) obj3, (String) obj4, (C0151fa) obj5, z, z2);
        }
        return null;
    }

    public static AbstractC0148ey m3396(Object obj) {
        if (C0453yj.m9945() < 0) {
            return m3377((C0093cx) obj);
        }
        return null;
    }

    public static boolean m3397(Object obj, boolean z, Object obj2) {
        if (C0458ze.m10926() <= 0) {
            return m3376((Field) obj, z, (C0052bj) obj2);
        }
        return false;
    }

    public static C0052bj m3398(Object obj) {
        if (C0458ze.m10926() < 0) {
            return m3378((C0093cx) obj);
        }
        return null;
    }

    public static String m3399(Object obj) {
        if (C0448yd.m9015() < 0) {
            return m3385((AbstractC0097da) obj);
        }
        return null;
    }

    @Override
    public <T> AbstractC0022ah<T> mo229a(C0285k c0285k, C0151fa<T> c0151fa) {
        Class clsM1970 = abc.m1970(c0151fa);
        if (gggy.m4342(Object.class, clsM1970)) {
            return new C0095cz(C0458ze.m10889(abd.m2029(this), c0151fa), C0458ze.m10937(this, c0285k, c0151fa, clsM1970));
        }
        return null;
    }

    public boolean m378a(Field field, boolean z) {
        return C0460zg.m11282(field, z, gggy.m4363(this));
    }
}
