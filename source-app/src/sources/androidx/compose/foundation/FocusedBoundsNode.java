package androidx.compose.foundation;

import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.layout.LayoutCoordinates;
import androidx.compose.p002ui.node.GlobalPositionAwareModifierNode;
import androidx.compose.p002ui.node.TraversableNode;
import androidx.compose.p002ui.node.TraversableNodeKt;
import kotlin.KotlinNothingValueException;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u00008\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u0000\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0006\b\u0000\u0018\u0000 \u001a2\u00020\u00012\u00020\u00022\u00020\u0003:\u0001\u001aB\u0005¢\u0006\u0002\u0010\u0004J\b\u0010\u0014\u001a\u00020\u0015H\u0002J\u0010\u0010\u0016\u001a\u00020\u00152\u0006\u0010\u0017\u001a\u00020\bH\u0016J\u000e\u0010\u0018\u001a\u00020\u00152\u0006\u0010\u0019\u001a\u00020\u0006R\u000e\u0010\u0005\u001a\u00020\u0006X\u0082\u000e¢\u0006\u0002\n\u0000R\u0010\u0010\u0007\u001a\u0004\u0018\u00010\bX\u0082\u000e¢\u0006\u0002\n\u0000R\u0016\u0010\t\u001a\u0004\u0018\u00010\n8BX\u0082\u0004¢\u0006\u0006\u001a\u0004\b\u000b\u0010\fR\u0014\u0010\r\u001a\u00020\u0006X\u0096D¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000fR\u0014\u0010\u0010\u001a\u00020\u00118VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u0012\u0010\u0013¨\u0006\u001b"}, d2 = {"Landroidx/compose/foundation/FocusedBoundsNode;", "Landroidx/compose/ui/Modifier$Node;", "Landroidx/compose/ui/node/TraversableNode;", "Landroidx/compose/ui/node/GlobalPositionAwareModifierNode;", "()V", "isFocused", "", "layoutCoordinates", "Landroidx/compose/ui/layout/LayoutCoordinates;", "observer", "Landroidx/compose/foundation/FocusedBoundsObserverNode;", "getObserver", "()Landroidx/compose/foundation/FocusedBoundsObserverNode;", "shouldAutoInvalidate", "getShouldAutoInvalidate", "()Z", "traverseKey", "", "getTraverseKey", "()Ljava/lang/Object;", "notifyObserverWhenAttached", "", "onGloballyPositioned", "coordinates", "setFocus", "focused", "TraverseKey", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class FocusedBoundsNode extends Modifier.Node implements TraversableNode, GlobalPositionAwareModifierNode {
    private boolean isFocused;
    private LayoutCoordinates layoutCoordinates;
    private final boolean shouldAutoInvalidate;

    public static final Companion INSTANCE = new Companion(null);
    public static final int $stable = 8;

    @Override
    public Object getTraverseKey() {
        return INSTANCE;
    }

    @Override
    public boolean getShouldAutoInvalidate() {
        return this.shouldAutoInvalidate;
    }

    private final FocusedBoundsObserverNode getObserver() throws KotlinNothingValueException {
        if (!getIsAttached()) {
            return null;
        }
        TraversableNode traversableNodeFindNearestAncestor = TraversableNodeKt.findNearestAncestor(this, FocusedBoundsObserverNode.INSTANCE);
        if (traversableNodeFindNearestAncestor instanceof FocusedBoundsObserverNode) {
            return (FocusedBoundsObserverNode) traversableNodeFindNearestAncestor;
        }
        return null;
    }

    public final void setFocus(boolean focused) throws KotlinNothingValueException {
        if (focused == this.isFocused) {
            return;
        }
        if (!focused) {
            FocusedBoundsObserverNode observer = getObserver();
            if (observer != null) {
                observer.onFocusBoundsChanged(null);
            }
        } else {
            notifyObserverWhenAttached();
        }
        this.isFocused = focused;
    }

    @Override
    public void onGloballyPositioned(LayoutCoordinates coordinates) throws KotlinNothingValueException {
        this.layoutCoordinates = coordinates;
        if (this.isFocused) {
            if (coordinates.isAttached()) {
                notifyObserverWhenAttached();
                return;
            }
            FocusedBoundsObserverNode observer = getObserver();
            if (observer != null) {
                observer.onFocusBoundsChanged(null);
            }
        }
    }

    private final void notifyObserverWhenAttached() {
        FocusedBoundsObserverNode observer;
        LayoutCoordinates layoutCoordinates = this.layoutCoordinates;
        if (layoutCoordinates != null) {
            Intrinsics.checkNotNull(layoutCoordinates);
            if (!layoutCoordinates.isAttached() || (observer = getObserver()) == null) {
                return;
            }
            observer.onFocusBoundsChanged(this.layoutCoordinates);
        }
    }

    @Metadata(d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, d2 = {"Landroidx/compose/foundation/FocusedBoundsNode$TraverseKey;", "", "()V", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
