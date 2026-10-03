package com.google.android.material.card2;

import android.animation.ObjectAnimator;
import android.app.AlertDialog;
import android.content.ContentResolver;
import android.content.SharedPreferences;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.view.View;
import android.widget.ImageView;
import java.io.ByteArrayOutputStream;
import java.io.Closeable;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Method;
import java.lang.reflect.Type;
import java.net.Proxy;
import java.net.ProxySelector;
import java.security.MessageDigest;
import java.security.Principal;
import java.security.cert.X509Certificate;
import java.text.DateFormat;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.atomic.AtomicIntegerArray;
import java.util.zip.CRC32;
import javax.security.auth.x500.X500Principal;

public class C0615 {

    private static final short[] f1481short = {1159, 1190, 1213, 1257, 1192, 1257, 1155, 1178, 1158, 1159, 1257, 1158, 1195, 1187, 1196, 1194, 1213, 1267, 1257, 2600, 2606, 2604, 2583, 2586, 2579, 2566, 2588, 2577, 2576, 2583, 2588, 2576, 2583, 2577, 2566, 2562, 2574, 2659, 2608, 2615, 2609, 2598, 2594, 2606, 2570, 2599, 2659, 2686, 2686, 2659, 2675, 2479, 2487, 2472, 2468, 2494, 2488, 2495, 2483, 2468, 2473, 2472, 2490, 2468, 2476, 2482, 2479, 2483, 2468, 2490, 2494, 2472, 2468, 2505, 2510, 2509, 2468, 2488, 2489, 2488, 2468, 2472, 2483, 2490, 2504, 2499, 2511, 1309, 1297, 1296, 1290, 1307, 1296, 1290, 1363, 1298, 1307, 1296, 1305, 1290, 1302, 2152, 2160, 2159, 2147, 2167, 2158, 2174, 2057, 2147, 2169, 2148, 2156, 2163, 2158, 2152, 2147, 2155, 2165, 2152, 2164, 2147, 2168, 2169, 2159, 2147, 2175, 2174, 2175, 2147, 2056, 2060, 2147, 2159, 2164, 2173, 3314, 3315, 3300, 995, 1019, 996, 1000, 1010, 1012, 1011, 1023, 1010, 1000, 1010, 1012, 1011, 996, 1014, 1000, 992, 1022, 995, 1023, 1000, 900, 1011, 1010, 996, 1000, 1010, 1011, 1010, 1000, 1012, 1013, 1012, 1000, 996, 1023, 1014, 2101, 2097, 2102, 2165, 2110, 2090, 2109, 2091, 2096, 2149, 336, 280, 277, 264, 333, 1671, 1691, 1691, 1695, 1760, 1790, 1761, 2548, 2540, 2547, 2559, 2532, 2536, 2533, 2559, 2532, 2547, 2547, 2559, 2551, 2537, 2548, 2536, 2559, 2531, 2529, 2541, 2533, 2540, 2540, 2537, 2529, 2559, 2449, 2450, 2456, 2559, 2531, 2530, 2531, 2559, 2547, 2536, 2529, 1863, 1860, 1863, 1863, 307, 299, 308, 312, 290, 292, 291, 303, 290, 312, 309, 308, 294, 312, 304, 302, 307, 303, 312, 294, 290, 308, 312, 341, 338, 337, 312, 292, 293, 292, 312, 308, 303, 294, 1391, 1396, 1405, 1297, 1294, 1289, 1290, 2416, 2427, 2412, 2427, 2356, 2412, 2431, 2408, 2409, 2419, 2421, 2420, 3143, 3143, 3143, 3106, 3174, 3174, 3119, 3151, 3151, 3151, 3119, 3195, 3195, 3106, 3146, 3146, 3128, 3183, 3183, 3128, 3185, 3185, 3106, 3192, 2965, 2971, 2788, 2783, 2776, 2752, 2792, 2787, 2782, 2778, 2770, 1387, 1404, 1323, 1572, 1605, 1542, 1546, 1547, 1547, 1536, 1542, 1553, 1548, 1546, 1547, 1605, 1553, 1546, 1605, 1309, 1285, 1306, 1302, 1292, 1290, 1293, 1281, 1302, 1307, 1306, 1288, 1302, 1310, 1280, 1309, 1281, 1302, 1288, 1292, 1306, 1302, 1400, 1403, 1393, 1302, 1294, 1290, 1284, 1302, 1306, 1281, 1288, 1403, 1404, 1407, 474, 472, 474, 465, 476, 409, 464, 458, 409, 474, 469, 470, 458, 476, 477, 1837, 1837, 1837, 1856, 1796, 1868, 1856, 1817, 1817, 1817, 1817, 3032, 3027, 3033, 3010, 3029, 3032, 3036, 3033, 3032, 3023, 3022, 2143, 2129, 2083, 2068, 2070, 2072, 2050, 2053, 2068, 2051, 2072, 2079, 2070, 2129, 2064, 2079, 2129, 2104, 2079, 2050, 2053, 2064, 2079, 2066, 2068, 2098, 2051, 2068, 2064, 2053, 2078, 2051, 2129, 2054, 2072, 2053, 2073, 2129, 2102, 2050, 2078, 2079, 2129, 2071, 2078, 2051, 2129, 2053, 2073, 2072, 2050, 2129, 2053, 2056, 2049, 2068, 2129, 2076, 2064, 2056, 2129, 2071, 2072, 2057, 2129, 2053, 2073, 2072, 2050, 2129, 2049, 2051, 2078, 2067, 2077, 2068, 2076, 2143, 2058, 2058, 2069, 2054, 2077, 2065, 2054, 2104, 2103, 2102, 2103, 2054, 2076, 2049, 2057, 2070, 2059, 2061, 2054, 2062, 2064, 2061, 2065, 2054, 2077, 2076, 2058, 2157, 2153, 2054, 2074, 2075, 2074, 2054, 2058, 2065, 2072, 2179, 2183, 2176, 2203, 2202, 2187, 762, 738, 765, 753, 746, 742, 747, 753, 764, 765, 751, 753, 761, 743, 762, 742, 753, 749, 751, 739, 747, 738, 738, 743, 751, 753, 668, 667, 664, 753, 749, 748, 749, 753, 765, 742, 751, 2176, 2233, 2213, 2212, 2200, 2223, 2219, 2222, 2223, 2232, 2282, 2211, 2233, 2282, 2217, 2214, 2213, 2233, 2223, 2222, 1945, 1949, 1931, 2611, 2683, 2684, 2656, 2663, 2642, 2679, 2679, 2657, 2678, 2656, 2656, 2606, 1422, 1461, 1455, 1470, 1449, 1462, 1458, 1461, 1466, 1455, 1470, 1471, 1531, 1466, 1449, 1449, 1466, 1442, 3113, 3085, 3118, 3090, 3090, 3094, 3142, 3139, 3093, 3142, 3126, 3091, 3093, 3086, 3142, 3113, 3076, 3093, 3075, 3092, 3088, 3075, 3092, 1652, 1648, 1651, 1647, 1647, 1643, 1588, 1576, 1589, 1570, 1589, 1578, 2319, 2315, 2311, 2305, 2307, 2361, 2319, 2309, 2313, 2312, 2299, 2241, 2189, 2266, 2192, 2189, 2201, 2303, 2189, 2301, 2267, 2193, 2188, 2193, 2194, 2192, 2269, 654, 681, 683, 700, 679, 698, 689, 659, 700, 689, 696, 685, 640, 673, 685, 698, 681, 698, 683, 672, 689, 757, 2175, 2170, 2171, 2125, 2144, 2144, 2147, 2154, 2158, 2145, 827, 788, 785, 792, 861, 798, 796, 798, 789, 792, 861, 789, 796, 782, 861, 792, 773, 781, 788, 783, 792, 793, 851, 861, 815, 792, 795, 783, 792, 782, 789, 788, 787, 794, 851, 2245, 2248, 2241, 2260, 2254, 2241, 2243, 2264, 2270, 2243, 2264, 2245, 2248, 2225, 2301, 2292, 2303, 2294, 2277, 2297, 2219, 2225, 2228, 2293, 2225, 2224, 2220, 2225, 2212, 2321, 2366, 2365, 2337, 2363, 2364, 2357, 2418, 2342, 2362, 2359, 2418, 2352, 2365, 2358, 2347, 2418, 2365, 2356, 2418, 318, 261, 270, 275, 283, 270, 264, 287, 270, 271, 331, 264, 259, 266, 281, 331, 334, 328, 347, 351, 275, 331, 266, 287, 331, 334, 271, 331, 258, 261, 331, 334, 280, 331, 285, 266, 263, 286, 270, 337, 331, 334, 280, 408, 444, 415, 419, 419, 423, 503, 404, 440, 441, 441, 434, 436, 419, 446, 440, 441, 391, 440, 440, 443, 1904, 1900, 1910, 1905, 1888, 1894, 1835, 2326, 2408, 780, 782, 776, 1529, 1509, 1509, 1505, 1438, 1408, 1439, 1408};

    public static int f1482 = -23;

    public static short[] m13855() {
        if (C0459zf.m11062() > 0) {
            return f1481short;
        }
        return null;
    }

    public static int m13856() {
        if (abf.m2510() <= 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static String m13857() {
        if (C0445ya.m8330() > 0) {
            return abd.m2070(m13855(), 0, 19, 1225);
        }
        return null;
    }

    public static void m13858(Object obj, int i, boolean z, Object obj2, long j) {
        if (C0453yj.m9996() <= 0) {
            C0445ya.m8304((C0354mn) obj, i, z, (C0409oo) obj2, j);
        }
    }

    public static int m13859() {
        return 1749741 ^ C0455za.m10081(C0445ya.m8198(m13855(), 19, 3, 3274));
    }

    public static String m13860() {
        if (C0448yd.m9074() <= 0) {
            return abf.m2527(m13855(), 22, 29, 2627);
        }
        return null;
    }

    public static int m13861(Object obj) {
        if (m13856() > 0) {
            return abc.m1884((EnumC0154fd) obj);
        }
        return 0;
    }

    public static void m13862(Object obj, Object obj2, Object obj3, Object obj4, Object obj5, Object obj6) {
        if (C0457zc.m10718() <= 0) {
            abf.m2480((C0211hg) obj, (C0209he) obj2, (String) obj3, (String) obj4, (String) obj5, (InterfaceC0210hf) obj6);
        }
    }

    public static void m13863(Object obj, Object obj2) {
        if (C0447yc.m8786() >= 0) {
            C0452yh.m9670((ObjectAnimator) obj, (float[]) obj2);
        }
    }

    public static List m13864(Object obj) {
        if (m13856() > 0) {
            return C0461zs.m11497((C0314lb) obj);
        }
        return null;
    }

    public static String m13865(Object obj, Object obj2) {
        if (m13856() > 0) {
            return C0448yd.m8891((C0286ka) obj, (String) obj2);
        }
        return null;
    }

    public static String m13866() {
        if (C0447yc.m8786() > 0) {
            return C0456zb.m10478(m13855(), 51, 36, 2555);
        }
        return null;
    }

    public static String m13867() {
        if (C0456zb.m10484() <= 0) {
            return abc.m1781(m13855(), 87, 14, 1406);
        }
        return null;
    }

    public static Class m13868(Object obj) {
        if (C0460zg.m11293() >= 0) {
            return C0456zb.m10501((Type) obj);
        }
        return null;
    }

    public static EnumC0069c m13869() {
        if (C0457zc.m10555() > 0) {
            return C0457zc.m10752();
        }
        return null;
    }

    public static InterfaceC0024aj m13870() {
        if (C0457zc.m10555() >= 0) {
            return C0460zg.m11430();
        }
        return null;
    }

    public static Proxy.Type m13871() {
        if (C0453yj.m9945() < 0) {
            return C0452yh.m9720();
        }
        return null;
    }

    public static String m13872() {
        if (C0457zc.m10718() <= 0) {
            return abf.m2527(m13855(), 101, 35, 2108);
        }
        return null;
    }

    public static InterfaceC0024aj m13873() {
        if (C0445ya.m8330() > 0) {
            return C0456zb.m10428();
        }
        return null;
    }

    public static int m13874(Object obj) {
        if (C0447yc.m8786() >= 0) {
            return C0461zs.m11523((Proxy) obj);
        }
        return 0;
    }

    public static StringBuilder m13875(Object obj, Object obj2) {
        if (abf.m2500() > 0) {
            return C0453yj.m9955((StringBuilder) obj, (String) obj2);
        }
        return null;
    }

    public static C0291kf m13876(Object obj, Object obj2) {
        if (C0453yj.m10032() >= 0) {
            return C0453yj.m9936((C0291kf) obj, (C0270jl) obj2);
        }
        return null;
    }

    public static String m13877() {
        if (abd.m2166() <= 0) {
            return abe.m2412(m13855(), 136, 3, 3239);
        }
        return null;
    }

    public static void m13878(Object obj, Object obj2, long j) {
        if (C0453yj.m10032() >= 0) {
            C0461zs.m11481((AbstractC0264jf) obj, (InterfaceC0245in) obj2, j);
        }
    }

    public static String m13879(String str) {
        String strM4277 = gggy.m4277();
        String strM4278 = gggy.m4277();
        for (int i = 0; i < 15; i++) {
            strM4277 = C0455za.m10171(C0452yh.m9675(C0452yh.m9675(new StringBuffer(), strM4277), C0447yc.m8791(i)));
            strM4278 = C0455za.m10171(C0459zf.m11054(C0452yh.m9675(new StringBuffer(), strM4278), ((int) (abe.m2360() * ((double) 10))) ^ i));
        }
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream(gggy.m4397(str) / 2);
        while (gggy.m4397(str) > 0) {
            C0448yd.m8972(byteArrayOutputStream, (C0458ze.m10892(strM4277, C0446yb.m8419(str, -2)) << 4) | C0458ze.m10892(strM4277, C0446yb.m8419(str, -1)));
        }
        byte[] bArrM9611 = C0452yh.m9611(byteArrayOutputStream);
        int length = bArrM9611.length;
        int iM4397 = gggy.m4397(strM4278);
        for (int i2 = 0; i2 < length; i2++) {
            bArrM9611[i2] = (byte) (bArrM9611[i2] ^ C0446yb.m8419(strM4278, i2 % iM4397));
        }
        return new String(bArrM9611);
    }

    public static InputStream m13880(Object obj, Object obj2) {
        if (C0453yj.m9966() > 0) {
            return C0456zb.m10409((ContentResolver) obj, (Uri) obj2);
        }
        return null;
    }

    public static long m13881(Object obj) {
        if (C0448yd.m9074() < 0) {
            return C0447yc.m8677((CRC32) obj);
        }
        return 0L;
    }

    public static String m13882() {
        if (C0453yj.m9945() <= 0) {
            return C0450yf.m9476(m13855(), 139, 37, 951);
        }
        return null;
    }

    public static C0430pi m13883(Object obj, long j) {
        if (m13856() >= 0) {
            return abd.m2104((C0430pi) obj, j);
        }
        return null;
    }

    public static String m13884() {
        if (C0453yj.m9966() >= 0) {
            return C0455za.m10121(m13855(), 176, 10, 2136);
        }
        return null;
    }

    public static C0243il m13885(Object obj) {
        if (abd.m2166() < 0) {
            return C0458ze.m10789((C0244im) obj);
        }
        return null;
    }

    public static String m13886() {
        if (abf.m2500() > 0) {
            return abf.m2527(m13855(), 186, 5, 368);
        }
        return null;
    }

    public static long m13887(Object obj) {
        if (C0453yj.m10032() > 0) {
            return C0450yf.m9392((C0290ke) obj);
        }
        return 0L;
    }

    public static View m13888(Object obj, Object obj2) {
        if (C0456zb.m10484() <= 0) {
            return C0445ya.m8316((View) obj, obj2);
        }
        return null;
    }

    public static String m13889(Object obj) {
        if (C0458ze.m10926() < 0) {
            return C0458ze.m10794((Object[]) obj);
        }
        return null;
    }

    public static C0271jm m13890(Object obj) {
        if (C0457zc.m10718() < 0) {
            return abc.m1814((C0290ke) obj);
        }
        return null;
    }

    public static String m13891() {
        if (C0457zc.m10718() <= 0) {
            return C0457zc.m10560(m13855(), 191, 7, 1743);
        }
        return null;
    }

    public static String m13892() {
        if (C0453yj.m10032() >= 0) {
            return abf.m2527(m13855(), 198, 37, 2464);
        }
        return null;
    }

    public static InterfaceC0024aj m13893() {
        if (C0448yd.m9015() < 0) {
            return abd.m2180();
        }
        return null;
    }

    public static C0412or m13894(Object obj, int i, int i2) {
        if (C0460zg.m11293() > 0) {
            return C0447yc.m8631((C0412or) obj, i, i2);
        }
        return null;
    }

    public static String m13895(Object obj) {
        if (abe.m2321() <= 0) {
            return C0457zc.m10712((C0273jo) obj);
        }
        return null;
    }

    public static int m13896(Object obj, int i) {
        if (C0458ze.m10926() < 0) {
            return C0450yf.m9498((AtomicIntegerArray) obj, i);
        }
        return 0;
    }

    public static String m13897() {
        if (C0453yj.m9996() <= 0) {
            return C0455za.m10121(m13855(), 235, 4, 1825);
        }
        return null;
    }

    public static String m13898() {
        if (C0453yj.m9966() > 0) {
            return C0460zg.m11422(m13855(), 239, 34, 359);
        }
        return null;
    }

    public static C0291kf m13899(Object obj, long j) {
        if (C0445ya.m8330() > 0) {
            return C0445ya.m8260((C0291kf) obj, j);
        }
        return null;
    }

    public static String m13900() {
        if (C0447yc.m8786() > 0) {
            return C0448yd.m9031(m13855(), 273, 7, 1340);
        }
        return null;
    }

    public static C0291kf m13901(Object obj, Object obj2) {
        if (abf.m2500() > 0) {
            return abe.m2224((C0291kf) obj, (C0290ke) obj2);
        }
        return null;
    }

    public static Object m13902(Object obj) {
        if (C0447yc.m8786() > 0) {
            return C0453yj.m9920((ThreadLocal) obj);
        }
        return null;
    }

    public static int m13903(Object obj, Object obj2, int i, int i2) {
        if (m13856() > 0) {
            return C0460zg.m11420((InputStream) obj, (byte[]) obj2, i, i2);
        }
        return 0;
    }

    public static AbstractC0022ah m13904(Object obj) {
        if (C0447yc.m8786() >= 0) {
            return C0452yh.m9817((AbstractC0022ah) obj);
        }
        return null;
    }

    public static String m13905() {
        if (C0445ya.m8330() >= 0) {
            return C0452yh.m9820(m13855(), 280, 12, 2330);
        }
        return null;
    }

    public static String m13906() {
        if (C0457zc.m10718() <= 0) {
            return C0459zf.m11207(m13855(), 292, 24, 3074);
        }
        return null;
    }

    public static String m13907(Object obj) {
        if (C0457zc.m10555() > 0) {
            return C0449ye.m9213((AssertionError) obj);
        }
        return null;
    }

    public static boolean m13908(Object obj, Object obj2) {
        if (C0453yj.m9945() <= 0) {
            return abf.m2589((C0239ih) obj, obj2);
        }
        return false;
    }

    public static String[] m13909(Object obj) {
        if (C0447yc.m8786() > 0) {
            return abe.m2378((File) obj);
        }
        return null;
    }

    public static String m13910() {
        if (C0457zc.m10718() <= 0) {
            return C0456zb.m10478(m13855(), 316, 2, 3003);
        }
        return null;
    }

    public static String m13911() {
        if (C0448yd.m9015() < 0) {
            return C0456zb.m10478(m13855(), 318, 9, 2743);
        }
        return null;
    }

    public static ProxySelector m13912(Object obj) {
        if (gggy.m4365() > 0) {
            return abe.m2225((C0279ju) obj);
        }
        return null;
    }

    public static String m13913() {
        if (C0459zf.m11053() > 0) {
            return C0460zg.m11422(m13855(), 327, 3, 1358);
        }
        return null;
    }

    public static String m13914() {
        if (C0457zc.m10555() > 0) {
            return C0448yd.m9031(m13855(), 330, 16, 1637);
        }
        return null;
    }

    public static byte[] m13915(Object obj) {
        if (C0456zb.m10484() < 0) {
            return abf.m2616((MessageDigest) obj);
        }
        return null;
    }

    public static String m13916() {
        if (C0458ze.m10926() < 0) {
            return C0453yj.m9924(m13855(), 346, 36, 1353);
        }
        return null;
    }

    public static String m13917() {
        if (C0453yj.m10032() > 0) {
            return C0456zb.m10478(m13855(), 382, 15, 441);
        }
        return null;
    }

    public static String m13918() {
        if (C0457zc.m10718() < 0) {
            return C0446yb.m8463(m13855(), 397, 11, 1888);
        }
        return null;
    }

    public static boolean m13919(Object obj, Object obj2) {
        if (C0453yj.m9945() < 0) {
            return C0447yc.m8710((Proxy) obj, obj2);
        }
        return false;
    }

    public static String m13920() {
        if (C0453yj.m10032() >= 0) {
            return abd.m2070(m13855(), 408, 11, 2973);
        }
        return null;
    }

    public static String m13921() {
        if (C0456zb.m10484() <= 0) {
            return abe.m2412(m13855(), 419, 78, 2161);
        }
        return null;
    }

    public static void m13922(Object obj) {
        if (abe.m2321() < 0) {
            C0458ze.m10802((InterfaceC0304ks) obj);
        }
    }

    public static long m13923(Object obj) {
        if (C0453yj.m9945() <= 0) {
            return C0449ye.m9266((File) obj);
        }
        return 0L;
    }

    public static Throwable m13924(Object obj, Object obj2) {
        if (C0457zc.m10555() > 0) {
            return abf.m2502((AssertionError) obj, (Throwable) obj2);
        }
        return null;
    }

    public static X500Principal m13925(Object obj) {
        if (C0453yj.m9996() <= 0) {
            return C0457zc.m10760((X509Certificate) obj);
        }
        return null;
    }

    public static String m13926() {
        if (C0448yd.m9015() < 0) {
            return C0451yg.m9579(m13855(), 497, 37, 2137);
        }
        return null;
    }

    public static String m13927() {
        if (C0453yj.m10032() > 0) {
            return C0458ze.m10915(m13855(), 534, 6, 2286);
        }
        return null;
    }

    public static String m13928() {
        if (C0447yc.m8786() > 0) {
            return abd.m2070(m13855(), 540, 37, 686);
        }
        return null;
    }

    public static int m13929(Object obj) {
        if (abd.m2166() <= 0) {
            return abe.m2384((C0409oo) obj);
        }
        return 0;
    }

    public static String m13930() {
        if (abd.m2021() > 0) {
            return C0461zs.m11581(m13855(), 577, 20, 2250);
        }
        return null;
    }

    public static X509Certificate m13931(Object obj, Object obj2) {
        if (C0457zc.m10718() < 0) {
            return C0447yc.m8771((InterfaceC0403oi) obj, (X509Certificate) obj2);
        }
        return null;
    }

    public static String m13932() {
        if (C0448yd.m9074() < 0) {
            return adds.m2884(m13855(), 597, 3, 2008);
        }
        return null;
    }

    public static int m13933(Object obj) {
        if (C0448yd.m9074() <= 0) {
            return C0455za.m10095((C0057bo) obj);
        }
        return 0;
    }

    public static String m13934() {
        if (C0447yc.m8786() > 0) {
            return C0448yd.m9031(m13855(), 600, 13, 2579);
        }
        return null;
    }

    public static boolean m13935(Object obj, Object obj2) {
        if (C0456zb.m10484() < 0) {
            return abd.m2179((HashMap) obj, obj2);
        }
        return false;
    }

    public static boolean m13936(Object obj, Object obj2) {
        if (abe.m2321() <= 0) {
            return adds.m2853((Principal) obj, obj2);
        }
        return false;
    }

    public static String m13937() {
        if (m13856() >= 0) {
            return abd.m2070(m13855(), 613, 18, 1499);
        }
        return null;
    }

    public static String m13938() {
        if (C0448yd.m9074() < 0) {
            return abd.m2070(m13855(), 631, 23, 3174);
        }
        return null;
    }

    public static double m13939(Object obj) {
        if (C0453yj.m9996() < 0) {
            return C0461zs.m11604((C0015aa) obj);
        }
        return 0.0d;
    }

    public static void m13940(Object obj) {
        if (C0459zf.m11053() > 0) {
            C0447yc.m8744((Closeable) obj);
        }
    }

    public static void m13941(Object obj, boolean z) {
        if (m13856() >= 0) {
            C0458ze.m10767((C0155fe) obj, z);
        }
    }

    public static String m13942() {
        if (C0458ze.m10926() < 0) {
            return C0457zc.m10560(m13855(), 654, 12, 1563);
        }
        return null;
    }

    public static Object m13943(Object obj, Object obj2) {
        if (abd.m2166() < 0) {
            return abf.m2448((InterfaceC0434r) obj, (Type) obj2);
        }
        return null;
    }

    public static String m13944() {
        if (abd.m2021() > 0) {
            return C0458ze.m10915(m13855(), 666, 10, 2406);
        }
        return null;
    }

    public static InterfaceC0024aj m13945() {
        if (C0457zc.m10555() > 0) {
            return adds.m2891();
        }
        return null;
    }

    public static void m13946(Object obj, Object obj2) {
        if (abf.m2500() >= 0) {
            C0456zb.m10472((ImageView) obj, (Drawable) obj2);
        }
    }

    public static AbstractC0022ah m13947() {
        if (C0445ya.m8330() > 0) {
            return C0453yj.m9854();
        }
        return null;
    }

    public static void m13948(Object obj, Object obj2) {
        if (C0460zg.m11293() > 0) {
            C0450yf.m9394((AbstractC0055bm) obj, (C0152fb) obj2);
        }
    }

    public static void m13949(Object obj) {
        if (C0457zc.m10555() > 0) {
            C0446yb.m8548((Iterator) obj);
        }
    }

    public static String m13950() {
        if (abd.m2021() > 0) {
            return C0459zf.m11207(m13855(), 676, 17, 2208);
        }
        return null;
    }

    public static AbstractC0022ah m13951() {
        if (C0458ze.m10926() <= 0) {
            return C0452yh.m9784();
        }
        return null;
    }

    public static String m13952() {
        if (C0453yj.m10032() > 0) {
            return C0448yd.m9031(m13855(), 693, 22, 712);
        }
        return null;
    }

    public static SharedPreferences.Editor m13953(Object obj) {
        if (C0458ze.m10926() < 0) {
            return C0459zf.m11181((SharedPreferences) obj);
        }
        return null;
    }

    public static String m13954() {
        if (C0447yc.m8786() >= 0) {
            return C0447yc.m8718(m13855(), 715, 10, 2063);
        }
        return null;
    }

    public static String m13955(short[] sArr, int i, int i2, int i3) {
        char[] cArr = new char[i2];
        for (int i4 = 0; i4 < i2; i4++) {
            cArr[i4] = (char) (sArr[i + i4] ^ i3);
        }
        return new String(cArr);
    }

    public static C0155fe m13956(Object obj) {
        if (C0453yj.m9945() < 0) {
            return C0455za.m10242((C0155fe) obj);
        }
        return null;
    }

    public static String m13957() {
        if (abd.m2021() >= 0) {
            return abd.m2070(m13855(), 725, 35, 893);
        }
        return null;
    }

    public static C0279ju m13958(Object obj) {
        if (C0453yj.m10032() > 0) {
            return C0453yj.m10010((C0281jw) obj);
        }
        return null;
    }

    public static String m13959() {
        if (C0453yj.m9966() >= 0) {
            return C0452yh.m9820(m13855(), 760, 29, 2193);
        }
        return null;
    }

    public static void m13960(Object obj, boolean z) {
        if (C0453yj.m10032() >= 0) {
            C0445ya.m8223((DateFormat) obj, z);
        }
    }

    public static String m13961() {
        if (m13856() > 0) {
            return C0446yb.m8463(m13855(), 789, 20, 2386);
        }
        return null;
    }

    public static AbstractC0292kg m13962(Object obj, Object obj2) {
        if (C0453yj.m10032() > 0) {
            return C0456zb.m10339((InterfaceC0324ll) obj, (C0290ke) obj2);
        }
        return null;
    }

    public static String m13963() {
        if (C0457zc.m10555() > 0) {
            return adds.m2884(m13855(), 809, 43, 363);
        }
        return null;
    }

    public static String m13964() {
        if (abd.m2166() <= 0) {
            return C0460zg.m11422(m13855(), 852, 21, 471);
        }
        return null;
    }

    public static void m13965(Object obj, Object obj2) {
        if (C0448yd.m9074() <= 0) {
            C0448yd.m8903((C0222hr) obj, (AlertDialog) obj2);
        }
    }

    public static String m13966() {
        if (m13856() > 0) {
            return C0446yb.m8463(m13855(), 873, 7, 1795);
        }
        return null;
    }

    public static String m13967() {
        if (C0448yd.m9015() <= 0) {
            return C0457zc.m10560(m13855(), 880, 2, 2378);
        }
        return null;
    }

    public static String m13968() {
        if (C0460zg.m11293() >= 0) {
            return C0448yd.m9031(m13855(), 882, 3, 830);
        }
        return null;
    }

    public static C0291kf m13969(Object obj, boolean z) {
        if (C0453yj.m9966() >= 0) {
            return abd.m2174((C0335lw) obj, z);
        }
        return null;
    }

    public static void m13970(Object obj, boolean z, Object obj2, long j, Object obj3) {
        if (C0460zg.m11293() >= 0) {
            abc.m1855((C0319lg) obj, z, (InterfaceC0324ll) obj2, j, (IOException) obj3);
        }
    }

    public static AbstractC0022ah m13971() {
        if (m13856() >= 0) {
            return C0452yh.m9630();
        }
        return null;
    }

    public static char[] m13972(Object obj) {
        if (C0447yc.m8786() >= 0) {
            return C0460zg.m11393((String) obj);
        }
        return null;
    }

    public static String m13973() {
        if (C0448yd.m9074() <= 0) {
            return C0453yj.m9924(m13855(), 885, 8, 1457);
        }
        return null;
    }

    public static int m13974(Object obj) {
        if (C0453yj.m10032() > 0) {
            return abe.m2294((Method) obj);
        }
        return 0;
    }

    public static C0155fe m13975(Object obj) {
        if (C0453yj.m9996() < 0) {
            return C0453yj.m10036((C0155fe) obj);
        }
        return null;
    }

    public static String m13976(Object obj) {
        if (C0448yd.m9015() <= 0) {
            return C0446yb.m8479((Enum) obj);
        }
        return null;
    }
}
