package androidx.compose.foundation.relocation;

import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.geometry.Rect;
import androidx.compose.p002ui.layout.LayoutCoordinates;
import androidx.compose.p002ui.node.DelegatableNode;
import androidx.compose.p002ui.node.TraversableNodeKt;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000$\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\u001a\u0014\u0010\u0000\u001a\u00020\u0001*\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u0003H\u0007\u001a\u000e\u0010\u0004\u001a\u0004\u0018\u00010\u0005*\u00020\u0006H\u0000\u001a!\u0010\u0007\u001a\u00020\b*\u00020\t2\u0006\u0010\n\u001a\u00020\t2\u0006\u0010\u000b\u001a\u00020\bH\u0002¢\u0006\u0002\b\f¨\u0006\r"}, d2 = {"bringIntoViewResponder", "Landroidx/compose/ui/Modifier;", "responder", "Landroidx/compose/foundation/relocation/BringIntoViewResponder;", "findBringIntoViewParent", "Landroidx/compose/foundation/relocation/BringIntoViewParent;", "Landroidx/compose/ui/node/DelegatableNode;", "localRectOf", "Landroidx/compose/ui/geometry/Rect;", "Landroidx/compose/ui/layout/LayoutCoordinates;", "sourceCoordinates", "rect", "localRectOf$BringIntoViewRequesterKt__BringIntoViewResponderKt", "foundation_release"}, k = 5, mv = {1, 8, 0}, xi = 48, xs = "androidx/compose/foundation/relocation/BringIntoViewRequesterKt")
final class BringIntoViewRequesterKt__BringIntoViewResponderKt {
    public static final Modifier bringIntoViewResponder(Modifier modifier, BringIntoViewResponder bringIntoViewResponder) {
        return modifier.then(new BringIntoViewResponderElement(bringIntoViewResponder));
    }

    public static final BringIntoViewParent findBringIntoViewParent(DelegatableNode delegatableNode) {
        if (!delegatableNode.getNode().getIsAttached()) {
            return null;
        }
        BringIntoViewParent bringIntoViewParent = (BringIntoViewParent) TraversableNodeKt.findNearestAncestor(delegatableNode, BringIntoViewResponderNode.TraverseKey);
        return bringIntoViewParent == null ? BringIntoViewResponder_androidKt.defaultBringIntoViewParent(delegatableNode) : bringIntoViewParent;
    }

    public static final Rect localRectOf$BringIntoViewRequesterKt__BringIntoViewResponderKt(LayoutCoordinates layoutCoordinates, LayoutCoordinates layoutCoordinates2, Rect rect) {
        return rect.m4383translatek4lQ0M(layoutCoordinates.localBoundingBoxOf(layoutCoordinates2, false).m4381getTopLeftF1C5BW0());
    }
}
