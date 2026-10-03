package androidx.compose.p002ui.focus;

import androidx.compose.p002ui.node.DelegatableNodeKt;
import androidx.compose.p002ui.node.LayoutNode;
import androidx.compose.runtime.collection.MutableVector;
import java.util.Comparator;
import kotlin.KotlinNothingValueException;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÂ\u0002\u0018\u00002\u0012\u0012\u0004\u0012\u00020\u00020\u0001j\b\u0012\u0004\u0012\u00020\u0002`\u0003B\u0007\b\u0002¢\u0006\u0002\u0010\u0004J\u0018\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\u00022\u0006\u0010\b\u001a\u00020\u0002H\u0016J\u0016\u0010\t\u001a\b\u0012\u0004\u0012\u00020\u000b0\n2\u0006\u0010\f\u001a\u00020\u000bH\u0002¨\u0006\r"}, d2 = {"Landroidx/compose/ui/focus/FocusableChildrenComparator;", "Ljava/util/Comparator;", "Landroidx/compose/ui/focus/FocusTargetNode;", "Lkotlin/Comparator;", "()V", "compare", "", "a", "b", "pathFromRoot", "Landroidx/compose/runtime/collection/MutableVector;", "Landroidx/compose/ui/node/LayoutNode;", "layoutNode", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
final class FocusableChildrenComparator implements Comparator<FocusTargetNode> {
    public static final FocusableChildrenComparator INSTANCE = new FocusableChildrenComparator();

    private FocusableChildrenComparator() {
    }

    @Override
    public int compare(FocusTargetNode a2, FocusTargetNode b) throws KotlinNothingValueException {
        int i = 0;
        if (!FocusTraversalKt.isEligibleForFocusSearch(a2) || !FocusTraversalKt.isEligibleForFocusSearch(b)) {
            if (FocusTraversalKt.isEligibleForFocusSearch(a2)) {
                return -1;
            }
            return FocusTraversalKt.isEligibleForFocusSearch(b) ? 1 : 0;
        }
        LayoutNode layoutNodeRequireLayoutNode = DelegatableNodeKt.requireLayoutNode(a2);
        LayoutNode layoutNodeRequireLayoutNode2 = DelegatableNodeKt.requireLayoutNode(b);
        if (Intrinsics.areEqual(layoutNodeRequireLayoutNode, layoutNodeRequireLayoutNode2)) {
            return 0;
        }
        MutableVector<LayoutNode> mutableVectorPathFromRoot = pathFromRoot(layoutNodeRequireLayoutNode);
        MutableVector<LayoutNode> mutableVectorPathFromRoot2 = pathFromRoot(layoutNodeRequireLayoutNode2);
        int iMin = Math.min(mutableVectorPathFromRoot.getSize() - 1, mutableVectorPathFromRoot2.getSize() - 1);
        if (iMin >= 0) {
            while (Intrinsics.areEqual(mutableVectorPathFromRoot.getContent()[i], mutableVectorPathFromRoot2.getContent()[i])) {
                if (i != iMin) {
                    i++;
                }
            }
            return Intrinsics.compare(mutableVectorPathFromRoot.getContent()[i].getPlaceOrder$ui_release(), mutableVectorPathFromRoot2.getContent()[i].getPlaceOrder$ui_release());
        }
        throw new IllegalStateException("Could not find a common ancestor between the two FocusModifiers.".toString());
    }

    private final MutableVector<LayoutNode> pathFromRoot(LayoutNode layoutNode) {
        MutableVector<LayoutNode> mutableVector = new MutableVector<>(new LayoutNode[16], 0);
        while (layoutNode != null) {
            mutableVector.add(0, layoutNode);
            layoutNode = layoutNode.getParent$ui_release();
        }
        return mutableVector;
    }
}
