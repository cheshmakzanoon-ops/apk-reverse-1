package androidx.compose.p000ui.unit;

import androidx.compose.p000ui.util.MathHelpersKt;
import androidx.compose.ui.geometry.Offset;
import androidx.compose.ui.geometry.OffsetKt;
import androidx.constraintlayout.core.motion.utils.TypedValues;
import androidx.constraintlayout.widget.ConstraintLayout;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000 \n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0006\n\u0002\u0010\u0007\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\r\u001a\u001d\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0003H\u0007¢\u0006\u0002\u0010\u0005\u001a*\u0010\u0006\u001a\u00020\u00012\u0006\u0010\u0007\u001a\u00020\u00012\u0006\u0010\b\u001a\u00020\u00012\u0006\u0010\t\u001a\u00020\nH\u0007ø\u0001\u0000¢\u0006\u0004\b\u000b\u0010\f\u001a\u001f\u0010\r\u001a\u00020\u000e*\u00020\u000e2\u0006\u0010\u000f\u001a\u00020\u0001H\u0087\u0002ø\u0001\u0000¢\u0006\u0004\b\u0010\u0010\u0011\u001a\u001f\u0010\r\u001a\u00020\u000e*\u00020\u00012\u0006\u0010\u000f\u001a\u00020\u000eH\u0087\u0002ø\u0001\u0000¢\u0006\u0004\b\u0012\u0010\u0011\u001a\u001f\u0010\u0013\u001a\u00020\u000e*\u00020\u000e2\u0006\u0010\u000f\u001a\u00020\u0001H\u0087\u0002ø\u0001\u0000¢\u0006\u0004\b\u0014\u0010\u0011\u001a\u001f\u0010\u0013\u001a\u00020\u000e*\u00020\u00012\u0006\u0010\u000f\u001a\u00020\u000eH\u0087\u0002ø\u0001\u0000¢\u0006\u0004\b\u0015\u0010\u0011\u001a\u0016\u0010\u0016\u001a\u00020\u0001*\u00020\u000eH\u0007ø\u0001\u0000¢\u0006\u0004\b\u0017\u0010\u0018\u001a\u0017\u0010\u0019\u001a\u00020\u000e*\u00020\u0001H\u0087\bø\u0001\u0000¢\u0006\u0004\b\u001a\u0010\u0018\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u001b"}, d2 = {"IntOffset", "Landroidx/compose/ui/unit/IntOffset;", "x", "", "y", "(II)J", "lerp", "start", "stop", "fraction", "", "lerp-81ZRxRo", "(JJF)J", "minus", "Landroidx/compose/ui/geometry/Offset;", TypedValues.CycleType.S_WAVE_OFFSET, "minus-Nv-tHpc", "(JJ)J", "minus-oCl6YwE", "plus", "plus-Nv-tHpc", "plus-oCl6YwE", "round", "round-k-4lQ0M", "(J)J", "toOffset", "toOffset--gyyYBs", "ui-unit_release"}, k = 2, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class IntOffsetKt {
    public static final long IntOffset(int i, int i2) {
        return IntOffset.m1961constructorimpl((((long) i2) & 4294967295L) | (((long) i) << 32));
    }

    public static final long m1978lerp81ZRxRo(long j, long j2, float f) {
        return IntOffset.m1961constructorimpl((((long) MathHelpersKt.lerp(IntOffset.m1967getXimpl(j), IntOffset.m1967getXimpl(j2), f)) << 32) | (((long) MathHelpersKt.lerp(IntOffset.m1968getYimpl(j), IntOffset.m1968getYimpl(j2), f)) & 4294967295L));
    }

    public static final long m1984toOffsetgyyYBs(long j) {
        return OffsetKt.Offset(IntOffset.m1967getXimpl(j), IntOffset.m1968getYimpl(j));
    }

    public static final long m1981plusNvtHpc(long j, long j2) {
        return OffsetKt.Offset(Offset.getX-impl(j) + IntOffset.m1967getXimpl(j2), Offset.getY-impl(j) + IntOffset.m1968getYimpl(j2));
    }

    public static final long m1979minusNvtHpc(long j, long j2) {
        return OffsetKt.Offset(Offset.getX-impl(j) - IntOffset.m1967getXimpl(j2), Offset.getY-impl(j) - IntOffset.m1968getYimpl(j2));
    }

    public static final long m1982plusoCl6YwE(long j, long j2) {
        return OffsetKt.Offset(IntOffset.m1967getXimpl(j) + Offset.getX-impl(j2), IntOffset.m1968getYimpl(j) + Offset.getY-impl(j2));
    }

    public static final long m1980minusoCl6YwE(long j, long j2) {
        return OffsetKt.Offset(IntOffset.m1967getXimpl(j) - Offset.getX-impl(j2), IntOffset.m1968getYimpl(j) - Offset.getY-impl(j2));
    }

    public static final long m1983roundk4lQ0M(long j) {
        int iRound = Math.round(Offset.getX-impl(j));
        return IntOffset.m1961constructorimpl((((long) Math.round(Offset.getY-impl(j))) & 4294967295L) | (((long) iRound) << 32));
    }
}
