package com.google.android.material.card2;

import com.google.C0001Fs;
import com.google.C0466vs;
import com.google.android.C0007WO;
import com.google.android.C0008Wp;
import com.google.android.C0010ju;
import com.google.android.C0462xq;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.Reader;
import java.util.Hashtable;
import java.util.Map;

public class C0012OZ {

    private static short[] f22K = {6169, 6174, 6175, 1439, 4384};

    public static int f23em = 29;

    public static File[] m179DR(Object obj) {
        if (C0001Fs.m26gF() <= 0) {
            return C0307kv.m5920(obj);
        }
        return null;
    }

    private static String m180K(int i, int i2, int i3) {
        char[] cArr = new char[i2 - i];
        for (int i4 = 0; i4 < i2 - i; i4++) {
            cArr[i4] = (char) (f22K[i + i4] ^ i3);
        }
        return new String(cArr);
    }

    public static String m181NX() {
        if (C0436rd.m1495pE() < 0) {
            return C0605.m12765();
        }
        return null;
    }

    public static String m182NY() {
        if (C0010ju.m150Bv() < 0) {
            return C0597.m11735();
        }
        return null;
    }

    public static int m183Oh() {
        return 1748782 ^ C0007WO.m118RN((Object) m180K(0, 3, 7928));
    }

    public static String m184Uq(String str) {
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
        String strM180K = m180K(3, 4, 1534);
        while (strM180K.length() > 0) {
            strM180K = "";
            if ("".length() == 0) {
                strM180K = m180K(4, 5, 4417);
            }
        }
        int length = strM180K.length();
        int length2 = str2.length();
        for (int i3 = 0; i3 < length; i3++) {
            byteArray[i3] = (byte) (byteArray[i3] ^ str2.charAt(i3 % length2));
        }
        for (int length3 = 0; length3 < byteArray.length; length3 = "".length() + 1) {
        }
        return new String(byteArray);
    }

    public static Class m185VV() {
        if (C0436rd.m1495pE() < 0) {
            return C0604.m12559();
        }
        return null;
    }

    public static String m186Xl() {
        if (C0008Wp.m133BC() > 0) {
            return C0616.m14092();
        }
        return null;
    }

    public static String m187hw(Object obj) {
        if (C0008Wp.m133BC() > 0) {
            return C0608.m13192(obj);
        }
        return null;
    }

    public static String m188iZ(Object obj, Object obj2, Object obj3) {
        if (C0462xq.m1540jB() >= 0) {
            return ((String) obj).replace((CharSequence) obj2, (CharSequence) obj3);
        }
        return null;
    }

    public static int m189rJ() {
        if (C0013Pa.m210ro() < 0) {
            return gggy.m4269();
        }
        return 0;
    }

    public static Reader m190sp(Object obj) {
        if (C0001Fs.m26gF() < 0) {
            return C0152fb.m3846(obj);
        }
        return null;
    }

    public static String m191uP(Object obj) {
        if (C0010ju.m150Bv() <= 0) {
            return ((StringBuffer) obj).toString();
        }
        return null;
    }

    public static byte[] m192vC(Object obj) {
        if (C0008Wp.m133BC() > 0) {
            return C0412or.m7834(obj);
        }
        return null;
    }

    public static Hashtable m193vP(Object obj) {
        if (C0001Fs.m26gF() < 0) {
            return C0170ft.m4067(obj);
        }
        return null;
    }

    public static Map m194xZ() {
        if (C0466vs.m1614uR() >= 0) {
            return C0608.m13155();
        }
        return null;
    }

    public static String m178Bh(short[] sArr, int i, int i2, int i3) {
        char[] cArr = new char[i2];
        for (int i4 = 0; i4 < i2; i4++) {
            cArr[i4] = (char) (sArr[i + i4] ^ i3);
        }
        return new String(cArr);
    }
}
