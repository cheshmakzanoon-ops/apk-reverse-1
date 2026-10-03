package androidx.compose.p002ui.draganddrop;

import androidx.autofill.HintConstants;
import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.layout.LayoutCoordinates;
import androidx.compose.p002ui.layout.LayoutCoordinatesKt;
import androidx.compose.p002ui.node.DelegatableNodeKt;
import androidx.compose.p002ui.node.TraversableNode;
import androidx.compose.p002ui.node.TraversableNodeKt;
import androidx.compose.ui.unit.IntSize;
import kotlin.Metadata;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Ref;

@Metadata(d1 = {"\u0000F\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\u001a\u0006\u0010\u0000\u001a\u00020\u0001\u001a1\u0010\u0000\u001a\u00020\u00012!\u0010\u0002\u001a\u001d\u0012\u0013\u0012\u00110\u0004¢\u0006\f\b\u0005\u0012\b\b\u0006\u0012\u0004\b\b(\u0007\u0012\u0004\u0012\u00020\b0\u00032\u0006\u0010\t\u001a\u00020\n\u001a\u001e\u0010\u000b\u001a\u00020\b*\u00020\u00012\u0006\u0010\f\u001a\u00020\rH\u0002ø\u0001\u0000¢\u0006\u0004\b\u000e\u0010\u000f\u001a\u0014\u0010\u0010\u001a\u00020\u0011*\u00020\n2\u0006\u0010\u0007\u001a\u00020\u0004H\u0002\u001a4\u0010\u0012\u001a\u0004\u0018\u0001H\u0013\"\b\b\u0000\u0010\u0013*\u00020\u0014*\u0002H\u00132\u0014\b\u0004\u0010\u0015\u001a\u000e\u0012\u0004\u0012\u0002H\u0013\u0012\u0004\u0012\u00020\b0\u0003H\u0082\b¢\u0006\u0002\u0010\u0016\u001a/\u0010\u0017\u001a\u00020\u0011\"\b\b\u0000\u0010\u0013*\u00020\u0014*\u0002H\u00132\u0012\u0010\u0018\u001a\u000e\u0012\u0004\u0012\u0002H\u0013\u0012\u0004\u0012\u00020\u00190\u0003H\u0002¢\u0006\u0002\u0010\u001a\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u001b"}, d2 = {"DragAndDropModifierNode", "Landroidx/compose/ui/draganddrop/DragAndDropModifierNode;", "shouldStartDragAndDrop", "Lkotlin/Function1;", "Landroidx/compose/ui/draganddrop/DragAndDropEvent;", "Lkotlin/ParameterName;", HintConstants.AUTOFILL_HINT_NAME, "event", "", "target", "Landroidx/compose/ui/draganddrop/DragAndDropTarget;", "contains", "position", "Landroidx/compose/ui/geometry/Offset;", "contains-Uv8p0NA", "(Landroidx/compose/ui/draganddrop/DragAndDropModifierNode;J)Z", "dispatchEntered", "", "firstDescendantOrNull", "T", "Landroidx/compose/ui/node/TraversableNode;", "predicate", "(Landroidx/compose/ui/node/TraversableNode;Lkotlin/jvm/functions/Function1;)Landroidx/compose/ui/node/TraversableNode;", "traverseSelfAndDescendants", "block", "Landroidx/compose/ui/node/TraversableNode$Companion$TraverseDescendantsAction;", "(Landroidx/compose/ui/node/TraversableNode;Lkotlin/jvm/functions/Function1;)V", "ui_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class DragAndDropNodeKt {
    public static final DragAndDropModifierNode DragAndDropModifierNode() {
        return new DragAndDropNode(new Function1<DragAndDropEvent, DragAndDropTarget>() {
            public final DragAndDropTarget invoke(DragAndDropEvent dragAndDropEvent) {
                return null;
            }
        });
    }

    public static final DragAndDropModifierNode DragAndDropModifierNode(final Function1<? super DragAndDropEvent, Boolean> function1, final DragAndDropTarget dragAndDropTarget) {
        return new DragAndDropNode(new Function1<DragAndDropEvent, DragAndDropTarget>() {
            {
                super(1);
            }

            public final DragAndDropTarget invoke(DragAndDropEvent dragAndDropEvent) {
                if (((Boolean) function1.invoke(dragAndDropEvent)).booleanValue()) {
                    return dragAndDropTarget;
                }
                return null;
            }
        });
    }

    public static final void dispatchEntered(DragAndDropTarget dragAndDropTarget, DragAndDropEvent dragAndDropEvent) {
        dragAndDropTarget.onEntered(dragAndDropEvent);
        dragAndDropTarget.onMoved(dragAndDropEvent);
    }

    public static final boolean m4199containsUv8p0NA(DragAndDropModifierNode dragAndDropModifierNode, long j) {
        if (!dragAndDropModifierNode.getNode().getIsAttached()) {
            return false;
        }
        LayoutCoordinates coordinates = DelegatableNodeKt.requireLayoutNode(dragAndDropModifierNode).getCoordinates();
        if (!coordinates.isAttached()) {
            return false;
        }
        long jMo6040getSizeYbymL2g = coordinates.mo6040getSizeYbymL2g();
        int i = IntSize.getWidth-impl(jMo6040getSizeYbymL2g);
        int i2 = IntSize.getHeight-impl(jMo6040getSizeYbymL2g);
        long jPositionInRoot = LayoutCoordinatesKt.positionInRoot(coordinates);
        float fM4346getXimpl = Offset.m4346getXimpl(jPositionInRoot);
        float fM4347getYimpl = Offset.m4347getYimpl(jPositionInRoot);
        float f = i + fM4346getXimpl;
        float f2 = i2 + fM4347getYimpl;
        float fM4346getXimpl2 = Offset.m4346getXimpl(j);
        if (fM4346getXimpl > fM4346getXimpl2 || fM4346getXimpl2 > f) {
            return false;
        }
        float fM4347getYimpl2 = Offset.m4347getYimpl(j);
        return fM4347getYimpl <= fM4347getYimpl2 && fM4347getYimpl2 <= f2;
    }

    public static final <T extends TraversableNode> void traverseSelfAndDescendants(T t, Function1<? super T, ? extends TraversableNode.Companion.TraverseDescendantsAction> function1) {
        if (function1.invoke(t) != TraversableNode.Companion.TraverseDescendantsAction.ContinueTraversal) {
            return;
        }
        TraversableNodeKt.traverseDescendants(t, function1);
    }

    private static final <T extends TraversableNode> T firstDescendantOrNull(T t, final Function1<? super T, Boolean> function1) {
        if (!t.getNode().getIsAttached()) {
            return null;
        }
        final Ref.ObjectRef objectRef = new Ref.ObjectRef();
        TraversableNodeKt.traverseDescendants(t, new Function1<T, TraversableNode.Companion.TraverseDescendantsAction>() {
            {
                super(1);
            }

            public final TraversableNode.Companion.TraverseDescendantsAction invoke(TraversableNode traversableNode) {
                if (((Boolean) function1.invoke(traversableNode)).booleanValue()) {
                    objectRef.element = traversableNode;
                    return TraversableNode.Companion.TraverseDescendantsAction.CancelTraversal;
                }
                return TraversableNode.Companion.TraverseDescendantsAction.ContinueTraversal;
            }
        });
        return (T) objectRef.element;
    }
}
