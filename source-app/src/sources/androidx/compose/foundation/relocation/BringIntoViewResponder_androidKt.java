package androidx.compose.foundation.relocation;

import android.view.View;
import androidx.compose.p002ui.geometry.Rect;
import androidx.compose.p002ui.layout.LayoutCoordinates;
import androidx.compose.p002ui.layout.LayoutCoordinatesKt;
import androidx.compose.p002ui.node.DelegatableNode;
import androidx.compose.p002ui.node.DelegatableNode_androidKt;
import kotlin.KotlinNothingValueException;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.jvm.functions.Function0;

@Metadata(d1 = {"\u0000\u0016\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\u001a\f\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u0000\u001a\f\u0010\u0003\u001a\u00020\u0004*\u00020\u0005H\u0002¨\u0006\u0006"}, d2 = {"defaultBringIntoViewParent", "Landroidx/compose/foundation/relocation/BringIntoViewParent;", "Landroidx/compose/ui/node/DelegatableNode;", "toRect", "Landroid/graphics/Rect;", "Landroidx/compose/ui/geometry/Rect;", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class BringIntoViewResponder_androidKt {
    public static final BringIntoViewParent defaultBringIntoViewParent(final DelegatableNode delegatableNode) {
        return new BringIntoViewParent() {
            @Override
            public final Object bringChildIntoView(LayoutCoordinates layoutCoordinates, Function0<Rect> function0, Continuation<? super Unit> continuation) throws KotlinNothingValueException {
                View viewRequireView = DelegatableNode_androidKt.requireView(delegatableNode);
                long jPositionInRoot = LayoutCoordinatesKt.positionInRoot(layoutCoordinates);
                Rect rect = (Rect) function0.invoke();
                Rect rectM4383translatek4lQ0M = rect != null ? rect.m4383translatek4lQ0M(jPositionInRoot) : null;
                if (rectM4383translatek4lQ0M != null) {
                    viewRequireView.requestRectangleOnScreen(BringIntoViewResponder_androidKt.toRect(rectM4383translatek4lQ0M), false);
                }
                return Unit.INSTANCE;
            }
        };
    }

    public static final android.graphics.Rect toRect(Rect rect) {
        return new android.graphics.Rect((int) rect.getLeft(), (int) rect.getTop(), (int) rect.getRight(), (int) rect.getBottom());
    }
}
