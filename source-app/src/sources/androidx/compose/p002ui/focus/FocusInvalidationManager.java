package androidx.compose.p002ui.focus;

import androidx.collection.MutableScatterSet;
import androidx.collection.ScatterSetKt;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.internal.InlineClassHelperKt;
import androidx.compose.p002ui.node.DelegatableNodeKt;
import androidx.compose.p002ui.node.DelegatingNode;
import androidx.compose.p002ui.node.NodeKind;
import androidx.compose.runtime.collection.MutableVector;
import kotlin.KotlinNothingValueException;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.FunctionReferenceImpl;

@Metadata(d1 = {"\u0000:\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0006\b\u0000\u0018\u00002\u00020\u0001B-\u0012\u0018\u0010\u0002\u001a\u0014\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00050\u0004\u0012\u0004\u0012\u00020\u00050\u0003\u0012\f\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004¢\u0006\u0002\u0010\u0007J\u0006\u0010\u0010\u001a\u00020\u0011J\b\u0010\u0012\u001a\u00020\u0005H\u0002J\u000e\u0010\u0013\u001a\u00020\u00052\u0006\u0010\u0014\u001a\u00020\nJ\u000e\u0010\u0013\u001a\u00020\u00052\u0006\u0010\u0014\u001a\u00020\fJ\u000e\u0010\u0013\u001a\u00020\u00052\u0006\u0010\u0014\u001a\u00020\u000eJ%\u0010\u0013\u001a\u00020\u0005\"\u0004\b\u0000\u0010\u0015*\b\u0012\u0004\u0012\u0002H\u00150\t2\u0006\u0010\u0014\u001a\u0002H\u0015H\u0002¢\u0006\u0002\u0010\u0016R\u0014\u0010\b\u001a\b\u0012\u0004\u0012\u00020\n0\tX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\f0\tX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\r\u001a\b\u0012\u0004\u0012\u00020\u000e0\tX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u000f\u001a\b\u0012\u0004\u0012\u00020\u000e0\tX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004X\u0082\u0004¢\u0006\u0002\n\u0000R \u0010\u0002\u001a\u0014\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00050\u0004\u0012\u0004\u0012\u00020\u00050\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0017"}, d2 = {"Landroidx/compose/ui/focus/FocusInvalidationManager;", "", "onRequestApplyChangesListener", "Lkotlin/Function1;", "Lkotlin/Function0;", "", "invalidateOwnerFocusState", "(Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function0;)V", "focusEventNodes", "Landroidx/collection/MutableScatterSet;", "Landroidx/compose/ui/focus/FocusEventModifierNode;", "focusPropertiesNodes", "Landroidx/compose/ui/focus/FocusPropertiesModifierNode;", "focusTargetNodes", "Landroidx/compose/ui/focus/FocusTargetNode;", "focusTargetsWithInvalidatedFocusEvents", "hasPendingInvalidation", "", "invalidateNodes", "scheduleInvalidation", "node", "T", "(Landroidx/collection/MutableScatterSet;Ljava/lang/Object;)V", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class FocusInvalidationManager {
    public static final int $stable = 8;
    private final Function0<Unit> invalidateOwnerFocusState;
    private final Function1<Function0<Unit>, Unit> onRequestApplyChangesListener;
    private final MutableScatterSet<FocusTargetNode> focusTargetNodes = ScatterSetKt.mutableScatterSetOf();
    private final MutableScatterSet<FocusEventModifierNode> focusEventNodes = ScatterSetKt.mutableScatterSetOf();
    private final MutableScatterSet<FocusPropertiesModifierNode> focusPropertiesNodes = ScatterSetKt.mutableScatterSetOf();
    private final MutableScatterSet<FocusTargetNode> focusTargetsWithInvalidatedFocusEvents = ScatterSetKt.mutableScatterSetOf();

    public FocusInvalidationManager(Function1<? super Function0<Unit>, Unit> function1, Function0<Unit> function0) {
        this.onRequestApplyChangesListener = function1;
        this.invalidateOwnerFocusState = function0;
    }

    public final void scheduleInvalidation(FocusTargetNode node) {
        scheduleInvalidation(this.focusTargetNodes, node);
    }

    public final void scheduleInvalidation(FocusEventModifierNode node) {
        scheduleInvalidation(this.focusEventNodes, node);
    }

    public final void scheduleInvalidation(FocusPropertiesModifierNode node) {
        scheduleInvalidation(this.focusPropertiesNodes, node);
    }

    public final boolean hasPendingInvalidation() {
        return this.focusTargetNodes.isNotEmpty() || this.focusPropertiesNodes.isNotEmpty() || this.focusEventNodes.isNotEmpty();
    }

    private final <T> void scheduleInvalidation(MutableScatterSet<T> mutableScatterSet, T t) {
        if (mutableScatterSet.add(t) && this.focusTargetNodes.get_size() + this.focusEventNodes.get_size() + this.focusPropertiesNodes.get_size() == 1) {
            this.onRequestApplyChangesListener.invoke(new C16071(this));
        }
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    class C16071 extends FunctionReferenceImpl implements Function0<Unit> {
        C16071(Object obj) {
            super(0, obj, FocusInvalidationManager.class, "invalidateNodes", "invalidateNodes()V", 0);
        }

        public Object invoke() throws KotlinNothingValueException {
            m4266invoke();
            return Unit.INSTANCE;
        }

        public final void m4266invoke() throws KotlinNothingValueException {
            ((FocusInvalidationManager) this.receiver).invalidateNodes();
        }
    }

    public final void invalidateNodes() throws KotlinNothingValueException {
        int i;
        long[] jArr;
        Object[] objArr;
        long[] jArr2;
        Object[] objArr2;
        FocusStateImpl focusState;
        FocusStateImpl focusState2;
        int i2;
        MutableVector mutableVector;
        long[] jArr3;
        Object[] objArr3;
        boolean z;
        Object[] objArr4;
        long[] jArr4;
        long[] jArr5;
        int i3;
        long[] jArr6;
        MutableScatterSet<FocusPropertiesModifierNode> mutableScatterSet = this.focusPropertiesNodes;
        Object[] objArr5 = mutableScatterSet.elements;
        long[] jArr7 = mutableScatterSet.metadata;
        int length = jArr7.length - 2;
        char c = 7;
        long j = -9187201950435737472L;
        int i4 = 8;
        int i5 = 1;
        if (length >= 0) {
            int i6 = 0;
            while (true) {
                long j2 = jArr7[i6];
                if ((((~j2) << c) & j2 & j) != j) {
                    int i7 = 8 - ((~(i6 - length)) >>> 31);
                    int i8 = 0;
                    while (i8 < i7) {
                        if ((j2 & 255) < 128) {
                            FocusPropertiesModifierNode focusPropertiesModifierNode = (FocusPropertiesModifierNode) objArr5[(i6 << 3) + i8];
                            if (focusPropertiesModifierNode.getNode().getIsAttached()) {
                                FocusPropertiesModifierNode focusPropertiesModifierNode2 = focusPropertiesModifierNode;
                                int iM6367constructorimpl = NodeKind.m6367constructorimpl(Fields.RotationZ);
                                Modifier.Node node = focusPropertiesModifierNode2.getNode();
                                MutableVector mutableVector2 = null;
                                while (node != null) {
                                    if (node instanceof FocusTargetNode) {
                                        this.focusTargetNodes.add((FocusTargetNode) node);
                                    } else {
                                        if ((node.getKindSet() & iM6367constructorimpl) != 0 && (node instanceof DelegatingNode)) {
                                            Modifier.Node delegate = ((DelegatingNode) node).getDelegate();
                                            int i9 = 0;
                                            while (delegate != null) {
                                                if ((delegate.getKindSet() & iM6367constructorimpl) != 0) {
                                                    i9++;
                                                    if (i9 == i5) {
                                                        jArr7 = jArr7;
                                                        node = delegate;
                                                    } else {
                                                        if (mutableVector2 == null) {
                                                            mutableVector2 = new MutableVector(new Modifier.Node[16], 0);
                                                        }
                                                        if (node != null) {
                                                            if (mutableVector2 != null) {
                                                                Boolean.valueOf(mutableVector2.add(node));
                                                            }
                                                            node = null;
                                                        }
                                                        if (mutableVector2 != null) {
                                                            Boolean.valueOf(mutableVector2.add(delegate));
                                                        }
                                                    }
                                                } else {
                                                    jArr7 = jArr7;
                                                }
                                                delegate = delegate.getChild();
                                                jArr7 = jArr7;
                                                i5 = 1;
                                            }
                                            jArr6 = jArr7;
                                            int i10 = i5;
                                            if (i9 == i10) {
                                                i5 = i10;
                                                jArr7 = jArr6;
                                            }
                                        }
                                        node = DelegatableNodeKt.pop(mutableVector2);
                                        jArr7 = jArr6;
                                        i5 = 1;
                                    }
                                    jArr6 = jArr7;
                                    node = DelegatableNodeKt.pop(mutableVector2);
                                    jArr7 = jArr6;
                                    i5 = 1;
                                }
                                jArr5 = jArr7;
                                if (!focusPropertiesModifierNode2.getNode().getIsAttached()) {
                                    throw new IllegalStateException("visitChildren called on an unattached node".toString());
                                }
                                MutableVector mutableVector3 = new MutableVector(new Modifier.Node[16], 0);
                                Modifier.Node child = focusPropertiesModifierNode2.getNode().getChild();
                                if (child == null) {
                                    DelegatableNodeKt.addLayoutNodeChildren(mutableVector3, focusPropertiesModifierNode2.getNode());
                                } else {
                                    mutableVector3.add(child);
                                }
                                while (mutableVector3.isNotEmpty()) {
                                    Modifier.Node nodePop = (Modifier.Node) mutableVector3.removeAt(mutableVector3.getSize() - 1);
                                    if ((nodePop.getAggregateChildKindSet() & iM6367constructorimpl) == 0) {
                                        DelegatableNodeKt.addLayoutNodeChildren(mutableVector3, nodePop);
                                    } else {
                                        while (nodePop != null) {
                                            if ((nodePop.getKindSet() & iM6367constructorimpl) != 0) {
                                                MutableVector mutableVector4 = null;
                                                while (nodePop != null) {
                                                    if (nodePop instanceof FocusTargetNode) {
                                                        this.focusTargetNodes.add((FocusTargetNode) nodePop);
                                                    } else if ((nodePop.getKindSet() & iM6367constructorimpl) != 0 && (nodePop instanceof DelegatingNode)) {
                                                        int i11 = 0;
                                                        for (Modifier.Node delegate2 = ((DelegatingNode) nodePop).getDelegate(); delegate2 != null; delegate2 = delegate2.getChild()) {
                                                            if ((delegate2.getKindSet() & iM6367constructorimpl) != 0) {
                                                                i11++;
                                                                if (i11 == 1) {
                                                                    nodePop = delegate2;
                                                                } else {
                                                                    if (mutableVector4 == null) {
                                                                        mutableVector4 = new MutableVector(new Modifier.Node[16], 0);
                                                                    }
                                                                    if (nodePop != null) {
                                                                        if (mutableVector4 != null) {
                                                                            Boolean.valueOf(mutableVector4.add(nodePop));
                                                                        }
                                                                        nodePop = null;
                                                                    }
                                                                    if (mutableVector4 != null) {
                                                                        Boolean.valueOf(mutableVector4.add(delegate2));
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        if (i11 == 1) {
                                                        }
                                                    }
                                                    nodePop = DelegatableNodeKt.pop(mutableVector4);
                                                }
                                                break;
                                            }
                                            nodePop = nodePop.getChild();
                                        }
                                    }
                                }
                            } else {
                                jArr5 = jArr7;
                            }
                            i3 = 8;
                        } else {
                            jArr5 = jArr7;
                            i3 = i4;
                        }
                        j2 >>= i3;
                        i8++;
                        i4 = i3;
                        jArr7 = jArr5;
                        i5 = 1;
                    }
                    jArr4 = jArr7;
                    if (i7 != i4) {
                        break;
                    }
                } else {
                    jArr4 = jArr7;
                }
                if (i6 == length) {
                    break;
                }
                i6++;
                jArr7 = jArr4;
                c = 7;
                j = -9187201950435737472L;
                i5 = 1;
                i4 = 8;
            }
        }
        this.focusPropertiesNodes.clear();
        MutableScatterSet<FocusEventModifierNode> mutableScatterSet2 = this.focusEventNodes;
        Object[] objArr6 = mutableScatterSet2.elements;
        long[] jArr8 = mutableScatterSet2.metadata;
        int length2 = jArr8.length - 2;
        if (length2 >= 0) {
            int i12 = 0;
            while (true) {
                long j3 = jArr8[i12];
                if ((((~j3) << 7) & j3 & (-9187201950435737472L)) != -9187201950435737472L) {
                    int i13 = 8 - ((~(i12 - length2)) >>> 31);
                    int i14 = 0;
                    while (i14 < i13) {
                        if ((j3 & 255) < 128) {
                            FocusEventModifierNode focusEventModifierNode = (FocusEventModifierNode) objArr6[(i12 << 3) + i14];
                            if (focusEventModifierNode.getNode().getIsAttached()) {
                                FocusEventModifierNode focusEventModifierNode2 = focusEventModifierNode;
                                int iM6367constructorimpl2 = NodeKind.m6367constructorimpl(Fields.RotationZ);
                                Modifier.Node node2 = focusEventModifierNode2.getNode();
                                boolean z2 = false;
                                boolean z3 = true;
                                FocusTargetNode focusTargetNode = null;
                                MutableVector mutableVector5 = null;
                                while (node2 != null) {
                                    if (node2 instanceof FocusTargetNode) {
                                        FocusTargetNode focusTargetNode2 = (FocusTargetNode) node2;
                                        if (focusTargetNode != null) {
                                            z2 = true;
                                        }
                                        if (this.focusTargetNodes.contains(focusTargetNode2)) {
                                            this.focusTargetsWithInvalidatedFocusEvents.add(focusTargetNode2);
                                            z3 = false;
                                        }
                                        jArr3 = jArr8;
                                        objArr3 = objArr6;
                                        focusTargetNode = focusTargetNode2;
                                    } else {
                                        if ((node2.getKindSet() & iM6367constructorimpl2) == 0 || !(node2 instanceof DelegatingNode)) {
                                            jArr3 = jArr8;
                                            objArr3 = objArr6;
                                            z = z2;
                                        } else {
                                            Modifier.Node delegate3 = ((DelegatingNode) node2).getDelegate();
                                            jArr3 = jArr8;
                                            int i15 = 0;
                                            while (delegate3 != null) {
                                                if ((delegate3.getKindSet() & iM6367constructorimpl2) != 0) {
                                                    i15++;
                                                    objArr4 = objArr6;
                                                    if (i15 == 1) {
                                                        node2 = delegate3;
                                                    } else {
                                                        MutableVector mutableVector6 = mutableVector5 == null ? new MutableVector(new Modifier.Node[16], 0) : mutableVector5;
                                                        if (node2 != null) {
                                                            if (mutableVector6 != null) {
                                                                Boolean.valueOf(mutableVector6.add(node2));
                                                            }
                                                            node2 = null;
                                                        }
                                                        if (mutableVector6 != null) {
                                                            Boolean.valueOf(mutableVector6.add(delegate3));
                                                        }
                                                        mutableVector5 = mutableVector6;
                                                        i15 = i15;
                                                    }
                                                    delegate3 = delegate3.getChild();
                                                    objArr6 = objArr4;
                                                    z2 = z2;
                                                } else {
                                                    objArr4 = objArr6;
                                                }
                                                z2 = z2;
                                                delegate3 = delegate3.getChild();
                                                objArr6 = objArr4;
                                                z2 = z2;
                                            }
                                            objArr3 = objArr6;
                                            z = z2;
                                            if (i15 == 1) {
                                                jArr8 = jArr3;
                                                objArr6 = objArr3;
                                                z2 = z;
                                            }
                                        }
                                        z2 = z;
                                    }
                                    node2 = DelegatableNodeKt.pop(mutableVector5);
                                    jArr8 = jArr3;
                                    objArr6 = objArr3;
                                }
                                jArr2 = jArr8;
                                objArr2 = objArr6;
                                boolean z4 = z2;
                                if (!focusEventModifierNode2.getNode().getIsAttached()) {
                                    throw new IllegalStateException("visitChildren called on an unattached node".toString());
                                }
                                MutableVector mutableVector7 = new MutableVector(new Modifier.Node[16], 0);
                                Modifier.Node child2 = focusEventModifierNode2.getNode().getChild();
                                if (child2 == null) {
                                    DelegatableNodeKt.addLayoutNodeChildren(mutableVector7, focusEventModifierNode2.getNode());
                                } else {
                                    mutableVector7.add(child2);
                                }
                                boolean z5 = z4;
                                while (mutableVector7.isNotEmpty()) {
                                    Modifier.Node nodePop2 = (Modifier.Node) mutableVector7.removeAt(mutableVector7.getSize() - 1);
                                    if ((nodePop2.getAggregateChildKindSet() & iM6367constructorimpl2) == 0) {
                                        DelegatableNodeKt.addLayoutNodeChildren(mutableVector7, nodePop2);
                                    } else {
                                        while (true) {
                                            if (nodePop2 != null) {
                                                if ((nodePop2.getKindSet() & iM6367constructorimpl2) != 0) {
                                                    MutableVector mutableVector8 = null;
                                                    while (nodePop2 != null) {
                                                        if (nodePop2 instanceof FocusTargetNode) {
                                                            FocusTargetNode focusTargetNode3 = (FocusTargetNode) nodePop2;
                                                            if (focusTargetNode != null) {
                                                                z5 = true;
                                                            }
                                                            if (this.focusTargetNodes.contains(focusTargetNode3)) {
                                                                this.focusTargetsWithInvalidatedFocusEvents.add(focusTargetNode3);
                                                                z3 = false;
                                                            }
                                                            focusTargetNode = focusTargetNode3;
                                                        } else {
                                                            if ((nodePop2.getKindSet() & iM6367constructorimpl2) != 0 && (nodePop2 instanceof DelegatingNode)) {
                                                                Modifier.Node delegate4 = ((DelegatingNode) nodePop2).getDelegate();
                                                                int i16 = 0;
                                                                while (delegate4 != null) {
                                                                    if ((delegate4.getKindSet() & iM6367constructorimpl2) != 0) {
                                                                        i16++;
                                                                        mutableVector = mutableVector7;
                                                                        if (i16 == 1) {
                                                                            nodePop2 = delegate4;
                                                                        } else {
                                                                            if (mutableVector8 == null) {
                                                                                mutableVector8 = new MutableVector(new Modifier.Node[16], 0);
                                                                            }
                                                                            if (nodePop2 != null) {
                                                                                if (mutableVector8 != null) {
                                                                                    Boolean.valueOf(mutableVector8.add(nodePop2));
                                                                                }
                                                                                nodePop2 = null;
                                                                            }
                                                                            if (mutableVector8 != null) {
                                                                                Boolean.valueOf(mutableVector8.add(delegate4));
                                                                            }
                                                                        }
                                                                        delegate4 = delegate4.getChild();
                                                                        iM6367constructorimpl2 = iM6367constructorimpl2;
                                                                        mutableVector7 = mutableVector;
                                                                    } else {
                                                                        mutableVector = mutableVector7;
                                                                    }
                                                                    iM6367constructorimpl2 = iM6367constructorimpl2;
                                                                    delegate4 = delegate4.getChild();
                                                                    iM6367constructorimpl2 = iM6367constructorimpl2;
                                                                    mutableVector7 = mutableVector;
                                                                }
                                                                mutableVector7 = mutableVector7;
                                                                i2 = iM6367constructorimpl2;
                                                                if (i16 != 1) {
                                                                    nodePop2 = DelegatableNodeKt.pop(mutableVector8);
                                                                }
                                                            }
                                                            iM6367constructorimpl2 = i2;
                                                            mutableVector7 = mutableVector7;
                                                        }
                                                        i2 = iM6367constructorimpl2;
                                                        nodePop2 = DelegatableNodeKt.pop(mutableVector8);
                                                        iM6367constructorimpl2 = i2;
                                                        mutableVector7 = mutableVector7;
                                                    }
                                                } else {
                                                    nodePop2 = nodePop2.getChild();
                                                    mutableVector7 = mutableVector7;
                                                }
                                            }
                                        }
                                    }
                                    iM6367constructorimpl2 = iM6367constructorimpl2;
                                    mutableVector7 = mutableVector7;
                                }
                                if (z3) {
                                    if (z5) {
                                        focusState2 = FocusEventModifierNodeKt.getFocusState(focusEventModifierNode);
                                    } else {
                                        if (focusTargetNode == null || (focusState = focusTargetNode.getFocusState()) == null) {
                                            focusState = FocusStateImpl.Inactive;
                                        }
                                        focusState2 = focusState;
                                    }
                                    focusEventModifierNode.onFocusEvent(focusState2);
                                }
                            } else {
                                focusEventModifierNode.onFocusEvent(FocusStateImpl.Inactive);
                                jArr2 = jArr8;
                                objArr2 = objArr6;
                            }
                        } else {
                            jArr2 = jArr8;
                            objArr2 = objArr6;
                        }
                        j3 >>= 8;
                        i14++;
                        jArr8 = jArr2;
                        objArr6 = objArr2;
                    }
                    jArr = jArr8;
                    objArr = objArr6;
                    i = 0;
                    if (i13 != 8) {
                        break;
                    }
                } else {
                    jArr = jArr8;
                    objArr = objArr6;
                    i = 0;
                }
                if (i12 == length2) {
                    break;
                }
                i12++;
                jArr8 = jArr;
                objArr6 = objArr;
            }
        } else {
            i = 0;
        }
        this.focusEventNodes.clear();
        MutableScatterSet<FocusTargetNode> mutableScatterSet3 = this.focusTargetNodes;
        Object[] objArr7 = mutableScatterSet3.elements;
        long[] jArr9 = mutableScatterSet3.metadata;
        int length3 = jArr9.length - 2;
        if (length3 >= 0) {
            int i17 = i;
            while (true) {
                long j4 = jArr9[i17];
                if ((((~j4) << 7) & j4 & (-9187201950435737472L)) != -9187201950435737472L) {
                    int i18 = 8 - ((~(i17 - length3)) >>> 31);
                    for (int i19 = i; i19 < i18; i19++) {
                        if ((j4 & 255) < 128) {
                            FocusTargetNode focusTargetNode4 = (FocusTargetNode) objArr7[(i17 << 3) + i19];
                            if (focusTargetNode4.getIsAttached()) {
                                FocusStateImpl focusState3 = focusTargetNode4.getFocusState();
                                focusTargetNode4.invalidateFocus$ui_release();
                                if (focusState3 != focusTargetNode4.getFocusState() || this.focusTargetsWithInvalidatedFocusEvents.contains(focusTargetNode4)) {
                                    FocusEventModifierNodeKt.refreshFocusEventNodes(focusTargetNode4);
                                }
                            }
                        }
                        j4 >>= 8;
                    }
                    if (i18 != 8) {
                        break;
                    }
                }
                if (i17 == length3) {
                    break;
                }
                i17++;
                i = 0;
            }
        }
        this.focusTargetNodes.clear();
        this.focusTargetsWithInvalidatedFocusEvents.clear();
        this.invalidateOwnerFocusState.invoke();
        if (!this.focusPropertiesNodes.isEmpty()) {
            InlineClassHelperKt.throwIllegalStateException("Unprocessed FocusProperties nodes");
        }
        if (!this.focusEventNodes.isEmpty()) {
            InlineClassHelperKt.throwIllegalStateException("Unprocessed FocusEvent nodes");
        }
        if (this.focusTargetNodes.isEmpty()) {
            return;
        }
        InlineClassHelperKt.throwIllegalStateException("Unprocessed FocusTarget nodes");
    }
}
