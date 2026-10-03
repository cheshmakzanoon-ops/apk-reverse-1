package androidx.compose.material3.carousel;

import androidx.compose.p002ui.geometry.Rect;
import androidx.compose.runtime.MutableFloatState;
import androidx.compose.runtime.MutableState;
import androidx.compose.runtime.PrimitiveSnapshotStateKt;
import androidx.compose.runtime.SnapshotStateKt__SnapshotStateKt;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0010\u0007\n\u0002\b\u0015\b\u0000\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002R\u0014\u0010\u0003\u001a\u00020\u00048VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u0005\u0010\u0006R+\u0010\b\u001a\u00020\u00042\u0006\u0010\u0007\u001a\u00020\u00048F@FX\u0086\u008e\u0002¢\u0006\u0012\n\u0004\b\f\u0010\r\u001a\u0004\b\t\u0010\u0006\"\u0004\b\n\u0010\u000bR\u0014\u0010\u000e\u001a\u00020\u000f8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u0010\u0010\u0011R+\u0010\u0012\u001a\u00020\u000f2\u0006\u0010\u0007\u001a\u00020\u000f8F@FX\u0086\u008e\u0002¢\u0006\u0012\n\u0004\b\u0016\u0010\u0017\u001a\u0004\b\u0013\u0010\u0011\"\u0004\b\u0014\u0010\u0015R\u0014\u0010\u0018\u001a\u00020\u000f8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u0019\u0010\u0011R+\u0010\u001a\u001a\u00020\u000f2\u0006\u0010\u0007\u001a\u00020\u000f8F@FX\u0086\u008e\u0002¢\u0006\u0012\n\u0004\b\u001d\u0010\u0017\u001a\u0004\b\u001b\u0010\u0011\"\u0004\b\u001c\u0010\u0015R\u0014\u0010\u001e\u001a\u00020\u000f8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u001f\u0010\u0011R+\u0010 \u001a\u00020\u000f2\u0006\u0010\u0007\u001a\u00020\u000f8F@FX\u0086\u008e\u0002¢\u0006\u0012\n\u0004\b#\u0010\u0017\u001a\u0004\b!\u0010\u0011\"\u0004\b\"\u0010\u0015¨\u0006$"}, d2 = {"Landroidx/compose/material3/carousel/CarouselItemInfoImpl;", "Landroidx/compose/material3/carousel/CarouselItemInfo;", "()V", "maskRect", "Landroidx/compose/ui/geometry/Rect;", "getMaskRect", "()Landroidx/compose/ui/geometry/Rect;", "<set-?>", "maskRectState", "getMaskRectState", "setMaskRectState", "(Landroidx/compose/ui/geometry/Rect;)V", "maskRectState$delegate", "Landroidx/compose/runtime/MutableState;", "maxSize", "", "getMaxSize", "()F", "maxSizeState", "getMaxSizeState", "setMaxSizeState", "(F)V", "maxSizeState$delegate", "Landroidx/compose/runtime/MutableFloatState;", "minSize", "getMinSize", "minSizeState", "getMinSizeState", "setMinSizeState", "minSizeState$delegate", "size", "getSize", "sizeState", "getSizeState", "setSizeState", "sizeState$delegate", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class CarouselItemInfoImpl implements CarouselItemInfo {
    public static final int $stable = 0;

    private final MutableFloatState sizeState = PrimitiveSnapshotStateKt.mutableFloatStateOf(0.0f);

    private final MutableFloatState minSizeState = PrimitiveSnapshotStateKt.mutableFloatStateOf(0.0f);

    private final MutableFloatState maxSizeState = PrimitiveSnapshotStateKt.mutableFloatStateOf(0.0f);

    private final MutableState maskRectState = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(Rect.INSTANCE.getZero(), null, 2, null);

    public final float getSizeState() {
        return this.sizeState.getFloatValue();
    }

    public final void setSizeState(float f) {
        this.sizeState.setFloatValue(f);
    }

    public final float getMinSizeState() {
        return this.minSizeState.getFloatValue();
    }

    public final void setMinSizeState(float f) {
        this.minSizeState.setFloatValue(f);
    }

    public final float getMaxSizeState() {
        return this.maxSizeState.getFloatValue();
    }

    public final void setMaxSizeState(float f) {
        this.maxSizeState.setFloatValue(f);
    }

    public final Rect getMaskRectState() {
        return (Rect) this.maskRectState.getValue();
    }

    public final void setMaskRectState(Rect rect) {
        this.maskRectState.setValue(rect);
    }

    @Override
    public float getSize() {
        return getSizeState();
    }

    @Override
    public float getMinSize() {
        return getMinSizeState();
    }

    @Override
    public float getMaxSize() {
        return getMaxSizeState();
    }

    @Override
    public Rect getMaskRect() {
        return getMaskRectState();
    }
}
