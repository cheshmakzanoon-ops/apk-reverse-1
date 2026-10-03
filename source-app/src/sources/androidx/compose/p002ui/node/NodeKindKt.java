package androidx.compose.p002ui.node;

import androidx.collection.MutableObjectIntMap;
import androidx.collection.ObjectIntMapKt;
import androidx.compose.p002ui.Actual_jvmKt;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.draw.DrawModifier;
import androidx.compose.p002ui.focus.FocusEventModifier;
import androidx.compose.p002ui.focus.FocusEventModifierNode;
import androidx.compose.p002ui.focus.FocusEventModifierNodeKt;
import androidx.compose.p002ui.focus.FocusOrderModifier;
import androidx.compose.p002ui.focus.FocusPropertiesModifierNode;
import androidx.compose.p002ui.focus.FocusPropertiesModifierNodeKt;
import androidx.compose.p002ui.focus.FocusTargetNode;
import androidx.compose.p002ui.focus.FocusTargetNodeKt;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.input.key.KeyInputModifierNode;
import androidx.compose.p002ui.input.key.SoftKeyboardInterceptionModifierNode;
import androidx.compose.p002ui.input.pointer.PointerInputModifier;
import androidx.compose.p002ui.input.rotary.RotaryInputModifierNode;
import androidx.compose.p002ui.internal.InlineClassHelperKt;
import androidx.compose.p002ui.layout.ApproachLayoutModifierNode;
import androidx.compose.p002ui.layout.LayoutModifier;
import androidx.compose.p002ui.layout.OnGloballyPositionedModifier;
import androidx.compose.p002ui.layout.OnPlacedModifier;
import androidx.compose.p002ui.layout.OnRemeasuredModifier;
import androidx.compose.p002ui.layout.ParentDataModifier;
import androidx.compose.p002ui.modifier.ModifierLocalConsumer;
import androidx.compose.p002ui.modifier.ModifierLocalModifierNode;
import androidx.compose.p002ui.modifier.ModifierLocalProvider;
import androidx.compose.p002ui.semantics.SemanticsModifier;
import androidx.compose.runtime.collection.MutableVector;
import kotlin.KotlinNothingValueException;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000>\n\u0000\n\u0002\u0010\b\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000b\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0018\u0002\n\u0002\b\u0002\u001a\u0010\u0010\u0010\u001a\u00020\u00112\u0006\u0010\u0012\u001a\u00020\u0013H\u0000\u001a \u0010\u0014\u001a\u00020\u00112\u0006\u0010\u0012\u001a\u00020\u00132\u0006\u0010\u0015\u001a\u00020\u00012\u0006\u0010\u0016\u001a\u00020\u0001H\u0000\u001a \u0010\u0017\u001a\u00020\u00112\u0006\u0010\u0012\u001a\u00020\u00132\u0006\u0010\u0018\u001a\u00020\u00012\u0006\u0010\u0016\u001a\u00020\u0001H\u0002\u001a\u0010\u0010\u0019\u001a\u00020\u00112\u0006\u0010\u0012\u001a\u00020\u0013H\u0000\u001a\u0010\u0010\u001a\u001a\u00020\u00112\u0006\u0010\u0012\u001a\u00020\u0013H\u0000\u001a\u0010\u0010\u001b\u001a\u00020\u00012\u0006\u0010\u001c\u001a\u00020\u001dH\u0000\u001a\u0010\u0010\u001b\u001a\u00020\u00012\u0006\u0010\u0012\u001a\u00020\u0013H\u0000\u001a\u0010\u0010\u001e\u001a\u00020\u00012\u0006\u0010\u0012\u001a\u00020\u0013H\u0000\u001a#\u0010\u001f\u001a\u00020\f*\u00020\u00012\n\u0010 \u001a\u0006\u0012\u0002\b\u00030\rH\u0080\nø\u0001\u0000¢\u0006\u0004\b!\u0010\"\u001a#\u0010#\u001a\u00020\u0001*\u00020\u00012\n\u0010$\u001a\u0006\u0012\u0002\b\u00030\rH\u0080\fø\u0001\u0000¢\u0006\u0004\b%\u0010&\u001a\f\u0010'\u001a\u00020\u0011*\u00020(H\u0002\u001a\f\u0010)\u001a\u00020\f*\u00020(H\u0002\"\u0014\u0010\u0000\u001a\u00020\u0001X\u0082T¢\u0006\b\n\u0000\u0012\u0004\b\u0002\u0010\u0003\"\u0014\u0010\u0004\u001a\u00020\u0001X\u0082T¢\u0006\b\n\u0000\u0012\u0004\b\u0005\u0010\u0003\"\u0014\u0010\u0006\u001a\u00020\u0001X\u0082T¢\u0006\b\n\u0000\u0012\u0004\b\u0007\u0010\u0003\"\u0014\u0010\b\u001a\b\u0012\u0004\u0012\u00020\n0\tX\u0082\u0004¢\u0006\u0002\n\u0000\"\u001c\u0010\u000b\u001a\u00020\f*\u0006\u0012\u0002\b\u00030\r8@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b\u000e\u0010\u000f\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006*"}, d2 = {"Inserted", "", "getInserted$annotations", "()V", "Removed", "getRemoved$annotations", "Updated", "getUpdated$annotations", "classToKindSetMap", "Landroidx/collection/MutableObjectIntMap;", "", "includeSelfInTraversal", "", "Landroidx/compose/ui/node/NodeKind;", "getIncludeSelfInTraversal-H91voCI", "(I)Z", "autoInvalidateInsertedNode", "", "node", "Landroidx/compose/ui/Modifier$Node;", "autoInvalidateNodeIncludingDelegates", "remainingSet", "phase", "autoInvalidateNodeSelf", "selfKindSet", "autoInvalidateRemovedNode", "autoInvalidateUpdatedNode", "calculateNodeKindSetFrom", "element", "Landroidx/compose/ui/Modifier$Element;", "calculateNodeKindSetFromIncludingDelegates", "contains", "value", "contains-64DMado", "(II)Z", "or", "other", "or-64DMado", "(II)I", "scheduleInvalidationOfAssociatedFocusTargets", "Landroidx/compose/ui/focus/FocusPropertiesModifierNode;", "specifiesCanFocusProperty", "ui_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class NodeKindKt {
    private static final int Inserted = 1;
    private static final int Removed = 2;
    private static final int Updated = 0;
    private static final MutableObjectIntMap<Object> classToKindSetMap = ObjectIntMapKt.mutableObjectIntMapOf();

    public static final boolean m6375contains64DMado(int i, int i2) {
        return (i & i2) != 0;
    }

    private static void getInserted$annotations() {
    }

    private static void getRemoved$annotations() {
    }

    private static void getUpdated$annotations() {
    }

    public static final int m6377or64DMado(int i, int i2) {
        return i | i2;
    }

    public static final int calculateNodeKindSetFrom(Modifier.Node node) {
        if (node.getKindSet() != 0) {
            return node.getKindSet();
        }
        MutableObjectIntMap<Object> mutableObjectIntMap = classToKindSetMap;
        Object objClassKeyForObject = Actual_jvmKt.classKeyForObject(node);
        int iFindKeyIndex = mutableObjectIntMap.findKeyIndex(objClassKeyForObject);
        if (iFindKeyIndex >= 0) {
            return mutableObjectIntMap.values[iFindKeyIndex];
        }
        int iM6367constructorimpl = NodeKind.m6367constructorimpl(1);
        if (node instanceof LayoutModifierNode) {
            iM6367constructorimpl |= NodeKind.m6367constructorimpl(2);
        }
        if (node instanceof DrawModifierNode) {
            iM6367constructorimpl |= NodeKind.m6367constructorimpl(4);
        }
        if (node instanceof SemanticsModifierNode) {
            iM6367constructorimpl |= NodeKind.m6367constructorimpl(8);
        }
        if (node instanceof PointerInputModifierNode) {
            iM6367constructorimpl |= NodeKind.m6367constructorimpl(16);
        }
        if (node instanceof ModifierLocalModifierNode) {
            iM6367constructorimpl |= NodeKind.m6367constructorimpl(32);
        }
        if (node instanceof ParentDataModifierNode) {
            iM6367constructorimpl |= NodeKind.m6367constructorimpl(64);
        }
        if (node instanceof LayoutAwareModifierNode) {
            iM6367constructorimpl |= NodeKind.m6367constructorimpl(Fields.SpotShadowColor);
        }
        if (node instanceof GlobalPositionAwareModifierNode) {
            iM6367constructorimpl |= NodeKind.m6367constructorimpl(Fields.RotationX);
        }
        if (node instanceof ApproachLayoutModifierNode) {
            iM6367constructorimpl |= NodeKind.m6367constructorimpl(Fields.RotationY);
        }
        if (node instanceof FocusTargetNode) {
            iM6367constructorimpl |= NodeKind.m6367constructorimpl(Fields.RotationZ);
        }
        if (node instanceof FocusPropertiesModifierNode) {
            iM6367constructorimpl |= NodeKind.m6367constructorimpl(Fields.CameraDistance);
        }
        if (node instanceof FocusEventModifierNode) {
            iM6367constructorimpl |= NodeKind.m6367constructorimpl(Fields.TransformOrigin);
        }
        if (node instanceof KeyInputModifierNode) {
            iM6367constructorimpl |= NodeKind.m6367constructorimpl(Fields.Shape);
        }
        if (node instanceof RotaryInputModifierNode) {
            iM6367constructorimpl |= NodeKind.m6367constructorimpl(Fields.Clip);
        }
        if (node instanceof CompositionLocalConsumerModifierNode) {
            iM6367constructorimpl |= NodeKind.m6367constructorimpl(Fields.CompositingStrategy);
        }
        if (node instanceof SoftKeyboardInterceptionModifierNode) {
            iM6367constructorimpl |= NodeKind.m6367constructorimpl(Fields.RenderEffect);
        }
        int iM6367constructorimpl2 = node instanceof TraversableNode ? NodeKind.m6367constructorimpl(262144) | iM6367constructorimpl : iM6367constructorimpl;
        mutableObjectIntMap.set(objClassKeyForObject, iM6367constructorimpl2);
        return iM6367constructorimpl2;
    }

    public static final void autoInvalidateRemovedNode(Modifier.Node node) {
        if (!node.getIsAttached()) {
            InlineClassHelperKt.throwIllegalStateException("autoInvalidateRemovedNode called on unattached node");
        }
        autoInvalidateNodeIncludingDelegates(node, -1, 2);
    }

    public static final void autoInvalidateInsertedNode(Modifier.Node node) {
        if (!node.getIsAttached()) {
            InlineClassHelperKt.throwIllegalStateException("autoInvalidateInsertedNode called on unattached node");
        }
        autoInvalidateNodeIncludingDelegates(node, -1, 1);
    }

    public static final void autoInvalidateUpdatedNode(Modifier.Node node) {
        if (!node.getIsAttached()) {
            InlineClassHelperKt.throwIllegalStateException("autoInvalidateUpdatedNode called on unattached node");
        }
        autoInvalidateNodeIncludingDelegates(node, -1, 0);
    }

    public static final void autoInvalidateNodeIncludingDelegates(Modifier.Node node, int i, int i2) throws KotlinNothingValueException {
        if (node instanceof DelegatingNode) {
            DelegatingNode delegatingNode = (DelegatingNode) node;
            autoInvalidateNodeSelf(node, delegatingNode.getSelfKindSet() & i, i2);
            int i3 = (~delegatingNode.getSelfKindSet()) & i;
            for (Modifier.Node delegate$ui_release = delegatingNode.getDelegate(); delegate$ui_release != null; delegate$ui_release = delegate$ui_release.getChild()) {
                autoInvalidateNodeIncludingDelegates(delegate$ui_release, i3, i2);
            }
            return;
        }
        autoInvalidateNodeSelf(node, i & node.getKindSet(), i2);
    }

    private static final void autoInvalidateNodeSelf(Modifier.Node node, int i, int i2) throws KotlinNothingValueException {
        if (i2 != 0 || node.getShouldAutoInvalidate()) {
            if ((NodeKind.m6367constructorimpl(2) & i) != 0 && (node instanceof LayoutModifierNode)) {
                LayoutModifierNodeKt.invalidateMeasurement((LayoutModifierNode) node);
                if (i2 == 2) {
                    DelegatableNodeKt.m6200requireCoordinator64DMado(node, NodeKind.m6367constructorimpl(2)).onRelease();
                }
            }
            if ((NodeKind.m6367constructorimpl(Fields.SpotShadowColor) & i) != 0 && (node instanceof LayoutAwareModifierNode) && i2 != 2) {
                DelegatableNodeKt.requireLayoutNode(node).invalidateMeasurements$ui_release();
            }
            if ((NodeKind.m6367constructorimpl(Fields.RotationX) & i) != 0 && (node instanceof GlobalPositionAwareModifierNode) && i2 != 2) {
                DelegatableNodeKt.requireLayoutNode(node).invalidateOnPositioned$ui_release();
            }
            if ((NodeKind.m6367constructorimpl(4) & i) != 0 && (node instanceof DrawModifierNode)) {
                DrawModifierNodeKt.invalidateDraw((DrawModifierNode) node);
            }
            if ((NodeKind.m6367constructorimpl(8) & i) != 0 && (node instanceof SemanticsModifierNode)) {
                SemanticsModifierNodeKt.invalidateSemantics((SemanticsModifierNode) node);
            }
            if ((NodeKind.m6367constructorimpl(64) & i) != 0 && (node instanceof ParentDataModifierNode)) {
                ParentDataModifierNodeKt.invalidateParentData((ParentDataModifierNode) node);
            }
            if ((NodeKind.m6367constructorimpl(Fields.RotationZ) & i) != 0 && (node instanceof FocusTargetNode) && i2 != 2) {
                FocusTargetNodeKt.invalidateFocusTarget((FocusTargetNode) node);
            }
            if ((NodeKind.m6367constructorimpl(Fields.CameraDistance) & i) != 0 && (node instanceof FocusPropertiesModifierNode)) {
                FocusPropertiesModifierNode focusPropertiesModifierNode = (FocusPropertiesModifierNode) node;
                if (specifiesCanFocusProperty(focusPropertiesModifierNode)) {
                    if (i2 == 2) {
                        scheduleInvalidationOfAssociatedFocusTargets(focusPropertiesModifierNode);
                    } else {
                        FocusPropertiesModifierNodeKt.invalidateFocusProperties(focusPropertiesModifierNode);
                    }
                }
            }
            if ((i & NodeKind.m6367constructorimpl(Fields.TransformOrigin)) == 0 || !(node instanceof FocusEventModifierNode)) {
                return;
            }
            FocusEventModifierNodeKt.invalidateFocusEvent((FocusEventModifierNode) node);
        }
    }

    private static final void scheduleInvalidationOfAssociatedFocusTargets(FocusPropertiesModifierNode focusPropertiesModifierNode) {
        FocusPropertiesModifierNode focusPropertiesModifierNode2 = focusPropertiesModifierNode;
        int iM6367constructorimpl = NodeKind.m6367constructorimpl(Fields.RotationZ);
        if (!focusPropertiesModifierNode2.getNode().getIsAttached()) {
            throw new IllegalStateException("visitChildren called on an unattached node".toString());
        }
        MutableVector mutableVector = new MutableVector(new Modifier.Node[16], 0);
        Modifier.Node child = focusPropertiesModifierNode2.getNode().getChild();
        if (child == null) {
            DelegatableNodeKt.addLayoutNodeChildren(mutableVector, focusPropertiesModifierNode2.getNode());
        } else {
            mutableVector.add(child);
        }
        while (mutableVector.isNotEmpty()) {
            Modifier.Node nodePop = (Modifier.Node) mutableVector.removeAt(mutableVector.getSize() - 1);
            if ((nodePop.getAggregateChildKindSet() & iM6367constructorimpl) == 0) {
                DelegatableNodeKt.addLayoutNodeChildren(mutableVector, nodePop);
            } else {
                while (nodePop != null) {
                    if ((nodePop.getKindSet() & iM6367constructorimpl) != 0) {
                        MutableVector mutableVector2 = null;
                        while (nodePop != null) {
                            if (nodePop instanceof FocusTargetNode) {
                                FocusTargetNodeKt.invalidateFocusTarget((FocusTargetNode) nodePop);
                            } else if ((nodePop.getKindSet() & iM6367constructorimpl) != 0 && (nodePop instanceof DelegatingNode)) {
                                int i = 0;
                                for (Modifier.Node delegate$ui_release = ((DelegatingNode) nodePop).getDelegate(); delegate$ui_release != null; delegate$ui_release = delegate$ui_release.getChild()) {
                                    if ((delegate$ui_release.getKindSet() & iM6367constructorimpl) != 0) {
                                        i++;
                                        if (i == 1) {
                                            nodePop = delegate$ui_release;
                                        } else {
                                            if (mutableVector2 == null) {
                                                mutableVector2 = new MutableVector(new Modifier.Node[16], 0);
                                            }
                                            if (nodePop != null) {
                                                if (mutableVector2 != null) {
                                                    mutableVector2.add(nodePop);
                                                }
                                                nodePop = null;
                                            }
                                            if (mutableVector2 != null) {
                                                mutableVector2.add(delegate$ui_release);
                                            }
                                        }
                                    }
                                }
                                if (i == 1) {
                                }
                            }
                            nodePop = DelegatableNodeKt.pop(mutableVector2);
                        }
                        break;
                    }
                    nodePop = nodePop.getChild();
                }
            }
        }
    }

    private static final boolean specifiesCanFocusProperty(FocusPropertiesModifierNode focusPropertiesModifierNode) {
        CanFocusChecker.INSTANCE.reset();
        focusPropertiesModifierNode.applyFocusProperties(CanFocusChecker.INSTANCE);
        return CanFocusChecker.INSTANCE.isCanFocusSet();
    }

    public static final int calculateNodeKindSetFromIncludingDelegates(Modifier.Node node) {
        if (node instanceof DelegatingNode) {
            DelegatingNode delegatingNode = (DelegatingNode) node;
            int selfKindSet$ui_release = delegatingNode.getSelfKindSet();
            for (Modifier.Node delegate$ui_release = delegatingNode.getDelegate(); delegate$ui_release != null; delegate$ui_release = delegate$ui_release.getChild()) {
                selfKindSet$ui_release |= calculateNodeKindSetFromIncludingDelegates(delegate$ui_release);
            }
            return selfKindSet$ui_release;
        }
        return calculateNodeKindSetFrom(node);
    }

    public static final boolean m6376getIncludeSelfInTraversalH91voCI(int i) {
        return (i & NodeKind.m6367constructorimpl(Fields.SpotShadowColor)) != 0;
    }

    public static final int calculateNodeKindSetFrom(Modifier.Element element) {
        int iM6367constructorimpl = NodeKind.m6367constructorimpl(1);
        if (element instanceof LayoutModifier) {
            iM6367constructorimpl |= NodeKind.m6367constructorimpl(2);
        }
        if (element instanceof DrawModifier) {
            iM6367constructorimpl |= NodeKind.m6367constructorimpl(4);
        }
        if (element instanceof SemanticsModifier) {
            iM6367constructorimpl |= NodeKind.m6367constructorimpl(8);
        }
        if (element instanceof PointerInputModifier) {
            iM6367constructorimpl |= NodeKind.m6367constructorimpl(16);
        }
        if ((element instanceof ModifierLocalConsumer) || (element instanceof ModifierLocalProvider)) {
            iM6367constructorimpl |= NodeKind.m6367constructorimpl(32);
        }
        if (element instanceof FocusEventModifier) {
            iM6367constructorimpl |= NodeKind.m6367constructorimpl(Fields.TransformOrigin);
        }
        if (element instanceof FocusOrderModifier) {
            iM6367constructorimpl |= NodeKind.m6367constructorimpl(Fields.CameraDistance);
        }
        if (element instanceof OnGloballyPositionedModifier) {
            iM6367constructorimpl |= NodeKind.m6367constructorimpl(Fields.RotationX);
        }
        if (element instanceof ParentDataModifier) {
            iM6367constructorimpl |= NodeKind.m6367constructorimpl(64);
        }
        return ((element instanceof OnPlacedModifier) || (element instanceof OnRemeasuredModifier)) ? iM6367constructorimpl | NodeKind.m6367constructorimpl(Fields.SpotShadowColor) : iM6367constructorimpl;
    }
}
