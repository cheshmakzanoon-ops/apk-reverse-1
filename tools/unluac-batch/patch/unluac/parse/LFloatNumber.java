/*
 * Patched copy of unluac 1.2.3.569's unluac/parse/LFloatNumber.
 *
 * Provenance: recovered from tools/unluac-batch/unluac.jar with jadx. The only
 * change is visibility: upstream declares `class LFloatNumber`, and unluac's
 * own decompile package constructs LFloatNumber from outside the package, so
 * the javac round-trip needs it public. Behaviour is untouched.
 */
package unluac.parse;

import unluac.decompile.PrintFlag;

public class LFloatNumber extends LNumber {
    public static final int NAN_SHIFT_OFFSET = 29;
    public final float number;
    public final LNumberType.NumberMode mode;

    public LFloatNumber(float number, LNumberType.NumberMode mode) {
        this.number = number;
        this.mode = mode;
    }

    @Override // unluac.parse.LNumber, unluac.parse.LObject
    public String toPrintString(int flags) {
        if (this.mode == LNumberType.NumberMode.MODE_NUMBER && this.number == Math.round(this.number)) {
            if (Float.floatToRawIntBits(this.number) == Float.floatToRawIntBits(-0.0f)) {
                return "-0";
            }
            return Integer.toString((int) this.number);
        }
        if (Float.isInfinite(this.number)) {
            return ((double) this.number) > 0.0d ? "1e9999" : "-1e9999";
        }
        if (Float.isNaN(this.number)) {
            if (PrintFlag.test(flags, 1)) {
                int bits = Float.floatToRawIntBits(this.number);
                int canonical = Float.floatToRawIntBits(Float.NaN);
                if (bits == canonical) {
                    return "NaN";
                }
                String sign = "+";
                if (bits < 0) {
                    bits ^= Integer.MIN_VALUE;
                    sign = "-";
                }
                long lbits = bits ^ canonical;
                return "NaN" + sign + Long.toHexString(lbits << 29);
            }
            return "(0/0)";
        }
        return Float.toString(this.number);
    }

    @Override // unluac.parse.LObject
    public boolean equals(Object o) {
        if (o instanceof LFloatNumber) {
            return Float.floatToRawIntBits(this.number) == Float.floatToRawIntBits(((LFloatNumber) o).number);
        }
        return (o instanceof LNumber) && value() == ((LNumber) o).value();
    }

    @Override // unluac.parse.LNumber
    public double value() {
        return this.number;
    }

    @Override // unluac.parse.LNumber
    public boolean integralType() {
        return false;
    }

    @Override // unluac.parse.LNumber
    public long bits() {
        return Float.floatToRawIntBits(this.number);
    }
}
