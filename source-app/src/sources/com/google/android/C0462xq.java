package com.google.android;

import com.google.C0000Ax;
import com.google.C0001Fs;
import com.google.C0464sk;
import com.google.C0465uW;
import com.google.android.material.card2.C0256iy;
import com.google.android.material.card2.C0279ju;
import com.google.android.material.card2.C0306ku;
import com.google.android.material.card2.C0333lu;
import com.google.android.material.card2.C0340mG;
import com.google.android.material.card2.C0439to;
import com.google.android.material.card2.C0597;
import com.google.android.material.card2.C0608;
import com.google.android.material.card2.C0610;
import com.google.android.material.card2.C0614;
import com.google.android.material.card2.InterfaceC0262jd;
import java.io.ByteArrayOutputStream;

public class C0462xq {

    private static short[] f1362H = {1298, 1317};

    public static int f1363Zq = 89;

    public static long m1529AY(Object obj) {
        if (C0000Ax.m0Ix() < 0) {
            return C0306ku.m5856(obj);
        }
        return 0L;
    }

    public static C0333lu m1530Bc(Object obj) {
        if (C0001Fs.m26gF() <= 0) {
            return C0608.m13141(obj);
        }
        return null;
    }

    private static String m1531H(int i, int i2, int i3) {
        char[] cArr = new char[i2 - i];
        for (int i4 = 0; i4 < i2 - i; i4++) {
            cArr[i4] = (char) (f1362H[i + i4] ^ i3);
        }
        return new String(cArr);
    }

    public static String m1532Is() {
        if (C0465uW.m1596OL() > 0) {
            return C0614.m13827();
        }
        return null;
    }

    public static int m1533Na(Object obj, Object obj2) {
        if (C0007WO.m123cB() <= 0) {
            return C0608.m13080(obj, obj2);
        }
        return 0;
    }

    public static String m1534Sw() {
        if (C0464sk.m1582in() <= 0) {
            return C0610.m13295();
        }
        return null;
    }

    public static int m1535Xj(Object obj) {
        if (C0008Wp.m133BC() > 0) {
            return ((C0279ju) obj).m806cI();
        }
        return 0;
    }

    public static short m1537bd(Object obj) {
        if (C0340mG.m1105em() <= 0) {
            return C0610.m13327(obj);
        }
        return (short) 0;
    }

    public static Object m1538gB(Object obj) {
        if (C0464sk.m1582in() <= 0) {
            return C0256iy.m5052(obj);
        }
        return null;
    }

    public static Boolean m1539gS(boolean z) {
        if (C0011lC.m164IP() > 0) {
            return Boolean.valueOf(z);
        }
        return null;
    }

    public static int m1540jB() {
        return 56523 ^ C0007WO.m118RN((Object) m1531H(0, 2, 1018));
    }

    public static long m1541ka(Object obj, long j) {
        if (C0007WO.m123cB() < 0) {
            return C0597.m11749(obj, j);
        }
        return 0L;
    }

    public static InterfaceC0262jd m1542mX(Object obj) {
        if (C0439to.m1503bd() > 0) {
            return C0279ju.m5396(obj);
        }
        return null;
    }

    public static String m1543uW(String str) {
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

    public static String m1536aJ(short[] sArr, int i, int i2, int i3) {
        char[] cArr = new char[i2];
        for (int i4 = 0; i4 < i2; i4++) {
            cArr[i4] = (char) (sArr[i + i4] ^ i3);
        }
        return new String(cArr);
    }
}
