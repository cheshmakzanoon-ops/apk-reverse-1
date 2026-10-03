package com.google.android.material.card2;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.graphics.Typeface;
import android.net.Uri;
import android.widget.TextView;
import java.io.ByteArrayOutputStream;
import java.lang.ref.Reference;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.net.ProxySelector;
import java.net.Socket;
import java.net.URI;
import java.net.URL;
import java.net.URLConnection;
import java.net.UnknownHostException;
import java.security.Principal;
import java.security.PublicKey;
import java.security.cert.X509Certificate;
import java.text.DateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Deque;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.zip.Inflater;

public class C0611 {

    private static final short[] f1473short = {2433, 2433, 1092, 1104, 1091, 1103, 1095, 1117, 1105, 1099, 1112, 1095, 1117, 1095, 1104, 1104, 1101, 1104, 1080, 1058, 1063, 1137, 2601, 2610, 2657, 2679, 2673, 2663, 2656, 2679, 887, 844, 849, 835, 854, 843, 849, 836, 843, 835, 832, 846, 839, 770, 880, 839, 851, 855, 839, 849, 854, 770, 778, 845, 844, 846, 859, 783, 843, 836, 783, 833, 835, 833, 842, 839, 838, 779, 687, 648, 640, 645, 652, 653, 713, 669, 646, 713, 650, 646, 647, 647, 652, 650, 669, 713, 669, 646, 713, 3028, 3032, 3009, 2964, 3039, 3030, 3019, 3022, 3032, 3019, 3037, 3018, 1416, 1421, 1434, 1428, 1425, 1435, 1419, 1421, 1438, 1438, 1425, 1408, 1437, 1419, 1494, 1439, 1410, 1785, 1732, 1740, 1753, 1759, 1736, 1753, 1752, 1692, 1744, 1753, 1757, 1752, 1749, 1746, 1755, 1692, 1767, 1676, 1681, 1669, 1757, 1681, 1754, 1789, 1681, 1786, 1761, 1692, 1759, 1748, 1757, 1742, 1757, 1759, 1736, 1753, 1742, 1692, 1758, 1737, 1736, 1692, 1739, 1757, 1743, 1692, 1676, 1732, 2884, 2911, 2896, 2899, 2909, 2900, 2833, 2885, 2910, 2833, 2883, 2900, 2908, 2910, 2887, 2900, 2833, 2896, 2909, 2881, 2911, 2130, 2122, 2133, 2137, 2115, 2117, 2114, 2126, 2137, 2115, 2117, 2114, 2133, 2119, 2137, 2129, 2127, 2130, 2126, 2137, 2119, 2115, 2133, 2137, 2100, 2099, 2096, 2137, 2117, 2116, 2117, 2137, 2133, 2126, 2119, 1443, 1445, 1453, 1441, 1442, 2531, 2552, 2552, 2552, 2552, 2076, 2052, 2075, 2071, 2051, 2074, 2058, 2173, 2071, 2079, 2049, 2076, 2048, 2071, 2171, 2060, 2061, 2075, 2071, 2061, 2060, 2061, 2071, 2059, 2058, 2059, 2071, 2075, 2048, 2057, 3309, 3314, 3322, 626, 626, 626, 535, 634, 634, 634, 535, 595, 535, 639, 639, 525, 602, 602, 525, 580, 580, 535, 590, 590, 590, 590, 2471, 2464, 2494, 2546, 2543, 2543, 2546, 2492, 2471, 2494, 2494, 2202, 2232, 2231, 2231, 2230, 2221, 2297, 2232, 2229, 2229, 2230, 2234, 2232, 2221, 2236, 2297, 3145, 3183, 3193, 3182, 3121, 3165, 3195, 3193, 3186, 3176, 2062, 2049, 2054, 2060, 2108, 2074, 2077, 2075, 2076, 2089, 2054, 2059, 2048, 2055, 2074, 2090, 2065, 2081, 2075, 2075, 2077, 2061, 2074, 2089, 2054, 2060, 2107, 2049, 2063, 2054, 2057, 2076, 2077, 2074, 2061, 392, 495, 448, 409, 411, 396, 393, 411, 488, 466, 414, 457, 498, 414, 489, 387, 414, 394, 414, 402, 400, 407, 406, 405, 404, 409, 408, 413, 493, 492, 467, 456, 463, 462, 461, 494, 408, 410, 398, 411, 396, 393, 411, 488, 466, 414, 457, 498, 414, 489, 387, 414, 394, 414, 402, 400, 407, 406, 405, 404, 409, 408, 413, 493, 492, 467, 456, 463, 462, 461, 494, 408, 410, 463, 401, 411, 488, 493, 401, 494, 409, 410, 401, 410, 410, 396, 1135, 1058, 1063, 1058, 1075, 1079, 1062, 1073, 1150, 3253, 3270, 3324, 3248, 3303, 3292, 3248, 3271, 3245, 3248, 3236, 3248, 3260, 3262, 3257, 3256, 3259, 3258, 3255, 3254, 3251, 3267, 3266, 3325, 3302, 3297, 3296, 3299, 3264, 3254, 3252, 3250, 3253, 3270, 3324, 3248, 3303, 3292, 3248, 3271, 3245, 3248, 3236, 3248, 3260, 3262, 3257, 3256, 3259, 3258, 3255, 3254, 3251, 3267, 3266, 3325, 3302, 3297, 3296, 3299, 3264, 3254, 3252, 808, 816, 815, 803, 825, 831, 824, 820, 803, 797, 786, 787, 786, 803, 811, 821, 808, 820, 803, 818, 809, 816, 816, 803, 815, 820, 829, 1794, 1818, 1797, 1801, 1811, 1813, 1810, 1822, 1811, 1801, 1811, 1813, 1810, 1797, 1815, 1801, 1793, 1823, 1794, 1822, 1801, 1815, 1811, 1797, 1801, 1892, 1891, 1888, 1801, 1809, 1813, 1819, 1801, 1797, 1822, 1815, 1893, 1902, 1890, 1005, 982, 979, 982, 983, 975, 982, 920, 1020, 985, 972, 989, 1022, 983, 970, 981, 985, 972, 920, 971, 972, 961, 980, 989, 898, 920, 2795, 2788, 2798, 2808, 2789, 2787, 2798, 2724, 2787, 2788, 2814, 2799, 2788, 2814, 2724, 2795, 2793, 2814, 2787, 2789, 2788, 2724, 2780, 2755, 2767, 2781, 3083, 3083, 3087, 1261, 1227, 1244, 1242, 1223, 1224, 1223, 1229, 1231, 1242, 1227, 1166, 1246, 1223, 1216, 1216, 1223, 1216, 1225, 1166, 1224, 1231, 1223, 1218, 1243, 1244, 1227, 1167, 1326, 1304, 1289, 1360, 1342, 1298, 1298, 1302, 1300, 1304, 1206, 1170, 1201, 1165, 1165, 1161, 1241, 1244, 1162, 1241, 1193, 1164, 1162, 1169, 1241, 1195, 1180, 1160, 1164, 1180, 1162, 1165, 1186, 1244, 1162, 1188, 702, 689, 762, 674, 697, 698, 696, 691, 702, 689, 702, 690, 691, 762, 676, 702, 697, 692, 690, 639, 561, 560, 555, 639, 553, 570, 557, 566, 569, 566, 570, 571, 613, 597, 639, 639, 639, 639, 572, 570, 557, 555, 566, 569, 566, 572, 574, 555, 570, 613, 639, 2327, 2331, 2330, 2304, 2321, 2330, 2304, 2393, 2310, 2325, 2330, 2323, 2321, 2938, 2880, 409, 446, 422, 433, 444, 441, 436, 496, 412, 441, 446, 443, 496, 407, 441, 422, 437, 446, 496, 402, 425, 496, 404, 437, 422, 437, 444, 447, 416, 437, 418, 496, 491, 505, 496, 403, 447, 446, 420, 433, 435, 420, 496, 404, 437, 422, 437, 444, 447, 416, 437, 418, 496, 438, 447, 418, 496, 386, 437, 419, 447, 444, 422, 437, 496, 393, 447, 421, 418, 496, 409, 419, 419, 421, 437, 419, 1766, 1777, 1702, 1773, 451, 449, 476, 455, 476, 464, 476, 479, 460, 470, 449, 449, 476, 449, 435, 448, 470, 455, 455, 474, 477, 468, 448, 460, 470, 477, 466, 465, 479, 470, 460, 451, 454, 448, 475, 435, 434, 430, 435, 419, 435, 508, 481, 435, 418, 2624, 2652, 2640, 2648, 2646, 2631, 2580, 2624, 2579, 2650, 2653, 2627, 2630, 2631, 2579, 2624, 2631, 2625, 2646, 2642, 2654, 2579, 2574, 2574, 2579, 2653, 2630, 2655, 2655, 3081, 3124, 3132, 3113, 3119, 3128, 3113, 3112, 3180, 3117, 3106, 3180, 3109, 3106, 3128, 3180, 3118, 3129, 3128, 3180, 3131, 3117, 3135, 3180, 884, 878, 893, 866, 807, 827, 807, 819, 829, 807, 2414, 2419, 2400, 2425, 2341, 2345, 2413, 2412, 2415, 2405, 2408, 2429, 2412, 632, 632, 1464, 1455, 1447, 1445, 1468, 1455, 1420, 1422, 1411, 1411, 898, 905, 896, 915, 914, 900, 917};

    public static int f1474 = 62;

    public static int m13339() {
        if (C0457zc.m10735() <= 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static short[] m13340() {
        if (C0461zs.m11510() < 0) {
            return f1473short;
        }
        return null;
    }

    public static String m13341() {
        if (C0456zb.m10484() <= 0) {
            return C0458ze.m10915(m13340(), 0, 2, 2479);
        }
        return null;
    }

    public static String m13342() {
        if (abd.m2021() > 0) {
            return abd.m2070(m13340(), 2, 20, 1026);
        }
        return null;
    }

    public static InterfaceC0252iu m13343(Object obj) {
        if (C0456zb.m10484() < 0) {
            return C0455za.m10132((C0329lq) obj);
        }
        return null;
    }

    public static String m13344() {
        if (C0453yj.m9966() > 0) {
            return C0460zg.m11422(m13340(), 22, 8, 2578);
        }
        return null;
    }

    public static String m13345() {
        if (C0453yj.m9945() <= 0) {
            return abe.m2412(m13340(), 30, 38, 802);
        }
        return null;
    }

    public static String m13346(short[] sArr, int i, int i2, int i3) {
        char[] cArr = new char[i2];
        for (int i4 = 0; i4 < i2; i4++) {
            cArr[i4] = (char) (sArr[i + i4] ^ i3);
        }
        return new String(cArr);
    }

    public static String m13347() {
        if (abd.m2021() > 0) {
            return C0452yh.m9820(m13340(), 68, 21, 745);
        }
        return null;
    }

    public static String m13348() {
        if (gggy.m4365() > 0) {
            return C0455za.m10121(m13340(), 89, 12, 3001);
        }
        return null;
    }

    public static String m13349() {
        if (abd.m2166() <= 0) {
            return abe.m2412(m13340(), 101, 17, 1528);
        }
        return null;
    }

    public static String m13350() {
        if (C0453yj.m9966() > 0) {
            return abd.m2070(m13340(), 118, 49, 1724);
        }
        return null;
    }

    public static Iterator m13351(Object obj) {
        if (abd.m2021() >= 0) {
            return C0456zb.m10335((C0437s) obj);
        }
        return null;
    }

    public static void m13352(Object obj) {
        if (C0456zb.m10484() < 0) {
            C0447yc.m8715((C0354mn) obj);
        }
    }

    public static String m13353(Object obj) {
        if (abf.m2500() > 0) {
            return C0448yd.m9065((NullPointerException) obj);
        }
        return null;
    }

    public static C0412or m13354() {
        if (C0453yj.m9996() <= 0) {
            return C0453yj.m9989();
        }
        return null;
    }

    public static String m13355() {
        if (abd.m2021() > 0) {
            return C0458ze.m10915(m13340(), 167, 21, 2865);
        }
        return null;
    }

    public static InterfaceC0245in m13356(Object obj) {
        if (C0458ze.m10926() <= 0) {
            return C0456zb.m10389((C0319lg) obj);
        }
        return null;
    }

    public static long m13357(long j) {
        if (abd.m2021() >= 0) {
            return C0445ya.m8271(j);
        }
        return 0L;
    }

    public static void m13358(Object obj) {
        if (C0453yj.m9996() <= 0) {
            C0457zc.m10627((C0307kv) obj);
        }
    }

    public static DateFormat m13359(int i, int i2, Object obj) {
        if (C0453yj.m9966() >= 0) {
            return adds.m2704(i, i2, (Locale) obj);
        }
        return null;
    }

    public static String m13360() {
        if (C0453yj.m10032() >= 0) {
            return C0458ze.m10915(m13340(), 188, 35, 2054);
        }
        return null;
    }

    public static AbstractC0022ah m13361() {
        if (abd.m2166() <= 0) {
            return C0458ze.m10952();
        }
        return null;
    }

    public static String m13362() {
        if (C0459zf.m11053() > 0) {
            return C0448yd.m9031(m13340(), 223, 5, 1518);
        }
        return null;
    }

    public static String m13363() {
        if (C0448yd.m9015() < 0) {
            return C0447yc.m8718(m13340(), 228, 5, 2504);
        }
        return null;
    }

    public static C0274jp m13364(Object obj, Object obj2) {
        if (C0459zf.m11053() >= 0) {
            return C0445ya.m8194((C0274jp) obj, (String) obj2);
        }
        return null;
    }

    public static boolean m13365(Object obj) {
        if (abd.m2021() >= 0) {
            return gggy.m4366((C0152fb) obj);
        }
        return false;
    }

    public static String m13366() {
        if (C0457zc.m10555() >= 0) {
            return gggy.m4340(m13340(), 233, 30, 2120);
        }
        return null;
    }

    public static String m13367() {
        if (C0448yd.m9015() <= 0) {
            return C0457zc.m10560(m13340(), 263, 3, 3227);
        }
        return null;
    }

    public static Type[] m13368(Object obj) {
        if (C0460zg.m11293() > 0) {
            return C0450yf.m9513((ParameterizedType) obj);
        }
        return null;
    }

    public static String m13369() {
        if (abf.m2500() >= 0) {
            return adds.m2884(m13340(), 266, 23, 567);
        }
        return null;
    }

    public static String m13370() {
        if (C0453yj.m10032() > 0) {
            return C0447yc.m8718(m13340(), 289, 11, 2514);
        }
        return null;
    }

    public static String m13371() {
        if (abf.m2500() > 0) {
            return C0457zc.m10560(m13340(), 300, 16, 2265);
        }
        return null;
    }

    public static AbstractC0022ah m13372() {
        if (C0453yj.m9945() <= 0) {
            return C0452yh.m9684();
        }
        return null;
    }

    public static String m13373() {
        if (abf.m2500() >= 0) {
            return C0452yh.m9820(m13340(), 316, 10, 3100);
        }
        return null;
    }

    public static Object m13374(Object obj, Object obj2, Object obj3) {
        if (C0448yd.m9015() < 0) {
            return C0455za.m10181((C0285k) obj, (String) obj2, (Type) obj3);
        }
        return null;
    }

    public static String m13375() {
        if (C0447yc.m8786() > 0) {
            return C0458ze.m10915(m13340(), 326, 35, 2152);
        }
        return null;
    }

    public static String m13376() {
        if (C0453yj.m9945() < 0) {
            return C0451yg.m9579(m13340(), 361, 86, 435);
        }
        return null;
    }

    public static boolean m13377(Object obj) {
        if (C0453yj.m9966() > 0) {
            return C0458ze.m10881((List) obj);
        }
        return false;
    }

    public static String m13378(Object obj) {
        if (C0460zg.m11293() > 0) {
            return C0448yd.m8868((C0187gj) obj);
        }
        return null;
    }

    public static void m13379(Object obj, Object obj2) {
        if (abd.m2166() <= 0) {
            C0457zc.m10589((Thread) obj, (String) obj2);
        }
    }

    public static String m13380() {
        if (C0447yc.m8786() >= 0) {
            return C0448yd.m9031(m13340(), 447, 9, 1091);
        }
        return null;
    }

    public static boolean m13381(Object obj) {
        if (C0448yd.m9015() < 0) {
            return C0449ye.m9307((Deque) obj);
        }
        return false;
    }

    public static byte[] m13382(Object obj) {
        if (m13339() >= 0) {
            return C0458ze.m10841((PublicKey) obj);
        }
        return null;
    }

    public static void m13383(Object obj, Object obj2) {
        if (C0453yj.m9966() > 0) {
            C0448yd.m8970((AbstractC0264jf) obj, (InterfaceC0245in) obj2);
        }
    }

    public static Principal m13384(Object obj) {
        if (C0459zf.m11053() > 0) {
            return C0445ya.m8398((X509Certificate) obj);
        }
        return null;
    }

    public static int m13385(Object obj) {
        if (C0453yj.m9996() < 0) {
            return C0446yb.m8504((Map) obj);
        }
        return 0;
    }

    public static String m13386() {
        if (C0460zg.m11293() >= 0) {
            return C0446yb.m8463(m13340(), 456, 63, 3229);
        }
        return null;
    }

    public static String m13387(Object obj) {
        if (C0459zf.m11053() >= 0) {
            return abe.m2246((Uri) obj);
        }
        return null;
    }

    public static String m13388() {
        if (abd.m2021() > 0) {
            return C0456zb.m10478(m13340(), 519, 27, 892);
        }
        return null;
    }

    public static Object m13389(Object obj, Object obj2) {
        if (C0447yc.m8786() >= 0) {
            return C0448yd.m8974((Map) obj, obj2);
        }
        return null;
    }

    public static String m13390() {
        if (abd.m2021() > 0) {
            return abe.m2412(m13340(), 546, 39, 1878);
        }
        return null;
    }

    public static String m13391() {
        if (abe.m2321() <= 0) {
            return C0457zc.m10560(m13340(), 585, 26, 952);
        }
        return null;
    }

    public static Typeface m13392(Object obj) {
        if (C0456zb.m10484() < 0) {
            return C0453yj.m9980((TextView) obj);
        }
        return null;
    }

    public static String m13393() {
        if (C0457zc.m10718() <= 0) {
            return C0455za.m10121(m13340(), 611, 26, 2698);
        }
        return null;
    }

    public static AbstractC0022ah m13394() {
        if (C0453yj.m9996() < 0) {
            return C0456zb.m10345();
        }
        return null;
    }

    public static boolean m13395(Object obj, Object obj2) {
        if (abd.m2166() < 0) {
            return C0452yh.m9674((Set) obj, obj2);
        }
        return false;
    }

    public static Date m13396(Object obj) {
        if (C0457zc.m10718() <= 0) {
            return C0448yd.m9017((Calendar) obj);
        }
        return null;
    }

    public static int m13397() {
        return 1751596 ^ C0455za.m10081(C0459zf.m11207(m13340(), 637, 3, 2799));
    }

    public static String m13398() {
        if (abe.m2321() <= 0) {
            return abd.m2070(m13340(), 640, 28, 1198);
        }
        return null;
    }

    public static C0155fe m13399(Object obj, long j) {
        if (C0456zb.m10484() < 0) {
            return C0448yd.m8985((C0155fe) obj, j);
        }
        return null;
    }

    public static InterfaceC0304ks m13400(Object obj, Object obj2) {
        if (C0460zg.m11293() >= 0) {
            return C0447yc.m8738((InterfaceC0310ky) obj, (C0290ke) obj2);
        }
        return null;
    }

    public static String m13401() {
        if (C0448yd.m9074() <= 0) {
            return abe.m2412(m13340(), 668, 10, 1405);
        }
        return null;
    }

    public static Type m13402(Object obj) {
        if (C0456zb.m10484() <= 0) {
            return abe.m2325((ParameterizedType) obj);
        }
        return null;
    }

    public static String m13403() {
        if (C0456zb.m10484() < 0) {
            return abf.m2527(m13340(), 678, 26, 1273);
        }
        return null;
    }

    public static Object m13404(Object obj) {
        if (C0448yd.m9015() <= 0) {
            return C0460zg.m11266((Reference) obj);
        }
        return null;
    }

    public static String m13405() {
        if (C0453yj.m9996() <= 0) {
            return adds.m2884(m13340(), 704, 19, 727);
        }
        return null;
    }

    public static Object m13406(Object obj, int i, Object obj2) {
        if (C0459zf.m11053() > 0) {
            return C0461zs.m11449((List) obj, i, obj2);
        }
        return null;
    }

    public static String m13407() {
        if (C0456zb.m10484() < 0) {
            return C0452yh.m9820(m13340(), 723, 32, 607);
        }
        return null;
    }

    public static SharedPreferences.Editor m13408(Object obj, Object obj2, Object obj3) {
        if (C0457zc.m10718() <= 0) {
            return C0445ya.m8314((SharedPreferences.Editor) obj, (String) obj2, (String) obj3);
        }
        return null;
    }

    public static int m13409(Object obj) {
        if (m13339() > 0) {
            return gggy.m4475((Socket) obj);
        }
        return 0;
    }

    public static C0409oo m13410(Object obj, Object obj2) {
        if (abd.m2166() < 0) {
            return abd.m2040((C0409oo) obj, (byte[]) obj2);
        }
        return null;
    }

    public static int m13411(Object obj) {
        if (C0458ze.m10926() <= 0) {
            return C0445ya.m8245((InterfaceC0277js) obj);
        }
        return 0;
    }

    public static Object m13412(Object obj, int i) {
        if (gggy.m4365() > 0) {
            return C0449ye.m9308((List) obj, i);
        }
        return null;
    }

    public static boolean m13413(double d) {
        if (C0458ze.m10926() < 0) {
            return adds.m2859(d);
        }
        return false;
    }

    public static URLConnection m13414(Object obj) {
        if (gggy.m4365() > 0) {
            return C0456zb.m10330((URL) obj);
        }
        return null;
    }

    public static String m13415() {
        if (C0448yd.m9074() < 0) {
            return abd.m2070(m13340(), 755, 13, 2420);
        }
        return null;
    }

    public static String m13416() {
        if (C0447yc.m8786() > 0) {
            return C0450yf.m9476(m13340(), 768, 2, 2854);
        }
        return null;
    }

    public static EnumC0154fd m13417() {
        if (C0447yc.m8786() > 0) {
            return C0450yf.m9447();
        }
        return null;
    }

    public static String m13418() {
        if (C0453yj.m10032() > 0) {
            return abe.m2412(m13340(), 770, 76, 464);
        }
        return null;
    }

    public static String m13419() {
        if (C0453yj.m9945() <= 0) {
            return adds.m2884(m13340(), 846, 4, 1731);
        }
        return null;
    }

    public static void m13420(Object obj) {
        if (m13339() > 0) {
            abc.m1899((C0152fb) obj);
        }
    }

    public static Type m13421(Object obj) {
        if (C0460zg.m11293() >= 0) {
            return C0447yc.m8811((Type) obj);
        }
        return null;
    }

    public static String m13422() {
        if (C0453yj.m10032() >= 0) {
            return C0448yd.m9031(m13340(), 850, 45, 403);
        }
        return null;
    }

    public static boolean m13423(Object obj) {
        if (abd.m2021() > 0) {
            return C0447yc.m8770((C0243il) obj);
        }
        return false;
    }

    public static String m13424() {
        if (abe.m2321() < 0) {
            return C0458ze.m10915(m13340(), 895, 29, 2611);
        }
        return null;
    }

    public static long m13425(Object obj) {
        if (m13339() > 0) {
            return C0447yc.m8752((Inflater) obj);
        }
        return 0L;
    }

    public static Throwable m13426(Object obj, Object obj2) {
        if (C0453yj.m9945() <= 0) {
            return C0453yj.m9827((UnknownHostException) obj, (Throwable) obj2);
        }
        return null;
    }

    public static List m13427(Object obj, Object obj2) {
        if (C0458ze.m10926() <= 0) {
            return C0449ye.m9151((ProxySelector) obj, (URI) obj2);
        }
        return null;
    }

    public static void m13428(Object obj, Object obj2, long j) {
        if (m13339() >= 0) {
            C0457zc.m10738((C0409oo) obj, (C0409oo) obj2, j);
        }
    }

    public static String m13429() {
        if (m13339() >= 0) {
            return adds.m2884(m13340(), 924, 24, 3148);
        }
        return null;
    }

    public static String m13430() {
        if (C0447yc.m8786() >= 0) {
            return abe.m2412(m13340(), 948, 10, 775);
        }
        return null;
    }

    public static String m13431() {
        if (C0459zf.m11053() > 0) {
            return abf.m2527(m13340(), 958, 13, 2313);
        }
        return null;
    }

    public static String m13432() {
        if (C0458ze.m10926() < 0) {
            return C0446yb.m8463(m13340(), 971, 2, 600);
        }
        return null;
    }

    public static int m13433(Object obj, int i, int i2) {
        if (gggy.m4365() >= 0) {
            return C0447yc.m8692((String) obj, i, i2);
        }
        return 0;
    }

    public static int m13434(Object obj) {
        if (C0453yj.m9945() < 0) {
            return C0450yf.m9458((PackageInfo) obj);
        }
        return 0;
    }

    public static boolean m13435(Object obj) {
        if (C0457zc.m10718() <= 0) {
            return C0449ye.m9285((String) obj);
        }
        return false;
    }

    public static String m13436(Object obj) {
        if (C0457zc.m10718() <= 0) {
            return abc.m1891((C0184gg) obj);
        }
        return null;
    }

    public static void m13437(Object obj) {
        if (gggy.m4365() >= 0) {
            abe.m2395((InterfaceC0428pg) obj);
        }
    }

    public static String m13438() {
        if (abd.m2021() >= 0) {
            return C0448yd.m9031(m13340(), 973, 6, 1482);
        }
        return null;
    }

    public static String m13439(String str) {
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
        String strM10887 = C0458ze.m10887();
        while (gggy.m4397(strM10887) > 0) {
            strM10887 = gggy.m4277();
            if (gggy.m4397(strM10887) == 0) {
                strM10887 = C0458ze.m10887();
            }
        }
        int iM4397 = gggy.m4397(strM10887);
        int iM4398 = gggy.m4397(strM4278);
        for (int i3 = 0; i3 < iM4397; i3++) {
            bArrM9611[i3] = (byte) (bArrM9611[i3] ^ C0446yb.m8419(strM4278, i3 % iM4398));
        }
        for (int iM4399 = 0; iM4399 < bArrM9611.length; iM4399 = gggy.m4397(gggy.m4277()) + 1) {
        }
        return new String(bArrM9611);
    }

    public static boolean m13440(Object obj, long j, Object obj2, int i, int i2) {
        if (abd.m2021() >= 0) {
            return adds.m2739((C0409oo) obj, j, (C0412or) obj2, i, i2);
        }
        return false;
    }

    public static void m13441(Object obj, Object obj2) {
        if (C0447yc.m8786() > 0) {
            abc.m1797((Activity) obj, (Intent) obj2);
        }
    }

    public static String m13442() {
        if (C0445ya.m8330() > 0) {
            return abd.m2070(m13340(), 979, 4, 1519);
        }
        return null;
    }

    public static Class m13443(Object obj) {
        if (C0458ze.m10926() < 0) {
            return C0459zf.m11105((C0151fa) obj);
        }
        return null;
    }

    public static String m13444() {
        if (C0459zf.m11053() > 0) {
            return C0448yd.m9031(m13340(), 983, 7, 993);
        }
        return null;
    }
}
