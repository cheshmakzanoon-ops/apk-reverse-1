package com.google.android.material.card2;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;
import android.view.LayoutInflater;
import android.widget.TextView;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.io.Writer;
import java.lang.reflect.Type;
import java.lang.reflect.WildcardType;
import java.net.Proxy;
import java.net.ProxySelector;
import java.net.Socket;
import java.nio.ByteOrder;
import java.nio.charset.Charset;
import java.security.Provider;
import java.security.Security;
import java.security.cert.Certificate;
import java.security.cert.X509Certificate;
import java.util.Calendar;
import java.util.Collection;
import java.util.Currency;
import java.util.Date;
import java.util.Deque;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import javax.net.SocketFactory;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.SSLSocketFactory;
import javax.security.auth.x500.X500Principal;

public class C0459zf {

    private static short[] f1359L = {-5616, -2101};

    public static int f1444 = 15;

    private static String m1516L(int i, int i2, int i3) {
        char[] cArr = new char[i2 - i];
        for (int i4 = 0; i4 < i2 - i; i4++) {
            cArr[i4] = (char) (f1359L[i + i4] ^ i3);
        }
        return new String(cArr);
    }

    public static void m10975(Object obj, boolean z) {
        if (C0456zb.m10326() < 0) {
            ((Calendar) obj).setLenient(z);
        }
    }

    public static String m10976() {
        if (C0445ya.m8222() > 0) {
            return C0604.m12566();
        }
        return null;
    }

    public static ProxySelector m10977(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return C0239ih.m4866(obj);
        }
        return null;
    }

    public static Object m10978(Object obj, Object obj2) {
        if (abf.m2510() <= 0) {
            return C0601.m12179(obj, obj2);
        }
        return null;
    }

    public static String m10979() {
        if (C0457zc.m10735() <= 0) {
            return C0604.m12673();
        }
        return null;
    }

    public static void m10980(Object obj, Object obj2) {
        if (C0446yb.m8415() <= 0) {
            C0608.m13050(obj, obj2);
        }
    }

    public static boolean m10981(Object obj) {
        if (C0458ze.m10932() > 0) {
            return C0257iz.m5088(obj);
        }
        return false;
    }

    public static AbstractC0292kg m10982(Object obj) {
        if (m11062() > 0) {
            return C0290ke.m5684(obj);
        }
        return null;
    }

    public static void m10983(Object obj, int i, int i2, int i3, boolean z, Object obj2, Object obj3) {
        if (m11062() > 0) {
            C0607.m12944(obj, i, i2, i3, z, obj2, obj3);
        }
    }

    public static AbstractC0022ah m10984() {
        if (C0457zc.m10735() < 0) {
            return C0106dj.f198cO;
        }
        return null;
    }

    public static String m10985() {
        if (C0447yc.m8635() > 0) {
            return C0597.m11783();
        }
        return null;
    }

    public static List m10986(Object obj) {
        if (abf.m2510() < 0) {
            return ((C0239ih) obj).m611bw();
        }
        return null;
    }

    public static Proxy m10987(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return ((C0239ih) obj).m604bA();
        }
        return null;
    }

    public static String m10988() {
        if (abe.m2308() < 0) {
            return C0611.m13371();
        }
        return null;
    }

    public static String m10989(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return ((C0187gj) obj).m537aZ();
        }
        return null;
    }

    public static SharedPreferences.Editor m10990(Object obj, Object obj2, int i) {
        if (C0457zc.m10735() <= 0) {
            return C0599.m11936(obj, obj2, i);
        }
        return null;
    }

    public static String m10991() {
        if (C0450yf.m9352() < 0) {
            return C0606.m12882();
        }
        return null;
    }

    public static String m10992() {
        if (C0461zs.m11510() <= 0) {
            return C0616.m14069();
        }
        return null;
    }

    public static void m10993(Object obj, boolean z) {
        if (C0449ye.m9220() <= 0) {
            ((Thread) obj).setDaemon(z);
        }
    }

    public static String[] m10994(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return C0256iy.m5050(obj);
        }
        return null;
    }

    public static InterfaceC0259ja m10995() {
        if (C0450yf.m9352() <= 0) {
            return InterfaceC0259ja.f686lr;
        }
        return null;
    }

    public static C0291kf m10996(Object obj, Object obj2) {
        if (C0445ya.m8222() > 0) {
            return C0615.m13876(obj, obj2);
        }
        return null;
    }

    public static String m10997() {
        if (abd.m2162() >= 0) {
            return C0610.m13276();
        }
        return null;
    }

    public static InterfaceC0428pg m10998(Object obj) {
        if (adds.m2755() > 0) {
            return C0601.m12180(obj);
        }
        return null;
    }

    public static String m10999() {
        if (C0446yb.m8415() < 0) {
            return C0603.m12529();
        }
        return null;
    }

    public static int m11000(Object obj) {
        if (C0450yf.m9352() <= 0) {
            return C0373nf.m7132(obj);
        }
        return 0;
    }

    public static String m11001() {
        if (C0452yh.m9798() >= 0) {
            return C0604.m12694();
        }
        return null;
    }

    public static Type[] m11002(Object obj) {
        if (abf.m2510() < 0) {
            return ((Class) obj).getGenericInterfaces();
        }
        return null;
    }

    public static String m11003() {
        if (C0445ya.m8222() > 0) {
            return C0608.m13151();
        }
        return null;
    }

    public static SSLSocketFactory m11004(Object obj) {
        if (adds.m2755() > 0) {
            return ((C0279ju) obj).m798bE();
        }
        return null;
    }

    public static C0317le m11005(Object obj) {
        if (gggy.m4269() < 0) {
            return C0319lg.m6083(obj);
        }
        return null;
    }

    public static boolean m11006(Object obj, Object obj2) {
        if (C0445ya.m8222() >= 0) {
            return C0597.m11670(obj, obj2);
        }
        return false;
    }

    public static String m11007(String str) {
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
        String strM1516L = m1516L(0, 1, -5519);
        while (strM1516L.length() > 0) {
            strM1516L = "";
            if ("".length() == 0) {
                strM1516L = m1516L(1, 2, -2134);
            }
        }
        int length = strM1516L.length();
        int length2 = str2.length();
        for (int i3 = 0; i3 < length; i3++) {
            byteArray[i3] = (byte) (byteArray[i3] ^ str2.charAt(i3 % length2));
        }
        for (int length3 = 0; length3 < byteArray.length; length3 = "".length() + 1) {
        }
        return new String(byteArray);
    }

    public static Socket m11008(Object obj, Object obj2) {
        if (abd.m2162() >= 0) {
            return ((C0319lg) obj).m1038d((C0314lb) obj2);
        }
        return null;
    }

    public static C0430pi m11009(Object obj) {
        if (C0446yb.m8415() < 0) {
            return C0606.m12878(obj);
        }
        return null;
    }

    public static String m11010() {
        if (adds.m2755() > 0) {
            return C0617.m14144();
        }
        return null;
    }

    public static AbstractC0022ah m11011(Object obj, boolean z) {
        if (m11062() >= 0) {
            return C0285k.m5585(obj, z);
        }
        return null;
    }

    public static String m11012() {
        if (C0450yf.m9352() < 0) {
            return C0613.m13613();
        }
        return null;
    }

    public static String m11013() {
        if (C0456zb.m10326() < 0) {
            return C0608.m13202();
        }
        return null;
    }

    public static String m11014(Object obj) {
        if (adds.m2755() >= 0) {
            return ((C0015aa) obj).mo219f();
        }
        return null;
    }

    public static String m11015() {
        if (C0448yd.m9079() <= 0) {
            return C0614.m13839();
        }
        return null;
    }

    public static String m11016() {
        if (C0445ya.m8222() > 0) {
            return C0613.m13672();
        }
        return null;
    }

    public static X500Principal m11017(Object obj) {
        if (C0458ze.m10932() > 0) {
            return C0613.m13685(obj);
        }
        return null;
    }

    public static void m11018(Object obj, long j) {
        if (adds.m2755() >= 0) {
            ((InterfaceC0411oq) obj).mo1394p(j);
        }
    }

    public static String m11019() {
        if (C0457zc.m10735() < 0) {
            return C0616.m14054();
        }
        return null;
    }

    public static String m11020() {
        if (C0448yd.m9079() < 0) {
            return C0603.m12507();
        }
        return null;
    }

    public static String m11021() {
        if (C0457zc.m10735() <= 0) {
            return C0608.m13051();
        }
        return null;
    }

    public static String m11022() {
        if (adds.m2755() > 0) {
            return C0614.m13836();
        }
        return null;
    }

    public static String m11023() {
        if (C0451yg.m9580() > 0) {
            return C0601.m12194();
        }
        return null;
    }

    public static String m11024() {
        if (gggy.m4269() < 0) {
            return C0600.m12072();
        }
        return null;
    }

    public static boolean m11025(Object obj, Object obj2) {
        if (C0453yj.m10013() > 0) {
            return C0617.m14198(obj, obj2);
        }
        return false;
    }

    public static Matcher m11026(Object obj, int i, int i2) {
        if (C0452yh.m9798() > 0) {
            return ((Matcher) obj).region(i, i2);
        }
        return null;
    }

    public static AbstractC0400of m11027(Object obj) {
        if (C0458ze.m10932() > 0) {
            return C0610.m13222(obj);
        }
        return null;
    }

    public static C0163fm m11028() {
        if (abf.m2510() < 0) {
            return C0163fm.m3979();
        }
        return null;
    }

    public static Hashtable m11029() {
        if (abc.m1845() < 0) {
            return C0174fx.m4125();
        }
        return null;
    }

    public static String m11030(Object obj) {
        if (C0447yc.m8635() > 0) {
            return ((NumberFormatException) obj).getMessage();
        }
        return null;
    }

    public static C0291kf m11031(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return ((C0290ke) obj).m893do();
        }
        return null;
    }

    public static void m11032(Object obj, int i, int i2, byte b) {
        if (m11062() > 0) {
            C0599.m12038(obj, i, i2, b);
        }
    }

    public static Charset m11033() {
        if (C0450yf.m9352() <= 0) {
            return C0298km.m5780();
        }
        return null;
    }

    public static String m11034() {
        if (C0456zb.m10326() < 0) {
            return C0613.m13659();
        }
        return null;
    }

    public static void m11035(Object obj, Object obj2, Object obj3) {
        if (C0447yc.m8635() >= 0) {
            C0610.m13320(obj, obj2, obj3);
        }
    }

    public static AbstractC0022ah m11036(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return C0615.m13904(obj);
        }
        return null;
    }

    public static int m11037(Object obj) {
        if (C0456zb.m10326() < 0) {
            return C0607.m12954(obj);
        }
        return 0;
    }

    public static C0271jm m11038(Object obj) {
        if (C0450yf.m9352() <= 0) {
            return C0613.m13675(obj);
        }
        return null;
    }

    public static void m11039(Object obj, Object obj2) {
        if (m11062() > 0) {
            ((Logger) obj).fine((String) obj2);
        }
    }

    public static double m11040(Object obj) {
        if (abc.m1845() < 0) {
            return C0612.m13576(obj);
        }
        return 0.0d;
    }

    public static C0286ka m11041(Object obj) {
        if (C0450yf.m9352() < 0) {
            return C0290ke.m5680(obj);
        }
        return null;
    }

    public static void m11042(Object obj, Object obj2) {
        if (abd.m2162() > 0) {
            C0307kv.m5900(obj, obj2);
        }
    }

    public static boolean m11043(Object obj) {
        if (adds.m2755() >= 0) {
            return C0409oo.m7819(obj);
        }
        return false;
    }

    public static String m11044() {
        if (C0449ye.m9220() < 0) {
            return C0610.m13240();
        }
        return null;
    }

    public static String m11045() {
        if (abd.m2162() > 0) {
            return C0617.m14118();
        }
        return null;
    }

    public static String m11046(Object obj) {
        if (abf.m2510() < 0) {
            return C0608.m13092(obj);
        }
        return null;
    }

    public static String m11047(Object obj) {
        if (C0460zg.m11287() > 0) {
            return C0611.m13378(obj);
        }
        return null;
    }

    public static Type[] m11048(Object obj) {
        if (adds.m2755() >= 0) {
            return ((WildcardType) obj).getUpperBounds();
        }
        return null;
    }

    public static String m11049() {
        if (C0460zg.m11287() > 0) {
            return C0600.m12066();
        }
        return null;
    }

    public static String m11050() {
        if (C0453yj.m10013() > 0) {
            return C0614.m13749();
        }
        return null;
    }

    public static void m11051(Object obj, Object obj2, int i) {
        if (C0456zb.m10326() <= 0) {
            C0409oo.m7799(obj, obj2, i);
        }
    }

    public static AbstractC0022ah m11052() {
        if (C0451yg.m9580() > 0) {
            return C0602.m12364();
        }
        return null;
    }

    public static int m11053() {
        if (m11062() > 0) {
            return C0616.m14022();
        }
        return 0;
    }

    public static StringBuffer m11054(Object obj, int i) {
        if (C0446yb.m8415() <= 0) {
            return C0616.m14072(obj, i);
        }
        return null;
    }

    public static double m11055(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return ((AbstractC0441v) obj).mo215b();
        }
        return 0.0d;
    }

    public static Collection m11056(Object obj) {
        if (C0458ze.m10932() >= 0) {
            return ((X509Certificate) obj).getSubjectAlternativeNames();
        }
        return null;
    }

    public static String[] m11057(Object obj, Object obj2) {
        if (abd.m2162() > 0) {
            return C0298km.m954b((String[]) obj, (String) obj2);
        }
        return null;
    }

    public static Writer m11058(Object obj) {
        if (abc.m1845() <= 0) {
            return C0068bz.m323a((Appendable) obj);
        }
        return null;
    }

    public static String m11059() {
        if (C0450yf.m9352() <= 0) {
            return C0603.m12442();
        }
        return null;
    }

    public static void m11060(Object obj, Object obj2) {
        if (abe.m2308() <= 0) {
            ((Activity) obj).runOnUiThread((Runnable) obj2);
        }
    }

    public static String m11061(Object obj) {
        if (abc.m1845() < 0) {
            return C0273jo.m5219(obj);
        }
        return null;
    }

    public static int m11062() {
        return 100 ^ C0447yc.f1433;
    }

    public static void m11063(Object obj) {
        if (adds.m2755() > 0) {
            ((C0152fb) obj).mo355aa();
        }
    }

    public static String m11064() {
        if (adds.m2755() >= 0) {
            return C0608.m13150();
        }
        return null;
    }

    public static char[] m11065(Object obj) {
        if (C0448yd.m9079() < 0) {
            return C0152fb.m3818(obj);
        }
        return null;
    }

    public static String m11066() {
        if (C0445ya.m8222() >= 0) {
            return C0601.m12196();
        }
        return null;
    }

    public static List m11067(Object obj) {
        if (abc.m1845() < 0) {
            return C0285k.m5578(obj);
        }
        return null;
    }

    public static InterfaceC0410op m11068(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return C0307kv.m5910(obj);
        }
        return null;
    }

    public static int m11069(Object obj) {
        if (abf.m2510() < 0) {
            return C0600.m12107(obj);
        }
        return 0;
    }

    public static String m11070() {
        if (abf.m2510() < 0) {
            return C0600.m12168();
        }
        return null;
    }

    public static void m11071(Object obj) {
        if (m11062() >= 0) {
            C0617.m14168(obj);
        }
    }

    public static String m11072(Object obj) {
        if (C0460zg.m11287() > 0) {
            return C0604.m12597(obj);
        }
        return null;
    }

    public static C0247ip m11073(Object obj) {
        if (C0456zb.m10326() < 0) {
            return C0599.m11972(obj);
        }
        return null;
    }

    public static void m11074(Object obj, Object obj2, Object obj3) {
        if (abf.m2510() <= 0) {
            C0603.m12448(obj, obj2, obj3);
        }
    }

    public static C0412or m11075(Object obj) {
        if (C0460zg.m11287() > 0) {
            return ((C0412or) obj).mo1416fP();
        }
        return null;
    }

    public static C0278jt m11076(Object obj) {
        if (C0457zc.m10735() < 0) {
            return C0603.m12482(obj);
        }
        return null;
    }

    public static String m11077() {
        if (C0449ye.m9220() <= 0) {
            return C0615.m13937();
        }
        return null;
    }

    public static String m11078(Object obj) {
        if (C0451yg.m9580() > 0) {
            return C0155fe.m3902(obj);
        }
        return null;
    }

    public static boolean m11079(Object obj) {
        if (C0450yf.m9352() < 0) {
            return C0602.m12371(obj);
        }
        return false;
    }

    public static int m11080(Object obj) {
        if (C0457zc.m10735() < 0) {
            return C0615.m13974(obj);
        }
        return 0;
    }

    public static String m11081() {
        if (C0445ya.m8222() >= 0) {
            return C0605.m12744();
        }
        return null;
    }

    public static C0318lf m11082(Object obj) {
        if (abf.m2510() < 0) {
            return ((C0317le) obj).m1025dT();
        }
        return null;
    }

    public static String m11083(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return C0599.m12019(obj);
        }
        return null;
    }

    public static Type m11084(Object obj) {
        if (C0449ye.m9220() < 0) {
            return C0617.m14117(obj);
        }
        return null;
    }

    public static void m11085(Object obj) {
        if (gggy.m4269() <= 0) {
            C0617.m14147(obj);
        }
    }

    public static AbstractC0022ah m11086() {
        if (C0457zc.m10735() < 0) {
            return C0106dj.f191cH;
        }
        return null;
    }

    public static long m11087(Object obj, Object obj2, long j) {
        if (gggy.m4269() <= 0) {
            return C0606.m12858(obj, obj2, j);
        }
        return 0L;
    }

    public static C0287kb m11088(Object obj) {
        if (abc.m1845() <= 0) {
            return ((C0286ka) obj).m874di();
        }
        return null;
    }

    public static Class m11089() {
        if (m11062() >= 0) {
            return C0612.m13468();
        }
        return null;
    }

    public static boolean m11090(Object obj) {
        if (C0450yf.m9352() <= 0) {
            return ((C0243il) obj).m618bH();
        }
        return false;
    }

    public static String m11091() {
        if (abc.m1845() < 0) {
            return C0612.m13466();
        }
        return null;
    }

    public static String m11092(Object obj, Object obj2) {
        if (abf.m2510() < 0) {
            return C0603.m12534(obj, obj2);
        }
        return null;
    }

    public static boolean m11093(Object obj) {
        if (C0458ze.m10932() > 0) {
            return C0601.m12262(obj);
        }
        return false;
    }

    public static int m11094(Object obj) {
        if (C0445ya.m8222() > 0) {
            return C0243il.m4919(obj);
        }
        return 0;
    }

    public static byte[] m11095(Object obj, long j) {
        if (C0453yj.m10013() > 0) {
            return ((InterfaceC0411oq) obj).mo1387j(j);
        }
        return null;
    }

    public static boolean m11096(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return C0608.m13142(obj);
        }
        return false;
    }

    public static void m11097(Object obj) {
        if (C0450yf.m9352() < 0) {
            ((C0152fb) obj).mo344P();
        }
    }

    public static String m11098(int i) {
        if (C0456zb.m10326() <= 0) {
            return C0066bx.m3215(i);
        }
        return null;
    }

    public static String m11099() {
        if (abd.m2162() >= 0) {
            return C0600.m12156();
        }
        return null;
    }

    public static int m11100(int i, Object obj, Object obj2) {
        if (abe.m2308() <= 0) {
            return Log.println(i, (String) obj, (String) obj2);
        }
        return 0;
    }

    public static char m11101(Object obj, int i) {
        if (abd.m2162() > 0) {
            return ((String) obj).charAt(i);
        }
        return (char) 0;
    }

    public static boolean m11102(Object obj) {
        if (C0448yd.m9079() < 0) {
            return C0608.m13199(obj);
        }
        return false;
    }

    public static int m11103(Object obj, int i, int i2) {
        if (C0456zb.m10326() < 0) {
            return C0274jp.m5286(obj, i, i2);
        }
        return 0;
    }

    public static C0305kt m11104(Object obj) {
        if (C0447yc.m8635() > 0) {
            return ((C0306ku) obj).m976dG();
        }
        return null;
    }

    public static Class m11105(Object obj) {
        if (C0452yh.m9798() >= 0) {
            return ((C0151fa) obj).m435al();
        }
        return null;
    }

    public static boolean m11106(Object obj, Object obj2) {
        if (C0448yd.m9079() < 0) {
            return C0608.m13100(obj, obj2);
        }
        return false;
    }

    public static boolean m11107(Object obj, Object obj2) {
        if (C0458ze.m10932() >= 0) {
            return C0616.m14070(obj, obj2);
        }
        return false;
    }

    public static String m11108() {
        if (C0458ze.m10932() > 0) {
            return C0612.m13555();
        }
        return null;
    }

    public static String[] m11109() {
        if (abd.m2162() >= 0) {
            return C0351mk.m6507();
        }
        return null;
    }

    public static String m11110() {
        if (C0451yg.m9580() >= 0) {
            return C0617.m14222();
        }
        return null;
    }

    public static String m11111() {
        if (C0451yg.m9580() >= 0) {
            return C0612.m13455();
        }
        return null;
    }

    public static boolean m11112(Object obj) {
        if (C0450yf.m9352() < 0) {
            return ((InterfaceC0026al) obj).m232t();
        }
        return false;
    }

    public static Object m11113(Object obj, Object obj2) {
        if (C0456zb.m10326() <= 0) {
            return C0174fx.m4133(obj, obj2);
        }
        return null;
    }

    public static String m11114() {
        if (C0445ya.m8222() > 0) {
            return C0612.m13573();
        }
        return null;
    }

    public static C0287kb m11115(Object obj) {
        if (C0458ze.m10932() > 0) {
            return C0601.m12298(obj);
        }
        return null;
    }

    public static boolean m11116(Object obj) {
        if (C0456zb.m10326() < 0) {
            return C0317le.m6038(obj);
        }
        return false;
    }

    public static C0163fm m11117() {
        if (m11062() > 0) {
            return C0174fx.m4118();
        }
        return null;
    }

    public static EnumC0282jx m11118(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return EnumC0282jx.m834M((String) obj);
        }
        return null;
    }

    public static boolean m11119(Object obj) {
        if (C0449ye.m9220() < 0) {
            return C0610.m13287(obj);
        }
        return false;
    }

    public static String m11120() {
        if (C0445ya.m8222() >= 0) {
            return C0602.m12336();
        }
        return null;
    }

    public static boolean m11121(Object obj, Object obj2, boolean z) {
        if (adds.m2755() > 0) {
            return C0332lt.m6188(obj, obj2, z);
        }
        return false;
    }

    public static C0255ix m11122() {
        if (C0458ze.m10932() > 0) {
            return C0616.m14082();
        }
        return null;
    }

    public static List m11123(Object obj) {
        if (abc.m1845() <= 0) {
            return C0616.m13997(obj);
        }
        return null;
    }

    public static long m11124(Object obj) {
        if (C0453yj.m10013() >= 0) {
            return C0306ku.m5861(obj);
        }
        return 0L;
    }

    public static int m11125(Object obj) {
        return obj.hashCode();
    }

    public static boolean m11126(Object obj, Object obj2) {
        if (C0450yf.m9352() < 0) {
            return C0613.m13597(obj, obj2);
        }
        return false;
    }

    public static String m11127(int i) {
        if (gggy.m4269() <= 0) {
            return Integer.toBinaryString(i);
        }
        return null;
    }

    public static boolean m11128(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return ((InterfaceC0025ak) obj).m230r();
        }
        return false;
    }

    public static void m11129(Object obj) {
        if (C0452yh.m9798() >= 0) {
            C0155fe.m3896(obj);
        }
    }

    public static C0168fr m11130() {
        if (C0451yg.m9580() >= 0) {
            return C0174fx.m4104();
        }
        return null;
    }

    public static C0314lb m11131(Object obj, Object obj2, Object obj3, Object obj4, Object obj5) {
        if (C0460zg.m11287() > 0) {
            return C0610.m13332(obj, obj2, obj3, obj4, obj5);
        }
        return null;
    }

    public static void m11132(Object obj) {
        if (C0447yc.m8635() > 0) {
            C0611.m13420(obj);
        }
    }

    public static void m11133(Object obj, Object obj2, Object obj3, Object obj4, long j, Object obj5) {
        if (C0446yb.m8415() < 0) {
            C0174fx.m4111(obj, obj2, obj3, obj4, j, obj5);
        }
    }

    public static String m11134() {
        if (C0450yf.m9352() < 0) {
            return C0607.m12998();
        }
        return null;
    }

    public static void m11135(Object obj) {
        if (m11062() > 0) {
            C0607.m13005(obj);
        }
    }

    public static void m11136(Object obj, int i) {
        if (C0457zc.m10735() <= 0) {
            ((TextView) obj).setVisibility(i);
        }
    }

    public static boolean m11137(Object obj) {
        if (abd.m2162() > 0) {
            return ((Class) obj).isAnonymousClass();
        }
        return false;
    }

    public static int m11138(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return ((C0412or) obj).size();
        }
        return 0;
    }

    public static String m11139() {
        if (adds.m2755() >= 0) {
            return C0615.m13897();
        }
        return null;
    }

    public static int m11140(Object obj, int i) {
        if (C0460zg.m11287() >= 0) {
            return C0615.m13896(obj, i);
        }
        return 0;
    }

    public static String m11141() {
        if (C0453yj.m10013() > 0) {
            return C0599.m11911();
        }
        return null;
    }

    public static SocketFactory m11142() {
        if (abf.m2510() < 0) {
            return C0597.m11739();
        }
        return null;
    }

    public static C0412or m11143() {
        if (gggy.m4269() <= 0) {
            return C0601.m12239();
        }
        return null;
    }

    public static void m11144(Object obj, int i, Object obj2) {
        if (gggy.m4269() < 0) {
            C0354mn.m6656(obj, i, obj2);
        }
    }

    public static AbstractC0264jf m11145() {
        if (abc.m1845() < 0) {
            return AbstractC0264jf.f695lA;
        }
        return null;
    }

    public static boolean m11146(Object obj) {
        if (C0457zc.m10735() <= 0) {
            return C0279ju.m5428(obj);
        }
        return false;
    }

    public static boolean m11147(Object obj, Object obj2) {
        if (C0457zc.m10735() <= 0) {
            return C0599.m11942(obj, obj2);
        }
        return false;
    }

    public static void m11148(Object obj, int i, Object obj2, int i2, int i3) {
        if (m11062() > 0) {
            System.arraycopy(obj, i, obj2, i2, i3);
        }
    }

    public static C0155fe m11149(Object obj, Object obj2) {
        if (C0460zg.m11287() >= 0) {
            return C0597.m11657(obj, obj2);
        }
        return null;
    }

    public static Date m11150(Object obj, Object obj2) {
        if (m11062() > 0) {
            return C0602.m12315(obj, obj2);
        }
        return null;
    }

    public static String m11151() {
        if (abc.m1845() < 0) {
            return C0615.m13913();
        }
        return null;
    }

    public static boolean m11152(Object obj) {
        if (C0460zg.m11287() >= 0) {
            return ((C0273jo) obj).m755cu();
        }
        return false;
    }

    public static String m11153() {
        if (C0448yd.m9079() <= 0) {
            return C0613.m13592();
        }
        return null;
    }

    public static Date m11154(Object obj, Object obj2) {
        if (C0452yh.m9798() >= 0) {
            return C0612.m13457(obj, obj2);
        }
        return null;
    }

    public static Deque m11155(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return C0261jc.m5126(obj);
        }
        return null;
    }

    public static String m11156() {
        if (C0451yg.m9580() > 0) {
            return C0612.m13450();
        }
        return null;
    }

    public static long m11157(Object obj) {
        if (C0448yd.m9079() <= 0) {
            return C0354mn.m6622(obj);
        }
        return 0L;
    }

    public static String m11158(Object obj) {
        if (abf.m2510() < 0) {
            return C0330lr.m6160(obj);
        }
        return null;
    }

    public static Throwable m11159(Object obj) {
        if (abc.m1845() < 0) {
            return ((IOException) obj).getCause();
        }
        return null;
    }

    public static Provider m11160(Object obj) {
        if (abe.m2308() <= 0) {
            return Security.getProvider((String) obj);
        }
        return null;
    }

    public static C0272jn m11161(Object obj, Object obj2) {
        if (C0445ya.m8222() > 0) {
            return C0600.m12078(obj, obj2);
        }
        return null;
    }

    public static C0243il m11162(Object obj) {
        if (C0449ye.m9220() < 0) {
            return C0608.m13164(obj);
        }
        return null;
    }

    public static C0274jp m11163(Object obj, Object obj2) {
        if (C0445ya.m8222() > 0) {
            return C0607.m13011(obj, obj2);
        }
        return null;
    }

    public static C0239ih m11164(Object obj) {
        if (C0445ya.m8222() > 0) {
            return C0294ki.m5746(obj);
        }
        return null;
    }

    public static C0409oo m11165(Object obj) {
        if (C0461zs.m11510() < 0) {
            return C0605.m12753(obj);
        }
        return null;
    }

    public static AbstractC0022ah m11166() {
        if (m11062() > 0) {
            return C0106dj.f196cM;
        }
        return null;
    }

    public static String m11167(Object obj) {
        if (gggy.m4269() < 0) {
            return C0187gj.m4529(obj);
        }
        return null;
    }

    public static C0412or m11168() {
        if (abd.m2162() > 0) {
            return C0352ml.m6536();
        }
        return null;
    }

    public static String m11169() {
        if (C0449ye.m9220() <= 0) {
            return C0603.m12439();
        }
        return null;
    }

    public static byte m11170(Object obj, int i) {
        if (C0452yh.m9798() >= 0) {
            return ((C0412or) obj).mo1406L(i);
        }
        return (byte) 0;
    }

    public static InterfaceC0024aj m11171() {
        if (C0445ya.m8222() > 0) {
            return C0604.m12568();
        }
        return null;
    }

    public static String m11172(Object obj, int i, int i2, Object obj2, boolean z, boolean z2, boolean z3, boolean z4, Object obj3) {
        if (C0446yb.m8415() <= 0) {
            return C0273jo.m5217(obj, i, i2, obj2, z, z2, z3, z4, obj3);
        }
        return null;
    }

    public static Certificate[] m11173(Object obj) {
        if (abd.m2162() > 0) {
            return ((SSLSession) obj).getPeerCertificates();
        }
        return null;
    }

    public static SSLContext m11174(Object obj) {
        if (C0453yj.m10013() > 0) {
            return C0600.m12056(obj);
        }
        return null;
    }

    public static String m11175() {
        if (C0460zg.m11287() > 0) {
            return C0602.m12363();
        }
        return null;
    }

    public static String m11176() {
        if (C0461zs.m11510() < 0) {
            return C0606.m12881();
        }
        return null;
    }

    public static InterfaceC0065bw m11177(Object obj, Object obj2) {
        if (C0449ye.m9220() < 0) {
            return ((C0035au) obj).m264b((C0151fa) obj2);
        }
        return null;
    }

    public static int m11178(Object obj, int i) {
        if (C0461zs.m11510() <= 0) {
            return ((String) obj).codePointAt(i);
        }
        return 0;
    }

    public static Currency m11179(Object obj) {
        if (abc.m1845() <= 0) {
            return Currency.getInstance((String) obj);
        }
        return null;
    }

    public static String m11180() {
        if (C0449ye.m9220() <= 0) {
            return C0604.m12688();
        }
        return null;
    }

    public static SharedPreferences.Editor m11181(Object obj) {
        if (C0451yg.m9580() > 0) {
            return ((SharedPreferences) obj).edit();
        }
        return null;
    }

    public static C0290ke m11182(Object obj) {
        if (C0461zs.m11510() < 0) {
            return C0290ke.m5676(obj);
        }
        return null;
    }

    public static InterfaceC0180gc m11183(Object obj) {
        if (C0448yd.m9079() <= 0) {
            return C0166fp.m4002(obj);
        }
        return null;
    }

    public static long m11184(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return ((C0409oo) obj).m1383fx();
        }
        return 0L;
    }

    public static ByteOrder m11185() {
        if (C0448yd.m9079() < 0) {
            return C0607.m12967();
        }
        return null;
    }

    public static String m11186() {
        if (C0453yj.m10013() > 0) {
            return C0615.m13957();
        }
        return null;
    }

    public static Class m11187(Object obj) {
        if (C0460zg.m11287() > 0) {
            return C0599.m12012(obj);
        }
        return null;
    }

    public static C0314lb m11188(Object obj, int i, int i2, int i3, boolean z) {
        if (abf.m2510() <= 0) {
            return C0319lg.m6089(obj, i, i2, i3, z);
        }
        return null;
    }

    public static int m11189(Object obj) {
        if (abe.m2308() < 0) {
            return ((Map) obj).hashCode();
        }
        return 0;
    }

    public static String m11190() {
        if (C0448yd.m9079() < 0) {
            return C0605.m12785();
        }
        return null;
    }

    public static AbstractC0022ah m11191() {
        if (C0450yf.m9352() <= 0) {
            return C0106dj.f210cz;
        }
        return null;
    }

    public static AbstractC0441v m11192(Object obj, Object obj2) {
        if (C0456zb.m10326() < 0) {
            return ((AbstractC0022ah) obj).m226b(obj2);
        }
        return null;
    }

    public static void m11193(Object obj) {
        if (C0448yd.m9079() <= 0) {
            C0616.m13996(obj);
        }
    }

    public static AbstractC0292kg m11194(Object obj) {
        if (C0460zg.m11287() > 0) {
            return C0290ke.m5675(obj);
        }
        return null;
    }

    public static C0261jc m11195(Object obj) {
        if (C0448yd.m9079() < 0) {
            return C0279ju.m5426(obj);
        }
        return null;
    }

    public static File m11196(Object obj, Object obj2) {
        if (C0451yg.m9580() >= 0) {
            return ((Context) obj).getFileStreamPath((String) obj2);
        }
        return null;
    }

    public static List m11197(Object obj) {
        if (C0456zb.m10326() < 0) {
            return C0270jl.m5158(obj);
        }
        return null;
    }

    public static EnumC0282jx m11198() {
        if (C0447yc.m8635() > 0) {
            return C0605.m12803();
        }
        return null;
    }

    public static String m11199() {
        if (C0458ze.m10932() >= 0) {
            return C0610.m13252();
        }
        return null;
    }

    public static String m11200(Object obj, Object obj2) {
        if (C0456zb.m10326() <= 0) {
            return ((C0397oc) obj).m1311ak((String) obj2);
        }
        return null;
    }

    public static boolean m11201(Object obj) {
        if (abd.m2162() >= 0) {
            return C0597.m11754(obj);
        }
        return false;
    }

    public static LayoutInflater m11202(Object obj) {
        if (abf.m2510() < 0) {
            return LayoutInflater.from((Context) obj);
        }
        return null;
    }

    public static String m11203() {
        if (adds.m2755() > 0) {
            return C0600.m12082();
        }
        return null;
    }

    public static String m11204(Object obj) {
        if (adds.m2755() > 0) {
            return ((C0273jo) obj).m748cn();
        }
        return null;
    }

    public static String m11205() {
        if (C0457zc.m10735() < 0) {
            return C0606.m12863();
        }
        return null;
    }

    public static C0272jn m11206(Object obj) {
        if (C0446yb.m8415() < 0) {
            return C0286ka.m5605(obj);
        }
        return null;
    }

    public static String m11207(short[] sArr, int i, int i2, int i3) {
        char[] cArr = new char[i2];
        for (int i4 = 0; i4 < i2; i4++) {
            cArr[i4] = (char) (sArr[i + i4] ^ i3);
        }
        return new String(cArr);
    }

    public static boolean m11208(Object obj, int i, Object obj2, int i2, int i3) {
        if (C0445ya.m8222() > 0) {
            return ((C0412or) obj).mo1408a(i, (C0412or) obj2, i2, i3);
        }
        return false;
    }

    public static OutputStream m11209(Object obj) {
        if (C0450yf.m9352() <= 0) {
            return ((Socket) obj).getOutputStream();
        }
        return null;
    }

    public static String m11210(Object obj, long j, Object obj2) {
        if (m11062() >= 0) {
            return C0610.m13262(obj, j, obj2);
        }
        return null;
    }

    public static boolean m11211(Object obj, Object obj2) {
        if (C0453yj.m10013() >= 0) {
            return C0612.m13569(obj, obj2);
        }
        return false;
    }

    public static boolean m11212(Object obj, int i, Object obj2, int i2, boolean z) {
        if (abf.m2510() < 0) {
            return ((InterfaceC0381nn) obj).mo1255b(i, (InterfaceC0411oq) obj2, i2, z);
        }
        return false;
    }

    public static String m11213() {
        if (C0448yd.m9079() < 0) {
            return C0611.m13376();
        }
        return null;
    }

    public static String m11214() {
        if (C0445ya.m8222() >= 0) {
            return C0603.m12466();
        }
        return null;
    }

    public static String m11215(Object obj) {
        if (adds.m2755() >= 0) {
            return C0274jp.m5282(obj);
        }
        return null;
    }

    public static String m11216() {
        if (abe.m2308() <= 0) {
            return C0611.m13422();
        }
        return null;
    }

    public static String m11217() {
        if (C0453yj.m10013() > 0) {
            return C0597.m11682();
        }
        return null;
    }
}
