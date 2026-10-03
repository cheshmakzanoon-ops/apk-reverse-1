package androidx.compose.p002ui.input.pointer.util;

import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.internal.InlineClassHelperKt;
import androidx.compose.ui.unit.Velocity;
import androidx.compose.ui.unit.VelocityKt;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000<\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\t\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0006\b\u0007\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J \u0010\u0014\u001a\u00020\u00152\u0006\u0010\u0016\u001a\u00020\u000b2\u0006\u0010\u0017\u001a\u00020\u0004ø\u0001\u0000¢\u0006\u0004\b\u0018\u0010\u0019J\u0013\u0010\u001a\u001a\u00020\u001bø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b\u001c\u0010\u0006J\u0018\u0010\u001a\u001a\u00020\u001b2\u0006\u0010\u001d\u001a\u00020\u001bø\u0001\u0000¢\u0006\u0004\b\u001e\u0010\u001fJ\u0006\u0010 \u001a\u00020\u0015R\"\u0010\u0003\u001a\u00020\u0004X\u0080\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\t\u001a\u0004\b\u0005\u0010\u0006\"\u0004\b\u0007\u0010\bR\u001a\u0010\n\u001a\u00020\u000bX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\f\u0010\u0006\"\u0004\b\r\u0010\bR\u0014\u0010\u000e\u001a\u00020\u000fX\u0082\u0004¢\u0006\b\n\u0000\u0012\u0004\b\u0010\u0010\u0002R\u000e\u0010\u0011\u001a\u00020\u0012X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0013\u001a\u00020\u0012X\u0082\u0004¢\u0006\u0002\n\u0000\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006!"}, d2 = {"Landroidx/compose/ui/input/pointer/util/VelocityTracker;", "", "()V", "currentPointerPositionAccumulator", "Landroidx/compose/ui/geometry/Offset;", "getCurrentPointerPositionAccumulator-F1C5BW0$ui_release", "()J", "setCurrentPointerPositionAccumulator-k-4lQ0M$ui_release", "(J)V", "J", "lastMoveEventTimeStamp", "", "getLastMoveEventTimeStamp$ui_release", "setLastMoveEventTimeStamp$ui_release", "strategy", "Landroidx/compose/ui/input/pointer/util/VelocityTracker1D$Strategy;", "getStrategy$annotations", "xVelocityTracker", "Landroidx/compose/ui/input/pointer/util/VelocityTracker1D;", "yVelocityTracker", "addPosition", "", "timeMillis", "position", "addPosition-Uv8p0NA", "(JJ)V", "calculateVelocity", "Landroidx/compose/ui/unit/Velocity;", "calculateVelocity-9UxMQ8M", "maximumVelocity", "calculateVelocity-AH228Gc", "(J)J", "resetTracking", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class VelocityTracker {
    public static final int $stable = 8;
    private long currentPointerPositionAccumulator;
    private long lastMoveEventTimeStamp;
    private final VelocityTracker1D.Strategy strategy;
    private final VelocityTracker1D xVelocityTracker;
    private final VelocityTracker1D yVelocityTracker;

    private static void getStrategy$annotations() {
    }

    public VelocityTracker() {
        VelocityTracker1D.Strategy strategy;
        if (VelocityTrackerKt.getVelocityTrackerStrategyUseImpulse()) {
            strategy = VelocityTracker1D.Strategy.Impulse;
        } else {
            strategy = VelocityTracker1D.Strategy.Lsq2;
        }
        this.strategy = strategy;
        boolean z = false;
        int i = 1;
        DefaultConstructorMarker defaultConstructorMarker = null;
        this.xVelocityTracker = new VelocityTracker1D(z, strategy, i, defaultConstructorMarker);
        this.yVelocityTracker = new VelocityTracker1D(z, strategy, i, defaultConstructorMarker);
        this.currentPointerPositionAccumulator = Offset.INSTANCE.m4362getZeroF1C5BW0();
    }

    public final long getCurrentPointerPositionAccumulator() {
        return this.currentPointerPositionAccumulator;
    }

    public final void m5973setCurrentPointerPositionAccumulatork4lQ0M$ui_release(long j) {
        this.currentPointerPositionAccumulator = j;
    }

    public final long getLastMoveEventTimeStamp() {
        return this.lastMoveEventTimeStamp;
    }

    public final void setLastMoveEventTimeStamp$ui_release(long j) {
        this.lastMoveEventTimeStamp = j;
    }

    public final void m5969addPositionUv8p0NA(long timeMillis, long position) {
        this.xVelocityTracker.addDataPoint(timeMillis, Offset.m4346getXimpl(position));
        this.yVelocityTracker.addDataPoint(timeMillis, Offset.m4347getYimpl(position));
    }

    public final long m5970calculateVelocity9UxMQ8M() {
        return m5971calculateVelocityAH228Gc(VelocityKt.Velocity(Float.MAX_VALUE, Float.MAX_VALUE));
    }

    public final long m5971calculateVelocityAH228Gc(long maximumVelocity) {
        if (!(Velocity.getX-impl(maximumVelocity) > 0.0f && Velocity.getY-impl(maximumVelocity) > 0.0f)) {
            InlineClassHelperKt.throwIllegalStateException("maximumVelocity should be a positive value. You specified=" + ((Object) Velocity.toString-impl(maximumVelocity)));
        }
        return VelocityKt.Velocity(this.xVelocityTracker.calculateVelocity(Velocity.getX-impl(maximumVelocity)), this.yVelocityTracker.calculateVelocity(Velocity.getY-impl(maximumVelocity)));
    }

    public final void resetTracking() {
        this.xVelocityTracker.resetTracking();
        this.yVelocityTracker.resetTracking();
        this.lastMoveEventTimeStamp = 0L;
    }
}
