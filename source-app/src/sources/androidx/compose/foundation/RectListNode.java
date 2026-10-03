package androidx.compose.foundation;

import android.graphics.Rect;
import android.view.View;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.layout.LayoutCoordinates;
import androidx.compose.p002ui.layout.LayoutCoordinatesKt;
import androidx.compose.p002ui.node.DelegatableNode_androidKt;
import androidx.compose.p002ui.node.GlobalPositionAwareModifierNode;
import androidx.compose.runtime.collection.MutableVector;
import kotlin.Metadata;
import kotlin.comparisons.ComparisonsKt;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;
import kotlin.math.MathKt;

@Metadata(d1 = {"\u0000<\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0007\b \u0018\u00002\u00020\u00012\u00020\u0002B\u001b\u0012\u0014\u0010\u0003\u001a\u0010\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u0006\u0018\u00010\u0004¢\u0006\u0002\u0010\u0007J\u0018\u0010\u0011\u001a\u00020\t2\u0006\u0010\u0012\u001a\u00020\u00052\u0006\u0010\u0003\u001a\u00020\u0006H\u0002J\u000e\u0010\u0013\u001a\b\u0012\u0004\u0012\u00020\t0\u0014H&J\b\u0010\u0015\u001a\u00020\u0016H\u0016J\u0010\u0010\u0017\u001a\u00020\u00162\u0006\u0010\u0018\u001a\u00020\u0005H\u0016J\u0012\u0010\u0019\u001a\u00020\u00162\b\u0010\u001a\u001a\u0004\u0018\u00010\tH\u0002J\u0016\u0010\u001b\u001a\u00020\u00162\f\u0010\u001c\u001a\b\u0012\u0004\u0012\u00020\t0\u0014H&R\u0010\u0010\b\u001a\u0004\u0018\u00010\tX\u0082\u000e¢\u0006\u0002\n\u0000R(\u0010\u0003\u001a\u0010\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u0006\u0018\u00010\u0004X\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\n\u0010\u000b\"\u0004\b\f\u0010\u0007R\u0014\u0010\r\u001a\u00020\u000e8DX\u0084\u0004¢\u0006\u0006\u001a\u0004\b\u000f\u0010\u0010¨\u0006\u001d"}, d2 = {"Landroidx/compose/foundation/RectListNode;", "Landroidx/compose/ui/Modifier$Node;", "Landroidx/compose/ui/node/GlobalPositionAwareModifierNode;", "rect", "Lkotlin/Function1;", "Landroidx/compose/ui/layout/LayoutCoordinates;", "Landroidx/compose/ui/geometry/Rect;", "(Lkotlin/jvm/functions/Function1;)V", "androidRect", "Landroid/graphics/Rect;", "getRect", "()Lkotlin/jvm/functions/Function1;", "setRect", "view", "Landroid/view/View;", "getView", "()Landroid/view/View;", "calcBounds", "layoutCoordinates", "currentRects", "Landroidx/compose/runtime/collection/MutableVector;", "onDetach", "", "onGloballyPositioned", "coordinates", "replaceRect", "newRect", "updateRects", "rects", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public abstract class RectListNode extends Modifier.Node implements GlobalPositionAwareModifierNode {
    public static final int $stable = 8;
    private Rect androidRect;
    private Function1<? super LayoutCoordinates, androidx.compose.p002ui.geometry.Rect> rect;

    public abstract MutableVector<Rect> currentRects();

    public abstract void updateRects(MutableVector<Rect> rects);

    public Function1<LayoutCoordinates, androidx.compose.p002ui.geometry.Rect> getRect() {
        return this.rect;
    }

    public void setRect(Function1<? super LayoutCoordinates, androidx.compose.p002ui.geometry.Rect> function1) {
        this.rect = function1;
    }

    public RectListNode(Function1<? super LayoutCoordinates, androidx.compose.p002ui.geometry.Rect> function1) {
        this.rect = function1;
    }

    protected final View getView() {
        return DelegatableNode_androidKt.requireView(this);
    }

    @Override
    public void onGloballyPositioned(LayoutCoordinates coordinates) {
        Rect rectCalcBounds;
        if (getRect() == null) {
            androidx.compose.p002ui.geometry.Rect rectBoundsInRoot = LayoutCoordinatesKt.boundsInRoot(coordinates);
            rectCalcBounds = new Rect(MathKt.roundToInt(rectBoundsInRoot.getLeft()), MathKt.roundToInt(rectBoundsInRoot.getTop()), MathKt.roundToInt(rectBoundsInRoot.getRight()), MathKt.roundToInt(rectBoundsInRoot.getBottom()));
        } else {
            Function1<LayoutCoordinates, androidx.compose.p002ui.geometry.Rect> rect = getRect();
            Intrinsics.checkNotNull(rect);
            rectCalcBounds = calcBounds(coordinates, (androidx.compose.p002ui.geometry.Rect) rect.invoke(coordinates));
        }
        replaceRect(rectCalcBounds);
    }

    @Override
    public void onDetach() {
        super.onDetach();
        replaceRect(null);
    }

    private final void replaceRect(Rect newRect) {
        MutableVector<Rect> mutableVectorCurrentRects = currentRects();
        Rect rect = this.androidRect;
        if (rect != null) {
            mutableVectorCurrentRects.remove(rect);
        }
        if (newRect != null && !newRect.isEmpty()) {
            mutableVectorCurrentRects.add(newRect);
        }
        updateRects(mutableVectorCurrentRects);
        this.androidRect = newRect;
    }

    private final Rect calcBounds(LayoutCoordinates layoutCoordinates, androidx.compose.p002ui.geometry.Rect rect) {
        LayoutCoordinates layoutCoordinatesFindRootCoordinates = LayoutCoordinatesKt.findRootCoordinates(layoutCoordinates);
        long jMo6041localPositionOfR5De75A = layoutCoordinatesFindRootCoordinates.mo6041localPositionOfR5De75A(layoutCoordinates, rect.m4381getTopLeftF1C5BW0());
        long jMo6041localPositionOfR5De75A2 = layoutCoordinatesFindRootCoordinates.mo6041localPositionOfR5De75A(layoutCoordinates, rect.m4382getTopRightF1C5BW0());
        long jMo6041localPositionOfR5De75A3 = layoutCoordinatesFindRootCoordinates.mo6041localPositionOfR5De75A(layoutCoordinates, rect.m4374getBottomLeftF1C5BW0());
        long jMo6041localPositionOfR5De75A4 = layoutCoordinatesFindRootCoordinates.mo6041localPositionOfR5De75A(layoutCoordinates, rect.m4375getBottomRightF1C5BW0());
        return new Rect(MathKt.roundToInt(ComparisonsKt.minOf(Offset.m4346getXimpl(jMo6041localPositionOfR5De75A), new float[]{Offset.m4346getXimpl(jMo6041localPositionOfR5De75A2), Offset.m4346getXimpl(jMo6041localPositionOfR5De75A3), Offset.m4346getXimpl(jMo6041localPositionOfR5De75A4)})), MathKt.roundToInt(ComparisonsKt.minOf(Offset.m4347getYimpl(jMo6041localPositionOfR5De75A), new float[]{Offset.m4347getYimpl(jMo6041localPositionOfR5De75A2), Offset.m4347getYimpl(jMo6041localPositionOfR5De75A3), Offset.m4347getYimpl(jMo6041localPositionOfR5De75A4)})), MathKt.roundToInt(ComparisonsKt.maxOf(Offset.m4346getXimpl(jMo6041localPositionOfR5De75A), new float[]{Offset.m4346getXimpl(jMo6041localPositionOfR5De75A2), Offset.m4346getXimpl(jMo6041localPositionOfR5De75A3), Offset.m4346getXimpl(jMo6041localPositionOfR5De75A4)})), MathKt.roundToInt(ComparisonsKt.maxOf(Offset.m4347getYimpl(jMo6041localPositionOfR5De75A), new float[]{Offset.m4347getYimpl(jMo6041localPositionOfR5De75A2), Offset.m4347getYimpl(jMo6041localPositionOfR5De75A3), Offset.m4347getYimpl(jMo6041localPositionOfR5De75A4)})));
    }
}
