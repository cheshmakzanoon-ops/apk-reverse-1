package com.google.android.material.card2;

import java.io.UnsupportedEncodingException;

final class C0408on {

    private static final byte[] f1297ve = {65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 43, 47};

    private static final byte[] f1298vf = {65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 45, 95};

    private static String m1338a(byte[] bArr, byte[] bArr2) {
        byte[] bArr3 = new byte[((bArr.length + 2) / 3) * 4];
        int length = bArr.length - (bArr.length % 3);
        int i = 0;
        int i2 = 0;
        while (i < length) {
            int i3 = i2 + 1;
            bArr3[i2] = bArr2[(bArr[i] & 255) >> 2];
            int i4 = i3 + 1;
            bArr3[i3] = bArr2[((bArr[i] & 3) << 4) | ((bArr[i + 1] & 255) >> 4)];
            int i5 = i4 + 1;
            bArr3[i4] = bArr2[((bArr[i + 1] & 15) << 2) | ((bArr[i + 2] & 255) >> 6)];
            bArr3[i5] = bArr2[bArr[i + 2] & 63];
            i += 3;
            i2 = i5 + 1;
        }
        switch (bArr.length % 3) {
            case 1:
                int i6 = i2 + 1;
                bArr3[i2] = bArr2[(bArr[length] & 255) >> 2];
                int i7 = i6 + 1;
                bArr3[i6] = bArr2[(bArr[length] & 3) << 4];
                bArr3[i7] = 61;
                bArr3[i7 + 1] = 61;
                break;
            case 2:
                int i8 = i2 + 1;
                bArr3[i2] = bArr2[(bArr[length] & 255) >> 2];
                int i9 = i8 + 1;
                bArr3[i8] = bArr2[((bArr[length] & 3) << 4) | ((bArr[length + 1] & 255) >> 4)];
                int i10 = i9 + 1;
                bArr3[i9] = bArr2[(bArr[length + 1] & 15) << 2];
                int i11 = i10 + 1;
                bArr3[i10] = 61;
                break;
        }
        try {
            return new String(bArr3, abf.m2541());
        } catch (UnsupportedEncodingException e) {
            throw new AssertionError(e);
        }
    }

    public static String m1339c(byte[] bArr) {
        return m7752(bArr, m7753());
    }

    public static String m7750(Object obj, Object obj2) {
        if (C0446yb.m8415() <= 0) {
            return m1338a((byte[]) obj, (byte[]) obj2);
        }
        return null;
    }

    public static byte[] m7751() {
        if (C0457zc.m10735() <= 0) {
            return f1297ve;
        }
        return null;
    }

    public static String m7752(Object obj, Object obj2) {
        if (abd.m2162() >= 0) {
            return m7755(obj, obj2);
        }
        return null;
    }

    public static byte[] m7753() {
        if (abe.m2308() < 0) {
            return m7754();
        }
        return null;
    }

    public static byte[] m7754() {
        if (C0458ze.m10926() < 0) {
            return m7751();
        }
        return null;
    }

    public static String m7755(Object obj, Object obj2) {
        if (C0458ze.m10926() < 0) {
            return m7750((byte[]) obj, (byte[]) obj2);
        }
        return null;
    }
}
