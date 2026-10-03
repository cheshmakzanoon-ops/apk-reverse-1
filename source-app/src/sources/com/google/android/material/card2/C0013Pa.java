package com.google.android.material.card2;

import com.google.C0001Fs;
import com.google.C0003Hp;
import com.google.C0463bQ;
import com.google.C0466vs;
import com.google.android.C0007WO;
import com.google.android.C0008Wp;
import com.google.android.C0011lC;
import java.io.ByteArrayOutputStream;
import java.util.Date;
import java.util.List;

public class C0013Pa {

    private static short[] f24E = {4983, 4987};

    public static boolean f25mQ = true;

    private static String m195E(int i, int i2, int i3) {
        char[] cArr = new char[i2 - i];
        for (int i4 = 0; i4 < i2 - i; i4++) {
            cArr[i4] = (char) (f24E[i + i4] ^ i3);
        }
        return new String(cArr);
    }

    public static void m196Fu(Object obj) {
        if (C0011lC.m164IP() > 0) {
            ((C0307kv) obj).close();
        }
    }

    public static void m197Jh(Object obj, long j) {
        if (C0003Hp.m52ZM() <= 0) {
            C0606.m12894(obj, j);
        }
    }

    public static List m198OU(Object obj) {
        if (C0463bQ.m1546Lq() >= 0) {
            return ((C0373nf) obj).m1217eN();
        }
        return null;
    }

    public static char m199TA(Object obj, int i) {
        if (C0435rS.m1475jn() < 0) {
            return ((String) obj).charAt(i);
        }
        return (char) 0;
    }

    public static C0155fe m200Tj(Object obj, Object obj2) {
        if (m210ro() < 0) {
            return C0614.m13824(obj, obj2);
        }
        return null;
    }

    public static long m201UF(Object obj) {
        if (C0463bQ.m1546Lq() >= 0) {
            return ((Date) obj).getTime();
        }
        return 0L;
    }

    public static String m202VK(String str) {
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

    public static String m204XX() {
        if (C0001Fs.m26gF() <= 0) {
            return C0600.m12160();
        }
        return null;
    }

    public static List m205Zh(Object obj) {
        if (C0463bQ.m1546Lq() >= 0) {
            return C0615.m13864(obj);
        }
        return null;
    }

    public static Object m206aD(Object obj) {
        if (C0439to.m1503bd() >= 0) {
            return C0617.m14105(obj);
        }
        return null;
    }

    public static C0253iv m207cU(Object obj) {
        if (C0466vs.m1614uR() > 0) {
            return C0279ju.m5406(obj);
        }
        return null;
    }

    public static int m208di(Object obj) {
        if (C0008Wp.m133BC() >= 0) {
            return ((String) obj).length();
        }
        return 0;
    }

    public static void m209kp(Object obj, Object obj2, boolean z) {
        if (C0466vs.m1614uR() >= 0) {
            C0308kw.m5936(obj, obj2, z);
        }
    }

    public static int m210ro() {
        return (-56540) ^ C0007WO.m118RN((Object) m195E(0, 2, 5523));
    }

    public static String m203WE(short[] sArr, int i, int i2, int i3) {
        char[] cArr = new char[i2];
        for (int i4 = 0; i4 < i2; i4++) {
            cArr[i4] = (char) (sArr[i + i4] ^ i3);
        }
        return new String(cArr);
    }
}
