package com.google.android.material.card2;

import java.io.IOException;
import java.io.Writer;
import java.util.ArrayList;
import java.util.List;

public final class C0086cq extends C0155fe {

    private String f140bI;

    private AbstractC0441v f141bJ;

    private final List<AbstractC0441v> f142bK;

    private static final Writer f139bH = new C0087cr();

    private static final C0015aa f138bG = new C0015aa(C0447yc.m8663());

    public C0086cq() {
        super(adds.m2663());
        this.f142bK = new ArrayList();
        this.f141bJ = C0458ze.m10823();
    }

    private AbstractC0441v m356ab() {
        return (AbstractC0441v) gggy.m4400(C0446yb.m8449(this), m3322(C0446yb.m8449(this)) - 1);
    }

    private void m357c(AbstractC0441v abstractC0441v) {
        if (C0449ye.m9292(this) != null) {
            if (!abd.m1998(abstractC0441v) || C0445ya.m8389(this)) {
                abf.m2652((C0444y) C0457zc.m10646(this), C0449ye.m9292(this), abstractC0441v);
            }
            this.f140bI = null;
            return;
        }
        if (C0452yh.m9618(C0446yb.m8449(this))) {
            this.f141bJ = abstractC0441v;
            return;
        }
        AbstractC0441v abstractC0441vM10646 = C0457zc.m10646(this);
        if (!(abstractC0441vM10646 instanceof C0437s)) {
            throw new IllegalStateException();
        }
        C0458ze.m10960((C0437s) abstractC0441vM10646, abstractC0441v);
    }

    public static AbstractC0441v m3315(Object obj) {
        if (C0461zs.m11510() < 0) {
            return ((C0086cq) obj).f141bJ;
        }
        return null;
    }

    public static AbstractC0441v m3316(Object obj) {
        if (C0446yb.m8415() <= 0) {
            return ((C0086cq) obj).m356ab();
        }
        return null;
    }

    public static Writer m3317() {
        if (C0449ye.m9220() <= 0) {
            return f139bH;
        }
        return null;
    }

    public static String m3318(Object obj) {
        if (gggy.m4269() < 0) {
            return ((C0086cq) obj).f140bI;
        }
        return null;
    }

    public static boolean m3319(Object obj) {
        if (abd.m2162() > 0) {
            return ((C0086cq) obj).m467aC();
        }
        return false;
    }

    public static boolean m3320(double d) {
        if (C0461zs.m11510() < 0) {
            return C0598.m11889(d);
        }
        return false;
    }

    public static C0015aa m3321() {
        if (adds.m2755() >= 0) {
            return f138bG;
        }
        return null;
    }

    public static int m3322(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return C0598.m11824(obj);
        }
        return 0;
    }

    public static List m3323(Object obj) {
        if (gggy.m4269() <= 0) {
            return ((C0086cq) obj).f142bK;
        }
        return null;
    }

    public static void m3324(Object obj, Object obj2) {
        if (C0447yc.m8635() >= 0) {
            ((C0086cq) obj).m357c((AbstractC0441v) obj2);
        }
    }

    public static boolean m3325(Object obj) {
        if (C0445ya.m8222() > 0) {
            return ((C0086cq) obj).m469aw();
        }
        return false;
    }

    public static int m3326() {
        if (adds.m2755() > 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static String m3327(Object obj) {
        if (m3326() > 0) {
            return m3318((C0086cq) obj);
        }
        return null;
    }

    public static boolean m3328(Object obj) {
        if (gggy.m4365() > 0) {
            return m3319((C0086cq) obj);
        }
        return false;
    }

    public static void m3329(Object obj, Object obj2) {
        if (C0445ya.m8330() >= 0) {
            m3324((C0086cq) obj, (AbstractC0441v) obj2);
        }
    }

    public static C0015aa m3330() {
        if (C0456zb.m10484() <= 0) {
            return m3321();
        }
        return null;
    }

    public static boolean m3331(Object obj) {
        if (C0453yj.m9966() > 0) {
            return m3325((C0086cq) obj);
        }
        return false;
    }

    public static AbstractC0441v m3332(Object obj) {
        if (C0453yj.m9996() <= 0) {
            return m3315((C0086cq) obj);
        }
        return null;
    }

    public static Writer m3333() {
        if (C0445ya.m8330() > 0) {
            return m3317();
        }
        return null;
    }

    public static List m3334(Object obj) {
        if (abf.m2500() >= 0) {
            return m3323((C0086cq) obj);
        }
        return null;
    }

    public static AbstractC0441v m3335(Object obj) {
        if (C0458ze.m10926() < 0) {
            return m3316((C0086cq) obj);
        }
        return null;
    }

    @Override
    public C0155fe mo358a(long j) {
        C0461zs.m11600(this, new C0015aa(C0456zb.m10500(j)));
        return this;
    }

    @Override
    public C0155fe mo359a(Boolean bool) {
        if (bool == null) {
            return C0446yb.m8494(this);
        }
        C0461zs.m11600(this, new C0015aa(bool));
        return this;
    }

    @Override
    public C0155fe mo360a(Number number) {
        if (number == null) {
            return C0446yb.m8494(this);
        }
        if (!abf.m2568(this)) {
            double dM9008 = C0448yd.m9008(number);
            if (abe.m2262(dM9008) || m3320(dM9008)) {
                throw new IllegalArgumentException(abc.m1925(abd.m2090(C0460zg.m11407(new StringBuilder(), C0461zs.m11443()), number)));
            }
        }
        C0461zs.m11600(this, new C0015aa(number));
        return this;
    }

    @Override
    public C0155fe mo361ac() {
        C0437s c0437s = new C0437s();
        C0461zs.m11600(this, c0437s);
        C0460zg.m11251(C0446yb.m8449(this), c0437s);
        return this;
    }

    @Override
    public C0155fe mo362ad() {
        C0444y c0444y = new C0444y();
        C0461zs.m11600(this, c0444y);
        C0460zg.m11251(C0446yb.m8449(this), c0444y);
        return this;
    }

    @Override
    public C0155fe mo363ae() {
        if (C0452yh.m9618(C0446yb.m8449(this)) || C0449ye.m9292(this) != null) {
            throw new IllegalStateException();
        }
        if (!(C0457zc.m10646(this) instanceof C0437s)) {
            throw new IllegalStateException();
        }
        abc.m1794(C0446yb.m8449(this), m3322(C0446yb.m8449(this)) - 1);
        return this;
    }

    @Override
    public C0155fe mo364af() {
        if (C0452yh.m9618(C0446yb.m8449(this)) || C0449ye.m9292(this) != null) {
            throw new IllegalStateException();
        }
        if (!(C0457zc.m10646(this) instanceof C0444y)) {
            throw new IllegalStateException();
        }
        abc.m1794(C0446yb.m8449(this), m3322(C0446yb.m8449(this)) - 1);
        return this;
    }

    public AbstractC0441v m365ag() {
        if (C0452yh.m9618(C0446yb.m8449(this))) {
            return C0456zb.m10342(this);
        }
        throw new IllegalStateException(abc.m1925(abd.m2090(C0460zg.m11407(new StringBuilder(), C0459zf.m11120()), C0446yb.m8449(this))));
    }

    @Override
    public C0155fe mo366ah() {
        C0461zs.m11600(this, C0458ze.m10823());
        return this;
    }

    @Override
    public void close() throws IOException {
        if (!C0452yh.m9618(C0446yb.m8449(this))) {
            throw new IOException(C0456zb.m10431());
        }
        C0460zg.m11251(C0446yb.m8449(this), C0448yd.m9092());
    }

    @Override
    public C0155fe mo367d(boolean z) {
        C0461zs.m11600(this, new C0015aa(C0450yf.m9568(z)));
        return this;
    }

    @Override
    public C0155fe mo368f(String str) {
        if (str == null) {
            throw new NullPointerException(C0447yc.m8804());
        }
        if (C0452yh.m9618(C0446yb.m8449(this)) || C0449ye.m9292(this) != null) {
            throw new IllegalStateException();
        }
        if (!(C0457zc.m10646(this) instanceof C0444y)) {
            throw new IllegalStateException();
        }
        this.f140bI = str;
        return this;
    }

    @Override
    public void flush() {
    }

    @Override
    public C0155fe mo369g(String str) {
        if (str == null) {
            return C0446yb.m8494(this);
        }
        C0461zs.m11600(this, new C0015aa(str));
        return this;
    }
}
