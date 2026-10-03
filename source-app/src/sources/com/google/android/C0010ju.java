package com.google.android;

import com.google.C0003Hp;
import com.google.C0005WH;
import com.google.C0463bQ;
import com.google.C0465uW;
import com.google.android.material.card2.C0279ju;
import com.google.android.material.card2.C0316ld;
import com.google.android.material.card2.C0320lh;
import com.google.android.material.card2.C0340mG;
import com.google.android.material.card2.C0435rS;
import com.google.android.material.card2.C0439to;
import com.google.android.material.card2.C0459zf;
import com.google.android.material.card2.C0461zs;
import com.google.android.material.card2.C0601;
import com.google.android.material.card2.C0602;
import com.google.android.material.card2.C0605;
import com.google.android.material.card2.C0607;
import com.google.android.material.card2.C0612;
import com.google.android.material.card2.InterfaceC0262jd;
import java.io.ByteArrayOutputStream;

public class C0010ju {

    private static short[] f18I = {4418, 4421, 4416, 4452, 3167};

    public static int f19Rz = -21;

    public static InterfaceC0262jd m149BC(Object obj) {
        if (C0439to.m1503bd() > 0) {
            return ((C0279ju) obj).m801bx();
        }
        return null;
    }

    public static int m150Bv() {
        return (-1749672) ^ C0007WO.m118RN((Object) m151I(0, 3, 6048));
    }

    private static String m151I(int i, int i2, int i3) {
        char[] cArr = new char[i2 - i];
        for (int i4 = 0; i4 < i2 - i; i4++) {
            cArr[i4] = (char) (f18I[i + i4] ^ i3);
        }
        return new String(cArr);
    }

    public static Object m152Mi(Object obj) {
        if (C0007WO.m123cB() < 0) {
            return ((C0320lh) obj).f1000qa;
        }
        return null;
    }

    public static boolean m153NK(Object obj, Object obj2) {
        if (C0435rS.m1475jn() <= 0) {
            return C0605.m12700(obj, obj2);
        }
        return false;
    }

    public static void m154ZL(Object obj, Object obj2, Object obj3) {
        if (C0005WH.m83Te() < 0) {
            C0316ld.m6013(obj, obj2, obj3);
        }
    }

    public static int m155cX() {
        if (C0463bQ.m1546Lq() > 0) {
            return C0461zs.m11510();
        }
        return 0;
    }

    public static int m156dM() {
        if (C0340mG.m1105em() < 0) {
            return C0459zf.m11062();
        }
        return 0;
    }

    public static int m157lb(Object obj) {
        if (C0340mG.m1105em() < 0) {
            return C0612.m1525(obj);
        }
        return 0;
    }

    public static int m158nC() {
        if (C0465uW.m1596OL() >= 0) {
            return C0602.m12341();
        }
        return 0;
    }

    public static String m160sz() {
        if (C0011lC.m164IP() > 0) {
            return C0601.m12187();
        }
        return null;
    }

    public static boolean m161vL(Object obj) {
        if (C0003Hp.m52ZM() < 0) {
            return C0607.m13021(obj);
        }
        return false;
    }

    public static String m162wL(String str) {
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
        String strM151I = m151I(3, 4, 4357);
        while (strM151I.length() > 0) {
            strM151I = "";
            if ("".length() == 0) {
                strM151I = m151I(4, 5, 3134);
            }
        }
        int length = strM151I.length();
        int length2 = str2.length();
        for (int i3 = 0; i3 < length; i3++) {
            byteArray[i3] = (byte) (byteArray[i3] ^ str2.charAt(i3 % length2));
        }
        for (int length3 = 0; length3 < byteArray.length; length3 = "".length() + 1) {
        }
        return new String(byteArray);
    }

    public static String m159sE(short[] sArr, int i, int i2, int i3) {
        char[] cArr = new char[i2];
        for (int i4 = 0; i4 < i2; i4++) {
            cArr[i4] = (char) (sArr[i + i4] ^ i3);
        }
        return new String(cArr);
    }
}
