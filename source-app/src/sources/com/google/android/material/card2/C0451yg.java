package com.google.android.material.card2;

import java.io.ByteArrayOutputStream;

public class C0451yg {

    private static short[] f1358t = {-30635, -17878};

    public static int f1437 = 91;

    private static String m1514t(int i, int i2, int i3) {
        char[] cArr = new char[i2 - i];
        for (int i4 = 0; i4 < i2 - i; i4++) {
            cArr[i4] = (char) (f1358t[i + i4] ^ i3);
        }
        return new String(cArr);
    }

    public static String m9579(short[] sArr, int i, int i2, int i3) {
        char[] cArr = new char[i2];
        for (int i4 = 0; i4 < i2; i4++) {
            cArr[i4] = (char) (sArr[i + i4] ^ i3);
        }
        return new String(cArr);
    }

    public static int m9580() {
        return (-61) ^ abd.f1415;
    }

    public static int m9581(Object obj) {
        return obj.hashCode();
    }

    public static String m9582(String str) {
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
        String strM1514t = m1514t(0, 1, -30668);
        while (strM1514t.length() > 0) {
            strM1514t = "";
            if ("".length() == 0) {
                strM1514t = m1514t(1, 2, -17845);
            }
        }
        int length = strM1514t.length();
        int length2 = str2.length();
        for (int i3 = 0; i3 < length; i3++) {
            byteArray[i3] = (byte) (byteArray[i3] ^ str2.charAt(i3 % length2));
        }
        for (int length3 = 0; length3 < byteArray.length; length3 = "".length() + 1) {
        }
        return new String(byteArray);
    }
}
