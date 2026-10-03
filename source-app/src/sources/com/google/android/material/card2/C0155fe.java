package com.google.android.material.card2;

import java.io.Closeable;
import java.io.Flushable;
import java.io.IOException;
import java.io.Writer;

public class C0155fe implements Closeable, Flushable {

    private static final String[] f287eu;

    private static final String[] f288ev = new String[128];

    private boolean f289A;

    private String f292ew;

    private String f293ex;

    private final Writer f294ey;

    private String f295ez;

    private boolean f296u;

    private boolean f297x;

    private int[] f291ei = new int[32];

    private int f290bF = 0;

    static {
        for (int i = 0; i <= 31; i++) {
            abd.m2113()[i] = m3873(adds.m2864(), new Object[]{abd.m2028(i)});
        }
        abd.m2113()[34] = C0456zb.m10346();
        abd.m2113()[92] = C0449ye.m9216();
        abd.m2113()[9] = gggy.m4424();
        abd.m2113()[8] = C0460zg.m11333();
        abd.m2113()[10] = C0461zs.m11507();
        abd.m2113()[13] = C0446yb.m8436();
        abd.m2113()[12] = C0461zs.m11519();
        f287eu = (String[]) C0457zc.m10713(abd.m2113());
        abd.m2033()[60] = C0446yb.m8541();
        abd.m2033()[62] = C0459zf.m11114();
        abd.m2033()[38] = C0461zs.m11516();
        abd.m2033()[61] = C0446yb.m8488();
        abd.m2033()[39] = C0449ye.m9255();
    }

    public C0155fe(Writer writer) {
        C0446yb.m8588(this, 6);
        this.f295ez = C0449ye.m9248();
        this.f289A = true;
        if (writer == null) {
            throw new NullPointerException(C0456zb.m10307());
        }
        this.f294ey = writer;
    }

    private C0155fe m457a(int i, char c) {
        C0459zf.m11129(this);
        C0446yb.m8588(this, i);
        C0452yh.m9703(C0456zb.m10473(this), c);
        return this;
    }

    private C0155fe m458a(int i, int i2, char c) {
        int iM4358 = gggy.m4358(this);
        if (iM4358 != i2 && iM4358 != i) {
            throw new IllegalStateException(C0460zg.m11230());
        }
        if (C0459zf.m11078(this) != null) {
            throw new IllegalStateException(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0457zc.m10613()), C0459zf.m11078(this))));
        }
        this.f290bF = C0452yh.m9679(this) - 1;
        if (iM4358 == i2) {
            abd.m2057(this);
        }
        C0452yh.m9703(C0456zb.m10473(this), c);
        return this;
    }

    private int m459aA() {
        if (C0452yh.m9679(this) == 0) {
            throw new IllegalStateException(abc.m1841());
        }
        return C0445ya.m8248(this)[C0452yh.m9679(this) - 1];
    }

    private void m460aB() {
        if (C0459zf.m11078(this) != null) {
            C0460zg.m11369(this);
            gggy.m4310(this, C0459zf.m11078(this));
            this.f292ew = null;
        }
    }

    private void m461ax() {
        int iM4358 = gggy.m4358(this);
        if (iM4358 == 5) {
            C0452yh.m9703(C0456zb.m10473(this), 44);
        } else if (iM4358 != 3) {
            throw new IllegalStateException(C0460zg.m11230());
        }
        abd.m2057(this);
        abe.m2315(this, 4);
    }

    private void m462ay() {
        switch (gggy.m4358(this)) {
            case 1:
                abe.m2315(this, 2);
                abd.m2057(this);
                return;
            case 2:
                C0453yj.m9938(C0456zb.m10473(this), ',');
                abd.m2057(this);
                return;
            case 3:
            case 5:
            default:
                throw new IllegalStateException(C0460zg.m11230());
            case 4:
                abf.m2625(C0456zb.m10473(this), C0449ye.m9125(this));
                abe.m2315(this, 5);
                return;
            case 6:
                break;
            case 7:
                if (!C0448yd.m9063(this)) {
                    throw new IllegalStateException(C0458ze.m10833());
                }
                break;
        }
        abe.m2315(this, 7);
    }

    private void m463az() {
        if (C0445ya.m8225(this) == null) {
            return;
        }
        C0452yh.m9703(C0456zb.m10473(this), 10);
        int iM9679 = C0452yh.m9679(this);
        for (int i = 1; i < iM9679; i++) {
            abe.m2297(C0456zb.m10473(this), C0445ya.m8225(this));
        }
    }

    private void m464d(int i) {
        if (C0452yh.m9679(this) == C0445ya.m8248(this).length) {
            this.f291ei = C0445ya.m8363(C0445ya.m8248(this), C0452yh.m9679(this) * 2);
        }
        int[] iArrM8248 = C0445ya.m8248(this);
        int iM9679 = C0452yh.m9679(this);
        this.f290bF = iM9679 + 1;
        iArrM8248[iM9679] = i;
    }

    private void m465e(int i) {
        C0445ya.m8248(this)[C0452yh.m9679(this) - 1] = i;
    }

    private void m466j(String str) {
        String strM2274;
        String[] strArrM2033 = C0456zb.m10280(this) ? abd.m2033() : abd.m2113();
        C0452yh.m9703(C0456zb.m10473(this), 34);
        int iM4397 = gggy.m4397(str);
        int i = 0;
        for (int i2 = 0; i2 < iM4397; i2++) {
            char cM8419 = C0446yb.m8419(str, i2);
            if (cM8419 < 128) {
                strM2274 = strArrM2033[cM8419];
                if (strM2274 != null) {
                    if (i < i2) {
                        C0446yb.m8499(C0456zb.m10473(this), str, i, i2 - i);
                    }
                    abe.m2297(C0456zb.m10473(this), strM2274);
                    i = i2 + 1;
                }
            } else {
                if (cM8419 == 8232) {
                    strM2274 = abc.m1795();
                } else if (cM8419 == 8233) {
                    strM2274 = abe.m2274();
                }
                if (i < i2) {
                    C0446yb.m8499(C0456zb.m10473(this), str, i, i2 - i);
                }
                abe.m2297(C0456zb.m10473(this), strM2274);
                i = i2 + 1;
            }
        }
        if (i < iM4397) {
            C0446yb.m8499(C0456zb.m10473(this), str, i, iM4397 - i);
        }
        C0452yh.m9703(C0456zb.m10473(this), 34);
    }

    public static boolean m3859(Object obj) {
        if (C0451yg.m9580() > 0) {
            return ((C0155fe) obj).f297x;
        }
        return false;
    }

    public static int m3860(Object obj) {
        if (C0447yc.m8635() > 0) {
            return ((C0155fe) obj).f290bF;
        }
        return 0;
    }

    public static C0155fe m3861(Object obj, int i, int i2, char c) {
        if (gggy.m4269() <= 0) {
            return ((C0155fe) obj).m458a(i, i2, c);
        }
        return null;
    }

    public static boolean m3862(Object obj) {
        if (C0456zb.m10326() < 0) {
            return ((C0155fe) obj).f296u;
        }
        return false;
    }

    public static String[] m3863() {
        if (C0446yb.m8415() <= 0) {
            return f288ev;
        }
        return null;
    }

    public static void m3864(Object obj, int i) {
        if (C0452yh.m9798() >= 0) {
            ((C0155fe) obj).m465e(i);
        }
    }

    public static int[] m3865(Object obj) {
        if (C0447yc.m8635() > 0) {
            return ((C0155fe) obj).f291ei;
        }
        return null;
    }

    public static void m3866(Object obj, int i) {
        if (C0451yg.m9580() >= 0) {
            ((C0155fe) obj).m464d(i);
        }
    }

    public static void m3867(Object obj) {
        if (C0448yd.m9079() < 0) {
            ((C0155fe) obj).m462ay();
        }
    }

    public static String m3868(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return ((C0155fe) obj).f293ex;
        }
        return null;
    }

    public static String m3869(Object obj) {
        if (C0452yh.m9798() >= 0) {
            return ((C0155fe) obj).f295ez;
        }
        return null;
    }

    public static C0155fe m3870(Object obj, int i, char c) {
        if (C0446yb.m8415() < 0) {
            return ((C0155fe) obj).m457a(i, c);
        }
        return null;
    }

    public static String[] m3871() {
        if (C0453yj.m10013() >= 0) {
            return f287eu;
        }
        return null;
    }

    public static Writer m3872(Object obj) {
        if (C0445ya.m8222() > 0) {
            return ((C0155fe) obj).f294ey;
        }
        return null;
    }

    public static String m3873(Object obj, Object obj2) {
        if (C0448yd.m9079() <= 0) {
            return C0598.m11903(obj, obj2);
        }
        return null;
    }

    public static String m3874(Object obj) {
        if (abe.m2308() < 0) {
            return C0598.m11838(obj);
        }
        return null;
    }

    public static Object m3875(Object obj) {
        if (abe.m2308() < 0) {
            return ((String[]) obj).clone();
        }
        return null;
    }

    public static void m3876(Object obj) {
        if (C0461zs.m11510() <= 0) {
            ((C0155fe) obj).m460aB();
        }
    }

    public static int m3877() {
        if (adds.m2755() > 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static void m3878(Object obj, Object obj2) {
        if (C0445ya.m8222() >= 0) {
            ((C0155fe) obj).m466j((String) obj2);
        }
    }

    public static int m3879(Object obj) {
        if (C0457zc.m10735() < 0) {
            return ((C0155fe) obj).m459aA();
        }
        return 0;
    }

    public static String m3880(Object obj) {
        if (C0446yb.m8415() < 0) {
            return ((C0155fe) obj).f292ew;
        }
        return null;
    }

    public static void m3881(Object obj) {
        if (C0447yc.m8635() > 0) {
            ((C0155fe) obj).m463az();
        }
    }

    public static void m3882(Object obj) {
        if (C0451yg.m9580() > 0) {
            ((C0155fe) obj).m461ax();
        }
    }

    public static boolean m3883(Object obj) {
        if (adds.m2755() > 0) {
            return ((C0155fe) obj).f289A;
        }
        return false;
    }

    public static String[] m3884() {
        if (C0456zb.m10484() < 0) {
            return m3863();
        }
        return null;
    }

    public static Object m3885(Object obj) {
        if (gggy.m4365() > 0) {
            return m3875((String[]) obj);
        }
        return null;
    }

    public static int m3886(Object obj) {
        if (C0453yj.m9966() >= 0) {
            return m3860((C0155fe) obj);
        }
        return 0;
    }

    public static String[] m3887() {
        if (C0457zc.m10718() <= 0) {
            return m3871();
        }
        return null;
    }

    public static void m3888(Object obj, int i) {
        if (abd.m2021() > 0) {
            m3866((C0155fe) obj, i);
        }
    }

    public static String m3889(Object obj) {
        if (C0459zf.m11053() >= 0) {
            return m3868((C0155fe) obj);
        }
        return null;
    }

    public static int m3890(Object obj) {
        if (C0460zg.m11293() >= 0) {
            return m3879((C0155fe) obj);
        }
        return 0;
    }

    public static int[] m3891(Object obj) {
        if (m3877() >= 0) {
            return m3865((C0155fe) obj);
        }
        return null;
    }

    public static String m3892(Object obj) {
        if (abe.m2321() < 0) {
            return m3869((C0155fe) obj);
        }
        return null;
    }

    public static boolean m3893(Object obj) {
        if (C0458ze.m10926() < 0) {
            return m3862((C0155fe) obj);
        }
        return false;
    }

    public static C0155fe m3894(Object obj, int i, int i2, char c) {
        if (C0458ze.m10926() < 0) {
            return m3861((C0155fe) obj, i, i2, c);
        }
        return null;
    }

    public static C0155fe m3895(Object obj, int i, char c) {
        if (C0453yj.m9996() <= 0) {
            return m3870((C0155fe) obj, i, c);
        }
        return null;
    }

    public static void m3896(Object obj) {
        if (abd.m2166() < 0) {
            m3867((C0155fe) obj);
        }
    }

    public static void m3897(Object obj, Object obj2) {
        if (abf.m2500() >= 0) {
            m3878((C0155fe) obj, (String) obj2);
        }
    }

    public static void m3898(Object obj, int i) {
        if (abf.m2500() >= 0) {
            m3864((C0155fe) obj, i);
        }
    }

    public static boolean m3899(Object obj) {
        if (C0448yd.m9074() <= 0) {
            return m3859((C0155fe) obj);
        }
        return false;
    }

    public static Writer m3900(Object obj) {
        if (gggy.m4365() >= 0) {
            return m3872((C0155fe) obj);
        }
        return null;
    }

    public static void m3901(Object obj) {
        if (abd.m2166() < 0) {
            m3882((C0155fe) obj);
        }
    }

    public static String m3902(Object obj) {
        if (gggy.m4365() > 0) {
            return m3880((C0155fe) obj);
        }
        return null;
    }

    public static void m3903(Object obj) {
        if (abd.m2166() <= 0) {
            m3881((C0155fe) obj);
        }
    }

    public static void m3904(Object obj) {
        if (C0453yj.m9966() >= 0) {
            m3876((C0155fe) obj);
        }
    }

    public static boolean m3905(Object obj) {
        if (C0453yj.m10032() >= 0) {
            return m3883((C0155fe) obj);
        }
        return false;
    }

    public C0155fe mo358a(long j) {
        adds.m2811(this);
        C0459zf.m11129(this);
        abe.m2297(C0456zb.m10473(this), C0450yf.m9420(j));
        return this;
    }

    public C0155fe mo359a(Boolean bool) {
        if (bool == null) {
            return C0457zc.m10630(this);
        }
        adds.m2811(this);
        C0459zf.m11129(this);
        abe.m2297(C0456zb.m10473(this), C0453yj.m10033(bool) ? C0456zb.m10298() : C0458ze.m10861());
        return this;
    }

    public C0155fe mo360a(Number number) {
        if (number == null) {
            return C0457zc.m10630(this);
        }
        adds.m2811(this);
        String strM3874 = m3874(number);
        if (!C0448yd.m9063(this) && (C0452yh.m9583(strM3874, C0459zf.m11049()) || C0452yh.m9583(strM3874, C0446yb.m8569()) || C0452yh.m9583(strM3874, abf.m2491()))) {
            throw new IllegalArgumentException(abc.m1925(abd.m2090(C0460zg.m11407(new StringBuilder(), C0460zg.m11298()), number)));
        }
        C0459zf.m11129(this);
        abf.m2625(C0456zb.m10473(this), strM3874);
        return this;
    }

    public final boolean m467aC() {
        return abc.m1888(this);
    }

    public final boolean m468aD() {
        return C0456zb.m10280(this);
    }

    public C0155fe mo361ac() {
        adds.m2811(this);
        return abc.m1936(this, 1, '[');
    }

    public C0155fe mo362ad() {
        adds.m2811(this);
        return abc.m1936(this, 3, '{');
    }

    public C0155fe mo363ae() {
        return C0447yc.m8641(this, 1, 2, ']');
    }

    public C0155fe mo364af() {
        return C0447yc.m8641(this, 3, 5, '}');
    }

    public C0155fe mo366ah() {
        if (C0459zf.m11078(this) == null) {
            C0459zf.m11129(this);
            abe.m2297(C0456zb.m10473(this), C0448yd.m8883());
        } else if (abc.m1888(this)) {
            adds.m2811(this);
            C0459zf.m11129(this);
            abe.m2297(C0456zb.m10473(this), C0448yd.m8883());
        } else {
            this.f292ew = null;
        }
        return this;
    }

    public boolean m469aw() {
        return C0448yd.m9063(this);
    }

    @Override
    public void close() throws IOException {
        C0449ye.m9184(C0456zb.m10473(this));
        int iM9679 = C0452yh.m9679(this);
        if (iM9679 > 1 || (iM9679 == 1 && C0445ya.m8248(this)[iM9679 - 1] != 7)) {
            throw new IOException(C0456zb.m10431());
        }
        this.f290bF = 0;
    }

    public C0155fe mo367d(boolean z) {
        adds.m2811(this);
        C0459zf.m11129(this);
        abe.m2297(C0456zb.m10473(this), z ? C0456zb.m10298() : C0458ze.m10861());
        return this;
    }

    public C0155fe mo368f(String str) {
        if (str == null) {
            throw new NullPointerException(C0447yc.m8804());
        }
        if (C0459zf.m11078(this) != null) {
            throw new IllegalStateException();
        }
        if (C0452yh.m9679(this) == 0) {
            throw new IllegalStateException(abc.m1841());
        }
        this.f292ew = str;
        return this;
    }

    public void flush() {
        if (C0452yh.m9679(this) == 0) {
            throw new IllegalStateException(abc.m1841());
        }
        gggy.m4290(C0456zb.m10473(this));
    }

    public C0155fe mo369g(String str) {
        if (str == null) {
            return C0457zc.m10630(this);
        }
        adds.m2811(this);
        C0459zf.m11129(this);
        gggy.m4310(this, str);
        return this;
    }

    public final void m470g(boolean z) {
        this.f296u = z;
    }

    public final void m471h(boolean z) {
        this.f297x = z;
    }

    public final void m472i(boolean z) {
        this.f289A = z;
    }

    public final void m473k(String str) {
        if (gggy.m4397(str) == 0) {
            this.f293ex = null;
            this.f295ez = C0449ye.m9248();
        } else {
            this.f293ex = str;
            this.f295ez = C0455za.m10252();
        }
    }
}
