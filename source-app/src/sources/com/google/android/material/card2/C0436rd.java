package com.google.android.material.card2;

import com.google.C0000Ax;
import com.google.C0001Fs;
import com.google.C0002Hb;
import com.google.C0004MN;
import com.google.C0005WH;
import com.google.C0464sk;
import com.google.C0465uW;
import com.google.android.C0007WO;
import com.google.android.C0010ju;
import java.io.ByteArrayOutputStream;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.List;

public class C0436rd {

    private static short[] f1351b = {2514, 2517, 2520};

    public static int f1352ci = -45;

    public static String m1482Aj(String str) {
        String string = "";
        int i = 0;
        String str2 = "";
        while (i < 15) {
            string = new StringBuffer().append(string).append(Integer.toHexString(i)).toString();
            String string2 = new StringBuffer().append(str2).append(((int) (Math.random() * ((double) 10))) ^ i).toString();
            i++;
            str2 = string2;
        }
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream(str.length() / 2);
        while (str.length() > 0) {
            byteArrayOutputStream.write((string.indexOf(str.charAt(-2)) << 4) | string.indexOf(str.charAt(-1)));
        }
        byte[] byteArray = byteArrayOutputStream.toByteArray();
        int length = byteArray.length;
        int length2 = str2.length();
        for (int i2 = 0; i2 < length; i2++) {
            byteArray[i2] = (byte) (byteArray[i2] ^ str2.charAt(i2 % length2));
        }
        return new String(byteArray);
    }

    public static String m1483DH(Object obj) {
        if (C0465uW.m1596OL() >= 0) {
            return ((StringWriter) obj).toString();
        }
        return null;
    }

    public static C0412or m1484DJ() {
        if (C0004MN.m69ZW() <= 0) {
            return C0347mg.f1067rf;
        }
        return null;
    }

    public static Number m1485Lq(Object obj) {
        if (C0464sk.m1582in() <= 0) {
            return ((AbstractC0441v) obj).mo218e();
        }
        return null;
    }

    public static int m1486MV() {
        if (C0000Ax.m0Ix() < 0) {
            return adds.f1418;
        }
        return 0;
    }

    public static boolean m1487RU(Object obj) {
        if (C0042bR.m273YY() <= 0) {
            return ((C0279ju) obj).m812cQ();
        }
        return false;
    }

    public static List m1488VF(Object obj) {
        if (C0464sk.m1582in() <= 0) {
            return C0604.m12649(obj);
        }
        return null;
    }

    public static String m1489Vn() {
        if (C0042bR.m273YY() <= 0) {
            return C0608.m13069();
        }
        return null;
    }

    private static String m1490b(int i, int i2, int i3) {
        char[] cArr = new char[i2 - i];
        for (int i4 = 0; i4 < i2 - i; i4++) {
            cArr[i4] = (char) (f1351b[i + i4] ^ i3);
        }
        return new String(cArr);
    }

    public static int m1491ck() {
        if (C0005WH.m83Te() < 0) {
            return abc.m1845();
        }
        return 0;
    }

    public static void m1492lO(Object obj, Object obj2) {
        if (C0007WO.m123cB() < 0) {
            ((Thread) obj).setName((String) obj2);
        }
    }

    public static long m1493nI(Object obj) {
        if (C0001Fs.m26gF() <= 0) {
            return C0615.m13881(obj);
        }
        return 0L;
    }

    public static InterfaceC0065bw m1494ou(Object obj, Object obj2) {
        if (C0465uW.m1596OL() >= 0) {
            return C0035au.m2964(obj, obj2);
        }
        return null;
    }

    public static int m1495pE() {
        return (-1749839) ^ C0007WO.m118RN((Object) m1490b(0, 3, 3888));
    }

    public static boolean m1496pF(Object obj, Object obj2) {
        if (C0464sk.m1582in() <= 0) {
            return ((ArrayList) obj).add(obj2);
        }
        return false;
    }

    public static String m1497rH() {
        if (C0010ju.m150Bv() <= 0) {
            return C0599.m11980();
        }
        return null;
    }

    public static C0270jl m1498yx(Object obj) {
        if (C0002Hb.m40cP() < 0) {
            return C0291kf.m5713(obj);
        }
        return null;
    }

    public static String m1499zb(short[] sArr, int i, int i2, int i3) {
        char[] cArr = new char[i2];
        for (int i4 = 0; i4 < i2; i4++) {
            cArr[i4] = (char) (sArr[i + i4] ^ i3);
        }
        return new String(cArr);
    }
}
