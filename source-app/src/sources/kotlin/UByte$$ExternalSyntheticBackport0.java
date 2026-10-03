package kotlin;

import java.lang.reflect.Method;

public final class UByte$$ExternalSyntheticBackport0 {
    public static int m26m(int i, int i2) {
        return (int) ((((long) i) & 4294967295L) / (((long) i2) & 4294967295L));
    }

    public static int m27m(long j) {
        return (int) (j ^ (j >>> 32));
    }

    public static int m29m(Method method) {
        return method.getParameterTypes().length;
    }

    public static int m30m(boolean z) {
        return z ? 1231 : 1237;
    }

    public static long m31m(long j, long j2) {
        if (j2 < 0) {
            return (j ^ Long.MIN_VALUE) < (j2 ^ Long.MIN_VALUE) ? j : j - j2;
        }
        if (j >= 0) {
            return j % j2;
        }
        long j3 = j - ((((j >>> 1) / j2) << 1) * j2);
        if ((j3 ^ Long.MIN_VALUE) < (j2 ^ Long.MIN_VALUE)) {
            j2 = 0;
        }
        return j3 - j2;
    }

    public static String m33m(int i, int i2) {
        return Long.toString(((long) i) & 4294967295L, i2);
    }

    public static String m35m(long j, int i) {
        if (j == 0) {
            return "0";
        }
        if (j > 0) {
            return Long.toString(j, i);
        }
        if (i < 2 || i > 36) {
            i = 10;
        }
        int i2 = 64;
        char[] cArr = new char[64];
        int i3 = i - 1;
        if ((i & i3) == 0) {
            int iNumberOfTrailingZeros = Integer.numberOfTrailingZeros(i);
            do {
                i2--;
                cArr[i2] = Character.forDigit(((int) j) & i3, i);
                j >>>= iNumberOfTrailingZeros;
            } while (j != 0);
        } else {
            long jM$1 = (i & 1) == 0 ? (j >>> 1) / ((long) (i >>> 1)) : m$1(j, i);
            long j2 = i;
            cArr[63] = Character.forDigit((int) (j - (jM$1 * j2)), i);
            i2 = 63;
            while (jM$1 > 0) {
                i2--;
                cArr[i2] = Character.forDigit((int) (jM$1 % j2), i);
                jM$1 /= j2;
            }
        }
        return new String(cArr, i2, 64 - i2);
    }

    public static int m$1(int i, int i2) {
        return (int) ((((long) i) & 4294967295L) % (((long) i2) & 4294967295L));
    }

    public static long m$1(long j, long j2) {
        if (j2 < 0) {
            return (j ^ Long.MIN_VALUE) < (j2 ^ Long.MIN_VALUE) ? 0L : 1L;
        }
        if (j >= 0) {
            return j / j2;
        }
        long j3 = ((j >>> 1) / j2) << 1;
        return j3 + ((long) (((j - (j3 * j2)) ^ Long.MIN_VALUE) < (j2 ^ Long.MIN_VALUE) ? 0 : 1));
    }

    public static String m$1(long j, int i) {
        if (j == 0) {
            return "0";
        }
        if (j > 0) {
            return Long.toString(j, i);
        }
        if (i < 2 || i > 36) {
            i = 10;
        }
        int i2 = 64;
        char[] cArr = new char[64];
        int i3 = i - 1;
        if ((i & i3) == 0) {
            int iNumberOfTrailingZeros = Integer.numberOfTrailingZeros(i);
            do {
                i2--;
                cArr[i2] = Character.forDigit(((int) j) & i3, i);
                j >>>= iNumberOfTrailingZeros;
            } while (j != 0);
        } else {
            long jM$1 = (i & 1) == 0 ? (j >>> 1) / ((long) (i >>> 1)) : m$1(j, i);
            long j2 = i;
            cArr[63] = Character.forDigit((int) (j - (jM$1 * j2)), i);
            i2 = 63;
            while (jM$1 > 0) {
                i2--;
                cArr[i2] = Character.forDigit((int) (jM$1 % j2), i);
                jM$1 /= j2;
            }
        }
        return new String(cArr, i2, 64 - i2);
    }

    public static String m$2(long j, int i) {
        if (j == 0) {
            return "0";
        }
        if (j > 0) {
            return Long.toString(j, i);
        }
        if (i < 2 || i > 36) {
            i = 10;
        }
        int i2 = 64;
        char[] cArr = new char[64];
        int i3 = i - 1;
        if ((i & i3) == 0) {
            int iNumberOfTrailingZeros = Integer.numberOfTrailingZeros(i);
            do {
                i2--;
                cArr[i2] = Character.forDigit(((int) j) & i3, i);
                j >>>= iNumberOfTrailingZeros;
            } while (j != 0);
        } else {
            long jM$1 = (i & 1) == 0 ? (j >>> 1) / ((long) (i >>> 1)) : m$1(j, i);
            long j2 = i;
            cArr[63] = Character.forDigit((int) (j - (jM$1 * j2)), i);
            i2 = 63;
            while (jM$1 > 0) {
                i2--;
                cArr[i2] = Character.forDigit((int) (jM$1 % j2), i);
                jM$1 /= j2;
            }
        }
        return new String(cArr, i2, 64 - i2);
    }
}
