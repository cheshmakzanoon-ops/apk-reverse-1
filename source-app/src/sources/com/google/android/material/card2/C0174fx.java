package com.google.android.material.card2;

import android.annotation.TargetApi;
import android.app.ActivityManager;
import android.content.Context;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.Drawable;
import android.os.AsyncTask;
import android.util.DisplayMetrics;
import android.view.WindowManager;
import android.widget.ImageView;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.Iterator;

public final class C0174fx {

    static Resources f332fh;

    static DisplayMetrics f333fi;

    private static boolean f334fj;

    private static boolean f335fk;

    private static C0166fp f336fl;

    private static C0161fk f337fm;

    private static C0159fi f338fn;

    private static C0157fg f339fo;

    private static C0164fn f340fp;

    private static ArrayList<InterfaceC0171fu> f341fq;

    private static C0163fm f342fr;

    private static C0168fr f343fs;

    private static HashSet<Bitmap> f344ft;

    private static Hashtable<ImageView, String> f345fu;

    private static Hashtable<String, ArrayList<ImageView>> f346fv;

    static final boolean f347fw;

    static {
        f347fw = !C0460zg.m11342(C0174fx.class);
        f334fj = true;
        f335fk = false;
        f336fl = new C0166fp();
        f337fm = new C0161fk();
        f338fn = new C0159fi();
        f339fo = new C0157fg();
        f340fp = new C0164fn();
        f341fq = new ArrayList<>();
        C0449ye.m9139(C0448yd.m9054(), C0460zg.m11413());
        C0449ye.m9139(C0448yd.m9054(), C0446yb.m8457());
        C0449ye.m9139(C0448yd.m9054(), C0458ze.m10871());
        C0449ye.m9139(C0448yd.m9054(), abc.m1846());
        C0449ye.m9139(C0448yd.m9054(), gggy.m4473());
        f342fr = C0458ze.m10949();
        f344ft = new HashSet<>();
        f345fu = new Hashtable<>();
        f346fv = new Hashtable<>();
    }

    public static int m498a(InputStream inputStream, OutputStream outputStream) {
        byte[] bArr = new byte[8192];
        int i = 0;
        while (true) {
            int iM2197 = abd.m2197(inputStream, bArr);
            if (iM2197 == -1) {
                return i;
            }
            C0458ze.m10821(outputStream, bArr, 0, iM2197);
            i += iM2197;
        }
    }

    private static Bitmap m499a(Context context, String str, String str2, int i, int i2) throws Throwable {
        Throwable th;
        BufferedInputStream bufferedInputStream;
        BufferedInputStream bufferedInputStream2;
        BitmapFactory.Options options;
        C0449ye.m9126(context);
        C0450yf.m9478(abc.m1925(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0461zs.m11483()), str), C0448yd.m9049()), str2)), new Object[0]);
        try {
            if (abc.m1801()) {
                BitmapFactory.Options options2 = new BitmapFactory.Options();
                options2.inJustDecodeBounds = true;
                bufferedInputStream2 = new BufferedInputStream(new FileInputStream(str2), 8192);
                try {
                    C0453yj.m9890(bufferedInputStream2, null, options2);
                    abf.m2477(bufferedInputStream2);
                    int i3 = 0;
                    while (true) {
                        if ((C0456zb.m10293(options2) >> i3) <= i && (C0461zs.m11546(options2) >> i3) <= i2) {
                            break;
                        }
                        i3++;
                    }
                    BitmapFactory.Options options3 = new BitmapFactory.Options();
                    options3.inSampleSize = 1 << i3;
                    options = options3;
                } catch (IOException e) {
                    if (bufferedInputStream2 != null) {
                        try {
                            abf.m2477(bufferedInputStream2);
                        } catch (IOException e2) {
                            C0460zg.m11233(abd.m2088(), C0460zg.m11330(), e2);
                        }
                    }
                    return null;
                } catch (Throwable th2) {
                    th = th2;
                    bufferedInputStream = bufferedInputStream2;
                    if (bufferedInputStream != null) {
                        throw th;
                    }
                    try {
                        abf.m2477(bufferedInputStream);
                        throw th;
                    } catch (IOException e3) {
                        C0460zg.m11233(abd.m2088(), C0460zg.m11330(), e3);
                        throw th;
                    }
                }
            } else {
                options = null;
                bufferedInputStream2 = null;
            }
            bufferedInputStream = new BufferedInputStream(new FileInputStream(str2), 8192);
            try {
                Bitmap bitmapM9890 = C0453yj.m9890(bufferedInputStream, null, options);
                C0450yf.m9478(m4100(C0455za.m10096(), new Object[]{abd.m2028(abd.m2135(bitmapM9890)), abd.m2028(C0459zf.m11037(bitmapM9890))}), new Object[0]);
                if (bufferedInputStream == null) {
                    return bitmapM9890;
                }
                try {
                    abf.m2477(bufferedInputStream);
                    return bitmapM9890;
                } catch (IOException e4) {
                    C0460zg.m11233(abd.m2088(), C0460zg.m11330(), e4);
                    return bitmapM9890;
                }
            } catch (IOException e5) {
                bufferedInputStream2 = bufferedInputStream;
                if (bufferedInputStream2 != null) {
                    abf.m2477(bufferedInputStream2);
                }
                return null;
            } catch (Throwable th3) {
                th = th3;
                if (bufferedInputStream != null) {
                    throw th;
                }
                abf.m2477(bufferedInputStream);
                throw th;
            }
        } catch (IOException e6) {
            bufferedInputStream2 = null;
        } catch (Throwable th4) {
            th = th4;
            bufferedInputStream = null;
        }
    }

    private static void m500a(Context context) {
        if (abc.m1900() != null) {
            return;
        }
        f333fi = new DisplayMetrics();
        abe.m2364(C0447yc.m8695((WindowManager) C0459zf.m10978(context, C0460zg.m11366())), abc.m1900());
        f332fh = new Resources(gggy.m4364(context), abc.m1900(), C0453yj.m9867(abd.m2103(context)));
    }

    public static void m501a(Context context, long j) {
        if (C0450yf.m9570()) {
            return;
        }
        f335fk = true;
        try {
            String[] strArrM11603 = C0461zs.m11603(abf.m2486(context));
            if (strArrM11603 != null) {
                for (String str : strArrM11603) {
                    if (C0459zf.m11107(str, C0449ye.m9313())) {
                        File file = new File(abc.m1925(C0460zg.m11407(abe.m2346(C0460zg.m11407(new StringBuilder(), C0461zs.m11569(abf.m2486(context))), '/'), str)));
                        if (C0456zb.m10382() > abc.m1952(file) + j) {
                            C0448yd.m8996(file);
                        }
                    }
                }
            }
        } catch (Exception e) {
            C0458ze.m10842(e);
        }
    }

    private static void m502a(Context context, ImageView imageView, String str, Drawable drawable, long j, InterfaceC0173fw interfaceC0173fw) {
        Bitmap bitmap;
        Drawable drawable2;
        if (!C0455za.m10080() && C0461zs.m11433(abd.m2172()) != C0457zc.m10701()) {
            throw new AssertionError(C0456zb.m10394());
        }
        C0456zb.m10357(context);
        if (abf.m2420(str)) {
            if (imageView != null) {
                C0455za.m10196(C0450yf.m9459(), imageView);
                C0457zc.m10652(imageView, drawable);
                return;
            }
            return;
        }
        if (abc.m1900() == null) {
            C0449ye.m9126(context);
        }
        int iM8351 = C0445ya.m8351(abc.m1900());
        int iM10210 = C0455za.m10210(abc.m1900());
        String strM11569 = C0461zs.m11569(C0448yd.m8935(context, adds.m2699(str)));
        File file = new File(strM11569);
        if (C0459zf.m11130() == null) {
            f343fs = new C0168fr(adds.m2869(context) / 8);
        }
        Drawable c0181gd = null;
        Bitmap bitmap2 = (Bitmap) C0459zf.m11113(C0459zf.m11130(), str);
        if (bitmap2 != null) {
            C0450yf.m9478(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), adds.m2892()), str)), new Object[0]);
        } else {
            c0181gd = (Drawable) C0457zc.m10644(C0459zf.m11117(), str);
        }
        if (c0181gd == null && bitmap2 == null) {
            bitmap = bitmap2;
        } else {
            C0450yf.m9478(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0453yj.m10020()), str)), new Object[0]);
            if (!C0449ye.m9283(file) || C0445ya.m8338(file, j)) {
                C0450yf.m9478(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0459zf.m11153()), str)), new Object[0]);
                bitmap = bitmap2;
            } else {
                C0450yf.m9478(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0456zb.m10337()), str)), new Object[0]);
                if (c0181gd != null && (c0181gd instanceof C0181gd)) {
                    C0456zb.m10359((C0181gd) c0181gd);
                }
                c0181gd = null;
                bitmap = null;
            }
        }
        if (c0181gd != null || bitmap != null) {
            if (imageView != null) {
                C0455za.m10196(C0450yf.m9459(), imageView);
                if (c0181gd instanceof C0181gd) {
                    c0181gd = m4068((C0181gd) c0181gd, C0455za.m10250());
                } else if (bitmap != null) {
                    c0181gd = new C0181gd(str, C0455za.m10250(), bitmap);
                }
                C0457zc.m10652(imageView, c0181gd);
                drawable2 = c0181gd;
            } else {
                drawable2 = c0181gd;
            }
            if (interfaceC0173fw != null) {
                C0445ya.m8362(interfaceC0173fw, imageView, (bitmap == null && (drawable2 instanceof C0181gd)) ? C0461zs.m11548((C0181gd) drawable2) : bitmap, str, true);
                return;
            }
            return;
        }
        C0450yf.m9478(abc.m1925(abd.m2090(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), abd.m2006()), str), C0448yd.m9049()), imageView)), new Object[0]);
        if (imageView != null) {
            C0457zc.m10652(imageView, drawable);
            abd.m2110(C0450yf.m9459(), imageView, str);
        }
        ArrayList arrayList = (ArrayList) C0449ye.m9236(C0459zf.m11029(), str);
        if (arrayList != null) {
            if (imageView != null) {
                C0449ye.m9139(arrayList, imageView);
                return;
            }
            return;
        }
        ArrayList arrayList2 = new ArrayList();
        if (imageView != null) {
            C0449ye.m9139(arrayList2, imageView);
        }
        abd.m2110(C0459zf.m11029(), str, arrayList2);
        if (iM8351 <= 0) {
            iM8351 = Integer.MAX_VALUE;
        }
        if (iM10210 <= 0) {
            iM10210 = Integer.MAX_VALUE;
        }
        C0175fy c0175fy = new C0175fy(strM11569, context, str, iM8351, iM10210);
        RunnableC0176fz runnableC0176fz = new RunnableC0176fz(c0175fy, str, drawable, interfaceC0173fw, imageView, arrayList2);
        if (C0449ye.m9283(file)) {
            try {
                if (C0445ya.m8338(file, j)) {
                    C0450yf.m9478(abc.m1925(C0460zg.m11407(C0458ze.m10777(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0449ye.m9246()), str), C0447yc.m8793()), C0456zb.m10382() - abc.m1952(file)), abd.m2032())), new Object[0]);
                    C0447yc.m8653(new AsyncTaskC0178ga(c0175fy, strM11569, runnableC0176fz));
                    return;
                }
                C0450yf.m9478(C0459zf.m11186(), new Object[0]);
            } catch (Exception e) {
            }
        }
        Iterator itM4074 = m4074(C0448yd.m9054());
        while (C0455za.m10104(itM4074)) {
            InterfaceC0171fu interfaceC0171fu = (InterfaceC0171fu) m4071(itM4074);
            if (m4088(interfaceC0171fu, str)) {
                C0458ze.m10867(interfaceC0171fu, context, str, strM11569, c0175fy, runnableC0176fz);
                return;
            }
        }
        C0457zc.m10652(imageView, drawable);
    }

    static void m503a(AsyncTask<Void, Void, Void> asyncTask) {
        if (abd.m2050() < 11) {
            C0449ye.m9271(asyncTask, new Void[0]);
        } else {
            abc.m1874(asyncTask);
        }
    }

    public static void m504a(ImageView imageView, String str) {
        C0459zf.m11133(C0455za.m10185(imageView), imageView, str, null, 259200000L, null);
    }

    static void m505a(String str, Object... objArr) {
        if (objArr.length == 0) {
            return;
        }
        m4100(str, objArr);
    }

    private static boolean m506a(File file, long j) {
        return j == 2147483647L || C0456zb.m10382() < abc.m1952(file) + j;
    }

    private static boolean m507a(CharSequence charSequence) {
        return charSequence == null || C0459zf.m11147(charSequence, gggy.m4277()) || C0459zf.m11147(charSequence, C0448yd.m8883()) || C0459zf.m11147(charSequence, C0458ze.m10943());
    }

    public static void m514b(Context context) {
        C0457zc.m10596(context, 604800000L);
    }

    @TargetApi(11)
    private static void m515b(AsyncTask<Void, Void, Void> asyncTask) {
        adds.m2724(asyncTask, adds.m2822(), new Void[0]);
    }

    private static int m516c(Context context) {
        return C0448yd.m9011((ActivityManager) C0459zf.m10978(context, C0447yc.m8650())) * 1024 * 1024;
    }

    public static String m517m(String str) {
        return abc.m1925(C0460zg.m11407(adds.m2680(new StringBuilder(), C0460zg.m11248(str)), C0449ye.m9313()));
    }

    public static C0181gd m4068(Object obj, Object obj2) {
        if (C0456zb.m10326() < 0) {
            return m4128(obj, obj2);
        }
        return null;
    }

    public static void m4069(Object obj) {
        if (gggy.m4269() <= 0) {
            m500a((Context) obj);
        }
    }

    public static void m4070(Object obj) {
        if (C0445ya.m8222() >= 0) {
            ((C0181gd) obj).m522aL();
        }
    }

    public static Object m4071(Object obj) {
        if (abe.m2308() <= 0) {
            return C0598.m11882(obj);
        }
        return null;
    }

    public static boolean m4072(Object obj, long j) {
        if (C0451yg.m9580() >= 0) {
            return m506a((File) obj, j);
        }
        return false;
    }

    public static C0157fg m4073() {
        if (C0461zs.m11510() < 0) {
            return f339fo;
        }
        return null;
    }

    public static Iterator m4074(Object obj) {
        if (C0449ye.m9220() < 0) {
            return C0598.m11895(obj);
        }
        return null;
    }

    public static boolean m4075(Object obj) {
        if (C0449ye.m9220() < 0) {
            return m507a((CharSequence) obj);
        }
        return false;
    }

    public static Object m4076(Object obj, Object obj2) {
        if (C0461zs.m11510() <= 0) {
            return ((C0163fm) obj).get(obj2);
        }
        return null;
    }

    public static ArrayList m4077() {
        if (C0448yd.m9079() <= 0) {
            return f341fq;
        }
        return null;
    }

    public static boolean m4078() {
        if (C0452yh.m9798() >= 0) {
            return f334fj;
        }
        return false;
    }

    public static C0161fk m4079() {
        if (C0460zg.m11287() >= 0) {
            return f337fm;
        }
        return null;
    }

    public static Hashtable m4080() {
        if (C0449ye.m9220() <= 0) {
            return f346fv;
        }
        return null;
    }

    public static int m4081() {
        if (abe.m2308() < 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static Resources m4082() {
        if (abe.m2308() < 0) {
            return f332fh;
        }
        return null;
    }

    public static void m4083(Object obj, Object obj2, Object obj3, Object obj4, long j, Object obj5) {
        if (C0449ye.m9220() <= 0) {
            m502a((Context) obj, (ImageView) obj2, (String) obj3, (Drawable) obj4, j, (InterfaceC0173fw) obj5);
        }
    }

    public static Bitmap m4084(Object obj) {
        if (C0461zs.m11510() < 0) {
            return ((C0181gd) obj).getBitmap();
        }
        return null;
    }

    public static DisplayMetrics m4085() {
        if (C0457zc.m10735() < 0) {
            return f333fi;
        }
        return null;
    }

    public static void m4086(Object obj, Object obj2) {
        if (C0453yj.m10013() > 0) {
            m505a((String) obj, (Object[]) obj2);
        }
    }

    public static boolean m4087() {
        if (C0445ya.m8222() >= 0) {
            return f335fk;
        }
        return false;
    }

    public static boolean m4088(Object obj, Object obj2) {
        if (C0451yg.m9580() >= 0) {
            return C0598.m11806(obj, obj2);
        }
        return false;
    }

    public static Object m4089(Object obj, Object obj2) {
        if (C0445ya.m8222() >= 0) {
            return ((C0168fr) obj).m495i(obj2);
        }
        return null;
    }

    public static Bitmap m4090(Object obj, Object obj2, Object obj3, int i, int i2) {
        if (C0448yd.m9079() <= 0) {
            return m499a((Context) obj, (String) obj2, (String) obj3, i, i2);
        }
        return null;
    }

    public static C0168fr m4091() {
        if (abe.m2308() < 0) {
            return f343fs;
        }
        return null;
    }

    public static void m4092(Object obj) {
        if (abd.m2162() > 0) {
            m515b((AsyncTask<Void, Void, Void>) obj);
        }
    }

    public static void m4093(Object obj) {
        if (C0451yg.m9580() >= 0) {
            m503a((AsyncTask<Void, Void, Void>) obj);
        }
    }

    public static int m4094(Object obj) {
        if (C0452yh.m9798() >= 0) {
            return m516c((Context) obj);
        }
        return 0;
    }

    public static C0181gd m4095(Object obj, Object obj2) {
        if (adds.m2755() > 0) {
            return ((C0181gd) obj).m521a((Resources) obj2);
        }
        return null;
    }

    public static boolean m4096() {
        if (abf.m2510() < 0) {
            return f347fw;
        }
        return false;
    }

    public static HashSet m4097() {
        if (C0453yj.m10013() >= 0) {
            return f344ft;
        }
        return null;
    }

    public static C0163fm m4098() {
        if (C0445ya.m8222() >= 0) {
            return f342fr;
        }
        return null;
    }

    public static C0166fp m4099() {
        if (C0459zf.m11062() >= 0) {
            return f336fl;
        }
        return null;
    }

    public static String m4100(Object obj, Object obj2) {
        if (C0448yd.m9079() <= 0) {
            return C0598.m11903(obj, obj2);
        }
        return null;
    }

    public static C0159fi m4101() {
        if (abc.m1845() <= 0) {
            return f338fn;
        }
        return null;
    }

    public static C0164fn m4102() {
        if (C0458ze.m10932() > 0) {
            return f340fp;
        }
        return null;
    }

    public static Hashtable m4103() {
        if (C0448yd.m9079() <= 0) {
            return f345fu;
        }
        return null;
    }

    public static C0168fr m4104() {
        if (C0459zf.m11053() >= 0) {
            return m4091();
        }
        return null;
    }

    public static HashSet m4105() {
        if (gggy.m4365() >= 0) {
            return m4097();
        }
        return null;
    }

    public static C0159fi m4106() {
        if (C0453yj.m9966() >= 0) {
            return m4101();
        }
        return null;
    }

    public static DisplayMetrics m4107() {
        if (abd.m2021() >= 0) {
            return m4085();
        }
        return null;
    }

    public static boolean m4108() {
        if (C0456zb.m10484() < 0) {
            return m4087();
        }
        return false;
    }

    public static C0161fk m4109() {
        if (C0458ze.m10926() <= 0) {
            return m4079();
        }
        return null;
    }

    public static C0157fg m4110() {
        if (C0457zc.m10555() > 0) {
            return m4073();
        }
        return null;
    }

    public static void m4111(Object obj, Object obj2, Object obj3, Object obj4, long j, Object obj5) {
        if (abd.m2021() > 0) {
            m4083((Context) obj, (ImageView) obj2, (String) obj3, (Drawable) obj4, j, (InterfaceC0173fw) obj5);
        }
    }

    public static C0166fp m4112() {
        if (C0445ya.m8330() > 0) {
            return m4099();
        }
        return null;
    }

    public static Resources m4113() {
        if (m4081() >= 0) {
            return m4082();
        }
        return null;
    }

    public static C0164fn m4114() {
        if (C0457zc.m10718() <= 0) {
            return m4102();
        }
        return null;
    }

    public static void m4115(Object obj) {
        if (C0453yj.m9945() <= 0) {
            m4093((AsyncTask) obj);
        }
    }

    public static void m4116(Object obj) {
        if (C0448yd.m9074() < 0) {
            m4069((Context) obj);
        }
    }

    public static ArrayList m4117() {
        if (C0458ze.m10926() < 0) {
            return m4077();
        }
        return null;
    }

    public static C0163fm m4118() {
        if (C0453yj.m9996() < 0) {
            return m4098();
        }
        return null;
    }

    public static boolean m4119() {
        if (abf.m2500() > 0) {
            return m4078();
        }
        return false;
    }

    public static boolean m4120(Object obj, long j) {
        if (C0448yd.m9015() <= 0) {
            return m4072((File) obj, j);
        }
        return false;
    }

    public static int m4121(Object obj) {
        if (C0457zc.m10718() <= 0) {
            return m4094((Context) obj);
        }
        return 0;
    }

    public static void m4122(Object obj) {
        if (C0457zc.m10718() <= 0) {
            m4092((AsyncTask) obj);
        }
    }

    public static void m4123(Object obj, Object obj2) {
        if (C0453yj.m10032() > 0) {
            m4086((String) obj, (Object[]) obj2);
        }
    }

    public static Hashtable m4124() {
        if (C0458ze.m10926() <= 0) {
            return m4103();
        }
        return null;
    }

    public static Hashtable m4125() {
        if (C0459zf.m11053() > 0) {
            return m4080();
        }
        return null;
    }

    public static boolean m4126(Object obj) {
        if (C0448yd.m9074() < 0) {
            return m4075((CharSequence) obj);
        }
        return false;
    }

    public static boolean m4127() {
        if (C0453yj.m9945() < 0) {
            return m4096();
        }
        return false;
    }

    public static C0181gd m4128(Object obj, Object obj2) {
        if (abd.m2021() >= 0) {
            return m4095((C0181gd) obj, (Resources) obj2);
        }
        return null;
    }

    public static Object m4129(Object obj, Object obj2) {
        if (C0457zc.m10718() <= 0) {
            return m4076((C0163fm) obj, obj2);
        }
        return null;
    }

    public static Bitmap m4130(Object obj, Object obj2, Object obj3, int i, int i2) {
        if (m4081() > 0) {
            return m4090((Context) obj, (String) obj2, (String) obj3, i, i2);
        }
        return null;
    }

    public static Bitmap m4131(Object obj) {
        if (gggy.m4365() >= 0) {
            return m4084((C0181gd) obj);
        }
        return null;
    }

    public static void m4132(Object obj) {
        if (C0453yj.m9966() >= 0) {
            m4070((C0181gd) obj);
        }
    }

    public static Object m4133(Object obj, Object obj2) {
        if (gggy.m4365() > 0) {
            return m4089((C0168fr) obj, obj2);
        }
        return null;
    }
}
