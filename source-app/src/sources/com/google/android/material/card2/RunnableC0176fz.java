package com.google.android.material.card2;

import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.drawable.Drawable;
import android.os.Looper;
import android.widget.ImageView;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.Iterator;

final class RunnableC0176fz implements Runnable {

    static final boolean f354fD;

    final AbstractC0179gb f355fE;

    final String f356fF;

    final Drawable f357fG;

    final InterfaceC0173fw f358fH;

    final ImageView f359fI;

    final ArrayList f360fJ;

    static {
        f354fD = !C0460zg.m11342(C0174fx.class);
    }

    RunnableC0176fz(AbstractC0179gb abstractC0179gb, String str, Drawable drawable, InterfaceC0173fw interfaceC0173fw, ImageView imageView, ArrayList arrayList) {
        this.f355fE = abstractC0179gb;
        this.f356fF = str;
        this.f357fG = drawable;
        this.f358fH = interfaceC0173fw;
        this.f359fI = imageView;
        this.f360fJ = arrayList;
    }

    public static boolean m4155() {
        if (C0445ya.m8222() >= 0) {
            return f354fD;
        }
        return false;
    }

    public static void m4156(Object obj, Object obj2) {
        if (C0453yj.m10013() > 0) {
            C0174fx.m505a((String) obj, (Object[]) obj2);
        }
    }

    public static int m4157() {
        if (adds.m2755() >= 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static AbstractC0179gb m4158(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return m4199(obj);
        }
        return null;
    }

    public static Bitmap m4159(Object obj) {
        if (C0447yc.m8635() > 0) {
            return m4200(obj);
        }
        return null;
    }

    public static Object m4160(Object obj, Object obj2, Object obj3) {
        if (C0451yg.m9580() > 0) {
            return ((C0163fm) obj).put(obj2, obj3);
        }
        return null;
    }

    public static void m4161(Object obj, Object obj2) {
        if (C0447yc.m8635() >= 0) {
            m4188(obj, obj2);
        }
    }

    public static ArrayList m4162(Object obj) {
        if (C0448yd.m9079() < 0) {
            return ((RunnableC0176fz) obj).f360fJ;
        }
        return null;
    }

    public static ImageView m4163(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return m4191(obj);
        }
        return null;
    }

    public static InterfaceC0173fw m4164(Object obj) {
        if (C0461zs.m11510() < 0) {
            return m4196(obj);
        }
        return null;
    }

    public static C0163fm m4165() {
        if (C0461zs.m11510() <= 0) {
            return m4190();
        }
        return null;
    }

    public static String m4166(Object obj) {
        if (C0451yg.m9580() > 0) {
            return ((RunnableC0176fz) obj).f356fF;
        }
        return null;
    }

    public static Hashtable m4167() {
        if (C0459zf.m11062() > 0) {
            return m4187();
        }
        return null;
    }

    public static Object m4168(Object obj, Object obj2, Object obj3) {
        if (C0448yd.m9079() <= 0) {
            return m4189(obj, obj2, obj3);
        }
        return null;
    }

    public static ImageView m4169(Object obj) {
        if (C0451yg.m9580() > 0) {
            return ((RunnableC0176fz) obj).f359fI;
        }
        return null;
    }

    public static Hashtable m4170() {
        if (C0458ze.m10932() > 0) {
            return C0450yf.m9459();
        }
        return null;
    }

    public static String m4171(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return m4198(obj);
        }
        return null;
    }

    public static boolean m4172() {
        if (abe.m2308() <= 0) {
            return m4194();
        }
        return false;
    }

    public static Resources m4173() {
        if (adds.m2755() >= 0) {
            return m4192();
        }
        return null;
    }

    public static Object m4174(Object obj) {
        if (C0459zf.m11062() > 0) {
            return C0598.m11882(obj);
        }
        return null;
    }

    public static Bitmap m4175(Object obj) {
        if (abe.m2308() < 0) {
            return ((AbstractC0179gb) obj).f364fN;
        }
        return null;
    }

    public static Drawable m4176(Object obj) {
        if (C0452yh.m9798() >= 0) {
            return m4197(obj);
        }
        return null;
    }

    public static C0163fm m4177() {
        if (C0449ye.m9220() < 0) {
            return C0459zf.m11117();
        }
        return null;
    }

    public static Looper m4178() {
        if (C0453yj.m10013() > 0) {
            return C0598.m11847();
        }
        return null;
    }

    public static Iterator m4179(Object obj) {
        if (C0458ze.m10932() > 0) {
            return C0598.m11895(obj);
        }
        return null;
    }

    public static Hashtable m4180() {
        if (abf.m2510() <= 0) {
            return C0459zf.m11029();
        }
        return null;
    }

    public static Drawable m4181(Object obj) {
        if (abc.m1845() < 0) {
            return ((RunnableC0176fz) obj).f357fG;
        }
        return null;
    }

    public static Hashtable m4182() {
        if (C0461zs.m11510() <= 0) {
            return m4193();
        }
        return null;
    }

    public static AbstractC0179gb m4183(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return ((RunnableC0176fz) obj).f355fE;
        }
        return null;
    }

    public static Resources m4184() {
        if (C0447yc.m8635() >= 0) {
            return C0174fx.f332fh;
        }
        return null;
    }

    public static InterfaceC0173fw m4185(Object obj) {
        if (C0448yd.m9079() < 0) {
            return ((RunnableC0176fz) obj).f358fH;
        }
        return null;
    }

    public static ArrayList m4186(Object obj) {
        if (abe.m2308() < 0) {
            return m4195(obj);
        }
        return null;
    }

    public static Hashtable m4187() {
        if (gggy.m4365() >= 0) {
            return m4170();
        }
        return null;
    }

    public static void m4188(Object obj, Object obj2) {
        if (C0457zc.m10555() >= 0) {
            m4156((String) obj, (Object[]) obj2);
        }
    }

    public static Object m4189(Object obj, Object obj2, Object obj3) {
        if (C0460zg.m11293() >= 0) {
            return m4160((C0163fm) obj, obj2, obj3);
        }
        return null;
    }

    public static C0163fm m4190() {
        if (C0453yj.m9945() < 0) {
            return m4177();
        }
        return null;
    }

    public static ImageView m4191(Object obj) {
        if (C0453yj.m10032() >= 0) {
            return m4169((RunnableC0176fz) obj);
        }
        return null;
    }

    public static Resources m4192() {
        if (C0445ya.m8330() >= 0) {
            return m4184();
        }
        return null;
    }

    public static Hashtable m4193() {
        if (abe.m2321() <= 0) {
            return m4180();
        }
        return null;
    }

    public static boolean m4194() {
        if (m4157() > 0) {
            return m4155();
        }
        return false;
    }

    public static ArrayList m4195(Object obj) {
        if (C0457zc.m10555() > 0) {
            return m4162((RunnableC0176fz) obj);
        }
        return null;
    }

    public static InterfaceC0173fw m4196(Object obj) {
        if (C0458ze.m10926() < 0) {
            return m4185((RunnableC0176fz) obj);
        }
        return null;
    }

    public static Drawable m4197(Object obj) {
        if (abd.m2021() >= 0) {
            return m4181((RunnableC0176fz) obj);
        }
        return null;
    }

    public static String m4198(Object obj) {
        if (C0459zf.m11053() >= 0) {
            return m4166((RunnableC0176fz) obj);
        }
        return null;
    }

    public static AbstractC0179gb m4199(Object obj) {
        if (C0456zb.m10484() <= 0) {
            return m4183((RunnableC0176fz) obj);
        }
        return null;
    }

    public static Bitmap m4200(Object obj) {
        if (C0458ze.m10926() < 0) {
            return m4175((AbstractC0179gb) obj);
        }
        return null;
    }

    @Override
    public void run() {
        Drawable drawable;
        if (!m4172() && !C0459zf.m11147(m4178(), abd.m2172())) {
            throw new AssertionError();
        }
        Bitmap bitmapM4159 = m4159(m4158(this));
        C0181gd c0181gd = bitmapM4159 != null ? new C0181gd(m4171(this), m4173(), bitmapM4159) : null;
        if (c0181gd == null) {
            m4161(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), gggy.m4328()), m4171(this))), new Object[0]);
            Drawable drawableM4176 = m4176(this);
            m4168(m4165(), m4171(this), drawableM4176);
            drawable = drawableM4176;
        } else {
            drawable = c0181gd;
        }
        C0455za.m10196(m4182(), m4171(this));
        if (m4164(this) != null && m4163(this) == null) {
            C0445ya.m8362(m4164(this), null, m4159(m4158(this)), m4171(this), false);
        }
        Iterator itM4179 = m4179(m4186(this));
        int i = 0;
        while (C0455za.m10104(itM4179)) {
            ImageView imageView = (ImageView) m4174(itM4179);
            String str = (String) C0449ye.m9236(m4167(), imageView);
            if (C0452yh.m9583(m4171(this), str)) {
                int i2 = i + 1;
                C0455za.m10196(m4167(), imageView);
                if (drawable != null) {
                    C0457zc.m10652(imageView, drawable);
                }
                if (m4164(this) != null && imageView == m4163(this)) {
                    C0445ya.m8362(m4164(this), imageView, m4159(m4158(this)), m4171(this), false);
                }
                i = i2;
            } else {
                m4161(abc.m1925(abd.m2090(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0456zb.m10443()), m4171(this)), C0448yd.m9049()), str), C0448yd.m9049()), imageView)), new Object[0]);
            }
        }
        m4161(abc.m1925(adds.m2680(C0460zg.m11407(new StringBuilder(), C0459zf.m11203()), i)), new Object[0]);
    }
}
