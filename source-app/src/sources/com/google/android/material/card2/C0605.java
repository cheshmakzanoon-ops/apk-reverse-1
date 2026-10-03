package com.google.android.material.card2;

import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.widget.ImageView;
import android.widget.TextView;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.Reader;
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.GenericArrayType;
import java.lang.reflect.Type;
import java.lang.reflect.WildcardType;
import java.net.InetSocketAddress;
import java.net.Proxy;
import java.net.Socket;
import java.security.Principal;
import java.security.cert.X509Certificate;
import java.text.DateFormat;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TimeZone;
import java.util.UUID;
import java.util.concurrent.TimeUnit;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class C0605 {

    private static final short[] f1461short = {1684, 1684, 1675, 1688, 1667, 1679, 1666, 1688, 1667, 1684, 1684, 1688, 1680, 1678, 1683, 1679, 1688, 1667, 1666, 1684, 1688, 1668, 1669, 1668, 1688, 1684, 1679, 1670, 1911, 1909, 1892, 1873, 1916, 1888, 1918, 1859, 1909, 1916, 1909, 1907, 1892, 1909, 1908, 1856, 1890, 1919, 1892, 1919, 1907, 1919, 1916, 2029, 2030, 2018, 2026, 2017, 1987, 1998, 1998, 1984, 1987, 1985, 1993, 1922, 1988, 1987, 1995, 1998, 2007, 2000, 1991, 1922, 1988, 1997, 2000, 1922, 972, 962, 990, 903, 922, 922, 903, 969, 978, 971, 971, 903, 987, 987, 903, 977, 966, 971, 978, 962, 903, 922, 922, 903, 969, 978, 971, 971, 335, 347, 336, 336, 337, 337, 341, 336, 338, 337, 340, 346, 343, 342, 341, 341, 343, 346, 338, 346, 2286, 545, 627, 612, 629, 628, 627, 623, 612, 613, 545, 623, 622, 545, 608, 613, 613, 627, 612, 626, 626, 612, 626, 545, 615, 622, 627, 545, 3000, 2974, 2952, 3021, 2983, 2974, 2946, 2947, 3007, 2952, 2956, 2953, 2952, 2975, 3011, 2974, 2952, 2969, 2977, 2952, 2947, 2948, 2952, 2947, 2969, 3013, 2969, 2975, 2968, 2952, 3012, 3021, 2969, 2946, 3021, 2956, 2958, 2958, 2952, 2973, 2969, 3021, 2944, 2956, 2945, 2955, 2946, 2975, 2944, 2952, 2953, 3021, 2983, 3006, 2978, 2979, 3030, 1496, 1493, 1500, 1481, 1491, 1487, 1475, 1474, 1496, 1477, 1474, 1497, 1485, 1496, 1477, 1475, 1474, 1452, 1535, 1528, 1534, 1513, 1517, 1505, 1477, 1512, 1452, 1519, 1508, 1517, 1506, 1515, 1513, 1512, 3100, 3083, 3083, 3094, 3083, 3130, 3094, 3101, 3100, 3159, 3089, 3085, 3085, 3081, 3130, 3094, 3101, 3100, 3161, 3140, 3140, 3161, 3156, 3144, 1612, 1600, 1601, 1627, 1610, 1601, 1627, 1538, 1603, 1614, 1601, 1608, 1626, 1614, 1608, 1610, 1053, 1030, 1037, 1040, 1048, 1037, 1035, 1052, 1037, 1036, 1096, 1048, 1031, 1050, 1052, 1106, 1096, 717, 725, 714, 710, 722, 715, 731, 684, 710, 732, 705, 713, 726, 715, 717, 710, 718, 720, 717, 721, 710, 715, 730, 685, 710, 685, 681, 710, 714, 721, 728, 3147, 3143, 3148, 3149, 3147, 3080, 3081, 3093, 3080, 3142, 3165, 3140, 3140, 2945, 2970, 2965, 2966, 2968, 2961, 3028, 2944, 2971, 3028, 2963, 2961, 2944, 3028, 2951, 2961, 2968, 2961, 2967, 2944, 2961, 2960, 3028, 2948, 2950, 2971, 2944, 2971, 2967, 2971, 2968, 872, 883, 894, 879, 857, 894, 888, 867, 868, 877, 810, 823, 823, 810, 868, 895, 870, 870, 2588, 2577, 2577, 2579, 2687, 2686, 2582, 2619, 2623, 2618, 2605, 2614, 2609, 2602, 2660, 2686, 562, 565, 559, 574, 553, 568, 574, 555, 559, 564, 553, 635, 2744, 2741, 2748, 2729, 2739, 2748, 2750, 2725, 2723, 2750, 2725, 2744, 2741, 2764, 2719, 2712, 2718, 2697, 2701, 2689, 2725, 2696, 2764, 2769, 2769, 2764, 2780, 3065, 3065, 1180, 1201, 1187, 1188, 1277, 1181, 1215, 1204, 1209, 1206, 1209, 1205, 1204, 1582, 1598, 1596, 1585, 1592, 1541, 1040, 1079, 1087, 1082, 1075, 1074, 1142, 1058, 1081, 1142, 1087, 1080, 1056, 1081, 1085, 1075, 1142, 1586, 1589, 1659, 1638, 1638, 1659, 1589, 1582, 1591, 1591, 2550, 2546, 2546, 2491, 1594, 1595, 1657, 1568, 1574, 1589, 1594, 1575, 1586, 1595, 1574, 1593, 834, 835, 692, 687, 676, 697, 689, 676, 674, 693, 676, 677, 737, 676, 687, 677, 737, 686, 679, 737, 690, 693, 691, 676, 672, 684, 737, 686, 687, 737, 1911, 1911, 1911, 1822, 1810, 1878, 1878, 1810, 1919, 1919, 1919, 1810, 1867, 1867, 1867, 1867, 1810, 1914, 1914, 1800, 1887, 1887, 1800, 1857, 1857, 1810, 1864, 1864, 1864, 3044, 3041, 3045, 3041, 3068, 2984, 2996, 2984, 3000, 2994, 2984, 3044, 3058, 3067, 3058, 3060, 3043, 3015, 3045, 3064, 3043, 3064, 3060, 3064, 3067, 2570, 2578, 2573, 2561, 2587, 2579, 2574, 2570, 2567, 2561, 2572, 2587, 2576, 2587, 2585, 2577, 2570, 2583, 2591, 2570, 2583, 2577, 2576, 2561, 2583, 2576, 2584, 2577, 2561, 2573, 2589, 2573, 2568, 2692, 2726, 2724, 2735, 2722, 2791, 2735, 2734, 2739, 2795, 2791, 2725, 2738, 2739, 2791, 2721, 2734, 2731, 2722, 2791, 2734, 2740, 2791, 2740, 2739, 2726, 2731, 2722, 2793, 2791, 2689, 2728, 2741, 2724, 2734, 2729, 2720, 2791, 2741, 2722, 2731, 2728, 2726, 2723, 2813, 2791, 1714, 1712, 1709, 1722, 1723, 1681, 1703, 1710, 1703, 1697, 1718, 1709, 1712, 1762, 1791, 1791, 1762, 1708, 1719, 1710, 1710, 2227, 2219, 2228, 2232, 2210, 2212, 2211, 2223, 2232, 2210, 2212, 2211, 2228, 2214, 2232, 2224, 2222, 2227, 2223, 2232, 2260, 2211, 2210, 2228, 2232, 2210, 2211, 2210, 2232, 2212, 2213, 2212, 2232, 2228, 2223, 2214, 1440, 1464, 1447, 1451, 1457, 1463, 1456, 1468, 1457, 1451, 1446, 1447, 1461, 1451, 1443, 1469, 1440, 1468, 1451, 1461, 1457, 1447, 1451, 1478, 1473, 1474, 1451, 1459, 1463, 1465, 1451, 1447, 1468, 1461, 1479, 1484, 1472, 2646, 2643, 2628, 2634, 2639, 2629, 2570, 2566, 2391, 2391, 2376, 2395, 2368, 2380, 2369, 2395, 2368, 2391, 2391, 2395, 2387, 2381, 2384, 2380, 2395, 2359, 2368, 2369, 2391, 2395, 2369, 2368, 2369, 2395, 2375, 2374, 2375, 2395, 2391, 2380, 2373, 2836, 2825, 2817, 2836, 2834, 2821, 2836, 2837, 2897, 3107, 3076, 3100, 3083, 3078, 3075, 3086, 3146, 3076, 3103, 3079, 3080, 3087, 3096, 3152, 3146, 2031, 2036, 1956, 1979, 1958, 1952, 2036, 1981, 1959, 2036, 1979, 1953, 1952, 2036, 1979, 1970, 2036, 1958, 1973, 1978, 1971, 1969, 2108, 2173, 2159, 2108, 2173, 2108, 2140, 2134, 2159, 2163, 2162, 2141, 2168, 2173, 2156, 2152, 2169, 2158, 2108, 2170, 2163, 2158, 2108};

    public static boolean f1462 = true;

    public static short[] m12695() {
        if (C0459zf.m11062() >= 0) {
            return f1461short;
        }
        return null;
    }

    public static int m12696() {
        if (C0456zb.m10326() < 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static WildcardType m12697(Object obj) {
        if (C0453yj.m9966() > 0) {
            return C0456zb.m10369((Type) obj);
        }
        return null;
    }

    public static boolean m12698(Object obj, Object obj2) {
        if (abd.m2166() < 0) {
            return abe.m2266((Map) obj, obj2);
        }
        return false;
    }

    public static String m12699() {
        if (m12696() > 0) {
            return C0459zf.m11207(m12695(), 0, 28, 1735);
        }
        return null;
    }

    public static boolean m12700(Object obj, Object obj2) {
        if (C0456zb.m10484() < 0) {
            return C0461zs.m11480((String) obj, (String) obj2);
        }
        return false;
    }

    public static void m12701(Object obj, float f) {
        if (abe.m2321() < 0) {
            C0446yb.m8492((ImageView) obj, f);
        }
    }

    public static long m12702(Object obj) {
        if (C0448yd.m9074() <= 0) {
            return C0446yb.m8551((C0271jm) obj);
        }
        return 0L;
    }

    public static EnumC0154fd m12703() {
        if (C0456zb.m10484() < 0) {
            return C0448yd.m8855();
        }
        return null;
    }

    public static Intent m12704(Object obj, Object obj2) {
        if (C0457zc.m10555() >= 0) {
            return C0445ya.m8272((Intent) obj, (Uri) obj2);
        }
        return null;
    }

    public static Object m12705(Object obj, Object obj2, Object obj3) {
        if (C0453yj.m9996() <= 0) {
            return C0452yh.m9764((C0285k) obj, (Reader) obj2, (Type) obj3);
        }
        return null;
    }

    public static Matcher m12706(Object obj, Object obj2) {
        if (abf.m2500() >= 0) {
            return abf.m2526((Matcher) obj, (Pattern) obj2);
        }
        return null;
    }

    public static AbstractC0022ah m12707() {
        if (C0445ya.m8330() > 0) {
            return adds.m2777();
        }
        return null;
    }

    public static String m12708() {
        if (C0458ze.m10926() <= 0) {
            return C0446yb.m8463(m12695(), 28, 23, 1808);
        }
        return null;
    }

    public static String m12709() {
        if (C0447yc.m8786() > 0) {
            return abd.m2070(m12695(), 51, 4, 1953);
        }
        return null;
    }

    public static String m12710() {
        if (C0460zg.m11293() >= 0) {
            return C0446yb.m8463(m12695(), 55, 21, 1954);
        }
        return null;
    }

    public static ContentResolver m12711(Object obj) {
        if (C0459zf.m11053() > 0) {
            return C0446yb.m8486((Context) obj);
        }
        return null;
    }

    public static InterfaceC0429ph m12712(Object obj, Object obj2) {
        if (abd.m2021() > 0) {
            return C0458ze.m10917((C0335lw) obj, (C0273jo) obj2);
        }
        return null;
    }

    public static String m12713() {
        if (C0457zc.m10718() < 0) {
            return C0452yh.m9820(m12695(), 76, 28, 935);
        }
        return null;
    }

    public static String m12714() {
        if (C0453yj.m9966() > 0) {
            return abf.m2527(m12695(), 104, 20, 354);
        }
        return null;
    }

    public static String m12715() {
        if (C0448yd.m9074() < 0) {
            return C0460zg.m11422(m12695(), 124, 1, 2255);
        }
        return null;
    }

    public static String m12716() {
        if (abd.m2021() >= 0) {
            return C0455za.m10121(m12695(), 125, 27, 513);
        }
        return null;
    }

    public static boolean m12717(Object obj, Object obj2) {
        if (C0445ya.m8330() > 0) {
            return C0461zs.m11593((InetSocketAddress) obj, obj2);
        }
        return false;
    }

    public static UUID m12718(Object obj) {
        if (C0453yj.m10032() > 0) {
            return C0448yd.m8966((String) obj);
        }
        return null;
    }

    public static void m12719(Object obj, Object obj2) {
        if (abd.m2166() <= 0) {
            C0453yj.m9959((AbstractC0264jf) obj, (InterfaceC0245in) obj2);
        }
    }

    public static String m12720() {
        if (abe.m2321() < 0) {
            return C0460zg.m11422(m12695(), 152, 56, 3053);
        }
        return null;
    }

    public static String m12721(int i) {
        if (C0445ya.m8330() > 0) {
            return C0459zf.m11127(i);
        }
        return null;
    }

    public static boolean m12722(Object obj, Object obj2) {
        if (abd.m2021() >= 0) {
            return abf.m2439((C0290ke) obj, (C0286ka) obj2);
        }
        return false;
    }

    public static String m12723() {
        if (gggy.m4365() > 0) {
            return C0456zb.m10478(m12695(), 208, 1, 3035);
        }
        return null;
    }

    public static String m12724() {
        if (m12696() > 0) {
            return C0457zc.m10560(m12695(), 209, 34, 1420);
        }
        return null;
    }

    public static List m12725(Object obj) {
        if (C0445ya.m8330() > 0) {
            return C0457zc.m10606((C0373nf) obj);
        }
        return null;
    }

    public static C0291kf m12726(Object obj, Object obj2) {
        if (C0453yj.m9996() <= 0) {
            return C0456zb.m10284((C0291kf) obj, (C0286ka) obj2);
        }
        return null;
    }

    public static void m12727(Object obj, int i) {
        if (C0445ya.m8330() > 0) {
            C0459zf.m11136((TextView) obj, i);
        }
    }

    public static String m12728() {
        if (abd.m2021() >= 0) {
            return C0455za.m10121(m12695(), 243, 24, 3193);
        }
        return null;
    }

    public static AbstractC0022ah m12729() {
        if (C0453yj.m9945() < 0) {
            return C0449ye.m9178();
        }
        return null;
    }

    public static String m12730(Object obj) {
        if (m12696() >= 0) {
            return abd.m2003((C0273jo) obj);
        }
        return null;
    }

    public static int m12731(Object obj) {
        if (abe.m2321() < 0) {
            return C0456zb.m10420((StringBuilder) obj);
        }
        return 0;
    }

    public static String m12732() {
        if (C0458ze.m10926() <= 0) {
            return abc.m1781(m12695(), 267, 16, 1583);
        }
        return null;
    }

    public static Collection m12733(Object obj) {
        if (C0453yj.m9966() > 0) {
            return C0459zf.m11056((X509Certificate) obj);
        }
        return null;
    }

    public static String m12734(String str) {
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

    public static String m12735() {
        if (abd.m2021() >= 0) {
            return abe.m2412(m12695(), 283, 17, 1128);
        }
        return null;
    }

    public static String m12736() {
        if (C0453yj.m9966() > 0) {
            return C0448yd.m9031(m12695(), 300, 31, 665);
        }
        return null;
    }

    public static String m12737() {
        if (C0453yj.m9945() <= 0) {
            return C0450yf.m9476(m12695(), 331, 13, 3112);
        }
        return null;
    }

    public static int m12738(Object obj) {
        if (abe.m2321() < 0) {
            return C0456zb.m10435((C0271jm) obj);
        }
        return 0;
    }

    public static void m12739(Object obj, Object obj2) {
        if (C0453yj.m9966() > 0) {
            C0446yb.m8459((C0316ld) obj, (IOException) obj2);
        }
    }

    public static String m12740() {
        if (abf.m2500() >= 0) {
            return abe.m2412(m12695(), 344, 31, 3060);
        }
        return null;
    }

    public static AbstractC0022ah m12741() {
        if (abe.m2321() < 0) {
            return C0452yh.m9658();
        }
        return null;
    }

    public static int m12742(Object obj) {
        if (C0457zc.m10718() <= 0) {
            return C0455za.m10169((Field) obj);
        }
        return 0;
    }

    public static InterfaceC0024aj m12743() {
        if (C0459zf.m11053() >= 0) {
            return C0455za.m10168();
        }
        return null;
    }

    public static String m12744() {
        if (C0458ze.m10926() <= 0) {
            return C0460zg.m11422(m12695(), 375, 18, 778);
        }
        return null;
    }

    public static String m12745() {
        if (C0456zb.m10484() < 0) {
            return C0450yf.m9476(m12695(), 393, 16, 2654);
        }
        return null;
    }

    public static DateFormat m12746(int i, int i2) {
        if (C0457zc.m10555() >= 0) {
            return C0456zb.m10458(i, i2);
        }
        return null;
    }

    public static String m12747() {
        if (C0459zf.m11053() >= 0) {
            return C0446yb.m8463(m12695(), 409, 12, 603);
        }
        return null;
    }

    public static long m12748(Object obj) {
        if (C0453yj.m9996() <= 0) {
            return C0453yj.m10015((AbstractC0292kg) obj);
        }
        return 0L;
    }

    public static void m12749(Object obj, Object obj2) {
        if (C0453yj.m9966() >= 0) {
            C0448yd.m9044((AbstractC0264jf) obj, (InterfaceC0245in) obj2);
        }
    }

    public static byte[] m12750(Object obj) {
        if (C0456zb.m10484() <= 0) {
            return C0450yf.m9501((ByteArrayOutputStream) obj);
        }
        return null;
    }

    public static C0294ki m12751(Object obj) {
        if (C0457zc.m10555() >= 0) {
            return gggy.m4392((C0318lf) obj);
        }
        return null;
    }

    public static String m12752() {
        if (C0457zc.m10718() <= 0) {
            return C0447yc.m8718(m12695(), 421, 27, 2796);
        }
        return null;
    }

    public static C0409oo m12753(Object obj) {
        if (C0459zf.m11053() >= 0) {
            return C0456zb.m10475((InterfaceC0411oq) obj);
        }
        return null;
    }

    public static String m12754() {
        if (C0453yj.m9945() < 0) {
            return C0456zb.m10478(m12695(), 448, 2, 3015);
        }
        return null;
    }

    public static String m12755() {
        if (gggy.m4365() >= 0) {
            return abf.m2527(m12695(), 450, 13, 1232);
        }
        return null;
    }

    public static String m12756(Object obj) {
        if (C0459zf.m11053() > 0) {
            return C0449ye.m9189((C0184gg) obj);
        }
        return null;
    }

    public static String m12757() {
        if (gggy.m4365() > 0) {
            return C0447yc.m8718(m12695(), 463, 6, 1629);
        }
        return null;
    }

    public static String m12758() {
        if (abe.m2321() < 0) {
            return abd.m2070(m12695(), 469, 17, 1110);
        }
        return null;
    }

    public static String m12759() {
        if (C0456zb.m10484() < 0) {
            return abe.m2412(m12695(), 486, 10, 1627);
        }
        return null;
    }

    public static String m12760() {
        if (C0457zc.m10718() <= 0) {
            return abd.m2070(m12695(), 496, 4, 2433);
        }
        return null;
    }

    public static void m1521(Object obj, boolean z) {
        if (C0459zf.m11053() >= 0) {
            C0448yd.m9047((C0155fe) obj, z);
        }
    }

    public static String m12761() {
        if (C0453yj.m10032() >= 0) {
            return adds.m2884(m12695(), 500, 12, 1620);
        }
        return null;
    }

    public static int m12762() {
        return 56538 ^ C0455za.m10081(abe.m2412(m12695(), 512, 2, 1446));
    }

    public static String m12763() {
        if (C0457zc.m10718() < 0) {
            return abc.m1781(m12695(), 514, 28, 705);
        }
        return null;
    }

    public static String m12764() {
        if (C0448yd.m9015() < 0) {
            return C0459zf.m11207(m12695(), 542, 29, 1842);
        }
        return null;
    }

    public static String m12765() {
        if (C0460zg.m11293() >= 0) {
            return C0460zg.m11422(m12695(), 571, 11, 2952);
        }
        return null;
    }

    public static String m12766() {
        if (abd.m2021() > 0) {
            return abe.m2412(m12695(), 582, 14, 2967);
        }
        return null;
    }

    public static Socket m12767(Object obj, Object obj2, Object obj3, Object obj4) {
        if (gggy.m4365() >= 0) {
            return C0456zb.m10336((AbstractC0296kk) obj, (C0253iv) obj2, (C0239ih) obj3, (C0319lg) obj4);
        }
        return null;
    }

    public static C0290ke m12768(Object obj) {
        if (C0457zc.m10555() > 0) {
            return C0455za.m10135((C0305kt) obj);
        }
        return null;
    }

    public static C0281jw m12769(Object obj, long j, Object obj2) {
        if (C0456zb.m10484() <= 0) {
            return C0461zs.m11608((C0281jw) obj, j, (TimeUnit) obj2);
        }
        return null;
    }

    public static void m12770(Object obj, Object obj2, Object obj3, Object obj4) {
        if (abf.m2500() >= 0) {
            C0460zg.m11272((AbstractC0264jf) obj, (InterfaceC0245in) obj2, (InetSocketAddress) obj3, (Proxy) obj4);
        }
    }

    public static Principal m12771(Object obj) {
        if (C0460zg.m11293() >= 0) {
            return C0446yb.m8580((X509Certificate) obj);
        }
        return null;
    }

    public static EnumC0295kj m12772() {
        if (C0448yd.m9015() <= 0) {
            return gggy.m4306();
        }
        return null;
    }

    public static String m12773() {
        if (C0448yd.m9074() < 0) {
            return C0459zf.m11207(m12695(), 596, 33, 2654);
        }
        return null;
    }

    public static InterfaceC0024aj m12774() {
        if (C0453yj.m10032() >= 0) {
            return C0445ya.m8327();
        }
        return null;
    }

    public static int m12775(Object obj, int i, int i2, int i3) {
        if (gggy.m4365() > 0) {
            return abc.m1829((int[]) obj, i, i2, i3);
        }
        return 0;
    }

    public static String m12776() {
        if (C0456zb.m10484() < 0) {
            return C0451yg.m9579(m12695(), 629, 46, 2759);
        }
        return null;
    }

    public static String m12777() {
        if (abf.m2500() >= 0) {
            return abd.m2070(m12695(), 675, 21, 1730);
        }
        return null;
    }

    public static Type m12778(Object obj) {
        if (C0453yj.m9945() < 0) {
            return C0447yc.m8648((GenericArrayType) obj);
        }
        return null;
    }

    public static long m12779() {
        if (C0448yd.m9015() <= 0) {
            return C0446yb.m8468();
        }
        return 0L;
    }

    public static C0290ke m12780(Object obj) {
        if (C0458ze.m10926() < 0) {
            return abc.m1776((C0290ke) obj);
        }
        return null;
    }

    public static String m12781(short[] sArr, int i, int i2, int i3) {
        char[] cArr = new char[i2];
        for (int i4 = 0; i4 < i2; i4++) {
            cArr[i4] = (char) (sArr[i + i4] ^ i3);
        }
        return new String(cArr);
    }

    public static Proxy m12782(Object obj) {
        if (abd.m2166() <= 0) {
            return gggy.m4430((C0279ju) obj);
        }
        return null;
    }

    public static boolean m12783(Object obj) {
        if (C0457zc.m10555() >= 0) {
            return abf.m2591((Constructor) obj);
        }
        return false;
    }

    public static C0415ou m12784(Object obj, Object obj2) {
        if (gggy.m4365() >= 0) {
            return C0448yd.m9021((C0415ou) obj, (C0430pi) obj2);
        }
        return null;
    }

    public static String m12785() {
        if (m12696() >= 0) {
            return C0455za.m10121(m12695(), 696, 36, 2279);
        }
        return null;
    }

    public static String m12786() {
        if (C0457zc.m10555() >= 0) {
            return C0452yh.m9820(m12695(), 732, 37, 1524);
        }
        return null;
    }

    public static String m12787() {
        if (m12696() > 0) {
            return abc.m1781(m12695(), 769, 8, 2598);
        }
        return null;
    }

    public static AbstractC0441v m12788(Object obj) {
        if (m12696() > 0) {
            return C0456zb.m10364((C0086cq) obj);
        }
        return null;
    }

    public static Object m12789(Object obj) {
        if (C0453yj.m9996() <= 0) {
            return C0457zc.m10754((C0320lh) obj);
        }
        return null;
    }

    public static String m12790() {
        if (C0448yd.m9074() < 0) {
            return abf.m2527(m12695(), 777, 33, 2308);
        }
        return null;
    }

    public static InterfaceC0024aj m12791() {
        if (abd.m2166() <= 0) {
            return C0448yd.m9045();
        }
        return null;
    }

    public static String m12792() {
        if (C0453yj.m9966() >= 0) {
            return C0452yh.m9820(m12695(), 810, 9, 2929);
        }
        return null;
    }

    public static String m12793(Object obj, Object obj2) {
        if (gggy.m4365() >= 0) {
            return C0453yj.m9954((C0271jm) obj, (String) obj2);
        }
        return null;
    }

    public static boolean m12794(Object obj, Object obj2) {
        if (C0453yj.m9996() < 0) {
            return abd.m2096((Collection) obj, obj2);
        }
        return false;
    }

    public static int m12795(Object obj, Object obj2) {
        if (C0445ya.m8330() >= 0) {
            return C0448yd.m9050((InputStream) obj, (OutputStream) obj2);
        }
        return 0;
    }

    public static List m12796(Object obj, Object obj2) {
        if (C0453yj.m10032() > 0) {
            return adds.m2771((C0271jm) obj, (String) obj2);
        }
        return null;
    }

    public static String m12797() {
        if (C0453yj.m9996() < 0) {
            return C0447yc.m8718(m12695(), 819, 16, 3178);
        }
        return null;
    }

    public static boolean m12798(char c) {
        if (C0453yj.m10032() > 0) {
            return C0446yb.m8435(c);
        }
        return false;
    }

    public static String m12799(Object obj) {
        if (C0456zb.m10484() <= 0) {
            return C0450yf.m9439((TimeZone) obj);
        }
        return null;
    }

    public static Iterator m12800(Object obj) {
        if (abe.m2321() <= 0) {
            return C0447yc.m8753((Set) obj);
        }
        return null;
    }

    public static String m12801() {
        if (C0453yj.m10032() > 0) {
            return adds.m2884(m12695(), 835, 22, 2004);
        }
        return null;
    }

    public static boolean m12802(Object obj, Object obj2) {
        if (C0448yd.m9074() <= 0) {
            return C0460zg.m11402((C0315lc) obj, (C0294ki) obj2);
        }
        return false;
    }

    public static EnumC0282jx m12803() {
        if (C0457zc.m10555() > 0) {
            return adds.m2670();
        }
        return null;
    }

    public static long m12804(Object obj) {
        if (m12696() > 0) {
            return abc.m1793((C0290ke) obj);
        }
        return 0L;
    }

    public static InterfaceC0428pg m12805(Object obj) {
        if (C0447yc.m8786() >= 0) {
            return abe.m2296((C0335lw) obj);
        }
        return null;
    }

    public static String m12806() {
        if (abe.m2321() < 0) {
            return C0456zb.m10478(m12695(), 857, 23, 2076);
        }
        return null;
    }

    public static void m12807(Object obj) {
        if (C0445ya.m8330() > 0) {
            abc.m1975((C0152fb) obj);
        }
    }

    public static int m12808(int i) {
        if (C0459zf.m11053() >= 0) {
            return C0447yc.m8821(i);
        }
        return 0;
    }
}
