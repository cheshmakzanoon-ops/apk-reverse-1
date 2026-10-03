package androidx.compose.material3;

import androidx.compose.runtime.MutableFloatState;
import androidx.compose.runtime.MutableState;
import androidx.compose.runtime.PrimitiveSnapshotStateKt;
import androidx.compose.runtime.SnapshotStateKt__SnapshotStateKt;
import androidx.compose.ui.util.MathHelpersKt;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u0007\n\u0002\b\u000b\n\u0002\u0010\u000b\n\u0002\b\b\n\u0002\u0010\u0002\n\u0002\b\b\b\u0001\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J\u0006\u0010\u0018\u001a\u00020\u0019J6\u0010\u001a\u001a\u00020\u00192\u0006\u0010\u001b\u001a\u00020\u00042\u0006\u0010\u001c\u001a\u00020\u00102\u0006\u0010\u001d\u001a\u00020\u00102\u0006\u0010\u001e\u001a\u00020\u00042\u0006\u0010\u001f\u001a\u00020\u00042\u0006\u0010 \u001a\u00020\u0004R+\u0010\u0005\u001a\u00020\u00042\u0006\u0010\u0003\u001a\u00020\u00048F@FX\u0086\u008e\u0002¢\u0006\u0012\n\u0004\b\n\u0010\u000b\u001a\u0004\b\u0006\u0010\u0007\"\u0004\b\b\u0010\tR+\u0010\f\u001a\u00020\u00042\u0006\u0010\u0003\u001a\u00020\u00048F@FX\u0086\u008e\u0002¢\u0006\u0012\n\u0004\b\u000f\u0010\u000b\u001a\u0004\b\r\u0010\u0007\"\u0004\b\u000e\u0010\tR+\u0010\u0011\u001a\u00020\u00102\u0006\u0010\u0003\u001a\u00020\u00108F@FX\u0086\u008e\u0002¢\u0006\u0012\n\u0004\b\u0016\u0010\u0017\u001a\u0004\b\u0012\u0010\u0013\"\u0004\b\u0014\u0010\u0015¨\u0006!"}, d2 = {"Landroidx/compose/material3/DrawerPredictiveBackState;", "", "()V", "<set-?>", "", "scaleXDistance", "getScaleXDistance", "()F", "setScaleXDistance", "(F)V", "scaleXDistance$delegate", "Landroidx/compose/runtime/MutableFloatState;", "scaleYDistance", "getScaleYDistance", "setScaleYDistance", "scaleYDistance$delegate", "", "swipeEdgeMatchesDrawer", "getSwipeEdgeMatchesDrawer", "()Z", "setSwipeEdgeMatchesDrawer", "(Z)V", "swipeEdgeMatchesDrawer$delegate", "Landroidx/compose/runtime/MutableState;", "clear", "", "update", "progress", "swipeEdgeLeft", "isRtl", "maxScaleXDistanceGrow", "maxScaleXDistanceShrink", "maxScaleYDistance", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class DrawerPredictiveBackState {
    public static final int $stable = 0;

    private final MutableState swipeEdgeMatchesDrawer = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(true, null, 2, null);

    private final MutableFloatState scaleXDistance = PrimitiveSnapshotStateKt.mutableFloatStateOf(0.0f);

    private final MutableFloatState scaleYDistance = PrimitiveSnapshotStateKt.mutableFloatStateOf(0.0f);

    public final boolean getSwipeEdgeMatchesDrawer() {
        return ((Boolean) this.swipeEdgeMatchesDrawer.getValue()).booleanValue();
    }

    public final void setSwipeEdgeMatchesDrawer(boolean z) {
        this.swipeEdgeMatchesDrawer.setValue(Boolean.valueOf(z));
    }

    public final float getScaleXDistance() {
        return this.scaleXDistance.getFloatValue();
    }

    public final void setScaleXDistance(float f) {
        this.scaleXDistance.setFloatValue(f);
    }

    public final float getScaleYDistance() {
        return this.scaleYDistance.getFloatValue();
    }

    public final void setScaleYDistance(float f) {
        this.scaleYDistance.setFloatValue(f);
    }

    public final void update(float progress, boolean swipeEdgeLeft, boolean isRtl, float maxScaleXDistanceGrow, float maxScaleXDistanceShrink, float maxScaleYDistance) {
        setSwipeEdgeMatchesDrawer(swipeEdgeLeft != isRtl);
        if (!getSwipeEdgeMatchesDrawer()) {
            maxScaleXDistanceGrow = maxScaleXDistanceShrink;
        }
        setScaleXDistance(MathHelpersKt.lerp(0.0f, maxScaleXDistanceGrow, progress));
        setScaleYDistance(MathHelpersKt.lerp(0.0f, maxScaleYDistance, progress));
    }

    public final void clear() {
        setSwipeEdgeMatchesDrawer(true);
        setScaleXDistance(0.0f);
        setScaleYDistance(0.0f);
    }
}
