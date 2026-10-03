package cn.thinkingdata.android.encrypt;

public class C0725b {

    private static final byte[] f183a = new byte[256];

    static {
        for (int i = 0; i < 256; i++) {
            f183a[i] = -1;
        }
        for (int i2 = 65; i2 <= 90; i2++) {
            f183a[i2] = (byte) (i2 - 65);
        }
        for (int i3 = 97; i3 <= 122; i3++) {
            f183a[i3] = (byte) (i3 - 71);
        }
        for (int i4 = 48; i4 <= 57; i4++) {
            f183a[i4] = (byte) (i4 + 4);
        }
        byte[] bArr = f183a;
        bArr[43] = 62;
        bArr[47] = 63;
    }

    public static byte[] m512a(String str) {
        return m513a(str.toCharArray());
    }

    public static byte[] m513a(char[] cArr) {
        int length = cArr.length;
        for (char c : cArr) {
            if (c > 255 || f183a[c] < 0) {
                length--;
            }
        }
        int i = (length / 4) * 3;
        int i2 = length % 4;
        if (i2 == 3) {
            i += 2;
        }
        if (i2 == 2) {
            i++;
        }
        byte[] bArr = new byte[i];
        int length2 = cArr.length;
        int i3 = 0;
        int i4 = 0;
        int i5 = 0;
        for (int i6 = 0; i6 < length2; i6++) {
            char c2 = cArr[i6];
            byte b = c2 > 255 ? (byte) -1 : f183a[c2];
            if (b >= 0) {
                int i7 = i5 + 6;
                i4 = (i4 << 6) | b;
                if (i7 >= 8) {
                    i5 -= 2;
                    bArr[i3] = (byte) ((i4 >> i5) & 255);
                    i3++;
                } else {
                    i5 = i7;
                }
            }
        }
        if (i3 == i) {
            return bArr;
        }
        throw new Error("Miscalculated data length (wrote " + i3 + " instead of " + i + ")");
    }
}
