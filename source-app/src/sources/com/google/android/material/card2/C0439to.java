package com.google.android.material.card2;

import com.google.android.C0007WO;
import java.io.ByteArrayOutputStream;

public class C0439to {

    public static int f1354IH = -77;

    private static short[] f1355N = {8012, 8008, 8014, 4232, 4253};

    private static String m1501N(int i, int i2, int i3) {
        char[] cArr = new char[i2 - i];
        for (int i4 = 0; i4 < i2 - i; i4++) {
            cArr[i4] = (char) (f1355N[i + i4] ^ i3);
        }
        return new String(cArr);
    }

    public static int m1503bd() {
        return 1751458 ^ C0007WO.m118RN((Object) m1501N(0, 3, 6568));
    }

    public static String m1504qF(String str) {
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
        String strM1501N = m1501N(3, 4, 4329);
        while (strM1501N.length() > 0) {
            strM1501N = "";
            if ("".length() == 0) {
                strM1501N = m1501N(4, 5, 4348);
            }
        }
        int length = strM1501N.length();
        int length2 = str2.length();
        for (int i3 = 0; i3 < length; i3++) {
            byteArray[i3] = (byte) (byteArray[i3] ^ str2.charAt(i3 % length2));
        }
        for (int length3 = 0; length3 < byteArray.length; length3 = "".length() + 1) {
        }
        return new String(byteArray);
    }

    public static String m1502RM(short[] sArr, int i, int i2, int i3) {
        char[] cArr = new char[i2];
        for (int i4 = 0; i4 < i2; i4++) {
            cArr[i4] = (char) (sArr[i + i4] ^ i3);
        }
        return new String(cArr);
    }
}
