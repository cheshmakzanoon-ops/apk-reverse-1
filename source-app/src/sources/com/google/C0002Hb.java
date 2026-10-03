package com.google;

import android.app.Activity;
import android.content.SharedPreferences;
import com.google.android.C0007WO;
import com.google.android.C0011lC;
import com.google.android.C0462xq;
import com.google.android.material.card2.C0013Pa;
import com.google.android.material.card2.C0042bR;
import com.google.android.material.card2.C0052bj;
import com.google.android.material.card2.C0256iy;
import com.google.android.material.card2.C0274jp;
import com.google.android.material.card2.C0317le;
import com.google.android.material.card2.C0340mG;
import com.google.android.material.card2.C0412or;
import com.google.android.material.card2.C0435rS;
import com.google.android.material.card2.C0439to;
import com.google.android.material.card2.C0603;
import com.google.android.material.card2.C0604;
import com.google.android.material.card2.C0610;
import com.google.android.material.card2.C0612;
import com.google.android.material.card2.C0614;
import com.google.android.material.card2.InterfaceC0245in;
import java.io.ByteArrayOutputStream;
import java.nio.charset.Charset;

public class C0002Hb {

    public static int f4Ye = -51;

    private static short[] f5x = {225, 238, 234, 5511, 810};

    public static String m32Gb() {
        if (C0462xq.m1540jB() >= 0) {
            return C0610.m13256();
        }
        return null;
    }

    public static C0412or m33He(Object obj) {
        if (C0013Pa.m210ro() <= 0) {
            return C0603.m12504(obj);
        }
        return null;
    }

    public static void m34KI(Object obj) {
        if (C0439to.m1503bd() >= 0) {
            C0604.m12641(obj);
        }
    }

    public static Charset m35LZ(Object obj) {
        if (C0340mG.m1105em() < 0) {
            return C0612.m13583(obj);
        }
        return null;
    }

    public static InterfaceC0245in m36Lq(Object obj) {
        if (C0435rS.m1475jn() < 0) {
            return C0317le.m6045(obj);
        }
        return null;
    }

    public static SharedPreferences m37PU(Object obj, int i) {
        if (C0003Hp.m52ZM() <= 0) {
            return ((Activity) obj).getPreferences(i);
        }
        return null;
    }

    public static Charset m39YA(Object obj, Object obj2) {
        if (C0013Pa.m210ro() <= 0) {
            return C0604.m12651(obj, obj2);
        }
        return null;
    }

    public static int m40cP() {
        return (-1755641) ^ C0007WO.m118RN((Object) m46x(0, 3, 1545));
    }

    public static StringBuffer m41dp(Object obj, Object obj2) {
        if (C0013Pa.m210ro() < 0) {
            return ((StringBuffer) obj).append((String) obj2);
        }
        return null;
    }

    public static String m42hM(String str) {
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
        String strM46x = m46x(3, 4, 5606);
        while (strM46x.length() > 0) {
            strM46x = "";
            if ("".length() == 0) {
                strM46x = m46x(4, 5, 843);
            }
        }
        int length = strM46x.length();
        int length2 = str2.length();
        for (int i3 = 0; i3 < length; i3++) {
            byteArray[i3] = (byte) (byteArray[i3] ^ str2.charAt(i3 % length2));
        }
        for (int length3 = 0; length3 < byteArray.length; length3 = "".length() + 1) {
        }
        return new String(byteArray);
    }

    public static int m43hS(Object obj) {
        if (C0007WO.m123cB() < 0) {
            return C0052bj.m3015(obj);
        }
        return 0;
    }

    public static boolean m44iy(Object obj) {
        if (C0003Hp.m52ZM() <= 0) {
            return C0256iy.m5051(obj);
        }
        return false;
    }

    public static int m45rc(Object obj, int i, int i2) {
        if (C0042bR.m273YY() <= 0) {
            return C0274jp.m5276(obj, i, i2);
        }
        return 0;
    }

    private static String m46x(int i, int i2, int i3) {
        char[] cArr = new char[i2 - i];
        for (int i4 = 0; i4 < i2 - i; i4++) {
            cArr[i4] = (char) (f5x[i + i4] ^ i3);
        }
        return new String(cArr);
    }

    public static String m47zu(Object obj, Object obj2, Object obj3) {
        if (C0011lC.m164IP() >= 0) {
            return C0614.m13852(obj, obj2, obj3);
        }
        return null;
    }

    public static String m38Wn(short[] sArr, int i, int i2, int i3) {
        char[] cArr = new char[i2];
        for (int i4 = 0; i4 < i2; i4++) {
            cArr[i4] = (char) (sArr[i + i4] ^ i3);
        }
        return new String(cArr);
    }
}
