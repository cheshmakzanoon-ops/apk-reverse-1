package com.google.common.math;

import java.math.BigInteger;
import java.math.RoundingMode;

@ElementTypesAreNonnullByDefault
final class MathPreconditions {
    static int checkPositive(String str, int i) {
        if (i > 0) {
            return i;
        }
        StringBuilder sb = new StringBuilder(String.valueOf(str).length() + 26);
        sb.append(str);
        sb.append(" (");
        sb.append(i);
        sb.append(") must be > 0");
        throw new IllegalArgumentException(sb.toString());
    }

    static long checkPositive(String str, long j) {
        if (j > 0) {
            return j;
        }
        StringBuilder sb = new StringBuilder(String.valueOf(str).length() + 35);
        sb.append(str);
        sb.append(" (");
        sb.append(j);
        sb.append(") must be > 0");
        throw new IllegalArgumentException(sb.toString());
    }

    static BigInteger checkPositive(String str, BigInteger bigInteger) {
        if (bigInteger.signum() > 0) {
            return bigInteger;
        }
        String strValueOf = String.valueOf(bigInteger);
        StringBuilder sb = new StringBuilder(String.valueOf(str).length() + 15 + String.valueOf(strValueOf).length());
        sb.append(str);
        sb.append(" (");
        sb.append(strValueOf);
        sb.append(") must be > 0");
        throw new IllegalArgumentException(sb.toString());
    }

    static int checkNonNegative(String str, int i) {
        if (i >= 0) {
            return i;
        }
        StringBuilder sb = new StringBuilder(String.valueOf(str).length() + 27);
        sb.append(str);
        sb.append(" (");
        sb.append(i);
        sb.append(") must be >= 0");
        throw new IllegalArgumentException(sb.toString());
    }

    static long checkNonNegative(String str, long j) {
        if (j >= 0) {
            return j;
        }
        StringBuilder sb = new StringBuilder(String.valueOf(str).length() + 36);
        sb.append(str);
        sb.append(" (");
        sb.append(j);
        sb.append(") must be >= 0");
        throw new IllegalArgumentException(sb.toString());
    }

    static BigInteger checkNonNegative(String str, BigInteger bigInteger) {
        if (bigInteger.signum() >= 0) {
            return bigInteger;
        }
        String strValueOf = String.valueOf(bigInteger);
        StringBuilder sb = new StringBuilder(String.valueOf(str).length() + 16 + String.valueOf(strValueOf).length());
        sb.append(str);
        sb.append(" (");
        sb.append(strValueOf);
        sb.append(") must be >= 0");
        throw new IllegalArgumentException(sb.toString());
    }

    static double checkNonNegative(String str, double d) {
        if (d >= 0.0d) {
            return d;
        }
        StringBuilder sb = new StringBuilder(String.valueOf(str).length() + 40);
        sb.append(str);
        sb.append(" (");
        sb.append(d);
        sb.append(") must be >= 0");
        throw new IllegalArgumentException(sb.toString());
    }

    static void checkRoundingUnnecessary(boolean z) {
        if (!z) {
            throw new ArithmeticException("mode was UNNECESSARY, but rounding was necessary");
        }
    }

    static void checkInRangeForRoundingInputs(boolean z, double d, RoundingMode roundingMode) {
        if (z) {
            return;
        }
        String strValueOf = String.valueOf(roundingMode);
        StringBuilder sb = new StringBuilder(String.valueOf(strValueOf).length() + 83);
        sb.append("rounded value is out of range for input ");
        sb.append(d);
        sb.append(" and rounding mode ");
        sb.append(strValueOf);
        throw new ArithmeticException(sb.toString());
    }

    static void checkNoOverflow(boolean z, String str, int i, int i2) {
        if (z) {
            return;
        }
        StringBuilder sb = new StringBuilder(String.valueOf(str).length() + 36);
        sb.append("overflow: ");
        sb.append(str);
        sb.append("(");
        sb.append(i);
        sb.append(", ");
        sb.append(i2);
        sb.append(")");
        throw new ArithmeticException(sb.toString());
    }

    static void checkNoOverflow(boolean z, String str, long j, long j2) {
        if (z) {
            return;
        }
        StringBuilder sb = new StringBuilder(String.valueOf(str).length() + 54);
        sb.append("overflow: ");
        sb.append(str);
        sb.append("(");
        sb.append(j);
        sb.append(", ");
        sb.append(j2);
        sb.append(")");
        throw new ArithmeticException(sb.toString());
    }

    private MathPreconditions() {
    }
}
