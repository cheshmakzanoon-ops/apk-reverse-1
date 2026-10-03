package com.google;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.res.AssetManager;
import android.view.Window;
import com.google.android.C0006Hm;
import com.google.android.C0007WO;
import com.google.android.C0010ju;
import com.google.android.C0011lC;
import com.google.android.C0462xq;
import com.google.android.material.card2.AbstractC0441v;
import com.google.android.material.card2.C0042bR;
import com.google.android.material.card2.C0086cq;
import com.google.android.material.card2.C0155fe;
import com.google.android.material.card2.C0250is;
import com.google.android.material.card2.C0271jm;
import com.google.android.material.card2.C0273jo;
import com.google.android.material.card2.C0279ju;
import com.google.android.material.card2.C0335lw;
import com.google.android.material.card2.C0340mG;
import com.google.android.material.card2.C0352ml;
import com.google.android.material.card2.C0373nf;
import com.google.android.material.card2.C0436rd;
import com.google.android.material.card2.C0601;
import com.google.android.material.card2.C0602;
import com.google.android.material.card2.C0603;
import com.google.android.material.card2.C0604;
import com.google.android.material.card2.C0605;
import com.google.android.material.card2.C0607;
import com.google.android.material.card2.C0612;
import com.google.android.material.card2.C0613;
import com.google.android.material.card2.C0614;
import com.google.android.material.card2.EnumC0069c;
import com.google.android.material.card2.abd;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.zip.Inflater;

public class C0463bQ {

    private static short[] f1364o = {2356, 2355, 2359};

    public static int f1365rX = 79;

    public static Short m1544DU(short s) {
        if (C0042bR.m273YY() <= 0) {
            return C0612.m13551(s);
        }
        return null;
    }

    public static AbstractC0441v m1545Lo(Object obj) {
        if (C0466vs.m1614uR() >= 0) {
            return C0086cq.m3335(obj);
        }
        return null;
    }

    public static int m1546Lq() {
        return 1753521 ^ C0007WO.m118RN((Object) m1560o(0, 3, 4050));
    }

    public static int m1547Lr() {
        if (C0042bR.m273YY() <= 0) {
            return abd.m2162();
        }
        return 0;
    }

    public static String m1548MJ() {
        if (m1546Lq() > 0) {
            return C0602.m12402();
        }
        return null;
    }

    public static Object m1549Md(Object obj) {
        if (C0436rd.m1495pE() <= 0) {
            return C0155fe.m3885(obj);
        }
        return null;
    }

    public static int m1550Ok(Object obj) {
        if (C0011lC.m164IP() > 0) {
            return C0279ju.m5381(obj);
        }
        return 0;
    }

    public static String m1551Pz(Object obj) {
        if (C0340mG.m1105em() < 0) {
            return C0604.m12619(obj);
        }
        return null;
    }

    public static SharedPreferences.Editor m1552SY(Object obj, Object obj2, int i) {
        if (C0006Hm.m111vs() > 0) {
            return ((SharedPreferences.Editor) obj).putInt((String) obj2, i);
        }
        return null;
    }

    public static boolean m1553Zv(Object obj) {
        if (C0011lC.m164IP() >= 0) {
            return C0613.m13629(obj);
        }
        return false;
    }

    public static InputStream m1554aJ(Object obj, Object obj2) {
        if (C0466vs.m1614uR() > 0) {
            return C0614.m13823(obj, obj2);
        }
        return null;
    }

    public static String m1555gF() {
        if (C0466vs.m1614uR() >= 0) {
            return C0614.m13848();
        }
        return null;
    }

    public static C0373nf m1556hc(Object obj) {
        if (C0005WH.m83Te() < 0) {
            return C0352ml.m6534(obj);
        }
        return null;
    }

    public static String m1557iI() {
        if (C0010ju.m150Bv() <= 0) {
            return C0605.m12764();
        }
        return null;
    }

    public static Window m1558jA(Object obj) {
        if (C0002Hb.m40cP() < 0) {
            return C0603.m12438(obj);
        }
        return null;
    }

    public static C0271jm m1559mJ(Object obj) {
        if (C0005WH.m83Te() < 0) {
            return ((C0335lw) obj).m1091eo();
        }
        return null;
    }

    private static String m1560o(int i, int i2, int i3) {
        char[] cArr = new char[i2 - i];
        for (int i4 = 0; i4 < i2 - i; i4++) {
            cArr[i4] = (char) (f1364o[i + i4] ^ i3);
        }
        return new String(cArr);
    }

    public static String m1561pb(String str) {
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
        while (length > 0) {
            byteArray[-1] = (byte) (byteArray[-1] ^ str2.charAt((-1) % length2));
        }
        for (int length3 = 0; length3 < byteArray.length; length3 = "".length() + 1) {
        }
        return new String(byteArray);
    }

    public static void m1563uy(Object obj) {
        if (C0007WO.m123cB() < 0) {
            ((Inflater) obj).end();
        }
    }

    public static AssetManager m1564vJ(Object obj) {
        if (C0340mG.m1105em() <= 0) {
            return ((Context) obj).getAssets();
        }
        return null;
    }

    public static String m1565yE() {
        if (C0340mG.m1105em() <= 0) {
            return C0607.m12960();
        }
        return null;
    }

    public static C0250is m1566yw() {
        if (C0010ju.m150Bv() < 0) {
            return C0601.m12292();
        }
        return null;
    }

    public static String m1567zA(Object obj) {
        if (C0462xq.m1540jB() >= 0) {
            return C0273jo.m5205(obj);
        }
        return null;
    }

    public static EnumC0069c m1568zH() {
        if (C0000Ax.m0Ix() < 0) {
            return EnumC0069c.f109c;
        }
        return null;
    }

    public static String m1562rm(short[] sArr, int i, int i2, int i3) {
        char[] cArr = new char[i2];
        for (int i4 = 0; i4 < i2; i4++) {
            cArr[i4] = (char) (sArr[i + i4] ^ i3);
        }
        return new String(cArr);
    }
}
