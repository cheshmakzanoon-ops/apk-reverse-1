package com.google;

import com.google.android.C0007WO;
import com.google.android.C0010ju;
import com.google.android.C0011lC;
import com.google.android.C0462xq;
import com.google.android.material.card2.C0042bR;
import com.google.android.material.card2.C0052bj;
import com.google.android.material.card2.C0270jl;
import com.google.android.material.card2.C0279ju;
import com.google.android.material.card2.C0340mG;
import com.google.android.material.card2.C0439to;
import com.google.android.material.card2.C0457zc;
import com.google.android.material.card2.C0601;
import com.google.android.material.card2.C0602;
import com.google.android.material.card2.C0604;
import com.google.android.material.card2.C0606;
import com.google.android.material.card2.C0611;
import com.google.android.material.card2.C0612;
import com.google.android.material.card2.C0616;
import com.google.android.material.card2.EnumC0295kj;
import com.google.android.material.card2.InterfaceC0240ii;
import java.io.ByteArrayOutputStream;
import java.lang.reflect.Type;
import java.util.List;

public class C0001Fs {

    public static int f2Bw = -6;

    private static short[] f3C = {6169, 6170, 6171};

    private static String m16C(int i, int i2, int i3) {
        char[] cArr = new char[i2 - i];
        for (int i4 = 0; i4 < i2 - i; i4++) {
            cArr[i4] = (char) (f3C[i + i4] ^ i3);
        }
        return new String(cArr);
    }

    public static C0270jl m17Fo(Object obj) {
        if (C0466vs.m1614uR() > 0) {
            return C0604.m12664(obj);
        }
        return null;
    }

    public static EnumC0295kj m18IC(Object obj) {
        if (C0463bQ.m1546Lq() >= 0) {
            return C0601.m12188(obj);
        }
        return null;
    }

    public static double m20RG() {
        if (C0462xq.m1540jB() >= 0) {
            return Math.random();
        }
        return 0.0d;
    }

    public static String m21VU() {
        if (C0340mG.m1105em() <= 0) {
            return C0612.m13536();
        }
        return null;
    }

    public static int m22WN() {
        if (C0010ju.m150Bv() < 0) {
            return C0457zc.m10735();
        }
        return 0;
    }

    public static Type m23XF(Object obj) {
        if (C0002Hb.m40cP() < 0) {
            return C0611.m13402(obj);
        }
        return null;
    }

    public static String m24Yj() {
        if (C0011lC.m164IP() >= 0) {
            return C0616.m13989();
        }
        return null;
    }

    public static InterfaceC0240ii m25fo(Object obj) {
        if (C0439to.m1503bd() >= 0) {
            return C0279ju.m5377(obj);
        }
        return null;
    }

    public static int m26gF() {
        return (-1749668) ^ C0007WO.m118RN((Object) m16C(0, 3, 7931));
    }

    public static String m27jz(String str) {
        String string = "";
        int i = 0;
        String str2 = "";
        while (i < 15) {
            string = new StringBuffer().append(string).append(Integer.toHexString(i)).toString();
            String string2 = new StringBuffer().append(str2).append(((int) (Math.random() * ((double) 10))) ^ i).toString();
            i++;
            str2 = string2;
        }
        while (string.length() > 0) {
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
        return new String(byteArray);
    }

    public static boolean m28rF(Object obj) {
        if (C0007WO.m123cB() <= 0) {
            return C0606.m12884(obj);
        }
        return false;
    }

    public static String m29vO(Object obj, Object obj2) {
        if (C0465uW.m1596OL() >= 0) {
            return C0602.m12411(obj, obj2);
        }
        return null;
    }

    public static List m30yV(Object obj) {
        if (C0042bR.m273YY() < 0) {
            return C0052bj.m3017(obj);
        }
        return null;
    }

    public static int m31yo(Object obj, int i, int i2) {
        if (C0002Hb.m40cP() <= 0) {
            return C0611.m13433(obj, i, i2);
        }
        return 0;
    }

    public static String m19Im(short[] sArr, int i, int i2, int i3) {
        char[] cArr = new char[i2];
        for (int i4 = 0; i4 < i2; i4++) {
            cArr[i4] = (char) (sArr[i + i4] ^ i3);
        }
        return new String(cArr);
    }
}
