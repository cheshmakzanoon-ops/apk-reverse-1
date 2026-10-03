package com.google.android.material.card2;

import android.animation.ObjectAnimator;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.SharedPreferences;
import android.view.View;
import android.widget.ImageView;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.ObjectInputStream;
import java.lang.reflect.Field;
import java.lang.reflect.Type;
import java.net.InetAddress;
import java.net.ProxySelector;
import java.net.Socket;
import java.security.cert.X509Certificate;
import java.util.BitSet;
import java.util.Collection;
import java.util.Comparator;
import java.util.Hashtable;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.Timer;
import java.util.TimerTask;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.regex.Pattern;
import java.util.zip.Inflater;
import javax.crypto.Cipher;
import javax.net.ssl.SSLPeerUnverifiedException;
import javax.security.auth.x500.X500Principal;

public class C0613 {

    private static final short[] f1477short = {320, 256, 267, 282, 281, 257, 284, 261, 316, 267, 285, 286, 257, 256, 285, 267, 334, 335, 339, 334, 256, 283, 258, 258, 3025, 3063, 3053, 3050, 3043, 2980, 3047, 3045, 3047, 3052, 3041, 3040, 3006, 2980, 1154, 1206, 1207, 1195, 1196, 1201, 1194, 1209, 1186, 1207, 1194, 1196, 1197, 1581, 1583, 1568, 1581, 1579, 1570, 1579, 1578, 1646, 2542, 2505, 2497, 2500, 2509, 2508, 2440, 2524, 2503, 2440, 2520, 2505, 2522, 2523, 2509, 2440, 2508, 2505, 2524, 2509, 2440, 2547, 1060, 1080, 1058, 1061, 1076, 1074, 1143, 1074, 1071, 1087, 1078, 1058, 1060, 1059, 1074, 1075, 1143, 1063, 1061, 1074, 1082, 1078, 1059, 1058, 1061, 1074, 1083, 1070, 2160, 2082, 2101, 2084, 2085, 2082, 2110, 2101, 2100, 2160, 2097, 2160, 2082, 2101, 2083, 2080, 2111, 2110, 2083, 2101, 2160, 2087, 2105, 2084, 2104, 2160, 2110, 2111, 2160, 2098, 2111, 2100, 2089, 1407, 1395, 1312, 1318, 1315, 1315, 1340, 1313, 1319, 1312, 1287, 1343, 1312, 1302, 1323, 1319, 1334, 1341, 1312, 1338, 1340, 1341, 1312, 1390, 3289, 3288, 3294, 1292, 1335, 1325, 1340, 1323, 1332, 1328, 1335, 1336, 1325, 1340, 1341, 1401, 1334, 1339, 1331, 1340, 1338, 1325, 2196, 2216, 2216, 2220, 2286, 2207, 2227, 2226, 2226, 2233, 2239, 2216, 2229, 2227, 2226, 2290, 2192, 2229, 2223, 2216, 2233, 2226, 2233, 2222, 2300, 2234, 2237, 2229, 2224, 2217, 2222, 2233, 2300, 2234, 2227, 2222, 2300, 3096, 3092, 3085, 3160, 3092, 3090, 3088, 675, 664, 641, 641, 717, 644, 643, 665, 648, 671, 654, 648, 669, 665, 642, 671, 727, 717, 682, 690, 685, 673, 693, 684, 700, 715, 673, 699, 678, 686, 689, 684, 682, 673, 681, 695, 682, 694, 673, 684, 701, 714, 673, 714, 718, 673, 691, 698, 715, 1787, 1783, 1774, 1733, 1762, 1783, 1786, 1779, 1718, 1706, 1718, 1702, 1708, 1718, 315, 300, 289, 312, 296, 365, 299, 290, 319, 365, 291, 300, 288, 296, 365, 2082, 2068, 2076, 2049, 2076, 2075, 2066, 2133, 2067, 2074, 2055, 2133, 2735, 2745, 2736, 2745, 2751, 2728, 2745, 2744, 364, 375, 295, 310, 291, 319, 362, 412, 401, 396, 468, 457, 457, 468, 410, 385, 408, 408, 1303, 1301, 1300, 1291, 1289, 1387, 1385, 1367, 1356, 1355, 1354, 2684, 2673, 2680, 2669, 2679, 2683, 2669, 2684, 2684, 2657, 2662, 2671, 2683, 2568, 2628, 2637, 2630, 2639, 2652, 2624, 2568, 2573, 2573, 2568, 2590, 2568, 2569, 2581, 2568, 2584, 2578, 2568, 2573, 2651, 693, 695, 695, 689, 676, 672, 761, 695, 700, 693, 678, 679, 689, 672, 2894, 2896, 2894, 3119, 3080, 3077, 3081, 3083, 3094, 3082, 3075, 3090, 3075, 3142, 3074, 3081, 3077, 3091, 3083, 3075, 3080, 3090, 2613, 2605, 2610, 2622, 2597, 2601, 2622, 2560, 2575, 2574, 2575, 2622, 2614, 2600, 2613, 2601, 2622, 2592, 2596, 2610, 2622, 2640, 2643, 2649, 2622, 2598, 2594, 2604, 2622, 2610, 2601, 2592, 2643, 2644, 2647, 1633, 1633, 1632, 1648, 1560, 1572, 1572, 1568, 1541, 1538, 1564, 1555, 1599, 1598, 1598, 1589, 1587, 1572, 1593, 1599, 1598, 1648, 1650, 1538, 1589, 1571, 1568, 1599, 1598, 1571, 1589, 1648, 1593, 1571, 1648, 1571, 1572, 1585, 1596, 1589, 1650, 2868, 2872, 2924, 2932, 2923, 2894, 2941, 2922, 2923, 2929, 2935, 2934, 2923, 2853, 2163, 2155, 2164, 2168, 2167, 2164, 2156, 2168, 2160, 2158, 2163, 2159, 2168, 2165, 2148, 2067, 2168, 2070, 2069, 2079, 2168, 2164, 2159, 2150, 3294, 3212, 3291, 3291, 3222, 3287, 3016, 1402, 1378, 1405, 1393, 1406, 1405, 1381, 1393, 1401, 1383, 1402, 1382, 1393, 1391, 1387, 1405, 1393, 1311, 1308, 1302, 1393, 1389, 1388, 1389, 1393, 1405, 1382, 1391, 2375, 2385, 2368, 2329, 2391, 2395, 2395, 2399, 2397, 2385, 417, 445, 445, 441, 442, 1864, 1872, 1871, 1859, 1880, 1876, 1881, 1859, 1870, 1871, 1885, 1859, 1867, 1877, 1864, 1876, 1859, 1887, 1885, 1873, 1881, 1872, 1872, 1877, 1885, 1859, 1837, 1838, 1828, 1859, 1887, 1886, 1887, 1859, 1871, 1876, 1885, 2364, 2367, 2365, 2357, 2361, 2348, 2353, 2347, 2352, 2362, 596, 514, 593, 577, 521, 596, 577, 585, 521, 593, 596, 580, 533, 593, 596, 604, 576, 578, 514, 593, 596, 514, 1613, 1608, 1609, 1461, 1465, 1530, 1526, 1533, 1532, 1444, 1107, 1128, 1128, 1063, 1130, 1126, 1129, 1150, 1063, 1121, 1128, 1131, 1131, 1128, 1136, 1066, 1138, 1143, 1063, 1141, 1122, 1142, 1138, 1122, 1140, 1139, 1140, 1085, 1063, 941, 938, 940, 951, 957, 938, 1011, 938, 940, 959, 944, 941, 942, 945, 940, 938, 1011, 941, 955, 957, 939, 940, 951, 938, 935, 1059, 1033, 1033, 1033, 1033, 1114, 1116, 1099, 1091, 1100, 1098, 1117, 1128, 1093, 1117, 1127, 1096, 1092, 1100, 1114, 1043, 1033, 2680, 2644, 2645, 2639, 2654, 2645, 2639, 2582, 2679, 2654, 2645, 2652, 2639, 2643, 565, 594, 584, 2354, 2406, 2423, 2410, 2406, 2351, 3295, 3271, 3288, 3284, 3264, 3289, 3273, 3262, 3284, 3292, 3266, 3295, 3267, 3284, 3289, 3272, 3263, 3284, 3258, 3257, 3251, 3284, 3288, 3267, 3274, 2150, 2122, 2122, 2126, 2124, 2112, 665, 691, 691, 707, 758, 758, 737, 691, 752, 758, 737, 743, 762, 757, 762, 752, 754, 743, 758, 691, 752, 763, 754, 762, 765, 681, 529, 543, 543, 522, 599, 539, 534, 531, 524, 543, 1324, 1280, 1293, 1287, 1294, 1299, 1292, 1284, 1285, 1345, 1317, 1327, 1371, 1345, 2243, 2270, 2262, 2255, 2260, 2243, 2261, 3011, 3035, 3012, 3016, 3026, 3028, 3027, 3039, 3016, 3026, 3028, 3027, 3012, 3030, 3016, 3008, 3038, 3011, 3039, 3016, 3030, 3026, 3012, 3016, 2981, 2978, 2977, 3016, 3028, 3029, 3028, 3016, 3012, 3039, 3030, 2980, 2991, 2979, 1884, 1873, 1869, 1877, 1884};

    public static boolean f1478 = true;

    public static short[] m13588() {
        if (C0458ze.m10932() >= 0) {
            return f1477short;
        }
        return null;
    }

    public static int m13589() {
        if (gggy.m4269() <= 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static boolean m13590(Object obj) {
        if (abe.m2321() < 0) {
            return abe.m2318((Socket) obj);
        }
        return false;
    }

    public static String m13591() {
        if (C0457zc.m10718() < 0) {
            return C0448yd.m9031(m13588(), 0, 24, 366);
        }
        return null;
    }

    public static String m13592() {
        if (abd.m2166() < 0) {
            return C0446yb.m8463(m13588(), 24, 14, 2948);
        }
        return null;
    }

    public static String m13593() {
        if (C0447yc.m8786() >= 0) {
            return abd.m2070(m13588(), 38, 13, 1219);
        }
        return null;
    }

    public static float m13594(Object obj) {
        if (C0453yj.m9996() < 0) {
            return C0449ye.m9240((String) obj);
        }
        return 0.0f;
    }

    public static String m13595() {
        if (C0453yj.m9966() > 0) {
            return C0447yc.m8718(m13588(), 51, 9, 1614);
        }
        return null;
    }

    public static String m13596() {
        if (C0445ya.m8330() >= 0) {
            return C0461zs.m11581(m13588(), 60, 22, 2472);
        }
        return null;
    }

    public static boolean m13597(Object obj, Object obj2) {
        if (C0456zb.m10484() < 0) {
            return C0455za.m10141((Collection) obj, obj2);
        }
        return false;
    }

    public static String m13598() {
        if (abe.m2321() <= 0) {
            return abc.m1781(m13588(), 82, 28, 1111);
        }
        return null;
    }

    public static String m13599() {
        if (C0448yd.m9074() < 0) {
            return C0445ya.m8198(m13588(), 110, 33, 2128);
        }
        return null;
    }

    public static String m13600() {
        if (C0453yj.m9966() >= 0) {
            return abd.m2070(m13588(), 143, 24, 1363);
        }
        return null;
    }

    public static byte[] m13601(Object obj, Object obj2) {
        if (abe.m2321() < 0) {
            return abd.m2177((Cipher) obj, (byte[]) obj2);
        }
        return null;
    }

    public static C0015aa m13602(Object obj) {
        if (C0447yc.m8786() >= 0) {
            return C0452yh.m9740((AbstractC0441v) obj);
        }
        return null;
    }

    public static Pattern m13603(Object obj) {
        if (C0453yj.m9966() > 0) {
            return C0446yb.m8562((String) obj);
        }
        return null;
    }

    public static int m13604(Object obj) {
        if (C0459zf.m11053() > 0) {
            return C0461zs.m11610((C0261jc) obj);
        }
        return 0;
    }

    public static int m13605() {
        return 1753700 ^ C0455za.m10081(C0459zf.m11207(m13588(), 167, 3, 2623));
    }

    public static String m13606() {
        if (C0459zf.m11053() >= 0) {
            return C0450yf.m9476(m13588(), 170, 19, 1369);
        }
        return null;
    }

    public static String m13607(Object obj, Object obj2) {
        if (abe.m2321() < 0) {
            return C0460zg.m11305((String) obj, (Locale) obj2);
        }
        return null;
    }

    public static boolean m13608(Object obj) {
        if (C0448yd.m9074() < 0) {
            return C0450yf.m9406((C0290ke) obj);
        }
        return false;
    }

    public static void m13609(Object obj, Object obj2, Object obj3) {
        if (C0457zc.m10718() <= 0) {
            abe.m2391((C0444y) obj, (String) obj2, (AbstractC0441v) obj3);
        }
    }

    public static String m13610() {
        if (C0457zc.m10718() <= 0) {
            return adds.m2866();
        }
        return null;
    }

    public static String m13611() {
        if (abf.m2500() > 0) {
            return C0457zc.m10560(m13588(), 189, 37, 2268);
        }
        return null;
    }

    public static byte[] m13612(Object obj) {
        if (C0459zf.m11053() > 0) {
            return gggy.m4272((C0412or) obj);
        }
        return null;
    }

    public static String m13613() {
        if (C0453yj.m10032() >= 0) {
            return abf.m2527(m13588(), 226, 7, 3189);
        }
        return null;
    }

    public static Class m13614(Object obj) {
        if (C0459zf.m11053() >= 0) {
            return abc.m1798((Class) obj);
        }
        return null;
    }

    public static void m13615(Object obj, Object obj2) {
        if (gggy.m4365() > 0) {
            C0460zg.m11358((C0373nf) obj, (EnumC0346mf) obj2);
        }
    }

    public static boolean m13616(Object obj) {
        if (C0445ya.m8330() > 0) {
            return abf.m2452((C0243il) obj);
        }
        return false;
    }

    public static int m13617() {
        if (C0458ze.m10926() < 0) {
            return abe.m2249();
        }
        return 0;
    }

    public static List m13618(Object obj, Object obj2, Object obj3) {
        if (C0453yj.m9996() <= 0) {
            return C0461zs.m11646((AbstractC0400of) obj, (List) obj2, (String) obj3);
        }
        return null;
    }

    public static boolean m13619(Object obj) {
        if (C0458ze.m10926() < 0) {
            return C0447yc.m8700((C0314lb) obj);
        }
        return false;
    }

    public static String m13620() {
        if (gggy.m4365() > 0) {
            return C0458ze.m10915(m13588(), 233, 18, 749);
        }
        return null;
    }

    public static void m13621(Object obj, Object obj2, Object obj3, Object obj4) {
        if (C0453yj.m9966() > 0) {
            C0456zb.m10445((C0285k) obj, obj2, (Type) obj3, (C0155fe) obj4);
        }
    }

    public static Object[] m13622(Object obj, int i) {
        if (C0456zb.m10484() < 0) {
            return abe.m2410((Object[]) obj, i);
        }
        return null;
    }

    public static InterfaceC0429ph m13623(Object obj) {
        if (C0453yj.m9966() > 0) {
            return abd.m2160((Socket) obj);
        }
        return null;
    }

    public static String m13624() {
        if (abd.m2166() < 0) {
            return C0459zf.m11207(m13588(), 251, 31, 766);
        }
        return null;
    }

    public static String m13625() {
        if (C0460zg.m11293() > 0) {
            return C0445ya.m8198(m13588(), 282, 14, 1686);
        }
        return null;
    }

    public static String m13626() {
        if (C0448yd.m9074() <= 0) {
            return abc.m1781(m13588(), 296, 15, 333);
        }
        return null;
    }

    public static C0273jo m13627(Object obj) {
        if (C0448yd.m9015() <= 0) {
            return abd.m2011((C0274jp) obj);
        }
        return null;
    }

    public static C0409oo m13628(Object obj, int i) {
        if (C0445ya.m8330() > 0) {
            return C0448yd.m8937((C0409oo) obj, i);
        }
        return null;
    }

    public static boolean m13629(Object obj) {
        if (C0458ze.m10926() < 0) {
            return abc.m1954((C0015aa) obj);
        }
        return false;
    }

    public static String m13630(short[] sArr, int i, int i2, int i3) {
        char[] cArr = new char[i2];
        for (int i4 = 0; i4 < i2; i4++) {
            cArr[i4] = (char) (sArr[i + i4] ^ i3);
        }
        return new String(cArr);
    }

    public static String m13631() {
        if (C0460zg.m11293() >= 0) {
            return C0458ze.m10915(m13588(), 311, 12, 2165);
        }
        return null;
    }

    public static String m13632() {
        if (gggy.m4365() > 0) {
            return C0460zg.m11422(m13588(), 323, 8, 2780);
        }
        return null;
    }

    public static String m13633() {
        if (abf.m2500() >= 0) {
            return C0455za.m10121(m13588(), 331, 7, 343);
        }
        return null;
    }

    public static boolean m13634(Object obj) {
        if (abd.m2021() > 0) {
            return C0456zb.m10395((Inflater) obj);
        }
        return false;
    }

    public static C0155fe m13635(Object obj) {
        if (C0457zc.m10555() > 0) {
            return C0449ye.m9183((C0155fe) obj);
        }
        return null;
    }

    public static boolean m13636(Object obj) {
        if (C0448yd.m9074() <= 0) {
            return abe.m2405((C0317le) obj);
        }
        return false;
    }

    public static void m13637(Object obj, boolean z) {
        if (C0453yj.m9945() < 0) {
            C0460zg.m11429((ImageView) obj, z);
        }
    }

    public static void m13638(Object obj, boolean z) {
        if (C0456zb.m10484() <= 0) {
            C0459zf.m10993((Thread) obj, z);
        }
    }

    public static String m13639(Object obj, Object obj2) {
        if (m13589() >= 0) {
            return C0460zg.m11290((InterfaceC0258j) obj, (Field) obj2);
        }
        return null;
    }

    public static C0268jj m13640(Object obj) {
        if (C0448yd.m9015() <= 0) {
            return C0449ye.m9243((C0269jk) obj);
        }
        return null;
    }

    public static AbstractC0022ah m13641() {
        if (abd.m2166() < 0) {
            return abe.m2270();
        }
        return null;
    }

    public static void m13642(Object obj, Object obj2) {
        if (C0453yj.m9945() <= 0) {
            C0446yb.m8472((AbstractC0264jf) obj, (InterfaceC0245in) obj2);
        }
    }

    public static String m13643() {
        if (C0456zb.m10484() < 0) {
            return C0452yh.m9820(m13588(), 338, 11, 500);
        }
        return null;
    }

    public static void m13644(Object obj, Object obj2, Object obj3) {
        if (C0448yd.m9015() < 0) {
            gggy.m4468((AbstractC0264jf) obj, (InterfaceC0245in) obj2, (C0290ke) obj3);
        }
    }

    public static String m13645() {
        if (abd.m2166() < 0) {
            return C0452yh.m9820(m13588(), 349, 11, 1335);
        }
        return null;
    }

    public static String m13646() {
        if (abf.m2500() > 0) {
            return C0458ze.m10915(m13588(), 360, 34, 2600);
        }
        return null;
    }

    public static boolean m13647(Object obj) {
        if (abe.m2321() < 0) {
            return C0460zg.m11222((AtomicBoolean) obj);
        }
        return false;
    }

    public static Throwable m13648(Object obj, Object obj2) {
        if (gggy.m4365() > 0) {
            return C0457zc.m10698((SSLPeerUnverifiedException) obj, (Throwable) obj2);
        }
        return null;
    }

    public static String m13649() {
        if (abd.m2166() <= 0) {
            return C0458ze.m10915(m13588(), 394, 14, 724);
        }
        return null;
    }

    public static EnumC0346mf m13650() {
        if (C0448yd.m9015() <= 0) {
            return abd.m2012();
        }
        return null;
    }

    public static AbstractC0022ah m13651() {
        if (C0458ze.m10926() < 0) {
            return abf.m2426();
        }
        return null;
    }

    public static ClassLoader m13652(Object obj) {
        if (C0447yc.m8786() > 0) {
            return C0448yd.m8890((Class) obj);
        }
        return null;
    }

    public static String m13653() {
        if (C0457zc.m10555() >= 0) {
            return abd.m2070(m13588(), 408, 3, 2926);
        }
        return null;
    }

    public static String m13654() {
        if (C0445ya.m8330() >= 0) {
            return C0448yd.m9031(m13588(), 411, 19, 3174);
        }
        return null;
    }

    public static Set m13655(Object obj) {
        if (C0448yd.m9074() <= 0) {
            return C0461zs.m11538((Set) obj);
        }
        return null;
    }

    public static String m13656() {
        if (C0447yc.m8786() >= 0) {
            return C0457zc.m10560(m13588(), 430, 35, 2657);
        }
        return null;
    }

    public static String m13657() {
        if (C0445ya.m8330() > 0) {
            return C0461zs.m11581(m13588(), 465, 41, 1616);
        }
        return null;
    }

    public static String m13658() {
        if (C0460zg.m11293() >= 0) {
            return C0461zs.m11581(m13588(), 506, 14, 2840);
        }
        return null;
    }

    public static String m13659() {
        if (C0447yc.m8786() > 0) {
            return C0446yb.m8463(m13588(), 520, 24, 2087);
        }
        return null;
    }

    public static String m13660() {
        if (C0448yd.m9074() <= 0) {
            return abc.m1781(m13588(), 544, 6, 3254);
        }
        return null;
    }

    public static StringBuilder m13661(Object obj, int i) {
        if (C0453yj.m9966() > 0) {
            return abe.m2241((StringBuilder) obj, i);
        }
        return null;
    }

    public static String m13662() {
        if (C0448yd.m9074() < 0) {
            return C0448yd.m9031(m13588(), 550, 1, 2963);
        }
        return null;
    }

    public static Object m13663(Object obj, Object obj2) {
        if (C0453yj.m9966() > 0) {
            return C0453yj.m9829((Hashtable) obj, obj2);
        }
        return null;
    }

    public static ProxySelector m13664(Object obj) {
        if (C0456zb.m10484() <= 0) {
            return abe.m2228((C0239ih) obj);
        }
        return null;
    }

    public static String m13665() {
        if (abe.m2321() <= 0) {
            return C0461zs.m11581(m13588(), 551, 28, 1326);
        }
        return null;
    }

    public static String m13666(String str) {
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

    public static C0409oo m13667(Object obj, Object obj2, int i, int i2) {
        if (C0460zg.m11293() >= 0) {
            return C0455za.m10189((C0409oo) obj, (String) obj2, i, i2);
        }
        return null;
    }

    public static Appendable m13668(Object obj, char c) {
        if (C0459zf.m11053() >= 0) {
            return C0448yd.m9006((Appendable) obj, c);
        }
        return null;
    }

    public static String m13669() {
        if (abe.m2321() <= 0) {
            return abd.m2070(m13588(), 579, 10, 2356);
        }
        return null;
    }

    public static StringBuilder m13670(Object obj, int i, int i2) {
        if (C0445ya.m8330() > 0) {
            return C0445ya.m8368((StringBuilder) obj, i, i2);
        }
        return null;
    }

    public static boolean m13671(Object obj, Object obj2, Object obj3) {
        if (abf.m2500() > 0) {
            return C0446yb.m8440((Comparator) obj, (String[]) obj2, (String[]) obj3);
        }
        return false;
    }

    public static String m13672() {
        if (C0453yj.m9996() <= 0) {
            return C0447yc.m8718(m13588(), 589, 5, 457);
        }
        return null;
    }

    public static String m13673() {
        if (C0445ya.m8330() >= 0) {
            return abf.m2527(m13588(), 594, 37, 1820);
        }
        return null;
    }

    public static String m13674() {
        if (abe.m2321() < 0) {
            return C0445ya.m8198(m13588(), 631, 10, 2398);
        }
        return null;
    }

    public static C0271jm m13675(Object obj) {
        if (C0453yj.m9945() <= 0) {
            return C0457zc.m10566((C0335lw) obj);
        }
        return null;
    }

    public static String m13676() {
        if (C0453yj.m10032() > 0) {
            return C0446yb.m8463(m13588(), 641, 22, 625);
        }
        return null;
    }

    public static C0290ke m13677(Object obj, Object obj2, Object obj3, Object obj4, Object obj5) {
        if (C0456zb.m10484() < 0) {
            return C0461zs.m11450((C0329lq) obj, (C0286ka) obj2, (C0319lg) obj3, (InterfaceC0324ll) obj4, (C0314lb) obj5);
        }
        return null;
    }

    public static String m13678() {
        if (abf.m2500() > 0) {
            return C0453yj.m9924(m13588(), 663, 3, 1597);
        }
        return null;
    }

    public static InterfaceC0262jd m13679(Object obj) {
        if (C0460zg.m11293() > 0) {
            return C0457zc.m10675((C0279ju) obj);
        }
        return null;
    }

    public static int m13680(Object obj) {
        if (m13589() > 0) {
            return C0452yh.m9637((C0209he) obj);
        }
        return 0;
    }

    public static String m13681() {
        if (C0457zc.m10718() <= 0) {
            return C0457zc.m10560(m13588(), 666, 7, 1433);
        }
        return null;
    }

    public static SharedPreferences m13682(Object obj, int i) {
        if (m13589() > 0) {
            return C0457zc.m10611((Activity) obj, i);
        }
        return null;
    }

    public static String m13683() {
        if (C0447yc.m8786() >= 0) {
            return C0461zs.m11581(m13588(), 673, 29, 1031);
        }
        return null;
    }

    public static boolean m13684(Object obj) {
        if (C0447yc.m8786() > 0) {
            return C0460zg.m11234((String) obj);
        }
        return false;
    }

    public static X500Principal m13685(Object obj) {
        if (m13589() >= 0) {
            return C0445ya.m8275((X509Certificate) obj);
        }
        return null;
    }

    public static String m13686() {
        if (C0459zf.m11053() >= 0) {
            return C0461zs.m11581(m13588(), 702, 25, 990);
        }
        return null;
    }

    public static String m13687() {
        if (C0459zf.m11053() >= 0) {
            return C0446yb.m8463(m13588(), 727, 22, 1065);
        }
        return null;
    }

    public static void m13688(Object obj, int i) {
        if (C0459zf.m11053() > 0) {
            C0461zs.m11553((BitSet) obj, i);
        }
    }

    public static C0291kf m13689(Object obj, Object obj2) {
        if (C0458ze.m10926() <= 0) {
            return gggy.m4453((C0291kf) obj, (EnumC0282jx) obj2);
        }
        return null;
    }

    public static C0315lc m13690(Object obj, Object obj2) {
        if (C0453yj.m9996() < 0) {
            return C0449ye.m9320((AbstractC0296kk) obj, (C0253iv) obj2);
        }
        return null;
    }

    public static int m13691(int i, Object obj, Object obj2) {
        if (abf.m2500() > 0) {
            return C0459zf.m11100(i, (String) obj, (String) obj2);
        }
        return 0;
    }

    public static String m13692() {
        if (C0453yj.m9996() <= 0) {
            return C0446yb.m8463(m13588(), 749, 14, 2619);
        }
        return null;
    }

    public static String m13693() {
        if (m13589() >= 0) {
            return C0445ya.m8198(m13588(), 763, 3, 616);
        }
        return null;
    }

    public static File m13694(Object obj) {
        if (abd.m2166() < 0) {
            return C0460zg.m11304((Context) obj);
        }
        return null;
    }

    public static void m13695(Object obj, Object obj2, Object obj3) {
        if (C0453yj.m9945() <= 0) {
            C0450yf.m9529((InterfaceC0259ja) obj, (C0273jo) obj2, (List) obj3);
        }
    }

    public static ObjectAnimator m13696(Object obj, long j) {
        if (C0445ya.m8330() > 0) {
            return gggy.m4345((ObjectAnimator) obj, j);
        }
        return null;
    }

    public static String m13697() {
        if (abd.m2166() <= 0) {
            return C0455za.m10121(m13588(), 766, 6, 2322);
        }
        return null;
    }

    public static String m13698() {
        if (C0458ze.m10926() < 0) {
            return C0456zb.m10478(m13588(), 772, 25, 3211);
        }
        return null;
    }

    public static int m13699(Object obj) {
        if (gggy.m4365() > 0) {
            return C0461zs.m11612((ObjectInputStream) obj);
        }
        return 0;
    }

    public static C0272jn m13700(Object obj, Object obj2, Object obj3) {
        if (C0453yj.m9966() > 0) {
            return adds.m2827((C0272jn) obj, (String) obj2, (String) obj3);
        }
        return null;
    }

    public static List m13701(Object obj) {
        if (C0459zf.m11053() >= 0) {
            return abe.m2313((C0270jl) obj);
        }
        return null;
    }

    public static C0290ke m13702(Object obj, Object obj2) {
        if (C0456zb.m10484() <= 0) {
            return C0445ya.m8279((InterfaceC0276jr) obj, (InterfaceC0277js) obj2);
        }
        return null;
    }

    public static void m13703(Object obj, Object obj2) {
        if (C0448yd.m9074() <= 0) {
            abf.m2565((AlertDialog) obj, (View) obj2);
        }
    }

    public static String m13704() {
        if (C0453yj.m9945() <= 0) {
            return C0451yg.m9579(m13588(), 797, 6, 2085);
        }
        return null;
    }

    public static InterfaceC0429ph m13705(Object obj) {
        if (C0457zc.m10718() < 0) {
            return C0450yf.m9451((C0373nf) obj);
        }
        return null;
    }

    public static String m13706() {
        if (C0445ya.m8330() > 0) {
            return abe.m2412(m13588(), 803, 26, 659);
        }
        return null;
    }

    public static Socket m13707(Object obj, Object obj2) {
        if (C0453yj.m9945() < 0) {
            return C0459zf.m11008((C0319lg) obj, (C0314lb) obj2);
        }
        return null;
    }

    public static C0294ki m13708(Object obj) {
        if (C0447yc.m8786() > 0) {
            return adds.m2851((C0314lb) obj);
        }
        return null;
    }

    public static C0412or m13709(Object obj) {
        if (abf.m2500() > 0) {
            return C0446yb.m8420((C0347mg) obj);
        }
        return null;
    }

    public static String m13710() {
        if (C0459zf.m11053() >= 0) {
            return C0456zb.m10478(m13588(), 829, 10, 634);
        }
        return null;
    }

    public static long m13711(Object obj) {
        if (C0445ya.m8330() > 0) {
            return abf.m2482((AbstractC0441v) obj);
        }
        return 0L;
    }

    public static Type m13712(Object obj) {
        if (C0448yd.m9015() < 0) {
            return gggy.m4500((Class) obj);
        }
        return null;
    }

    public static boolean m13713(Object obj, Object obj2) {
        if (C0453yj.m9945() < 0) {
            return abd.m2133((InterfaceC0014a) obj, (C0041b) obj2);
        }
        return false;
    }

    public static C0247ip m13714(Object obj) {
        if (C0453yj.m10032() >= 0) {
            return C0452yh.m9758((C0239ih) obj);
        }
        return null;
    }

    public static String m13715(Object obj) {
        if (C0460zg.m11293() >= 0) {
            return abf.m2653((C0333lu) obj);
        }
        return null;
    }

    public static byte[] m13716(Object obj) {
        if (abf.m2500() > 0) {
            return C0453yj.m10009((InetAddress) obj);
        }
        return null;
    }

    public static String m13717() {
        if (abd.m2021() > 0) {
            return C0446yb.m8463(m13588(), 839, 14, 1377);
        }
        return null;
    }

    public static int m13718(Object obj) {
        if (C0457zc.m10718() <= 0) {
            return abd.m2130((AbstractC0441v) obj);
        }
        return 0;
    }

    public static String m13719() {
        if (m13589() > 0) {
            return C0452yh.m9820(m13588(), 853, 7, 2214);
        }
        return null;
    }

    public static void m13720(Object obj, Object obj2, long j, long j2) {
        if (C0456zb.m10484() < 0) {
            adds.m2841((Timer) obj, (TimerTask) obj2, j, j2);
        }
    }

    public static Collection m13721(Object obj) {
        if (C0445ya.m8330() > 0) {
            return adds.m2808((LinkedHashMap) obj);
        }
        return null;
    }

    public static String m13722() {
        if (abe.m2321() < 0) {
            return C0457zc.m10560(m13588(), 860, 38, 2967);
        }
        return null;
    }

    public static String m13723() {
        if (gggy.m4365() > 0) {
            return C0456zb.m10478(m13588(), 898, 5, 1853);
        }
        return null;
    }
}
