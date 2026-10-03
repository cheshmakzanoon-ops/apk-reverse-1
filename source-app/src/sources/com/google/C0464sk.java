package com.google;

import com.google.android.C0006Hm;
import com.google.android.C0007WO;
import com.google.android.C0008Wp;
import com.google.android.material.card2.AbstractC0022ah;
import com.google.android.material.card2.C0013Pa;
import com.google.android.material.card2.C0253iv;
import com.google.android.material.card2.C0273jo;
import com.google.android.material.card2.C0279ju;
import com.google.android.material.card2.C0287kb;
import com.google.android.material.card2.C0313la;
import com.google.android.material.card2.C0332lt;
import com.google.android.material.card2.C0340mG;
import com.google.android.material.card2.C0435rS;
import com.google.android.material.card2.C0439to;
import com.google.android.material.card2.C0608;
import com.google.android.material.card2.C0610;
import com.google.android.material.card2.C0611;
import com.google.android.material.card2.C0616;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Comparator;
import java.util.List;
import javax.net.ssl.TrustManager;
import javax.net.ssl.TrustManagerFactory;

public class C0464sk {

    public static int f1366UQ = -84;

    private static short[] f1367e = {3526, 3524, 3583};

    public static List m1569AP(Object obj) {
        if (C0000Ax.m0Ix() <= 0) {
            return C0610.m13227(obj);
        }
        return null;
    }

    public static String m1570Cc(String str) {
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

    public static TrustManager[] m1572GZ(Object obj) {
        if (C0004MN.m69ZW() < 0) {
            return ((TrustManagerFactory) obj).getTrustManagers();
        }
        return null;
    }

    public static AbstractC0022ah m1573Iz() {
        if (C0004MN.m69ZW() < 0) {
            return C0611.m13361();
        }
        return null;
    }

    public static boolean m1574MG(Object obj, Object obj2) {
        if (C0013Pa.m210ro() <= 0) {
            return ((C0313la) obj).m994a((IOException) obj2);
        }
        return false;
    }

    public static Comparator m1575MY() {
        if (C0005WH.m83Te() < 0) {
            return C0608.m13139();
        }
        return null;
    }

    public static StringBuffer m1576Ol(Object obj, int i) {
        if (C0007WO.m123cB() <= 0) {
            return ((StringBuffer) obj).append(i);
        }
        return null;
    }

    public static byte[] m1577dO(Object obj) {
        if (C0006Hm.m111vs() >= 0) {
            return C0616.m14055(obj);
        }
        return null;
    }

    private static String m1578e(int i, int i2, int i3) {
        char[] cArr = new char[i2 - i];
        for (int i4 = 0; i4 < i2 - i; i4++) {
            cArr[i4] = (char) (f1367e[i + i4] ^ i3);
        }
        return new String(cArr);
    }

    public static String m1579ey(Object obj) {
        if (C0005WH.m83Te() < 0) {
            return ((C0273jo) obj).m758cx();
        }
        return null;
    }

    public static void m1580fG(Object obj) {
        if (C0008Wp.m133BC() >= 0) {
            System.loadLibrary((String) obj);
        }
    }

    public static int m1581hD(Object obj) {
        if (C0340mG.m1105em() <= 0) {
            return obj.hashCode();
        }
        return 0;
    }

    public static int m1582in() {
        return (-1753542) ^ C0007WO.m118RN((Object) m1578e(0, 3, 2848));
    }

    public static Object m1583iy(Object obj, int i, Object obj2) {
        if (C0340mG.m1105em() <= 0) {
            return C0611.m13406(obj, i, obj2);
        }
        return null;
    }

    public static C0279ju m1584qh(Object obj) {
        if (C0002Hb.m40cP() <= 0) {
            return C0332lt.m6183(obj);
        }
        return null;
    }

    public static long m1585qs(Object obj) {
        if (C0439to.m1503bd() >= 0) {
            return C0253iv.m4993(obj);
        }
        return 0L;
    }

    public static String m1586ut() {
        if (C0435rS.m1475jn() <= 0) {
            return C0610.m13236();
        }
        return null;
    }

    public static String m1587xq(Object obj) {
        if (C0002Hb.m40cP() <= 0) {
            return C0287kb.m5623(obj);
        }
        return null;
    }

    public static String m1571GQ(short[] sArr, int i, int i2, int i3) {
        char[] cArr = new char[i2];
        for (int i4 = 0; i4 < i2; i4++) {
            cArr[i4] = (char) (sArr[i + i4] ^ i3);
        }
        return new String(cArr);
    }
}
