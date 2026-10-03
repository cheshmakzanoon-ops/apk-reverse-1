package com.google.common.primitives;

import com.google.common.base.Ascii;
import com.google.common.base.Preconditions;
import java.util.Arrays;
import java.util.Comparator;

@ElementTypesAreNonnullByDefault
public final class SignedBytes {
    public static final byte MAX_POWER_OF_TWO = 64;

    public static int compare(byte b, byte b2) {
        return b - b2;
    }

    public static byte saturatedCast(long j) {
        if (j > 127) {
            return Ascii.DEL;
        }
        return j < -128 ? UnsignedBytes.MAX_POWER_OF_TWO : (byte) j;
    }

    private SignedBytes() {
    }

    public static byte checkedCast(long j) {
        byte b = (byte) j;
        Preconditions.checkArgument(((long) b) == j, "Out of range: %s", j);
        return b;
    }

    public static byte min(byte... bArr) {
        Preconditions.checkArgument(bArr.length > 0);
        byte b = bArr[0];
        for (int i = 1; i < bArr.length; i++) {
            byte b2 = bArr[i];
            if (b2 < b) {
                b = b2;
            }
        }
        return b;
    }

    public static byte max(byte... bArr) {
        Preconditions.checkArgument(bArr.length > 0);
        byte b = bArr[0];
        for (int i = 1; i < bArr.length; i++) {
            byte b2 = bArr[i];
            if (b2 > b) {
                b = b2;
            }
        }
        return b;
    }

    public static String join(String str, byte... bArr) {
        Preconditions.checkNotNull(str);
        if (bArr.length == 0) {
            return "";
        }
        StringBuilder sb = new StringBuilder(bArr.length * 5);
        sb.append((int) bArr[0]);
        for (int i = 1; i < bArr.length; i++) {
            sb.append(str);
            sb.append((int) bArr[i]);
        }
        return sb.toString();
    }

    public static Comparator<byte[]> lexicographicalComparator() {
        return LexicographicalComparator.INSTANCE;
    }

    private enum LexicographicalComparator implements Comparator<byte[]> {
        INSTANCE;

        @Override
        public int compare(byte[] bArr, byte[] bArr2) {
            int iMin = Math.min(bArr.length, bArr2.length);
            for (int i = 0; i < iMin; i++) {
                int iCompare = SignedBytes.compare(bArr[i], bArr2[i]);
                if (iCompare != 0) {
                    return iCompare;
                }
            }
            return bArr.length - bArr2.length;
        }

        @Override
        public String toString() {
            return "SignedBytes.lexicographicalComparator()";
        }
    }

    public static void sortDescending(byte[] bArr) {
        Preconditions.checkNotNull(bArr);
        sortDescending(bArr, 0, bArr.length);
    }

    public static void sortDescending(byte[] bArr, int i, int i2) {
        Preconditions.checkNotNull(bArr);
        Preconditions.checkPositionIndexes(i, i2, bArr.length);
        Arrays.sort(bArr, i, i2);
        Bytes.reverse(bArr, i, i2);
    }
}
