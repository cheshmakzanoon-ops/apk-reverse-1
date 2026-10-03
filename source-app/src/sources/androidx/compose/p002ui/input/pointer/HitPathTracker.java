package androidx.compose.p002ui.input.pointer;

import androidx.collection.MutableLongObjectMap;
import androidx.collection.MutableObjectList;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.layout.LayoutCoordinates;
import androidx.compose.runtime.collection.MutableVector;
import java.util.List;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000V\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\t\n\u0002\b\u0002\b\u0000\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J0\u0010\r\u001a\u00020\u000e2\u0006\u0010\u000f\u001a\u00020\u00102\f\u0010\u0011\u001a\b\u0012\u0004\u0012\u00020\u00130\u00122\b\b\u0002\u0010\u0014\u001a\u00020\u0015ø\u0001\u0000¢\u0006\u0004\b\u0016\u0010\u0017J\u0006\u0010\u0018\u001a\u00020\u000eJ\u0018\u0010\u0019\u001a\u00020\u00152\u0006\u0010\u001a\u001a\u00020\u001b2\b\b\u0002\u0010\u001c\u001a\u00020\u0015J\u0006\u0010\u001d\u001a\u00020\u000eJ\u0006\u0010\u001e\u001a\u00020\u000eJ\u001e\u0010\u001f\u001a\u00020\u000e2\u0006\u0010\u000f\u001a\u00020 2\f\u0010!\u001a\b\u0012\u0004\u0012\u00020\b0\u0007H\u0002R\u001a\u0010\u0005\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\b0\u00070\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\t\u001a\u00020\nX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\""}, d2 = {"Landroidx/compose/ui/input/pointer/HitPathTracker;", "", "rootCoordinates", "Landroidx/compose/ui/layout/LayoutCoordinates;", "(Landroidx/compose/ui/layout/LayoutCoordinates;)V", "hitPointerIdsAndNodes", "Landroidx/collection/MutableLongObjectMap;", "Landroidx/collection/MutableObjectList;", "Landroidx/compose/ui/input/pointer/Node;", "root", "Landroidx/compose/ui/input/pointer/NodeParent;", "getRoot$ui_release", "()Landroidx/compose/ui/input/pointer/NodeParent;", "addHitPath", "", "pointerId", "Landroidx/compose/ui/input/pointer/PointerId;", "pointerInputNodes", "", "Landroidx/compose/ui/Modifier$Node;", "prunePointerIdsAndChangesNotInNodesList", "", "addHitPath-QJqDSyo", "(JLjava/util/List;Z)V", "clearPreviouslyHitModifierNodeCache", "dispatchChanges", "internalPointerEvent", "Landroidx/compose/ui/input/pointer/InternalPointerEvent;", "isInBounds", "processCancel", "removeDetachedPointerInputNodes", "removeInvalidPointerIdsAndChanges", "", "hitNodes", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class HitPathTracker {
    public static final int $stable = 8;
    private final LayoutCoordinates rootCoordinates;
    private final NodeParent root = new NodeParent();
    private final MutableLongObjectMap<MutableObjectList<Node>> hitPointerIdsAndNodes = new MutableLongObjectMap<>(10);

    public HitPathTracker(LayoutCoordinates layoutCoordinates) {
        this.rootCoordinates = layoutCoordinates;
    }

    public final NodeParent getRoot() {
        return this.root;
    }

    public static void m5773addHitPathQJqDSyo$default(HitPathTracker hitPathTracker, long j, List list, boolean z, int i, Object obj) {
        if ((i & 4) != 0) {
            z = false;
        }
        hitPathTracker.m5774addHitPathQJqDSyo(j, list, z);
    }

    public final void m5774addHitPathQJqDSyo(long pointerId, List<? extends Modifier.Node> pointerInputNodes, boolean prunePointerIdsAndChangesNotInNodesList) {
        MutableLongObjectMap<MutableObjectList<Node>> mutableLongObjectMap;
        MutableObjectList<Node> mutableObjectList;
        Node node;
        NodeParent nodeParent = this.root;
        this.hitPointerIdsAndNodes.clear();
        int size = pointerInputNodes.size();
        boolean z = true;
        for (int i = 0; i < size; i++) {
            Modifier.Node node2 = pointerInputNodes.get(i);
            if (z) {
                MutableVector<Node> children = nodeParent.getChildren();
                int size2 = children.getSize();
                if (size2 <= 0) {
                    node = null;
                    break;
                }
                Node[] content = children.getContent();
                int i2 = 0;
                while (true) {
                    node = content[i2];
                    if (Intrinsics.areEqual(node.getModifierNode(), node2)) {
                        break;
                    }
                    i2++;
                    if (i2 >= size2) {
                        node = null;
                        break;
                    }
                }
                Node node3 = node;
                if (node3 != null) {
                    node3.markIsIn();
                    node3.getPointerIds().m5964add0FcD4WY(pointerId);
                    MutableLongObjectMap<MutableObjectList<Node>> mutableLongObjectMap2 = this.hitPointerIdsAndNodes;
                    MutableObjectList<Node> mutableObjectList2 = mutableLongObjectMap2.get(pointerId);
                    if (mutableObjectList2 == null) {
                        mutableObjectList2 = new MutableObjectList<>(0, 1, null);
                        mutableLongObjectMap2.set(pointerId, mutableObjectList2);
                    }
                    mutableObjectList2.add(node3);
                    nodeParent = node3;
                } else {
                    z = false;
                    Node node4 = new Node(node2);
                    node4.getPointerIds().m5964add0FcD4WY(pointerId);
                    mutableLongObjectMap = this.hitPointerIdsAndNodes;
                    mutableObjectList = mutableLongObjectMap.get(pointerId);
                    if (mutableObjectList == null) {
                        mutableObjectList = new MutableObjectList<>(0, 1, null);
                        mutableLongObjectMap.set(pointerId, mutableObjectList);
                    }
                    mutableObjectList.add(node4);
                    nodeParent.getChildren().add(node4);
                    nodeParent = node4;
                }
            } else {
                Node node5 = new Node(node2);
                node5.getPointerIds().m5964add0FcD4WY(pointerId);
                mutableLongObjectMap = this.hitPointerIdsAndNodes;
                mutableObjectList = mutableLongObjectMap.get(pointerId);
                if (mutableObjectList == null) {
                    mutableObjectList = new MutableObjectList<>(0, 1, null);
                    mutableLongObjectMap.set(pointerId, mutableObjectList);
                }
                mutableObjectList.add(node5);
                nodeParent.getChildren().add(node5);
                nodeParent = node5;
            }
        }
        if (!prunePointerIdsAndChangesNotInNodesList) {
            return;
        }
        MutableLongObjectMap<MutableObjectList<Node>> mutableLongObjectMap3 = this.hitPointerIdsAndNodes;
        long[] jArr = mutableLongObjectMap3.keys;
        Object[] objArr = mutableLongObjectMap3.values;
        long[] jArr2 = mutableLongObjectMap3.metadata;
        int length = jArr2.length - 2;
        if (length < 0) {
            return;
        }
        int i3 = 0;
        while (true) {
            long j = jArr2[i3];
            if ((((~j) << 7) & j & (-9187201950435737472L)) != -9187201950435737472L) {
                int i4 = 8 - ((~(i3 - length)) >>> 31);
                for (int i5 = 0; i5 < i4; i5++) {
                    if ((255 & j) < 128) {
                        int i6 = (i3 << 3) + i5;
                        removeInvalidPointerIdsAndChanges(jArr[i6], (MutableObjectList) objArr[i6]);
                    }
                    j >>= 8;
                }
                if (i4 != 8) {
                    return;
                }
            }
            if (i3 == length) {
                return;
            } else {
                i3++;
            }
        }
    }

    private final void removeInvalidPointerIdsAndChanges(long pointerId, MutableObjectList<Node> hitNodes) {
        this.root.removeInvalidPointerIdsAndChanges(pointerId, hitNodes);
    }

    public static boolean dispatchChanges$default(HitPathTracker hitPathTracker, InternalPointerEvent internalPointerEvent, boolean z, int i, Object obj) {
        if ((i & 2) != 0) {
            z = true;
        }
        return hitPathTracker.dispatchChanges(internalPointerEvent, z);
    }

    public final boolean dispatchChanges(InternalPointerEvent internalPointerEvent, boolean isInBounds) {
        if (this.root.buildCache(internalPointerEvent.getChanges(), this.rootCoordinates, internalPointerEvent, isInBounds)) {
            return this.root.dispatchFinalEventPass(internalPointerEvent) || this.root.dispatchMainEventPass(internalPointerEvent.getChanges(), this.rootCoordinates, internalPointerEvent, isInBounds);
        }
        return false;
    }

    public final void clearPreviouslyHitModifierNodeCache() {
        this.root.clear();
    }

    public final void processCancel() {
        this.root.dispatchCancel();
        clearPreviouslyHitModifierNodeCache();
    }

    public final void removeDetachedPointerInputNodes() {
        this.root.removeDetachedPointerInputModifierNodes();
    }
}
