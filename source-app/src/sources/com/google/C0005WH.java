package com.google;

import com.google.android.C0007WO;
import com.google.android.C0010ju;
import com.google.android.material.card2.C0042bR;
import com.google.android.material.card2.C0243il;
import com.google.android.material.card2.C0314lb;
import com.google.android.material.card2.C0409oo;
import com.google.android.material.card2.C0435rS;
import com.google.android.material.card2.C0597;
import com.google.android.material.card2.C0600;
import com.google.android.material.card2.C0613;
import com.google.android.material.card2.C0617;
import com.google.android.material.card2.InterfaceC0025ak;
import java.io.ByteArrayOutputStream;
import java.net.Socket;

public class C0005WH {

    public static boolean f10Sv = true;

    private static short[] f11h = {5875, 5837, 5872};

    public static boolean m81Sm(Object obj) {
        if (C0435rS.m1475jn() < 0) {
            return C0243il.m4902(obj);
        }
        return false;
    }

    public static void m82TC(Object obj, Object obj2, Object obj3) {
        if (C0466vs.m1614uR() > 0) {
            C0617.m14202(obj, obj2, obj3);
        }
    }

    public static int m83Te() {
        return (-1748656) ^ C0007WO.m118RN((Object) m88h(0, 3, 4114));
    }

    public static int m84VG(Object obj) {
        if (C0007WO.m123cB() < 0) {
            return ((C0314lb) obj).f960pn;
        }
        return 0;
    }

    public static String m85dW(String str) {
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
        for (int i3 = 0; i3 < length; i3++) {
            byteArray[i3] = (byte) (byteArray[i3] ^ str2.charAt(i3 % length2));
        }
        for (int length3 = 0; length3 < byteArray.length; length3 = "".length() + 1) {
        }
        return new String(byteArray);
    }

    public static boolean m86eM(Object obj) {
        if (m83Te() < 0) {
            return ((InterfaceC0025ak) obj).m231s();
        }
        return false;
    }

    public static String m87gO() {
        if (C0435rS.m1475jn() <= 0) {
            return C0597.m11703();
        }
        return null;
    }

    private static String m88h(int i, int i2, int i3) {
        char[] cArr = new char[i2 - i];
        for (int i4 = 0; i4 < i2 - i; i4++) {
            cArr[i4] = (char) (f11h[i + i4] ^ i3);
        }
        return new String(cArr);
    }

    public static String m89iN() {
        if (C0010ju.m150Bv() <= 0) {
            return C0600.m12042();
        }
        return null;
    }

    public static long m90qs(Object obj) {
        if (C0042bR.m273YY() <= 0) {
            return ((C0409oo) obj).m1378fK();
        }
        return 0L;
    }

    public static String m91ux(int i) {
        if (C0004MN.m69ZW() < 0) {
            return Integer.toHexString(i);
        }
        return null;
    }

    public static Socket m92xn(Object obj, Object obj2) {
        if (C0004MN.m69ZW() < 0) {
            return C0613.m13707(obj, obj2);
        }
        return null;
    }

    public static String m80EQ(short[] sArr, int i, int i2, int i3) {
        char[] cArr = new char[i2];
        for (int i4 = 0; i4 < i2; i4++) {
            cArr[i4] = (char) (sArr[i + i4] ^ i3);
        }
        return new String(cArr);
    }
}
