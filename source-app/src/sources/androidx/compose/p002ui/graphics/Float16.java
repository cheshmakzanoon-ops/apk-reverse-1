package androidx.compose.p002ui.graphics;

import androidx.compose.foundation.text.input.internal.PartialGapBuffer;
import kotlin.Metadata;
import kotlin.jvm.JvmInline;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.text.CharsKt;
import kotlin.text.Regex;

@Metadata(d1 = {"\u0000N\n\u0002\u0018\u0002\n\u0002\u0010\u000f\n\u0000\n\u0002\u0010\u0007\n\u0002\b\u0002\n\u0002\u0010\u0006\n\u0002\b\u0002\n\u0002\u0010\n\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0011\n\u0002\u0010\u000b\n\u0002\u0010\u0000\n\u0002\b\u0014\n\u0002\u0010\u0005\n\u0002\b\t\n\u0002\u0010\u000e\n\u0002\b\u0005\n\u0002\u0010\t\n\u0002\b\u000f\b\u0081@\u0018\u0000 R2\b\u0012\u0004\u0012\u00020\u00000\u0001:\u0001RB\u0011\b\u0016\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0004\b\u0004\u0010\u0005B\u0011\b\u0016\u0012\u0006\u0010\u0002\u001a\u00020\u0006¢\u0006\u0004\b\u0004\u0010\u0007B\u000f\u0012\u0006\u0010\b\u001a\u00020\t¢\u0006\u0004\b\u0004\u0010\nJ\u0013\u0010\u0015\u001a\u00020\u0000ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b\u0016\u0010\nJ\u0013\u0010\u0017\u001a\u00020\u0000ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b\u0018\u0010\nJ\u001b\u0010\u0019\u001a\u00020\f2\u0006\u0010\u001a\u001a\u00020\u0000H\u0096\u0002ø\u0001\u0000¢\u0006\u0004\b\u001b\u0010\u001cJ\u001a\u0010\u001d\u001a\u00020\u001e2\b\u0010\u001a\u001a\u0004\u0018\u00010\u001fHÖ\u0003¢\u0006\u0004\b \u0010!J\u0013\u0010\"\u001a\u00020\u0000ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b#\u0010\nJ\u0010\u0010$\u001a\u00020\fHÖ\u0001¢\u0006\u0004\b%\u0010\u000eJ\r\u0010&\u001a\u00020\u001e¢\u0006\u0004\b'\u0010(J\r\u0010)\u001a\u00020\u001e¢\u0006\u0004\b*\u0010(J\r\u0010+\u001a\u00020\u001e¢\u0006\u0004\b,\u0010(J\r\u0010-\u001a\u00020\u001e¢\u0006\u0004\b.\u0010(J\u0013\u0010/\u001a\u00020\u0000ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b0\u0010\nJ\r\u00101\u001a\u00020\f¢\u0006\u0004\b2\u0010\u000eJ\r\u00103\u001a\u000204¢\u0006\u0004\b5\u00106J\r\u00107\u001a\u00020\u0006¢\u0006\u0004\b8\u00109J\r\u0010:\u001a\u00020\u0003¢\u0006\u0004\b;\u0010<J\r\u0010=\u001a\u00020>¢\u0006\u0004\b?\u0010@J\r\u0010A\u001a\u00020\f¢\u0006\u0004\bB\u0010\u000eJ\r\u0010C\u001a\u00020D¢\u0006\u0004\bE\u0010FJ\r\u0010G\u001a\u00020\f¢\u0006\u0004\bH\u0010\u000eJ\r\u0010I\u001a\u00020\t¢\u0006\u0004\bJ\u0010\nJ\u000f\u0010K\u001a\u00020>H\u0016¢\u0006\u0004\bL\u0010@J\u0013\u0010M\u001a\u00020\u0000ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\bN\u0010\nJ\u0018\u0010O\u001a\u00020\u00002\u0006\u0010\u0011\u001a\u00020\u0000ø\u0001\u0000¢\u0006\u0004\bP\u0010QR\u0011\u0010\u000b\u001a\u00020\f8F¢\u0006\u0006\u001a\u0004\b\r\u0010\u000eR\u0011\u0010\b\u001a\u00020\t¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010R\u0017\u0010\u0011\u001a\u00020\u00008Fø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\u0012\u0010\nR\u0011\u0010\u0013\u001a\u00020\f8F¢\u0006\u0006\u001a\u0004\b\u0014\u0010\u000e\u0088\u0001\b\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006S"}, d2 = {"Landroidx/compose/ui/graphics/Float16;", "", "value", "", "constructor-impl", "(F)S", "", "(D)S", "halfValue", "", "(S)S", "exponent", "", "getExponent-impl", "(S)I", "getHalfValue", "()S", "sign", "getSign-slo4al4", "significand", "getSignificand-impl", "absoluteValue", "absoluteValue-slo4al4", "ceil", "ceil-slo4al4", "compareTo", "other", "compareTo-41bOqos", "(SS)I", "equals", "", "", "equals-impl", "(SLjava/lang/Object;)Z", "floor", "floor-slo4al4", "hashCode", "hashCode-impl", "isFinite", "isFinite-impl", "(S)Z", "isInfinite", "isInfinite-impl", "isNaN", "isNaN-impl", "isNormalized", "isNormalized-impl", "round", "round-slo4al4", "toBits", "toBits-impl", "toByte", "", "toByte-impl", "(S)B", "toDouble", "toDouble-impl", "(S)D", "toFloat", "toFloat-impl", "(S)F", "toHexString", "", "toHexString-impl", "(S)Ljava/lang/String;", "toInt", "toInt-impl", "toLong", "", "toLong-impl", "(S)J", "toRawBits", "toRawBits-impl", "toShort", "toShort-impl", "toString", "toString-impl", "trunc", "trunc-slo4al4", "withSign", "withSign-qCeQghg", "(SS)S", "Companion", "ui-graphics_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
@JvmInline
public final class Float16 implements Comparable<Float16> {
    public static final int MaxExponent = 15;
    public static final int MinExponent = -14;
    public static final int Size = 16;
    private final short halfValue;

    public static final Companion INSTANCE = new Companion(null);
    private static final short Epsilon = m4699constructorimpl((short) 5120);
    private static final short LowestValue = m4699constructorimpl((short) -1025);
    private static final short MaxValue = m4699constructorimpl((short) 31743);
    private static final short MinNormal = m4699constructorimpl((short) 1024);
    private static final short MinValue = m4699constructorimpl((short) 1);
    private static final short NaN = m4699constructorimpl((short) 32256);
    private static final short NegativeInfinity = m4699constructorimpl((short) -1024);
    private static final short NegativeZero = m4699constructorimpl(Short.MIN_VALUE);
    private static final short PositiveInfinity = m4699constructorimpl((short) 31744);
    private static final short PositiveZero = m4699constructorimpl((short) 0);

    public static final Float16 m4694boximpl(short s) {
        return new Float16(s);
    }

    public static short m4699constructorimpl(short s) {
        return s;
    }

    public static boolean m4700equalsimpl(short s, Object obj) {
        return (obj instanceof Float16) && s == ((Float16) obj).m4725unboximpl();
    }

    public static final boolean m4701equalsimpl0(short s, short s2) {
        return s == s2;
    }

    public static final int m4703getExponentimpl(short s) {
        return ((s >>> 10) & 31) - 15;
    }

    public static final int m4705getSignificandimpl(short s) {
        return s & 1023;
    }

    public static int m4706hashCodeimpl(short s) {
        return s;
    }

    public static final boolean m4707isFiniteimpl(short s) {
        return (s & Short.MAX_VALUE) != 31744;
    }

    public static final boolean m4708isInfiniteimpl(short s) {
        return (s & Short.MAX_VALUE) == 31744;
    }

    public static final boolean m4709isNaNimpl(short s) {
        return (s & Short.MAX_VALUE) > 31744;
    }

    public static final boolean m4710isNormalizedimpl(short s) {
        int i = s & 31744;
        return (i == 0 || i == 31744) ? false : true;
    }

    public static final int m4719toRawBitsimpl(short s) {
        return s & 65535;
    }

    public boolean equals(Object obj) {
        return m4700equalsimpl(this.halfValue, obj);
    }

    public int hashCode() {
        return m4706hashCodeimpl(this.halfValue);
    }

    public final short m4725unboximpl() {
        return this.halfValue;
    }

    @Override
    public int compareTo(Float16 float16) {
        return m4724compareTo41bOqos(float16.m4725unboximpl());
    }

    private Float16(short s) {
        this.halfValue = s;
    }

    public final short getHalfValue() {
        return this.halfValue;
    }

    public static short m4697constructorimpl(double d) {
        return m4698constructorimpl((float) d);
    }

    public static final byte m4713toByteimpl(short s) {
        return (byte) m4715toFloatimpl(s);
    }

    public static final short m4720toShortimpl(short s) {
        return (short) m4715toFloatimpl(s);
    }

    public static final int m4717toIntimpl(short s) {
        return (int) m4715toFloatimpl(s);
    }

    public static final long m4718toLongimpl(short s) {
        return (long) m4715toFloatimpl(s);
    }

    public static final double m4714toDoubleimpl(short s) {
        return m4715toFloatimpl(s);
    }

    public static final int m4712toBitsimpl(short s) {
        return m4709isNaNimpl(s) ? NaN : s & 65535;
    }

    public static String m4721toStringimpl(short s) {
        return String.valueOf(m4715toFloatimpl(s));
    }

    public String toString() {
        return m4721toStringimpl(this.halfValue);
    }

    public int m4724compareTo41bOqos(short s) {
        return m4696compareTo41bOqos(this.halfValue, s);
    }

    public static int m4696compareTo41bOqos(short s, short s2) {
        if (m4709isNaNimpl(s)) {
            return !m4709isNaNimpl(s2) ? 1 : 0;
        }
        if (m4709isNaNimpl(s2)) {
            return -1;
        }
        return Intrinsics.compare((s & Short.MIN_VALUE) != 0 ? Fields.CompositingStrategy - (s & 65535) : s & 65535, (s2 & Short.MIN_VALUE) != 0 ? Fields.CompositingStrategy - (s2 & 65535) : s2 & 65535);
    }

    public static final short m4704getSignslo4al4(short s) {
        if (m4709isNaNimpl(s)) {
            return NaN;
        }
        if (m4696compareTo41bOqos(s, NegativeZero) < 0) {
            return Float16Kt.NegativeOne;
        }
        return m4696compareTo41bOqos(s, PositiveZero) > 0 ? Float16Kt.One : s;
    }

    public static final short m4723withSignqCeQghg(short s, short s2) {
        return m4699constructorimpl((short) ((s & Short.MAX_VALUE) | (s2 & Short.MIN_VALUE)));
    }

    public static final short m4693absoluteValueslo4al4(short s) {
        return m4699constructorimpl((short) (s & Short.MAX_VALUE));
    }

    public static final short m4711roundslo4al4(short s) {
        int i = s & 65535;
        int i2 = s & Short.MAX_VALUE;
        if (i2 < 15360) {
            i = (s & Short.MIN_VALUE) | ((i2 < 14336 ? 0 : 65535) & 15360);
        } else if (i2 < 25600) {
            int i3 = i2 >> 10;
            i = (i + (1 << (24 - i3))) & (~((1 << (25 - i3)) - 1));
        }
        return m4699constructorimpl((short) i);
    }

    public static final short m4695ceilslo4al4(short s) {
        int i = 65535 & s;
        int i2 = s & Short.MAX_VALUE;
        if (i2 < 15360) {
            i = ((-((~(i >> 15)) & (i2 == 0 ? 0 : 1))) & 15360) | (s & Short.MIN_VALUE);
        } else if (i2 < 25600) {
            int i3 = (1 << (25 - (i2 >> 10))) - 1;
            i = (i + (((i >> 15) - 1) & i3)) & (~i3);
        }
        return m4699constructorimpl((short) i);
    }

    public static final short m4702floorslo4al4(short s) {
        int i = s & 65535;
        int i2 = s & Short.MAX_VALUE;
        if (i2 < 15360) {
            i = (s & Short.MIN_VALUE) | ((i <= 32768 ? 0 : 65535) & 15360);
        } else if (i2 < 25600) {
            int i3 = (1 << (25 - (i2 >> 10))) - 1;
            i = (i + ((-(i >> 15)) & i3)) & (~i3);
        }
        return m4699constructorimpl((short) i);
    }

    public static final short m4722truncslo4al4(short s) {
        int i = 65535 & s;
        int i2 = s & Short.MAX_VALUE;
        if (i2 < 15360) {
            i = Short.MIN_VALUE & s;
        } else if (i2 < 25600) {
            i &= ~((1 << (25 - (i2 >> 10))) - 1);
        }
        return m4699constructorimpl((short) i);
    }

    public static final String m4716toHexStringimpl(short s) {
        StringBuilder sb = new StringBuilder();
        int i = 65535 & s;
        int i2 = i >>> 15;
        int i3 = (i >>> 10) & 31;
        int i4 = s & 1023;
        if (i3 != 31) {
            if (i2 == 1) {
                sb.append('-');
            }
            if (i3 != 0) {
                sb.append("0x1.");
                String string = Integer.toString(i4, CharsKt.checkRadix(16));
                Intrinsics.checkNotNullExpressionValue(string, "toString(this, checkRadix(radix))");
                sb.append(new Regex("0{2,}$").replaceFirst(string, ""));
                sb.append('p');
                sb.append(String.valueOf(i3 - 15));
            } else if (i4 == 0) {
                sb.append("0x0.0p0");
            } else {
                sb.append("0x0.");
                String string2 = Integer.toString(i4, CharsKt.checkRadix(16));
                Intrinsics.checkNotNullExpressionValue(string2, "toString(this, checkRadix(radix))");
                sb.append(new Regex("0{2,}$").replaceFirst(string2, ""));
                sb.append("p-14");
            }
        } else if (i4 == 0) {
            if (i2 != 0) {
                sb.append('-');
            }
            sb.append("Infinity");
        } else {
            sb.append("NaN");
        }
        return sb.toString();
    }

    @Metadata(d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\b\n\u0002\b\u0013\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u0019\u0010\u0003\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0005\u0010\u0006R\u0019\u0010\b\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\t\u0010\u0006R\u000e\u0010\n\u001a\u00020\u000bX\u0086T¢\u0006\u0002\n\u0000R\u0019\u0010\f\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\r\u0010\u0006R\u000e\u0010\u000e\u001a\u00020\u000bX\u0086T¢\u0006\u0002\n\u0000R\u0019\u0010\u000f\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0010\u0010\u0006R\u0019\u0010\u0011\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0012\u0010\u0006R\u0019\u0010\u0013\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0014\u0010\u0006R\u0019\u0010\u0015\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0016\u0010\u0006R\u0019\u0010\u0017\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0018\u0010\u0006R\u0019\u0010\u0019\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u001a\u0010\u0006R\u0019\u0010\u001b\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u001c\u0010\u0006R\u000e\u0010\u001d\u001a\u00020\u000bX\u0086T¢\u0006\u0002\n\u0000\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u001e"}, d2 = {"Landroidx/compose/ui/graphics/Float16$Companion;", "", "()V", "Epsilon", "Landroidx/compose/ui/graphics/Float16;", "getEpsilon-slo4al4", "()S", "S", "LowestValue", "getLowestValue-slo4al4", "MaxExponent", "", "MaxValue", "getMaxValue-slo4al4", "MinExponent", "MinNormal", "getMinNormal-slo4al4", "MinValue", "getMinValue-slo4al4", "NaN", "getNaN-slo4al4", "NegativeInfinity", "getNegativeInfinity-slo4al4", "NegativeZero", "getNegativeZero-slo4al4", "PositiveInfinity", "getPositiveInfinity-slo4al4", "PositiveZero", "getPositiveZero-slo4al4", "Size", "ui-graphics_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final short m4726getEpsilonslo4al4() {
            return Float16.Epsilon;
        }

        public final short m4727getLowestValueslo4al4() {
            return Float16.LowestValue;
        }

        public final short m4728getMaxValueslo4al4() {
            return Float16.MaxValue;
        }

        public final short m4729getMinNormalslo4al4() {
            return Float16.MinNormal;
        }

        public final short m4730getMinValueslo4al4() {
            return Float16.MinValue;
        }

        public final short m4731getNaNslo4al4() {
            return Float16.NaN;
        }

        public final short m4732getNegativeInfinityslo4al4() {
            return Float16.NegativeInfinity;
        }

        public final short m4733getNegativeZeroslo4al4() {
            return Float16.NegativeZero;
        }

        public final short m4734getPositiveInfinityslo4al4() {
            return Float16.PositiveInfinity;
        }

        public final short m4735getPositiveZeroslo4al4() {
            return Float16.PositiveZero;
        }
    }

    public static short m4698constructorimpl(float f) {
        int i;
        int i2;
        int iFloatToRawIntBits = Float.floatToRawIntBits(f);
        int i3 = iFloatToRawIntBits >>> 31;
        int i4 = (iFloatToRawIntBits >>> 23) & PartialGapBuffer.BUF_SIZE;
        int i5 = 8388607 & iFloatToRawIntBits;
        int i6 = 31;
        int i7 = 0;
        if (i4 == 255) {
            if (i5 != 0) {
                i2 = Fields.RotationY;
                i7 = i2;
            }
            i = (i3 << 15) | (i6 << 10) | i7;
        } else {
            int i8 = i4 - 112;
            if (i8 >= 31) {
                i6 = 49;
            } else if (i8 > 0) {
                i7 = i5 >> 13;
                if ((iFloatToRawIntBits & Fields.TransformOrigin) != 0) {
                    i = (((i8 << 10) | i7) + 1) | (i3 << 15);
                } else {
                    i6 = i8;
                }
            } else if (i8 >= -10) {
                int i9 = (8388608 | i5) >> (1 - i8);
                if ((i9 & Fields.TransformOrigin) != 0) {
                    i9 += Fields.Shape;
                }
                i2 = i9 >> 13;
                i6 = 0;
                i7 = i2;
            } else {
                i6 = 0;
            }
            i = (i3 << 15) | (i6 << 10) | i7;
        }
        return m4699constructorimpl((short) i);
    }

    public static final float m4715toFloatimpl(short s) {
        int i;
        int i2;
        int i3;
        int i4 = Short.MIN_VALUE & s;
        int i5 = ((65535 & s) >>> 10) & 31;
        int i6 = s & 1023;
        if (i5 != 0) {
            int i7 = i6 << 13;
            if (i5 == 31) {
                i = PartialGapBuffer.BUF_SIZE;
                if (i7 != 0) {
                    i7 |= 4194304;
                }
            } else {
                i = i5 + 112;
            }
            int i8 = i;
            i2 = i7;
            i3 = i8;
        } else {
            if (i6 != 0) {
                float fIntBitsToFloat = Float.intBitsToFloat(i6 + 1056964608) - Float16Kt.Fp32DenormalFloat;
                return i4 == 0 ? fIntBitsToFloat : -fIntBitsToFloat;
            }
            i3 = 0;
            i2 = 0;
        }
        return Float.intBitsToFloat((i3 << 23) | (i4 << 16) | i2);
    }
}
