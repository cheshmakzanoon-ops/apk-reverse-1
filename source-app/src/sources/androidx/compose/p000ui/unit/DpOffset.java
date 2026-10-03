package androidx.compose.p000ui.unit;

import androidx.constraintlayout.widget.ConstraintLayout;
import kotlin.Metadata;
import kotlin.UByte$;
import kotlin.jvm.JvmInline;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\t\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\b\n\u0002\b\b\n\u0002\u0010\u000e\n\u0002\b\u0004\b\u0087@\u0018\u0000 %2\u00020\u0001:\u0001%B\u0011\b\u0000\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0004\b\u0004\u0010\u0005J$\u0010\u0010\u001a\u00020\u00002\b\b\u0002\u0010\b\u001a\u00020\t2\b\b\u0002\u0010\r\u001a\u00020\tø\u0001\u0000¢\u0006\u0004\b\u0011\u0010\u0012J\u001a\u0010\u0013\u001a\u00020\u00142\b\u0010\u0015\u001a\u0004\u0018\u00010\u0001HÖ\u0003¢\u0006\u0004\b\u0016\u0010\u0017J\u0010\u0010\u0018\u001a\u00020\u0019HÖ\u0001¢\u0006\u0004\b\u001a\u0010\u001bJ\u001b\u0010\u001c\u001a\u00020\u00002\u0006\u0010\u0015\u001a\u00020\u0000H\u0087\u0002ø\u0001\u0000¢\u0006\u0004\b\u001d\u0010\u001eJ\u001b\u0010\u001f\u001a\u00020\u00002\u0006\u0010\u0015\u001a\u00020\u0000H\u0087\u0002ø\u0001\u0000¢\u0006\u0004\b \u0010\u001eJ\u000f\u0010!\u001a\u00020\"H\u0017¢\u0006\u0004\b#\u0010$R\u0016\u0010\u0002\u001a\u00020\u00038\u0000X\u0081\u0004¢\u0006\b\n\u0000\u0012\u0004\b\u0006\u0010\u0007R \u0010\b\u001a\u00020\t8FX\u0087\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\f\u0012\u0004\b\n\u0010\u0007\u001a\u0004\b\u000b\u0010\fR \u0010\r\u001a\u00020\t8FX\u0087\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\f\u0012\u0004\b\u000e\u0010\u0007\u001a\u0004\b\u000f\u0010\f\u0088\u0001\u0002\u0092\u0001\u00020\u0003\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006&"}, d2 = {"Landroidx/compose/ui/unit/DpOffset;", "", "packedValue", "", "constructor-impl", "(J)J", "getPackedValue$annotations", "()V", "x", "Landroidx/compose/ui/unit/Dp;", "getX-D9Ej5fM$annotations", "getX-D9Ej5fM", "(J)F", "y", "getY-D9Ej5fM$annotations", "getY-D9Ej5fM", "copy", "copy-tPigGR8", "(JFF)J", "equals", "", "other", "equals-impl", "(JLjava/lang/Object;)Z", "hashCode", "", "hashCode-impl", "(J)I", "minus", "minus-CB-Mgk4", "(JJ)J", "plus", "plus-CB-Mgk4", "toString", "", "toString-impl", "(J)Ljava/lang/String;", "Companion", "ui-unit_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
@JvmInline
public final class DpOffset {
    private final long packedValue;

    public static final Companion INSTANCE = new Companion(null);
    private static final long Zero = m1891constructorimpl(0);
    private static final long Unspecified = m1891constructorimpl(9205357640488583168L);

    public static final DpOffset m1890boximpl(long j) {
        return new DpOffset(j);
    }

    public static long m1891constructorimpl(long j) {
        return j;
    }

    public static boolean m1894equalsimpl(long j, Object obj) {
        return (obj instanceof DpOffset) && j == ((DpOffset) obj).getPackedValue();
    }

    public static final boolean m1895equalsimpl0(long j, long j2) {
        return j == j2;
    }

    public static void getPackedValue$annotations() {
    }

    public static void m1897getXD9Ej5fM$annotations() {
    }

    public static void m1899getYD9Ej5fM$annotations() {
    }

    public static int m1900hashCodeimpl(long j) {
        return UByte$.ExternalSyntheticBackport0.m(j);
    }

    public boolean equals(Object obj) {
        return m1894equalsimpl(this.packedValue, obj);
    }

    public int hashCode() {
        return m1900hashCodeimpl(this.packedValue);
    }

    public final long getPackedValue() {
        return this.packedValue;
    }

    private DpOffset(long j) {
        this.packedValue = j;
    }

    public static long m1893copytPigGR8$default(long j, float f, float f2, int i, Object obj) {
        if ((i & 1) != 0) {
            f = m1896getXD9Ej5fM(j);
        }
        if ((i & 2) != 0) {
            f2 = m1898getYD9Ej5fM(j);
        }
        return m1892copytPigGR8(j, f, f2);
    }

    public static final long m1901minusCBMgk4(long j, long j2) {
        float fM1835constructorimpl = C0027Dp.m1835constructorimpl(m1896getXD9Ej5fM(j) - m1896getXD9Ej5fM(j2));
        float fM1835constructorimpl2 = C0027Dp.m1835constructorimpl(m1898getYD9Ej5fM(j) - m1898getYD9Ej5fM(j2));
        return m1891constructorimpl((((long) Float.floatToRawIntBits(fM1835constructorimpl)) << 32) | (4294967295L & ((long) Float.floatToRawIntBits(fM1835constructorimpl2))));
    }

    public static final long m1902plusCBMgk4(long j, long j2) {
        float fM1835constructorimpl = C0027Dp.m1835constructorimpl(m1896getXD9Ej5fM(j) + m1896getXD9Ej5fM(j2));
        float fM1835constructorimpl2 = C0027Dp.m1835constructorimpl(m1898getYD9Ej5fM(j) + m1898getYD9Ej5fM(j2));
        return m1891constructorimpl((((long) Float.floatToRawIntBits(fM1835constructorimpl)) << 32) | (4294967295L & ((long) Float.floatToRawIntBits(fM1835constructorimpl2))));
    }

    public String toString() {
        return m1903toStringimpl(this.packedValue);
    }

    public static String m1903toStringimpl(long j) {
        if (j != 9205357640488583168L) {
            return "(" + ((Object) C0027Dp.m1846toStringimpl(m1896getXD9Ej5fM(j))) + ", " + ((Object) C0027Dp.m1846toStringimpl(m1898getYD9Ej5fM(j))) + ')';
        }
        return "DpOffset.Unspecified";
    }

    @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u0019\u0010\u0003\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0005\u0010\u0006R\u0019\u0010\b\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\t\u0010\u0006\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\n"}, d2 = {"Landroidx/compose/ui/unit/DpOffset$Companion;", "", "()V", "Unspecified", "Landroidx/compose/ui/unit/DpOffset;", "getUnspecified-RKDOV3M", "()J", "J", "Zero", "getZero-RKDOV3M", "ui-unit_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final long m1906getZeroRKDOV3M() {
            return DpOffset.Zero;
        }

        public final long m1905getUnspecifiedRKDOV3M() {
            return DpOffset.Unspecified;
        }
    }

    public static final float m1896getXD9Ej5fM(long j) {
        return C0027Dp.m1835constructorimpl(Float.intBitsToFloat((int) (j >> 32)));
    }

    public static final float m1898getYD9Ej5fM(long j) {
        return C0027Dp.m1835constructorimpl(Float.intBitsToFloat((int) (j & 4294967295L)));
    }

    public static final long m1892copytPigGR8(long j, float f, float f2) {
        return m1891constructorimpl((((long) Float.floatToRawIntBits(f)) << 32) | (((long) Float.floatToRawIntBits(f2)) & 4294967295L));
    }
}
