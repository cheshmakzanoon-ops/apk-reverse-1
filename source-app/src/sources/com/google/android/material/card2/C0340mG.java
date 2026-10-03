package com.google.android.material.card2;

import com.google.C0001Fs;
import com.google.C0002Hb;
import com.google.android.C0006Hm;
import com.google.android.C0007WO;
import com.google.android.C0008Wp;
import com.google.android.C0010ju;
import java.io.ByteArrayOutputStream;
import java.net.InetSocketAddress;
import java.util.Calendar;

public class C0340mG {

    private static short[] f1045l = {1764, 1764, 1747};

    public static int f1046pR = -73;

    public static Object m1097By(Object obj, Object obj2) {
        if (C0008Wp.m133BC() >= 0) {
            return C0174fx.m4129(obj, obj2);
        }
        return null;
    }

    public static String m1098Mf() {
        if (C0435rS.m1475jn() < 0) {
            return C0605.m12740();
        }
        return null;
    }

    public static String m1100ZU(Object obj, int i) {
        if (C0010ju.m150Bv() <= 0) {
            return ((C0271jm) obj).m721h(i);
        }
        return null;
    }

    public static void m1101Zo(Object obj, Object obj2, long j) {
        if (C0006Hm.m111vs() > 0) {
            ((C0409oo) obj).mo1045b((C0409oo) obj2, j);
        }
    }

    public static long m1102co(Object obj) {
        if (m1105em() <= 0) {
            return C0291kf.m5723(obj);
        }
        return 0L;
    }

    public static AbstractC0022ah m1103dM() {
        if (C0008Wp.m133BC() > 0) {
            return C0611.m13394();
        }
        return null;
    }

    public static String m1104dq(String str) {
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

    public static int m1105em() {
        return (-1755602) ^ C0007WO.m118RN((Object) m1106l(0, 3, 12));
    }

    private static String m1106l(int i, int i2, int i3) {
        char[] cArr = new char[i2 - i];
        for (int i4 = 0; i4 < i2 - i; i4++) {
            cArr[i4] = (char) (f1045l[i + i4] ^ i3);
        }
        return new String(cArr);
    }

    public static int m1107og(Object obj, int i) {
        if (C0435rS.m1475jn() <= 0) {
            return ((Calendar) obj).get(i);
        }
        return 0;
    }

    public static int m1108qg() {
        if (C0007WO.m123cB() <= 0) {
            return adds.m2755();
        }
        return 0;
    }

    public static String m1109qz(Object obj, long j) {
        if (C0002Hb.m40cP() <= 0) {
            return ((C0409oo) obj).m1389l(j);
        }
        return null;
    }

    public static boolean m1110ss(Object obj, Object obj2) {
        if (C0435rS.m1475jn() < 0) {
            return ((String) obj).startsWith((String) obj2);
        }
        return false;
    }

    public static InetSocketAddress m1111zB(Object obj, int i) {
        if (C0001Fs.m26gF() <= 0) {
            return InetSocketAddress.createUnresolved((String) obj, i);
        }
        return null;
    }

    public static String m1099Xp(short[] sArr, int i, int i2, int i3) {
        char[] cArr = new char[i2];
        for (int i4 = 0; i4 < i2; i4++) {
            cArr[i4] = (char) (sArr[i + i4] ^ i3);
        }
        return new String(cArr);
    }
}
