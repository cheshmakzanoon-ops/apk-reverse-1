package androidx.compose.p000ui.viewinterop;

import android.graphics.Rect;
import android.view.FocusFinder;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import androidx.compose.runtime.collection.MutableVector;
import androidx.compose.ui.Modifier;
import androidx.compose.ui.focus.FocusDirection;
import androidx.compose.ui.focus.FocusInteropUtils_androidKt;
import androidx.compose.ui.focus.FocusOwner;
import androidx.compose.ui.focus.FocusProperties;
import androidx.compose.ui.focus.FocusPropertiesModifierNode;
import androidx.compose.ui.focus.FocusRequester;
import androidx.compose.ui.focus.FocusTargetNode;
import androidx.compose.ui.focus.FocusTransactionManager;
import androidx.compose.ui.focus.FocusTransactionsKt;
import androidx.compose.ui.internal.InlineClassHelperKt;
import androidx.compose.ui.node.DelegatableNode;
import androidx.compose.ui.node.DelegatableNodeKt;
import androidx.compose.ui.node.DelegatingNode;
import androidx.compose.ui.node.NodeKind;
import androidx.compose.ui.node.Owner;
import androidx.constraintlayout.widget.ConstraintLayout;
import kotlin.Metadata;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.FunctionReferenceImpl;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000B\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u000b\b\u0002\u0018\u00002\u00020\u00012\u00020\u00022\u00020\u00032\u00020\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0010\u0010\f\u001a\u00020\r2\u0006\u0010\u000e\u001a\u00020\u000fH\u0016J\b\u0010\u0010\u001a\u00020\u0011H\u0002J\b\u0010\u0012\u001a\u00020\rH\u0016J\b\u0010\u0013\u001a\u00020\rH\u0016J\u0018\u0010\u0014\u001a\u00020\u00152\u0006\u0010\u0016\u001a\u00020\u0017ø\u0001\u0000¢\u0006\u0004\b\u0018\u0010\u0019J\u0018\u0010\u001a\u001a\u00020\u00152\u0006\u0010\u0016\u001a\u00020\u0017ø\u0001\u0000¢\u0006\u0004\b\u001b\u0010\u0019J\u001c\u0010\u001c\u001a\u00020\r2\b\u0010\u001d\u001a\u0004\u0018\u00010\u00072\b\u0010\u001e\u001a\u0004\u0018\u00010\u0007H\u0016J\u0010\u0010\u001f\u001a\u00020\r2\u0006\u0010 \u001a\u00020\u0007H\u0016J\u0010\u0010!\u001a\u00020\r2\u0006\u0010 \u001a\u00020\u0007H\u0016R\u001c\u0010\u0006\u001a\u0004\u0018\u00010\u0007X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\b\u0010\t\"\u0004\b\n\u0010\u000b\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\""}, d2 = {"Landroidx/compose/ui/viewinterop/FocusGroupPropertiesNode;", "Landroidx/compose/ui/Modifier$Node;", "Landroidx/compose/ui/focus/FocusPropertiesModifierNode;", "Landroid/view/ViewTreeObserver$OnGlobalFocusChangeListener;", "Landroid/view/View$OnAttachStateChangeListener;", "()V", "focusedChild", "Landroid/view/View;", "getFocusedChild", "()Landroid/view/View;", "setFocusedChild", "(Landroid/view/View;)V", "applyFocusProperties", "", "focusProperties", "Landroidx/compose/ui/focus/FocusProperties;", "getFocusTargetOfEmbeddedViewWrapper", "Landroidx/compose/ui/focus/FocusTargetNode;", "onAttach", "onDetach", "onEnter", "Landroidx/compose/ui/focus/FocusRequester;", "focusDirection", "Landroidx/compose/ui/focus/FocusDirection;", "onEnter-3ESFkO8", "(I)Landroidx/compose/ui/focus/FocusRequester;", "onExit", "onExit-3ESFkO8", "onGlobalFocusChanged", "oldFocus", "newFocus", "onViewAttachedToWindow", "v", "onViewDetachedFromWindow", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
final class FocusGroupPropertiesNode extends Modifier.Node implements FocusPropertiesModifierNode, ViewTreeObserver.OnGlobalFocusChangeListener, View.OnAttachStateChangeListener {
    private View focusedChild;

    public final View getFocusedChild() {
        return this.focusedChild;
    }

    public final void setFocusedChild(View view) {
        this.focusedChild = view;
    }

    public void applyFocusProperties(FocusProperties focusProperties) {
        focusProperties.setCanFocus(false);
        focusProperties.setEnter(new C00351(this));
        focusProperties.setExit(new C00362(this));
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    class C00351 extends FunctionReferenceImpl implements Function1<FocusDirection, FocusRequester> {
        C00351(Object obj) {
            super(1, obj, FocusGroupPropertiesNode.class, "onEnter", "onEnter-3ESFkO8(I)Landroidx/compose/ui/focus/FocusRequester;", 0);
        }

        public Object invoke(Object obj) {
            return m2103invoke3ESFkO8(((FocusDirection) obj).unbox-impl());
        }

        public final FocusRequester m2103invoke3ESFkO8(int i) {
            return ((FocusGroupPropertiesNode) this.receiver).m2101onEnter3ESFkO8(i);
        }
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    class C00362 extends FunctionReferenceImpl implements Function1<FocusDirection, FocusRequester> {
        C00362(Object obj) {
            super(1, obj, FocusGroupPropertiesNode.class, "onExit", "onExit-3ESFkO8(I)Landroidx/compose/ui/focus/FocusRequester;", 0);
        }

        public Object invoke(Object obj) {
            return m2104invoke3ESFkO8(((FocusDirection) obj).unbox-impl());
        }

        public final FocusRequester m2104invoke3ESFkO8(int i) {
            return ((FocusGroupPropertiesNode) this.receiver).m2102onExit3ESFkO8(i);
        }
    }

    public final FocusRequester m2101onEnter3ESFkO8(int focusDirection) {
        View view = FocusGroupNode_androidKt.getView(this);
        if (view.isFocused() || view.hasFocus()) {
            return FocusRequester.Companion.getDefault();
        }
        DelegatableNode delegatableNode = (DelegatableNode) this;
        FocusOwner focusOwner = DelegatableNodeKt.requireOwner(delegatableNode).getFocusOwner();
        View viewRequireOwner = DelegatableNodeKt.requireOwner(delegatableNode);
        Intrinsics.checkNotNull(viewRequireOwner, "null cannot be cast to non-null type android.view.View");
        return FocusInteropUtils_androidKt.requestInteropFocus(view, FocusInteropUtils_androidKt.toAndroidFocusDirection-3ESFkO8(focusDirection), FocusGroupNode_androidKt.getCurrentlyFocusedRect(focusOwner, viewRequireOwner, view)) ? FocusRequester.Companion.getDefault() : FocusRequester.Companion.getCancel();
    }

    public final FocusRequester m2102onExit3ESFkO8(int focusDirection) {
        View viewFindNextFocusFromRect;
        View view = FocusGroupNode_androidKt.getView(this);
        if (!view.hasFocus()) {
            return FocusRequester.Companion.getDefault();
        }
        DelegatableNode delegatableNode = (DelegatableNode) this;
        FocusOwner focusOwner = DelegatableNodeKt.requireOwner(delegatableNode).getFocusOwner();
        View viewRequireOwner = DelegatableNodeKt.requireOwner(delegatableNode);
        Intrinsics.checkNotNull(viewRequireOwner, "null cannot be cast to non-null type android.view.View");
        View view2 = viewRequireOwner;
        if (view instanceof ViewGroup) {
            Rect currentlyFocusedRect = FocusGroupNode_androidKt.getCurrentlyFocusedRect(focusOwner, view2, view);
            Integer num = FocusInteropUtils_androidKt.toAndroidFocusDirection-3ESFkO8(focusDirection);
            int iIntValue = num != null ? num.intValue() : 130;
            FocusFinder focusFinder = FocusFinder.getInstance();
            View view3 = this.focusedChild;
            if (view3 != null) {
                viewFindNextFocusFromRect = focusFinder.findNextFocus((ViewGroup) view2, view3, iIntValue);
            } else {
                viewFindNextFocusFromRect = focusFinder.findNextFocusFromRect((ViewGroup) view2, currentlyFocusedRect, iIntValue);
            }
            if (viewFindNextFocusFromRect != null && FocusGroupNode_androidKt.containsDescendant(view, viewFindNextFocusFromRect)) {
                viewFindNextFocusFromRect.requestFocus(iIntValue, currentlyFocusedRect);
                return FocusRequester.Companion.getCancel();
            }
            if (!view2.requestFocus()) {
                throw new IllegalStateException("host view did not take focus".toString());
            }
            return FocusRequester.Companion.getDefault();
        }
        if (!view2.requestFocus()) {
            throw new IllegalStateException("host view did not take focus".toString());
        }
        return FocusRequester.Companion.getDefault();
    }

    private final FocusTargetNode getFocusTargetOfEmbeddedViewWrapper() {
        DelegatableNode delegatableNode = (DelegatableNode) this;
        int i = NodeKind.constructor-impl(1024);
        if (!delegatableNode.getNode().isAttached()) {
            InlineClassHelperKt.throwIllegalStateException("visitLocalDescendants called on an unattached node");
        }
        Modifier.Node node = delegatableNode.getNode();
        if ((node.getAggregateChildKindSet$ui_release() & i) != 0) {
            boolean z = false;
            for (Modifier.Node child$ui_release = node.getChild$ui_release(); child$ui_release != null; child$ui_release = child$ui_release.getChild$ui_release()) {
                if ((child$ui_release.getKindSet$ui_release() & i) != 0) {
                    Modifier.Node nodeAccess$pop = child$ui_release;
                    MutableVector mutableVector = null;
                    while (nodeAccess$pop != null) {
                        if (nodeAccess$pop instanceof FocusTargetNode) {
                            FocusTargetNode focusTargetNode = (FocusTargetNode) nodeAccess$pop;
                            if (z) {
                                return focusTargetNode;
                            }
                            z = true;
                        } else if ((nodeAccess$pop.getKindSet$ui_release() & i) != 0 && (nodeAccess$pop instanceof DelegatingNode)) {
                            int i2 = 0;
                            for (Modifier.Node delegate$ui_release = ((DelegatingNode) nodeAccess$pop).getDelegate$ui_release(); delegate$ui_release != null; delegate$ui_release = delegate$ui_release.getChild$ui_release()) {
                                if ((delegate$ui_release.getKindSet$ui_release() & i) != 0) {
                                    i2++;
                                    if (i2 == 1) {
                                        nodeAccess$pop = delegate$ui_release;
                                    } else {
                                        if (mutableVector == null) {
                                            mutableVector = new MutableVector(new Modifier.Node[16], 0);
                                        }
                                        if (nodeAccess$pop != null) {
                                            if (mutableVector != null) {
                                                mutableVector.add(nodeAccess$pop);
                                            }
                                            nodeAccess$pop = null;
                                        }
                                        if (mutableVector != null) {
                                            mutableVector.add(delegate$ui_release);
                                        }
                                    }
                                }
                            }
                            if (i2 == 1) {
                            }
                        }
                        nodeAccess$pop = DelegatableNodeKt.access$pop(mutableVector);
                    }
                }
            }
        }
        throw new IllegalStateException("Could not find focus target of embedded view wrapper".toString());
    }

    @Override
    public void onGlobalFocusChanged(View oldFocus, View newFocus) {
        DelegatableNode delegatableNode = (DelegatableNode) this;
        if (DelegatableNodeKt.requireLayoutNode(delegatableNode).getOwner$ui_release() == null) {
            return;
        }
        View view = FocusGroupNode_androidKt.getView(this);
        FocusOwner focusOwner = DelegatableNodeKt.requireOwner(delegatableNode).getFocusOwner();
        Owner ownerRequireOwner = DelegatableNodeKt.requireOwner(delegatableNode);
        boolean z = (oldFocus == null || Intrinsics.areEqual(oldFocus, ownerRequireOwner) || !FocusGroupNode_androidKt.containsDescendant(view, oldFocus)) ? false : true;
        boolean z2 = (newFocus == null || Intrinsics.areEqual(newFocus, ownerRequireOwner) || !FocusGroupNode_androidKt.containsDescendant(view, newFocus)) ? false : true;
        if (z && z2) {
            this.focusedChild = newFocus;
            return;
        }
        if (!z2) {
            if (z) {
                this.focusedChild = null;
                if (getFocusTargetOfEmbeddedViewWrapper().getFocusState().isFocused()) {
                    focusOwner.clearFocus-I7lrPNg(false, true, false, FocusDirection.Companion.getExit-dhqQ-8s());
                    return;
                }
                return;
            }
            this.focusedChild = null;
            return;
        }
        this.focusedChild = newFocus;
        FocusTargetNode focusTargetOfEmbeddedViewWrapper = getFocusTargetOfEmbeddedViewWrapper();
        if (focusTargetOfEmbeddedViewWrapper.getFocusState().getHasFocus()) {
            return;
        }
        FocusTransactionManager focusTransactionManager = focusOwner.getFocusTransactionManager();
        try {
            if (FocusTransactionManager.access$getOngoingTransaction$p(focusTransactionManager)) {
                FocusTransactionManager.access$cancelTransaction(focusTransactionManager);
            }
            FocusTransactionManager.access$beginTransaction(focusTransactionManager);
            FocusTransactionsKt.performRequestFocus(focusTargetOfEmbeddedViewWrapper);
        } finally {
            FocusTransactionManager.access$commitTransaction(focusTransactionManager);
        }
    }

    public void onAttach() {
        super.onAttach();
        FocusGroupNode_androidKt.getView(this).addOnAttachStateChangeListener(this);
    }

    public void onDetach() {
        FocusGroupNode_androidKt.getView(this).removeOnAttachStateChangeListener(this);
        this.focusedChild = null;
        super.onDetach();
    }

    @Override
    public void onViewAttachedToWindow(View v) {
        v.getViewTreeObserver().addOnGlobalFocusChangeListener(this);
    }

    @Override
    public void onViewDetachedFromWindow(View v) {
        v.getViewTreeObserver().removeOnGlobalFocusChangeListener(this);
    }
}
