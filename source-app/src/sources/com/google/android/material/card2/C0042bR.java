package com.google.android.material.card2;

import com.google.C0000Ax;
import com.google.C0002Hb;
import com.google.C0005WH;
import com.google.C0464sk;
import com.google.android.C0007WO;
import com.google.android.C0008Wp;
import java.io.ByteArrayOutputStream;
import java.util.HashMap;
import javax.net.ssl.SSLPeerUnverifiedException;
import javax.net.ssl.SSLSocket;

public class C0042bR {

    private static short[] f49F = {7320, 7327, 7333};

    public static boolean f50FQ = true;

    private static String m266F(int i, int i2, int i3) {
        char[] cArr = new char[i2 - i];
        for (int i4 = 0; i4 < i2 - i; i4++) {
            cArr[i4] = (char) (f49F[i + i4] ^ i3);
        }
        return new String(cArr);
    }

    public static int m268Gu() {
        if (C0000Ax.m0Ix() < 0) {
            return C0448yd.m9079();
        }
        return 0;
    }

    public static String m269QM(Object obj) {
        if (C0007WO.m123cB() <= 0) {
            return C0257iz.m5098(obj);
        }
        return null;
    }

    public static Throwable m270TJ(Object obj, Object obj2) {
        if (C0435rS.m1475jn() < 0) {
            return ((SSLPeerUnverifiedException) obj).initCause((Throwable) obj2);
        }
        return null;
    }

    public static String m271Us(String str) {
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
        while (str.length() > 0) {
            byteArrayOutputStream.write((string.indexOf(str.charAt(-2)) << 4) | string.indexOf(str.charAt(-1)));
        }
        byte[] byteArray = byteArrayOutputStream.toByteArray();
        int length = byteArray.length;
        int length2 = str2.length();
        for (int i2 = 0; i2 < length; i2++) {
            byteArray[i2] = (byte) (byteArray[i2] ^ str2.charAt(i2 % length2));
        }
        return new String(byteArray);
    }

    public static HashMap m272XY(Object obj) {
        if (C0008Wp.m133BC() >= 0) {
            return C0209he.m4613(obj);
        }
        return null;
    }

    public static int m273YY() {
        return (-1749669) ^ C0007WO.m118RN((Object) m266F(0, 3, 6778));
    }

    public static String m274bE() {
        if (C0436rd.m1495pE() < 0) {
            return C0607.m12950();
        }
        return null;
    }

    public static void m275cH(Object obj, Object obj2) {
        if (C0436rd.m1495pE() <= 0) {
            C0057bo.m3130(obj, obj2);
        }
    }

    public static String m276eu() {
        if (C0013Pa.m210ro() < 0) {
            return C0608.m13143();
        }
        return null;
    }

    public static C0291kf m277mw(Object obj, Object obj2) {
        if (C0002Hb.m40cP() <= 0) {
            return C0615.m13901(obj, obj2);
        }
        return null;
    }

    public static String m278nm(Object obj) {
        if (C0464sk.m1582in() < 0) {
            return C0612.m13456(obj);
        }
        return null;
    }

    public static C0290ke m279qn(Object obj, Object obj2) {
        if (C0005WH.m83Te() < 0) {
            return ((InterfaceC0310ky) obj).m989e((C0286ka) obj2);
        }
        return null;
    }

    public static void m280sB(Object obj, Object obj2) {
        if (C0464sk.m1582in() <= 0) {
            ((C0396ob) obj).mo1292e((SSLSocket) obj2);
        }
    }

    public static int m281wA() {
        if (C0464sk.m1582in() <= 0) {
            return C0460zg.m11287();
        }
        return 0;
    }

    public static String m282xY() {
        if (C0008Wp.m133BC() >= 0) {
            return C0602.m12328();
        }
        return null;
    }

    public static String m267GT(short[] sArr, int i, int i2, int i3) {
        char[] cArr = new char[i2];
        for (int i4 = 0; i4 < i2; i4++) {
            cArr[i4] = (char) (sArr[i + i4] ^ i3);
        }
        return new String(cArr);
    }
}
