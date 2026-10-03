package androidx.compose.p002ui.focus;

import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.layout.BeyondBoundsLayout;
import androidx.compose.p002ui.node.DelegatableNodeKt;
import androidx.compose.p002ui.node.DelegatingNode;
import androidx.compose.p002ui.node.LayoutNode;
import androidx.compose.p002ui.node.NodeChain;
import androidx.compose.p002ui.node.NodeKind;
import androidx.compose.runtime.collection.MutableVector;
import kotlin.KotlinNothingValueException;
import kotlin.Metadata;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000 \n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\u001aA\u0010\u0000\u001a\u0004\u0018\u0001H\u0001\"\u0004\b\u0000\u0010\u0001*\u00020\u00022\u0006\u0010\u0003\u001a\u00020\u00042\u0019\u0010\u0005\u001a\u0015\u0012\u0004\u0012\u00020\u0007\u0012\u0006\u0012\u0004\u0018\u0001H\u00010\u0006¢\u0006\u0002\b\bH\u0000ø\u0001\u0000¢\u0006\u0004\b\t\u0010\n\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u000b"}, d2 = {"searchBeyondBounds", "T", "Landroidx/compose/ui/focus/FocusTargetNode;", "direction", "Landroidx/compose/ui/focus/FocusDirection;", "block", "Lkotlin/Function1;", "Landroidx/compose/ui/layout/BeyondBoundsLayout$BeyondBoundsScope;", "Lkotlin/ExtensionFunctionType;", "searchBeyondBounds--OM-vw8", "(Landroidx/compose/ui/focus/FocusTargetNode;ILkotlin/jvm/functions/Function1;)Ljava/lang/Object;", "ui_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class BeyondBoundsLayoutKt {
    public static final <T> T m4247searchBeyondBoundsOMvw8(FocusTargetNode focusTargetNode, int i, Function1<? super BeyondBoundsLayout.BeyondBoundsScope, ? extends T> function1) throws KotlinNothingValueException {
        Modifier.Node nodePop;
        BeyondBoundsLayout beyondBoundsLayoutParent;
        int iM6011getBeforehoxUOeE;
        NodeChain nodes;
        FocusTargetNode focusTargetNode2 = focusTargetNode;
        int iM6367constructorimpl = NodeKind.m6367constructorimpl(Fields.RotationZ);
        if (!focusTargetNode2.getNode().getIsAttached()) {
            throw new IllegalStateException("visitAncestors called on an unattached node".toString());
        }
        Modifier.Node parent = focusTargetNode2.getNode().getParent();
        LayoutNode layoutNodeRequireLayoutNode = DelegatableNodeKt.requireLayoutNode(focusTargetNode2);
        loop0: while (true) {
            if (layoutNodeRequireLayoutNode == null) {
                nodePop = null;
                break;
            }
            if ((layoutNodeRequireLayoutNode.getNodes().getHead().getAggregateChildKindSet() & iM6367constructorimpl) != 0) {
                while (parent != null) {
                    if ((parent.getKindSet() & iM6367constructorimpl) != 0) {
                        nodePop = parent;
                        MutableVector mutableVector = null;
                        while (nodePop != null) {
                            if (nodePop instanceof FocusTargetNode) {
                                break loop0;
                            }
                            if ((nodePop.getKindSet() & iM6367constructorimpl) != 0 && (nodePop instanceof DelegatingNode)) {
                                int i2 = 0;
                                for (Modifier.Node delegate = ((DelegatingNode) nodePop).getDelegate(); delegate != null; delegate = delegate.getChild()) {
                                    if ((delegate.getKindSet() & iM6367constructorimpl) != 0) {
                                        i2++;
                                        if (i2 == 1) {
                                            nodePop = delegate;
                                        } else {
                                            if (mutableVector == null) {
                                                mutableVector = new MutableVector(new Modifier.Node[16], 0);
                                            }
                                            if (nodePop != null) {
                                                if (mutableVector != null) {
                                                    mutableVector.add(nodePop);
                                                }
                                                nodePop = null;
                                            }
                                            if (mutableVector != null) {
                                                mutableVector.add(delegate);
                                            }
                                        }
                                    }
                                }
                                if (i2 == 1) {
                                }
                            }
                            nodePop = DelegatableNodeKt.pop(mutableVector);
                        }
                    }
                    parent = parent.getParent();
                }
            }
            layoutNodeRequireLayoutNode = layoutNodeRequireLayoutNode.getParent$ui_release();
            parent = (layoutNodeRequireLayoutNode == null || (nodes = layoutNodeRequireLayoutNode.getNodes()) == null) ? null : nodes.getTail();
        }
        FocusTargetNode focusTargetNode3 = (FocusTargetNode) nodePop;
        if ((focusTargetNode3 != null && Intrinsics.areEqual(focusTargetNode3.getBeyondBoundsLayoutParent(), focusTargetNode.getBeyondBoundsLayoutParent())) || (beyondBoundsLayoutParent = focusTargetNode.getBeyondBoundsLayoutParent()) == null) {
            return null;
        }
        if (FocusDirection.m4251equalsimpl0(i, FocusDirection.INSTANCE.m4264getUpdhqQ8s())) {
            iM6011getBeforehoxUOeE = BeyondBoundsLayout.LayoutDirection.INSTANCE.m6009getAbovehoxUOeE();
        } else if (FocusDirection.m4251equalsimpl0(i, FocusDirection.INSTANCE.m4257getDowndhqQ8s())) {
            iM6011getBeforehoxUOeE = BeyondBoundsLayout.LayoutDirection.INSTANCE.m6012getBelowhoxUOeE();
        } else if (FocusDirection.m4251equalsimpl0(i, FocusDirection.INSTANCE.m4260getLeftdhqQ8s())) {
            iM6011getBeforehoxUOeE = BeyondBoundsLayout.LayoutDirection.INSTANCE.m6013getLefthoxUOeE();
        } else if (FocusDirection.m4251equalsimpl0(i, FocusDirection.INSTANCE.m4263getRightdhqQ8s())) {
            iM6011getBeforehoxUOeE = BeyondBoundsLayout.LayoutDirection.INSTANCE.m6014getRighthoxUOeE();
        } else if (FocusDirection.m4251equalsimpl0(i, FocusDirection.INSTANCE.m4261getNextdhqQ8s())) {
            iM6011getBeforehoxUOeE = BeyondBoundsLayout.LayoutDirection.INSTANCE.m6010getAfterhoxUOeE();
        } else {
            if (!FocusDirection.m4251equalsimpl0(i, FocusDirection.INSTANCE.m4262getPreviousdhqQ8s())) {
                throw new IllegalStateException("Unsupported direction for beyond bounds layout".toString());
            }
            iM6011getBeforehoxUOeE = BeyondBoundsLayout.LayoutDirection.INSTANCE.m6011getBeforehoxUOeE();
        }
        return (T) beyondBoundsLayoutParent.mo1200layouto7g1Pn8(iM6011getBeforehoxUOeE, function1);
    }
}
