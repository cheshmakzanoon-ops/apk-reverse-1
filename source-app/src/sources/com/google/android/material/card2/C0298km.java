package com.google.android.material.card2;

import java.io.Closeable;
import java.io.IOException;
import java.io.InterruptedIOException;
import java.net.InetAddress;
import java.net.Socket;
import java.net.UnknownHostException;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.TimeZone;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.TimeUnit;
import java.util.regex.Pattern;
import javax.annotation.Nullable;

public final class C0298km {

    public static final byte[] f886nU = new byte[0];

    public static final String[] f889nX = new String[0];

    public static final AbstractC0292kg f888nW = abd.m2068(null, C0446yb.m8601());

    public static final AbstractC0288kc f887nV = C0449ye.m9174(null, C0446yb.m8601());

    private static final C0412or f902ok = C0455za.m10126(abc.m1960());

    private static final C0412or f894oc = C0455za.m10126(C0459zf.m11139());

    private static final C0412or f896oe = C0455za.m10126(abe.m2258());

    private static final C0412or f898og = C0455za.m10126(abc.m1831());

    private static final C0412or f900oi = C0455za.m10126(adds.m2756());

    public static final Charset f901oj = C0457zc.m10654(C0461zs.m11549());

    public static final Charset f890nY = C0457zc.m10654(C0447yc.m8783());

    private static final Charset f893ob = C0457zc.m10654(C0447yc.m8703());

    private static final Charset f895od = C0457zc.m10654(C0446yb.m8572());

    private static final Charset f897of = C0457zc.m10654(adds.m2800());

    private static final Charset f899oh = C0457zc.m10654(abc.m1768());

    public static final TimeZone f892oa = m5754(C0461zs.m11649());

    public static final Comparator<String> f891nZ = new C0299kn();

    private static final Pattern f903ol = C0461zs.m11638(C0458ze.m10872());

    public static String m928S(String str) {
        if (!C0446yb.m8589(str, C0449ye.m9248())) {
            try {
                String strM9261 = C0449ye.m9261(abe.m2411(str), C0446yb.m8554());
                if (C0460zg.m11421(strM9261) || C0452yh.m9742(strM9261)) {
                    return null;
                }
                return strM9261;
            } catch (IllegalArgumentException e) {
                return null;
            }
        }
        InetAddress inetAddressM10490 = (C0458ze.m10811(str, C0450yf.m9426()) && C0459zf.m11107(str, C0450yf.m9561())) ? C0456zb.m10490(str, 1, gggy.m4397(str) - 1) : C0456zb.m10490(str, 0, gggy.m4397(str));
        if (inetAddressM10490 == null) {
            return null;
        }
        byte[] bArrM2365 = abe.m2365(inetAddressM10490);
        if (bArrM2365.length == 16) {
            return C0455za.m10184(bArrM2365);
        }
        throw new AssertionError(abc.m1925(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0458ze.m10919()), str), C0459zf.m11010())));
    }

    private static boolean m929T(String str) {
        for (int i = 0; i < gggy.m4397(str); i++) {
            char cM8419 = C0446yb.m8419(str, i);
            if (cM8419 > 31) {
                if (cM8419 >= 127) {
                    return true;
                }
                if (C0458ze.m10892(C0458ze.m10936(), cM8419) == -1) {
                }
            }
            return true;
        }
        return false;
    }

    public static int m930U(String str) {
        int i = 0;
        int iM4397 = gggy.m4397(str);
        while (i < iM4397) {
            char cM8419 = C0446yb.m8419(str, i);
            if (cM8419 <= 31 || cM8419 >= 127) {
                return i;
            }
            i++;
        }
        return -1;
    }

    public static boolean m931V(String str) {
        return C0447yc.m8825(C0458ze.m10828(C0447yc.m8654(), str));
    }

    public static int m932a(String str, int i, int i2, char c) {
        for (int i3 = i; i3 < i2; i3++) {
            if (C0446yb.m8419(str, i3) == c) {
                return i3;
            }
        }
        return i2;
    }

    public static int m933a(String str, int i, int i2, String str2) {
        for (int i3 = i; i3 < i2; i3++) {
            if (C0458ze.m10892(str2, C0446yb.m8419(str, i3)) != -1) {
                return i3;
            }
        }
        return i2;
    }

    public static int m934a(String str, long j, TimeUnit timeUnit) {
        if (j < 0) {
            throw new IllegalArgumentException(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), str), C0459zf.m10997())));
        }
        if (timeUnit == null) {
            throw new NullPointerException(C0457zc.m10572());
        }
        long jM2632 = abf.m2632(timeUnit, j);
        if (jM2632 > 2147483647L) {
            throw new IllegalArgumentException(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), str), C0455za.m10048())));
        }
        if (jM2632 != 0 || j <= 0) {
            return (int) jM2632;
        }
        throw new IllegalArgumentException(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), str), C0461zs.m11485())));
    }

    public static int m935a(Comparator<String> comparator, String[] strArr, String str) {
        int length = strArr.length;
        for (int i = 0; i < length; i++) {
            if (C0449ye.m9315(comparator, strArr[i], str) == 0) {
                return i;
            }
        }
        return -1;
    }

    public static AssertionError m936a(String str, Exception exc) {
        return (AssertionError) C0461zs.m11520(new AssertionError(str), exc);
    }

    public static String m937a(C0273jo c0273jo, boolean z) {
        String strM1925 = C0446yb.m8589(abe.m2260(c0273jo), C0449ye.m9248()) ? abc.m1925(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0450yf.m9426()), abe.m2260(c0273jo)), C0450yf.m9561())) : abe.m2260(c0273jo);
        return (z || C0457zc.m10643(c0273jo) != C0447yc.m8714(C0445ya.m8254(c0273jo))) ? abc.m1925(adds.m2680(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), strM1925), C0449ye.m9248()), C0457zc.m10643(c0273jo))) : strM1925;
    }

    private static String m938a(byte[] bArr) {
        int i = 0;
        int i2 = -1;
        int i3 = 0;
        int i4 = 0;
        while (i4 < bArr.length) {
            int i5 = i4;
            while (i5 < 16 && bArr[i5] == 0 && bArr[i5 + 1] == 0) {
                i5 += 2;
            }
            int i6 = i5 - i4;
            if (i6 > i3 && i6 >= 4) {
                i3 = i6;
                i2 = i4;
            }
            i4 = i5 + 2;
        }
        C0409oo c0409oo = new C0409oo();
        while (i < bArr.length) {
            if (i == i2) {
                C0447yc.m8844(c0409oo, 58);
                i += i3;
                if (i == 16) {
                    C0447yc.m8844(c0409oo, 58);
                }
            } else {
                if (i > 0) {
                    C0447yc.m8844(c0409oo, 58);
                }
                abf.m2564(c0409oo, ((bArr[i] & 255) << 8) | (bArr[i + 1] & 255));
                i += 2;
            }
        }
        return C0456zb.m10496(c0409oo);
    }

    public static Charset m939a(InterfaceC0411oq interfaceC0411oq, Charset charset) {
        if (gggy.m4489(interfaceC0411oq, 0L, abe.m2242())) {
            C0461zs.m11605(interfaceC0411oq, gggy.m4418(abe.m2242()));
            return abc.m1850();
        }
        if (gggy.m4489(interfaceC0411oq, 0L, abe.m2267())) {
            C0461zs.m11605(interfaceC0411oq, gggy.m4418(abe.m2267()));
            return C0445ya.m8379();
        }
        if (gggy.m4489(interfaceC0411oq, 0L, C0461zs.m11472())) {
            C0461zs.m11605(interfaceC0411oq, gggy.m4418(C0461zs.m11472()));
            return C0456zb.m10338();
        }
        if (gggy.m4489(interfaceC0411oq, 0L, abe.m2206())) {
            C0461zs.m11605(interfaceC0411oq, gggy.m4418(abe.m2206()));
            return abd.m2014();
        }
        if (!gggy.m4489(interfaceC0411oq, 0L, C0456zb.m10286())) {
            return charset;
        }
        C0461zs.m11605(interfaceC0411oq, gggy.m4418(C0456zb.m10286()));
        return C0459zf.m11033();
    }

    public static <T> List<T> m940a(List<T> list) {
        return abc.m1875(new ArrayList(list));
    }

    public static <T> List<T> m941a(T... tArr) {
        return abc.m1875(abf.m2488((Object[]) C0455za.m10271(tArr)));
    }

    public static void m942a(long j, long j2, long j3) {
        if ((j2 | j3) < 0 || j2 > j || j - j2 < j3) {
            throw new ArrayIndexOutOfBoundsException();
        }
    }

    public static void m943a(Closeable closeable) {
        if (closeable != null) {
            try {
                C0452yh.m9639(closeable);
            } catch (RuntimeException e) {
                throw e;
            } catch (Exception e2) {
            }
        }
    }

    public static void m944a(Socket socket) {
        if (socket != null) {
            try {
                C0456zb.m10350(socket);
            } catch (AssertionError e) {
                if (!C0456zb.m10287(e)) {
                    throw e;
                }
            } catch (RuntimeException e2) {
                throw e2;
            } catch (Exception e3) {
            }
        }
    }

    public static boolean m945a(InterfaceC0429ph interfaceC0429ph, int i, TimeUnit timeUnit) {
        try {
            return gggy.m4296(interfaceC0429ph, i, timeUnit);
        } catch (IOException e) {
            return false;
        }
    }

    public static boolean m946a(AssertionError assertionError) {
        return (m5757(assertionError) == null || C0453yj.m9832(assertionError) == null || !C0446yb.m8589(C0453yj.m9832(assertionError), abf.m2556())) ? false : true;
    }

    public static boolean m947a(Object obj, Object obj2) {
        return obj == obj2 || (obj != null && C0459zf.m11147(obj, obj2));
    }

    private static boolean m948a(String str, int i, int i2, byte[] bArr, int i3) {
        int i4 = i3;
        int i5 = i;
        while (i5 < i2) {
            if (i4 == bArr.length) {
                return false;
            }
            if (i4 != i3) {
                if (C0446yb.m8419(str, i5) != '.') {
                    return false;
                }
                i5++;
            }
            int i6 = 0;
            int i7 = i5;
            while (i7 < i2) {
                char cM8419 = C0446yb.m8419(str, i7);
                if (cM8419 < '0' || cM8419 > '9') {
                    break;
                }
                if ((i6 == 0 && i5 != i7) || (i6 = ((i6 * 10) + cM8419) - 48) > 255) {
                    return false;
                }
                i7++;
            }
            if (i7 - i5 == 0) {
                return false;
            }
            bArr[i4] = (byte) i6;
            i4++;
            i5 = i7;
        }
        return i4 == i3 + 4;
    }

    public static String[] m949a(Comparator<? super String> comparator, String[] strArr, String[] strArr2) {
        ArrayList arrayList = new ArrayList();
        for (String str : strArr) {
            for (String str2 : strArr2) {
                if (C0449ye.m9315(comparator, str, str2) == 0) {
                    C0460zg.m11251(arrayList, str);
                    break;
                }
            }
        }
        return (String[]) C0456zb.m10507(arrayList, new String[m5750(arrayList)]);
    }

    public static String m950b(String str, Object... objArr) {
        return C0450yf.m9572(C0446yb.m8554(), str, objArr);
    }

    public static ThreadFactory m951b(String str, boolean z) {
        return new ThreadFactoryC0300ko(str, z);
    }

    public static boolean m952b(InterfaceC0429ph interfaceC0429ph, int i, TimeUnit timeUnit) {
        long jM1830 = abc.m1830();
        long jM9631 = C0448yd.m9046(gggy.m4377(interfaceC0429ph)) ? C0452yh.m9631(gggy.m4377(interfaceC0429ph)) - jM1830 : Long.MAX_VALUE;
        C0448yd.m8901(gggy.m4377(interfaceC0429ph), C0450yf.m9495(jM9631, C0457zc.m10723(timeUnit, i)) + jM1830);
        try {
            C0409oo c0409oo = new C0409oo();
            while (abe.m2209(interfaceC0429ph, c0409oo, 8192L) != -1) {
                C0461zs.m11454(c0409oo);
            }
            if (jM9631 == Long.MAX_VALUE) {
                C0459zf.m11009(gggy.m4377(interfaceC0429ph));
            } else {
                C0448yd.m8901(gggy.m4377(interfaceC0429ph), jM9631 + jM1830);
            }
            return true;
        } catch (InterruptedIOException e) {
            if (jM9631 == Long.MAX_VALUE) {
                C0459zf.m11009(gggy.m4377(interfaceC0429ph));
            } else {
                C0448yd.m8901(gggy.m4377(interfaceC0429ph), jM9631 + jM1830);
            }
            return false;
        } catch (Throwable th) {
            if (jM9631 == Long.MAX_VALUE) {
                C0459zf.m11009(gggy.m4377(interfaceC0429ph));
            } else {
                C0448yd.m8901(gggy.m4377(interfaceC0429ph), jM9631 + jM1830);
            }
            throw th;
        }
    }

    public static boolean m953b(Comparator<String> comparator, String[] strArr, String[] strArr2) {
        if (strArr == null || strArr2 == null || strArr.length == 0 || strArr2.length == 0) {
            return false;
        }
        for (String str : strArr) {
            for (String str2 : strArr2) {
                if (C0449ye.m9315(comparator, str, str2) == 0) {
                    return true;
                }
            }
        }
        return false;
    }

    public static String[] m954b(String[] strArr, String str) {
        String[] strArr2 = new String[strArr.length + 1];
        adds.m2876(strArr, 0, strArr2, 0, strArr.length);
        strArr2[strArr2.length - 1] = str;
        return strArr2;
    }

    public static int m955d(char c) {
        if (c >= '0' && c <= '9') {
            return c - '0';
        }
        if (c >= 'a' && c <= 'f') {
            return (c - 'a') + 10;
        }
        if (c < 'A' || c > 'F') {
            return -1;
        }
        return (c - 'A') + 10;
    }

    @Nullable
    private static InetAddress m956j(String str, int i, int i2) {
        int i3;
        int i4;
        int i5;
        int i6;
        int iM9663;
        byte[] bArr = new byte[16];
        int i7 = -1;
        int i8 = i;
        int i9 = -1;
        int i10 = 0;
        while (true) {
            if (i8 >= i2) {
                i3 = i10;
                break;
            }
            if (i10 == bArr.length) {
                return null;
            }
            if (i8 + 2 <= i2 && C0457zc.m10624(str, i8, C0457zc.m10563(), 0, 2)) {
                if (i9 != -1) {
                    return null;
                }
                i7 = i8 + 2;
                int i11 = i10 + 2;
                if (i7 == i2) {
                    i9 = i11;
                    i3 = i11;
                    break;
                }
                i4 = i11;
                i9 = i11;
                i5 = 0;
                i8 = i7;
                while (i8 < i2) {
                    iM9663 = C0452yh.m9663(C0446yb.m8419(str, i8));
                    if (iM9663 == -1) {
                        break;
                        break;
                    }
                    i5 = (i5 << 4) + iM9663;
                    i8++;
                }
                i6 = i8 - i7;
                if (i6 != 0) {
                }
                return null;
            }
            if (i10 == 0) {
                i4 = i10;
                i7 = i8;
            } else {
                if (!C0457zc.m10624(str, i8, C0449ye.m9248(), 0, 1)) {
                    if (C0457zc.m10624(str, i8, C0452yh.m9669(), 0, 1) && abd.m2107(str, i7, i2, bArr, i10 - 2)) {
                        i3 = i10 + 2;
                        break;
                    }
                    return null;
                }
                i7 = i8 + 1;
                i4 = i10;
            }
            i5 = 0;
            i8 = i7;
            while (i8 < i2) {
                iM9663 = C0452yh.m9663(C0446yb.m8419(str, i8));
                if (iM9663 == -1) {
                    break;
                }
                i5 = (i5 << 4) + iM9663;
                i8++;
            }
            i6 = i8 - i7;
            if (i6 != 0 || i6 > 4) {
                return null;
            }
            int i12 = i4 + 1;
            bArr[i4] = (byte) ((i5 >>> 8) & 255);
            bArr[i12] = (byte) (i5 & 255);
            i10 = i12 + 1;
        }
        if (i3 != bArr.length) {
            if (i9 == -1) {
                return null;
            }
            adds.m2876(bArr, i9, bArr, bArr.length - (i3 - i9), i3 - i9);
            C0459zf.m11032(bArr, i9, (bArr.length - i3) + i9, (byte) 0);
        }
        try {
            return C0456zb.m10277(bArr);
        } catch (UnknownHostException e) {
            throw new AssertionError();
        }
    }

    public static int m957k(String str, int i, int i2) {
        for (int i3 = i; i3 < i2; i3++) {
            switch (C0446yb.m8419(str, i3)) {
                case '\t':
                case '\n':
                case '\f':
                case '\r':
                case ' ':
                    break;
                default:
                    return i3;
            }
        }
        return i2;
    }

    public static int m958l(String str, int i, int i2) {
        for (int i3 = i2 - 1; i3 >= i; i3--) {
            switch (C0446yb.m8419(str, i3)) {
                case '\t':
                case '\n':
                case '\f':
                case '\r':
                case ' ':
                    break;
                default:
                    return i3 + 1;
            }
        }
        return i;
    }

    public static String m959m(String str, int i, int i2) {
        int iM5761 = m5761(str, i, i2);
        return C0447yc.m8745(str, iM5761, C0447yc.m8627(str, iM5761, i2));
    }

    public static int m5750(Object obj) {
        if (C0451yg.m9580() > 0) {
            return C0598.m11824(obj);
        }
        return 0;
    }

    public static Pattern m5751() {
        if (C0449ye.m9220() <= 0) {
            return f903ol;
        }
        return null;
    }

    public static boolean m5752(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return m929T((String) obj);
        }
        return false;
    }

    public static int m5753() {
        if (C0460zg.m11287() >= 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static TimeZone m5754(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return C0598.m11796(obj);
        }
        return null;
    }

    public static Object m5755(Object obj) {
        if (C0447yc.m8635() > 0) {
            return ((Object[]) obj).clone();
        }
        return null;
    }

    public static Charset m5756() {
        if (adds.m2755() >= 0) {
            return f893ob;
        }
        return null;
    }

    public static Throwable m5757(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return C0598.m11897(obj);
        }
        return null;
    }

    public static C0412or m5758() {
        if (C0457zc.m10735() <= 0) {
            return f896oe;
        }
        return null;
    }

    public static C0412or m5759() {
        if (abe.m2308() <= 0) {
            return f894oc;
        }
        return null;
    }

    public static InetAddress m5760(Object obj, int i, int i2) {
        if (C0453yj.m10013() > 0) {
            return m956j((String) obj, i, i2);
        }
        return null;
    }

    public static int m5761(Object obj, int i, int i2) {
        if (C0453yj.m10013() >= 0) {
            return C0598.m11792(obj, i, i2);
        }
        return 0;
    }

    public static Charset m5762() {
        if (C0446yb.m8415() < 0) {
            return f895od;
        }
        return null;
    }

    public static boolean m5763(Object obj, int i, int i2, Object obj2, int i3) {
        if (C0447yc.m8635() > 0) {
            return m948a((String) obj, i, i2, (byte[]) obj2, i3);
        }
        return false;
    }

    public static C0412or m5764() {
        if (C0453yj.m10013() > 0) {
            return f900oi;
        }
        return null;
    }

    public static C0412or m5765() {
        if (abc.m1845() <= 0) {
            return f902ok;
        }
        return null;
    }

    public static C0412or m5766() {
        if (C0448yd.m9079() <= 0) {
            return f898og;
        }
        return null;
    }

    public static Charset m5767() {
        if (abe.m2308() <= 0) {
            return f897of;
        }
        return null;
    }

    public static Charset m5768() {
        if (gggy.m4269() <= 0) {
            return f899oh;
        }
        return null;
    }

    public static String m5769(Object obj) {
        if (C0447yc.m8635() > 0) {
            return m938a((byte[]) obj);
        }
        return null;
    }

    public static Charset m5770() {
        if (C0453yj.m9945() <= 0) {
            return m5762();
        }
        return null;
    }

    public static boolean m5771(Object obj, int i, int i2, Object obj2, int i3) {
        if (m5753() >= 0) {
            return m5763((String) obj, i, i2, (byte[]) obj2, i3);
        }
        return false;
    }

    public static C0412or m5772() {
        if (C0460zg.m11293() >= 0) {
            return m5766();
        }
        return null;
    }

    public static boolean m5773(Object obj) {
        if (C0448yd.m9015() < 0) {
            return m5752((String) obj);
        }
        return false;
    }

    public static String m5774(Object obj) {
        if (C0456zb.m10484() < 0) {
            return m5769((byte[]) obj);
        }
        return null;
    }

    public static Object m5775(Object obj) {
        if (C0453yj.m9966() >= 0) {
            return m5755((Object[]) obj);
        }
        return null;
    }

    public static Pattern m5776() {
        if (m5753() >= 0) {
            return m5751();
        }
        return null;
    }

    public static Charset m5777() {
        if (C0459zf.m11053() >= 0) {
            return m5767();
        }
        return null;
    }

    public static Charset m5778() {
        if (abf.m2500() > 0) {
            return m5756();
        }
        return null;
    }

    public static InetAddress m5779(Object obj, int i, int i2) {
        if (abd.m2166() <= 0) {
            return m5760((String) obj, i, i2);
        }
        return null;
    }

    public static Charset m5780() {
        if (C0457zc.m10718() < 0) {
            return m5768();
        }
        return null;
    }

    public static C0412or m5781() {
        if (C0453yj.m10032() > 0) {
            return m5765();
        }
        return null;
    }

    public static C0412or m5782() {
        if (C0456zb.m10484() < 0) {
            return m5759();
        }
        return null;
    }

    public static C0412or m5783() {
        if (C0457zc.m10718() <= 0) {
            return m5764();
        }
        return null;
    }

    public static C0412or m5784() {
        if (C0457zc.m10718() <= 0) {
            return m5758();
        }
        return null;
    }
}
