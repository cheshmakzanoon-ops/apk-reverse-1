package com.google.android.material.card2;

import java.io.EOFException;
import java.io.IOException;
import java.io.Reader;
import java.io.StringReader;
import java.io.StringWriter;
import java.io.Writer;
import java.lang.reflect.Type;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;
import java.util.concurrent.atomic.AtomicLongArray;

public final class C0285k {

    private static final C0151fa<?> f809i = C0461zs.m11643(Object.class);

    final boolean f810A;

    final boolean f811B;

    final int f812C;

    private final Map<C0151fa<?>, AbstractC0022ah<?>> f813D;

    final List<InterfaceC0024aj> f814j;

    final List<InterfaceC0024aj> f815k;

    private final ThreadLocal<Map<C0151fa<?>, C0433q<?>>> f816l;

    final boolean f817m;

    private final C0035au f818n;

    final String f819o;

    final int f820p;

    final C0052bj f821q;

    final List<InterfaceC0024aj> f822r;

    final InterfaceC0258j f823s;

    final boolean f824t;

    final boolean f825u;

    final Map<Type, InterfaceC0434r<?>> f826v;

    private final C0083cn f827w;

    final boolean f828x;

    final EnumC0019ae f829y;

    final boolean f830z;

    public C0285k() {
        this(abf.m2567(), C0448yd.m8870(), C0457zc.m10724(), false, false, false, true, false, false, false, abf.m2643(), null, 2, 2, C0461zs.m11607(), C0461zs.m11607(), C0461zs.m11607());
    }

    C0285k(C0052bj c0052bj, InterfaceC0258j interfaceC0258j, Map<Type, InterfaceC0434r<?>> map, boolean z, boolean z2, boolean z3, boolean z4, boolean z5, boolean z6, boolean z7, EnumC0019ae enumC0019ae, String str, int i, int i2, List<InterfaceC0024aj> list, List<InterfaceC0024aj> list2, List<InterfaceC0024aj> list3) {
        this.f816l = new ThreadLocal<>();
        this.f813D = new ConcurrentHashMap();
        this.f821q = c0052bj;
        this.f823s = interfaceC0258j;
        this.f826v = map;
        this.f818n = new C0035au(map);
        this.f810A = z;
        this.f817m = z2;
        this.f824t = z3;
        this.f825u = z4;
        this.f830z = z5;
        this.f828x = z6;
        this.f811B = z7;
        this.f829y = enumC0019ae;
        this.f819o = str;
        this.f820p = i;
        this.f812C = i2;
        this.f814j = list;
        this.f815k = list2;
        ArrayList arrayList = new ArrayList();
        C0460zg.m11251(arrayList, m5546());
        C0460zg.m11251(arrayList, C0450yf.m9555());
        C0460zg.m11251(arrayList, c0052bj);
        C0447yc.m8634(arrayList, list3);
        C0460zg.m11251(arrayList, C0461zs.m11509());
        C0460zg.m11251(arrayList, m5555());
        C0460zg.m11251(arrayList, m5544());
        C0460zg.m11251(arrayList, C0461zs.m11511());
        C0460zg.m11251(arrayList, C0449ye.m9264());
        AbstractC0022ah abstractC0022ahM8916 = C0448yd.m8916(enumC0019ae);
        C0460zg.m11251(arrayList, gggy.m4268(C0456zb.m10425(), Long.class, abstractC0022ahM8916));
        C0460zg.m11251(arrayList, gggy.m4268(adds.m2765(), Double.class, C0450yf.m9517(this, z7)));
        C0460zg.m11251(arrayList, gggy.m4268(C0456zb.m10433(), Float.class, C0459zf.m11011(this, z7)));
        C0460zg.m11251(arrayList, C0448yd.m8861());
        C0460zg.m11251(arrayList, C0449ye.m9132());
        C0460zg.m11251(arrayList, C0458ze.m10933());
        C0460zg.m11251(arrayList, abc.m1813(AtomicLong.class, C0456zb.m10322(abstractC0022ahM8916)));
        C0460zg.m11251(arrayList, abc.m1813(AtomicLongArray.class, C0458ze.m10865(abstractC0022ahM8916)));
        C0460zg.m11251(arrayList, C0455za.m10261());
        C0460zg.m11251(arrayList, adds.m2803());
        C0460zg.m11251(arrayList, abe.m2288());
        C0460zg.m11251(arrayList, abd.m2031());
        C0460zg.m11251(arrayList, abc.m1813(BigDecimal.class, C0458ze.m10788()));
        C0460zg.m11251(arrayList, abc.m1813(BigInteger.class, C0447yc.m8680()));
        C0460zg.m11251(arrayList, C0448yd.m9091());
        C0460zg.m11251(arrayList, C0461zs.m11504());
        C0460zg.m11251(arrayList, C0450yf.m9515());
        C0460zg.m11251(arrayList, C0446yb.m8550());
        C0460zg.m11251(arrayList, C0458ze.m10768());
        C0460zg.m11251(arrayList, C0459zf.m11171());
        C0460zg.m11251(arrayList, C0453yj.m9971());
        C0460zg.m11251(arrayList, C0455za.m10100());
        C0460zg.m11251(arrayList, gggy.m4406());
        C0460zg.m11251(arrayList, C0456zb.m10349());
        C0460zg.m11251(arrayList, C0458ze.m10832());
        C0460zg.m11251(arrayList, C0448yd.m8900());
        C0460zg.m11251(arrayList, abc.m1834());
        C0460zg.m11251(arrayList, C0449ye.m9263());
        C0460zg.m11251(arrayList, new C0079cj(abd.m1987(this)));
        C0460zg.m11251(arrayList, new C0088cs(abd.m1987(this), z2));
        this.f827w = new C0083cn(abd.m1987(this));
        C0460zg.m11251(arrayList, abe.m2312(this));
        C0460zg.m11251(arrayList, gggy.m4395());
        C0460zg.m11251(arrayList, new C0093cx(abd.m1987(this), interfaceC0258j, c0052bj, abe.m2312(this)));
        this.f822r = abc.m1875(arrayList);
    }

    private static AbstractC0022ah<Number> m845a(EnumC0019ae enumC0019ae) {
        return enumC0019ae == abf.m2643() ? C0446yb.m8549() : new C0367n();
    }

    private static AbstractC0022ah<AtomicLong> m846a(AbstractC0022ah<Number> abstractC0022ah) {
        return C0456zb.m10457(new C0394o(abstractC0022ah));
    }

    private AbstractC0022ah<Number> m847a(boolean z) {
        return z ? abe.m2348() : new C0312l(this);
    }

    static void m848a(double d) {
        if (abe.m2262(d) || m5545(d)) {
            throw new IllegalArgumentException(abc.m1925(C0460zg.m11407(adds.m2814(new StringBuilder(), d), C0458ze.m10810())));
        }
    }

    private static void m849a(Object obj, C0152fb c0152fb) {
        if (obj != null) {
            try {
                if (abe.m2401(c0152fb) != m5554()) {
                    throw new C0442w(C0459zf.m11024());
                }
            } catch (C0156ff e) {
                throw new C0018ad(e);
            } catch (IOException e2) {
                throw new C0442w(e2);
            }
        }
    }

    private static AbstractC0022ah<AtomicLongArray> m850b(AbstractC0022ah<Number> abstractC0022ah) {
        return C0452yh.m9593(new C0421p(abstractC0022ah));
    }

    private AbstractC0022ah<Number> m851b(boolean z) {
        return z ? C0456zb.m10371() : new C0339m(this);
    }

    public static boolean m5542(Object obj) {
        if (C0457zc.m10735() < 0) {
            return ((C0285k) obj).f830z;
        }
        return false;
    }

    public static boolean m5543(Object obj) {
        if (C0452yh.m9798() > 0) {
            return ((C0285k) obj).f810A;
        }
        return false;
    }

    public static InterfaceC0024aj m5544() {
        if (C0446yb.m8415() < 0) {
            return C0598.m11867();
        }
        return null;
    }

    public static boolean m5545(double d) {
        if (C0447yc.m8635() >= 0) {
            return C0598.m11889(d);
        }
        return false;
    }

    public static InterfaceC0024aj m5546() {
        if (C0458ze.m10932() > 0) {
            return C0598.m11834();
        }
        return null;
    }

    public static AbstractC0022ah m5547(Object obj) {
        if (adds.m2755() >= 0) {
            return ((C0421p) obj).m228q();
        }
        return null;
    }

    public static AbstractC0022ah m5548(Object obj) {
        if (C0461zs.m11510() < 0) {
            return m846a((AbstractC0022ah<Number>) obj);
        }
        return null;
    }

    public static AbstractC0022ah m5549(Object obj) {
        if (abd.m2162() >= 0) {
            return m845a((EnumC0019ae) obj);
        }
        return null;
    }

    public static ThreadLocal m5550(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return ((C0285k) obj).f816l;
        }
        return null;
    }

    public static C0151fa m5551() {
        if (C0451yg.m9580() > 0) {
            return f809i;
        }
        return null;
    }

    public static Object m5552(Object obj) {
        if (abe.m2308() <= 0) {
            return C0598.m11882(obj);
        }
        return null;
    }

    public static C0035au m5553(Object obj) {
        if (C0456zb.m10326() < 0) {
            return ((C0285k) obj).f818n;
        }
        return null;
    }

    public static EnumC0154fd m5554() {
        if (C0456zb.m10326() <= 0) {
            return C0598.m11807();
        }
        return null;
    }

    public static InterfaceC0024aj m5555() {
        if (C0446yb.m8415() < 0) {
            return C0598.m11869();
        }
        return null;
    }

    public static C0083cn m5556(Object obj) {
        if (C0450yf.m9352() < 0) {
            return ((C0285k) obj).f827w;
        }
        return null;
    }

    public static boolean m5557(Object obj) {
        if (C0458ze.m10932() >= 0) {
            return ((C0285k) obj).f825u;
        }
        return false;
    }

    public static boolean m5558(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return ((C0285k) obj).f824t;
        }
        return false;
    }

    public static Map m5559(Object obj) {
        if (C0452yh.m9798() > 0) {
            return ((C0285k) obj).f813D;
        }
        return null;
    }

    public static int m5560() {
        if (C0458ze.m10932() > 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static AbstractC0022ah m5561(Object obj) {
        if (C0448yd.m9079() < 0) {
            return ((C0394o) obj).m228q();
        }
        return null;
    }

    public static void m5562(Object obj, Object obj2) {
        if (abf.m2510() < 0) {
            ((C0433q) obj).m1466c((AbstractC0022ah) obj2);
        }
    }

    public static void m5563(Object obj, Object obj2) {
        if (C0450yf.m9352() < 0) {
            m849a(obj, (C0152fb) obj2);
        }
    }

    public static AbstractC0022ah m5564(Object obj) {
        if (C0457zc.m10735() <= 0) {
            return m850b((AbstractC0022ah<Number>) obj);
        }
        return null;
    }

    public static AbstractC0022ah m5565(Object obj, boolean z) {
        if (C0446yb.m8415() < 0) {
            return ((C0285k) obj).m847a(z);
        }
        return null;
    }

    public static List m5566(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return ((C0285k) obj).f822r;
        }
        return null;
    }

    public static boolean m5567(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return ((C0285k) obj).f828x;
        }
        return false;
    }

    public static AbstractC0022ah m5568(Object obj, boolean z) {
        if (C0457zc.m10735() <= 0) {
            return ((C0285k) obj).m851b(z);
        }
        return null;
    }

    public static C0083cn m5569(Object obj) {
        if (C0448yd.m9015() <= 0) {
            return m5556((C0285k) obj);
        }
        return null;
    }

    public static boolean m5570(Object obj) {
        if (C0447yc.m8786() >= 0) {
            return m5557((C0285k) obj);
        }
        return false;
    }

    public static AbstractC0022ah m5571(Object obj) {
        if (m5560() >= 0) {
            return m5561((C0394o) obj);
        }
        return null;
    }

    public static void m5572(Object obj, Object obj2) {
        if (C0458ze.m10926() <= 0) {
            m5563(obj, (C0152fb) obj2);
        }
    }

    public static AbstractC0022ah m5573(Object obj, boolean z) {
        if (C0458ze.m10926() < 0) {
            return m5565((C0285k) obj, z);
        }
        return null;
    }

    public static C0151fa m5574() {
        if (C0445ya.m8330() > 0) {
            return m5551();
        }
        return null;
    }

    public static void m5575(Object obj, Object obj2) {
        if (C0447yc.m8786() >= 0) {
            m5562((C0433q) obj, (AbstractC0022ah) obj2);
        }
    }

    public static C0035au m5576(Object obj) {
        if (C0458ze.m10926() <= 0) {
            return m5553((C0285k) obj);
        }
        return null;
    }

    public static AbstractC0022ah m5577(Object obj) {
        if (C0459zf.m11053() > 0) {
            return m5547((C0421p) obj);
        }
        return null;
    }

    public static List m5578(Object obj) {
        if (C0457zc.m10718() <= 0) {
            return m5566((C0285k) obj);
        }
        return null;
    }

    public static boolean m5579(Object obj) {
        if (abd.m2166() < 0) {
            return m5567((C0285k) obj);
        }
        return false;
    }

    public static AbstractC0022ah m5580(Object obj) {
        if (abf.m2500() > 0) {
            return m5564((AbstractC0022ah) obj);
        }
        return null;
    }

    public static ThreadLocal m5581(Object obj) {
        if (abe.m2321() <= 0) {
            return m5550((C0285k) obj);
        }
        return null;
    }

    public static AbstractC0022ah m5582(Object obj) {
        if (abd.m2021() >= 0) {
            return m5548((AbstractC0022ah) obj);
        }
        return null;
    }

    public static boolean m5583(Object obj) {
        if (C0448yd.m9074() < 0) {
            return m5542((C0285k) obj);
        }
        return false;
    }

    public static boolean m5584(Object obj) {
        if (abe.m2321() <= 0) {
            return m5558((C0285k) obj);
        }
        return false;
    }

    public static AbstractC0022ah m5585(Object obj, boolean z) {
        if (C0453yj.m9966() > 0) {
            return m5568((C0285k) obj, z);
        }
        return null;
    }

    public static AbstractC0022ah m5586(Object obj) {
        if (C0453yj.m9996() <= 0) {
            return m5549((EnumC0019ae) obj);
        }
        return null;
    }

    public static Map m5587(Object obj) {
        if (abe.m2321() <= 0) {
            return m5559((C0285k) obj);
        }
        return null;
    }

    public static boolean m5588(Object obj) {
        if (abf.m2500() > 0) {
            return m5543((C0285k) obj);
        }
        return false;
    }

    public <T> AbstractC0022ah<T> m852a(InterfaceC0024aj interfaceC0024aj, C0151fa<T> c0151fa) {
        InterfaceC0024aj interfaceC0024ajM2312 = interfaceC0024aj;
        if (!C0458ze.m10847(C0459zf.m11067(this), interfaceC0024ajM2312)) {
            interfaceC0024ajM2312 = abe.m2312(this);
        }
        Iterator itM9883 = C0453yj.m9883(C0459zf.m11067(this));
        boolean z = false;
        while (C0455za.m10104(itM9883)) {
            InterfaceC0024aj interfaceC0024aj2 = (InterfaceC0024aj) m5552(itM9883);
            if (z) {
                AbstractC0022ah<T> abstractC0022ahM10607 = C0457zc.m10607(interfaceC0024aj2, this, c0151fa);
                if (abstractC0022ahM10607 != null) {
                    return abstractC0022ahM10607;
                }
            } else if (interfaceC0024aj2 == interfaceC0024ajM2312) {
                z = true;
            }
        }
        throw new IllegalArgumentException(abc.m1925(abd.m2090(C0460zg.m11407(new StringBuilder(), abe.m2306()), c0151fa)));
    }

    public <T> AbstractC0022ah<T> m853a(C0151fa<T> c0151fa) {
        Map map;
        AbstractC0022ah<T> abstractC0022ahM10607 = (AbstractC0022ah) adds.m2889(C0449ye.m9138(this), c0151fa == null ? abe.m2254() : c0151fa);
        if (abstractC0022ahM10607 == null) {
            Map map2 = (Map) C0448yd.m8940(C0445ya.m8274(this));
            boolean z = false;
            if (map2 == null) {
                HashMap map3 = new HashMap();
                adds.m2696(C0445ya.m8274(this), map3);
                z = true;
                map = map3;
            } else {
                map = map2;
            }
            abstractC0022ahM10607 = (C0433q) adds.m2889(map, c0151fa);
            if (abstractC0022ahM10607 == null) {
                try {
                    C0433q c0433q = new C0433q();
                    C0445ya.m8264(map, c0151fa, c0433q);
                    Iterator itM9883 = C0453yj.m9883(C0459zf.m11067(this));
                    while (C0455za.m10104(itM9883)) {
                        abstractC0022ahM10607 = C0457zc.m10607((InterfaceC0024aj) m5552(itM9883), this, c0151fa);
                        if (abstractC0022ahM10607 != null) {
                            C0455za.m10061(c0433q, abstractC0022ahM10607);
                            C0445ya.m8264(C0449ye.m9138(this), c0151fa, abstractC0022ahM10607);
                            abf.m2577(map, c0151fa);
                            if (z) {
                                C0453yj.m9864(C0445ya.m8274(this));
                            }
                        }
                    }
                    throw new IllegalArgumentException(abc.m1925(abd.m2090(C0460zg.m11407(new StringBuilder(), C0456zb.m10414()), c0151fa)));
                } catch (Throwable th) {
                    abf.m2577(map, c0151fa);
                    if (z) {
                        C0453yj.m9864(C0445ya.m8274(this));
                    }
                    throw th;
                }
            }
        }
        return abstractC0022ahM10607;
    }

    public C0152fb m854a(Reader reader) {
        C0152fb c0152fb = new C0152fb(reader);
        C0450yf.m9553(c0152fb, abd.m2051(this));
        return c0152fb;
    }

    public C0155fe m855a(Writer writer) {
        if (gggy.m4410(this)) {
            abe.m2297(writer, C0453yj.m9843());
        }
        C0155fe c0155fe = new C0155fe(writer);
        if (abd.m2002(this)) {
            C0453yj.m9914(c0155fe, abf.m2520());
        }
        C0458ze.m10906(c0155fe, abc.m1916(this));
        return c0155fe;
    }

    public <T> T m856a(C0152fb c0152fb, Type type) {
        boolean z = true;
        boolean zM2005 = abd.m2005(c0152fb);
        C0450yf.m9553(c0152fb, true);
        try {
            try {
                try {
                    try {
                        abe.m2401(c0152fb);
                        z = false;
                        T t = (T) C0447yc.m8683(abd.m2165(this, C0461zs.m11619(type)), c0152fb);
                        C0450yf.m9553(c0152fb, zM2005);
                        return t;
                    } catch (IllegalStateException e) {
                        throw new C0018ad(e);
                    }
                } catch (EOFException e2) {
                    if (!z) {
                        throw new C0018ad(e2);
                    }
                    C0450yf.m9553(c0152fb, zM2005);
                    return null;
                }
            } catch (IOException e3) {
                throw new C0018ad(e3);
            } catch (AssertionError e4) {
                AssertionError assertionError = new AssertionError(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), abd.m2168()), C0453yj.m9832(e4))));
                C0461zs.m11520(assertionError, e4);
                throw assertionError;
            }
        } catch (Throwable th) {
            C0450yf.m9553(c0152fb, zM2005);
            throw th;
        }
    }

    public <T> T m857a(Reader reader, Type type) {
        C0152fb c0152fbM9222 = C0449ye.m9222(this, reader);
        T t = (T) C0446yb.m8441(this, c0152fbM9222, type);
        C0456zb.m10436(t, c0152fbM9222);
        return t;
    }

    public <T> T m858a(String str, Type type) {
        if (str == null) {
            return null;
        }
        return (T) C0450yf.m9344(this, new StringReader(str), type);
    }

    public String m859a(AbstractC0441v abstractC0441v) {
        StringWriter stringWriter = new StringWriter();
        gggy.m4308(this, abstractC0441v, stringWriter);
        return C0456zb.m10416(stringWriter);
    }

    public String m860a(Object obj) {
        return obj == null ? C0452yh.m9734(this, C0458ze.m10823()) : C0452yh.m9751(this, obj, gggy.m4399(obj));
    }

    public String m861a(Object obj, Type type) {
        StringWriter stringWriter = new StringWriter();
        C0456zb.m10279(this, obj, type, stringWriter);
        return C0456zb.m10416(stringWriter);
    }

    public void m862a(AbstractC0441v abstractC0441v, C0155fe c0155fe) {
        boolean zM9112 = C0449ye.m9112(c0155fe);
        C0457zc.m10725(c0155fe, true);
        boolean zM10399 = C0456zb.m10399(c0155fe);
        C0460zg.m11403(c0155fe, C0457zc.m10649(this));
        boolean zM11240 = C0460zg.m11240(c0155fe);
        C0458ze.m10906(c0155fe, abc.m1916(this));
        try {
            try {
                adds.m2870(abstractC0441v, c0155fe);
                C0457zc.m10725(c0155fe, zM9112);
                C0460zg.m11403(c0155fe, zM10399);
                C0458ze.m10906(c0155fe, zM11240);
            } catch (IOException e) {
                throw new C0442w(e);
            } catch (AssertionError e2) {
                AssertionError assertionError = new AssertionError(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), abd.m2168()), C0453yj.m9832(e2))));
                C0461zs.m11520(assertionError, e2);
                throw assertionError;
            }
        } catch (Throwable th) {
            C0457zc.m10725(c0155fe, zM9112);
            C0460zg.m11403(c0155fe, zM10399);
            C0458ze.m10906(c0155fe, zM11240);
            throw th;
        }
    }

    public void m863a(AbstractC0441v abstractC0441v, Appendable appendable) {
        try {
            C0448yd.m9004(this, abstractC0441v, C0449ye.m9166(this, C0457zc.m10747(appendable)));
        } catch (IOException e) {
            throw new C0442w(e);
        }
    }

    public void m864a(Object obj, Type type, C0155fe c0155fe) {
        AbstractC0022ah abstractC0022ahM2165 = abd.m2165(this, C0461zs.m11619(type));
        boolean zM9112 = C0449ye.m9112(c0155fe);
        C0457zc.m10725(c0155fe, true);
        boolean zM10399 = C0456zb.m10399(c0155fe);
        C0460zg.m11403(c0155fe, C0457zc.m10649(this));
        boolean zM11240 = C0460zg.m11240(c0155fe);
        C0458ze.m10906(c0155fe, abc.m1916(this));
        try {
            try {
                C0457zc.m10586(abstractC0022ahM2165, c0155fe, obj);
                C0457zc.m10725(c0155fe, zM9112);
                C0460zg.m11403(c0155fe, zM10399);
                C0458ze.m10906(c0155fe, zM11240);
            } catch (IOException e) {
                throw new C0442w(e);
            } catch (AssertionError e2) {
                AssertionError assertionError = new AssertionError(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), abd.m2168()), C0453yj.m9832(e2))));
                C0461zs.m11520(assertionError, e2);
                throw assertionError;
            }
        } catch (Throwable th) {
            C0457zc.m10725(c0155fe, zM9112);
            C0460zg.m11403(c0155fe, zM10399);
            C0458ze.m10906(c0155fe, zM11240);
            throw th;
        }
    }

    public void m865a(Object obj, Type type, Appendable appendable) {
        try {
            C0447yc.m8726(this, obj, type, C0449ye.m9166(this, C0457zc.m10747(appendable)));
        } catch (IOException e) {
            throw new C0442w(e);
        }
    }

    public <T> AbstractC0022ah<T> m866b(Class<T> cls) {
        return abd.m2165(this, C0461zs.m11643(cls));
    }

    public String toString() {
        return abc.m1925(C0460zg.m11407(abd.m2090(C0460zg.m11407(abd.m2090(C0460zg.m11407(abd.m2164(new StringBuilder(C0455za.m10167()), abc.m1916(this)), C0461zs.m11496()), C0459zf.m11067(this)), C0455za.m10150()), abd.m1987(this)), C0446yb.m8473()));
    }
}
