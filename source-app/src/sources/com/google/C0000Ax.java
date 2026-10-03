package com.google;

import com.google.android.C0007WO;
import com.google.android.C0010ju;
import com.google.android.C0011lC;
import com.google.android.material.card2.AbstractC0441v;
import com.google.android.material.card2.C0013Pa;
import com.google.android.material.card2.C0068bz;
import com.google.android.material.card2.C0155fe;
import com.google.android.material.card2.C0184gg;
import com.google.android.material.card2.C0274jp;
import com.google.android.material.card2.C0335lw;
import com.google.android.material.card2.C0404oj;
import com.google.android.material.card2.C0439to;
import com.google.android.material.card2.C0445ya;
import com.google.android.material.card2.C0599;
import com.google.android.material.card2.C0602;
import com.google.android.material.card2.C0608;
import com.google.android.material.card2.C0610;
import com.google.android.material.card2.C0611;
import com.google.android.material.card2.C0615;
import com.google.android.material.card2.InterfaceC0411oq;
import java.io.ByteArrayOutputStream;

public class C0000Ax {

    public static boolean f0Vh;

    private static short[] f1v = {7, 60, 61, 11041, 3059};

    public static int m0Ix() {
        return (-1746875) ^ C0007WO.m118RN((Object) m15v(0, 3, 1752));
    }

    public static long m1JG(Object obj) {
        if (C0005WH.m83Te() <= 0) {
            return C0599.m11940(obj);
        }
        return 0L;
    }

    public static int m2Ju(Object obj) {
        if (C0003Hp.m52ZM() < 0) {
            return C0335lw.m6201(obj);
        }
        return 0;
    }

    public static void m3Ka(Object obj, Object obj2) {
        if (C0013Pa.m210ro() <= 0) {
            C0068bz.m324b((AbstractC0441v) obj, (C0155fe) obj2);
        }
    }

    public static String m5RZ() {
        if (C0466vs.m1614uR() > 0) {
            return C0610.m13261();
        }
        return null;
    }

    public static long m6SU() {
        if (C0464sk.m1582in() < 0) {
            return C0404oj.m7690();
        }
        return 0L;
    }

    public static C0274jp m7Wh(Object obj, Object obj2) {
        if (C0011lC.m164IP() >= 0) {
            return C0602.m12393(obj, obj2);
        }
        return null;
    }

    public static String m8XX() {
        if (C0464sk.m1582in() <= 0) {
            return C0611.m13386();
        }
        return null;
    }

    public static String m9bd(Object obj) {
        if (C0010ju.m150Bv() < 0) {
            return C0615.m13976(obj);
        }
        return null;
    }

    public static String m10dI() {
        if (C0007WO.m123cB() < 0) {
            return C0608.m13165();
        }
        return null;
    }

    public static int m11ga() {
        if (C0439to.m1503bd() >= 0) {
            return C0445ya.m8222();
        }
        return 0;
    }

    public static String m12nQ(Object obj) {
        if (C0005WH.m83Te() < 0) {
            return C0184gg.m4266(obj);
        }
        return null;
    }

    public static String m13oQ(Object obj) {
        if (C0013Pa.m210ro() <= 0) {
            return ((InterfaceC0411oq) obj).mo1377fJ();
        }
        return null;
    }

    public static String m14ug(String str) {
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
        String strM15v = m15v(3, 4, 11072);
        while (strM15v.length() > 0) {
            strM15v = "";
            if ("".length() == 0) {
                strM15v = m15v(4, 5, 2962);
            }
        }
        int length = strM15v.length();
        int length2 = str2.length();
        for (int i3 = 0; i3 < length; i3++) {
            byteArray[i3] = (byte) (byteArray[i3] ^ str2.charAt(i3 % length2));
        }
        for (int length3 = 0; length3 < byteArray.length; length3 = "".length() + 1) {
        }
        return new String(byteArray);
    }

    private static String m15v(int i, int i2, int i3) {
        char[] cArr = new char[i2 - i];
        for (int i4 = 0; i4 < i2 - i; i4++) {
            cArr[i4] = (char) (f1v[i + i4] ^ i3);
        }
        return new String(cArr);
    }

    public static String m4QK(short[] sArr, int i, int i2, int i3) {
        char[] cArr = new char[i2];
        for (int i4 = 0; i4 < i2; i4++) {
            cArr[i4] = (char) (sArr[i + i4] ^ i3);
        }
        return new String(cArr);
    }
}
