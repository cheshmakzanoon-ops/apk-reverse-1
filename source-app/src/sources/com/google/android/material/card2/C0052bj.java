package com.google.android.material.card2;

import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.util.Iterator;
import java.util.List;

public final class C0052bj implements Cloneable, InterfaceC0024aj {

    public static final C0052bj f67ax = new C0052bj();

    private boolean f68aA;

    private double f71aD = -1.0d;

    private int f73az = 136;

    private boolean f70aC = true;

    private List<InterfaceC0014a> f69aB = C0461zs.m11607();

    private List<InterfaceC0014a> f72ay = C0461zs.m11607();

    private boolean m283a(InterfaceC0028an interfaceC0028an) {
        return interfaceC0028an == null || gggy.m4379(interfaceC0028an) <= C0456zb.m10358(this);
    }

    private boolean m284a(InterfaceC0028an interfaceC0028an, InterfaceC0029ao interfaceC0029ao) {
        return C0446yb.m8512(this, interfaceC0028an) && C0452yh.m9761(this, interfaceC0029ao);
    }

    private boolean m285a(InterfaceC0029ao interfaceC0029ao) {
        return interfaceC0029ao == null || m3008(interfaceC0029ao) > C0456zb.m10358(this);
    }

    private boolean m286a(Class<?> cls, boolean z) {
        Iterator itM9883 = C0453yj.m9883(z ? C0457zc.m10744(this) : C0447yc.m8694(this));
        while (C0455za.m10104(itM9883)) {
            if (m3010((InterfaceC0014a) m2997(itM9883), cls)) {
                return true;
            }
        }
        return false;
    }

    private boolean m287d(Class<?> cls) {
        if (C0456zb.m10358(this) == -1.0d || C0455za.m10144(this, (InterfaceC0028an) m3012(cls, InterfaceC0028an.class), (InterfaceC0029ao) m3012(cls, InterfaceC0029ao.class))) {
            return (!C0445ya.m8229(this) && C0456zb.m10390(this, cls)) || adds.m2690(this, cls);
        }
        return true;
    }

    private boolean m288e(Class<?> cls) {
        return !gggy.m4342(Enum.class, cls) && (C0449ye.m9115(cls) || C0445ya.m8378(cls));
    }

    private boolean m289f(Class<?> cls) {
        return C0460zg.m11314(cls) && !C0449ye.m9157(this, cls);
    }

    private boolean m290g(Class<?> cls) {
        return (gggy.m4330(cls) & 8) != 0;
    }

    public static boolean m2995(Object obj, Object obj2) {
        if (abf.m2510() <= 0) {
            return ((C0052bj) obj).m290g((Class) obj2);
        }
        return false;
    }

    public static double m2996(Object obj) {
        if (C0447yc.m8635() > 0) {
            return ((C0052bj) obj).f71aD;
        }
        return 0.0d;
    }

    public static Object m2997(Object obj) {
        if (C0450yf.m9352() <= 0) {
            return C0598.m11882(obj);
        }
        return null;
    }

    public static boolean m2998(Object obj, Object obj2) {
        if (C0450yf.m9352() < 0) {
            return ((C0052bj) obj).m288e((Class) obj2);
        }
        return false;
    }

    public static boolean m2999(Object obj) {
        if (gggy.m4269() < 0) {
            return ((C0052bj) obj).f70aC;
        }
        return false;
    }

    public static boolean m3000(Object obj, Object obj2) {
        if (C0457zc.m10735() <= 0) {
            return ((C0052bj) obj).m289f((Class) obj2);
        }
        return false;
    }

    public static boolean m3001(Object obj, Object obj2) {
        if (C0453yj.m10013() >= 0) {
            return ((C0052bj) obj).m287d((Class) obj2);
        }
        return false;
    }

    public static boolean m3002(Object obj, Object obj2, boolean z) {
        if (abe.m2308() < 0) {
            return ((C0052bj) obj).m286a((Class<?>) obj2, z);
        }
        return false;
    }

    public static List m3003(Object obj) {
        if (C0452yh.m9798() > 0) {
            return ((C0052bj) obj).f69aB;
        }
        return null;
    }

    public static boolean m3004(Object obj, Object obj2) {
        if (C0448yd.m9079() < 0) {
            return ((C0052bj) obj).m285a((InterfaceC0029ao) obj2);
        }
        return false;
    }

    public static int m3005(Object obj) {
        if (C0448yd.m9079() < 0) {
            return ((C0052bj) obj).f73az;
        }
        return 0;
    }

    public static boolean m3006(Object obj, Object obj2, Object obj3) {
        if (abd.m2162() >= 0) {
            return ((C0052bj) obj).m284a((InterfaceC0028an) obj2, (InterfaceC0029ao) obj3);
        }
        return false;
    }

    public static List m3007(Object obj) {
        if (C0448yd.m9079() <= 0) {
            return ((C0052bj) obj).f72ay;
        }
        return null;
    }

    public static double m3008(Object obj) {
        if (C0458ze.m10932() >= 0) {
            return C0598.m11876(obj);
        }
        return 0.0d;
    }

    public static boolean m3009(Object obj, Object obj2) {
        if (adds.m2755() > 0) {
            return ((C0052bj) obj).m283a((InterfaceC0028an) obj2);
        }
        return false;
    }

    public static boolean m3010(Object obj, Object obj2) {
        if (C0451yg.m9580() > 0) {
            return C0598.m11907(obj, obj2);
        }
        return false;
    }

    public static boolean m3011(Object obj) {
        if (C0456zb.m10326() < 0) {
            return ((C0052bj) obj).f68aA;
        }
        return false;
    }

    public static Annotation m3012(Object obj, Object obj2) {
        if (C0450yf.m9352() <= 0) {
            return C0598.m11881(obj, obj2);
        }
        return null;
    }

    public static C0052bj m3013(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return ((C0052bj) obj).m293z();
        }
        return null;
    }

    public static boolean m3014(Object obj) {
        if (C0453yj.m10032() >= 0) {
            return m2999((C0052bj) obj);
        }
        return false;
    }

    public static int m3015(Object obj) {
        if (C0460zg.m11293() > 0) {
            return m3005((C0052bj) obj);
        }
        return 0;
    }

    public static double m3016(Object obj) {
        if (abf.m2500() >= 0) {
            return m2996((C0052bj) obj);
        }
        return 0.0d;
    }

    public static List m3017(Object obj) {
        if (abd.m2021() > 0) {
            return m3003((C0052bj) obj);
        }
        return null;
    }

    public static boolean m3018(Object obj, Object obj2) {
        if (C0460zg.m11293() > 0) {
            return m3000((C0052bj) obj, (Class) obj2);
        }
        return false;
    }

    public static boolean m3019(Object obj, Object obj2) {
        if (C0458ze.m10926() <= 0) {
            return m2998((C0052bj) obj, (Class) obj2);
        }
        return false;
    }

    public static boolean m3020(Object obj, Object obj2, boolean z) {
        if (C0448yd.m9074() < 0) {
            return m3002((C0052bj) obj, (Class) obj2, z);
        }
        return false;
    }

    public static C0052bj m3021(Object obj) {
        if (C0457zc.m10718() <= 0) {
            return m3013((C0052bj) obj);
        }
        return null;
    }

    public static boolean m3022(Object obj, Object obj2) {
        if (C0457zc.m10718() < 0) {
            return m3009((C0052bj) obj, (InterfaceC0028an) obj2);
        }
        return false;
    }

    public static boolean m3023(Object obj) {
        if (C0453yj.m9945() < 0) {
            return m3011((C0052bj) obj);
        }
        return false;
    }

    public static List m3024(Object obj) {
        if (abf.m2500() > 0) {
            return m3007((C0052bj) obj);
        }
        return null;
    }

    public static boolean m3025(Object obj, Object obj2) {
        if (C0457zc.m10555() > 0) {
            return m2995((C0052bj) obj, (Class) obj2);
        }
        return false;
    }

    public static boolean m3026(Object obj, Object obj2, Object obj3) {
        if (abe.m2321() <= 0) {
            return m3006((C0052bj) obj, (InterfaceC0028an) obj2, (InterfaceC0029ao) obj3);
        }
        return false;
    }

    public static boolean m3027(Object obj, Object obj2) {
        if (gggy.m4365() > 0) {
            return m3004((C0052bj) obj, (InterfaceC0029ao) obj2);
        }
        return false;
    }

    public static boolean m3028(Object obj, Object obj2) {
        if (C0448yd.m9074() <= 0) {
            return m3001((C0052bj) obj, (Class) obj2);
        }
        return false;
    }

    @Override
    public <T> AbstractC0022ah<T> mo229a(C0285k c0285k, C0151fa<T> c0151fa) {
        Class clsM1970 = abc.m1970(c0151fa);
        boolean zM11247 = C0460zg.m11247(this, clsM1970);
        boolean z = zM11247 || adds.m2669(this, clsM1970, true);
        boolean z2 = zM11247 || adds.m2669(this, clsM1970, false);
        if (z || z2) {
            return new C0053bk(this, z2, z, c0285k, c0151fa);
        }
        return null;
    }

    public boolean m291a(Field field, boolean z) {
        InterfaceC0025ak interfaceC0025ak;
        if ((C0457zc.m10709(this) & C0449ye.m9258(field)) != 0) {
            return true;
        }
        if ((C0456zb.m10358(this) == -1.0d || C0455za.m10144(this, (InterfaceC0028an) C0445ya.m8331(field, InterfaceC0028an.class), (InterfaceC0029ao) C0445ya.m8331(field, InterfaceC0029ao.class))) && !C0457zc.m10697(field)) {
            if (abc.m1788(this) && ((interfaceC0025ak = (InterfaceC0025ak) C0445ya.m8331(field, InterfaceC0025ak.class)) == null || (!z ? C0452yh.m9628(interfaceC0025ak) : C0461zs.m11529(interfaceC0025ak)))) {
                return true;
            }
            if ((C0445ya.m8229(this) || !C0456zb.m10390(this, abc.m1764(field))) && !adds.m2690(this, abc.m1764(field))) {
                List listM10744 = z ? C0457zc.m10744(this) : C0447yc.m8694(this);
                if (!C0452yh.m9618(listM10744)) {
                    C0041b c0041b = new C0041b(field);
                    Iterator itM9883 = C0453yj.m9883(listM10744);
                    while (C0455za.m10104(itM9883)) {
                        if (C0447yc.m8618((InterfaceC0014a) m2997(itM9883), c0041b)) {
                            return true;
                        }
                    }
                }
                return false;
            }
            return true;
        }
        return true;
    }

    public boolean m292b(Class<?> cls, boolean z) {
        return C0460zg.m11247(this, cls) || adds.m2669(this, cls, z);
    }

    protected Object clone() {
        return abf.m2453(this);
    }

    protected C0052bj m293z() {
        try {
            return (C0052bj) super.clone();
        } catch (CloneNotSupportedException e) {
            throw new AssertionError(e);
        }
    }
}
