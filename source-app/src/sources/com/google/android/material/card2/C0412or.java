package com.google.android.material.card2;

import java.io.EOFException;
import java.io.InputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.lang.reflect.Field;
import java.nio.charset.Charset;
import java.security.NoSuchAlgorithmException;

public class C0412or implements Serializable, Comparable<C0412or> {
    private static final long serialVersionUID = 1;

    transient int f1304dV;

    final byte[] f1305vk;

    transient String f1306vl;

    static final char[] f1303vj = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};

    public static final C0412or f1302vi = C0449ye.m9278(new byte[0]);

    C0412or(byte[] bArr) {
        this.f1305vk = bArr;
    }

    public static C0412or m1399a(InputStream inputStream, int i) throws EOFException {
        if (inputStream == null) {
            throw new IllegalArgumentException(adds.m2731());
        }
        if (i < 0) {
            throw new IllegalArgumentException(abc.m1925(adds.m2680(C0460zg.m11407(new StringBuilder(), adds.m2831()), i)));
        }
        byte[] bArr = new byte[i];
        int i2 = 0;
        while (i2 < i) {
            int iM10347 = C0456zb.m10347(inputStream, bArr, i2, i - i2);
            if (iM10347 == -1) {
                throw new EOFException();
            }
            i2 += iM10347;
        }
        return new C0412or(bArr);
    }

    public static C0412or m1400ao(String str) {
        if (str == null) {
            throw new IllegalArgumentException(C0445ya.m8396());
        }
        if (gggy.m4397(str) % 2 != 0) {
            throw new IllegalArgumentException(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0447yc.m8722()), str)));
        }
        byte[] bArr = new byte[gggy.m4397(str) / 2];
        for (int i = 0; i < bArr.length; i++) {
            bArr[i] = (byte) ((C0458ze.m10874(C0446yb.m8419(str, i * 2)) << 4) + C0458ze.m10874(C0446yb.m8419(str, (i * 2) + 1)));
        }
        return C0449ye.m9278(bArr);
    }

    private C0412or m1401ap(String str) {
        try {
            return C0449ye.m9278(m7827(C0461zs.m11636(str), C0457zc.m10571(this)));
        } catch (NoSuchAlgorithmException e) {
            throw new AssertionError(e);
        }
    }

    public static C0412or m1402aq(String str) {
        if (str == null) {
            throw new IllegalArgumentException(abe.m2203());
        }
        C0412or c0412or = new C0412or(C0457zc.m10721(str, C0447yc.m8619()));
        c0412or.f1306vl = str;
        return c0412or;
    }

    private static int m1403d(char c) {
        if (c >= '0' && c <= '9') {
            return c - '0';
        }
        if (c >= 'a' && c <= 'f') {
            return (c - 'a') + 10;
        }
        if (c < 'A' || c > 'F') {
            throw new IllegalArgumentException(abc.m1925(abe.m2346(C0460zg.m11407(new StringBuilder(), C0448yd.m9040()), c)));
        }
        return (c - 'A') + 10;
    }

    static int m1404e(String str, int i) {
        int iM4397 = gggy.m4397(str);
        int i2 = 0;
        int iM1937 = 0;
        while (iM1937 < iM4397) {
            if (i2 == i) {
                return iM1937;
            }
            int iM10816 = C0458ze.m10816(str, iM1937);
            if ((abe.m2212(iM10816) && iM10816 != 10 && iM10816 != 13) || iM10816 == 65533) {
                return -1;
            }
            i2++;
            iM1937 += abc.m1937(iM10816);
        }
        return gggy.m4397(str);
    }

    public static C0412or m1405g(byte... bArr) {
        if (bArr == null) {
            throw new IllegalArgumentException(C0456zb.m10499());
        }
        return new C0412or((byte[]) adds.m2726(bArr));
    }

    private void readObject(ObjectInputStream objectInputStream) {
        C0412or c0412orM8240 = C0445ya.m8240(objectInputStream, C0453yj.m10002(objectInputStream));
        try {
            Field fieldM11530 = C0461zs.m11530(C0412or.class, C0459zf.m11199());
            abc.m1817(fieldM11530, true);
            C0449ye.m9215(fieldM11530, this, C0457zc.m10571(c0412orM8240));
        } catch (IllegalAccessException e) {
            throw new AssertionError();
        } catch (NoSuchFieldException e2) {
            throw new AssertionError();
        }
    }

    private void writeObject(ObjectOutputStream objectOutputStream) {
        C0445ya.m8341(objectOutputStream, C0457zc.m10571(this).length);
        C0446yb.m8556(objectOutputStream, C0457zc.m10571(this));
    }

    public static C0412or m7821(Object obj, Object obj2) {
        if (abe.m2308() < 0) {
            return ((C0412or) obj).m1401ap((String) obj2);
        }
        return null;
    }

    public static int m7822(Object obj) {
        if (C0447yc.m8635() > 0) {
            return ((C0412or) obj).f1304dV;
        }
        return 0;
    }

    public static int m7823(Object obj, int i) {
        if (adds.m2755() > 0) {
            return m1404e((String) obj, i);
        }
        return 0;
    }

    public static Object m7824(Object obj) {
        if (C0461zs.m11510() < 0) {
            return ((byte[]) obj).clone();
        }
        return null;
    }

    public static char[] m7825() {
        if (C0450yf.m9352() < 0) {
            return f1303vj;
        }
        return null;
    }

    public static int m7826(char c) {
        if (adds.m2755() > 0) {
            return m1403d(c);
        }
        return 0;
    }

    public static byte[] m7827(Object obj, Object obj2) {
        if (C0449ye.m9220() < 0) {
            return C0598.m11815(obj, obj2);
        }
        return null;
    }

    public static boolean m7828(Object obj, int i, Object obj2, int i2, int i3) {
        if (C0453yj.m10013() > 0) {
            return C0432pk.m1464a((byte[]) obj, i, (byte[]) obj2, i2, i3);
        }
        return false;
    }

    public static String m7829(Object obj) {
        if (C0452yh.m9798() > 0) {
            return C0408on.m1339c((byte[]) obj);
        }
        return null;
    }

    public static byte[] m7830(Object obj) {
        if (C0452yh.m9798() >= 0) {
            return ((C0412or) obj).f1305vk;
        }
        return null;
    }

    public static String m7831(Object obj) {
        if (C0453yj.m10013() > 0) {
            return ((C0412or) obj).f1306vl;
        }
        return null;
    }

    public static Charset m7832() {
        if (C0449ye.m9220() <= 0) {
            return C0432pk.f1347vT;
        }
        return null;
    }

    public static Charset m7833() {
        if (abd.m2021() > 0) {
            return m7832();
        }
        return null;
    }

    public static byte[] m7834(Object obj) {
        if (abd.m2021() >= 0) {
            return m7830((C0412or) obj);
        }
        return null;
    }

    public static String m7835(Object obj) {
        if (C0459zf.m11053() >= 0) {
            return m7829((byte[]) obj);
        }
        return null;
    }

    public static C0412or m7836(Object obj, Object obj2) {
        if (C0460zg.m11293() >= 0) {
            return m7821((C0412or) obj, (String) obj2);
        }
        return null;
    }

    public static int m7837(Object obj, int i) {
        if (C0457zc.m10718() <= 0) {
            return m7823((String) obj, i);
        }
        return 0;
    }

    public static int m7838(Object obj) {
        if (C0459zf.m11053() > 0) {
            return m7822((C0412or) obj);
        }
        return 0;
    }

    public static boolean m7839(Object obj, int i, Object obj2, int i2, int i3) {
        if (abe.m2321() <= 0) {
            return m7828((byte[]) obj, i, (byte[]) obj2, i2, i3);
        }
        return false;
    }

    public static Object m7840(Object obj) {
        if (C0460zg.m11293() > 0) {
            return m7824((byte[]) obj);
        }
        return null;
    }

    public static String m7841(Object obj) {
        if (C0445ya.m8330() > 0) {
            return m7831((C0412or) obj);
        }
        return null;
    }

    public static int m7842(char c) {
        if (C0453yj.m9945() <= 0) {
            return m7826(c);
        }
        return 0;
    }

    public static char[] m7843() {
        if (C0459zf.m11053() > 0) {
            return m7825();
        }
        return null;
    }

    public byte mo1406L(int i) {
        return C0457zc.m10571(this)[i];
    }

    void mo1407a(C0409oo c0409oo) {
        abf.m2562(c0409oo, C0457zc.m10571(this), 0, C0457zc.m10571(this).length);
    }

    public boolean mo1408a(int i, C0412or c0412or, int i2, int i3) {
        return C0450yf.m9393(c0412or, i2, C0457zc.m10571(this), i, i3);
    }

    public boolean mo1409a(int i, byte[] bArr, int i2, int i3) {
        return i >= 0 && i <= C0457zc.m10571(this).length - i3 && i2 >= 0 && i2 <= bArr.length - i3 && C0460zg.m11389(C0457zc.m10571(this), i, bArr, i2, i3);
    }

    @Override
    public int compareTo(C0412or c0412or) {
        return C0445ya.m8356(this, c0412or);
    }

    public int m1410e(C0412or c0412or) {
        int iM4418 = gggy.m4418(this);
        int iM4419 = gggy.m4418(c0412or);
        int iM10520 = C0456zb.m10520(iM4418, iM4419);
        for (int i = 0; i < iM10520; i++) {
            int iM8829 = C0447yc.m8829(this, i) & 255;
            int iM88210 = C0447yc.m8829(c0412or, i) & 255;
            if (iM8829 != iM88210) {
                return iM8829 < iM88210 ? -1 : 1;
            }
        }
        if (iM4418 == iM4419) {
            return 0;
        }
        return iM4418 >= iM4419 ? 1 : -1;
    }

    public C0412or mo1411e(int i, int i2) {
        if (i < 0) {
            throw new IllegalArgumentException(C0450yf.m9430());
        }
        if (i2 > C0457zc.m10571(this).length) {
            throw new IllegalArgumentException(abc.m1925(C0460zg.m11407(adds.m2680(C0460zg.m11407(new StringBuilder(), C0460zg.m11280()), C0457zc.m10571(this).length), C0457zc.m10722())));
        }
        int i3 = i2 - i;
        if (i3 < 0) {
            throw new IllegalArgumentException(C0448yd.m9048());
        }
        if (i == 0 && i2 == C0457zc.m10571(this).length) {
            return this;
        }
        byte[] bArr = new byte[i3];
        adds.m2876(C0457zc.m10571(this), i, bArr, 0, i3);
        return new C0412or(bArr);
    }

    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        }
        return (obj instanceof C0412or) && gggy.m4418((C0412or) obj) == C0457zc.m10571(this).length && C0450yf.m9393((C0412or) obj, 0, C0457zc.m10571(this), 0, C0457zc.m10571(this).length);
    }

    public final boolean m1412f(C0412or c0412or) {
        return abe.m2331(this, 0, c0412or, 0, gggy.m4418(c0412or));
    }

    public String mo1413fM() {
        return C0456zb.m10333(C0457zc.m10571(this));
    }

    public String mo1414fN() {
        char[] cArr = new char[C0457zc.m10571(this).length * 2];
        int i = 0;
        for (byte b : C0457zc.m10571(this)) {
            int i2 = i + 1;
            cArr[i] = C0450yf.m9545()[(b >> 4) & 15];
            i = i2 + 1;
            cArr[i2] = C0450yf.m9545()[b & 15];
        }
        return new String(cArr);
    }

    public C0412or mo1415fO() {
        return C0455za.m10199(this, C0445ya.m8310());
    }

    public C0412or mo1416fP() {
        return C0455za.m10199(this, C0447yc.m8705());
    }

    public C0412or mo1417fQ() {
        int i = 0;
        while (true) {
            int i2 = i;
            if (i2 >= C0457zc.m10571(this).length) {
                return this;
            }
            byte b = C0457zc.m10571(this)[i2];
            if (b < 65 || b > 90) {
                i = i2 + 1;
            } else {
                byte[] bArr = (byte[]) adds.m2726(C0457zc.m10571(this));
                bArr[i2] = (byte) (b + 32);
                while (true) {
                    i2++;
                    if (i2 >= bArr.length) {
                        return new C0412or(bArr);
                    }
                    byte b2 = bArr[i2];
                    if (b2 >= 65 && b2 <= 90) {
                        bArr[i2] = (byte) (b2 + 32);
                    }
                }
            }
        }
    }

    public byte[] mo1418fR() {
        return (byte[]) adds.m2726(C0457zc.m10571(this));
    }

    public String mo1419fS() {
        String strM11590 = C0461zs.m11590(this);
        if (strM11590 != null) {
            return strM11590;
        }
        String str = new String(C0457zc.m10571(this), C0447yc.m8619());
        this.f1306vl = str;
        return str;
    }

    public int hashCode() {
        int iM4276 = gggy.m4276(this);
        if (iM4276 != 0) {
            return iM4276;
        }
        int iM10716 = C0457zc.m10716(C0457zc.m10571(this));
        this.f1304dV = iM10716;
        return iM10716;
    }

    public int size() {
        return C0457zc.m10571(this).length;
    }

    public String toString() {
        if (C0457zc.m10571(this).length == 0) {
            return abd.m2044();
        }
        String strM10854 = C0458ze.m10854(this);
        int iM9041 = C0448yd.m9041(strM10854, 64);
        if (iM9041 == -1) {
            return C0457zc.m10571(this).length <= 64 ? abc.m1925(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0453yj.m9943()), gggy.m4359(this)), C0450yf.m9561())) : abc.m1925(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(adds.m2680(C0460zg.m11407(new StringBuilder(), C0458ze.m10820()), C0457zc.m10571(this).length), C0458ze.m10801()), gggy.m4359(gggy.m4354(this, 0, 64))), C0448yd.m8929()));
        }
        String strM9597 = C0452yh.m9597(C0452yh.m9597(C0452yh.m9597(C0447yc.m8745(strM10854, 0, iM9041), abd.m2072(), C0449ye.m9216()), C0447yc.m8732(), C0461zs.m11507()), gggy.m4383(), C0446yb.m8436());
        return iM9041 < gggy.m4397(strM10854) ? abc.m1925(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(adds.m2680(C0460zg.m11407(new StringBuilder(), C0458ze.m10820()), C0457zc.m10571(this).length), adds.m2722()), strM9597), C0448yd.m8929())) : abc.m1925(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0461zs.m11574()), strM9597), C0450yf.m9561()));
    }
}
