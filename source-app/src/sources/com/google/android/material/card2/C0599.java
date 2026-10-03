package com.google.android.material.card2;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.SharedPreferences;
import android.graphics.drawable.GradientDrawable;
import android.util.DisplayMetrics;
import android.view.View;
import java.io.ByteArrayOutputStream;
import java.io.EOFException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.ref.SoftReference;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Type;
import java.net.ConnectException;
import java.net.HttpURLConnection;
import java.net.InetAddress;
import java.net.Proxy;
import java.net.ProxySelector;
import java.net.Socket;
import java.net.URI;
import java.security.cert.Certificate;
import java.security.cert.X509Certificate;
import java.util.Deque;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.StringTokenizer;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicIntegerArray;
import javax.net.SocketFactory;
import javax.net.ssl.HostnameVerifier;

public class C0599 {

    private static final short[] f1450short = {1483, 1477, 1443, 1418, 1431, 1410, 1418, 1425, 1477, 1425, 1418, 1477, 1431, 1408, 1410, 1420, 1430, 1425, 1408, 1431, 1477, 1412, 1477, 1425, 1436, 1429, 1408, 1477, 1412, 1409, 1412, 1429, 1425, 1408, 1431, 1498, 2719, 2696, 2782, 2718, 2719, 2781, 2774, 2777, 2763, 2769, 2770, 2773, 2763, 2778, 2774, 2757, 2763, 2774, 2759, 2757, 2763, 2778, 2774, 2766, 2763, 2781, 2754, 2777, 2763, 2781, 2754, 2779, 2763, 2774, 2754, 2768, 2763, 2756, 2770, 2759, 2763, 2776, 2772, 2755, 2763, 2777, 2776, 2753, 2763, 2771, 2770, 2772, 2718, 2713, 2717, 3039, 2982, 2986, 3071, 3064, 3046, 2999, 983, 963, 976, 988, 980, 974, 962, 984, 971, 980, 974, 980, 963, 963, 990, 963, 945, 1021, 1012, 1023, 1014, 997, 1017, 945, 943, 945, 948, 1013, 939, 945, 948, 1013, 2891, 1435, 1408, 1423, 1420, 1410, 1419, 1486, 1434, 1409, 1486, 1417, 1419, 1434, 1486, 1415, 1437, 1437, 1435, 1419, 1437, 1486, 1423, 1408, 1418, 1486, 1437, 1415, 1417, 1408, 1423, 1434, 1435, 1436, 1419, 2577, 2571, 2584, 2567, 2626, 2654, 2626, 2640, 2648, 2626, 882, 874, 885, 889, 866, 878, 889, 839, 840, 841, 840, 889, 881, 879, 882, 878, 889, 871, 867, 885, 889, 788, 787, 784, 889, 869, 868, 869, 889, 885, 878, 871, 1767, 1767, 1784, 1771, 1776, 1788, 1777, 1771, 1766, 1767, 1781, 1771, 1763, 1789, 1760, 1788, 1771, 1776, 1777, 1767, 1771, 1783, 1782, 1783, 1771, 1767, 1788, 1781, 775, 814, 875, 875, 873, 876, 1008, 1009, 958, 970, 978, 973, 958, 1000, 1019, 1004, 1005, 1015, 1009, 1008, 1005, 958, 1016, 1009, 1004, 958, 1021, 1010, 1019, 1023, 1004, 1002, 1019, 998, 1002, 958, 1021, 1009, 1008, 1008, 1019, 1021, 1002, 1015, 1009, 1008, 1005, 2062, 2091, 2110, 2095, 865, 865, 865, 865, 776, 772, 832, 832, 777, 873, 873, 873, 777, 861, 861, 772, 876, 876, 798, 841, 841, 798, 855, 855, 772, 862, 862, 862, 1507, 1507, 1507, 1507, 1422, 1482, 1410, 1422, 1495, 1495, 1495, 1495, 3121, 3104, 3133, 3121, 3098, 3123, 3104, 3127, 3126, 3116, 3114, 3115, 1739, 1744, 2203, 2201, 2183, 2181, 2277, 2267, 2240, 2246, 2247, 2196, 2279, 2180, 2200, 1939, 1935, 1935, 1931, 3174, 3151, 3080, 3082, 3080, 3075, 842, 840, 851, 844, 859, 846, 863, 790, 794, 1595, 1585, 1576, 259, 274, 271, 259, 296, 259, 286, 259, 283, 274, 283, 281, 258, 260, 281, 258, 287, 274, 2580, 2568, 2568, 2572, 2579, 2578, 2576, 2565, 2926, 2920, 2927, 2921, 2926, 2903, 2939, 2932, 2939, 2941, 2943, 2920, 2874, 2855, 2855, 2874, 2932, 2927, 2934, 2934, 2022, 2046, 2017, 2029, 2036, 2035, 2046, 2046, 2032, 2035, 2033, 2041, 2029, 2017, 2033, 2017, 2020, 1258, 1255, 1263, 1248, 1254, 1265, 1219, 1260, 1248, 1257, 1249, 1226, 1251, 1251, 1270, 1248, 1265, 2209, 2236, 2295, 2671, 2671, 2671, 2566, 2570, 2638, 2638, 2567, 2663, 2663, 2567, 2643, 2643, 2643, 2643, 2570, 2658, 2658, 2576, 2631, 2631, 2576, 2649, 2649, 2570, 2640, 551, 546, 548, 3273, 3326, 3306, 3310, 3314, 3305, 3326, 3327, 3259, 3272, 3294, 3279, 3279, 3282, 3285, 3292, 3272, 3259, 3307, 3305, 3326, 3325, 3322, 3320, 3326, 3259, 3317, 3316, 3311, 3259, 3305, 3326, 3320, 3326, 3314, 3309, 3326, 3327, 1362, 1303, 1296, 1293, 1290, 1311, 1296, 1309, 1307, 1341, 1292, 1307, 1311, 1290, 1297, 1292, 1293, 1348, 447, 388, 399, 402, 410, 399, 393, 414, 399, 398, 458, 412, 395, 390, 415, 399, 470, 498, 465, 493, 493, 489, 441, 444, 490, 2154, 2154, 2165, 2150, 2155, 2154, 2168, 2150, 2158, 2160, 2157, 2161, 2150, 2167, 2156, 2165, 2165, 2150, 2154, 2161, 2168, 1936, 1936, 1806, 1792, 1803, 1818, 1803, 2082, 2080, 2107, 2109, 2080, 2048, 2103, 2081, 2082, 2109, 2108, 2081, 2103, 2172, 2096, 2109, 2102, 2091, 2162, 2163, 2159, 2162, 2108, 2087, 2110, 2110, 1905, 1893, 1913, 1912, 1814, 1877, 1879, 1880, 1880, 1881, 1858, 1814, 1861, 1875, 1860, 1887, 1879, 1882, 1887, 1868, 1875, 1814, 952, 899, 904, 917, 925, 904, 910, 921, 904, 905, 973, 910, 898, 905, 904, 973, 925, 898, 900, 899, 921, 983, 973, 2687, 2661, 2678, 2665, 2609, 2601, 2687, 2604, 2666, 2686, 2659, 2657, 2629, 2658, 2664, 2665, 2676, 2609, 2601, 2687, 2604, 2680, 2659, 2629, 2658, 2664, 2665, 2676, 2609, 2601, 2687, 1405, 1294, 1381, 1400, 1388, 1332, 1400, 1331, 1300, 1400, 1299, 1288, 1407, 1391, 1294, 1381, 1400, 1388, 1332, 1400, 1331, 1300, 1400, 1299, 1391, 1403, 1288, 1407, 1404, 1321, 1405, 1294, 1289, 1329, 1403, 1288, 1406, 1404, 3279, 3272, 3278, 3289, 3293, 3281, 3228, 3275, 3293, 3279, 3228, 3278, 3289, 3279, 3289, 3272, 3206, 3228, 930, 928, 928, 934, 944, 944, 1006, 928, 940, 941, 951, 945, 940, 943, 1006, 930, 943, 943, 940, 948, 1006, 940, 945, 938, 932, 938, 941, 1955, 1921, 1934, 1934, 1935, 1940, 1984, 1939, 1940, 1938, 1925, 1921, 1933, 1984, 1921, 1984, 1938, 1925, 1937, 1941, 1925, 1939, 1940, 1984, 1922, 1935, 1924, 1945, 1984, 1943, 1929, 1940, 1928, 1935, 1941, 1940, 1984, 1923, 1928, 1941, 1934, 1931, 1925, 1924, 1984, 1925, 1934, 1923, 1935, 1924, 1929, 1934, 1927, 1984, 1935, 1938, 1984, 1921, 1984, 1931, 1934, 1935, 1943, 1934, 1984, 1923, 1935, 1934, 1940, 1925, 1934, 1940, 1984, 1932, 1925, 1934, 1927, 1940, 1928, 1985, 1190, 1201, 1189, 1185, 1201, 1191, 1184, 1180, 1201, 1205, 1200, 1201, 1190, 1191, 1268, 1257, 1257, 1268, 1210, 1185, 1208, 1208, 1670, 1689, 1676, 1671, 780, 780, 787, 812, 784, 796, 788, 794, 779, 825, 798, 796, 779, 784, 781, 774, 863, 834, 834, 863, 785, 778, 787, 787, 939, 951, 954, 906, 945, 940, 958, 953, 954, 2179, 2191, 2191, 2187, 2185, 2181, 1955, 1935, 1950, 1947, 1947, 1946, 1947};

    public static boolean f1451;

    public static int m11909() {
        if (C0452yh.m9798() >= 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static short[] m11910() {
        if (abf.m2510() <= 0) {
            return f1450short;
        }
        return null;
    }

    public static String m11911() {
        if (C0448yd.m9015() <= 0) {
            return C0450yf.m9476(m11910(), 0, 36, 1509);
        }
        return null;
    }

    public static String m11912(Object obj) {
        if (C0453yj.m9996() < 0) {
            return C0450yf.m9347((UUID) obj);
        }
        return null;
    }

    public static Activity m11913(Object obj) {
        if (C0445ya.m8330() > 0) {
            return C0452yh.m9676((C0209he) obj);
        }
        return null;
    }

    public static boolean m11914(Object obj) {
        if (abe.m2321() < 0) {
            return C0448yd.m8963((C0155fe) obj);
        }
        return false;
    }

    public static String m11915() {
        if (C0448yd.m9074() < 0) {
            return C0456zb.m10478(m11910(), 36, 55, 2743);
        }
        return null;
    }

    public static Socket m11916(Object obj) {
        if (abe.m2321() < 0) {
            return C0460zg.m11426((SocketFactory) obj);
        }
        return null;
    }

    public static void m11917(Object obj, int i, int i2) {
        if (C0457zc.m10555() >= 0) {
            gggy.m4404((GradientDrawable) obj, i, i2);
        }
    }

    public static C0305kt m11918(Object obj) {
        if (C0457zc.m10718() <= 0) {
            return C0459zf.m11104((C0306ku) obj);
        }
        return null;
    }

    public static String m11919() {
        if (C0458ze.m10926() < 0) {
            return gggy.m4340(m11910(), 91, 1, 3040);
        }
        return null;
    }

    public static void m11920(Object obj, int i, int i2) {
        if (C0453yj.m9966() > 0) {
            C0460zg.m11379((AtomicIntegerArray) obj, i, i2);
        }
    }

    public static long m11921(Object obj, Object obj2, long j) {
        if (abe.m2321() <= 0) {
            return C0445ya.m8333((InterfaceC0429ph) obj, (C0409oo) obj2, j);
        }
        return 0L;
    }

    public static String m11922() {
        if (C0448yd.m9015() <= 0) {
            return C0448yd.m9031(m11910(), 92, 6, 2954);
        }
        return null;
    }

    public static String m11923() {
        if (C0445ya.m8330() > 0) {
            return C0459zf.m11207(m11910(), 98, 32, 913);
        }
        return null;
    }

    public static String m11924() {
        if (m11909() > 0) {
            return C0453yj.m9924(m11910(), 130, 1, 2917);
        }
        return null;
    }

    public static String m11925() {
        if (C0448yd.m9015() < 0) {
            return abd.m2070(m11910(), 131, 34, 1518);
        }
        return null;
    }

    public static InetAddress m11926(Object obj) {
        if (m11909() > 0) {
            return C0450yf.m9509((byte[]) obj);
        }
        return null;
    }

    public static Set m11927(Object obj) {
        if (gggy.m4365() >= 0) {
            return abc.m1966((Map) obj);
        }
        return null;
    }

    public static InterfaceC0410op m11928(Object obj) {
        if (C0453yj.m9945() < 0) {
            return gggy.m4298((InterfaceC0428pg) obj);
        }
        return null;
    }

    public static boolean m11929(Object obj, int i, Object obj2, int i2, int i3) {
        if (abf.m2500() >= 0) {
            return C0447yc.m8763((C0412or) obj, i, (byte[]) obj2, i2, i3);
        }
        return false;
    }

    public static OutputStream m11930(Object obj) {
        if (C0453yj.m9966() > 0) {
            return C0459zf.m11209((Socket) obj);
        }
        return null;
    }

    public static String m11931() {
        if (C0453yj.m10032() > 0) {
            return C0453yj.m9924(m11910(), 165, 10, 2658);
        }
        return null;
    }

    public static InputStream m11932(Object obj, Object obj2) {
        if (gggy.m4365() >= 0) {
            return C0449ye.m9275((Class) obj, (String) obj2);
        }
        return null;
    }

    public static String m11933() {
        if (C0453yj.m10032() > 0) {
            return abe.m2412(m11910(), 175, 32, 806);
        }
        return null;
    }

    public static String m11934(Object obj) {
        if (C0457zc.m10555() >= 0) {
            return C0456zb.m10401((C0273jo) obj);
        }
        return null;
    }

    public static String m11935() {
        if (C0453yj.m9945() <= 0) {
            return abf.m2527(m11910(), 207, 28, 1716);
        }
        return null;
    }

    public static SharedPreferences.Editor m11936(Object obj, Object obj2, int i) {
        if (gggy.m4365() >= 0) {
            return C0457zc.m10656((SharedPreferences.Editor) obj, (String) obj2, i);
        }
        return null;
    }

    public static String m11937() {
        if (C0445ya.m8330() >= 0) {
            return C0460zg.m11422(m11910(), 235, 6, 859);
        }
        return null;
    }

    public static boolean m11938(Object obj) {
        if (C0448yd.m9074() < 0) {
            return C0455za.m10083((StringTokenizer) obj);
        }
        return false;
    }

    public static String m11939() {
        if (m11909() > 0) {
            return C0452yh.m9820(m11910(), 241, 41, 926);
        }
        return null;
    }

    public static long m11940(Object obj) {
        if (C0445ya.m8330() >= 0) {
            return C0457zc.m10657((String) obj);
        }
        return 0L;
    }

    public static int m11941(Object obj) {
        if (gggy.m4365() > 0) {
            return C0446yb.m8530((String) obj);
        }
        return 0;
    }

    public static boolean m11942(Object obj, Object obj2) {
        if (C0460zg.m11293() > 0) {
            return abc.m1863(obj, obj2);
        }
        return false;
    }

    public static boolean m11943(Object obj) {
        if (C0459zf.m11053() > 0) {
            return C0446yb.m8447((Socket) obj);
        }
        return false;
    }

    public static String m11944() {
        if (C0460zg.m11293() > 0) {
            return C0460zg.m11422(m11910(), 282, 4, 2122);
        }
        return null;
    }

    public static List m11945(Object obj) {
        if (C0447yc.m8786() > 0) {
            return C0455za.m10077(obj);
        }
        return null;
    }

    public static String m11946() {
        if (C0448yd.m9074() < 0) {
            return abd.m2070(m11910(), 286, 28, 804);
        }
        return null;
    }

    public static String m11947() {
        if (C0445ya.m8330() >= 0) {
            return C0461zs.m11581(m11910(), 314, 12, 1454);
        }
        return null;
    }

    public static String m11948() {
        if (C0457zc.m10718() < 0) {
            return gggy.m4340(m11910(), 326, 12, 3141);
        }
        return null;
    }

    public static String m11949() {
        if (abf.m2500() > 0) {
            return C0460zg.m11422(m11910(), 338, 2, 1776);
        }
        return null;
    }

    public static Proxy.Type m11950() {
        if (C0453yj.m9945() <= 0) {
            return abf.m2512();
        }
        return null;
    }

    public static Appendable m11951(Object obj, Object obj2, int i, int i2) {
        if (C0453yj.m9996() <= 0) {
            return adds.m2861((Appendable) obj, (CharSequence) obj2, i, i2);
        }
        return null;
    }

    public static String m11952() {
        if (gggy.m4365() >= 0) {
            return abe.m2412(m11910(), 340, 13, 2235);
        }
        return null;
    }

    public static int m11953(Object obj) {
        if (C0445ya.m8330() > 0) {
            return abd.m1981((InterfaceC0277js) obj);
        }
        return 0;
    }

    public static String m11954() {
        if (C0453yj.m9945() < 0) {
            return C0451yg.m9579(m11910(), 353, 4, 2043);
        }
        return null;
    }

    public static String m11955() {
        if (C0448yd.m9074() <= 0) {
            return abd.m2070(m11910(), 357, 6, 3130);
        }
        return null;
    }

    public static AbstractC0441v m11956(Object obj) {
        if (abd.m2166() <= 0) {
            return C0449ye.m9101((C0152fb) obj);
        }
        return null;
    }

    public static String m11957() {
        if (abd.m2021() > 0) {
            return C0445ya.m8198(m11910(), 363, 9, 826);
        }
        return null;
    }

    public static String m11958() {
        if (C0453yj.m9966() > 0) {
            return gggy.m4340(m11910(), 372, 3, 1660);
        }
        return null;
    }

    public static String m11959(Object obj, Object obj2) {
        if (C0453yj.m10032() > 0) {
            return abf.m2458((HttpURLConnection) obj, (String) obj2);
        }
        return null;
    }

    public static long m11960(Object obj) {
        if (C0447yc.m8786() >= 0) {
            return C0461zs.m11471((C0430pi) obj);
        }
        return 0L;
    }

    public static String m11961() {
        if (C0459zf.m11053() >= 0) {
            return C0455za.m10121(m11910(), 375, 10, 375);
        }
        return null;
    }

    public static String m11962(String str) {
        String strM4277 = gggy.m4277();
        String strM4278 = gggy.m4277();
        for (int i = 0; i < 15; i++) {
            strM4277 = C0455za.m10171(C0452yh.m9675(C0452yh.m9675(new StringBuffer(), strM4277), C0447yc.m8791(i)));
            strM4278 = C0455za.m10171(C0459zf.m11054(C0452yh.m9675(new StringBuffer(), strM4278), ((int) (abe.m2360() * ((double) 10))) ^ i));
        }
        while (gggy.m4397(strM4277) > 0) {
        }
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream(gggy.m4397(str) / 2);
        for (int i2 = 0; i2 < gggy.m4397(str); i2 += 2) {
            C0448yd.m8972(byteArrayOutputStream, (C0458ze.m10892(strM4277, C0446yb.m8419(str, i2)) << 4) | C0458ze.m10892(strM4277, C0446yb.m8419(str, i2 + 1)));
        }
        byte[] bArrM9611 = C0452yh.m9611(byteArrayOutputStream);
        int length = bArrM9611.length;
        int iM4397 = gggy.m4397(strM4278);
        for (int i3 = 0; i3 < length; i3++) {
            bArrM9611[i3] = (byte) (bArrM9611[i3] ^ C0446yb.m8419(strM4278, i3 % iM4397));
        }
        return new String(bArrM9611);
    }

    public static boolean m11963(Object obj) {
        if (C0453yj.m9996() < 0) {
            return C0447yc.m8789(obj);
        }
        return false;
    }

    public static void m11964(Object obj, Object obj2) {
        if (C0456zb.m10484() < 0) {
            C0456zb.m10334((Object[]) obj, obj2);
        }
    }

    public static String m11965() {
        if (C0459zf.m11053() >= 0) {
            return C0445ya.m8198(m11910(), 385, 8, 331);
        }
        return null;
    }

    public static String m11966() {
        if (C0447yc.m8786() >= 0) {
            return C0461zs.m11581(m11910(), 393, 8, 2684);
        }
        return null;
    }

    public static Type[] m11967(Object obj) {
        if (C0460zg.m11293() > 0) {
            return C0459zf.m11002((Class) obj);
        }
        return null;
    }

    public static String m11968(Object obj) {
        if (C0457zc.m10718() <= 0) {
            return C0460zg.m11306((Certificate) obj);
        }
        return null;
    }

    public static String m11969() {
        if (C0460zg.m11293() > 0) {
            return C0453yj.m9924(m11910(), 401, 20, 2842);
        }
        return null;
    }

    public static String m11970(Object obj) {
        if (abe.m2321() < 0) {
            return adds.m2896((InvocationTargetException) obj);
        }
        return null;
    }

    public static void m11971(Object obj, Object obj2) throws EOFException {
        if (C0453yj.m9966() > 0) {
            abc.m1783((C0409oo) obj, (byte[]) obj2);
        }
    }

    public static C0247ip m11972(Object obj) {
        if (C0460zg.m11293() >= 0) {
            return C0448yd.m8893((C0279ju) obj);
        }
        return null;
    }

    public static void m11973(Object obj, Object obj2) {
        if (C0453yj.m9996() < 0) {
            adds.m2700((View) obj, (View.OnTouchListener) obj2);
        }
    }

    public static int m11974(Object obj) {
        if (abf.m2500() >= 0) {
            return C0448yd.m9076((C0373nf) obj);
        }
        return 0;
    }

    public static String m11975() {
        if (C0458ze.m10926() < 0) {
            return C0450yf.m9476(m11910(), 421, 17, 1970);
        }
        return null;
    }

    public static String m11976() {
        if (C0460zg.m11293() > 0) {
            return abd.m2070(m11910(), 438, 17, 1157);
        }
        return null;
    }

    public static List m11977(Object obj) {
        if (C0453yj.m9996() < 0) {
            return C0445ya.m8233((Object[]) obj);
        }
        return null;
    }

    public static boolean m11978(Object obj, Object obj2, Object obj3) {
        if (abf.m2500() > 0) {
            return C0445ya.m8224((C0314lb) obj, (C0239ih) obj2, (C0294ki) obj3);
        }
        return false;
    }

    public static String m11979() {
        if (abe.m2321() <= 0) {
            return C0457zc.m10560(m11910(), 455, 3, 2180);
        }
        return null;
    }

    public static String m11980() {
        if (C0445ya.m8330() > 0) {
            return abc.m1781(m11910(), 458, 26, 2602);
        }
        return null;
    }

    public static ProxySelector m11981() {
        if (abf.m2500() >= 0) {
            return C0456zb.m10424();
        }
        return null;
    }

    public static int m11982() {
        return (-1753587) ^ C0455za.m10081(C0446yb.m8463(m11910(), 484, 3, 1217));
    }

    public static String m11983() {
        if (m11909() > 0) {
            return abd.m2070(m11910(), 487, 38, 3227);
        }
        return null;
    }

    public static String m11984() {
        if (C0453yj.m10032() >= 0) {
            return C0453yj.m9924(m11910(), 525, 18, 1406);
        }
        return null;
    }

    public static String m11985(short[] sArr, int i, int i2, int i3) {
        char[] cArr = new char[i2];
        for (int i4 = 0; i4 < i2; i4++) {
            cArr[i4] = (char) (sArr[i + i4] ^ i3);
        }
        return new String(cArr);
    }

    public static String m11986() {
        if (C0453yj.m9945() <= 0) {
            return adds.m2884(m11910(), 543, 16, 490);
        }
        return null;
    }

    public static String m11987(Object obj) {
        if (C0453yj.m10032() > 0) {
            return C0446yb.m8452((Activity) obj);
        }
        return null;
    }

    public static void m11988(Object obj, Object obj2, Object obj3) {
        if (C0456zb.m10484() < 0) {
            abf.m2624((AbstractC0264jf) obj, (InterfaceC0245in) obj2, (InterfaceC0252iu) obj3);
        }
    }

    public static List m11989(Object obj) {
        if (m11909() >= 0) {
            return C0456zb.m10497((Object[]) obj);
        }
        return null;
    }

    public static boolean m11990(Object obj, Object obj2) {
        if (C0456zb.m10484() <= 0) {
            return gggy.m4301((Deque) obj, obj2);
        }
        return false;
    }

    public static String m11991(Object obj) {
        if (C0457zc.m10555() > 0) {
            return C0450yf.m9537((C0152fb) obj);
        }
        return null;
    }

    public static String m11992() {
        if (C0460zg.m11293() >= 0) {
            return C0451yg.m9579(m11910(), 559, 9, 409);
        }
        return null;
    }

    public static Type m11993(Object obj, Object obj2, Object obj3) {
        if (abd.m2021() > 0) {
            return C0455za.m10214((Type) obj, (Class) obj2, (Type) obj3);
        }
        return null;
    }

    public static String m11994() {
        if (C0457zc.m10555() >= 0) {
            return C0461zs.m11581(m11910(), 568, 21, 2105);
        }
        return null;
    }

    public static void m11995(Object obj, int i, Object obj2, Object obj3) {
        if (C0448yd.m9074() < 0) {
            abf.m2637((C0396ob) obj, i, (String) obj2, (Throwable) obj3);
        }
    }

    public static EnumC0019ae m11996() {
        if (C0453yj.m9966() >= 0) {
            return gggy.m4422();
        }
        return null;
    }

    public static boolean m11997(int i) {
        if (C0460zg.m11293() > 0) {
            return C0456zb.m10426(i);
        }
        return false;
    }

    public static boolean m11998(Object obj) {
        if (C0447yc.m8786() >= 0) {
            return C0459zf.m11137((Class) obj);
        }
        return false;
    }

    public static String m11999() {
        if (C0460zg.m11293() > 0) {
            return C0452yh.m9820(m11910(), 589, 2, 1964);
        }
        return null;
    }

    public static String m12000() {
        if (C0457zc.m10555() > 0) {
            return abe.m2412(m11910(), 591, 5, 1864);
        }
        return null;
    }

    public static Object m12001(Object obj, Object obj2) {
        if (abd.m2166() < 0) {
            return C0461zs.m11495((Hashtable) obj, obj2);
        }
        return null;
    }

    public static boolean m12002(Object obj, Object obj2) {
        if (C0453yj.m9966() > 0) {
            return C0448yd.m8895((X509Certificate) obj, obj2);
        }
        return false;
    }

    public static String m12003() {
        if (C0448yd.m9074() <= 0) {
            return C0458ze.m10915(m11910(), 596, 26, 2130);
        }
        return null;
    }

    public static String m12004() {
        if (C0456zb.m10484() <= 0) {
            return C0445ya.m8198(m11910(), 622, 22, 1846);
        }
        return null;
    }

    public static void m12005(Object obj, Object obj2, Object obj3, Object obj4) {
        if (C0453yj.m9966() >= 0) {
            C0450yf.m9342((InterfaceC0210hf) obj, (String) obj2, (String) obj3, (HashMap) obj4);
        }
    }

    public static int m12006(Object obj) {
        if (C0448yd.m9015() <= 0) {
            return C0447yc.m8711((DisplayMetrics) obj);
        }
        return 0;
    }

    public static void m12007(int i) {
        if (C0457zc.m10555() >= 0) {
            abe.m2316(i);
        }
    }

    public static String m12008() {
        if (C0453yj.m10032() >= 0) {
            return abc.m1781(m11910(), 644, 23, 1005);
        }
        return null;
    }

    public static URI m12009(Object obj) {
        if (m11909() >= 0) {
            return abf.m2615((C0273jo) obj);
        }
        return null;
    }

    public static Object m12010(Object obj) {
        if (C0453yj.m10032() >= 0) {
            return C0453yj.m9929((SoftReference) obj);
        }
        return null;
    }

    public static void m12011(Object obj, Object obj2) {
        if (C0447yc.m8786() > 0) {
            C0447yc.m8727((ThreadLocal) obj, obj2);
        }
    }

    public static Class m12012(Object obj) {
        if (C0453yj.m9996() <= 0) {
            return C0448yd.m8894((Class) obj);
        }
        return null;
    }

    public static EnumC0154fd m12013() {
        if (C0447yc.m8786() >= 0) {
            return C0450yf.m9562();
        }
        return null;
    }

    public static String m12014() {
        if (C0447yc.m8786() >= 0) {
            return C0457zc.m10560(m11910(), 667, 31, 2572);
        }
        return null;
    }

    public static IOException m12015(Object obj) {
        if (C0459zf.m11053() >= 0) {
            return C0460zg.m11400((C0316ld) obj);
        }
        return null;
    }

    public static String m12016() {
        if (C0448yd.m9074() < 0) {
            return C0446yb.m8463(m11910(), 698, 38, 1365);
        }
        return null;
    }

    public static void m12017(Object obj, Object obj2) {
        if (C0448yd.m9015() <= 0) {
            abf.m2559((AbstractC0264jf) obj, (InterfaceC0245in) obj2);
        }
    }

    public static String m12018() {
        if (C0445ya.m8330() > 0) {
            return C0452yh.m9820(m11910(), 736, 18, 3260);
        }
        return null;
    }

    public static String m12019(Object obj) {
        if (C0448yd.m9015() < 0) {
            return C0446yb.m8426((C0412or) obj);
        }
        return null;
    }

    public static EnumC0346mf m12020(Object obj) {
        if (C0445ya.m8330() >= 0) {
            return abd.m2007((C0384nq) obj);
        }
        return null;
    }

    public static C0281jw m12021(Object obj, Object obj2) {
        if (abe.m2321() <= 0) {
            return C0448yd.m8880((C0281jw) obj, (HostnameVerifier) obj2);
        }
        return null;
    }

    public static String m12022() {
        if (m11909() > 0) {
            return C0451yg.m9579(m11910(), 754, 27, 963);
        }
        return null;
    }

    public static Class m12023(Object obj) {
        if (C0453yj.m9945() <= 0) {
            return C0452yh.m9796((Field) obj);
        }
        return null;
    }

    public static EnumC0346mf m12024() {
        if (gggy.m4365() > 0) {
            return C0452yh.m9727();
        }
        return null;
    }

    public static AbstractC0264jf m12025(Object obj, Object obj2) {
        if (C0457zc.m10555() > 0) {
            return gggy.m4440((InterfaceC0267ji) obj, (InterfaceC0245in) obj2);
        }
        return null;
    }

    public static String m12026() {
        if (C0453yj.m9945() < 0) {
            return C0461zs.m11581(m11910(), 781, 80, 2016);
        }
        return null;
    }

    public static String m12027() {
        if (C0448yd.m9015() <= 0) {
            return C0461zs.m11581(m11910(), 861, 22, 1236);
        }
        return null;
    }

    public static String m12028() {
        if (C0448yd.m9015() < 0) {
            return C0452yh.m9820(m11910(), 883, 4, 1769);
        }
        return null;
    }

    public static String m12029() {
        if (C0457zc.m10555() > 0) {
            return C0452yh.m9820(m11910(), 887, 24, 895);
        }
        return null;
    }

    public static String m12030() {
        if (C0457zc.m10718() < 0) {
            return C0453yj.m9924(m11910(), 911, 9, 991);
        }
        return null;
    }

    public static C0412or m12031(Object obj) {
        if (abd.m2166() < 0) {
            return abc.m1938((C0347mg) obj);
        }
        return null;
    }

    public static EnumC0154fd m12032() {
        if (abf.m2500() >= 0) {
            return C0457zc.m10651();
        }
        return null;
    }

    public static String m12033() {
        if (C0445ya.m8330() >= 0) {
            return C0451yg.m9579(m11910(), 920, 6, 2272);
        }
        return null;
    }

    public static void m12034(Object obj, Object obj2, int i) {
        if (C0448yd.m9074() <= 0) {
            C0458ze.m10901((C0222hr) obj, (AlertDialog) obj2, i);
        }
    }

    public static String m12035() {
        if (C0453yj.m9996() < 0) {
            return C0452yh.m9820(m11910(), 926, 7, 2015);
        }
        return null;
    }

    public static Throwable m12036(Object obj, Object obj2) {
        if (C0453yj.m9966() >= 0) {
            return C0453yj.m9949((ConnectException) obj, (Throwable) obj2);
        }
        return null;
    }

    public static StringBuffer m12037(Object obj, Object obj2) {
        if (C0448yd.m9015() <= 0) {
            return abe.m2201((StringBuffer) obj, (String) obj2);
        }
        return null;
    }

    public static void m12038(Object obj, int i, int i2, byte b) {
        if (C0453yj.m9996() <= 0) {
            C0456zb.m10400((byte[]) obj, i, i2, b);
        }
    }
}
