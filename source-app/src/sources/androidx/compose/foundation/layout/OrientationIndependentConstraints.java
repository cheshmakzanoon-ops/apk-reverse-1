package androidx.compose.foundation.layout;

import androidx.compose.ui.unit.Constraints;
import androidx.compose.ui.unit.ConstraintsKt;
import kotlin.Metadata;
import kotlin.jvm.JvmInline;

@Metadata(d1 = {"\u00000\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\r\n\u0002\u0010\u000b\n\u0002\b\u000f\n\u0002\u0010\u000e\n\u0002\b\u0003\b\u0081@\u0018\u00002\u00020\u0001B)\b\u0016\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0003\u0012\u0006\u0010\u0006\u001a\u00020\u0003¢\u0006\u0004\b\u0007\u0010\bB\u0019\b\u0016\u0012\u0006\u0010\t\u001a\u00020\n\u0012\u0006\u0010\u000b\u001a\u00020\f¢\u0006\u0004\b\u0007\u0010\rB\u0011\b\u0002\u0012\u0006\u0010\u000e\u001a\u00020\n¢\u0006\u0004\b\u0007\u0010\u000fJ;\u0010\u0016\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u00032\b\b\u0002\u0010\u0006\u001a\u00020\u0003ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b\u0017\u0010\u0018J\u001a\u0010\u0019\u001a\u00020\u001a2\b\u0010\u001b\u001a\u0004\u0018\u00010\u0001HÖ\u0003¢\u0006\u0004\b\u001c\u0010\u001dJ\u0010\u0010\u001e\u001a\u00020\u0003HÖ\u0001¢\u0006\u0004\b\u001f\u0010\u0011J\u0015\u0010 \u001a\u00020\u00032\u0006\u0010\u000b\u001a\u00020\f¢\u0006\u0004\b!\u0010\"J\u0015\u0010#\u001a\u00020\u00032\u0006\u0010\u000b\u001a\u00020\f¢\u0006\u0004\b$\u0010\"J\u0013\u0010%\u001a\u00020\u0000ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b&\u0010\u000fJ\u001b\u0010'\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\fø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b(\u0010\rJ\u0010\u0010)\u001a\u00020*HÖ\u0001¢\u0006\u0004\b+\u0010,R\u0012\u0010\u0006\u001a\u00020\u00038Æ\u0002¢\u0006\u0006\u001a\u0004\b\u0010\u0010\u0011R\u0012\u0010\u0005\u001a\u00020\u00038Æ\u0002¢\u0006\u0006\u001a\u0004\b\u0012\u0010\u0011R\u0012\u0010\u0004\u001a\u00020\u00038Æ\u0002¢\u0006\u0006\u001a\u0004\b\u0013\u0010\u0011R\u0012\u0010\u0002\u001a\u00020\u00038Æ\u0002¢\u0006\u0006\u001a\u0004\b\u0014\u0010\u0011R\u0016\u0010\u000e\u001a\u00020\nX\u0082\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\n\u0002\u0010\u0015\u0088\u0001\u000e\u0092\u0001\u00020\n\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006-"}, d2 = {"Landroidx/compose/foundation/layout/OrientationIndependentConstraints;", "", "mainAxisMin", "", "mainAxisMax", "crossAxisMin", "crossAxisMax", "constructor-impl", "(IIII)J", "c", "Landroidx/compose/ui/unit/Constraints;", "orientation", "Landroidx/compose/foundation/layout/LayoutOrientation;", "(JLandroidx/compose/foundation/layout/LayoutOrientation;)J", "value", "(J)J", "getCrossAxisMax-impl", "(J)I", "getCrossAxisMin-impl", "getMainAxisMax-impl", "getMainAxisMin-impl", "J", "copy", "copy-yUG9Ft0", "(JIIII)J", "equals", "", "other", "equals-impl", "(JLjava/lang/Object;)Z", "hashCode", "hashCode-impl", "maxHeight", "maxHeight-impl", "(JLandroidx/compose/foundation/layout/LayoutOrientation;)I", "maxWidth", "maxWidth-impl", "stretchCrossAxis", "stretchCrossAxis-q4ezo7Y", "toBoxConstraints", "toBoxConstraints-OenEA2s", "toString", "", "toString-impl", "(J)Ljava/lang/String;", "foundation-layout_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
@JvmInline
public final class OrientationIndependentConstraints {
    private final long value;

    public static final OrientationIndependentConstraints m1001boximpl(long j) {
        return new OrientationIndependentConstraints(j);
    }

    private static long m1003constructorimpl(long j) {
        return j;
    }

    public static boolean m1007equalsimpl(long j, Object obj) {
        return (obj instanceof OrientationIndependentConstraints) && Constraints.equals-impl0(j, ((OrientationIndependentConstraints) obj).getValue());
    }

    public static final boolean m1008equalsimpl0(long j, long j2) {
        return Constraints.equals-impl0(j, j2);
    }

    public static int m1013hashCodeimpl(long j) {
        return Constraints.hashCode-impl(j);
    }

    public static String m1018toStringimpl(long j) {
        return "OrientationIndependentConstraints(value=" + ((Object) Constraints.toString-impl(j)) + ')';
    }

    public boolean equals(Object obj) {
        return m1007equalsimpl(this.value, obj);
    }

    public int hashCode() {
        return m1013hashCodeimpl(this.value);
    }

    public String toString() {
        return m1018toStringimpl(this.value);
    }

    public final long getValue() {
        return this.value;
    }

    private OrientationIndependentConstraints(long j) {
        this.value = j;
    }

    public static final int m1012getMainAxisMinimpl(long j) {
        return Constraints.getMinWidth-impl(j);
    }

    public static final int m1011getMainAxisMaximpl(long j) {
        return Constraints.getMaxWidth-impl(j);
    }

    public static final int m1010getCrossAxisMinimpl(long j) {
        return Constraints.getMinHeight-impl(j);
    }

    public static final int m1009getCrossAxisMaximpl(long j) {
        return Constraints.getMaxHeight-impl(j);
    }

    public static long m1002constructorimpl(int i, int i2, int i3, int i4) {
        return m1003constructorimpl(ConstraintsKt.Constraints(i, i2, i3, i4));
    }

    public static long m1004constructorimpl(long j, LayoutOrientation layoutOrientation) {
        return m1002constructorimpl(layoutOrientation == LayoutOrientation.Horizontal ? Constraints.getMinWidth-impl(j) : Constraints.getMinHeight-impl(j), layoutOrientation == LayoutOrientation.Horizontal ? Constraints.getMaxWidth-impl(j) : Constraints.getMaxHeight-impl(j), layoutOrientation == LayoutOrientation.Horizontal ? Constraints.getMinHeight-impl(j) : Constraints.getMinWidth-impl(j), layoutOrientation == LayoutOrientation.Horizontal ? Constraints.getMaxHeight-impl(j) : Constraints.getMaxWidth-impl(j));
    }

    public static final long m1017toBoxConstraintsOenEA2s(long j, LayoutOrientation layoutOrientation) {
        if (layoutOrientation == LayoutOrientation.Horizontal) {
            return ConstraintsKt.Constraints(Constraints.getMinWidth-impl(j), Constraints.getMaxWidth-impl(j), Constraints.getMinHeight-impl(j), Constraints.getMaxHeight-impl(j));
        }
        return ConstraintsKt.Constraints(Constraints.getMinHeight-impl(j), Constraints.getMaxHeight-impl(j), Constraints.getMinWidth-impl(j), Constraints.getMaxWidth-impl(j));
    }

    public static final int m1015maxWidthimpl(long j, LayoutOrientation layoutOrientation) {
        if (layoutOrientation == LayoutOrientation.Horizontal) {
            return Constraints.getMaxWidth-impl(j);
        }
        return Constraints.getMaxHeight-impl(j);
    }

    public static final int m1014maxHeightimpl(long j, LayoutOrientation layoutOrientation) {
        if (layoutOrientation == LayoutOrientation.Horizontal) {
            return Constraints.getMaxHeight-impl(j);
        }
        return Constraints.getMaxWidth-impl(j);
    }

    public static final long m1005copyyUG9Ft0(long j, int i, int i2, int i3, int i4) {
        return m1002constructorimpl(i, i2, i3, i4);
    }

    public static final long m1016stretchCrossAxisq4ezo7Y(long j) {
        return m1002constructorimpl(Constraints.getMinWidth-impl(j), Constraints.getMaxWidth-impl(j), Constraints.getMaxHeight-impl(j) != Integer.MAX_VALUE ? Constraints.getMaxHeight-impl(j) : Constraints.getMinHeight-impl(j), Constraints.getMaxHeight-impl(j));
    }

    public static long m1006copyyUG9Ft0$default(long j, int i, int i2, int i3, int i4, int i5, Object obj) {
        if ((i5 & 1) != 0) {
            i = Constraints.getMinWidth-impl(j);
        }
        int i6 = i;
        if ((i5 & 2) != 0) {
            i2 = Constraints.getMaxWidth-impl(j);
        }
        int i7 = i2;
        if ((i5 & 4) != 0) {
            i3 = Constraints.getMinHeight-impl(j);
        }
        int i8 = i3;
        if ((i5 & 8) != 0) {
            i4 = Constraints.getMaxHeight-impl(j);
        }
        return m1005copyyUG9Ft0(j, i6, i7, i8, i4);
    }
}
