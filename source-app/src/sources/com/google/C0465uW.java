package com.google;

import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import com.google.android.C0006Hm;
import com.google.android.C0007WO;
import com.google.android.C0008Wp;
import com.google.android.C0011lC;
import com.google.android.C0462xq;
import com.google.android.material.card2.AbstractC0022ah;
import com.google.android.material.card2.C0042bR;
import com.google.android.material.card2.C0291kf;
import com.google.android.material.card2.C0436rd;
import com.google.android.material.card2.C0439to;
import com.google.android.material.card2.C0456zb;
import com.google.android.material.card2.C0597;
import com.google.android.material.card2.C0601;
import com.google.android.material.card2.C0602;
import com.google.android.material.card2.C0612;
import com.google.android.material.card2.C0617;
import com.google.android.material.card2.InterfaceC0428pg;
import java.io.ByteArrayOutputStream;
import java.util.List;

public class C0465uW {

    public static int f1368CW = 95;

    private static short[] f1369H = {3833, 3833, 3838};

    public static String m1588BN() {
        if (C0042bR.m273YY() < 0) {
            return C0597.m11757();
        }
        return null;
    }

    public static int m1589Fi(Object obj, int i) {
        if (C0439to.m1503bd() > 0) {
            return ((String) obj).indexOf(i);
        }
        return 0;
    }

    private static String m1590H(int i, int i2, int i3) {
        char[] cArr = new char[i2 - i];
        for (int i4 = 0; i4 < i2 - i; i4++) {
            cArr[i4] = (char) (f1369H[i + i4] ^ i3);
        }
        return new String(cArr);
    }

    public static int m1591IP(Object obj) {
        if (C0436rd.m1495pE() < 0) {
            return ((Bitmap) obj).getRowBytes();
        }
        return 0;
    }

    public static byte[] m1592KC(Object obj, Object obj2) {
        if (C0001Fs.m26gF() <= 0) {
            return C0601.m12178(obj, obj2);
        }
        return null;
    }

    public static C0291kf m1593Ks(Object obj, Object obj2) {
        if (C0462xq.m1540jB() > 0) {
            return C0602.m12313(obj, obj2);
        }
        return null;
    }

    public static List m1594Lb(Object obj) {
        if (C0011lC.m164IP() >= 0) {
            return C0612.m13497(obj);
        }
        return null;
    }

    public static int m1596OL() {
        return 1754648 ^ C0007WO.m118RN((Object) m1590H(0, 3, 2078));
    }

    public static String m1597Wr() {
        if (C0008Wp.m133BC() > 0) {
            return C0612.m13508();
        }
        return null;
    }

    public static PackageInfo m1598dB(Object obj, Object obj2, int i) {
        if (C0001Fs.m26gF() < 0) {
            return ((PackageManager) obj).getPackageInfo((String) obj2, i);
        }
        return null;
    }

    public static AbstractC0022ah m1599eE() {
        if (C0006Hm.m111vs() >= 0) {
            return C0597.m11781();
        }
        return null;
    }

    public static InterfaceC0428pg m1600kC(Object obj, long j) {
        if (C0002Hb.m40cP() < 0) {
            return C0617.m14149(obj, j);
        }
        return null;
    }

    public static int m1601kO() {
        if (C0466vs.m1614uR() > 0) {
            return C0456zb.m10326();
        }
        return 0;
    }

    public static String m1602tF(String str) {
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

    public static String m1595Mo(short[] sArr, int i, int i2, int i3) {
        char[] cArr = new char[i2];
        for (int i4 = 0; i4 < i2; i4++) {
            cArr[i4] = (char) (sArr[i + i4] ^ i3);
        }
        return new String(cArr);
    }
}
