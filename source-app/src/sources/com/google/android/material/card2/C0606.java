package com.google.android.material.card2;

import android.content.Context;
import android.content.res.Resources;
import android.os.Looper;
import android.view.View;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.lang.reflect.Field;
import java.lang.reflect.GenericArrayType;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Type;
import java.math.BigDecimal;
import java.net.Proxy;
import java.nio.ByteBuffer;
import java.util.Collection;
import java.util.Date;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.zip.Inflater;
import javax.crypto.Cipher;
import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.SSLSession;
import javax.net.ssl.SSLSocket;

public class C0606 {

    private static final short[] f1463short = {1862, 1917, 1895, 1910, 1889, 1918, 1914, 1917, 1906, 1895, 1910, 1911, 1843, 1910, 1888, 1904, 1906, 1891, 1910, 1843, 1888, 1910, 1890, 1894, 1910, 1917, 1904, 1910, 1523, 1476, 1490, 1489, 1486, 1487, 1490, 1476, 1409, 1506, 1486, 1477, 1476, 1435, 1409, 536, 512, 543, 531, 521, 527, 520, 516, 521, 531, 521, 527, 520, 543, 525, 531, 539, 517, 536, 516, 531, 514, 537, 512, 512, 531, 543, 516, 525, 2054, 2078, 2049, 2061, 2070, 2074, 2071, 2061, 2070, 2049, 2049, 2061, 2053, 2075, 2054, 2074, 2061, 2067, 2071, 2049, 2061, 2147, 2144, 2154, 2061, 2069, 2065, 2079, 2061, 2049, 2074, 2067, 2144, 2151, 2148, 1317, 1315, 1313, 1241, 1241, 1242, 1179, 1213, 1194, 1196, 1201, 1214, 1201, 1211, 1209, 1196, 1213, 1272, 1211, 1200, 1209, 1201, 1206, 1272, 1196, 1207, 1207, 1272, 1204, 1207, 1206, 1215, 1250, 1272, 2223, 2228, 2300, 2272, 2272, 2276, 2299, 2298, 2296, 2285, 1377, 1671, 1670, 1679, 1670, 1687, 1670, 2093, 2088, 2088, 2110, 2089, 2111, 2111, 2156, 2161, 2161, 2156, 2082, 2105, 2080, 2080, 704, 705, 707, 726, 642, 710, 713, 642, 716, 718, 716, 711, 714, 715, 643, 655, 2111, 2087, 2104, 2100, 2094, 2088, 2095, 2083, 2100, 2094, 2088, 2095, 2104, 2090, 2100, 2108, 2082, 2111, 2083, 2100, 2090, 2094, 2104, 2100, 2138, 2137, 2131, 2100, 2088, 2089, 2088, 2100, 2104, 2083, 2090, 2137, 2142, 2141, 871, 890, 890, 871, 809, 818, 811, 811, 2147, 2145, 2145, 2151, 2162, 2166, 2095, 2158, 2147, 2156, 2149, 2167, 2147, 2149, 2151, 1999, 2000, 2004, 1993, 1999, 1998, 2003, 1740, 2836, 2835, 2825, 2840, 2831, 2831, 2824, 2829, 2825, 2840, 2841, 1645, 1635, 1663, 1574, 1595, 1595, 1574, 1640, 1651, 1642, 1642, 796, 775, 842, 838, 863, 778, 838, 832, 834, 794, 791, 1105, 1118, 1115, 1111, 1116, 1094, 1042, 1089, 1094, 1088, 1111, 1107, 1119, 1089, 1042, 1089, 1114, 1117, 1095, 1118, 1110, 1116, 1045, 1094, 1042, 1114, 1107, 1092, 1111, 1042, 1107, 1089, 1089, 1117, 1105, 1115, 1107, 1094, 1111, 1110, 1042, 1089, 1094, 1088, 1111, 1107, 1119, 1042, 1147, 1142, 1089, 309, 289, 292, 341, 341, 338, 340, 625, 617, 630, 634, 629, 630, 622, 634, 626, 620, 625, 621, 634, 534, 609, 608, 630, 634, 608, 609, 608, 634, 614, 615, 614, 634, 630, 621, 612, 792, 783, 793, 794, 773, 772, 793, 783, 836, 776, 773, 782, 787, 834, 835, 836, 777, 774, 773, 793, 783, 834, 835, 3162, 3081, 3092, 3092, 3081, 3143, 3164, 3141, 3141, 2668, 2622, 2665, 2665, 2622, 2679, 2679, 2596, 2661, 2380, 2411, 2419, 2404, 2409, 2412, 2401, 2341, 2404, 2417, 2417, 2400, 2408, 2421, 2417, 2341, 2417, 2410, 2341, 2407, 2412, 2411, 2401, 2341, 2404, 2411, 2341, 2412, 2411, 2422, 2417, 2404, 2411, 2406, 2400, 2341, 2410, 2403, 2341, 1897, 1824, 1850, 1897, 1831, 1830, 1853, 1897, 1832, 1897, 1855, 1832, 1829, 1824, 1837, 1897, 1837, 1830, 1852, 1835, 1829, 1836, 1897, 1855, 1832, 1829, 1852, 1836, 1897, 1832, 1850, 1897, 1849, 1836, 1851, 1897, 1795, 1818, 1798, 1799, 1897, 1850, 1849, 1836, 1834, 1824, 1839, 1824, 1834, 1832, 1853, 1824, 1830, 1831, 1895, 1897, 1821, 1830, 1897, 1830, 1855, 1836, 1851, 1851, 1824, 1837, 1836, 1897, 1853, 1825, 1824, 1850, 1897, 1835, 1836, 1825, 1832, 1855, 1824, 1830, 1851, 1893, 1897, 1852, 1850, 1836, 1897, 1806, 1850, 1830, 1831, 1803, 1852, 1824, 1829, 1837, 1836, 1851, 1895, 1850, 1836, 1851, 1824, 1832, 1829, 1824, 1843, 1836, 1818, 1849, 1836, 1834, 1824, 1832, 1829, 1807, 1829, 1830, 1832, 1853, 1824, 1831, 1838, 1817, 1830, 1824, 1831, 1853, 1823, 1832, 1829, 1852, 1836, 1850, 1889, 1888, 1897, 1828, 1836, 1853, 1825, 1830, 1837, 1895, 1612, 1641, 1641, 1663, 1640, 1662, 1662, 1654, 2878, 2853, 2853, 2863, 2853, 2853, 1906, 1918, 1916, 1889, 1891, 1908, 1890, 1890, 1908, 1909, 1480, 1488, 1487, 1475, 1495, 1486, 1502, 1449, 1475, 1483, 1493, 1480, 1492, 1475, 1455, 1496, 1497, 1487, 1475, 1497, 1496, 1497, 1475, 1503, 1502, 1503, 1475, 1489, 1496, 1449, 515, 516, 526, 527, 530, 586, 599, 599, 586, 602, 2112, 2124, 2119, 2118, 2051, 2079, 2051, 2067, 2073, 2051, 2573, 2597, 2623, 2604, 2611, 2667, 2662, 2571, 2329, 2006, 2037, 2043, 2046, 2047, 2046, 1978, 2040, 2035, 2030, 2039, 2043, 2026, 1978, 1970, 1983, 2046, 2018, 1983, 2046, 1971, 1972, 2872, 2872, 2872, 2897, 2841, 2841, 2896, 2864, 2864, 2864, 2896, 2820, 2820, 2909, 2869, 2869, 2887, 2832, 2832, 2887, 2830, 2830, 2909, 2823, 1150, 1125, 1134, 1139, 1147, 1134, 1128, 1151, 1134, 1135, 1067, 1123, 1124, 1144, 1151, 1073, 1067, 2015, 2013, 1990, 2009, 1998, 2011, 1994, 2372, 2379, 2304, 2368, 2380, 2393, 2382, 2373, 503, 503, 488, 507, 502, 503, 485, 507, 499, 493, 496, 492, 507, 480, 481, 503, 507, 487, 486, 487, 507, 503, 492, 485, 1207, 1184, 1205, 1193, 1212, 1253, 1191, 1184, 1187, 1194, 1207, 1184, 1253, 1207, 1184, 1204, 1200, 1184, 1206, 1201, 1196, 1195, 1186, 1253, 1201, 1197, 1184, 1253, 1206, 1196, 1195, 1198, 619, 608, 625, 626, 618, 631, 622, 599, 608, 630, 629, 618, 619, 630, 608, 2991, 2989, 2992, 2987, 2992, 3004, 2992, 2995, 2976, 3002, 2989, 2989, 2992, 2989, 3039, 2988, 3002, 2987, 2987, 2998, 2993, 3000, 2988, 2976, 2994, 3006, 2983, 2976, 3001, 2989, 3006, 2994, 3002, 2976, 2988, 2998, 2981, 3002, 3013, 3039, 3034, 2956};

    public static int f1464 = -77;

    public static int m12809() {
        if (C0449ye.m9220() <= 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static short[] m12810() {
        if (C0457zc.m10735() <= 0) {
            return f1463short;
        }
        return null;
    }

    public static int m12811(Object obj, int i, int i2, Object obj2) {
        if (C0453yj.m9945() <= 0) {
            return C0453yj.m10035((String) obj, i, i2, (String) obj2);
        }
        return 0;
    }

    public static boolean m12812(Object obj) {
        if (C0458ze.m10926() <= 0) {
            return C0461zs.m11533((Class) obj);
        }
        return false;
    }

    public static void m12813(Object obj) {
        if (C0458ze.m10926() <= 0) {
            adds.m2718((AbstractC0292kg) obj);
        }
    }

    public static EnumC0154fd m12814() {
        if (C0457zc.m10555() > 0) {
            return abd.m2022();
        }
        return null;
    }

    public static GenericArrayType m12815(Object obj) {
        if (C0457zc.m10718() <= 0) {
            return C0452yh.m9587((Type) obj);
        }
        return null;
    }

    public static boolean m12816(Object obj) {
        if (C0453yj.m9945() < 0) {
            return C0452yh.m9787((C0155fe) obj);
        }
        return false;
    }

    public static InterfaceC0240ii m12817(Object obj) {
        if (C0445ya.m8330() > 0) {
            return C0446yb.m8538((C0239ih) obj);
        }
        return null;
    }

    public static InterfaceC0428pg m12818(Object obj, Object obj2) {
        if (m12809() > 0) {
            return C0447yc.m8632((C0404oj) obj, (InterfaceC0428pg) obj2);
        }
        return null;
    }

    public static InvocationHandler m12819(Object obj) {
        if (C0453yj.m9996() <= 0) {
            return C0450yf.m9372(obj);
        }
        return null;
    }

    public static Collection m12820(Object obj) {
        if (abd.m2166() <= 0) {
            return C0447yc.m8834((Map) obj);
        }
        return null;
    }

    public static String m12821() {
        if (C0459zf.m11053() >= 0) {
            return C0446yb.m8463(m12810(), 0, 28, 1811);
        }
        return null;
    }

    public static Float m12822(float f) {
        if (abd.m2166() < 0) {
            return C0457zc.m10707(f);
        }
        return null;
    }

    public static String m12823() {
        if (C0447yc.m8786() >= 0) {
            return C0457zc.m10560(m12810(), 28, 15, 1441);
        }
        return null;
    }

    public static String m12824() {
        if (C0448yd.m9074() <= 0) {
            return C0446yb.m8463(m12810(), 43, 29, 588);
        }
        return null;
    }

    public static String m12825() {
        if (C0453yj.m9966() >= 0) {
            return C0446yb.m8463(m12810(), 72, 35, 2130);
        }
        return null;
    }

    public static String m12826() {
        if (abf.m2500() >= 0) {
            return C0450yf.m9476(m12810(), 107, 3, 1348);
        }
        return null;
    }

    public static int m12827() {
        return 1752586 ^ C0455za.m10081(C0460zg.m11422(m12810(), 110, 3, 572));
    }

    public static C0274jp m12828(Object obj, Object obj2, Object obj3) {
        if (m12809() > 0) {
            return C0453yj.m9901((C0274jp) obj, (String) obj2, (String) obj3);
        }
        return null;
    }

    public static InterfaceC0024aj m12829(Object obj, Object obj2, Object obj3) {
        if (gggy.m4365() >= 0) {
            return abe.m2361((Class) obj, (Class) obj2, (AbstractC0022ah) obj3);
        }
        return null;
    }

    public static String m12830() {
        if (C0453yj.m9996() < 0) {
            return abe.m2412(m12810(), 113, 28, 1240);
        }
        return null;
    }

    public static C0430pi m12831(Object obj, long j, Object obj2) {
        if (C0453yj.m9996() < 0) {
            return C0446yb.m8451((C0430pi) obj, j, (TimeUnit) obj2);
        }
        return null;
    }

    public static long m12832(Object obj) {
        if (C0453yj.m10032() >= 0) {
            return C0453yj.m9948((BigDecimal) obj);
        }
        return 0L;
    }

    public static Number m12833(Object obj) {
        if (C0453yj.m9996() <= 0) {
            return C0450yf.m9521((C0015aa) obj);
        }
        return null;
    }

    public static String m12834() {
        if (C0456zb.m10484() < 0) {
            return C0456zb.m10478(m12810(), 141, 10, 2196);
        }
        return null;
    }

    public static String m12835() {
        if (C0445ya.m8330() > 0) {
            return C0455za.m10121(m12810(), 151, 1, 1341);
        }
        return null;
    }

    public static ExecutorService m12836(Object obj) {
        if (C0453yj.m9966() >= 0) {
            return C0448yd.m8914((C0261jc) obj);
        }
        return null;
    }

    public static String m12837() {
        if (C0448yd.m9074() <= 0) {
            return C0457zc.m10560(m12810(), 152, 6, 1731);
        }
        return null;
    }

    public static String m12838(Object obj) {
        if (C0453yj.m9945() < 0) {
            return C0456zb.m10396((C0152fb) obj);
        }
        return null;
    }

    public static String m12839() {
        if (C0457zc.m10555() >= 0) {
            return C0445ya.m8198(m12810(), 158, 15, 2124);
        }
        return null;
    }

    public static String m12840() {
        if (C0445ya.m8330() >= 0) {
            return C0446yb.m8463(m12810(), 173, 16, 687);
        }
        return null;
    }

    public static String m12841() {
        if (C0457zc.m10555() > 0) {
            return C0458ze.m10915(m12810(), 189, 38, 2155);
        }
        return null;
    }

    public static String m12842() {
        if (abf.m2500() >= 0) {
            return C0456zb.m10478(m12810(), 227, 8, 839);
        }
        return null;
    }

    public static void m12843(Object obj, Object obj2) {
        if (C0448yd.m9015() < 0) {
            C0447yc.m8607((SSLSocket) obj, (String[]) obj2);
        }
    }

    public static double m12844(Object obj) {
        if (abd.m2166() <= 0) {
            return C0461zs.m11588((InterfaceC0028an) obj);
        }
        return 0.0d;
    }

    public static String m12845() {
        if (C0459zf.m11053() >= 0) {
            return C0461zs.m11581(m12810(), 235, 15, 2050);
        }
        return null;
    }

    public static String m12846(Object obj) {
        if (C0458ze.m10926() < 0) {
            return abe.m2290((SSLSession) obj);
        }
        return null;
    }

    public static String m12847() {
        if (C0448yd.m9074() < 0) {
            return abe.m2412(m12810(), 250, 7, 1920);
        }
        return null;
    }

    public static String m12848() {
        if (C0445ya.m8330() >= 0) {
            return C0455za.m10121(m12810(), 257, 1, 1713);
        }
        return null;
    }

    public static String m12849() {
        if (C0448yd.m9074() <= 0) {
            return C0448yd.m9031(m12810(), 258, 11, 2941);
        }
        return null;
    }

    public static String m12850() {
        if (gggy.m4365() >= 0) {
            return C0460zg.m11422(m12810(), 269, 11, 1542);
        }
        return null;
    }

    public static void m12851(Object obj, Object obj2, Object obj3) {
        if (C0459zf.m11053() >= 0) {
            C0449ye.m9099((Thread.UncaughtExceptionHandler) obj, (Thread) obj2, (Throwable) obj3);
        }
    }

    public static boolean m12852(Object obj) {
        if (abe.m2321() <= 0) {
            return adds.m2799((Inflater) obj);
        }
        return false;
    }

    public static Proxy m12853(Object obj) {
        if (m12809() > 0) {
            return C0447yc.m8792((C0294ki) obj);
        }
        return null;
    }

    public static String m12854() {
        if (C0458ze.m10926() < 0) {
            return C0459zf.m11207(m12810(), 280, 11, 807);
        }
        return null;
    }

    public static String m12855(short[] sArr, int i, int i2, int i3) {
        char[] cArr = new char[i2];
        for (int i4 = 0; i4 < i2; i4++) {
            cArr[i4] = (char) (sArr[i + i4] ^ i3);
        }
        return new String(cArr);
    }

    public static boolean m12856(Object obj, Object obj2) {
        if (C0457zc.m10555() >= 0) {
            return C0453yj.m9891((Method) obj, obj2);
        }
        return false;
    }

    public static C0291kf m12857(Object obj, Object obj2, Object obj3) {
        if (gggy.m4365() > 0) {
            return C0446yb.m8581((C0291kf) obj, (String) obj2, (String) obj3);
        }
        return null;
    }

    public static long m12858(Object obj, Object obj2, long j) {
        if (C0456zb.m10484() <= 0) {
            return C0445ya.m8239((C0409oo) obj, (C0409oo) obj2, j);
        }
        return 0L;
    }

    public static String m12859() {
        if (C0459zf.m11053() >= 0) {
            return abc.m1781(m12810(), 291, 51, 1074);
        }
        return null;
    }

    public static void m12860(Object obj) {
        if (m12809() >= 0) {
            abd.m2189((C0409oo) obj);
        }
    }

    public static InterfaceC0428pg m12861(Object obj) {
        if (C0458ze.m10926() < 0) {
            return C0449ye.m9224((InterfaceC0304ks) obj);
        }
        return null;
    }

    public static short m12862(Object obj) {
        if (C0453yj.m9945() <= 0) {
            return C0455za.m10253((C0409oo) obj);
        }
        return (short) 0;
    }

    public static String m12863() {
        if (C0448yd.m9074() <= 0) {
            return C0446yb.m8463(m12810(), 342, 7, 359);
        }
        return null;
    }

    public static String m12864() {
        if (abd.m2021() > 0) {
            return adds.m2884(m12810(), 349, 29, 549);
        }
        return null;
    }

    public static boolean m12865(Object obj, Object obj2, boolean z) {
        if (C0459zf.m11053() > 0) {
            return adds.m2707((C0052bj) obj, (Class) obj2, z);
        }
        return false;
    }

    public static boolean m12866(Object obj, long j, Object obj2) {
        if (C0457zc.m10555() >= 0) {
            return abf.m2493((InterfaceC0411oq) obj, j, (C0412or) obj2);
        }
        return false;
    }

    public static Set m12867(Object obj) {
        if (gggy.m4365() >= 0) {
            return C0445ya.m8332((C0271jm) obj);
        }
        return null;
    }

    public static EnumC0346mf m12868() {
        if (abe.m2321() <= 0) {
            return abe.m2261();
        }
        return null;
    }

    public static boolean m12869(Object obj, boolean z, int i, Object obj2, int i2, int i3) {
        if (C0456zb.m10484() < 0) {
            return C0447yc.m8708((String) obj, z, i, (String) obj2, i2, i3);
        }
        return false;
    }

    public static String m12870() {
        if (abd.m2021() >= 0) {
            return C0447yc.m8718(m12810(), 378, 23, 874);
        }
        return null;
    }

    public static String m12871() {
        if (C0456zb.m10484() < 0) {
            return abd.m2070(m12810(), 401, 9, 3113);
        }
        return null;
    }

    public static String m12872() {
        if (C0447yc.m8786() >= 0) {
            return C0456zb.m10478(m12810(), 410, 9, 2564);
        }
        return null;
    }

    public static String m12873() {
        if (C0460zg.m11293() > 0) {
            return C0455za.m10121(m12810(), 419, 39, 2309);
        }
        return null;
    }

    public static Cipher m12874(Object obj) {
        if (C0447yc.m8786() > 0) {
            return abc.m1894((String) obj);
        }
        return null;
    }

    public static String m12875() {
        if (abe.m2321() <= 0) {
            return C0457zc.m10560(m12810(), 458, 144, 1865);
        }
        return null;
    }

    public static Boolean m12876(boolean z) {
        if (m12809() >= 0) {
            return C0457zc.m10672(z);
        }
        return null;
    }

    public static Looper m12877() {
        if (C0453yj.m9945() <= 0) {
            return C0457zc.m10670();
        }
        return null;
    }

    public static C0430pi m12878(Object obj) {
        if (C0448yd.m9015() <= 0) {
            return C0450yf.m9334((C0430pi) obj);
        }
        return null;
    }

    public static int m12879(Object obj, Object obj2, Object obj3) {
        int iM10484 = C0456zb.m10484();
        if (iM10484 > 0) {
            return 0;
        }
        return iM10484;
    }

    public static void m12880(Object obj, Object obj2, Object obj3, double d, Object obj4, double d2) {
        if (C0453yj.m10032() >= 0) {
            C0452yh.m9718((C0222hr) obj, (View) obj2, (String) obj3, d, (String) obj4, d2);
        }
    }

    public static String m12881() {
        if (abd.m2166() <= 0) {
            return C0453yj.m9924(m12810(), 602, 8, 1549);
        }
        return null;
    }

    public static String m12882() {
        if (C0457zc.m10555() > 0) {
            return C0458ze.m10959();
        }
        return null;
    }

    public static Resources m12883(Object obj) {
        if (abf.m2500() >= 0) {
            return gggy.m4284((Context) obj);
        }
        return null;
    }

    public static boolean m12884(Object obj) {
        if (C0445ya.m8330() > 0) {
            return adds.m2885((C0318lf) obj);
        }
        return false;
    }

    public static String m12885() {
        if (C0448yd.m9015() < 0) {
            return abf.m2527(m12810(), 610, 6, 2837);
        }
        return null;
    }

    public static Long m12886(long j) {
        if (C0459zf.m11053() > 0) {
            return abd.m2147(j);
        }
        return null;
    }

    public static String m12887(String str) {
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

    public static int m12888(Object obj) {
        if (C0460zg.m11293() > 0) {
            return C0449ye.m9127((EnumC0346mf) obj);
        }
        return 0;
    }

    public static C0273jo m12889(Object obj) {
        if (C0456zb.m10484() <= 0) {
            return C0446yb.m8406((C0286ka) obj);
        }
        return null;
    }

    public static String m12890() {
        if (C0453yj.m9996() < 0) {
            return C0450yf.m9476(m12810(), 616, 10, 1841);
        }
        return null;
    }

    public static String m12891() {
        if (C0459zf.m11053() > 0) {
            return abc.m1781(m12810(), 626, 30, 1436);
        }
        return null;
    }

    public static C0278jt m12892(Object obj) {
        if (abd.m2166() <= 0) {
            return C0450yf.m9415((String) obj);
        }
        return null;
    }

    public static int m12893(Object obj, Object obj2) {
        if (C0453yj.m10032() >= 0) {
            return C0450yf.m9340((C0409oo) obj, (ByteBuffer) obj2);
        }
        return 0;
    }

    public static void m12894(Object obj, long j) {
        if (abd.m2021() >= 0) {
            C0457zc.m10645((Context) obj, j);
        }
    }

    public static String m12895() {
        if (C0459zf.m11053() >= 0) {
            return C0461zs.m11581(m12810(), 656, 10, 618);
        }
        return null;
    }

    public static void m12896(Object obj, Object obj2, Object obj3) {
        if (C0448yd.m9074() < 0) {
            C0448yd.m8871((Field) obj, obj2, obj3);
        }
    }

    public static String m12897() {
        if (C0453yj.m9966() > 0) {
            return abe.m2412(m12810(), 666, 10, 2083);
        }
        return null;
    }

    public static String m12898() {
        if (C0459zf.m11053() > 0) {
            return C0460zg.m11422(m12810(), 676, 8, 2646);
        }
        return null;
    }

    public static HostnameVerifier m12899(Object obj) {
        if (C0456zb.m10484() <= 0) {
            return gggy.m4477((C0239ih) obj);
        }
        return null;
    }

    public static String m12900() {
        if (C0460zg.m11293() >= 0) {
            return C0453yj.m9924(m12810(), 684, 1, 2340);
        }
        return null;
    }

    public static String m12901(int i) {
        if (abf.m2500() >= 0) {
            return C0460zg.m11384(i);
        }
        return null;
    }

    public static String m12902() {
        if (gggy.m4365() >= 0) {
            return C0445ya.m8198(m12810(), 685, 22, 1946);
        }
        return null;
    }

    public static C0319lg m12903(Object obj) {
        if (C0457zc.m10718() < 0) {
            return C0449ye.m9225((C0329lq) obj);
        }
        return null;
    }

    public static String m12904() {
        if (C0457zc.m10718() < 0) {
            return C0452yh.m9820(m12810(), 707, 24, 2941);
        }
        return null;
    }

    public static String m12905(Object obj) {
        if (C0460zg.m11293() > 0) {
            return abe.m2236((IOException) obj);
        }
        return null;
    }

    public static void m12906(Object obj, int i, int i2, Object obj2) {
        if (C0457zc.m10718() < 0) {
            adds.m2753((Object[]) obj, i, i2, obj2);
        }
    }

    public static boolean m12907(Object obj, Object obj2) {
        if (gggy.m4365() >= 0) {
            return C0460zg.m11253((Type) obj, (Type) obj2);
        }
        return false;
    }

    public static ByteBuffer m12908(Object obj) {
        if (C0448yd.m9015() < 0) {
            return abf.m2432((byte[]) obj);
        }
        return null;
    }

    public static String m12909() {
        if (C0448yd.m9074() <= 0) {
            return C0448yd.m9031(m12810(), 731, 17, 1035);
        }
        return null;
    }

    public static String m12910() {
        if (gggy.m4365() >= 0) {
            return C0450yf.m9476(m12810(), 748, 7, 1967);
        }
        return null;
    }

    public static Matcher m12911(Object obj, Object obj2) {
        if (C0448yd.m9074() < 0) {
            return C0458ze.m10780((Pattern) obj, (CharSequence) obj2);
        }
        return null;
    }

    public static String m12912() {
        if (C0448yd.m9074() < 0) {
            return C0455za.m10121(m12810(), 755, 8, 2349);
        }
        return null;
    }

    public static String m12913() {
        if (abe.m2321() <= 0) {
            return C0460zg.m11422(m12810(), 763, 24, 420);
        }
        return null;
    }

    public static void m12914(Object obj, Object obj2, Object obj3) {
        if (C0448yd.m9074() < 0) {
            C0452yh.m9809((C0081cl) obj, (C0155fe) obj2, (Date) obj3);
        }
    }

    public static ByteBuffer m12915(Object obj, Object obj2, int i, int i2) {
        if (C0453yj.m9996() < 0) {
            return C0452yh.m9645((ByteBuffer) obj, (byte[]) obj2, i, i2);
        }
        return null;
    }

    public static InterfaceC0024aj m12916() {
        if (C0457zc.m10555() >= 0) {
            return C0448yd.m8993();
        }
        return null;
    }

    public static String m12917() {
        if (C0453yj.m9996() < 0) {
            return gggy.m4340(m12810(), 787, 32, 1221);
        }
        return null;
    }

    public static String m12918() {
        if (abf.m2500() >= 0) {
            return C0452yh.m9820(m12810(), 819, 15, 517);
        }
        return null;
    }

    public static String m12919(Object obj) {
        if (abd.m2166() <= 0) {
            return adds.m2888((Exception) obj);
        }
        return null;
    }

    public static String m12920() {
        if (C0456zb.m10484() < 0) {
            return abf.m2527(m12810(), 834, 42, 3071);
        }
        return null;
    }
}
