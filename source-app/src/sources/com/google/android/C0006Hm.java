package com.google.android;

import android.content.Context;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.widget.Toast;
import com.google.C0000Ax;
import com.google.C0001Fs;
import com.google.C0003Hp;
import com.google.C0463bQ;
import com.google.C0465uW;
import com.google.C0466vs;
import com.google.android.material.card2.AbstractC0264jf;
import com.google.android.material.card2.C0042bR;
import com.google.android.material.card2.C0152fb;
import com.google.android.material.card2.C0187gj;
import com.google.android.material.card2.C0268jj;
import com.google.android.material.card2.C0319lg;
import com.google.android.material.card2.C0340mG;
import com.google.android.material.card2.C0402oh;
import com.google.android.material.card2.C0436rd;
import com.google.android.material.card2.C0439to;
import com.google.android.material.card2.C0446yb;
import com.google.android.material.card2.C0447yc;
import com.google.android.material.card2.C0453yj;
import com.google.android.material.card2.C0600;
import com.google.android.material.card2.C0607;
import com.google.android.material.card2.C0608;
import com.google.android.material.card2.C0613;
import java.io.ByteArrayOutputStream;
import java.util.Deque;
import java.util.Iterator;

public class C0006Hm {

    private static short[] f12M = {5727, 5722, 5725};

    public static int f13UV = 88;

    public static int m93Cc() {
        if (C0001Fs.m26gF() <= 0) {
            return C0447yc.m8635();
        }
        return 0;
    }

    public static AbstractC0264jf m94Di(Object obj) {
        if (C0007WO.m123cB() < 0) {
            return ((C0319lg) obj).f993pU;
        }
        return null;
    }

    public static int m95Hu() {
        if (C0340mG.m1105em() < 0) {
            return C0453yj.m10013();
        }
        return 0;
    }

    public static int m96IK() {
        if (C0436rd.m1495pE() <= 0) {
            return C0446yb.m8415();
        }
        return 0;
    }

    public static String m97IY(Object obj) {
        if (C0463bQ.m1546Lq() > 0) {
            return C0187gj.m4531(obj);
        }
        return null;
    }

    private static String m98M(int i, int i2, int i3) {
        char[] cArr = new char[i2 - i];
        for (int i4 = 0; i4 < i2 - i; i4++) {
            cArr[i4] = (char) (f12M[i + i4] ^ i3);
        }
        return new String(cArr);
    }

    public static String m99VY() {
        if (C0042bR.m273YY() <= 0) {
            return C0608.m13131();
        }
        return null;
    }

    public static C0268jj m100WJ(Object obj) {
        if (C0465uW.m1596OL() > 0) {
            return C0613.m13640(obj);
        }
        return null;
    }

    public static String m101Zg() {
        if (C0436rd.m1495pE() < 0) {
            return C0607.m13018();
        }
        return null;
    }

    public static C0402oh m102bR() {
        if (C0003Hp.m52ZM() <= 0) {
            return C0402oh.f1286uT;
        }
        return null;
    }

    public static int m103dp(Object obj) {
        if (C0439to.m1503bd() >= 0) {
            return ((Bitmap) obj).getWidth();
        }
        return 0;
    }

    public static int m105hT(Object obj) {
        if (m111vs() >= 0) {
            return C0152fb.m3819(obj);
        }
        return 0;
    }

    public static Toast m106nD(Object obj, Object obj2, int i) {
        if (C0008Wp.m133BC() >= 0) {
            return Toast.makeText((Context) obj, (CharSequence) obj2, i);
        }
        return null;
    }

    public static AssetManager m107to(Object obj) {
        if (C0000Ax.m0Ix() < 0) {
            return C0600.m12053(obj);
        }
        return null;
    }

    public static String m108tx(String str) {
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

    public static String m109uW() {
        if (C0462xq.m1540jB() >= 0) {
            return C0600.m12169();
        }
        return null;
    }

    public static Iterator m110vC(Object obj) {
        if (C0466vs.m1614uR() > 0) {
            return ((Deque) obj).iterator();
        }
        return null;
    }

    public static int m111vs() {
        return 1753577 ^ C0007WO.m118RN((Object) m98M(0, 3, 4281));
    }

    public static String m104fA(short[] sArr, int i, int i2, int i3) {
        char[] cArr = new char[i2];
        for (int i4 = 0; i4 < i2; i4++) {
            cArr[i4] = (char) (sArr[i + i4] ^ i3);
        }
        return new String(cArr);
    }
}
