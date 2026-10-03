package com.google.android;

import com.google.C0003Hp;
import com.google.C0465uW;
import com.google.android.material.card2.C0247ip;
import com.google.android.material.card2.C0290ke;
import com.google.android.material.card2.C0291kf;
import com.google.android.material.card2.C0412or;
import com.google.android.material.card2.C0430pi;
import com.google.android.material.card2.C0435rS;
import com.google.android.material.card2.C0436rd;
import com.google.android.material.card2.C0452yh;
import com.google.android.material.card2.C0601;
import com.google.android.material.card2.C0605;
import com.google.android.material.card2.C0606;
import com.google.android.material.card2.C0612;
import com.google.android.material.card2.InterfaceC0240ii;
import com.google.android.material.card2.abf;
import java.io.ByteArrayOutputStream;

public class C0011lC {

    public static boolean f20YY = true;

    private static short[] f21l = {4530, 4532, 4529};

    public static InterfaceC0240ii m163Fy(Object obj) {
        if (C0435rS.m1475jn() < 0) {
            return C0606.m12817(obj);
        }
        return null;
    }

    public static int m164IP() {
        return 1750666 ^ C0007WO.m118RN((Object) m173l(0, 3, 5969));
    }

    public static int m165KO() {
        if (C0008Wp.m133BC() >= 0) {
            return C0601.m12304();
        }
        return 0;
    }

    public static int m166ON() {
        if (C0008Wp.m133BC() >= 0) {
            return C0452yh.m9798();
        }
        return 0;
    }

    public static String m167OU() {
        if (C0435rS.m1475jn() <= 0) {
            return C0606.m12837();
        }
        return null;
    }

    public static void m168ZN(Object obj, int i) {
        if (C0007WO.m123cB() <= 0) {
            ((ByteArrayOutputStream) obj).write(i);
        }
    }

    public static boolean m169de(Object obj) {
        if (C0465uW.m1596OL() >= 0) {
            return C0430pi.m8176(obj);
        }
        return false;
    }

    public static C0412or m170fP(Object obj) {
        if (C0003Hp.m52ZM() <= 0) {
            return C0247ip.m4938(obj);
        }
        return null;
    }

    public static String m171fs() {
        if (C0435rS.m1475jn() <= 0) {
            return C0605.m12728();
        }
        return null;
    }

    private static String m173l(int i, int i2, int i3) {
        char[] cArr = new char[i2 - i];
        for (int i4 = 0; i4 < i2 - i; i4++) {
            cArr[i4] = (char) (f21l[i + i4] ^ i3);
        }
        return new String(cArr);
    }

    public static String m174pE(String str) {
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

    public static String m175qr() {
        if (C0436rd.m1495pE() < 0) {
            return C0612.m13544();
        }
        return null;
    }

    public static C0290ke m176rV(Object obj) {
        if (C0008Wp.m133BC() >= 0) {
            return ((C0291kf) obj).m911ds();
        }
        return null;
    }

    public static int m177tb() {
        if (C0007WO.m123cB() < 0) {
            return abf.m2510();
        }
        return 0;
    }

    public static String m172ha(short[] sArr, int i, int i2, int i3) {
        char[] cArr = new char[i2];
        for (int i4 = 0; i4 < i2; i4++) {
            cArr[i4] = (char) (sArr[i + i4] ^ i3);
        }
        return new String(cArr);
    }
}
