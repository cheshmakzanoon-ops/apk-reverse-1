package com.google;

import com.google.android.C0007WO;
import com.google.android.C0010ju;
import com.google.android.C0011lC;
import com.google.android.material.card2.C0057bo;
import com.google.android.material.card2.C0305kt;
import com.google.android.material.card2.C0340mG;
import com.google.android.material.card2.C0415ou;
import com.google.android.material.card2.C0439to;
import com.google.android.material.card2.C0449ye;
import com.google.android.material.card2.C0603;
import com.google.android.material.card2.C0605;
import com.google.android.material.card2.C0613;
import com.google.android.material.card2.InterfaceC0310ky;
import java.io.ByteArrayOutputStream;
import java.lang.reflect.Constructor;

public class C0466vs {

    private static short[] f1370a = {11243, 11218, 11223};

    public static boolean f1371rK;

    public static String m1603Bh() {
        if (C0439to.m1503bd() > 0) {
            return C0613.m13678();
        }
        return null;
    }

    public static C0415ou m1604Cz(Object obj, Object obj2) {
        if (C0464sk.m1582in() < 0) {
            return C0605.m12784(obj, obj2);
        }
        return null;
    }

    public static String m1605Nr() {
        if (C0001Fs.m26gF() < 0) {
            return C0613.m13656();
        }
        return null;
    }

    public static boolean m1606WP(Object obj, int i, Object obj2, int i2, int i3) {
        if (C0011lC.m164IP() > 0) {
            return C0603.m12544(obj, i, obj2, i2, i3);
        }
        return false;
    }

    private static String m1607a(int i, int i2, int i3) {
        char[] cArr = new char[i2 - i];
        for (int i4 = 0; i4 < i2 - i; i4++) {
            cArr[i4] = (char) (f1370a[i + i4] ^ i3);
        }
        return new String(cArr);
    }

    public static void m1608iU(Object obj, Object obj2) {
        if (C0340mG.m1105em() <= 0) {
            ((InterfaceC0310ky) obj).m987a((C0305kt) obj2);
        }
    }

    public static Object m1609kS(Object obj) {
        if (m1614uR() >= 0) {
            return C0057bo.m3106(obj);
        }
        return null;
    }

    public static String m1610lH(String str) {
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
        for (int i2 = 0; i2 < str.length(); i2 += 2) {
            byteArrayOutputStream.write((string.indexOf(str.charAt(i2)) << 4) | string.indexOf(str.charAt(i2 + 1)));
        }
        byte[] byteArray = byteArrayOutputStream.toByteArray();
        int length = byteArray.length;
        int length2 = str2.length();
        while (length > 0) {
            byteArray[-1] = (byte) (byteArray[-1] ^ str2.charAt((-1) % length2));
        }
        for (int length3 = 0; length3 < byteArray.length; length3 = "".length() + 1) {
        }
        return new String(byteArray);
    }

    public static int m1611nb() {
        if (C0010ju.m150Bv() < 0) {
            return C0449ye.m9220();
        }
        return 0;
    }

    public static Object m1613qs(Object obj, Object obj2) {
        if (C0005WH.m83Te() <= 0) {
            return ((Constructor) obj).newInstance((Object[]) obj2);
        }
        return null;
    }

    public static int m1614uR() {
        return 1746902 ^ C0007WO.m118RN((Object) m1607a(0, 3, 11572));
    }

    public static Throwable m1615vX(Object obj, Object obj2) {
        if (C0464sk.m1582in() < 0) {
            return C0603.m12539(obj, obj2);
        }
        return null;
    }

    public static String m1612pz(short[] sArr, int i, int i2, int i3) {
        char[] cArr = new char[i2];
        for (int i4 = 0; i4 < i2; i4++) {
            cArr[i4] = (char) (sArr[i + i4] ^ i3);
        }
        return new String(cArr);
    }
}
