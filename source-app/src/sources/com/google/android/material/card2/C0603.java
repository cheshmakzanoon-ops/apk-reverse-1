package com.google.android.material.card2;

import android.app.AlertDialog;
import android.content.SharedPreferences;
import android.content.res.AssetManager;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Rect;
import android.os.Looper;
import android.view.Window;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InterruptedIOException;
import java.io.StringWriter;
import java.lang.reflect.Method;
import java.lang.reflect.Type;
import java.net.Proxy;
import java.net.Socket;
import java.net.SocketAddress;
import java.nio.ByteBuffer;
import java.nio.IntBuffer;
import java.nio.charset.Charset;
import java.text.DateFormat;
import java.util.Collection;
import java.util.Comparator;
import java.util.Currency;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.TimeUnit;
import java.util.zip.CRC32;
import java.util.zip.Inflater;
import javax.net.SocketFactory;
import javax.net.ssl.SSLSocket;

public class C0603 {

    private static final short[] f1457short = {482, 483, 483, 483, 974, 971, 990, 975, 1139, 1138, 1072, 1150, 1148, 1150, 1141, 1144, 1073, 1085, 2884, 2908, 2883, 2895, 2900, 2904, 2901, 2895, 2882, 2883, 2897, 2895, 2887, 2905, 2884, 2904, 2895, 2897, 2901, 2883, 2895, 2850, 2853, 2854, 2895, 2903, 2899, 2909, 2895, 2883, 2904, 2897, 2851, 2856, 2852, 1977, 1963, 1963, 1981, 1964, 1963, 2039, 3077, 3090, 2619, 2607, 2610, 2608, 3105, 3108, 3123, 3133, 3128, 3122, 1992, 2035, 2044, 2047, 2033, 2040, 1981, 2025, 2034, 1981, 2036, 2035, 2027, 2034, 2038, 2040, 1981, 2035, 2034, 1968, 2044, 2031, 2042, 2030, 1981, 2046, 2034, 2035, 2030, 2025, 2031, 2024, 2046, 2025, 2034, 2031, 1981, 2043, 2034, 2031, 1981, 2997, 2989, 2994, 3006, 2986, 2995, 2979, 3028, 3006, 2998, 2984, 2997, 2985, 3006, 2981, 2980, 2994, 3006, 2978, 2979, 2978, 3006, 2988, 2981, 3028, 3078, 3131, 3123, 3110, 3104, 3127, 3114, 3117, 3108, 3171, 3117, 3126, 3118, 3105, 3110, 3121, 3183, 3171, 3108, 3116, 3127, 3193, 3171, 2173, 2175, 2146, 2169, 2146, 2158, 2146, 2145, 2162, 2152, 2175, 2175, 2146, 2175, 2071, 2061, 2169, 2164, 2173, 2152, 2162, 2153, 2156, 2169, 2156, 2061, 2142, 2137, 2143, 2120, 2124, 2112, 2148, 2121, 2061, 2064, 2064, 2061, 2077, 967, 998, 937, 1020, 1018, 1000, 1003, 997, 1004, 937, 1019, 1004, 1018, 1020, 997, 1021, 933, 937, 1005, 1004, 1007, 1000, 1020, 997, 1021, 992, 999, 1006, 937, 2476, 2463, 2448, 2457, 2459, 2299, 2279, 2279, 2275, 2204, 2178, 2205, 2178, 2195, 3016, 2968, 2970, 2951, 2972, 2951, 2955, 2951, 2948, 3029, 3172, 3143, 3147, 3145, 3164, 3137, 3143, 3142, 976, 909, 919, 900, 923, 945, 920, 982, 983, 990, 919, 909, 990, 908, 923, 910, 913, 908, 906, 919, 912, 921, 990, 919, 912, 925, 913, 912, 909, 919, 909, 906, 923, 912, 906, 990, 908, 923, 909, 907, 914, 906, 909, 991, 992, 948, 943, 943, 992, 940, 929, 946, 935, 933, 1006, 2178, 1327, 1292, 1309, 1306, 1308, 1295, 1293, 1306, 1358, 1293, 1282, 1295, 1309, 1309, 1358, 1293, 1295, 1280, 1353, 1306, 1358, 1292, 1291, 1358, 1287, 1280, 1309, 1306, 1295, 1280, 1306, 1287, 1295, 1306, 1291, 1290, 1359, 1358, 1325, 1282, 1295, 1309, 1309, 1358, 1280, 1295, 1283, 1291, 1364, 1358, 1068, 1070, 1087, 1034, 1083, 1083, 1063, 1058, 1064, 1066, 1087, 1058, 1060, 1061, 1051, 1081, 1060, 1087, 1060, 1064, 1060, 1063, 3920, 3921, 3944, 3280, 3292, 3293, 3271, 3290, 3293, 3270, 3282, 3271, 3290, 3292, 3293, 1283, 1284, 1304, 1311, 2233, 2238, 2229, 2212, 2179, 2239, 2227, 2235, 2229, 2212, 2193, 2228, 2228, 2210, 2229, 2211, 2211, 2288, 2285, 2285, 2288, 2238, 2213, 2236, 2236, 1587, 1566, 1536, 1559, 1555, 1558, 1547, 1618, 1591, 1546, 1559, 1553, 1543, 1542, 1559, 1558, 686, 659, 667, 654, 648, 671, 654, 655, 715, 650, 715, 655, 644, 670, 649, 647, 654, 715, 649, 670, 671, 715, 668, 650, 664, 715, 262, 288, 307, 316, 289, 308, 311, 288, 383, 279, 316, 305, 317, 310, 315, 316, 309, 1853, 1853, 1853, 1880, 1820, 1820, 1880, 1845, 1845, 1845, 1880, 1793, 1793, 1793, 1793, 1880, 1840, 1840, 1858, 1813, 1813, 1858, 1803, 1803, 1880, 1794, 509, 461, 464, 468, 474, 465, 415, 460, 454, 460, 459, 474, 466, 415, 477, 474, 471, 478, 457, 470, 464, 458, 461, 415, 473, 464, 461, 415, 475, 465, 460, 415, 467, 464, 464, 468, 458, 463, 415, 464, 473, 415, 1402, 1393, 1404, 1402, 1394, 1354, 1404, 1387, 1391, 1404, 1387, 1357, 1387, 1388, 1386, 1389, 1404, 1405, 1672, 1733, 1757, 1755, 1756, 1672, 1739, 1737, 1732, 1732, 1672, 1752, 1754, 1735, 1739, 1741, 1741, 1740, 1664, 1665, 1672, 1741, 1744, 1737, 1739, 1756, 1732, 1745, 1672, 1735, 1734, 1739, 1741, 1249, 1273, 1254, 1258, 1264, 1270, 1265, 1277, 1264, 1258, 1255, 1254, 1268, 1258, 1250, 1276, 1249, 1277, 1258, 1268, 1264, 1254, 1258, 1156, 1159, 1165, 1258, 1270, 1271, 1270, 1258, 1254, 1277, 1268, 1159, 1152, 1155, 1869, 1877, 1866, 1849, 1901, 1900, 1911, 1911, 1916, 1909, 1849, 1915, 1900, 1919, 1919, 1916, 1899, 1916, 1917, 1849, 1901, 1910, 1910, 1849, 1908, 1912, 1911, 1888, 1849, 1915, 1888, 1901, 1916, 1898, 1848, 3062, 3036, 3036, 2988, 2965, 2962, 2962, 2969, 2968, 3036, 2975, 2969, 2958, 2952, 2965, 2970, 2965, 2975, 2973, 2952, 2969, 2959, 3036, 2970, 2963, 2958, 3036, 3170, 3188, 3186, 3198, 3199, 3189, 2848, 2850, 2850, 2852, 2865, 2869, 2924, 2852, 2863, 2850, 2862, 2853, 2856, 2863, 2854, 1267, 1263, 1267, 694, 692, 681, 694, 672, 687, 680, 674, 866, 878};

    public static boolean f1458;

    public static int m12429() {
        if (abc.m1845() <= 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static short[] m12430() {
        if (adds.m2755() >= 0) {
            return f1457short;
        }
        return null;
    }

    public static long m12431(Object obj, Object obj2, long j) {
        if (C0458ze.m10926() <= 0) {
            return C0452yh.m9693((C0417ow) obj, (C0409oo) obj2, j);
        }
        return 0L;
    }

    public static String m12432() {
        if (abe.m2321() <= 0) {
            return C0457zc.m10560(m12430(), 0, 4, 461);
        }
        return null;
    }

    public static boolean m12433(Object obj) {
        if (C0448yd.m9074() < 0) {
            return abd.m2138((Class) obj);
        }
        return false;
    }

    public static Thread m12434() {
        if (C0453yj.m9966() > 0) {
            return C0450yf.m9571();
        }
        return null;
    }

    public static AbstractC0022ah m12435(Object obj, Object obj2, Object obj3) {
        if (C0453yj.m9996() <= 0) {
            return C0461zs.m11457((InterfaceC0024aj) obj, (C0285k) obj2, (C0151fa) obj3);
        }
        return null;
    }

    public static String m12436(Object obj) {
        if (abe.m2321() <= 0) {
            return C0450yf.m9493((Currency) obj);
        }
        return null;
    }

    public static Set m12437(Object obj) {
        if (gggy.m4365() >= 0) {
            return abf.m2513((HashMap) obj);
        }
        return null;
    }

    public static Window m12438(Object obj) {
        if (gggy.m4365() > 0) {
            return C0456zb.m10452((AlertDialog) obj);
        }
        return null;
    }

    public static String m12439() {
        if (gggy.m4365() >= 0) {
            return C0451yg.m9579(m12430(), 4, 4, 938);
        }
        return null;
    }

    public static double m12440(Object obj) {
        if (C0458ze.m10926() <= 0) {
            return C0448yd.m8923((String) obj);
        }
        return 0.0d;
    }

    public static String m12441() {
        if (C0453yj.m9966() >= 0) {
            return C0446yb.m8463(m12430(), 8, 10, 1053);
        }
        return null;
    }

    public static String m12442() {
        if (C0448yd.m9015() <= 0) {
            return C0461zs.m11581(m12430(), 18, 35, 2832);
        }
        return null;
    }

    public static String m12443() {
        if (gggy.m4365() >= 0) {
            return C0459zf.m11207(m12430(), 53, 7, 2008);
        }
        return null;
    }

    public static int m12444(Object obj) {
        if (C0453yj.m9966() >= 0) {
            return gggy.m4443((C0354mn) obj);
        }
        return 0;
    }

    public static String m12445() {
        if (C0448yd.m9015() <= 0) {
            return C0453yj.m9924(m12430(), 60, 2, 3113);
        }
        return null;
    }

    public static String m12446() {
        if (C0453yj.m9966() > 0) {
            return C0456zb.m10478(m12430(), 62, 4, 2653);
        }
        return null;
    }

    public static void m12447(Object obj) {
        if (gggy.m4365() >= 0) {
            abd.m2184((CRC32) obj);
        }
    }

    public static void m12448(Object obj, Object obj2, Object obj3) {
        if (C0460zg.m11293() > 0) {
            C0452yh.m9719((InterfaceC0246io) obj, (InterfaceC0245in) obj2, (IOException) obj3);
        }
    }

    public static String m12449() {
        if (C0445ya.m8330() > 0) {
            return C0459zf.m11207(m12430(), 66, 6, 3153);
        }
        return null;
    }

    public static List m12450(Object obj, Object obj2) {
        if (gggy.m4365() > 0) {
            return C0453yj.m9913((C0273jo) obj, (C0271jm) obj2);
        }
        return null;
    }

    public static String m12451() {
        if (C0453yj.m9996() < 0) {
            return C0459zf.m11207(m12430(), 72, 41, 1949);
        }
        return null;
    }

    public static int m12452(Object obj, Object obj2, Object obj3) {
        if (C0448yd.m9074() <= 0) {
            return C0445ya.m8269((Comparator) obj, (String[]) obj2, (String) obj3);
        }
        return 0;
    }

    public static int m12453(char c) {
        if (C0457zc.m10718() <= 0) {
            return C0456zb.m10463(c);
        }
        return 0;
    }

    public static Date m12454(Object obj, Object obj2) {
        if (C0459zf.m11053() >= 0) {
            return adds.m2747((DateFormat) obj, (String) obj2);
        }
        return null;
    }

    public static String m12455() {
        if (C0458ze.m10926() < 0) {
            return abe.m2412(m12430(), 113, 25, 3041);
        }
        return null;
    }

    public static C0412or m12456(Object obj) {
        if (C0453yj.m10032() >= 0) {
            return C0460zg.m11383((C0409oo) obj);
        }
        return null;
    }

    public static C0247ip m12457() {
        if (C0445ya.m8330() > 0) {
            return C0458ze.m10819();
        }
        return null;
    }

    public static InputStream m12458(Object obj, Object obj2) {
        if (abd.m2021() >= 0) {
            return C0455za.m10097((AssetManager) obj, (String) obj2);
        }
        return null;
    }

    public static boolean m12459(Object obj, Object obj2, Object obj3) {
        if (gggy.m4365() > 0) {
            return C0455za.m10107((C0402oh) obj, (String) obj2, (String) obj3);
        }
        return false;
    }

    public static long m12460(Object obj, Object obj2) {
        if (C0458ze.m10926() <= 0) {
            return abe.m2282((C0409oo) obj, (InterfaceC0429ph) obj2);
        }
        return 0L;
    }

    public static String m12461() {
        if (C0456zb.m10484() < 0) {
            return C0460zg.m11422(m12430(), 138, 23, 3139);
        }
        return null;
    }

    public static boolean m12462(Object obj) {
        if (C0458ze.m10926() <= 0) {
            return abc.m1869((Socket) obj);
        }
        return false;
    }

    public static Class m12463(Object obj) {
        if (C0457zc.m10718() <= 0) {
            return abc.m1749(obj);
        }
        return null;
    }

    public static void m12464(Object obj) {
        if (abd.m2166() < 0) {
            abf.m2422((C0057bo) obj);
        }
    }

    public static short m12465(Object obj) {
        if (C0453yj.m9966() > 0) {
            return abf.m2466((InterfaceC0411oq) obj);
        }
        return (short) 0;
    }

    public static String m12466() {
        if (C0457zc.m10718() < 0) {
            return C0445ya.m8198(m12430(), 161, 39, 2093);
        }
        return null;
    }

    public static Configuration m12467(Object obj) {
        if (abd.m2021() > 0) {
            return adds.m2736((Resources) obj);
        }
        return null;
    }

    public static AbstractC0363mw m12468() {
        if (C0447yc.m8786() >= 0) {
            return C0450yf.m9441();
        }
        return null;
    }

    public static EnumC0282jx m12469() {
        if (C0453yj.m9945() <= 0) {
            return C0453yj.m9906();
        }
        return null;
    }

    public static String m12470() {
        if (C0457zc.m10555() > 0) {
            return C0450yf.m9476(m12430(), 200, 29, 905);
        }
        return null;
    }

    public static String m12471() {
        if (abe.m2321() <= 0) {
            return C0451yg.m9579(m12430(), 229, 5, 2558);
        }
        return null;
    }

    public static String m12472(Object obj) {
        if (C0448yd.m9074() < 0) {
            return C0453yj.m9982(obj);
        }
        return null;
    }

    public static String m12473(Object obj) {
        if (abe.m2321() < 0) {
            return C0456zb.m10462((AbstractC0441v) obj);
        }
        return null;
    }

    public static C0287kb m12474(Object obj, Object obj2) {
        if (C0453yj.m9996() < 0) {
            return C0449ye.m9211((C0287kb) obj, (C0271jm) obj2);
        }
        return null;
    }

    public static StringBuilder m12475(Object obj, Object obj2) {
        if (C0459zf.m11053() > 0) {
            return abf.m2573((StringBuilder) obj, obj2);
        }
        return null;
    }

    public static TimeUnit m12476() {
        if (C0457zc.m10555() > 0) {
            return C0461zs.m11599();
        }
        return null;
    }

    public static String m12477() {
        if (C0456zb.m10484() <= 0) {
            return abc.m1781(m12430(), 234, 9, 2227);
        }
        return null;
    }

    public static String m12478() {
        if (C0453yj.m10032() > 0) {
            return C0450yf.m9476(m12430(), 243, 10, 3048);
        }
        return null;
    }

    public static void m12479(Object obj, Object obj2) {
        if (abd.m2166() < 0) {
            abc.m1822((InterfaceC0385nr) obj, (File) obj2);
        }
    }

    public static Object m12480(Object obj) {
        if (C0453yj.m10032() > 0) {
            return C0448yd.m8982((Map.Entry) obj);
        }
        return null;
    }

    public static String m12481() {
        if (abe.m2321() <= 0) {
            return abe.m2412(m12430(), 253, 8, 3112);
        }
        return null;
    }

    public static C0278jt m12482(Object obj) {
        if (C0453yj.m9996() < 0) {
            return C0450yf.m9454((AbstractC0288kc) obj);
        }
        return null;
    }

    public static String m12483(Object obj) {
        if (C0457zc.m10718() <= 0) {
            return abe.m2385((C0187gj) obj);
        }
        return null;
    }

    public static String m12484() {
        if (gggy.m4365() >= 0) {
            return C0459zf.m11207(m12430(), 261, 44, 1022);
        }
        return null;
    }

    public static String m12485() {
        if (C0456zb.m10484() < 0) {
            return C0458ze.m10915(m12430(), 305, 11, 960);
        }
        return null;
    }

    public static boolean m12486(Object obj, Object obj2) {
        if (C0447yc.m8786() >= 0) {
            return C0448yd.m8971((List) obj, obj2);
        }
        return false;
    }

    public static long m12487(double d) {
        if (m12429() >= 0) {
            return abc.m1839(d);
        }
        return 0L;
    }

    public static Iterator m12488(Object obj) {
        if (C0459zf.m11053() >= 0) {
            return abf.m2598((Collection) obj);
        }
        return null;
    }

    public static void m12489(Object obj, Object obj2, Object obj3) {
        if (abd.m2166() <= 0) {
            C0452yh.m9699((AbstractC0264jf) obj, (InterfaceC0245in) obj2, (C0286ka) obj3);
        }
    }

    public static String m12490() {
        if (C0453yj.m9945() < 0) {
            return adds.m2884(m12430(), 316, 1, 2217);
        }
        return null;
    }

    public static String m12491(String str) {
        String strM4277 = gggy.m4277();
        String strM4278 = gggy.m4277();
        for (int i = 0; i < 15; i++) {
            strM4277 = C0455za.m10171(C0452yh.m9675(C0452yh.m9675(new StringBuffer(), strM4277), C0447yc.m8791(i)));
            strM4278 = C0455za.m10171(C0459zf.m11054(C0452yh.m9675(new StringBuffer(), strM4278), ((int) (abe.m2360() * ((double) 10))) ^ i));
        }
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream(gggy.m4397(str) / 2);
        for (int i2 = 0; i2 < gggy.m4397(str); i2 += 2) {
            C0448yd.m8972(byteArrayOutputStream, (C0458ze.m10892(strM4277, C0446yb.m8419(str, i2)) << 4) | C0458ze.m10892(strM4277, C0446yb.m8419(str, i2 + 1)));
        }
        byte[] bArrM9611 = C0452yh.m9611(byteArrayOutputStream);
        int length = bArrM9611.length;
        int iM4397 = gggy.m4397(strM4278);
        while (length > 0) {
            bArrM9611[-1] = (byte) (bArrM9611[-1] ^ C0446yb.m8419(strM4278, (-1) % iM4397));
        }
        for (int iM4398 = 0; iM4398 < bArrM9611.length; iM4398 = gggy.m4397(gggy.m4277()) + 1) {
        }
        return new String(bArrM9611);
    }

    public static String m12492(short[] sArr, int i, int i2, int i3) {
        char[] cArr = new char[i2];
        for (int i4 = 0; i4 < i2; i4++) {
            cArr[i4] = (char) (sArr[i + i4] ^ i3);
        }
        return new String(cArr);
    }

    public static String m12493() {
        if (C0457zc.m10718() <= 0) {
            return C0448yd.m9031(m12430(), 317, 50, 1390);
        }
        return null;
    }

    public static String m12494() {
        if (C0458ze.m10926() <= 0) {
            return C0459zf.m11207(m12430(), 367, 22, 1099);
        }
        return null;
    }

    public static void m12495(Object obj, int i, Object obj2) {
        if (C0453yj.m10032() > 0) {
            C0453yj.m9956((InterfaceC0381nn) obj, i, (EnumC0346mf) obj2);
        }
    }

    public static int m12496() {
        return 1754546 ^ C0455za.m10081(C0451yg.m9579(m12430(), 389, 3, 2487));
    }

    public static boolean m12497(Object obj, int i, Object obj2) {
        if (m12429() > 0) {
            return C0449ye.m9259((InterfaceC0429ph) obj, i, (TimeUnit) obj2);
        }
        return false;
    }

    public static int m12498(Object obj, int i) {
        if (C0447yc.m8786() > 0) {
            return C0459zf.m11178((String) obj, i);
        }
        return 0;
    }

    public static C0397oc m12499() {
        if (C0453yj.m9945() < 0) {
            return C0447yc.m8734();
        }
        return null;
    }

    public static void m12500(Object obj) {
        if (abd.m2021() >= 0) {
            C0450yf.m9411((InterfaceC0310ky) obj);
        }
    }

    public static C0430pi m12501(Object obj) {
        if (C0447yc.m8786() > 0) {
            return C0448yd.m9012((C0373nf) obj);
        }
        return null;
    }

    public static IntBuffer m12502(Object obj) {
        if (C0453yj.m9945() < 0) {
            return C0452yh.m9712((ByteBuffer) obj);
        }
        return null;
    }

    public static Class m12503() {
        if (C0445ya.m8330() > 0) {
            return adds.m2660();
        }
        return null;
    }

    public static C0412or m12504(Object obj) {
        if (C0447yc.m8786() > 0) {
            return C0445ya.m8307((C0412or) obj);
        }
        return null;
    }

    public static void m12505(Object obj, Object obj2, Object obj3) {
        if (gggy.m4365() >= 0) {
            abf.m2438((AbstractC0264jf) obj, (InterfaceC0245in) obj2, (C0270jl) obj3);
        }
    }

    public static double m12506() {
        if (C0447yc.m8786() > 0) {
            return C0452yh.m9588();
        }
        return 0.0d;
    }

    public static String m12507() {
        if (gggy.m4365() > 0) {
            return abc.m1781(m12430(), 392, 12, 3219);
        }
        return null;
    }

    public static String m12508() {
        if (C0456zb.m10484() < 0) {
            return C0445ya.m8198(m12430(), 404, 4, 1387);
        }
        return null;
    }

    public static String m12509() {
        if (abf.m2500() > 0) {
            return C0455za.m10121(m12430(), 408, 25, 2256);
        }
        return null;
    }

    public static C0151fa m12510(Object obj) {
        if (abd.m2166() <= 0) {
            return C0445ya.m8261((Type) obj);
        }
        return null;
    }

    public static Object m12511(Object obj) {
        if (abf.m2500() >= 0) {
            return abc.m1979((Map.Entry) obj);
        }
        return null;
    }

    public static void m12512(Object obj, long j) {
        if (C0447yc.m8786() >= 0) {
            C0461zs.m11634((C0409oo) obj, j);
        }
    }

    public static String m12513() {
        if (C0453yj.m10032() > 0) {
            return C0452yh.m9820(m12430(), 433, 16, 1650);
        }
        return null;
    }

    public static C0430pi m12514(Object obj) {
        if (C0460zg.m11293() > 0) {
            return C0458ze.m10880((InterfaceC0429ph) obj);
        }
        return null;
    }

    public static InterfaceC0065bw m12515(Object obj, Object obj2) {
        if (C0448yd.m9074() < 0) {
            return C0459zf.m11177((C0035au) obj, (C0151fa) obj2);
        }
        return null;
    }

    public static String m12516(Object obj) {
        if (C0448yd.m9015() <= 0) {
            return C0461zs.m11441((C0412or) obj);
        }
        return null;
    }

    public static String m12517() {
        if (C0448yd.m9015() < 0) {
            return abd.m2070(m12430(), 449, 26, 747);
        }
        return null;
    }

    public static InterfaceC0410op m12518(Object obj, int i) {
        if (abd.m2166() <= 0) {
            return C0453yj.m9926((InterfaceC0410op) obj, i);
        }
        return null;
    }

    public static String m12519(Object obj, Object obj2) {
        if (C0447yc.m8786() >= 0) {
            return C0459zf.m11200((C0397oc) obj, (String) obj2);
        }
        return null;
    }

    public static AlertDialog m12520(Object obj) {
        if (abf.m2500() >= 0) {
            return C0449ye.m9299((AlertDialog.Builder) obj);
        }
        return null;
    }

    public static Thread m12521(Object obj) {
        if (abf.m2500() > 0) {
            return C0446yb.m8577((Looper) obj);
        }
        return null;
    }

    public static String m12522() {
        if (C0457zc.m10718() < 0) {
            return C0450yf.m9476(m12430(), 475, 17, 338);
        }
        return null;
    }

    public static String m12523() {
        if (C0457zc.m10718() < 0) {
            return C0451yg.m9579(m12430(), 492, 26, 1912);
        }
        return null;
    }

    public static String m12524() {
        if (C0457zc.m10555() >= 0) {
            return C0451yg.m9579(m12430(), 518, 42, 447);
        }
        return null;
    }

    public static String m12525() {
        if (C0448yd.m9074() < 0) {
            return C0458ze.m10915(m12430(), 560, 18, 1305);
        }
        return null;
    }

    public static String m12526() {
        if (C0448yd.m9015() <= 0) {
            return C0447yc.m8718(m12430(), 578, 33, 1704);
        }
        return null;
    }

    public static String m12527() {
        if (m12429() >= 0) {
            return C0460zg.m11422(m12430(), 611, 37, 1205);
        }
        return null;
    }

    public static int m1520(Object obj) {
        if (gggy.m4365() > 0) {
            return C0447yc.m8675((Method) obj);
        }
        return 0;
    }

    public static String m12528() {
        if (gggy.m4365() >= 0) {
            return C0448yd.m9031(m12430(), 648, 35, 1817);
        }
        return null;
    }

    public static String m12529() {
        if (C0456zb.m10484() < 0) {
            return abf.m2527(m12430(), 683, 27, 3068);
        }
        return null;
    }

    public static String m12530() {
        if (C0447yc.m8786() > 0) {
            return C0448yd.m9031(m12430(), 710, 6, 3089);
        }
        return null;
    }

    public static C0409oo m12531(Object obj, Object obj2, int i, int i2, Object obj3) {
        if (C0448yd.m9015() < 0) {
            return C0456zb.m10300((C0409oo) obj, (String) obj2, i, i2, (Charset) obj3);
        }
        return null;
    }

    public static void m12532(Object obj, Object obj2, int i, int i2) {
        if (abd.m2166() <= 0) {
            C0445ya.m8247((Inflater) obj, (byte[]) obj2, i, i2);
        }
    }

    public static C0291kf m12533(Object obj, Object obj2) {
        if (C0447yc.m8786() >= 0) {
            return C0448yd.m8884((C0291kf) obj, (C0271jm) obj2);
        }
        return null;
    }

    public static String m12534(Object obj, Object obj2) {
        if (C0447yc.m8786() >= 0) {
            return C0455za.m10059((C0396ob) obj, (SSLSocket) obj2);
        }
        return null;
    }

    public static Proxy m12535(Object obj) {
        if (gggy.m4365() > 0) {
            return C0459zf.m10987((C0239ih) obj);
        }
        return null;
    }

    public static String m12536(Object obj) {
        if (C0448yd.m9015() <= 0) {
            return C0455za.m10270((Class) obj);
        }
        return null;
    }

    public static String m12537() {
        if (C0458ze.m10926() < 0) {
            return adds.m2884(m12430(), 716, 15, 2881);
        }
        return null;
    }

    public static String m12538(Object obj) {
        if (C0459zf.m11053() > 0) {
            return abe.m2302((String) obj);
        }
        return null;
    }

    public static Throwable m12539(Object obj, Object obj2) {
        if (abe.m2321() <= 0) {
            return C0450yf.m9368((InterruptedIOException) obj, (Throwable) obj2);
        }
        return null;
    }

    public static void m12540(Object obj) {
        if (C0458ze.m10926() <= 0) {
            abc.m1924((SharedPreferences.Editor) obj);
        }
    }

    public static void m12541(Object obj) {
        if (C0457zc.m10555() > 0) {
            abd.m1983((ThreadLocal) obj);
        }
    }

    public static Bitmap m12542(Object obj, Object obj2, Object obj3) {
        if (gggy.m4365() > 0) {
            return abf.m2552((InputStream) obj, (Rect) obj2, (BitmapFactory.Options) obj3);
        }
        return null;
    }

    public static String m12543() {
        if (C0448yd.m9015() < 0) {
            return abd.m2070(m12430(), 731, 3, 1235);
        }
        return null;
    }

    public static boolean m12544(Object obj, int i, Object obj2, int i2, int i3) {
        if (C0457zc.m10718() <= 0) {
            return C0447yc.m8670((String) obj, i, (String) obj2, i2, i3);
        }
        return false;
    }

    public static C0261jc m12545(Object obj) {
        if (C0453yj.m9945() < 0) {
            return C0461zs.m11597((C0279ju) obj);
        }
        return null;
    }

    public static SocketFactory m12546(Object obj) {
        if (abd.m2166() <= 0) {
            return C0452yh.m9752((C0239ih) obj);
        }
        return null;
    }

    public static String m12547() {
        if (abd.m2021() >= 0) {
            return C0458ze.m10915(m12430(), 734, 8, 742);
        }
        return null;
    }

    public static String m12548() {
        if (C0445ya.m8330() >= 0) {
            return C0452yh.m9820(m12430(), 742, 2, 846);
        }
        return null;
    }

    public static byte m12549(Object obj, int i) {
        if (abd.m2166() <= 0) {
            return C0459zf.m11170((C0412or) obj, i);
        }
        return (byte) 0;
    }

    public static String m12550(Object obj) {
        if (C0458ze.m10926() < 0) {
            return C0457zc.m10570((StringWriter) obj);
        }
        return null;
    }

    public static InterfaceC0410op m12551(Object obj) {
        if (C0457zc.m10718() <= 0) {
            return abe.m2305((InterfaceC0410op) obj);
        }
        return null;
    }

    public static C0409oo m12552(Object obj) {
        if (C0445ya.m8330() > 0) {
            return C0456zb.m10494((C0409oo) obj);
        }
        return null;
    }

    public static SocketAddress m12553(Object obj) {
        if (C0460zg.m11293() > 0) {
            return abc.m1974((Proxy) obj);
        }
        return null;
    }

    public static void m12554(Object obj, Object obj2, Object obj3) {
        if (C0445ya.m8330() > 0) {
            C0461zs.m11577((C0317le) obj, (C0294ki) obj2, (IOException) obj3);
        }
    }

    public static boolean m12555(Object obj, int i, Object obj2) {
        if (abd.m2166() < 0) {
            return C0456zb.m10386((InterfaceC0429ph) obj, i, (TimeUnit) obj2);
        }
        return false;
    }

    public static int m12556(Object obj, int i) {
        if (C0445ya.m8330() >= 0) {
            return abd.m2009((String) obj, i);
        }
        return 0;
    }
}
