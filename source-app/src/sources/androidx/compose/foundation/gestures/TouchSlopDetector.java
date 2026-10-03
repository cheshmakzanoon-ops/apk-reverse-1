package androidx.compose.foundation.gestures;

import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.geometry.OffsetKt;
import androidx.compose.p002ui.input.pointer.PointerInputChange;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u00000\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0007\n\u0002\b\u0005\n\u0002\u0010\u0002\n\u0002\b\u0006\b\u0002\u0018\u00002\u00020\u0001B\u0011\u0012\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u0003¢\u0006\u0002\u0010\u0004J#\u0010\n\u001a\u0004\u0018\u00010\b2\u0006\u0010\u000b\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\u000eø\u0001\u0001ø\u0001\u0000¢\u0006\u0002\b\u000fJ\u001d\u0010\u0010\u001a\u00020\b2\u0006\u0010\r\u001a\u00020\u000eH\u0002ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b\u0011\u0010\u0012J\u0006\u0010\u0013\u001a\u00020\u0014J\u0014\u0010\u0015\u001a\u00020\u000e*\u00020\bø\u0001\u0000¢\u0006\u0004\b\u0016\u0010\u0017J\u0014\u0010\u0018\u001a\u00020\u000e*\u00020\bø\u0001\u0000¢\u0006\u0004\b\u0019\u0010\u0017R\u0013\u0010\u0002\u001a\u0004\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006R\u0016\u0010\u0007\u001a\u00020\bX\u0082\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\n\u0002\u0010\t\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u001a"}, d2 = {"Landroidx/compose/foundation/gestures/TouchSlopDetector;", "", "orientation", "Landroidx/compose/foundation/gestures/Orientation;", "(Landroidx/compose/foundation/gestures/Orientation;)V", "getOrientation", "()Landroidx/compose/foundation/gestures/Orientation;", "totalPositionChange", "Landroidx/compose/ui/geometry/Offset;", "J", "addPointerInputChange", "dragEvent", "Landroidx/compose/ui/input/pointer/PointerInputChange;", "touchSlop", "", "addPointerInputChange-GcwITfU", "calculatePostSlopOffset", "calculatePostSlopOffset-tuRUvjQ", "(F)J", "reset", "", "crossAxis", "crossAxis-k-4lQ0M", "(J)F", "mainAxis", "mainAxis-k-4lQ0M", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
final class TouchSlopDetector {
    private final Orientation orientation;
    private long totalPositionChange;

    public TouchSlopDetector() {
        Orientation orientation = null;
        this(orientation, 1, orientation);
    }

    public TouchSlopDetector(Orientation orientation) {
        this.orientation = orientation;
        this.totalPositionChange = Offset.INSTANCE.m4362getZeroF1C5BW0();
    }

    public TouchSlopDetector(Orientation orientation, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? null : orientation);
    }

    public final Orientation getOrientation() {
        return this.orientation;
    }

    public final float m855mainAxisk4lQ0M(long j) {
        return this.orientation == Orientation.Horizontal ? Offset.m4346getXimpl(j) : Offset.m4347getYimpl(j);
    }

    public final float m854crossAxisk4lQ0M(long j) {
        return this.orientation == Orientation.Horizontal ? Offset.m4347getYimpl(j) : Offset.m4346getXimpl(j);
    }

    public final Offset m853addPointerInputChangeGcwITfU(PointerInputChange dragEvent, float touchSlop) {
        float fAbs;
        long jM4351plusMKHz9U = Offset.m4351plusMKHz9U(this.totalPositionChange, Offset.m4350minusMKHz9U(dragEvent.getPosition(), dragEvent.getPreviousPosition()));
        this.totalPositionChange = jM4351plusMKHz9U;
        if (this.orientation == null) {
            fAbs = Offset.m4344getDistanceimpl(jM4351plusMKHz9U);
        } else {
            fAbs = Math.abs(m855mainAxisk4lQ0M(jM4351plusMKHz9U));
        }
        if (fAbs >= touchSlop) {
            return Offset.m4335boximpl(m852calculatePostSlopOffsettuRUvjQ(touchSlop));
        }
        return null;
    }

    public final void reset() {
        this.totalPositionChange = Offset.INSTANCE.m4362getZeroF1C5BW0();
    }

    private final long m852calculatePostSlopOffsettuRUvjQ(float touchSlop) {
        if (this.orientation == null) {
            long j = this.totalPositionChange;
            return Offset.m4350minusMKHz9U(this.totalPositionChange, Offset.m4353timestuRUvjQ(Offset.m4341divtuRUvjQ(j, Offset.m4344getDistanceimpl(j)), touchSlop));
        }
        float fM855mainAxisk4lQ0M = m855mainAxisk4lQ0M(this.totalPositionChange) - (Math.signum(m855mainAxisk4lQ0M(this.totalPositionChange)) * touchSlop);
        float fM854crossAxisk4lQ0M = m854crossAxisk4lQ0M(this.totalPositionChange);
        if (this.orientation == Orientation.Horizontal) {
            return OffsetKt.Offset(fM855mainAxisk4lQ0M, fM854crossAxisk4lQ0M);
        }
        return OffsetKt.Offset(fM854crossAxisk4lQ0M, fM855mainAxisk4lQ0M);
    }
}
