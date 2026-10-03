package cn.thinkingdata.android.utils;

public class C0750a {

    private static final char[] f242a = new char[64];

    private static final byte[] f243b;

    static {
        char c = 'A';
        int i = 0;
        while (c <= 'Z') {
            f242a[i] = c;
            c = (char) (c + 1);
            i++;
        }
        char c2 = 'a';
        while (c2 <= 'z') {
            f242a[i] = c2;
            c2 = (char) (c2 + 1);
            i++;
        }
        char c3 = '0';
        while (c3 <= '9') {
            f242a[i] = c3;
            c3 = (char) (c3 + 1);
            i++;
        }
        char[] cArr = f242a;
        cArr[i] = '+';
        cArr[i + 1] = '/';
        f243b = new byte[128];
        int i2 = 0;
        while (true) {
            byte[] bArr = f243b;
            if (i2 >= bArr.length) {
                break;
            }
            bArr[i2] = -1;
            i2++;
        }
        for (int i3 = 0; i3 < 64; i3++) {
            f243b[f242a[i3]] = (byte) i3;
        }
    }

    public static char[] m689a(byte[] bArr) {
        return m690a(bArr, bArr.length);
    }

    public static char[] m690a(byte[] bArr, int i) {
        int i2;
        int i3;
        int i4 = ((i * 4) + 2) / 3;
        char[] cArr = new char[((i + 2) / 3) * 4];
        int i5 = 0;
        int i6 = 0;
        while (i5 < i) {
            int i7 = i5 + 1;
            byte b = bArr[i5];
            int i8 = b & 255;
            if (i7 < i) {
                int i9 = bArr[i7] & 255;
                i7 = i5 + 2;
                i2 = i9;
            } else {
                i2 = 0;
            }
            if (i7 < i) {
                i3 = bArr[i7] & 255;
                i7++;
            } else {
                i3 = 0;
            }
            int i10 = ((b & 3) << 4) | (i2 >>> 4);
            int i11 = ((i2 & 15) << 2) | (i3 >>> 6);
            char[] cArr2 = f242a;
            cArr[i6] = cArr2[i8 >>> 2];
            int i12 = i6 + 2;
            cArr[i6 + 1] = cArr2[i10];
            char c = '=';
            cArr[i12] = i12 < i4 ? cArr2[i11] : '=';
            int i13 = i6 + 3;
            int i14 = i3 & 63;
            if (i13 < i4) {
                c = cArr2[i14];
            }
            cArr[i13] = c;
            i6 += 4;
            i5 = i7;
        }
        return cArr;
    }
}
