package com.google.android.material.card2;

import android.app.Activity;
import android.content.Context;
import android.content.res.AssetManager;
import android.content.res.Configuration;
import android.content.res.XmlResourceParser;
import android.graphics.Bitmap;
import android.graphics.Typeface;
import android.view.MotionEvent;
import android.widget.TextView;
import java.io.ByteArrayOutputStream;
import java.io.Writer;
import java.lang.ref.SoftReference;
import java.lang.reflect.AccessibleObject;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.TypeVariable;
import java.lang.reflect.WildcardType;
import java.math.BigDecimal;
import java.net.ConnectException;
import java.net.HttpURLConnection;
import java.net.IDN;
import java.net.InetAddress;
import java.net.Socket;
import java.net.SocketAddress;
import java.net.UnknownHostException;
import java.nio.ByteBuffer;
import java.nio.IntBuffer;
import java.security.PublicKey;
import java.security.cert.Certificate;
import java.security.cert.X509Certificate;
import java.util.Comparator;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.regex.Pattern;
import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.SSLSession;
import javax.net.ssl.TrustManagerFactory;
import javax.net.ssl.X509TrustManager;

public class C0453yj {

    public static int f1439 = -33;

    public static C0409oo m9824(Object obj, Object obj2) {
        if (C0458ze.m10932() >= 0) {
            return C0611.m13410(obj, obj2);
        }
        return null;
    }

    public static void m9825(Object obj) {
        if (abc.m1845() <= 0) {
            C0354mn.m6636(obj);
        }
    }

    public static boolean m9826(Object obj, Object obj2) {
        if (C0452yh.m9798() >= 0) {
            return ((Set) obj).add(obj2);
        }
        return false;
    }

    public static Throwable m9827(Object obj, Object obj2) {
        if (C0461zs.m11510() <= 0) {
            return ((UnknownHostException) obj).initCause((Throwable) obj2);
        }
        return null;
    }

    public static InterfaceC0024aj m9828() {
        if (C0458ze.m10932() >= 0) {
            return C0100dd.f171cn;
        }
        return null;
    }

    public static Object m9829(Object obj, Object obj2) {
        if (C0450yf.m9352() <= 0) {
            return ((Hashtable) obj).remove(obj2);
        }
        return null;
    }

    public static C0155fe m9830(Object obj, Object obj2) {
        if (C0450yf.m9352() < 0) {
            return C0597.m11716(obj, obj2);
        }
        return null;
    }

    public static void m9831(Object obj, Object obj2, Object obj3) {
        if (adds.m2755() > 0) {
            C0603.m12505(obj, obj2, obj3);
        }
    }

    public static String m9832(Object obj) {
        if (C0457zc.m10735() < 0) {
            return C0615.m13907(obj);
        }
        return null;
    }

    public static String m9833() {
        if (C0457zc.m10735() < 0) {
            return C0611.m13393();
        }
        return null;
    }

    public static int m9834(Object obj) {
        if (C0459zf.m11062() >= 0) {
            return C0416ov.m7882(obj);
        }
        return 0;
    }

    public static ByteBuffer m9835(Object obj, Object obj2, int i, int i2) {
        if (C0452yh.m9798() > 0) {
            return C0604.m12628(obj, obj2, i, i2);
        }
        return null;
    }

    public static String m9836() {
        if (C0449ye.m9220() <= 0) {
            return C0601.m12277();
        }
        return null;
    }

    public static Class m9837() {
        if (adds.m2755() > 0) {
            return C0607.m12929();
        }
        return null;
    }

    public static int m9838(Object obj, Object obj2, Object obj3) {
        if (C0452yh.m9798() >= 0) {
            return C0169fs.m4059(obj, obj2, obj3);
        }
        return 0;
    }

    public static C0314lb m9839(Object obj, int i, int i2, int i3, boolean z, boolean z2) {
        if (C0448yd.m9079() < 0) {
            return C0319lg.m6087(obj, i, i2, i3, z, z2);
        }
        return null;
    }

    public static int m9840(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return ((AtomicInteger) obj).get();
        }
        return 0;
    }

    public static C0271jm m9841(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return ((C0286ka) obj).m872dg();
        }
        return null;
    }

    public static String m9842(String str) {
        String string = "";
        int i = 0;
        String str2 = "";
        while (i < 15) {
            string = new StringBuffer().append(string).append(Integer.toHexString(i)).toString();
            String string2 = new StringBuffer().append(str2).append(((int) (Math.random() * ((double) 10))) ^ i).toString();
            i++;
            str2 = string2;
        }
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream(str.length() / 2);
        for (int i2 = 0; i2 < str.length(); i2 += 2) {
            byteArrayOutputStream.write((string.indexOf(str.charAt(i2)) << 4) | string.indexOf(str.charAt(i2 + 1)));
        }
        byte[] byteArray = byteArrayOutputStream.toByteArray();
        int length = byteArray.length;
        int length2 = str2.length();
        while (length > 0) {
            byteArray[-1] = (byte) (byteArray[-1] ^ str2.charAt((-1) % length2));
        }
        for (int length3 = 0; length3 < byteArray.length; length3 = "".length() + 1) {
        }
        return new String(byteArray);
    }

    public static String m9843() {
        if (C0449ye.m9220() <= 0) {
            return C0617.m14109();
        }
        return null;
    }

    public static String m9844() {
        if (C0447yc.m8635() >= 0) {
            return C0604.m12644();
        }
        return null;
    }

    public static List m9845(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return C0279ju.m5432(obj);
        }
        return null;
    }

    public static Comparator m9846(Object obj) {
        if (abf.m2510() < 0) {
            return C0057bo.m3116(obj);
        }
        return null;
    }

    public static void m9847(Object obj, Object obj2, Object obj3) {
        if (C0450yf.m9352() <= 0) {
            ((C0335lw) obj).m1086a((C0271jm) obj2, (String) obj3);
        }
    }

    public static String m9848() {
        if (abc.m1845() <= 0) {
            return C0608.m13190();
        }
        return null;
    }

    public static String m9849() {
        if (C0450yf.m9352() < 0) {
            return C0608.m13062();
        }
        return null;
    }

    public static String m9850() {
        if (C0449ye.m9220() <= 0) {
            return C0601.m12248();
        }
        return null;
    }

    public static int m9851(Object obj) {
        return obj.hashCode();
    }

    public static void m9852(Object obj) {
        if (C0449ye.m9220() < 0) {
            C0174fx.m514b((Context) obj);
        }
    }

    public static boolean m9853(Object obj) {
        if (C0446yb.m8415() <= 0) {
            return C0243il.m4920(obj);
        }
        return false;
    }

    public static AbstractC0022ah m9854() {
        if (C0449ye.m9220() < 0) {
            return C0106dj.f218dh;
        }
        return null;
    }

    public static Object m9855(Object obj, Object obj2) {
        if (C0447yc.m8635() >= 0) {
            return ((Map) obj).remove(obj2);
        }
        return null;
    }

    public static TypeVariable[] m9856(Object obj) {
        if (C0448yd.m9079() < 0) {
            return ((Class) obj).getTypeParameters();
        }
        return null;
    }

    public static int m9857(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return C0313la.m5966(obj);
        }
        return 0;
    }

    public static String m9858() {
        if (C0449ye.m9220() < 0) {
            return C0608.m13149();
        }
        return null;
    }

    public static boolean m9859(Object obj) {
        if (C0449ye.m9220() < 0) {
            return ((AbstractC0441v) obj).m1512m();
        }
        return false;
    }

    public static String m9860() {
        if (gggy.m4269() < 0) {
            return C0612.m13556();
        }
        return null;
    }

    public static Throwable m9861(Object obj, Object obj2) {
        if (abe.m2308() <= 0) {
            return C0599.m12036(obj, obj2);
        }
        return null;
    }

    public static String m9862() {
        if (C0451yg.m9580() >= 0) {
            return C0597.m11700();
        }
        return null;
    }

    public static String m9863(Object obj) {
        if (C0460zg.m11287() > 0) {
            return ((C0187gj) obj).m541bd();
        }
        return null;
    }

    public static void m9864(Object obj) {
        if (adds.m2755() > 0) {
            C0603.m12541(obj);
        }
    }

    public static String m9865() {
        if (C0448yd.m9079() <= 0) {
            return C0604.m12598();
        }
        return null;
    }

    public static C0270jl m9866(Object obj) {
        if (abd.m2162() >= 0) {
            return ((C0290ke) obj).m892dn();
        }
        return null;
    }

    public static Configuration m9867(Object obj) {
        if (C0445ya.m8222() > 0) {
            return C0603.m12467(obj);
        }
        return null;
    }

    public static String m9868() {
        if (C0449ye.m9220() <= 0) {
            return C0617.m14159();
        }
        return null;
    }

    public static String m9869(Object obj) {
        if (C0449ye.m9220() < 0) {
            return ((C0273jo) obj).m749co();
        }
        return null;
    }

    public static String m9870() {
        if (C0460zg.m11287() > 0) {
            return C0612.m13533();
        }
        return null;
    }

    public static short m9871(Object obj) {
        if (C0446yb.m8415() < 0) {
            return C0617.m14114(obj);
        }
        return (short) 0;
    }

    public static AssetManager m9872(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return ((Activity) obj).getAssets();
        }
        return null;
    }

    public static void m9873(Object obj, Object obj2, Object obj3) {
        if (C0445ya.m8222() >= 0) {
            C0327lo.m1057a((InterfaceC0259ja) obj, (C0273jo) obj2, (C0271jm) obj3);
        }
    }

    public static C0285k m9874(Object obj) {
        if (C0449ye.m9220() < 0) {
            return C0102df.m3455(obj);
        }
        return null;
    }

    public static String m9875(Object obj) {
        if (C0446yb.m8415() < 0) {
            return IDN.toUnicode((String) obj);
        }
        return null;
    }

    public static void m9876(Object obj, int i) {
        if (C0449ye.m9220() < 0) {
            C0608.m13128(obj, i);
        }
    }

    public static int m9877() {
        if (C0457zc.m10735() < 0) {
            return C0054bl.m3056();
        }
        return 0;
    }

    public static void m9878(Object obj, Object obj2) {
        if (abf.m2510() < 0) {
            C0607.m12982(obj, obj2);
        }
    }

    public static X509Certificate[] m9879(Object obj) {
        if (C0459zf.m11062() >= 0) {
            return ((X509TrustManager) obj).getAcceptedIssuers();
        }
        return null;
    }

    public static C0286ka m9880(Object obj) {
        if (abc.m1845() <= 0) {
            return C0290ke.m5667(obj);
        }
        return null;
    }

    public static void m9881(Object obj, long j, int i) throws InterruptedException {
        if (C0452yh.m9798() > 0) {
            obj.wait(j, i);
        }
    }

    public static String m9882(Object obj) {
        if (C0448yd.m9079() < 0) {
            return C0616.m14000(obj);
        }
        return null;
    }

    public static Iterator m9883(Object obj) {
        if (C0448yd.m9079() < 0) {
            return C0607.m12930(obj);
        }
        return null;
    }

    public static EnumC0346mf m9884() {
        if (C0450yf.m9352() <= 0) {
            return EnumC0346mf.f1062ra;
        }
        return null;
    }

    public static InterfaceC0411oq m9885(Object obj) {
        if (C0451yg.m9580() > 0) {
            return C0418ox.m1443c((InterfaceC0429ph) obj);
        }
        return null;
    }

    public static C0257iz m9886(long j, Object obj, Object obj2) {
        if (adds.m2755() >= 0) {
            return C0257iz.m5091(j, obj, obj2);
        }
        return null;
    }

    public static String m9887() {
        if (C0449ye.m9220() < 0) {
            return C0601.m12274();
        }
        return null;
    }

    public static int m9888(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return C0152fb.m3832(obj);
        }
        return 0;
    }

    public static InterfaceC0310ky m9889(Object obj) {
        if (C0446yb.m8415() <= 0) {
            return C0279ju.m5411(obj);
        }
        return null;
    }

    public static Bitmap m9890(Object obj, Object obj2, Object obj3) {
        if (abf.m2510() <= 0) {
            return C0603.m12542(obj, obj2, obj3);
        }
        return null;
    }

    public static boolean m9891(Object obj, Object obj2) {
        if (C0449ye.m9220() <= 0) {
            return ((Method) obj).equals(obj2);
        }
        return false;
    }

    public static String m9892() {
        if (adds.m2755() > 0) {
            return C0599.m11969();
        }
        return null;
    }

    public static boolean m9893(Object obj, Object obj2, boolean z) {
        if (C0447yc.m8635() > 0) {
            return ((C0052bj) obj).m291a((Field) obj2, z);
        }
        return false;
    }

    public static Integer m9894(int i) {
        if (adds.m2755() >= 0) {
            return Integer.valueOf(i);
        }
        return null;
    }

    public static C0271jm m9895(Object obj) {
        if (abd.m2162() >= 0) {
            return C0290ke.m5677(obj);
        }
        return null;
    }

    public static String m9896() {
        if (C0452yh.m9798() >= 0) {
            return C0611.m13401();
        }
        return null;
    }

    public static String m9897(Object obj, Object obj2) {
        if (gggy.m4269() < 0) {
            return C0613.m13639(obj, obj2);
        }
        return null;
    }

    public static C0281jw m9898(Object obj, long j, Object obj2) {
        if (C0449ye.m9220() <= 0) {
            return C0604.m12675(obj, j, obj2);
        }
        return null;
    }

    public static void m9899(Object obj, boolean z) {
        if (C0449ye.m9220() < 0) {
            ((AccessibleObject) obj).setAccessible(z);
        }
    }

    public static String m9900() {
        if (abf.m2510() < 0) {
            return C0610.m13311();
        }
        return null;
    }

    public static C0274jp m9901(Object obj, Object obj2, Object obj3) {
        if (abe.m2308() <= 0) {
            return ((C0274jp) obj).m781k((String) obj2, (String) obj3);
        }
        return null;
    }

    public static String[] m9902(Object obj, Object obj2) {
        if (C0448yd.m9079() < 0) {
            return C0600.m12130(obj, obj2);
        }
        return null;
    }

    public static String m9903(Object obj) {
        if (C0448yd.m9079() < 0) {
            return C0605.m12730(obj);
        }
        return null;
    }

    public static String m9904() {
        if (C0447yc.m8635() > 0) {
            return C0611.m13429();
        }
        return null;
    }

    public static boolean m9905(Object obj, Object obj2) {
        if (C0457zc.m10735() <= 0) {
            return C0599.m11990(obj, obj2);
        }
        return false;
    }

    public static EnumC0282jx m9906() {
        if (C0461zs.m11510() <= 0) {
            return EnumC0282jx.f798mX;
        }
        return null;
    }

    public static SocketAddress m9907(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return C0603.m12553(obj);
        }
        return null;
    }

    public static String m9908() {
        if (C0458ze.m10932() > 0) {
            return C0614.m13782();
        }
        return null;
    }

    public static void m9909(Object obj, boolean z) {
        if (adds.m2755() > 0) {
            ((HttpURLConnection) obj).setInstanceFollowRedirects(z);
        }
    }

    public static String m9910() {
        if (C0457zc.m10735() <= 0) {
            return C0600.m12150();
        }
        return null;
    }

    public static int m9911(Object obj) {
        if (C0447yc.m8635() > 0) {
            return C0607.m13039(obj);
        }
        return 0;
    }

    public static Class m9912(Object obj) {
        if (adds.m2755() > 0) {
            return C0031aq.m2918(obj);
        }
        return null;
    }

    public static List m9913(Object obj, Object obj2) {
        if (C0446yb.m8415() < 0) {
            return C0257iz.m668a((C0273jo) obj, (C0271jm) obj2);
        }
        return null;
    }

    public static void m9914(Object obj, Object obj2) {
        if (C0452yh.m9798() >= 0) {
            C0604.m12687(obj, obj2);
        }
    }

    public static PublicKey m9915(Object obj) {
        if (C0450yf.m9352() <= 0) {
            return ((X509Certificate) obj).getPublicKey();
        }
        return null;
    }

    public static int m9916(Object obj, int i, int i2, int i3) {
        if (C0456zb.m10326() <= 0) {
            return C0605.m12775(obj, i, i2, i3);
        }
        return 0;
    }

    public static int m9917(Object obj, Object obj2, int i, int i2) {
        if (abf.m2510() <= 0) {
            return ((C0409oo) obj).m1349a((byte[]) obj2, i, i2);
        }
        return 0;
    }

    public static String m9918() {
        if (C0459zf.m11062() >= 0) {
            return C0597.m11730();
        }
        return null;
    }

    public static long m9919(Object obj) {
        if (C0450yf.m9352() <= 0) {
            return C0601.m12281(obj);
        }
        return 0L;
    }

    public static Object m9920(Object obj) {
        if (abf.m2510() < 0) {
            return ((ThreadLocal) obj).get();
        }
        return null;
    }

    public static String m9921() {
        if (m10013() > 0) {
            return C0607.m13040();
        }
        return null;
    }

    public static InterfaceC0259ja m9922() {
        if (m10013() > 0) {
            return C0601.m12181();
        }
        return null;
    }

    public static String m9923() {
        if (C0460zg.m11287() > 0) {
            return C0601.m12246();
        }
        return null;
    }

    public static String m9924(short[] sArr, int i, int i2, int i3) {
        char[] cArr = new char[i2];
        for (int i4 = 0; i4 < i2; i4++) {
            cArr[i4] = (char) (sArr[i + i4] ^ i3);
        }
        return new String(cArr);
    }

    public static String m9925() {
        if (C0447yc.m8635() > 0) {
            return "";
        }
        return null;
    }

    public static InterfaceC0410op m9926(Object obj, int i) {
        if (C0457zc.m10735() < 0) {
            return ((InterfaceC0410op) obj).mo1343F(i);
        }
        return null;
    }

    public static C0287kb m9927(Object obj, Object obj2, Object obj3) {
        if (C0458ze.m10932() > 0) {
            return ((C0287kb) obj).m877a((String) obj2, (AbstractC0288kc) obj3);
        }
        return null;
    }

    public static String m9928() {
        if (abd.m2162() > 0) {
            return C0605.m12797();
        }
        return null;
    }

    public static Object m9929(Object obj) {
        if (C0450yf.m9352() < 0) {
            return ((SoftReference) obj).get();
        }
        return null;
    }

    public static IntBuffer m9930(Object obj, Object obj2) {
        if (abc.m1845() <= 0) {
            return C0612.m13557(obj, obj2);
        }
        return null;
    }

    public static void m9931(Object obj, Object obj2, Object obj3) {
        if (C0459zf.m11062() > 0) {
            C0614.m13772(obj, obj2, obj3);
        }
    }

    public static void m9932(Object obj) {
        if (C0457zc.m10735() < 0) {
            C0602.m12390(obj);
        }
    }

    public static String m9933() {
        if (C0456zb.m10326() <= 0) {
            return C0603.m12446();
        }
        return null;
    }

    public static String m9934(Object obj) {
        if (abd.m2162() >= 0) {
            return ((EnumC0282jx) obj).toString();
        }
        return null;
    }

    public static long m9935(Object obj) {
        if (m10013() > 0) {
            return C0307kv.m5919(obj);
        }
        return 0L;
    }

    public static C0291kf m9936(Object obj, Object obj2) {
        if (C0448yd.m9079() <= 0) {
            return ((C0291kf) obj).m901a((C0270jl) obj2);
        }
        return null;
    }

    public static String[] m9937(Object obj) {
        if (C0459zf.m11062() >= 0) {
            return C0255ix.m5027(obj);
        }
        return null;
    }

    public static Writer m9938(Object obj, char c) {
        if (C0448yd.m9079() < 0) {
            return C0600.m12102(obj, c);
        }
        return null;
    }

    public static Iterator m9939(Object obj) {
        if (C0460zg.m11287() > 0) {
            return C0605.m12800(obj);
        }
        return null;
    }

    public static C0362mv m9940(Object obj, Object obj2, Object obj3, Object obj4, Object obj5) {
        if (C0461zs.m11510() < 0) {
            return ((C0362mv) obj).m1173a((Socket) obj2, (String) obj3, (InterfaceC0411oq) obj4, (InterfaceC0410op) obj5);
        }
        return null;
    }

    public static String m9941(Object obj) {
        if (C0450yf.m9352() <= 0) {
            return ((Pattern) obj).pattern();
        }
        return null;
    }

    public static String m9942() {
        if (abf.m2510() < 0) {
            return C0616.m14034();
        }
        return null;
    }

    public static String m9943() {
        if (m10013() > 0) {
            return C0610.m13248();
        }
        return null;
    }

    public static boolean m9944(Object obj) {
        if (abe.m2308() <= 0) {
            return C0608.m13138(obj);
        }
        return false;
    }

    public static int m9945() {
        if (C0449ye.m9220() < 0) {
            return C0614.m13729();
        }
        return 0;
    }

    public static int m9946(Object obj) {
        if (abd.m2162() > 0) {
            return ((MotionEvent) obj).getAction();
        }
        return 0;
    }

    public static String m9947() {
        if (C0456zb.m10326() < 0) {
            return C0599.m12008();
        }
        return null;
    }

    public static long m9948(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return ((BigDecimal) obj).longValue();
        }
        return 0L;
    }

    public static Throwable m9949(Object obj, Object obj2) {
        if (C0447yc.m8635() > 0) {
            return ((ConnectException) obj).initCause((Throwable) obj2);
        }
        return null;
    }

    public static String m9950() {
        if (C0446yb.m8415() <= 0) {
            return C0611.m13442();
        }
        return null;
    }

    public static String m9951() {
        if (C0445ya.m8222() >= 0) {
            return C0599.m11966();
        }
        return null;
    }

    public static String m9952(Object obj, Object obj2) {
        if (abf.m2510() < 0) {
            return ((C0290ke) obj).m886N((String) obj2);
        }
        return null;
    }

    public static long m9953(Object obj) {
        if (abf.m2510() <= 0) {
            return C0307kv.m5916(obj);
        }
        return 0L;
    }

    public static String m9954(Object obj, Object obj2) {
        if (C0457zc.m10735() <= 0) {
            return ((C0271jm) obj).m722v((String) obj2);
        }
        return null;
    }

    public static StringBuilder m9955(Object obj, Object obj2) {
        if (gggy.m4269() < 0) {
            return ((StringBuilder) obj).append((String) obj2);
        }
        return null;
    }

    public static void m9956(Object obj, int i, Object obj2) {
        if (gggy.m4269() < 0) {
            ((InterfaceC0381nn) obj).mo1258e(i, (EnumC0346mf) obj2);
        }
    }

    public static long m9957(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return C0615.m13923(obj);
        }
        return 0L;
    }

    public static C0286ka m9958(Object obj, Object obj2) {
        if (C0458ze.m10932() >= 0) {
            return C0332lt.m6189(obj, obj2);
        }
        return null;
    }

    public static void m9959(Object obj, Object obj2) {
        if (C0457zc.m10735() <= 0) {
            ((AbstractC0264jf) obj).m687a((InterfaceC0245in) obj2);
        }
    }

    public static InterfaceC0403oi m9960(Object obj) {
        if (adds.m2755() >= 0) {
            return C0398od.m7606(obj);
        }
        return null;
    }

    public static String m9961() {
        if (C0458ze.m10932() >= 0) {
            return C0597.m11705();
        }
        return null;
    }

    public static String m9962() {
        if (C0449ye.m9220() <= 0) {
            return C0615.m13921();
        }
        return null;
    }

    public static List m9963(Object obj, int i) {
        if (abc.m1845() < 0) {
            return C0402oh.m7659(obj, i);
        }
        return null;
    }

    public static boolean m9964(Object obj, Object obj2) {
        if (C0449ye.m9220() < 0) {
            return C0095cz.m3433(obj, obj2);
        }
        return false;
    }

    public static String m9965(Object obj) {
        if (abf.m2510() < 0) {
            return ((C0187gj) obj).m534aW();
        }
        return null;
    }

    public static int m9966() {
        if (C0451yg.m9580() >= 0) {
            return C0607.m12983();
        }
        return 0;
    }

    public static String m9967() {
        if (C0449ye.m9220() < 0) {
            return C0601.m12299();
        }
        return null;
    }

    public static String m9968() {
        if (C0458ze.m10932() > 0) {
            return C0616.m14038();
        }
        return null;
    }

    public static String m9969(Object obj) {
        if (m10013() > 0) {
            return C0274jp.m5295(obj);
        }
        return null;
    }

    public static byte m9970(Object obj, long j) {
        if (C0458ze.m10932() > 0) {
            return ((C0409oo) obj).m1386i(j);
        }
        return (byte) 0;
    }

    public static InterfaceC0024aj m9971() {
        if (C0452yh.m9798() >= 0) {
            return C0604.m12626();
        }
        return null;
    }

    public static InterfaceC0385nr m9972(Object obj) {
        if (C0456zb.m10326() < 0) {
            return C0308kw.m5938(obj);
        }
        return null;
    }

    public static InterfaceC0245in m9973(Object obj, Object obj2) {
        if (abe.m2308() <= 0) {
            return C0617.m14133(obj, obj2);
        }
        return null;
    }

    public static void m9974(Object obj, Object obj2) {
        if (C0448yd.m9079() < 0) {
            C0606.m12843(obj, obj2);
        }
    }

    public static String m9975() {
        if (C0457zc.m10735() <= 0) {
            return C0597.m11664();
        }
        return null;
    }

    public static long m9976(long j) {
        if (abe.m2308() < 0) {
            return C0611.m13357(j);
        }
        return 0L;
    }

    public static boolean m9977(Object obj) {
        if (abc.m1845() <= 0) {
            return C0600.m12041(obj);
        }
        return false;
    }

    public static InterfaceC0277js m9978(Object obj) {
        if (abf.m2510() < 0) {
            return C0352ml.m6529(obj);
        }
        return null;
    }

    public static void m9979(Object obj) {
        if (adds.m2755() >= 0) {
            C0603.m12447(obj);
        }
    }

    public static Typeface m9980(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return ((TextView) obj).getTypeface();
        }
        return null;
    }

    public static Certificate[] m9981(Object obj) {
        if (abe.m2308() < 0) {
            return ((SSLSession) obj).getLocalCertificates();
        }
        return null;
    }

    public static String m9982(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return String.valueOf(obj);
        }
        return null;
    }

    public static String m9983() {
        if (C0448yd.m9079() < 0) {
            return C0612.m1524();
        }
        return null;
    }

    public static EnumC0154fd m9984() {
        if (C0459zf.m11062() >= 0) {
            return C0597.m11753();
        }
        return null;
    }

    public static AbstractC0292kg m9985(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return C0616.m14029(obj);
        }
        return null;
    }

    public static String m9986(Object obj, Object obj2) {
        if (abf.m2510() <= 0) {
            return C0615.m13865(obj, obj2);
        }
        return null;
    }

    public static String m9987() {
        if (adds.m2755() > 0) {
            return C0602.m12356();
        }
        return null;
    }

    public static String m9988() {
        if (gggy.m4269() <= 0) {
            return C0612.m13563();
        }
        return null;
    }

    public static C0412or m9989() {
        if (m10013() > 0) {
            return C0347mg.f1071rj;
        }
        return null;
    }

    public static int m9990(Object obj) {
        if (C0447yc.m8635() > 0) {
            return ((String) obj).length();
        }
        return 0;
    }

    public static int m9991(Object obj) {
        if (C0449ye.m9220() < 0) {
            return C0057bo.m3122(obj);
        }
        return 0;
    }

    public static long m9992(Object obj) {
        if (C0445ya.m8222() > 0) {
            return C0290ke.m5668(obj);
        }
        return 0L;
    }

    public static boolean m9993(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return C0613.m13684(obj);
        }
        return false;
    }

    public static void m9994(Object obj, Object obj2, Object obj3, Object obj4, Object obj5, Object obj6) {
        if (C0451yg.m9580() >= 0) {
            C0608.m13157(obj, obj2, obj3, obj4, obj5, obj6);
        }
    }

    public static EnumC0154fd m9995() {
        if (C0452yh.m9798() >= 0) {
            return C0606.m12814();
        }
        return null;
    }

    public static int m9996() {
        if (C0449ye.m9220() < 0) {
            return C0612.m13484();
        }
        return 0;
    }

    public static Throwable m9997(Object obj, Object obj2) {
        if (C0452yh.m9798() > 0) {
            return C0613.m13648(obj, obj2);
        }
        return null;
    }

    public static String m9998() {
        if (C0456zb.m10326() <= 0) {
            return C0615.m13914();
        }
        return null;
    }

    public static String m9999(Object obj) {
        if (C0458ze.m10932() > 0) {
            return C0617.m14214(obj);
        }
        return null;
    }

    public static long m10000(Object obj) {
        if (m10013() >= 0) {
            return ((C0430pi) obj).mo1425fW();
        }
        return 0L;
    }

    public static C0291kf m10001(Object obj, boolean z) {
        if (adds.m2755() >= 0) {
            return ((InterfaceC0324ll) obj).mo1051m(z);
        }
        return null;
    }

    public static int m10002(Object obj) {
        if (m10013() > 0) {
            return C0613.m13699(obj);
        }
        return 0;
    }

    public static AbstractC0148ey m10003() {
        if (C0451yg.m9580() > 0) {
            return C0614.m13826();
        }
        return null;
    }

    public static String m10004() {
        if (m10013() >= 0) {
            return C0605.m12773();
        }
        return null;
    }

    public static C0253iv m10005(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return C0612.m13550(obj);
        }
        return null;
    }

    public static void m10006(Object obj) {
        if (gggy.m4269() < 0) {
            C0611.m13437(obj);
        }
    }

    public static XmlResourceParser m10007(Object obj, Object obj2) {
        if (C0457zc.m10735() < 0) {
            return C0597.m11727(obj, obj2);
        }
        return null;
    }

    public static WildcardType m10008(Object obj) {
        if (gggy.m4269() <= 0) {
            return C0612.m13474(obj);
        }
        return null;
    }

    public static byte[] m10009(Object obj) {
        if (C0450yf.m9352() < 0) {
            return ((InetAddress) obj).getAddress();
        }
        return null;
    }

    public static C0279ju m10010(Object obj) {
        if (C0445ya.m8222() > 0) {
            return ((C0281jw) obj).m833cW();
        }
        return null;
    }

    public static C0278jt m10011(Object obj) {
        if (C0449ye.m9220() < 0) {
            return ((AbstractC0292kg) obj).mo918cg();
        }
        return null;
    }

    public static TrustManagerFactory m10012(Object obj) {
        if (abe.m2308() < 0) {
            return TrustManagerFactory.getInstance((String) obj);
        }
        return null;
    }

    public static int m10013() {
        return (-29) ^ C0445ya.f1431;
    }

    public static String m10014() {
        if (C0446yb.m8415() <= 0) {
            return C0597.m11724();
        }
        return null;
    }

    public static long m10015(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return ((AbstractC0292kg) obj).mo917cf();
        }
        return 0L;
    }

    public static String m10016() {
        if (abc.m1845() < 0) {
            return C0610.m13290();
        }
        return null;
    }

    public static String m10017() {
        if (C0461zs.m11510() <= 0) {
            return C0617.m14218();
        }
        return null;
    }

    public static void m10018(Object obj, Object obj2) {
        if (C0461zs.m11510() <= 0) {
            C0610.m13209(obj, obj2);
        }
    }

    public static String m10019() {
        if (C0461zs.m11510() < 0) {
            return C0608.m13171();
        }
        return null;
    }

    public static String m10020() {
        if (C0452yh.m9798() >= 0) {
            return C0597.m11706();
        }
        return null;
    }

    public static Set m10021(Object obj) {
        if (C0446yb.m8415() < 0) {
            return C0603.m12437(obj);
        }
        return null;
    }

    public static String m10022() {
        if (C0452yh.m9798() > 0) {
            return C0615.m13944();
        }
        return null;
    }

    public static boolean m10023(Object obj, Object obj2) {
        if (C0457zc.m10735() < 0) {
            return ((String) obj).matches((String) obj2);
        }
        return false;
    }

    public static C0409oo m10024(Object obj, int i) {
        if (C0448yd.m9079() < 0) {
            return C0600.m12148(obj, i);
        }
        return null;
    }

    public static AbstractC0363mw m10025(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return C0354mn.m6632(obj);
        }
        return null;
    }

    public static C0247ip m10026(Object obj) {
        if (m10013() > 0) {
            return C0239ih.m4863(obj);
        }
        return null;
    }

    public static void m10027(Object obj, int i, Object obj2, Object obj3) {
        if (C0456zb.m10326() < 0) {
            C0354mn.m6643(obj, i, obj2, obj3);
        }
    }

    public static String m10028() {
        if (C0450yf.m9352() < 0) {
            return C0617.m14193();
        }
        return null;
    }

    public static String m10029() {
        if (C0446yb.m8415() <= 0) {
            return C0601.m12199();
        }
        return null;
    }

    public static HostnameVerifier m10030(Object obj) {
        if (gggy.m4269() <= 0) {
            return C0279ju.m5385(obj);
        }
        return null;
    }

    public static String m10031() {
        if (C0448yd.m9079() < 0) {
            return C0606.m12897();
        }
        return null;
    }

    public static int m10032() {
        if (abe.m2308() <= 0) {
            return C0608.m13174();
        }
        return 0;
    }

    public static boolean m10033(Object obj) {
        if (C0452yh.m9798() > 0) {
            return C0604.m12690(obj);
        }
        return false;
    }

    public static AbstractC0148ey m10034() {
        if (gggy.m4269() <= 0) {
            return AbstractC0148ey.m3751();
        }
        return null;
    }

    public static int m10035(Object obj, int i, int i2, Object obj2) {
        if (abe.m2308() <= 0) {
            return C0298km.m933a((String) obj, i, i2, (String) obj2);
        }
        return 0;
    }

    public static C0155fe m10036(Object obj) {
        if (C0445ya.m8222() > 0) {
            return ((C0155fe) obj).mo361ac();
        }
        return null;
    }

    public static String m10037() {
        if (C0451yg.m9580() > 0) {
            return C0617.m14138();
        }
        return null;
    }

    public static boolean m10038(Object obj) {
        if (abf.m2510() < 0) {
            return C0332lt.m6184(obj);
        }
        return false;
    }
}
