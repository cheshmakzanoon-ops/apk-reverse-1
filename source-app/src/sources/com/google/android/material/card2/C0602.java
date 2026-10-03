package com.google.android.material.card2;

import android.app.Activity;
import android.content.SharedPreferences;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.lang.reflect.AccessibleObject;
import java.lang.reflect.Type;
import java.net.HttpURLConnection;
import java.net.Socket;
import java.net.SocketException;
import java.security.cert.X509Certificate;
import java.sql.Time;
import java.text.ParsePosition;
import java.util.Collection;
import java.util.Comparator;
import java.util.Date;
import java.util.EnumSet;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.TimeZone;
import java.util.concurrent.ThreadFactory;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.zip.Inflater;

public class C0602 {

    private static final short[] f1455short = {1169, 1244, 1246, 1244, 1239, 1242, 1261, 1242, 1228, 1231, 1232, 1233, 1228, 1242, 1183, 1182, 1154, 1183, 1233, 1226, 1235, 1235, 2824, 2832, 2831, 2819, 2841, 2847, 2840, 2836, 2819, 2841, 2847, 2840, 2831, 2845, 2819, 2827, 2837, 2824, 2836, 2819, 2845, 2841, 2831, 2819, 2925, 2926, 2916, 2819, 2847, 2846, 2847, 2819, 2831, 2836, 2845, 3033, 3013, 3039, 3032, 3017, 3023, 2954, 2967, 2967, 2954, 3038, 3010, 3011, 3033, 2457, 2462, 2487, 2546, 2546, 2546, 2546, 2543, 2462, 2487, 2546, 2546, 2547, 2436, 2462, 2487, 2546, 2546, 2549, 2436, 2543, 2462, 2487, 2546, 2546, 2555, 2436, 2462, 2482, 2489, 2472, 2467, 2484, 2467, 2453, 2474, 2475, 2486, 2471, 2481, 2482, 2467, 2465, 2471, 2495, 2463, 1058, 1070, 1146, 1135, 1129, 1075, 2242, 2240, 2269, 2242, 2242, 2259, 2246, 2257, 2266, 2022, 1985, 1993, 1996, 1989, 1988, 1920, 2004, 1999, 1920, 2002, 1989, 1985, 1988, 1920, 2000, 2005, 1986, 1996, 1993, 1987, 1920, 2003, 2005, 1990, 1990, 1993, 2008, 1920, 1996, 1993, 2003, 2004, 502, 481, 498, 505, 463, 471, 456, 452, 478, 472, 479, 467, 478, 452, 478, 472, 479, 456, 474, 452, 460, 466, 463, 467, 452, 474, 478, 456, 452, 425, 430, 429, 452, 472, 473, 472, 452, 456, 467, 474, 424, 419, 431, 2278, 2276, 2276, 2274, 2295, 2291, 2370, 2422, 2410, 2411, 2341, 2406, 2410, 2416, 2409, 2401, 2411, 2338, 2417, 2341, 2408, 2410, 2401, 2412, 2403, 2428, 2341, 2403, 2412, 2400, 2409, 2401, 2422, 2341, 2403, 2410, 2423, 2341, 3051, 3040, 3069, 3046, 3043, 3053, 3052, 3172, 3111, 3115, 3114, 3120, 3105, 3114, 3120, 3193, 2510, 2547, 2555, 2542, 2536, 2559, 2542, 2543, 2475, 2532, 2533, 2542, 2475, 2497, 2520, 2500, 2501, 2475, 2542, 2535, 2542, 2534, 2542, 2533, 2559, 2475, 2537, 2558, 2559, 2475, 2556, 2538, 2552, 2475, 1924, 1948, 1923, 1935, 1922, 1923, 1937, 1935, 1927, 1945, 1924, 1944, 1935, 1937, 1941, 1923, 1935, 2017, 2018, 2024, 1935, 1943, 1939, 1949, 1935, 1923, 1944, 1937, 2018, 2021, 2022, 2851, 2869, 2852, 2833, 2876, 2848, 2878, 2816, 2850, 2879, 2852, 2879, 2867, 2879, 2876, 2851, 3203, 3203, 3260, 916, 923, 914, 918, 901, 899, 914, 911, 899, 1015, 948, 952, 954, 954, 930, 953, 958, 948, 950, 931, 958, 952, 953, 1015, 953, 952, 931, 1015, 946, 953, 950, 949, 955, 946, 947, 1015, 945, 952, 933, 1015, 948, 955, 958, 946, 953, 931, 2932, 2816, 2875, 2932, 2855, 2865, 2865, 2932, 2851, 2876, 2865, 2854, 2865, 2932, 2848, 2876, 2877, 2855, 2932, 2851, 2869, 2855, 2932, 2869, 2872, 2872, 2875, 2871, 2869, 2848, 2865, 2864, 2936, 2932, 2855, 2865, 2848, 2932, 2848, 2876, 2865, 2932, 2843, 2879, 2844, 2848, 2848, 2852, 2839, 2872, 2877, 2865, 2874, 2848, 2932, 2872, 2875, 2867, 2867, 2865, 2854, 2932, 2872, 2865, 2850, 2865, 2872, 2932, 2848, 2875, 2932, 2834, 2845, 2842, 2833, 2926, 2932, 2840, 2875, 2867, 2867, 2865, 2854, 2938, 2867, 2865, 2848, 2840, 2875, 2867, 2867, 2865, 2854, 2940, 2843, 2879, 2844, 2848, 2848, 2852, 2839, 2872, 2877, 2865, 2874, 2848, 2938, 2871, 2872, 2869, 2855, 2855, 2938, 2867, 2865, 2848, 2842, 2869, 2873, 2865, 2940, 2941, 2941, 2938, 2855, 2865, 2848, 2840, 2865, 2850, 2865, 2872, 2940, 2840, 2865, 2850, 2865, 2872, 2938, 2834, 2845, 2842, 2833, 2941, 2927, 3040, 3048, 3065, 3045, 3042, 3049, 2989, 2915, 2849, 2870, 2871, 2915, 2868, 2850, 2864, 2915, 1667, 1743, 1730, 1737, 1748, 1677, 1676, 1680, 1677, 1731, 1752, 1729, 1729, 1318, 1337, 1315, 1337, 1330, 1340, 1333, 3173, 3199, 3173, 3190, 3177, 2402, 2414, 2423, 2338, 2428, 2427, 2414, 2403, 2410, 607, 583, 600, 596, 590, 584, 591, 579, 590, 596, 601, 600, 586, 596, 604, 578, 607, 579, 596, 586, 590, 600, 596, 569, 574, 573, 596, 584, 585, 584, 596, 600, 579, 586, 568, 563, 575, 3285, 3304, 3296, 3317, 3315, 3300, 3317, 3316, 3248, 3326, 3313, 3325, 3317, 521, 558, 566, 545, 556, 553, 548, 608, 521, 528, 566, 630, 608, 545, 548, 548, 562, 549, 563, 563, 634, 608, 615, 1423, 1416, 1422, 1433, 1437, 1425, 1500, 1434, 1429, 1426, 1429, 1423, 1428, 1433, 1432, 688, 670, 663, 662, 651, 656, 663, 670, 729, 662, 652, 653, 729, 662, 671, 729, 669, 664, 653, 668, 729, 651, 668, 648, 652, 668, 650, 653, 729, 653, 662, 729, 652, 649, 669, 664, 653, 668, 729, 655, 656, 668, 654, 729, 671, 662, 651, 729, 3115, 3127, 3127, 3123, 3120, 3193, 939, 972, 995, 998, 1002, 993, 1019, 991, 1021, 992, 1017, 998, 1003, 1002, 1021, 677, 680, 677, 694, 681, 2491, 2476, 2495, 2495, 2492, 2475, 2545, 1495, 1471, 1443, 1443, 1447, 1496, 1478, 1497, 1478, 2749, 2696, 2696, 2713, 2705, 2700, 2696, 2713, 2712, 2780, 2696, 2707, 2780, 2703, 2713, 2702, 2709, 2717, 2704, 2709, 2694, 2713, 2780, 2710, 2717, 2698, 2717, 2770, 2704, 2717, 2706, 2715, 2770, 2751, 2704, 2717, 2703, 2703, 2758, 2780, 3304, 3304, 3304, 3307, 1926, 1979, 1953, 1952, 1969, 1967, 2133, 2132, 2075, 2159, 2167, 2152, 2075, 2142, 2115, 2127, 2142, 2133, 2120, 2130, 2132, 2133, 2120, 2075, 2141, 2132, 2121, 2075, 2136, 2135, 2142, 2138, 2121, 2127, 2142, 2115, 2127, 2075, 2136, 2132, 2133, 2133, 2142, 2136, 2127, 2130, 2132, 2133, 2120, 3022, 3020, 3058, 3049, 3054, 3055, 3262, 3325, 3319, 3310, 3318, 3323, 3308, 3277, 3307, 3319, 3306, 3323, 3235, 2259, 2271, 2270, 2270, 2261, 2259, 2244, 2265, 2271, 2270, 729, 709, 713, 705, 719, 734, 650, 663, 663, 650, 708, 735, 710, 710, 801, 823, 817, 807, 800, 823, 1628, 1659, 1635, 1652, 1657, 1660, 1649, 1589, 1616, 1659, 1632, 1656, 1606, 1648, 1633, 1589, 1633, 1644, 1637, 1648, 1583, 1589, 1987, 2015, 2003, 2011, 2005, 1988, 2038, 2001, 2003, 1988, 2015, 1986, 1993, 1936, 1933, 1933, 1936, 2014, 1989, 2012, 2012, 1496, 1498, 1496, 1491, 1502, 1513, 1502, 1480, 1483, 1492, 1493, 1480, 1502, 544, 568, 551, 555, 560, 572, 555, 533, 538, 539, 538, 555, 547, 573, 544, 572, 555, 565, 561, 551, 555, 581, 582, 588, 555, 567, 566, 567, 555, 551, 572, 565, 582, 577, 578, 1717, 1694, 
    1684, 1744, 1695, 1686, 1744, 1689, 1694, 1664, 1669, 1668, 1419, 1431, 1427, 1408, 2050, 2061, 2049, 2057, 2124, 2053, 2079, 2124, 2057, 2049, 2076, 2072, 2069, 658, 656, 653, 666, 667, 675, 663, 662, 650, 647, 652, 662, 651, 641, 643, 662, 653, 656, 706, 735, 735, 706, 652, 663, 654, 654};

    public static boolean f1456 = true;

    public static short[] m12309() {
        if (C0459zf.m11062() > 0) {
            return f1455short;
        }
        return null;
    }

    public static int m12310() {
        if (C0458ze.m10932() > 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static long m12311(Object obj, byte b, long j, long j2) {
        if (C0445ya.m8330() > 0) {
            return abd.m2098((C0409oo) obj, b, j, j2);
        }
        return 0L;
    }

    public static String m12312() {
        if (C0459zf.m11053() >= 0) {
            return C0459zf.m11207(m12309(), 0, 22, 1215);
        }
        return null;
    }

    public static C0291kf m12313(Object obj, Object obj2) {
        if (C0445ya.m8330() > 0) {
            return abf.m2557((C0291kf) obj, (String) obj2);
        }
        return null;
    }

    public static String m12314() {
        if (gggy.m4365() >= 0) {
            return C0460zg.m11422(m12309(), 22, 35, 2908);
        }
        return null;
    }

    public static Date m12315(Object obj, Object obj2) {
        if (abe.m2321() < 0) {
            return C0445ya.m8290((String) obj, (ParsePosition) obj2);
        }
        return null;
    }

    public static String m12316() {
        if (gggy.m4365() > 0) {
            return adds.m2884(m12309(), 57, 14, 2986);
        }
        return null;
    }

    public static int[] m12317(Object obj, int i) {
        if (C0445ya.m8330() > 0) {
            return C0449ye.m9319((int[]) obj, i);
        }
        return null;
    }

    public static String m12318() {
        if (C0448yd.m9074() <= 0) {
            return gggy.m4340(m12309(), 71, 46, 2498);
        }
        return null;
    }

    public static ThreadFactory m12319(Object obj, boolean z) {
        if (abd.m2166() < 0) {
            return abe.m2388((String) obj, z);
        }
        return null;
    }

    public static String m12320() {
        if (C0448yd.m9015() < 0) {
            return C0445ya.m8198(m12309(), 117, 6, 1038);
        }
        return null;
    }

    public static String m12321() {
        if (C0456zb.m10484() < 0) {
            return gggy.m4340(m12309(), 123, 9, 2194);
        }
        return null;
    }

    public static int m12322(Object obj, Object obj2, int i, int i2) {
        if (C0457zc.m10555() > 0) {
            return C0448yd.m9038((Inflater) obj, (byte[]) obj2, i, i2);
        }
        return 0;
    }

    public static String m12323() {
        if (abf.m2500() >= 0) {
            return abd.m2070(m12309(), 132, 33, 1952);
        }
        return null;
    }

    public static String m12324(Object obj) {
        if (C0457zc.m10555() > 0) {
            return gggy.m4279((StringBuffer) obj);
        }
        return null;
    }

    public static String m12325() {
        if (C0453yj.m9996() <= 0) {
            return C0445ya.m8198(m12309(), 165, 4, 384);
        }
        return null;
    }

    public static boolean m12326(Object obj, Object obj2, Object obj3) {
        if (C0453yj.m9966() >= 0) {
            return C0450yf.m9369((C0402oh) obj, (String) obj2, (X509Certificate) obj3);
        }
        return false;
    }

    public static String m12327() {
        if (C0448yd.m9074() < 0) {
            return C0448yd.m9031(m12309(), 169, 39, 411);
        }
        return null;
    }

    public static String m12328() {
        if (abe.m2321() <= 0) {
            return C0455za.m10121(m12309(), 208, 6, 2183);
        }
        return null;
    }

    public static Comparator m12329() {
        if (abd.m2166() <= 0) {
            return abf.m2459();
        }
        return null;
    }

    public static String m12330() {
        if (C0459zf.m11053() >= 0) {
            return C0455za.m10121(m12309(), 214, 32, 2309);
        }
        return null;
    }

    public static String m12331() {
        if (C0460zg.m11293() > 0) {
            return C0456zb.m10478(m12309(), 246, 7, 2952);
        }
        return null;
    }

    public static Object m12332(Object obj, Object obj2, Object obj3) {
        if (C0453yj.m9966() >= 0) {
            return C0452yh.m9736((Map) obj, obj2, obj3);
        }
        return null;
    }

    public static void m12333(Object obj, Object obj2, Object obj3) {
        if (C0447yc.m8786() >= 0) {
            C0449ye.m9111((AbstractC0296kk) obj, (C0253iv) obj2, (C0314lb) obj3);
        }
    }

    public static boolean m12334(Object obj, Object obj2) {
        if (C0448yd.m9074() <= 0) {
            return C0446yb.m8461((Logger) obj, (Level) obj2);
        }
        return false;
    }

    public static String m12335() {
        if (C0459zf.m11053() >= 0) {
            return adds.m2884(m12309(), 253, 9, 3140);
        }
        return null;
    }

    public static String m12336() {
        if (C0460zg.m11293() >= 0) {
            return C0450yf.m9476(m12309(), 262, 34, 2443);
        }
        return null;
    }

    public static String m12337() {
        if (C0453yj.m9966() >= 0) {
            return abd.m2070(m12309(), 296, 31, 2000);
        }
        return null;
    }

    public static Object[] m12338(Object obj, Object obj2) {
        if (m12310() >= 0) {
            return C0461zs.m11626((Collection) obj, (Object[]) obj2);
        }
        return null;
    }

    public static String m12339() {
        if (C0460zg.m11293() >= 0) {
            return adds.m2884(m12309(), 327, 16, 2896);
        }
        return null;
    }

    public static int m12340(Object obj) {
        if (C0457zc.m10555() >= 0) {
            return C0453yj.m9990((String) obj);
        }
        return 0;
    }

    public static int m12341() {
        return (-1747710) ^ C0455za.m10081(C0453yj.m9924(m12309(), 343, 3, 2659));
    }

    public static SharedPreferences m12342(Object obj, Object obj2, int i) {
        if (C0458ze.m10926() <= 0) {
            return C0458ze.m10860((Activity) obj, (String) obj2, i);
        }
        return null;
    }

    public static long m12343() {
        if (C0447yc.m8786() >= 0) {
            return C0448yd.m8908();
        }
        return 0L;
    }

    public static TimeZone m12344() {
        if (C0447yc.m8786() > 0) {
            return C0458ze.m10781();
        }
        return null;
    }

    public static void m12345(Object obj, int i) throws SocketException {
        if (abf.m2500() >= 0) {
            C0448yd.m9075((Socket) obj, i);
        }
    }

    public static Time m12346(Object obj, Object obj2) {
        if (C0458ze.m10926() < 0) {
            return gggy.m4294((C0100dd) obj, (C0152fb) obj2);
        }
        return null;
    }

    public static Object[] m12347(Object obj, Object obj2) {
        if (C0460zg.m11293() >= 0) {
            return C0449ye.m9267((List) obj, (Object[]) obj2);
        }
        return null;
    }

    public static String m12348(Object obj) {
        if (abe.m2321() < 0) {
            return C0459zf.m11204((C0273jo) obj);
        }
        return null;
    }

    public static String m12349() {
        if (m12310() >= 0) {
            return adds.m2884(m12309(), 346, 46, 983);
        }
        return null;
    }

    public static C0250is m12350() {
        if (abd.m2021() > 0) {
            return C0447yc.m8674();
        }
        return null;
    }

    public static void m12351(Object obj, boolean z) {
        if (C0460zg.m11293() >= 0) {
            C0453yj.m9909((HttpURLConnection) obj, z);
        }
    }

    public static String m12352() {
        if (abd.m2166() < 0) {
            return C0450yf.m9476(m12309(), 392, 145, 2900);
        }
        return null;
    }

    public static String m12353() {
        if (m12310() >= 0) {
            return C0451yg.m9579(m12309(), 537, 7, 2957);
        }
        return null;
    }

    public static String m12354() {
        if (C0457zc.m10718() < 0) {
            return C0452yh.m9820(m12309(), 544, 9, 2883);
        }
        return null;
    }

    public static String m12355() {
        if (C0453yj.m9945() <= 0) {
            return C0461zs.m11581(m12309(), 553, 13, 1709);
        }
        return null;
    }

    public static String m12356() {
        if (C0453yj.m9945() <= 0) {
            return C0447yc.m8718(m12309(), 566, 7, 1392);
        }
        return null;
    }

    public static void m12357(Object obj, boolean z) {
        if (abf.m2500() > 0) {
            C0453yj.m9899((AccessibleObject) obj, z);
        }
    }

    public static String m12358() {
        if (C0453yj.m9996() < 0) {
            return C0446yb.m8463(m12309(), 573, 5, 3116);
        }
        return null;
    }

    public static boolean m12359(Object obj, Object obj2) {
        if (C0448yd.m9015() <= 0) {
            return C0456zb.m10275((String) obj, (CharSequence) obj2);
        }
        return false;
    }

    public static Class m12360(Object obj) {
        if (abd.m2021() > 0) {
            return C0449ye.m9300((Class) obj);
        }
        return null;
    }

    public static String m12361() {
        if (C0453yj.m10032() >= 0) {
            return C0451yg.m9579(m12309(), 578, 9, 2319);
        }
        return null;
    }

    public static boolean m12362(Object obj, boolean z) {
        if (C0445ya.m8330() > 0) {
            return C0448yd.m8998((C0314lb) obj, z);
        }
        return false;
    }

    public static String m12363() {
        if (m12310() > 0) {
            return C0448yd.m9031(m12309(), 587, 37, 523);
        }
        return null;
    }

    public static AbstractC0022ah m12364() {
        if (C0453yj.m9996() < 0) {
            return C0448yd.m8975();
        }
        return null;
    }

    public static String m12365() {
        if (C0459zf.m11053() > 0) {
            return gggy.m4340(m12309(), 624, 13, 3216);
        }
        return null;
    }

    public static long m12366(Object obj) {
        if (C0456zb.m10484() < 0) {
            return C0453yj.m10000((C0430pi) obj);
        }
        return 0L;
    }

    public static long m12367(long j, long j2) {
        if (C0460zg.m11293() > 0) {
            return C0447yc.m8785(j, j2);
        }
        return 0L;
    }

    public static long m12368(Object obj) {
        if (C0457zc.m10718() <= 0) {
            return abf.m2558((C0409oo) obj);
        }
        return 0L;
    }

    public static boolean m12369(Object obj, Object obj2) {
        if (C0453yj.m10032() >= 0) {
            return abd.m2178((Class) obj, (Class) obj2);
        }
        return false;
    }

    public static String m12370() {
        if (C0453yj.m9966() > 0) {
            return C0451yg.m9579(m12309(), 637, 23, 576);
        }
        return null;
    }

    public static boolean m12371(Object obj) {
        if (C0453yj.m9966() >= 0) {
            return C0445ya.m8383((C0152fb) obj);
        }
        return false;
    }

    public static int m12372(Object obj) {
        if (C0457zc.m10718() <= 0) {
            return abd.m2020((Matcher) obj);
        }
        return 0;
    }

    public static String m12373() {
        if (C0448yd.m9015() <= 0) {
            return C0448yd.m9031(m12309(), 660, 15, 1532);
        }
        return null;
    }

    public static long m12374(Object obj) {
        if (C0460zg.m11293() > 0) {
            return C0445ya.m8325((C0314lb) obj);
        }
        return 0L;
    }

    public static String m12375() {
        if (C0460zg.m11293() >= 0) {
            return C0452yh.m9820(m12309(), 675, 48, 761);
        }
        return null;
    }

    public static AbstractC0288kc m12376(Object obj, Object obj2, int i, int i2) {
        if (m12310() > 0) {
            return abc.m1854((C0278jt) obj, (byte[]) obj2, i, i2);
        }
        return null;
    }

    public static C0290ke m12377(Object obj, Object obj2) {
        if (C0458ze.m10926() <= 0) {
            return C0450yf.m9464((InterfaceC0277js) obj, (C0286ka) obj2);
        }
        return null;
    }

    public static String m12378() {
        if (m12310() > 0) {
            return C0456zb.m10478(m12309(), 723, 6, 3139);
        }
        return null;
    }

    public static C0211hg m12379() {
        if (C0459zf.m11053() >= 0) {
            return C0448yd.m9087();
        }
        return null;
    }

    public static String m12380() {
        if (C0445ya.m8330() >= 0) {
            return C0452yh.m9820(m12309(), 729, 15, 911);
        }
        return null;
    }

    public static String m12381() {
        if (abd.m2021() > 0) {
            return abe.m2412(m12309(), 744, 5, 708);
        }
        return null;
    }

    public static String m12382(short[] sArr, int i, int i2, int i3) {
        char[] cArr = new char[i2];
        for (int i4 = 0; i4 < i2; i4++) {
            cArr[i4] = (char) (sArr[i + i4] ^ i3);
        }
        return new String(cArr);
    }

    public static String m12383() {
        if (abf.m2500() >= 0) {
            return abc.m1781(m12309(), 749, 7, 2521);
        }
        return null;
    }

    public static String m12384() {
        if (C0458ze.m10926() <= 0) {
            return C0460zg.m11422(m12309(), 756, 9, 1527);
        }
        return null;
    }

    public static void m12385(Object obj) {
        if (C0447yc.m8786() >= 0) {
            C0460zg.m11365((Throwable) obj);
        }
    }

    public static String m12386() {
        if (C0458ze.m10926() < 0) {
            return C0457zc.m10560(m12309(), 765, 40, 2812);
        }
        return null;
    }

    public static List m12387(Object obj) {
        if (m12310() > 0) {
            return abd.m2061((C0279ju) obj);
        }
        return null;
    }

    public static String m12388(Object obj) {
        if (C0457zc.m10555() > 0) {
            return C0461zs.m11503((StringTokenizer) obj);
        }
        return null;
    }

    public static int m12389(Object obj) {
        if (C0453yj.m9945() < 0) {
            return C0457zc.m10626((C0314lb) obj);
        }
        return 0;
    }

    public static void m12390(Object obj) {
        if (C0448yd.m9074() < 0) {
            C0460zg.m11405((C0084co) obj);
        }
    }

    public static String m12391(String str) {
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

    public static C0412or m12392(Object obj, long j) {
        if (C0448yd.m9015() <= 0) {
            return abd.m2176((C0409oo) obj, j);
        }
        return null;
    }

    public static C0274jp m12393(Object obj, Object obj2) {
        if (abd.m2021() > 0) {
            return C0458ze.m10922((C0273jo) obj, (String) obj2);
        }
        return null;
    }

    public static C0412or m12394(Object obj, long j) {
        if (C0453yj.m9996() <= 0) {
            return C0455za.m10078((InterfaceC0411oq) obj, j);
        }
        return null;
    }

    public static C0412or m12395(Object obj) {
        if (C0456zb.m10484() <= 0) {
            return C0459zf.m11075((C0412or) obj);
        }
        return null;
    }

    public static String m12396() {
        if (abd.m2021() >= 0) {
            return C0451yg.m9579(m12309(), 805, 4, 3214);
        }
        return null;
    }

    public static String m12397() {
        if (m12310() > 0) {
            return C0457zc.m10560(m12309(), 809, 6, 2004);
        }
        return null;
    }

    public static EnumSet m12398(Object obj) {
        if (C0453yj.m9996() < 0) {
            return abe.m2383((Class) obj);
        }
        return null;
    }

    public static Object m12399(Object obj, Object obj2, Object obj3, Object obj4) {
        if (C0453yj.m10032() > 0) {
            return C0452yh.m9624((InterfaceC0440u) obj, (AbstractC0441v) obj2, (Type) obj3, (InterfaceC0438t) obj4);
        }
        return null;
    }

    public static InterfaceC0410op m12400(Object obj, long j) {
        if (C0453yj.m9966() > 0) {
            return C0461zs.m11565((InterfaceC0410op) obj, j);
        }
        return null;
    }

    public static C0291kf m12401(Object obj, Object obj2) {
        if (abd.m2166() < 0) {
            return C0449ye.m9102((C0291kf) obj, (AbstractC0292kg) obj2);
        }
        return null;
    }

    public static String m12402() {
        if (C0448yd.m9074() <= 0) {
            return abe.m2412(m12309(), 815, 43, 2107);
        }
        return null;
    }

    public static boolean m12403(Object obj) {
        if (abe.m2321() < 0) {
            return C0445ya.m8207((C0319lg) obj);
        }
        return false;
    }

    public static void m12404(Object obj) {
        if (C0458ze.m10926() < 0) {
            adds.m2764((List) obj);
        }
    }

    public static String m12405() {
        if (m12310() > 0) {
            return abf.m2527(m12309(), 858, 6, 2962);
        }
        return null;
    }

    public static String m12406() {
        if (C0456zb.m10484() < 0) {
            return C0452yh.m9820(m12309(), 864, 13, 3230);
        }
        return null;
    }

    public static SharedPreferences.Editor m12407(Object obj, Object obj2) {
        if (C0447yc.m8786() >= 0) {
            return abd.m1990((SharedPreferences.Editor) obj, (String) obj2);
        }
        return null;
    }

    public static long m12408(Object obj, Object obj2) {
        if (C0459zf.m11053() >= 0) {
            return abc.m1827((InterfaceC0385nr) obj, (File) obj2);
        }
        return 0L;
    }

    public static Object m12409(Object obj) {
        if (C0453yj.m9945() < 0) {
            return C0455za.m10193((InterfaceC0065bw) obj);
        }
        return null;
    }

    public static String m12410() {
        if (C0448yd.m9015() <= 0) {
            return C0453yj.m9924(m12309(), 877, 10, 2224);
        }
        return null;
    }

    public static String m12411(Object obj, Object obj2) {
        if (abd.m2021() > 0) {
            return C0453yj.m9952((C0290ke) obj, (String) obj2);
        }
        return null;
    }

    public static String m12412() {
        if (C0453yj.m9945() < 0) {
            return abe.m2412(m12309(), 887, 14, 682);
        }
        return null;
    }

    public static C0250is m12413(Object obj) {
        if (abf.m2500() >= 0) {
            return abd.m2035((C0270jl) obj);
        }
        return null;
    }

    public static InterfaceC0410op m12414(Object obj, Object obj2) {
        if (C0453yj.m9996() < 0) {
            return C0449ye.m9250((InterfaceC0410op) obj, (byte[]) obj2);
        }
        return null;
    }

    public static Object m12415(Object obj, Object obj2, Object obj3) {
        if (C0458ze.m10926() <= 0) {
            return C0455za.m10088((C0057bo) obj, obj2, obj3);
        }
        return null;
    }

    public static String m12416() {
        if (abd.m2166() < 0) {
            return C0461zs.m11581(m12309(), 901, 6, 850);
        }
        return null;
    }

    public static String m12417() {
        if (C0445ya.m8330() >= 0) {
            return C0450yf.m9476(m12309(), 907, 22, 1557);
        }
        return null;
    }

    public static String m12418() {
        if (C0458ze.m10926() <= 0) {
            return C0457zc.m10560(m12309(), 929, 21, 1968);
        }
        return null;
    }

    public static String m12419() {
        if (C0458ze.m10926() <= 0) {
            return C0451yg.m9579(m12309(), 950, 13, 1467);
        }
        return null;
    }

    public static String m12420() {
        if (C0456zb.m10484() < 0) {
            return C0448yd.m9031(m12309(), 963, 35, 628);
        }
        return null;
    }

    public static Matcher m12421(Object obj, int i, int i2) {
        if (C0448yd.m9074() <= 0) {
            return C0459zf.m11026((Matcher) obj, i, i2);
        }
        return null;
    }

    public static String m12422() {
        if (C0448yd.m9015() <= 0) {
            return C0461zs.m11581(m12309(), 998, 12, 1776);
        }
        return null;
    }

    public static String m12423() {
        if (abd.m2021() >= 0) {
            return adds.m2884(m12309(), 1010, 4, 1522);
        }
        return null;
    }

    public static AssertionError m12424(Object obj, Object obj2) {
        if (m12310() >= 0) {
            return C0450yf.m9385((String) obj, (Exception) obj2);
        }
        return null;
    }

    public static String m12425() {
        if (C0458ze.m10926() < 0) {
            return C0446yb.m8463(m12309(), 1014, 13, 2156);
        }
        return null;
    }

    public static InterfaceC0429ph m12426(Object obj) {
        if (abf.m2500() >= 0) {
            return C0447yc.m8685((C0335lw) obj);
        }
        return null;
    }

    public static String m12427() {
        if (C0448yd.m9074() < 0) {
            return C0452yh.m9820(m12309(), 1027, 26, 738);
        }
        return null;
    }

    public static boolean m12428(Object obj) {
        if (abd.m2021() > 0) {
            return C0456zb.m10415((C0255ix) obj);
        }
        return false;
    }
}
