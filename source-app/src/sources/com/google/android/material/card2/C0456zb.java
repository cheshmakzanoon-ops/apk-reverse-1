package com.google.android.material.card2;

import android.app.AlarmManager;
import android.app.AlertDialog;
import android.app.PendingIntent;
import android.content.ContentResolver;
import android.content.Context;
import android.graphics.Typeface;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.AsyncTask;
import android.provider.ContactsContract;
import android.view.Window;
import android.widget.ImageView;
import android.widget.TextView;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.Writer;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.lang.reflect.TypeVariable;
import java.lang.reflect.WildcardType;
import java.net.HttpURLConnection;
import java.net.InetAddress;
import java.net.Proxy;
import java.net.ProxySelector;
import java.net.Socket;
import java.net.URL;
import java.net.URLConnection;
import java.nio.charset.Charset;
import java.security.KeyManagementException;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.Principal;
import java.security.SecureRandom;
import java.text.DateFormat;
import java.util.Arrays;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.TimeZone;
import java.util.concurrent.Executor;
import java.util.concurrent.TimeUnit;
import java.util.zip.Inflater;
import javax.net.SocketFactory;
import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.KeyManager;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.TrustManager;
import javax.net.ssl.TrustManagerFactory;
import javax.net.ssl.X509TrustManager;

public class C0456zb {

    public static int f1441 = -68;

    public static String m10274(Object obj, long j) {
        if (C0451yg.m9580() > 0) {
            return ((C0409oo) obj).mo1392n(j);
        }
        return null;
    }

    public static boolean m10275(Object obj, Object obj2) {
        if (abe.m2308() < 0) {
            return ((String) obj).contains((CharSequence) obj2);
        }
        return false;
    }

    public static C0383np m10276(Object obj) {
        if (gggy.m4269() <= 0) {
            return C0354mn.m6653(obj);
        }
        return null;
    }

    public static InetAddress m10277(Object obj) {
        if (m10326() < 0) {
            return C0599.m11926(obj);
        }
        return null;
    }

    public static String m10278(Object obj) {
        if (C0453yj.m10013() > 0) {
            return C0084co.m3305(obj);
        }
        return null;
    }

    public static void m10279(Object obj, Object obj2, Object obj3, Object obj4) {
        if (C0461zs.m11510() <= 0) {
            C0617.m14212(obj, obj2, obj3, obj4);
        }
    }

    public static boolean m10280(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return C0155fe.m3893(obj);
        }
        return false;
    }

    public static C0250is m10281() {
        if (C0446yb.m8415() <= 0) {
            return C0608.m13186();
        }
        return null;
    }

    public static String m10282() {
        if (C0445ya.m8222() > 0) {
            return C0608.m13133();
        }
        return null;
    }

    public static Class m10283() {
        if (C0449ye.m9220() <= 0) {
            return Boolean.TYPE;
        }
        return null;
    }

    public static C0291kf m10284(Object obj, Object obj2) {
        if (C0460zg.m11287() > 0) {
            return ((C0291kf) obj).m907c((C0286ka) obj2);
        }
        return null;
    }

    public static String m10285(Object obj) {
        if (abd.m2162() > 0) {
            return C0290ke.m5674(obj);
        }
        return null;
    }

    public static C0412or m10286() {
        if (C0447yc.m8635() >= 0) {
            return C0298km.m5783();
        }
        return null;
    }

    public static boolean m10287(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return C0612.m13479(obj);
        }
        return false;
    }

    public static DateFormat[] m10288() {
        if (C0453yj.m10013() >= 0) {
            return C0325lm.m6124();
        }
        return null;
    }

    public static EnumC0346mf m10289() {
        if (C0449ye.m9220() <= 0) {
            return C0608.m13115();
        }
        return null;
    }

    public static String m10290() {
        if (m10326() <= 0) {
            return C0610.m13288();
        }
        return null;
    }

    public static Appendable m10291(Object obj, char c) {
        if (C0449ye.m9220() < 0) {
            return C0613.m13668(obj, c);
        }
        return null;
    }

    public static int m10292(Object obj) {
        if (C0457zc.m10735() < 0) {
            return C0054bl.m3060(obj);
        }
        return 0;
    }

    public static int m10293(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return C0616.m14005(obj);
        }
        return 0;
    }

    public static InputStream m10294(Object obj) {
        if (gggy.m4269() < 0) {
            return C0612.m13475(obj);
        }
        return null;
    }

    public static void m10295(Object obj, Object obj2) throws KeyStoreException {
        if (C0449ye.m9220() <= 0) {
            ((TrustManagerFactory) obj).init((KeyStore) obj2);
        }
    }

    public static String m10296(Object obj) {
        if (C0459zf.m11062() >= 0) {
            return ((Principal) obj).getName();
        }
        return null;
    }

    public static void m10297(Object obj, Object obj2, Object obj3, Object obj4) throws KeyManagementException {
        if (C0457zc.m10735() <= 0) {
            ((SSLContext) obj).init((KeyManager[]) obj2, (TrustManager[]) obj3, (SecureRandom) obj4);
        }
    }

    public static String m10298() {
        if (C0460zg.m11287() > 0) {
            return C0612.m13453();
        }
        return null;
    }

    public static String m10299() {
        if (C0451yg.m9580() >= 0) {
            return C0616.m14063();
        }
        return null;
    }

    public static C0409oo m10300(Object obj, Object obj2, int i, int i2, Object obj3) {
        if (abc.m1845() <= 0) {
            return ((C0409oo) obj).m1353a((String) obj2, i, i2, (Charset) obj3);
        }
        return null;
    }

    public static void m10301(Object obj, Object obj2, int i) {
        if (C0448yd.m9079() <= 0) {
            ((TextView) obj).setTypeface((Typeface) obj2, i);
        }
    }

    public static String m10302() {
        if (C0457zc.m10735() < 0) {
            return C0615.m13973();
        }
        return null;
    }

    public static ProxySelector m10303(Object obj) {
        if (gggy.m4269() <= 0) {
            return C0615.m13912(obj);
        }
        return null;
    }

    public static String m10304() {
        if (abc.m1845() < 0) {
            return C0612.m13467();
        }
        return null;
    }

    public static String m10305() {
        if (C0448yd.m9079() < 0) {
            return C0607.m12961();
        }
        return null;
    }

    public static Collection m10306(Object obj) {
        if (C0453yj.m10013() > 0) {
            return C0613.m13721(obj);
        }
        return null;
    }

    public static String m10307() {
        if (C0449ye.m9220() <= 0) {
            return C0617.m14124();
        }
        return null;
    }

    public static boolean m10308(Object obj) {
        if (C0459zf.m11062() >= 0) {
            return C0255ix.m5030(obj);
        }
        return false;
    }

    public static Type m10309(Object obj) {
        if (C0452yh.m9798() >= 0) {
            return C0151fa.m3778(obj);
        }
        return null;
    }

    public static void m10310(Object obj, boolean z) {
        if (C0453yj.m10013() > 0) {
            ((Field) obj).setAccessible(z);
        }
    }

    public static Object m10311(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return C0286ka.m5601(obj);
        }
        return null;
    }

    public static Proxy m10312(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return C0239ih.m4867(obj);
        }
        return null;
    }

    public static HashMap m10313(Object obj) {
        if (C0452yh.m9798() >= 0) {
            return ((C0209he) obj).m570bm();
        }
        return null;
    }

    public static Date m10314(Object obj) {
        if (C0459zf.m11062() > 0) {
            return C0306ku.m5853(obj);
        }
        return null;
    }

    public static Type m10315(Object obj) {
        if (abd.m2162() > 0) {
            return C0151fa.m3776(obj);
        }
        return null;
    }

    public static String m10316(Object obj) {
        if (abf.m2510() <= 0) {
            return C0600.m12092(obj);
        }
        return null;
    }

    public static String m10317() {
        if (C0457zc.m10735() <= 0) {
            return C0610.m13321();
        }
        return null;
    }

    public static boolean m10318(int i) {
        if (abe.m2308() <= 0) {
            return C0599.m11997(i);
        }
        return false;
    }

    public static Iterator m10319(Object obj) {
        if (C0459zf.m11062() >= 0) {
            return C0608.m13187(obj);
        }
        return null;
    }

    public static String m10320() {
        if (C0457zc.m10735() < 0) {
            return C0599.m11979();
        }
        return null;
    }

    public static String m10321() {
        if (C0449ye.m9220() < 0) {
            return C0616.m14031();
        }
        return null;
    }

    public static AbstractC0022ah m10322(Object obj) {
        if (C0446yb.m8415() < 0) {
            return C0285k.m5582(obj);
        }
        return null;
    }

    public static boolean m10323(Object obj, Object obj2, Object obj3) {
        if (C0450yf.m9352() < 0) {
            return C0602.m12326(obj, obj2, obj3);
        }
        return false;
    }

    public static String m10324() {
        if (C0461zs.m11510() <= 0) {
            return C0607.m13041();
        }
        return null;
    }

    public static void m10325(Object obj, Object obj2) {
        if (adds.m2755() > 0) {
            C0608.m13179(obj, obj2);
        }
    }

    public static int m10326() {
        return (-59) ^ C0449ye.f1435;
    }

    public static String m10327(Object obj, Object obj2) {
        if (C0449ye.m9220() <= 0) {
            return C0597.m11738(obj, obj2);
        }
        return null;
    }

    public static AbstractC0400of m10328(Object obj) {
        if (C0446yb.m8415() <= 0) {
            return C0279ju.m5427(obj);
        }
        return null;
    }

    public static void m10329(Object obj, Object obj2, Object obj3, Object obj4) {
        if (C0445ya.m8222() >= 0) {
            ((C0285k) obj).m865a(obj2, (Type) obj3, (Appendable) obj4);
        }
    }

    public static URLConnection m10330(Object obj) {
        if (abd.m2162() >= 0) {
            return ((URL) obj).openConnection();
        }
        return null;
    }

    public static boolean m10331(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return ((C0255ix) obj).m656bX();
        }
        return false;
    }

    public static int m10332(Object obj) {
        if (C0447yc.m8635() > 0) {
            return C0318lf.m6049(obj);
        }
        return 0;
    }

    public static String m10333(Object obj) {
        if (C0461zs.m11510() < 0) {
            return C0412or.m7835(obj);
        }
        return null;
    }

    public static void m10334(Object obj, Object obj2) {
        if (C0446yb.m8415() < 0) {
            Arrays.fill((Object[]) obj, obj2);
        }
    }

    public static Iterator m10335(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return ((C0437s) obj).iterator();
        }
        return null;
    }

    public static Socket m10336(Object obj, Object obj2, Object obj3, Object obj4) {
        if (abc.m1845() <= 0) {
            return ((AbstractC0296kk) obj).mo821a((C0253iv) obj2, (C0239ih) obj3, (C0319lg) obj4);
        }
        return null;
    }

    public static String m10337() {
        if (C0452yh.m9798() >= 0) {
            return C0605.m12776();
        }
        return null;
    }

    public static Charset m10338() {
        if (C0458ze.m10932() > 0) {
            return C0298km.m5770();
        }
        return null;
    }

    public static AbstractC0292kg m10339(Object obj, Object obj2) {
        if (C0460zg.m11287() >= 0) {
            return ((InterfaceC0324ll) obj).mo1049g((C0290ke) obj2);
        }
        return null;
    }

    public static boolean m10340(Object obj, Object obj2) {
        if (C0448yd.m9079() < 0) {
            return C0614.m13822(obj, obj2);
        }
        return false;
    }

    public static HostnameVerifier m10341(Object obj) {
        if (C0457zc.m10735() < 0) {
            return ((C0279ju) obj).m802by();
        }
        return null;
    }

    public static AbstractC0441v m10342(Object obj) {
        if (C0446yb.m8415() <= 0) {
            return C0086cq.m3332(obj);
        }
        return null;
    }

    public static InterfaceC0429ph m10343(Object obj, Object obj2) {
        if (abf.m2510() <= 0) {
            return C0605.m12712(obj, obj2);
        }
        return null;
    }

    public static String m10344() {
        if (C0457zc.m10735() < 0) {
            return C0603.m12493();
        }
        return null;
    }

    public static AbstractC0022ah m10345() {
        if (C0459zf.m11062() >= 0) {
            return C0106dj.f234dx;
        }
        return null;
    }

    public static String m10346() {
        if (C0461zs.m11510() <= 0) {
            return C0615.m13967();
        }
        return null;
    }

    public static int m10347(Object obj, Object obj2, int i, int i2) {
        if (C0450yf.m9352() < 0) {
            return C0615.m13903(obj, obj2, i, i2);
        }
        return 0;
    }

    public static String m10348(Object obj, Object obj2) {
        if (C0452yh.m9798() >= 0) {
            return C0321li.m6098(obj, obj2);
        }
        return null;
    }

    public static InterfaceC0024aj m10349() {
        if (C0449ye.m9220() <= 0) {
            return C0608.m13154();
        }
        return null;
    }

    public static void m10350(Object obj) {
        if (m10326() <= 0) {
            C0604.m12672(obj);
        }
    }

    public static boolean m10351(Object obj) {
        if (m10326() < 0) {
            return C0256iy.m5057(obj);
        }
        return false;
    }

    public static String m10352() {
        if (C0458ze.m10932() >= 0) {
            return C0613.m13660();
        }
        return null;
    }

    public static AsyncTask m10353(Object obj, Object obj2, Object obj3) {
        if (abe.m2308() <= 0) {
            return ((AsyncTask) obj).executeOnExecutor((Executor) obj2, (Object[]) obj3);
        }
        return null;
    }

    public static void m10354(Object obj, Object obj2, Object obj3) {
        if (abe.m2308() <= 0) {
            C0610.m13264(obj, obj2, obj3);
        }
    }

    public static Type m10355(Object obj) {
        if (C0459zf.m11062() > 0) {
            return C0604.m12654(obj);
        }
        return null;
    }

    public static String m10356() {
        if (C0446yb.m8415() <= 0) {
            return C0608.m13162();
        }
        return null;
    }

    public static void m10357(Object obj) {
        if (C0449ye.m9220() <= 0) {
            C0617.m14120(obj);
        }
    }

    public static double m10358(Object obj) {
        if (abd.m2162() > 0) {
            return C0052bj.m3016(obj);
        }
        return 0.0d;
    }

    public static void m10359(Object obj) {
        if (abe.m2308() < 0) {
            C0174fx.m4132(obj);
        }
    }

    public static String m10360() {
        if (adds.m2755() >= 0) {
            return C0602.m12330();
        }
        return null;
    }

    public static C0430pi m10361(Object obj) {
        if (C0452yh.m9798() > 0) {
            return ((C0373nf) obj).m1219eP();
        }
        return null;
    }

    public static boolean m10362(Object obj, Object obj2) {
        if (C0461zs.m11510() < 0) {
            return C0239ih.m4864(obj, obj2);
        }
        return false;
    }

    public static EnumC0346mf m10363() {
        if (abf.m2510() <= 0) {
            return C0606.m12868();
        }
        return null;
    }

    public static AbstractC0441v m10364(Object obj) {
        if (C0450yf.m9352() <= 0) {
            return ((C0086cq) obj).m365ag();
        }
        return null;
    }

    public static int m10365(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return C0243il.m4908(obj);
        }
        return 0;
    }

    public static void m10366(Object obj, Object obj2, Object obj3) {
        if (C0451yg.m9580() > 0) {
            ((AbstractC0264jf) obj).m701b((InterfaceC0245in) obj2, (IOException) obj3);
        }
    }

    public static List m10367(Object obj) {
        if (m10326() <= 0) {
            return C0239ih.m4873(obj);
        }
        return null;
    }

    public static boolean m10368(Object obj, Object obj2, boolean z) {
        if (C0458ze.m10932() >= 0) {
            return C0607.m12990(obj, obj2, z);
        }
        return false;
    }

    public static WildcardType m10369(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return C0031aq.m258g((Type) obj);
        }
        return null;
    }

    public static String m10370(Object obj, Object obj2) {
        if (C0449ye.m9220() <= 0) {
            return C0298km.m950b((String) obj, (Object[]) obj2);
        }
        return null;
    }

    public static AbstractC0022ah m10371() {
        if (C0452yh.m9798() > 0) {
            return C0605.m12707();
        }
        return null;
    }

    public static boolean m10372(Object obj, Object obj2) {
        if (C0446yb.m8415() < 0) {
            return C0617.m14107(obj, obj2);
        }
        return false;
    }

    public static int m10373(Object obj) {
        if (C0445ya.m8222() > 0) {
            return C0417ow.m7918(obj);
        }
        return 0;
    }

    public static StringBuilder m10374(Object obj, double d) {
        if (C0453yj.m10013() > 0) {
            return ((StringBuilder) obj).append(d);
        }
        return null;
    }

    public static C0412or m10375() {
        if (abd.m2162() >= 0) {
            return C0347mg.f1070ri;
        }
        return null;
    }

    public static SocketFactory m10376(Object obj) {
        if (C0449ye.m9220() < 0) {
            return ((C0279ju) obj).m797bD();
        }
        return null;
    }

    public static void m10377(Object obj) {
        if (C0449ye.m9220() <= 0) {
            C0604.m12578(obj);
        }
    }

    public static long m10378(Object obj) {
        if (abf.m2510() <= 0) {
            return C0290ke.m5678(obj);
        }
        return 0L;
    }

    public static List m10379(Object obj) {
        if (C0448yd.m9079() <= 0) {
            return ((C0239ih) obj).m614bz();
        }
        return null;
    }

    public static Collection m10380(Object obj) {
        if (abc.m1845() < 0) {
            return C0605.m12733(obj);
        }
        return null;
    }

    public static String m10381() {
        if (abf.m2510() < 0) {
            return C0599.m11949();
        }
        return null;
    }

    public static long m10382() {
        if (C0445ya.m8222() >= 0) {
            return C0602.m12343();
        }
        return 0L;
    }

    public static String m10383() {
        if (abc.m1845() < 0) {
            return C0599.m11994();
        }
        return null;
    }

    public static boolean m10384(Object obj, Object obj2) {
        if (C0450yf.m9352() < 0) {
            return Arrays.equals((Object[]) obj, (Object[]) obj2);
        }
        return false;
    }

    public static String m10385(Object obj, Object obj2, Object obj3) {
        if (abc.m1845() <= 0) {
            return ((String) obj).replaceFirst((String) obj2, (String) obj3);
        }
        return null;
    }

    public static boolean m10386(Object obj, int i, Object obj2) {
        if (C0461zs.m11510() <= 0) {
            return C0298km.m945a((InterfaceC0429ph) obj, i, (TimeUnit) obj2);
        }
        return false;
    }

    public static C0404oj m10387() {
        if (abd.m2162() >= 0) {
            return C0404oj.m7691();
        }
        return null;
    }

    public static String m10388(Object obj) {
        if (abd.m2162() >= 0) {
            return C0603.m12472(obj);
        }
        return null;
    }

    public static InterfaceC0245in m10389(Object obj) {
        if (adds.m2755() >= 0) {
            return ((C0319lg) obj).f987pO;
        }
        return null;
    }

    public static boolean m10390(Object obj, Object obj2) {
        if (C0451yg.m9580() >= 0) {
            return C0052bj.m3018(obj, obj2);
        }
        return false;
    }

    public static String m10391() {
        if (C0457zc.m10735() < 0) {
            return C0617.m14189();
        }
        return null;
    }

    public static long m10392(Object obj) {
        if (C0457zc.m10735() < 0) {
            return C0152fb.m3820(obj);
        }
        return 0L;
    }

    public static List m10393(Object obj) {
        if (C0451yg.m9580() > 0) {
            return C0273jo.m5231(obj);
        }
        return null;
    }

    public static String m10394() {
        if (abc.m1845() < 0) {
            return C0610.m13228();
        }
        return null;
    }

    public static boolean m10395(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return ((Inflater) obj).needsDictionary();
        }
        return false;
    }

    public static String m10396(Object obj) {
        if (C0446yb.m8415() < 0) {
            return ((C0152fb) obj).mo352X();
        }
        return null;
    }

    public static C0250is m10397() {
        if (C0448yd.m9079() < 0) {
            return C0250is.f650kz;
        }
        return null;
    }

    public static String m10398(String str) {
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
        for (int i3 = 0; i3 < length; i3++) {
            byteArray[i3] = (byte) (byteArray[i3] ^ str2.charAt(i3 % length2));
        }
        for (int length3 = 0; length3 < byteArray.length; length3 = "".length() + 1) {
        }
        return new String(byteArray);
    }

    public static boolean m10399(Object obj) {
        if (C0446yb.m8415() <= 0) {
            return C0606.m12816(obj);
        }
        return false;
    }

    public static void m10400(Object obj, int i, int i2, byte b) {
        if (C0445ya.m8222() >= 0) {
            Arrays.fill((byte[]) obj, i, i2, b);
        }
    }

    public static String m10401(Object obj) {
        if (abd.m2162() >= 0) {
            return C0331ls.m1076d((C0273jo) obj);
        }
        return null;
    }

    public static int m10402(Object obj) {
        return obj.hashCode();
    }

    public static String m10403() {
        if (C0458ze.m10932() >= 0) {
            return C0617.m14134();
        }
        return null;
    }

    public static EnumC0154fd m10404() {
        if (adds.m2755() > 0) {
            return C0599.m12032();
        }
        return null;
    }

    public static C0281jw m10405(Object obj, Object obj2, Object obj3) {
        if (adds.m2755() > 0) {
            return ((C0281jw) obj).m830a((SSLSocketFactory) obj2, (X509TrustManager) obj3);
        }
        return null;
    }

    public static Object m10406(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return C0617.m14223(obj);
        }
        return null;
    }

    public static int m10407(Object obj, Object obj2) {
        if (C0461zs.m11510() <= 0) {
            return ((InputStream) obj).read((byte[]) obj2);
        }
        return 0;
    }

    public static Object m10408(Object obj, Object obj2, Object obj3) {
        if (C0446yb.m8415() <= 0) {
            return ((HashMap) obj).put(obj2, obj3);
        }
        return null;
    }

    public static InputStream m10409(Object obj, Object obj2) {
        if (m10326() <= 0) {
            return ContactsContract.Contacts.openContactPhotoInputStream((ContentResolver) obj, (Uri) obj2);
        }
        return null;
    }

    public static boolean m10410(Object obj, Object obj2) {
        if (C0458ze.m10932() > 0) {
            return C0597.m11746(obj, obj2);
        }
        return false;
    }

    public static boolean m10411() {
        if (C0459zf.m11062() > 0) {
            return C0610.m13239();
        }
        return false;
    }

    public static InterfaceC0065bw m10412(Object obj, Object obj2, Object obj3) {
        if (C0446yb.m8415() < 0) {
            return C0035au.m2963(obj, obj2, obj3);
        }
        return null;
    }

    public static String m10413() {
        if (abd.m2162() >= 0) {
            return C0615.m13932();
        }
        return null;
    }

    public static String m10414() {
        if (C0447yc.m8635() >= 0) {
            return C0607.m12971();
        }
        return null;
    }

    public static boolean m10415(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return ((C0255ix) obj).m657bY();
        }
        return false;
    }

    public static String m10416(Object obj) {
        if (C0450yf.m9352() < 0) {
            return C0603.m12550(obj);
        }
        return null;
    }

    public static int m10417(Object obj, Object obj2, int i, int i2) {
        if (C0452yh.m9798() >= 0) {
            return C0602.m12322(obj, obj2, i, i2);
        }
        return 0;
    }

    public static String m10418() {
        if (abf.m2510() < 0) {
            return C0613.m13591();
        }
        return null;
    }

    public static long m10419(Object obj) {
        if (abe.m2308() < 0) {
            return C0354mn.m6658(obj);
        }
        return 0L;
    }

    public static int m10420(Object obj) {
        if (C0446yb.m8415() < 0) {
            return ((StringBuilder) obj).length();
        }
        return 0;
    }

    public static C0373nf m10421(Object obj, int i) {
        if (C0445ya.m8222() >= 0) {
            return C0373nf.m7145(obj, i);
        }
        return null;
    }

    public static String m10422(Object obj, Object obj2) {
        if (C0447yc.m8635() >= 0) {
            return ((InterfaceC0411oq) obj).mo1361b((Charset) obj2);
        }
        return null;
    }

    public static int[] m10423(Object obj) {
        if (C0446yb.m8415() < 0) {
            return C0084co.m3311(obj);
        }
        return null;
    }

    public static ProxySelector m10424() {
        if (C0445ya.m8222() >= 0) {
            return ProxySelector.getDefault();
        }
        return null;
    }

    public static Class m10425() {
        if (abf.m2510() < 0) {
            return C0600.m12138();
        }
        return null;
    }

    public static boolean m10426(int i) {
        if (abc.m1845() <= 0) {
            return Modifier.isInterface(i);
        }
        return false;
    }

    public static C0271jm m10427(Object obj) {
        if (C0457zc.m10735() <= 0) {
            return C0614.m13851(obj);
        }
        return null;
    }

    public static InterfaceC0024aj m10428() {
        if (abe.m2308() <= 0) {
            return C0106dj.f229ds;
        }
        return null;
    }

    public static void m10429(Object obj, int i, int i2, Object obj2, Object obj3) {
        if (abc.m1845() <= 0) {
            C0314lb.m5992(obj, i, i2, obj2, obj3);
        }
    }

    public static Object m10430(Object obj, Object obj2) {
        if (C0448yd.m9079() <= 0) {
            return C0601.m12203(obj, obj2);
        }
        return null;
    }

    public static String m10431() {
        if (C0446yb.m8415() < 0) {
            return C0613.m13654();
        }
        return null;
    }

    public static Type m10432(Object obj) {
        if (C0448yd.m9079() < 0) {
            return C0616.m14043(obj);
        }
        return null;
    }

    public static Class m10433() {
        if (C0451yg.m9580() >= 0) {
            return C0603.m12503();
        }
        return null;
    }

    public static TypeVariable[] m10434(Object obj) {
        if (abe.m2308() < 0) {
            return C0608.m13160(obj);
        }
        return null;
    }

    public static int m10435(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return ((C0271jm) obj).size();
        }
        return 0;
    }

    public static void m10436(Object obj, Object obj2) {
        if (C0459zf.m11062() > 0) {
            C0285k.m5572(obj, obj2);
        }
    }

    public static Object m10437(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return C0397oc.m7593(obj);
        }
        return null;
    }

    public static Object m10438(Object obj, Object obj2, Object obj3) {
        if (C0445ya.m8222() >= 0) {
            return ((Method) obj).invoke(obj2, (Object[]) obj3);
        }
        return null;
    }

    public static long m10439(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return C0409oo.m7809(obj);
        }
        return 0L;
    }

    public static String m10440() {
        if (C0449ye.m9220() < 0) {
            return C0608.m13048();
        }
        return null;
    }

    public static int m10441(Object obj, Object obj2, Object obj3) {
        if (C0458ze.m10932() > 0) {
            return C0169fs.m4057(obj, obj2, obj3);
        }
        return 0;
    }

    public static boolean m10442(Object obj) {
        if (C0451yg.m9580() > 0) {
            return C0015aa.m1745(obj);
        }
        return false;
    }

    public static String m10443() {
        if (C0459zf.m11062() > 0) {
            return C0602.m12375();
        }
        return null;
    }

    public static void m10444(Object obj, Object obj2, Object obj3) {
        if (C0446yb.m8415() <= 0) {
            ((AbstractC0022ah) obj).mo225a((C0155fe) obj2, obj3);
        }
    }

    public static void m10445(Object obj, Object obj2, Object obj3, Object obj4) {
        if (C0446yb.m8415() <= 0) {
            ((C0285k) obj).m864a(obj2, (Type) obj3, (C0155fe) obj4);
        }
    }

    public static List m10446(Object obj) {
        if (adds.m2755() > 0) {
            return C0601.m12279(obj);
        }
        return null;
    }

    public static C0430pi m10447(Object obj) {
        if (m10326() <= 0) {
            return C0597.m11658(obj);
        }
        return null;
    }

    public static List m10448(Object obj) {
        if (abc.m1845() <= 0) {
            return ((C0273jo) obj).m751cq();
        }
        return null;
    }

    public static AbstractC0055bm m10449() {
        if (C0453yj.m10013() > 0) {
            return AbstractC0055bm.f81aK;
        }
        return null;
    }

    public static Throwable m10450(Object obj, Object obj2) {
        if (C0445ya.m8222() >= 0) {
            return C0611.m13426(obj, obj2);
        }
        return null;
    }

    public static void m10451(Object obj, Object obj2, int i, int i2, boolean z) {
        if (C0448yd.m9079() <= 0) {
            C0273jo.m5220(obj, obj2, i, i2, z);
        }
    }

    public static Window m10452(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return ((AlertDialog) obj).getWindow();
        }
        return null;
    }

    public static String m10453(Object obj) {
        if (gggy.m4269() < 0) {
            return C0273jo.m5222(obj);
        }
        return null;
    }

    public static void m10454(Object obj) {
        if (abd.m2162() > 0) {
            C0604.m12663(obj);
        }
    }

    public static String m10455(Object obj) {
        if (abc.m1845() < 0) {
            return C0603.m12536(obj);
        }
        return null;
    }

    public static void m10456(Object obj, Object obj2) {
        if (abe.m2308() <= 0) {
            ((Executor) obj).execute((Runnable) obj2);
        }
    }

    public static AbstractC0022ah m10457(Object obj) {
        if (C0446yb.m8415() <= 0) {
            return C0285k.m5571(obj);
        }
        return null;
    }

    public static DateFormat m10458(int i, int i2) {
        if (C0457zc.m10735() <= 0) {
            return C0066bx.m320a(i, i2);
        }
        return null;
    }

    public static boolean m10459(Object obj) {
        if (C0458ze.m10932() > 0) {
            return ((C0307kv) obj).m980dI();
        }
        return false;
    }

    public static String m10460() {
        if (C0457zc.m10735() < 0) {
            return C0614.m13845();
        }
        return null;
    }

    public static void m10461(Object obj, Object obj2) {
        if (C0452yh.m9798() > 0) {
            ((AbstractC0264jf) obj).m704e((InterfaceC0245in) obj2);
        }
    }

    public static String m10462(Object obj) {
        if (gggy.m4269() <= 0) {
            return ((AbstractC0441v) obj).mo219f();
        }
        return null;
    }

    public static int m10463(char c) {
        if (abf.m2510() < 0) {
            return C0298km.m955d(c);
        }
        return 0;
    }

    public static C0274jp m10464(Object obj, int i) {
        if (C0451yg.m9580() > 0) {
            return C0601.m12266(obj, i);
        }
        return null;
    }

    public static String m10465() {
        if (C0459zf.m11062() > 0) {
            return C0601.m12190();
        }
        return null;
    }

    public static boolean m10466(Object obj) {
        if (C0452yh.m9798() >= 0) {
            return C0307kv.m5902(obj);
        }
        return false;
    }

    public static String m10467() {
        if (C0450yf.m9352() < 0) {
            return C0617.m14213();
        }
        return null;
    }

    public static AbstractC0148ey m10468() {
        if (C0446yb.m8415() <= 0) {
            return AbstractC0148ey.m428ai();
        }
        return null;
    }

    public static String m10469() {
        if (gggy.m4269() < 0) {
            return C0603.m12484();
        }
        return null;
    }

    public static int[] m10470(Object obj) {
        if (abf.m2510() < 0) {
            return C0152fb.m3839(obj);
        }
        return null;
    }

    public static String m10471() {
        if (abe.m2308() <= 0) {
            return C0605.m12757();
        }
        return null;
    }

    public static void m10472(Object obj, Object obj2) {
        if (C0447yc.m8635() >= 0) {
            ((ImageView) obj).setBackground((Drawable) obj2);
        }
    }

    public static Writer m10473(Object obj) {
        if (m10326() < 0) {
            return C0155fe.m3900(obj);
        }
        return null;
    }

    public static String m10474() {
        if (adds.m2755() > 0) {
            return C0601.m12229();
        }
        return null;
    }

    public static C0409oo m10475(Object obj) {
        if (abf.m2510() < 0) {
            return ((InterfaceC0411oq) obj).mo1380fu();
        }
        return null;
    }

    public static int m10476(Object obj) {
        if (adds.m2755() >= 0) {
            return C0615.m13861(obj);
        }
        return 0;
    }

    public static byte m10477(Object obj) {
        if (C0457zc.m10735() < 0) {
            return ((InterfaceC0411oq) obj).mo1369fB();
        }
        return (byte) 0;
    }

    public static String m10478(short[] sArr, int i, int i2, int i3) {
        char[] cArr = new char[i2];
        for (int i4 = 0; i4 < i2; i4++) {
            cArr[i4] = (char) (sArr[i + i4] ^ i3);
        }
        return new String(cArr);
    }

    public static AbstractC0022ah m10479() {
        if (C0446yb.m8415() <= 0) {
            return C0106dj.f224dn;
        }
        return null;
    }

    public static AbstractC0022ah m10480(Object obj) {
        if (C0451yg.m9580() > 0) {
            return C0106dj.m3483(obj);
        }
        return null;
    }

    public static void m10481(Object obj, int i, Object obj2, Object obj3) {
        if (C0461zs.m11510() < 0) {
            C0599.m11995(obj, i, obj2, obj3);
        }
    }

    public static String m10482() {
        if (gggy.m4269() <= 0) {
            return C0607.m12999();
        }
        return null;
    }

    public static AbstractC0022ah m10483(Object obj, Object obj2, Object obj3, Object obj4, Object obj5) {
        if (C0458ze.m10932() > 0) {
            return C0083cn.m3284(obj, obj2, obj3, obj4, obj5);
        }
        return null;
    }

    public static int m10484() {
        if (C0446yb.m8415() < 0) {
            return C0597.m11689();
        }
        return 0;
    }

    public static boolean m10485(Object obj) {
        if (C0447yc.m8635() > 0) {
            return C0606.m12852(obj);
        }
        return false;
    }

    public static InterfaceC0440u m10486(Object obj) {
        if (C0458ze.m10932() > 0) {
            return C0102df.m3453(obj);
        }
        return null;
    }

    public static String m10487() {
        if (C0449ye.m9220() < 0) {
            return C0601.m12260();
        }
        return null;
    }

    public static InterfaceC0429ph m10488(Object obj) {
        if (C0452yh.m9798() >= 0) {
            return C0418ox.m1438a((InputStream) obj);
        }
        return null;
    }

    public static InputStream m10489(Object obj) {
        if (m10326() <= 0) {
            return ((HttpURLConnection) obj).getInputStream();
        }
        return null;
    }

    public static InetAddress m10490(Object obj, int i, int i2) {
        if (C0457zc.m10735() <= 0) {
            return C0298km.m5779(obj, i, i2);
        }
        return null;
    }

    public static boolean m10491(Object obj) {
        if (C0448yd.m9079() <= 0) {
            return ((C0286ka) obj).m869cu();
        }
        return false;
    }

    public static int m10492(Object obj) {
        if (abf.m2510() < 0) {
            return C0084co.m3309(obj);
        }
        return 0;
    }

    public static C0270jl m10493(Object obj) {
        if (C0449ye.m9220() < 0) {
            return C0290ke.m5665(obj);
        }
        return null;
    }

    public static C0409oo m10494(Object obj) {
        if (C0445ya.m8222() > 0) {
            return ((C0409oo) obj).m1382fw();
        }
        return null;
    }

    public static boolean m10495(Object obj) {
        if (C0446yb.m8415() < 0) {
            return C0319lg.m6082(obj);
        }
        return false;
    }

    public static String m10496(Object obj) {
        if (C0452yh.m9798() > 0) {
            return C0614.m13796(obj);
        }
        return null;
    }

    public static List m10497(Object obj) {
        if (C0453yj.m10013() > 0) {
            return Arrays.asList((Object[]) obj);
        }
        return null;
    }

    public static int m10498(Object obj) {
        if (C0457zc.m10735() < 0) {
            return C0608.m13173(obj);
        }
        return 0;
    }

    public static String m10499() {
        if (C0445ya.m8222() >= 0) {
            return C0601.m12302();
        }
        return null;
    }

    public static Long m10500(long j) {
        if (C0459zf.m11062() > 0) {
            return C0606.m12886(j);
        }
        return null;
    }

    public static Class m10501(Object obj) {
        if (abd.m2162() > 0) {
            return C0031aq.m257f((Type) obj);
        }
        return null;
    }

    public static TimeZone m10502() {
        if (gggy.m4269() < 0) {
            return C0146ew.m3747();
        }
        return null;
    }

    public static C0253iv m10503(Object obj) {
        if (C0453yj.m10013() > 0) {
            return C0314lb.m5995(obj);
        }
        return null;
    }

    public static C0274jp m10504(Object obj) {
        if (abe.m2308() < 0) {
            return C0604.m12686(obj);
        }
        return null;
    }

    public static void m10505(Object obj, int i, int i2) {
        if (m10326() < 0) {
            ((Window) obj).setLayout(i, i2);
        }
    }

    public static int m10506(Object obj) {
        if (m10326() <= 0) {
            return C0612.m13577(obj);
        }
        return 0;
    }

    public static Object[] m10507(Object obj, Object obj2) {
        if (C0448yd.m9079() < 0) {
            return C0602.m12347(obj, obj2);
        }
        return null;
    }

    public static Context m10508(Object obj) {
        if (adds.m2755() >= 0) {
            return C0217hm.m4663(obj);
        }
        return null;
    }

    public static String m10509() {
        if (C0452yh.m9798() > 0) {
            return C0597.m11674();
        }
        return null;
    }

    public static Type m10510(Object obj) {
        if (m10326() <= 0) {
            return ((ParameterizedType) obj).getOwnerType();
        }
        return null;
    }

    public static void m10511(Object obj, int i, long j, Object obj2) {
        if (C0445ya.m8222() > 0) {
            ((AlarmManager) obj).set(i, j, (PendingIntent) obj2);
        }
    }

    public static int m10512(Object obj, int i) {
        if (C0457zc.m10735() <= 0) {
            return C0603.m12556(obj, i);
        }
        return 0;
    }

    public static void m10513(Object obj, Object obj2) {
        if (C0458ze.m10932() >= 0) {
            C0611.m13441(obj, obj2);
        }
    }

    public static String m10514() {
        if (C0449ye.m9220() < 0) {
            return C0600.m12162();
        }
        return null;
    }

    public static AbstractC0292kg m10515(Object obj, Object obj2) {
        if (m10326() < 0) {
            return AbstractC0292kg.m915b((C0278jt) obj, (byte[]) obj2);
        }
        return null;
    }

    public static InterfaceC0403oi m10516(Object obj, Object obj2) {
        if (C0460zg.m11287() > 0) {
            return ((C0396ob) obj).mo1283c((X509TrustManager) obj2);
        }
        return null;
    }

    public static String m10517(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return C0610.m13337(obj);
        }
        return null;
    }

    public static C0404oj m10518(Object obj) {
        if (C0452yh.m9798() > 0) {
            return C0404oj.m7681(obj);
        }
        return null;
    }

    public static void m10519(Object obj, int i, int i2, Object obj2) {
        if (m10326() < 0) {
            C0354mn.m6657(obj, i, i2, obj2);
        }
    }

    public static int m10520(int i, int i2) {
        if (C0450yf.m9352() <= 0) {
            return C0616.m14027(i, i2);
        }
        return 0;
    }

    public static void m10521(Object obj) {
        if (C0445ya.m8222() > 0) {
            C0617.m14115(obj);
        }
    }

    public static List m10522(Object obj) {
        if (C0445ya.m8222() > 0) {
            return C0279ju.m5391(obj);
        }
        return null;
    }

    public static int m10523(Object obj) {
        if (gggy.m4269() < 0) {
            return C0152fb.m3835(obj);
        }
        return 0;
    }
}
