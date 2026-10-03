package com.google.android;

import android.animation.ObjectAnimator;
import android.os.Looper;
import com.google.C0001Fs;
import com.google.C0003Hp;
import com.google.C0004MN;
import com.google.C0005WH;
import com.google.C0464sk;
import com.google.android.material.card2.AbstractC0022ah;
import com.google.android.material.card2.C0146ew;
import com.google.android.material.card2.C0169fs;
import com.google.android.material.card2.C0279ju;
import com.google.android.material.card2.C0373nf;
import com.google.android.material.card2.C0430pi;
import com.google.android.material.card2.C0435rS;
import com.google.android.material.card2.C0439to;
import com.google.android.material.card2.C0602;
import com.google.android.material.card2.C0603;
import com.google.android.material.card2.C0604;
import com.google.android.material.card2.C0611;
import com.google.android.material.card2.C0615;
import com.google.android.material.card2.EnumC0346mf;
import java.io.ByteArrayOutputStream;
import java.lang.reflect.InvocationTargetException;
import java.util.List;

public class C0008Wp {

    public static boolean f16Yk = true;

    private static short[] f17j = {2119, 2117, 2127, 2221, 7131};

    public static EnumC0346mf m132AC(Object obj) {
        if (C0439to.m1503bd() >= 0) {
            return C0373nf.m7143(obj);
        }
        return null;
    }

    public static int m133BC() {
        return 1747727 ^ C0007WO.m118RN((Object) m146j(0, 3, 3751));
    }

    public static AbstractC0022ah m134ME() {
        if (C0005WH.m83Te() <= 0) {
            return C0615.m13951();
        }
        return null;
    }

    public static int m135Os(Object obj, int i) {
        if (C0003Hp.m52ZM() < 0) {
            return C0146ew.m3746(obj, i);
        }
        return 0;
    }

    public static void m136Rq(Object obj, Object obj2, Object obj3) {
        if (C0464sk.m1582in() <= 0) {
            C0603.m12489(obj, obj2, obj3);
        }
    }

    public static String m138Te() {
        if (C0435rS.m1475jn() <= 0) {
            return C0602.m12355();
        }
        return null;
    }

    public static List m139WK(Object obj) {
        if (C0464sk.m1582in() <= 0) {
            return C0279ju.m5402(obj);
        }
        return null;
    }

    public static String m140ZD(String str) {
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
        String strM146j = m146j(3, 4, 2252);
        while (strM146j.length() > 0) {
            strM146j = "";
            if ("".length() == 0) {
                strM146j = m146j(4, 5, 7098);
            }
        }
        int length = strM146j.length();
        int length2 = str2.length();
        for (int i3 = 0; i3 < length; i3++) {
            byteArray[i3] = (byte) (byteArray[i3] ^ str2.charAt(i3 % length2));
        }
        for (int length3 = 0; length3 < byteArray.length; length3 = "".length() + 1) {
        }
        return new String(byteArray);
    }

    public static int m141Zh(Object obj) {
        if (C0462xq.m1540jB() > 0) {
            return C0169fs.m4055(obj);
        }
        return 0;
    }

    public static AbstractC0022ah m142bI(Object obj, Object obj2, Object obj3) {
        if (C0010ju.m150Bv() < 0) {
            return C0603.m12435(obj, obj2, obj3);
        }
        return null;
    }

    public static String m143eD() {
        if (C0011lC.m164IP() >= 0) {
            return C0611.m13424();
        }
        return null;
    }

    public static Throwable m144fo(Object obj) {
        if (C0001Fs.m26gF() < 0) {
            return ((InvocationTargetException) obj).getTargetException();
        }
        return null;
    }

    public static C0430pi m145hu(Object obj) {
        if (C0439to.m1503bd() >= 0) {
            return C0604.m12627(obj);
        }
        return null;
    }

    private static String m146j(int i, int i2, int i3) {
        char[] cArr = new char[i2 - i];
        for (int i4 = 0; i4 < i2 - i; i4++) {
            cArr[i4] = (char) (f17j[i + i4] ^ i3);
        }
        return new String(cArr);
    }

    public static void m147pR(Object obj) {
        if (C0464sk.m1582in() < 0) {
            ((ObjectAnimator) obj).start();
        }
    }

    public static Looper m148pm() {
        if (C0004MN.m69ZW() < 0) {
            return Looper.getMainLooper();
        }
        return null;
    }

    public static String m137St(short[] sArr, int i, int i2, int i3) {
        char[] cArr = new char[i2];
        for (int i4 = 0; i4 < i2; i4++) {
            cArr[i4] = (char) (sArr[i + i4] ^ i3);
        }
        return new String(cArr);
    }
}
