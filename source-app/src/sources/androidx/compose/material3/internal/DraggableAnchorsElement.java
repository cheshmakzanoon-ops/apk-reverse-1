package androidx.compose.material3.internal;

import androidx.autofill.HintConstants;
import androidx.compose.foundation.gestures.Orientation;
import androidx.compose.p002ui.node.ModifierNodeElement;
import androidx.compose.p002ui.platform.InspectableValueKt;
import androidx.compose.p002ui.platform.InspectorInfo;
import androidx.compose.ui.unit.Constraints;
import androidx.compose.ui.unit.IntSize;
import kotlin.Metadata;
import kotlin.Pair;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000^\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\b\u0002\u0018\u0000*\u0004\b\u0000\u0010\u00012\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u0002H\u00010\u00030\u0002Be\u0012\f\u0010\u0004\u001a\b\u0012\u0004\u0012\u00028\u00000\u0005\u0012H\u0010\u0006\u001aD\u0012\u0013\u0012\u00110\b¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\u000b\u0012\u0013\u0012\u00110\f¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\r\u0012\u0016\u0012\u0014\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000\u000f\u0012\u0004\u0012\u00028\u00000\u000e0\u0007\u0012\u0006\u0010\u0010\u001a\u00020\u0011¢\u0006\u0002\u0010\u0012J\u000e\u0010\u0013\u001a\b\u0012\u0004\u0012\u00028\u00000\u0003H\u0016J\u0013\u0010\u0014\u001a\u00020\u00152\b\u0010\u0016\u001a\u0004\u0018\u00010\u0017H\u0096\u0002J\b\u0010\u0018\u001a\u00020\u0019H\u0016J\u0016\u0010\u001a\u001a\u00020\u001b2\f\u0010\u001c\u001a\b\u0012\u0004\u0012\u00028\u00000\u0003H\u0016J\f\u0010\u001d\u001a\u00020\u001b*\u00020\u001eH\u0016RP\u0010\u0006\u001aD\u0012\u0013\u0012\u00110\b¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\u000b\u0012\u0013\u0012\u00110\f¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\r\u0012\u0016\u0012\u0014\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000\u000f\u0012\u0004\u0012\u00028\u00000\u000e0\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0010\u001a\u00020\u0011X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u0004\u001a\b\u0012\u0004\u0012\u00028\u00000\u0005X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u001f"}, d2 = {"Landroidx/compose/material3/internal/DraggableAnchorsElement;", "T", "Landroidx/compose/ui/node/ModifierNodeElement;", "Landroidx/compose/material3/internal/DraggableAnchorsNode;", "state", "Landroidx/compose/material3/internal/AnchoredDraggableState;", "anchors", "Lkotlin/Function2;", "Landroidx/compose/ui/unit/IntSize;", "Lkotlin/ParameterName;", HintConstants.AUTOFILL_HINT_NAME, "size", "Landroidx/compose/ui/unit/Constraints;", "constraints", "Lkotlin/Pair;", "Landroidx/compose/material3/internal/DraggableAnchors;", "orientation", "Landroidx/compose/foundation/gestures/Orientation;", "(Landroidx/compose/material3/internal/AnchoredDraggableState;Lkotlin/jvm/functions/Function2;Landroidx/compose/foundation/gestures/Orientation;)V", "create", "equals", "", "other", "", "hashCode", "", "update", "", "node", "inspectableProperties", "Landroidx/compose/ui/platform/InspectorInfo;", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
final class DraggableAnchorsElement<T> extends ModifierNodeElement<DraggableAnchorsNode<T>> {
    private final Function2<IntSize, Constraints, Pair<DraggableAnchors<T>, T>> anchors;
    private final Orientation orientation;
    private final AnchoredDraggableState<T> state;

    public DraggableAnchorsElement(AnchoredDraggableState<T> anchoredDraggableState, Function2<? super IntSize, ? super Constraints, ? extends Pair<? extends DraggableAnchors<T>, ? extends T>> function2, Orientation orientation) {
        this.state = anchoredDraggableState;
        this.anchors = function2;
        this.orientation = orientation;
    }

    @Override
    public DraggableAnchorsNode<T> getNode() {
        return new DraggableAnchorsNode<>(this.state, this.anchors, this.orientation);
    }

    @Override
    public void update(DraggableAnchorsNode<T> node) {
        node.setState(this.state);
        node.setAnchors(this.anchors);
        node.setOrientation(this.orientation);
    }

    @Override
    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof DraggableAnchorsElement)) {
            return false;
        }
        DraggableAnchorsElement draggableAnchorsElement = (DraggableAnchorsElement) other;
        return Intrinsics.areEqual(this.state, draggableAnchorsElement.state) && this.anchors == draggableAnchorsElement.anchors && this.orientation == draggableAnchorsElement.orientation;
    }

    @Override
    public int hashCode() {
        return (((this.state.hashCode() * 31) + this.anchors.hashCode()) * 31) + this.orientation.hashCode();
    }

    @Override
    public void inspectableProperties(InspectorInfo inspectorInfo) {
        if (InspectableValueKt.isDebugInspectorInfoEnabled()) {
            new Function1<InspectorInfo, Unit>() {
                {
                    super(1);
                }

                public Object invoke(Object obj) {
                    invoke((InspectorInfo) obj);
                    return Unit.INSTANCE;
                }

                public final void invoke(InspectorInfo inspectorInfo2) {
                    inspectorInfo2.getProperties().set("state", this.this$0.state);
                    inspectorInfo2.getProperties().set("anchors", this.this$0.anchors);
                    inspectorInfo2.getProperties().set("orientation", this.this$0.orientation);
                }
            };
        } else {
            InspectableValueKt.getNoInspectorInfo();
        }
    }
}
