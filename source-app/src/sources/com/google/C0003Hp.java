package com.google;

import android.content.Context;
import com.google.android.C0007WO;
import com.google.android.C0008Wp;
import com.google.android.C0462xq;
import com.google.android.material.card2.C0013Pa;
import com.google.android.material.card2.C0155fe;
import com.google.android.material.card2.C0174fx;
import com.google.android.material.card2.C0329lq;
import com.google.android.material.card2.C0439to;
import com.google.android.material.card2.C0450yf;
import com.google.android.material.card2.C0458ze;
import com.google.android.material.card2.C0604;
import com.google.android.material.card2.C0605;
import com.google.android.material.card2.C0606;
import java.io.ByteArrayOutputStream;
import java.util.Collection;
import java.util.List;

public class C0003Hp {

    private static short[] f6d = {8069, 8069, 8064};

    public static int f7zS = 89;

    public static C0155fe m49XA(Object obj, Object obj2) {
        if (C0000Ax.m0Ix() < 0) {
            return C0604.m12617(obj, obj2);
        }
        return null;
    }

    public static void m50Xh(Object obj, boolean z) {
        if (C0008Wp.m133BC() >= 0) {
            C0605.m1521(obj, z);
        }
    }

    public static List m51Xw(Object obj) {
        if (C0439to.m1503bd() > 0) {
            return C0329lq.m6149(obj);
        }
        return null;
    }

    public static int m52ZM() {
        return (-1750757) ^ C0007WO.m118RN((Object) m53d(0, 3, 6502));
    }

    private static String m53d(int i, int i2, int i3) {
        char[] cArr = new char[i2 - i];
        for (int i4 = 0; i4 < i2 - i; i4++) {
            cArr[i4] = (char) (f6d[i + i4] ^ i3);
        }
        return new String(cArr);
    }

    public static byte[] m54ft(Object obj) {
        if (C0013Pa.m210ro() < 0) {
            return ((ByteArrayOutputStream) obj).toByteArray();
        }
        return null;
    }

    public static int m55jr() {
        if (C0462xq.m1540jB() >= 0) {
            return C0450yf.m9352();
        }
        return 0;
    }

    public static int m56mW() {
        if (C0002Hb.m40cP() < 0) {
            return C0458ze.m10932();
        }
        return 0;
    }

    public static String m57oD(String str) {
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

    public static Collection m58wa(Object obj) {
        if (C0462xq.m1540jB() >= 0) {
            return C0606.m12820(obj);
        }
        return null;
    }

    public static void m59xL(Object obj, long j) {
        if (C0001Fs.m26gF() < 0) {
            C0174fx.m501a((Context) obj, j);
        }
    }

    public static String m48HP(short[] sArr, int i, int i2, int i3) {
        char[] cArr = new char[i2];
        for (int i4 = 0; i4 < i2; i4++) {
            cArr[i4] = (char) (sArr[i + i4] ^ i3);
        }
        return new String(cArr);
    }
}
