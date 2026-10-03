package com.google.android.material.card2;

import java.io.Reader;
import java.util.Iterator;
import java.util.Map;

public final class C0084co extends C0152fb {

    private int[] f134bC;

    private String[] f135bD;

    private Object[] f136bE;

    private int f137bF;

    private static final Reader f133bB = new C0085cp();

    private static final Object f132bA = new Object();

    private String m336J() {
        return abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), adds.m2706()), m3301(this)));
    }

    private Object m337K() {
        return C0461zs.m11614(this)[C0456zb.m10492(this) - 1];
    }

    private Object m338L() {
        Object[] objArrM11614 = C0461zs.m11614(this);
        int iM10492 = C0456zb.m10492(this) - 1;
        this.f137bF = iM10492;
        Object obj = objArrM11614[iM10492];
        C0461zs.m11614(this)[C0456zb.m10492(this)] = null;
        return obj;
    }

    private void m339a(EnumC0154fd enumC0154fd) {
        if (C0460zg.m11368(this) != enumC0154fd) {
            throw new IllegalStateException(abc.m1925(C0460zg.m11407(abd.m2090(C0460zg.m11407(abd.m2090(C0460zg.m11407(new StringBuilder(), C0455za.m10062()), enumC0154fd), C0458ze.m10957()), C0460zg.m11368(this)), C0456zb.m10278(this))));
        }
    }

    private void m340g(Object obj) {
        if (C0456zb.m10492(this) == C0461zs.m11614(this).length) {
            int iM10492 = C0456zb.m10492(this) * 2;
            this.f136bE = adds.m2824(C0461zs.m11614(this), iM10492);
            this.f134bC = C0445ya.m8363(C0456zb.m10423(this), iM10492);
            this.f135bD = (String[]) adds.m2824(C0458ze.m10818(this), iM10492);
        }
        Object[] objArrM11614 = C0461zs.m11614(this);
        int iM10493 = C0456zb.m10492(this);
        this.f137bF = iM10493 + 1;
        objArrM11614[iM10493] = obj;
    }

    public static String m3286(Object obj) {
        if (abf.m2510() < 0) {
            return C0598.m11795(obj);
        }
        return null;
    }

    public static Object m3287(Object obj) {
        if (C0445ya.m8222() > 0) {
            return ((C0084co) obj).m337K();
        }
        return null;
    }

    public static boolean m3288(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return ((C0084co) obj).m455aw();
        }
        return false;
    }

    public static void m3289(Object obj, Object obj2) {
        if (C0445ya.m8222() > 0) {
            ((C0084co) obj).m339a((EnumC0154fd) obj2);
        }
    }

    public static int m3290() {
        if (C0446yb.m8415() < 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static int[] m3291(Object obj) {
        if (C0447yc.m8635() > 0) {
            return ((C0084co) obj).f134bC;
        }
        return null;
    }

    public static boolean m3292(double d) {
        if (C0456zb.m10326() < 0) {
            return C0598.m11889(d);
        }
        return false;
    }

    public static Object m3293() {
        if (abf.m2510() < 0) {
            return f132bA;
        }
        return null;
    }

    public static void m3294(Object obj, Object obj2) {
        if (C0451yg.m9580() >= 0) {
            ((C0084co) obj).m340g(obj2);
        }
    }

    public static Object m3295(Object obj) {
        if (C0452yh.m9798() > 0) {
            return ((C0084co) obj).m338L();
        }
        return null;
    }

    public static Object m3296(Object obj) {
        if (C0449ye.m9220() < 0) {
            return C0598.m11882(obj);
        }
        return null;
    }

    public static Object[] m3297(Object obj) {
        if (C0448yd.m9079() < 0) {
            return ((C0084co) obj).f136bE;
        }
        return null;
    }

    public static int m3298(Object obj) {
        if (C0448yd.m9079() < 0) {
            return ((C0084co) obj).f137bF;
        }
        return 0;
    }

    public static String m3299(Object obj) {
        if (C0459zf.m11062() > 0) {
            return ((C0084co) obj).m336J();
        }
        return null;
    }

    public static boolean m3300(Object obj) {
        if (C0450yf.m9352() < 0) {
            return C0598.m11810(obj);
        }
        return false;
    }

    public static String m3301(Object obj) {
        if (C0445ya.m8222() > 0) {
            return C0598.m11793(obj);
        }
        return null;
    }

    public static String[] m3302(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return ((C0084co) obj).f135bD;
        }
        return null;
    }

    public static EnumC0154fd m3303() {
        if (abc.m1845() <= 0) {
            return C0598.m11807();
        }
        return null;
    }

    public static void m3304(Object obj, Object obj2) {
        if (C0447yc.m8786() > 0) {
            m3289((C0084co) obj, (EnumC0154fd) obj2);
        }
    }

    public static String m3305(Object obj) {
        if (m3290() >= 0) {
            return m3299((C0084co) obj);
        }
        return null;
    }

    public static boolean m3306(Object obj) {
        if (C0453yj.m9996() < 0) {
            return m3288((C0084co) obj);
        }
        return false;
    }

    public static Object m3307(Object obj) {
        if (m3290() > 0) {
            return m3295((C0084co) obj);
        }
        return null;
    }

    public static Object m3308() {
        if (abf.m2500() > 0) {
            return m3293();
        }
        return null;
    }

    public static int m3309(Object obj) {
        if (C0460zg.m11293() > 0) {
            return m3298((C0084co) obj);
        }
        return 0;
    }

    public static Object[] m3310(Object obj) {
        if (C0453yj.m9945() < 0) {
            return m3297((C0084co) obj);
        }
        return null;
    }

    public static int[] m3311(Object obj) {
        if (C0453yj.m9966() > 0) {
            return m3291((C0084co) obj);
        }
        return null;
    }

    public static String[] m3312(Object obj) {
        if (C0445ya.m8330() > 0) {
            return m3302((C0084co) obj);
        }
        return null;
    }

    public static Object m3313(Object obj) {
        if (C0448yd.m9074() < 0) {
            return m3287((C0084co) obj);
        }
        return null;
    }

    public static void m3314(Object obj, Object obj2) {
        if (C0456zb.m10484() <= 0) {
            m3294((C0084co) obj, obj2);
        }
    }

    @Override
    public void mo341M() {
        abe.m2350(this, C0453yj.m9984());
        C0446yb.m8518(this, abe.m2368((C0437s) C0448yd.m9019(this)));
        C0456zb.m10423(this)[C0456zb.m10492(this) - 1] = 0;
    }

    @Override
    public void mo342N() {
        abe.m2350(this, C0456zb.m10404());
        C0446yb.m8518(this, C0453yj.m9939(gggy.m4495((C0444y) C0448yd.m9019(this))));
    }

    @Override
    public void mo343O() {
        abe.m2350(this, gggy.m4343());
        adds.m2801(this);
        adds.m2801(this);
        if (C0456zb.m10492(this) > 0) {
            int[] iArrM10423 = C0456zb.m10423(this);
            int iM10492 = C0456zb.m10492(this) - 1;
            iArrM10423[iM10492] = iArrM10423[iM10492] + 1;
        }
    }

    @Override
    public void mo344P() {
        abe.m2350(this, C0455za.m10079());
        adds.m2801(this);
        adds.m2801(this);
        if (C0456zb.m10492(this) > 0) {
            int[] iArrM10423 = C0456zb.m10423(this);
            int iM10492 = C0456zb.m10492(this) - 1;
            iArrM10423[iM10492] = iArrM10423[iM10492] + 1;
        }
    }

    @Override
    public String mo345Q() {
        StringBuilder sbM2346 = abe.m2346(new StringBuilder(), '$');
        int i = 0;
        while (i < C0456zb.m10492(this)) {
            if (C0461zs.m11614(this)[i] instanceof C0437s) {
                i++;
                if (C0461zs.m11614(this)[i] instanceof Iterator) {
                    abe.m2346(adds.m2680(abe.m2346(sbM2346, '['), C0456zb.m10423(this)[i]), ']');
                }
            } else if (C0461zs.m11614(this)[i] instanceof C0444y) {
                i++;
                if (C0461zs.m11614(this)[i] instanceof Iterator) {
                    abe.m2346(sbM2346, '.');
                    if (C0458ze.m10818(this)[i] != null) {
                        C0460zg.m11407(sbM2346, C0458ze.m10818(this)[i]);
                    }
                }
            }
            i++;
        }
        return abc.m1925(sbM2346);
    }

    @Override
    public boolean mo346R() {
        abe.m2350(this, C0450yf.m9431());
        boolean zM10717 = C0457zc.m10717((C0015aa) adds.m2801(this));
        if (C0456zb.m10492(this) > 0) {
            int[] iArrM10423 = C0456zb.m10423(this);
            int iM10492 = C0456zb.m10492(this) - 1;
            iArrM10423[iM10492] = iArrM10423[iM10492] + 1;
        }
        return zM10717;
    }

    @Override
    public double mo347S() {
        EnumC0154fd enumC0154fdM11368 = C0460zg.m11368(this);
        if (enumC0154fdM11368 != adds.m2664() && enumC0154fdM11368 != abc.m1941()) {
            throw new IllegalStateException(abc.m1925(C0460zg.m11407(abd.m2090(C0460zg.m11407(abd.m2090(C0460zg.m11407(new StringBuilder(), C0455za.m10062()), adds.m2664()), C0458ze.m10957()), enumC0154fdM11368), C0456zb.m10278(this))));
        }
        double dM2208 = abe.m2208((C0015aa) C0448yd.m9019(this));
        if (!gggy.m4478(this) && (abe.m2262(dM2208) || m3292(dM2208))) {
            throw new NumberFormatException(abc.m1925(adds.m2814(C0460zg.m11407(new StringBuilder(), C0461zs.m11443()), dM2208)));
        }
        adds.m2801(this);
        if (C0456zb.m10492(this) > 0) {
            int[] iArrM10423 = C0456zb.m10423(this);
            int iM10492 = C0456zb.m10492(this) - 1;
            iArrM10423[iM10492] = iArrM10423[iM10492] + 1;
        }
        return dM2208;
    }

    @Override
    public int mo348T() {
        EnumC0154fd enumC0154fdM11368 = C0460zg.m11368(this);
        if (enumC0154fdM11368 != adds.m2664() && enumC0154fdM11368 != abc.m1941()) {
            throw new IllegalStateException(abc.m1925(C0460zg.m11407(abd.m2090(C0460zg.m11407(abd.m2090(C0460zg.m11407(new StringBuilder(), C0455za.m10062()), adds.m2664()), C0458ze.m10957()), enumC0154fdM11368), C0456zb.m10278(this))));
        }
        int iM2230 = abe.m2230((C0015aa) C0448yd.m9019(this));
        adds.m2801(this);
        if (C0456zb.m10492(this) > 0) {
            int[] iArrM10423 = C0456zb.m10423(this);
            int iM10492 = C0456zb.m10492(this) - 1;
            iArrM10423[iM10492] = iArrM10423[iM10492] + 1;
        }
        return iM2230;
    }

    @Override
    public long mo349U() {
        EnumC0154fd enumC0154fdM11368 = C0460zg.m11368(this);
        if (enumC0154fdM11368 != adds.m2664() && enumC0154fdM11368 != abc.m1941()) {
            throw new IllegalStateException(abc.m1925(C0460zg.m11407(abd.m2090(C0460zg.m11407(abd.m2090(C0460zg.m11407(new StringBuilder(), C0455za.m10062()), adds.m2664()), C0458ze.m10957()), enumC0154fdM11368), C0456zb.m10278(this))));
        }
        long jM1859 = abc.m1859((C0015aa) C0448yd.m9019(this));
        adds.m2801(this);
        if (C0456zb.m10492(this) > 0) {
            int[] iArrM10423 = C0456zb.m10423(this);
            int iM10492 = C0456zb.m10492(this) - 1;
            iArrM10423[iM10492] = iArrM10423[iM10492] + 1;
        }
        return jM1859;
    }

    @Override
    public String mo350V() {
        abe.m2350(this, C0453yj.m9995());
        Map.Entry entry = (Map.Entry) m3296((Iterator) C0448yd.m9019(this));
        String str = (String) abe.m2338(entry);
        C0458ze.m10818(this)[C0456zb.m10492(this) - 1] = str;
        C0446yb.m8518(this, C0455za.m10227(entry));
        return str;
    }

    @Override
    public void mo351W() {
        abe.m2350(this, C0452yh.m9757());
        adds.m2801(this);
        if (C0456zb.m10492(this) > 0) {
            int[] iArrM10423 = C0456zb.m10423(this);
            int iM10492 = C0456zb.m10492(this) - 1;
            iArrM10423[iM10492] = iArrM10423[iM10492] + 1;
        }
    }

    @Override
    public String mo352X() {
        EnumC0154fd enumC0154fdM11368 = C0460zg.m11368(this);
        if (enumC0154fdM11368 != abc.m1941() && enumC0154fdM11368 != adds.m2664()) {
            throw new IllegalStateException(abc.m1925(C0460zg.m11407(abd.m2090(C0460zg.m11407(abd.m2090(C0460zg.m11407(new StringBuilder(), C0455za.m10062()), abc.m1941()), C0458ze.m10957()), enumC0154fdM11368), C0456zb.m10278(this))));
        }
        String strM2442 = abf.m2442((C0015aa) adds.m2801(this));
        if (C0456zb.m10492(this) > 0) {
            int[] iArrM10423 = C0456zb.m10423(this);
            int iM10492 = C0456zb.m10492(this) - 1;
            iArrM10423[iM10492] = iArrM10423[iM10492] + 1;
        }
        return strM2442;
    }

    @Override
    public EnumC0154fd mo353Y() {
        if (C0456zb.m10492(this) == 0) {
            return m3303();
        }
        Object objM9019 = C0448yd.m9019(this);
        if (objM9019 instanceof Iterator) {
            boolean z = C0461zs.m11614(this)[C0456zb.m10492(this) - 2] instanceof C0444y;
            Iterator it = (Iterator) objM9019;
            if (!C0455za.m10104(it)) {
                return z ? C0455za.m10079() : gggy.m4343();
            }
            if (z) {
                return C0453yj.m9995();
            }
            C0446yb.m8518(this, m3296(it));
            return C0460zg.m11368(this);
        }
        if (objM9019 instanceof C0444y) {
            return C0456zb.m10404();
        }
        if (objM9019 instanceof C0437s) {
            return C0453yj.m9984();
        }
        if (!(objM9019 instanceof C0015aa)) {
            if (objM9019 instanceof C0443x) {
                return C0452yh.m9757();
            }
            if (objM9019 == C0449ye.m9122()) {
                throw new IllegalStateException(C0452yh.m9822());
            }
            throw new AssertionError();
        }
        C0015aa c0015aa = (C0015aa) objM9019;
        if (C0459zf.m11093(c0015aa)) {
            return abc.m1941();
        }
        if (m3300(c0015aa)) {
            return C0450yf.m9431();
        }
        if (adds.m2714(c0015aa)) {
            return adds.m2664();
        }
        throw new AssertionError();
    }

    public void m354Z() {
        abe.m2350(this, C0453yj.m9995());
        Map.Entry entry = (Map.Entry) m3296((Iterator) C0448yd.m9019(this));
        C0446yb.m8518(this, C0455za.m10227(entry));
        C0446yb.m8518(this, new C0015aa((String) abe.m2338(entry)));
    }

    @Override
    public void mo355aa() {
        if (C0460zg.m11368(this) == C0453yj.m9995()) {
            m3286(this);
            C0458ze.m10818(this)[C0456zb.m10492(this) - 2] = C0448yd.m8883();
        } else {
            adds.m2801(this);
            if (C0456zb.m10492(this) > 0) {
                C0458ze.m10818(this)[C0456zb.m10492(this) - 1] = C0448yd.m8883();
            }
        }
        if (C0456zb.m10492(this) > 0) {
            int[] iArrM10423 = C0456zb.m10423(this);
            int iM10492 = C0456zb.m10492(this) - 1;
            iArrM10423[iM10492] = iArrM10423[iM10492] + 1;
        }
    }

    @Override
    public void close() {
        this.f136bE = new Object[]{C0449ye.m9122()};
        this.f137bF = 1;
    }

    @Override
    public boolean hasNext() {
        EnumC0154fd enumC0154fdM11368 = C0460zg.m11368(this);
        return (enumC0154fdM11368 == C0455za.m10079() || enumC0154fdM11368 == gggy.m4343()) ? false : true;
    }

    @Override
    public String toString() {
        return C0458ze.m10951(gggy.m4399(this));
    }
}
