package com.google.android;

import com.google.C0001Fs;
import com.google.C0003Hp;
import com.google.C0004MN;
import com.google.C0465uW;
import com.google.C0466vs;
import com.google.android.material.card2.AbstractC0264jf;
import com.google.android.material.card2.C0155fe;
import com.google.android.material.card2.C0329lq;
import com.google.android.material.card2.C0397oc;
import com.google.android.material.card2.C0409oo;
import com.google.android.material.card2.C0435rS;
import com.google.android.material.card2.C0436rd;
import com.google.android.material.card2.C0439to;
import com.google.android.material.card2.C0599;
import com.google.android.material.card2.C0602;
import com.google.android.material.card2.C0603;
import com.google.android.material.card2.C0610;
import com.google.android.material.card2.EnumC0154fd;
import com.google.android.material.card2.abe;
import java.io.ByteArrayOutputStream;
import java.io.Reader;
import java.nio.charset.Charset;
import java.security.cert.X509Certificate;
import java.util.concurrent.atomic.AtomicBoolean;
import javax.security.auth.x500.X500Principal;

public class C0007WO {

    public static boolean f14Jx = true;

    private static short[] f15d = {10516, 10513, 10513};

    public static Charset m113GE() {
        if (C0436rd.m1495pE() < 0) {
            return C0409oo.m7803();
        }
        return null;
    }

    public static String m114Ib() {
        if (m123cB() < 0) {
            return C0602.m12312();
        }
        return null;
    }

    public static int m115Na() {
        if (C0466vs.m1614uR() >= 0) {
            return abe.m2308();
        }
        return 0;
    }

    public static EnumC0154fd m116OF() {
        if (C0003Hp.m52ZM() < 0) {
            return EnumC0154fd.f278el;
        }
        return null;
    }

    public static AtomicBoolean m117Oc(Object obj) {
        if (C0435rS.m1475jn() < 0) {
            return C0397oc.m7597(obj);
        }
        return null;
    }

    public static int m118RN(Object obj) {
        return obj.hashCode();
    }

    public static void m121Vc(Object obj) {
        if (C0006Hm.m111vs() >= 0) {
            ((Reader) obj).close();
        }
    }

    public static AbstractC0264jf m122be(Object obj) {
        if (C0439to.m1503bd() >= 0) {
            return C0329lq.m6151(obj);
        }
        return null;
    }

    public static int m123cB() {
        return (-1747863) ^ m118RN((Object) m124d(0, 3, 12276));
    }

    private static String m124d(int i, int i2, int i3) {
        char[] cArr = new char[i2 - i];
        for (int i4 = 0; i4 < i2 - i; i4++) {
            cArr[i4] = (char) (f15d[i + i4] ^ i3);
        }
        return new String(cArr);
    }

    public static C0409oo m125eX(Object obj, Object obj2) {
        if (C0465uW.m1596OL() > 0) {
            return C0610.m13237(obj, obj2);
        }
        return null;
    }

    public static String m126gZ(String str) {
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

    public static X500Principal m127lb(Object obj) {
        if (C0439to.m1503bd() > 0) {
            return ((X509Certificate) obj).getSubjectX500Principal();
        }
        return null;
    }

    public static C0155fe m128px(Object obj) {
        if (C0439to.m1503bd() >= 0) {
            return C0610.m13223(obj);
        }
        return null;
    }

    public static String m129rb() {
        if (C0001Fs.m26gF() < 0) {
            return "";
        }
        return null;
    }

    public static String m130uf() {
        if (C0435rS.m1475jn() <= 0) {
            return C0599.m12027();
        }
        return null;
    }

    public static Thread m131xc() {
        if (C0004MN.m69ZW() < 0) {
            return C0603.m12434();
        }
        return null;
    }

    public static Class<?> m119RN(String str) throws ClassNotFoundException {
        return Class.forName(str);
    }

    public static String m112CU(short[] sArr, int i, int i2, int i3) {
        char[] cArr = new char[i2];
        for (int i4 = 0; i4 < i2; i4++) {
            cArr[i4] = (char) (sArr[i + i4] ^ i3);
        }
        return new String(cArr);
    }

    public static String m120RN(short[] sArr, int i, int i2, int i3) {
        char[] cArr = new char[i2];
        for (int i4 = 0; i4 < i2; i4++) {
            cArr[i4] = (char) (sArr[i + i4] ^ i3);
        }
        return new String(cArr);
    }
}
