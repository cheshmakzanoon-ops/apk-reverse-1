package com.google;

import com.google.android.C0006Hm;
import com.google.android.C0007WO;
import com.google.android.C0008Wp;
import com.google.android.C0010ju;
import com.google.android.C0011lC;
import com.google.android.material.card2.C0013Pa;
import com.google.android.material.card2.C0257iz;
import com.google.android.material.card2.C0261jc;
import com.google.android.material.card2.C0306ku;
import com.google.android.material.card2.C0315lc;
import com.google.android.material.card2.C0340mG;
import com.google.android.material.card2.C0352ml;
import com.google.android.material.card2.C0412or;
import com.google.android.material.card2.C0435rS;
import com.google.android.material.card2.C0599;
import com.google.android.material.card2.C0603;
import com.google.android.material.card2.C0607;
import com.google.android.material.card2.C0608;
import com.google.android.material.card2.C0612;
import com.google.android.material.card2.C0613;
import java.io.ByteArrayOutputStream;
import java.io.Writer;
import java.lang.reflect.Type;

public class C0004MN {

    private static short[] f8I = {6290, 6289, 6303};

    public static int f9YR = -86;

    public static String m61Be(Object obj) {
        if (C0435rS.m1475jn() < 0) {
            return C0612.m13458(obj);
        }
        return null;
    }

    public static String m62HA() {
        if (C0008Wp.m133BC() >= 0) {
            return C0608.m13119();
        }
        return null;
    }

    private static String m63I(int i, int i2, int i3) {
        char[] cArr = new char[i2 - i];
        for (int i4 = 0; i4 < i2 - i; i4++) {
            cArr[i4] = (char) (f8I[i + i4] ^ i3);
        }
        return new String(cArr);
    }

    public static String m64Js() {
        if (C0003Hp.m52ZM() <= 0) {
            return C0607.m12925();
        }
        return null;
    }

    public static Type[] m65KN(Object obj) {
        if (C0464sk.m1582in() < 0) {
            return C0599.m11967(obj);
        }
        return null;
    }

    public static String m66Na(String str) {
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

    public static Writer m67Om(Object obj) {
        if (C0340mG.m1105em() < 0) {
            return C0612.m13531(obj);
        }
        return null;
    }

    public static String m68Un() {
        if (C0003Hp.m52ZM() < 0) {
            return C0603.m12432();
        }
        return null;
    }

    public static int m69ZW() {
        return (-1752612) ^ C0007WO.m118RN((Object) m63I(0, 3, 7799));
    }

    public static String m70aV(Object obj) {
        if (C0001Fs.m26gF() <= 0) {
            return ((C0257iz) obj).m673cb();
        }
        return null;
    }

    public static C0412or m71bi() {
        if (C0007WO.m123cB() < 0) {
            return C0352ml.m6540();
        }
        return null;
    }

    public static Float m72cs(float f) {
        if (C0435rS.m1475jn() < 0) {
            return Float.valueOf(f);
        }
        return null;
    }

    public static long m73dm(Object obj) {
        if (C0011lC.m164IP() >= 0) {
            return Long.parseLong((String) obj);
        }
        return 0L;
    }

    public static C0315lc m74eo(Object obj, Object obj2) {
        if (C0010ju.m150Bv() <= 0) {
            return C0613.m13690(obj, obj2);
        }
        return null;
    }

    public static void m75pF(Object obj, Object obj2) {
        if (C0006Hm.m111vs() > 0) {
            C0607.m13027(obj, obj2);
        }
    }

    public static void m76ra(Object obj) {
        if (C0013Pa.m210ro() < 0) {
            C0261jc.m5123(obj);
        }
    }

    public static String m78xf(Object obj) {
        if (C0002Hb.m40cP() <= 0) {
            return C0306ku.m5864(obj);
        }
        return null;
    }

    public static void m79zC(Object obj, int i) {
        if (C0464sk.m1582in() <= 0) {
            ((Writer) obj).write(i);
        }
    }

    public static String m77tY(short[] sArr, int i, int i2, int i3) {
        char[] cArr = new char[i2];
        for (int i4 = 0; i4 < i2; i4++) {
            cArr[i4] = (char) (sArr[i + i4] ^ i3);
        }
        return new String(cArr);
    }
}
