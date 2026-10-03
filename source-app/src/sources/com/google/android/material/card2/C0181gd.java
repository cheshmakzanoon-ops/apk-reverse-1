package com.google.android.material.card2;

import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import java.util.HashSet;

class C0181gd extends BitmapDrawable {

    C0182ge f365fO;

    String f366fP;

    public C0181gd(String str, Resources resources, Bitmap bitmap) {
        this(str, resources, bitmap, new C0182ge(null));
    }

    private C0181gd(String str, Resources resources, Bitmap bitmap, C0182ge c0182ge) {
        super(resources, bitmap);
        this.f366fP = str;
        this.f365fO = c0182ge;
        C0450yf.m9380(m4236(), bitmap);
        m4240(m4224(), str);
        m4222(m4235(), str, this);
        C0182ge c0182geM4225 = m4225(this);
        c0182geM4225.f367fQ = m4244(c0182geM4225) + 1;
    }

    public static boolean m4219(Object obj) {
        if (C0457zc.m10735() <= 0) {
            return ((C0182ge) obj).f368fR;
        }
        return false;
    }

    public static Object m4220(Object obj, Object obj2) {
        if (gggy.m4269() <= 0) {
            return m4258(obj, obj2);
        }
        return null;
    }

    public static Bitmap m4221(Object obj) {
        if (C0448yd.m9079() <= 0) {
            return m4255(obj);
        }
        return null;
    }

    public static Object m4222(Object obj, Object obj2, Object obj3) {
        if (C0457zc.m10735() < 0) {
            return m4252(obj, obj2, obj3);
        }
        return null;
    }

    public static Object m4223(Object obj, Object obj2) {
        if (C0446yb.m8415() < 0) {
            return ((C0168fr) obj).m495i(obj2);
        }
        return null;
    }

    public static C0168fr m4224() {
        if (abf.m2510() < 0) {
            return m4256();
        }
        return null;
    }

    public static C0182ge m4225(Object obj) {
        if (C0457zc.m10735() <= 0) {
            return m4250(obj);
        }
        return null;
    }

    public static void m4226(Object obj, Object obj2) {
        if (C0449ye.m9220() < 0) {
            m4249(obj, obj2);
        }
    }

    public static boolean m4227(Object obj) {
        if (C0453yj.m10013() > 0) {
            return m4248(obj);
        }
        return false;
    }

    public static int m4228(Object obj) {
        if (abd.m2162() > 0) {
            return ((C0182ge) obj).f367fQ;
        }
        return 0;
    }

    public static Object m4229(Object obj, Object obj2, Object obj3) {
        if (abd.m2162() > 0) {
            return ((C0163fm) obj).put(obj2, obj3);
        }
        return null;
    }

    public static String m4230(Object obj) {
        if (C0456zb.m10326() < 0) {
            return ((C0181gd) obj).f366fP;
        }
        return null;
    }

    public static HashSet m4231() {
        if (C0446yb.m8415() < 0) {
            return abd.m2155();
        }
        return null;
    }

    public static C0168fr m4232() {
        if (C0448yd.m9079() <= 0) {
            return C0459zf.m11130();
        }
        return null;
    }

    public static Bitmap m4233(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return ((C0181gd) obj).getBitmap();
        }
        return null;
    }

    public static C0163fm m4234() {
        if (C0459zf.m11062() > 0) {
            return C0459zf.m11117();
        }
        return null;
    }

    public static C0163fm m4235() {
        if (gggy.m4269() < 0) {
            return m4247();
        }
        return null;
    }

    public static HashSet m4236() {
        if (abc.m1845() < 0) {
            return m4254();
        }
        return null;
    }

    public static void m4237(Object obj, Object obj2) {
        if (C0458ze.m10932() > 0) {
            C0174fx.m505a((String) obj, (Object[]) obj2);
        }
    }

    public static C0182ge m4238(Object obj) {
        if (adds.m2755() > 0) {
            return ((C0181gd) obj).f365fO;
        }
        return null;
    }

    public static Object m4239(Object obj, Object obj2, Object obj3) {
        if (C0449ye.m9220() < 0) {
            return m4251(obj, obj2, obj3);
        }
        return null;
    }

    public static Object m4240(Object obj, Object obj2) {
        if (abd.m2162() > 0) {
            return m4253(obj, obj2);
        }
        return null;
    }

    public static boolean m4241(Object obj, Object obj2) {
        if (C0448yd.m9079() <= 0) {
            return C0598.m11874(obj, obj2);
        }
        return false;
    }

    public static Object m4242(Object obj, Object obj2) {
        if (C0461zs.m11510() <= 0) {
            return ((C0163fm) obj).remove(obj2);
        }
        return null;
    }

    public static String m4243(Object obj) {
        if (C0461zs.m11510() < 0) {
            return m4257(obj);
        }
        return null;
    }

    public static int m4244(Object obj) {
        if (C0450yf.m9352() < 0) {
            return m4246(obj);
        }
        return 0;
    }

    public static Object m4245(Object obj, Object obj2, Object obj3) {
        if (abd.m2162() > 0) {
            return ((C0168fr) obj).m494c(obj2, obj3);
        }
        return null;
    }

    public static int m4246(Object obj) {
        if (abf.m2500() > 0) {
            return m4228((C0182ge) obj);
        }
        return 0;
    }

    public static C0163fm m4247() {
        if (C0460zg.m11293() > 0) {
            return m4234();
        }
        return null;
    }

    public static boolean m4248(Object obj) {
        if (C0457zc.m10718() <= 0) {
            return m4219((C0182ge) obj);
        }
        return false;
    }

    public static void m4249(Object obj, Object obj2) {
        if (abd.m2021() >= 0) {
            m4237((String) obj, (Object[]) obj2);
        }
    }

    public static C0182ge m4250(Object obj) {
        if (abd.m2021() >= 0) {
            return m4238((C0181gd) obj);
        }
        return null;
    }

    public static Object m4251(Object obj, Object obj2, Object obj3) {
        if (C0460zg.m11293() > 0) {
            return m4245((C0168fr) obj, obj2, obj3);
        }
        return null;
    }

    public static Object m4252(Object obj, Object obj2, Object obj3) {
        if (C0453yj.m9945() <= 0) {
            return m4229((C0163fm) obj, obj2, obj3);
        }
        return null;
    }

    public static Object m4253(Object obj, Object obj2) {
        if (abf.m2500() >= 0) {
            return m4223((C0168fr) obj, obj2);
        }
        return null;
    }

    public static HashSet m4254() {
        if (C0453yj.m10032() >= 0) {
            return m4231();
        }
        return null;
    }

    public static Bitmap m4255(Object obj) {
        if (gggy.m4365() > 0) {
            return m4233((C0181gd) obj);
        }
        return null;
    }

    public static C0168fr m4256() {
        if (abd.m2166() < 0) {
            return m4232();
        }
        return null;
    }

    public static String m4257(Object obj) {
        if (C0447yc.m8786() >= 0) {
            return m4230((C0181gd) obj);
        }
        return null;
    }

    public static Object m4258(Object obj, Object obj2) {
        if (gggy.m4365() >= 0) {
            return m4242((C0163fm) obj, obj2);
        }
        return null;
    }

    public C0181gd m521a(Resources resources) {
        return new C0181gd(m4243(this), resources, m4221(this), m4225(this));
    }

    public void m522aL() {
        m4226(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0446yb.m8431()), m4243(this))), new Object[0]);
        m4225(this).f368fR = true;
        m4220(m4235(), m4243(this));
        m4241(m4236(), m4221(this));
    }

    protected void finalize() throws Throwable {
        super.finalize();
        C0182ge c0182geM4225 = m4225(this);
        c0182geM4225.f367fQ = m4244(c0182geM4225) - 1;
        if (m4244(m4225(this)) == 0) {
            if (!m4227(m4225(this))) {
                m4239(m4224(), m4243(this), m4221(this));
            }
            m4241(m4236(), m4221(this));
            m4220(m4235(), m4243(this));
            m4226(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), adds.m2763()), m4243(this))), new Object[0]);
        }
    }
}
