package com.google.android.material.card2;

import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Looper;
import java.io.ByteArrayOutputStream;
import java.lang.annotation.Annotation;
import java.lang.reflect.Method;
import java.net.InetAddress;
import java.net.SocketTimeoutException;
import java.nio.ByteBuffer;
import java.security.MessageDigest;
import java.text.DateFormat;
import java.text.ParsePosition;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Comparator;
import java.util.Date;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.TimeZone;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicIntegerArray;
import java.util.concurrent.atomic.AtomicLongArray;
import java.util.zip.CRC32;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.SSLSocket;
import javax.net.ssl.SSLSocketFactory;

public class C0598 {

    private static short[] f1360z = {-8534, -8530, -8532, -10760, -10784, -10753, -10765, -10776, -10780, -10765, -10803, -10814, -10813, -10814, -10765, -10757, -10779, -10760, -10780, -10765, -10771, -10775, -10753, -10765, -10850, -10855, -10854, -10765, -10769, -10770, -10769, -10765, -10753, -10780, -10771, -10850, -10855, -10854, -15376, -15402, -15404, -11890, -11882, -11895, -11899, -11873, -11879, -11874, -11886, -11899, -11896, -11895, -11877, -11899, -11891, -11885, -11890, -11886, -11899, -11884, -11889, -11882, -11882, -11899, -11895, -11886, -11877, -17494, -17501, -17533, -17448, -17503, -17521, -17529, -17526, -17524, -17503, -17456, -17501, -17488, -17482, -17490, -17525, -17519, -17449, -17455, -17480, -17498, -17524, -17483, -17501, -17482, -17491, -17535, -17452, -17451, -17454, -17448, -17519, -17524, -17453, -17491, -17494, -17455, -17483, -17503, -17531, -17484, -17485, -17517, -17511, -17530, -17447, -17525, -17453, -17520, -17531, -17489, -17496, -17522, -17453, -17484, -17528, -17529, -17457, -17484, -17532, -17488, -17483, -17447, -17501, -17512, -17535, -17493, -17479, -17461, -17518, -17531, -17512, -17485, -17450, -17495, -17520, -17493, -17478, -17526, -17454, -17453, -17520, -17449, -17534, -17510, -17492, -17503, -17481, -17501, -17461, -17511, -17496, -17493, -17491, -17514, -17489, -17457, -17493, -17511, -17461, -17533, -17451, -17525, -17479, -17479, -17514, -17487, -17443, -21820, -21812, -21798, -21798, -21816, -21810, -21812, -21879, -21868, -21868, -21879, -21817, -21796, -21819, -21819, -22624, -22601, -22604, -22624, -22601, -22623, -22598, 22175, 22160, 22170, 22156, 22161, 22167, 22170, 22224, 22160, 22171, 22154, 22224, 22192, 22171, 22154, 22153, 22161, 22156, 22165, 15756, 15764, 15762, 15765, 15820, 15763, 15748, 15767, 15744, 15757, 15752, 15749, 15744, 15765, 15748, 15821, 15809, -19067, -19039, -19037, -19035, -18966, -19043, -19029, -19010, -19031, -19038, -19026, -19035, -19027, -18550, -18553, -18557, -18554, -18553, -18544, -18543, 17344, 17380, 17351, 17403, 17403, 17407, 17327, 17322, 17404, 17327, 17404, 17386, 17403, 17403, 17382, 17377, 17384, 17404, 19456, 19490, 19503, 19503, 19555, 19508, 19490, 19504, 19501, 19556, 19511, 19555, 19498, 19501, 19566, 19493, 19503, 19498, 19492, 19499, 19511, 19554, 10837, 10834, 6917, 6941, 6914, 6926, 6932, 6930, 6933, 6937, 6926, 6932, 6930, 6933, 6914, 6928, 6926, 6918, 6936, 6917, 6937, 6926, 6915, 6930, 7013, 6926, 7008, 7011, 7017, 6926, 6914, 6937, 6928, 8060, 8027, 8003, 8020, 8025, 8028, 8017, 7957, 8023, 8028, 8001, 8006, 8016, 8001, 7957, 8003, 8020, 8025, 8000, 8016, 7957, 8001, 8012, 8005, 8016, 7951, 7957, -25653, -25647, -25642, -25645, -25704, -25723, -25723, -25704, -25642, -25651, -25644, -25644, -24842, -24842, -24842, -24929, -24873, -24873, -24930, -24834, -24834, -24834, -24930, -24886, -24886, -24886, -24886, -24941, -24837, -24837, -24951, -24866, -24866, -24951, -24896, -24896, -24941, -24887, -19633, -19633, -19632, -19645, -19624, -19628, -19645, -19587, -19598, -19597, -19598, -19645, -19623, -19644, -19636, -19629, -19634, -19640, -19645, -19637, -19627, -19640, -19628, -19645, -19634, -19617, -19672, -19645, -19672, -19668, -19645, -19631, -19624, -19671, -6060, -6077, -6069, -6071, -6064, -6077, -607, -583, -602, -598, -578, -601, -585, -576, -598, -606, -580, -607, -579, -598, -591, -592, -602, -598, -586, -585, -586, -598, -602, -579, -588, 12070, 12094, 12065, 12077, 12087, 12081, 12086, 12090, 12087, 12077, 12064, 12065, 12083, 12077, 12069, 12091, 12070, 12090, 12077, 12081, 12090, 12083, 12081, 12090, 12083, 12096, 12098, 12077, 12066, 12093, 12094, 12075, 12099, 12097, 12098, 12103, 12077, 12065, 12090, 12083, 12096, 12103, 12100, -9572, -9505, -9517, -9520, -9527, -9519, -9518, -9572, -11644, -11644, -11621, -11640, -11629, -11617, -11640, -11594, -11591, -11592, -11591, -11640, -11648, -11618, -11645, -11617, -11640, -11548, -11629, -11630, -11644, -11640, -11630, -11629, -11630, -11640, -11628, -11627, -11628, -11640, -11644, -11617, -11626, 12038, 12041, 12098, 12034, 12032, 12043, 12038, 12041, 12038, 12042, 12043, 12098, 12060, 12038, 12033, 12044, 12042, -27947, -27911, -27912, -27934, -27917, -27912, -27934, -27973, -27966, -27921, -27930, -27917, -22081, -22027, -22044, -22031, -22035, 5012, 5014, 5015, 5005, 5009, 1794, 1818, 1797, 1801, 1811, 1813, 1810, 1822, 1811, 1801, 1811, 1813, 1810, 1797, 1815, 1801, 1793, 1823, 1794, 1822, 1801, 1815, 1811, 1797, 1801, 1892, 1891, 1888, 1801, 1813, 1812, 1813, 1801, 1797, 1822, 1815, 1217, 1241, 1222, 1226, 1233, 1245, 1232, 1226, 1233, 1222, 1222, 1226, 1218, 1244, 1217, 1245, 1226, 1236, 1232, 1222, 1226, 1191, 1184, 1187, 1226, 1238, 1239, 1238, 1226, 1222, 1245, 1236, -25838, -25828, -25851, -25828, -25801, -25759, -25835, -25745, -25855, -30850, -30894, -30893, -30893, -30888, -30882, -30903, -30892, -30894, -30893, 7864, 7840, 7871, 7859, 7870, 7871, 7853, 7859, 7867, 7845, 7864, 7844, 7859, 7855, 7853, 7841, 7849, 7840, 7840, 7845, 7853, 7859, 7901, 7902, 7892, 7859, 7855, 7854, 7855, 7859, 7871, 7844, 7853, -26359, -26322, -26314, -26335, -26324, -26327, -26332, -26272, -26332, -26311, -26322, -26335, -26323, -26327, -26333, -26272, -26316, -26335, -26334, -26324, -26331, -26272, -26317, -26327, -26310, -26331, -26272, -26315, -26320, -26332, -26335, -26316, -26331, -26272, -1437, -1432, -1439, -1422, -1421, -1435, -1420, -1504, -1475, -1475, -1504, -1426, -1419, -1428, -1428, 6976, 6996, 6985, 6987, 7023, 6984, 6978, 6979, 7006, 6939, 6915, 6997, 6918, 6994, 6985, 7023, 6984, 6978, 6979, 7006, 6939, 6915, 6997, 19316};

    public static int f1449 = -98;

    private static String m1518z(int i, int i2, int i3) {
        char[] cArr = new char[i2 - i];
        for (int i4 = 0; i4 < i2 - i; i4++) {
            cArr[i4] = (char) (f1360z[i + i4] ^ i3);
        }
        return new String(cArr);
    }

    public static C0250is m11784() {
        if (C0612.m13484() <= 0) {
            return C0250is.f611jy;
        }
        return null;
    }

    public static int m11785() {
        return 1747779 ^ C0600.m12050((Object) m1518z(0, 3, -10166));
    }

    public static String m11786() {
        if (C0604.m12623() < 0) {
            return m1518z(3, 38, -10836);
        }
        return null;
    }

    public static String m11787() {
        if (C0606.m12827() >= 0) {
            return m1518z(38, 41, -15439);
        }
        return null;
    }

    public static EnumC0295kj m11788() {
        if (C0607.m12983() > 0) {
            return EnumC0295kj.f880nO;
        }
        return null;
    }

    public static C0286ka m11789(Object obj) {
        if (C0605.m12762() >= 0) {
            return ((InterfaceC0277js) obj).mo786cH();
        }
        return null;
    }

    public static String m11790() {
        if (C0603.m12496() >= 0) {
            return m1518z(41, 67, -11814);
        }
        return null;
    }

    public static StringBuilder m11791(Object obj, Object obj2, int i, int i2) {
        if (C0608.m13174() >= 0) {
            return ((StringBuilder) obj).append((char[]) obj2, i, i2);
        }
        return null;
    }

    public static int m11792(Object obj, int i, int i2) {
        if (C0606.m12827() > 0) {
            return C0298km.m957k((String) obj, i, i2);
        }
        return 0;
    }

    public static String m11793(Object obj) {
        if (C0611.m13397() >= 0) {
            return ((C0084co) obj).mo345Q();
        }
        return null;
    }

    public static Class m11794() {
        if (C0612.m13484() < 0) {
            return Short.TYPE;
        }
        return null;
    }

    public static String m11795(Object obj) {
        if (C0608.m13174() >= 0) {
            return ((C0084co) obj).mo350V();
        }
        return null;
    }

    public static TimeZone m11796(Object obj) {
        if (C0605.m12762() > 0) {
            return TimeZone.getTimeZone((String) obj);
        }
        return null;
    }

    public static int m11797(Object obj) {
        if (C0603.m12496() >= 0) {
            return ((InterfaceC0411oq) obj).mo1373fF();
        }
        return 0;
    }

    public static C0273jo m11798(Object obj) {
        if (C0600.m12166() < 0) {
            return C0273jo.m731A((String) obj);
        }
        return null;
    }

    public static int m11799(Object obj) {
        if (C0609.m13206() >= 0) {
            return ((ByteBuffer) obj).remaining();
        }
        return 0;
    }

    public static String m11800(Object obj) {
        if (C0602.m12341() <= 0) {
            return C0325lm.m1053a((Date) obj);
        }
        return null;
    }

    public static String m11801() {
        if (m11785() > 0) {
            return m1518z(67, 175, -17440);
        }
        return null;
    }

    public static String m11802(String str) {
        String strM13831 = C0614.m13831();
        String strM13832 = C0614.m13831();
        for (int i = 0; i < 15; i++) {
            strM13831 = C0602.m12324(C0599.m12037(C0599.m12037(new StringBuffer(), strM13831), C0604.m12571(i)));
            strM13832 = C0602.m12324(C0616.m14072(C0599.m12037(new StringBuffer(), strM13832), ((int) (C0603.m12506() * ((double) 10))) ^ i));
        }
        while (C0602.m12340(strM13831) > 0) {
        }
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream(C0602.m12340(str) / 2);
        for (int i2 = 0; i2 < C0602.m12340(str); i2 += 2) {
            C0608.m13113(byteArrayOutputStream, (C0597.m11675(strM13831, C0604.m12607(str, i2)) << 4) | C0597.m11675(strM13831, C0604.m12607(str, i2 + 1)));
        }
        byte[] bArrM12750 = C0605.m12750(byteArrayOutputStream);
        int length = bArrM12750.length;
        int iM12340 = C0602.m12340(strM13832);
        for (int i3 = 0; i3 < length; i3++) {
            bArrM12750[i3] = (byte) (bArrM12750[i3] ^ C0604.m12607(strM13832, i3 % iM12340));
        }
        return new String(bArrM12750);
    }

    public static int m11803(Object obj) {
        if (C0614.m13729() <= 0) {
            return ((AtomicIntegerArray) obj).length();
        }
        return 0;
    }

    public static String m11804() {
        if (m11785() > 0) {
            return m1518z(175, 190, -21847);
        }
        return null;
    }

    public static String m11805() {
        if (C0605.m12762() > 0) {
            return m1518z(190, 197, -22574);
        }
        return null;
    }

    public static boolean m11806(Object obj, Object obj2) {
        if (C0599.m11982() < 0) {
            return ((InterfaceC0171fu) obj).mo476l((String) obj2);
        }
        return false;
    }

    public static EnumC0154fd m11807() {
        if (C0617.m14174() < 0) {
            return EnumC0154fd.f281eo;
        }
        return null;
    }

    public static String m11808() {
        if (C0612.m13484() <= 0) {
            return m1518z(197, 216, 22270);
        }
        return null;
    }

    public static EnumC0295kj m11809() {
        if (C0607.m12983() >= 0) {
            return EnumC0295kj.f879nN;
        }
        return null;
    }

    public static boolean m11810(Object obj) {
        if (m11785() > 0) {
            return ((C0015aa) obj).m220n();
        }
        return false;
    }

    public static C0250is m11811() {
        if (C0597.m11689() < 0) {
            return C0250is.f602jp;
        }
        return null;
    }

    public static String m11812() {
        if (C0610.m13218() < 0) {
            return m1518z(216, 233, 15841);
        }
        return null;
    }

    public static String m11813() {
        if (C0610.m13218() < 0) {
            return m1518z(233, 246, -18998);
        }
        return null;
    }

    public static String m11814() {
        if (C0617.m14174() <= 0) {
            return m1518z(246, 253, -18494);
        }
        return null;
    }

    public static byte[] m11815(Object obj, Object obj2) {
        if (C0617.m14174() <= 0) {
            return ((MessageDigest) obj).digest((byte[]) obj2);
        }
        return null;
    }

    public static void m11816(Object obj, int i, long j) {
        if (C0600.m12166() <= 0) {
            ((AtomicLongArray) obj).set(i, j);
        }
    }

    public static String m11817(Object obj) {
        if (C0600.m12166() <= 0) {
            return ((SSLSession) obj).getProtocol();
        }
        return null;
    }

    public static C0412or m11818(Object obj, int i) {
        if (C0611.m13397() >= 0) {
            return ((C0409oo) obj).m1340C(i);
        }
        return null;
    }

    public static String m11819() {
        if (m11785() >= 0) {
            return m1518z(253, 271, 17295);
        }
        return null;
    }

    public static int m11820(Object obj) {
        if (C0601.m12304() > 0) {
            return ((EnumC0295kj) obj).hashCode();
        }
        return 0;
    }

    public static String m11821() {
        if (C0607.m12983() >= 0) {
            return m1518z(271, 293, 19523);
        }
        return null;
    }

    public static String m11822() {
        if (C0603.m12496() > 0) {
            return m1518z(293, 295, 10840);
        }
        return null;
    }

    public static String m11823() {
        if (C0601.m12304() > 0) {
            return m1518z(295, 326, 6993);
        }
        return null;
    }

    public static int m11824(Object obj) {
        if (C0617.m14174() < 0) {
            return ((List) obj).size();
        }
        return 0;
    }

    public static String m11825() {
        if (C0600.m12166() <= 0) {
            return m1518z(326, 353, 7989);
        }
        return null;
    }

    public static Throwable m11826(Object obj, Object obj2) {
        if (C0599.m11982() <= 0) {
            return ((SocketTimeoutException) obj).initCause((Throwable) obj2);
        }
        return null;
    }

    public static C0250is m11827(Object obj) {
        if (C0599.m11982() <= 0) {
            return C0250is.m643r((String) obj);
        }
        return null;
    }

    public static Object[] m11828(Object obj) {
        if (C0613.m13605() > 0) {
            return ((Class) obj).getEnumConstants();
        }
        return null;
    }

    public static String m11829() {
        if (C0610.m13218() <= 0) {
            return m1518z(353, 365, -25672);
        }
        return null;
    }

    public static SSLSocketFactory m11830(Object obj) {
        if (C0609.m13206() >= 0) {
            return ((SSLContext) obj).getSocketFactory();
        }
        return null;
    }

    public static int m11831(Object obj, Object obj2, int i) {
        if (C0612.m13484() < 0) {
            return ((SharedPreferences) obj).getInt((String) obj2, i);
        }
        return 0;
    }

    public static String m11832() {
        if (C0616.m14022() >= 0) {
            return m1518z(365, 391, -24909);
        }
        return null;
    }

    public static String m11833() {
        if (C0610.m13218() <= 0) {
            return m1518z(391, 425, -19684);
        }
        return null;
    }

    public static InterfaceC0024aj m11834() {
        if (C0610.m13218() <= 0) {
            return C0106dj.f215de;
        }
        return null;
    }

    public static void m11835(Object obj) {
        if (C0617.m14174() <= 0) {
            ((C0152fb) obj).mo343O();
        }
    }

    public static String m11836() {
        if (C0602.m12341() < 0) {
            return m1518z(425, 431, -6138);
        }
        return null;
    }

    public static String m11837() {
        if (C0612.m13484() < 0) {
            return m1518z(431, 456, -523);
        }
        return null;
    }

    public static String m11838(Object obj) {
        if (C0614.m13729() < 0) {
            return obj.toString();
        }
        return null;
    }

    public static int m11839(long j) {
        if (C0600.m12166() < 0) {
            return Long.numberOfTrailingZeros(j);
        }
        return 0;
    }

    public static Class[] m11840(Object obj) {
        if (C0601.m12304() >= 0) {
            return ((Class) obj).getInterfaces();
        }
        return null;
    }

    public static String m11841() {
        if (C0616.m14022() > 0) {
            return m1518z(456, 499, 12146);
        }
        return null;
    }

    public static void m11842(Object obj) {
        if (C0613.m13605() > 0) {
            ((Map) obj).clear();
        }
    }

    public static boolean m11843(Object obj, Object obj2, Object obj3) {
        if (C0602.m12341() <= 0) {
            return ((AbstractC0296kk) obj).mo826a((C0253iv) obj2, (C0314lb) obj3);
        }
        return false;
    }

    public static AbstractC0022ah m11844() {
        if (C0602.m12341() <= 0) {
            return C0106dj.f219di;
        }
        return null;
    }

    public static Method m11845(Object obj, Object obj2, Object obj3) {
        if (C0612.m13484() <= 0) {
            return ((Class) obj).getDeclaredMethod((String) obj2, (Class[]) obj3);
        }
        return null;
    }

    public static int m11846(Object obj, Object obj2) {
        if (C0597.m11689() <= 0) {
            return ((C0409oo) obj).read((ByteBuffer) obj2);
        }
        return 0;
    }

    public static Looper m11847() {
        if (C0608.m13174() >= 0) {
            return Looper.myLooper();
        }
        return null;
    }

    public static C0257iz m11848(Object obj, Object obj2) {
        if (C0599.m11982() <= 0) {
            return C0257iz.m667a((C0273jo) obj, (String) obj2);
        }
        return null;
    }

    public static Set m11849(Object obj) {
        if (C0597.m11689() < 0) {
            return ((LinkedHashMap) obj).entrySet();
        }
        return null;
    }

    public static String m11850() {
        if (C0613.m13605() > 0) {
            return m1518z(499, 507, -9540);
        }
        return null;
    }

    public static void m11851(Object obj, long j) {
        if (C0600.m12166() < 0) {
            ((InterfaceC0411oq) obj).mo1393o(j);
        }
    }

    public static String[] m11852(Object obj, Object obj2, Object obj3) {
        if (C0603.m12496() >= 0) {
            return C0298km.m949a((Comparator<? super String>) obj, (String[]) obj2, (String[]) obj3);
        }
        return null;
    }

    public static boolean m11853(Object obj) {
        if (C0605.m12762() > 0) {
            return ((C0373nf) obj).m1214eK();
        }
        return false;
    }

    public static int m11854(Object obj) {
        if (C0612.m13484() < 0) {
            return ((Integer) obj).intValue();
        }
        return 0;
    }

    public static String[] m11855(Object obj) {
        if (C0597.m11689() < 0) {
            return ((SSLSocket) obj).getEnabledProtocols();
        }
        return null;
    }

    public static String m11856() {
        if (C0614.m13729() <= 0) {
            return m1518z(507, 540, -11561);
        }
        return null;
    }

    public static void m11858(Object obj, int i) {
        if (m11785() >= 0) {
            Arrays.fill((int[]) obj, i);
        }
    }

    public static PendingIntent m11859(Object obj, int i, Object obj2, int i2) {
        if (C0610.m13218() <= 0) {
            return PendingIntent.getActivity((Context) obj, i, (Intent) obj2, i2);
        }
        return null;
    }

    public static long m11860(Object obj, long j) {
        if (C0599.m11982() <= 0) {
            return ((TimeUnit) obj).toSeconds(j);
        }
        return 0L;
    }

    public static String m11861() {
        if (C0605.m12762() > 0) {
            return m1518z(540, 557, 12143);
        }
        return null;
    }

    public static String m11862() {
        if (C0607.m12983() > 0) {
            return m1518z(557, 569, -28010);
        }
        return null;
    }

    public static InterfaceC0245in m11863(Object obj) {
        if (C0612.m13484() <= 0) {
            return ((C0329lq) obj).m1069eg();
        }
        return null;
    }

    public static InterfaceC0240ii m11864(Object obj) {
        if (C0605.m12762() > 0) {
            return ((C0279ju) obj).m807cL();
        }
        return null;
    }

    public static C0286ka m11865(Object obj) {
        if (C0608.m13174() >= 0) {
            return ((C0329lq) obj).mo786cH();
        }
        return null;
    }

    public static String m11866() {
        if (C0605.m12762() > 0) {
            return m1518z(569, 574, -22139);
        }
        return null;
    }

    public static InterfaceC0024aj m11867() {
        if (C0602.m12341() < 0) {
            return C0106dj.f195cL;
        }
        return null;
    }

    public static String m11868() {
        if (C0608.m13174() >= 0) {
            return m1518z(574, 579, 5113);
        }
        return null;
    }

    public static InterfaceC0024aj m11869() {
        if (C0604.m12623() < 0) {
            return C0106dj.f213dc;
        }
        return null;
    }

    public static boolean m11870(Object obj) {
        if (C0599.m11982() <= 0) {
            return C0328lp.m1064aa((String) obj);
        }
        return false;
    }

    public static String m11871() {
        if (C0599.m11982() < 0) {
            return m1518z(579, 615, 1878);
        }
        return null;
    }

    public static String m11872() {
        if (C0610.m13218() < 0) {
            return m1518z(615, 647, 1173);
        }
        return null;
    }

    public static void m11873(Object obj, Object obj2) {
        if (C0601.m12304() >= 0) {
            ((AbstractC0264jf) obj).m705f((InterfaceC0245in) obj2);
        }
    }

    public static boolean m11874(Object obj, Object obj2) {
        if (C0604.m12623() <= 0) {
            return ((HashSet) obj).remove(obj2);
        }
        return false;
    }

    public static String m11875() {
        if (C0617.m14174() < 0) {
            return m1518z(647, 656, -28638);
        }
        return null;
    }

    public static double m11876(Object obj) {
        if (C0601.m12304() > 0) {
            return ((InterfaceC0029ao) obj).m237x();
        }
        return 0.0d;
    }

    public static void m11877(Object obj, Object obj2, Object obj3, Object obj4) {
        if (C0612.m13484() < 0) {
            ((AbstractC0264jf) obj).m693a((InterfaceC0245in) obj2, (String) obj3, (List<InetAddress>) obj4);
        }
    }

    public static String m11878() {
        if (C0616.m14022() > 0) {
            return m1518z(656, 666, -30915);
        }
        return null;
    }

    public static boolean m11879(Object obj, Object obj2) {
        if (C0601.m12304() >= 0) {
            return ((C0057bo) obj).equals(obj2);
        }
        return false;
    }

    public static boolean m11880(Object obj) {
        if (C0601.m12304() > 0) {
            return C0328lp.m1063Z((String) obj);
        }
        return false;
    }

    public static Annotation m11881(Object obj, Object obj2) {
        if (C0608.m13174() > 0) {
            return ((Class) obj).getAnnotation((Class) obj2);
        }
        return null;
    }

    public static Object m11882(Object obj) {
        if (C0609.m13206() >= 0) {
            return ((Iterator) obj).next();
        }
        return null;
    }

    public static void m11883(Object obj, Object obj2, int i, int i2) {
        if (C0610.m13218() < 0) {
            ((CRC32) obj).update((byte[]) obj2, i, i2);
        }
    }

    public static void m11884(Object obj) {
        if (C0597.m11689() <= 0) {
            ((InterfaceC0324ll) obj).mo1048ee();
        }
    }

    public static String m11885() {
        if (C0607.m12983() >= 0) {
            return m1518z(666, 699, 7916);
        }
        return null;
    }

    public static InterfaceC0240ii m11886() {
        if (C0599.m11982() <= 0) {
            return InterfaceC0240ii.f503ic;
        }
        return null;
    }

    public static List m11887(Object obj, Object obj2) {
        if (C0617.m14174() <= 0) {
            return ((InterfaceC0259ja) obj).mo676a((C0273jo) obj2);
        }
        return null;
    }

    public static Date m11888(Object obj, Object obj2, Object obj3) {
        if (C0603.m12496() >= 0) {
            return ((DateFormat) obj).parse((String) obj2, (ParsePosition) obj3);
        }
        return null;
    }

    public static boolean m11889(double d) {
        if (C0607.m12983() > 0) {
            return Double.isInfinite(d);
        }
        return false;
    }

    public static void m11890(Object obj, Object obj2) {
        if (C0614.m13729() < 0) {
            ((C0315lc) obj).m1014b((C0294ki) obj2);
        }
    }

    public static String m11891() {
        if (C0606.m12827() > 0) {
            return m1518z(699, 733, -26304);
        }
        return null;
    }

    public static byte[] m11892(Object obj, Object obj2) {
        if (C0601.m12304() > 0) {
            return ((String) obj).getBytes((String) obj2);
        }
        return null;
    }

    public static boolean m11893(Object obj, Object obj2) {
        if (C0610.m13218() <= 0) {
            return ((Locale) obj).equals(obj2);
        }
        return false;
    }

    public static String m11894() {
        if (C0601.m12304() >= 0) {
            return m1518z(733, 748, -1536);
        }
        return null;
    }

    public static Iterator m11895(Object obj) {
        if (C0600.m12166() < 0) {
            return ((ArrayList) obj).iterator();
        }
        return null;
    }

    public static C0250is m11896() {
        if (C0614.m13729() <= 0) {
            return C0250is.f604jr;
        }
        return null;
    }

    public static Throwable m11897(Object obj) {
        if (C0608.m13174() > 0) {
            return ((AssertionError) obj).getCause();
        }
        return null;
    }

    public static int m11898(Object obj) {
        if (m11785() >= 0) {
            return ((ParsePosition) obj).getIndex();
        }
        return 0;
    }

    public static boolean m11899(Object obj) {
        if (C0613.m13605() >= 0) {
            return ((LinkedHashMap) obj).isEmpty();
        }
        return false;
    }

    public static String m11900() {
        if (C0599.m11982() <= 0) {
            return m1518z(748, 771, 6950);
        }
        return null;
    }

    public static String m11901() {
        if (C0609.m13206() >= 0) {
            return m1518z(771, 772, 19291);
        }
        return null;
    }

    public static AbstractC0292kg m11902() {
        if (m11785() >= 0) {
            return C0298km.f888nW;
        }
        return null;
    }

    public static String m11903(Object obj, Object obj2) {
        if (C0606.m12827() > 0) {
            return String.format((String) obj, (Object[]) obj2);
        }
        return null;
    }

    public static void m11904(Object obj, Object obj2) {
        if (C0600.m12166() < 0) {
            ((C0373nf) obj).m1205c((EnumC0346mf) obj2);
        }
    }

    public static String m11905(Object obj) {
        if (C0608.m13174() >= 0) {
            return ((C0239ih) obj).toString();
        }
        return null;
    }

    public static int m11906(Object obj) {
        if (C0601.m12304() >= 0) {
            return ((InterfaceC0277js) obj).mo785cG();
        }
        return 0;
    }

    public static boolean m11907(Object obj, Object obj2) {
        if (C0606.m12827() > 0) {
            return ((InterfaceC0014a) obj).m212a((Class<?>) obj2);
        }
        return false;
    }

    public static void m11908(Object obj, int i, int i2) {
        if (C0601.m12304() > 0) {
            ((Calendar) obj).set(i, i2);
        }
    }

    public static String m11857(short[] sArr, int i, int i2, int i3) {
        char[] cArr = new char[i2];
        for (int i4 = 0; i4 < i2; i4++) {
            cArr[i4] = (char) (sArr[i + i4] ^ i3);
        }
        return new String(cArr);
    }
}
