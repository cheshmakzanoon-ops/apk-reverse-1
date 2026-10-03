package androidx.compose.runtime.changelist;

import androidx.compose.runtime.Anchor;
import androidx.compose.runtime.ComposerImpl;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.Composition;
import androidx.compose.runtime.CompositionContext;
import androidx.compose.runtime.ControlledComposition;
import androidx.compose.runtime.IntStack;
import androidx.compose.runtime.MovableContentState;
import androidx.compose.runtime.MovableContentStateReference;
import androidx.compose.runtime.RememberObserver;
import androidx.compose.runtime.SlotReader;
import androidx.compose.runtime.SlotTable;
import androidx.compose.runtime.Stack;
import androidx.compose.runtime.internal.IntRef;
import java.util.List;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;

@Metadata(d1 = {"\u0000®\u0001\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0002\b\u0005\n\u0002\u0010\b\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010 \n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u000e\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0017\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\b\b\u0000\u0018\u0000 \u0081\u00012\u00020\u0001:\u0002\u0081\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\u0018\u0010#\u001a\u00020$2\u0006\u0010%\u001a\u00020&2\b\u0010'\u001a\u0004\u0018\u00010\u0001J\u001e\u0010(\u001a\u00020$2\u000e\u0010)\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00010*2\u0006\u0010+\u001a\u00020,J(\u0010-\u001a\u00020$2\b\u0010.\u001a\u0004\u0018\u00010/2\u0006\u00100\u001a\u0002012\u0006\u00102\u001a\u0002032\u0006\u00104\u001a\u000203J\u0006\u00105\u001a\u00020$J\u0016\u00106\u001a\u00020$2\u0006\u00107\u001a\u00020,2\u0006\u0010%\u001a\u00020&J\"\u00108\u001a\u00020$2\u0012\u00109\u001a\u000e\u0012\u0004\u0012\u00020;\u0012\u0004\u0012\u00020$0:2\u0006\u0010<\u001a\u00020;J\u0006\u0010=\u001a\u00020$J\u0006\u0010>\u001a\u00020$J\u0006\u0010?\u001a\u00020$J\u0016\u0010@\u001a\u00020$2\u0006\u0010A\u001a\u00020\u00122\u0006\u0010B\u001a\u00020\u0012J\u0006\u0010C\u001a\u00020$J\u0010\u0010D\u001a\u00020$2\u0006\u0010%\u001a\u00020&H\u0002J\b\u0010E\u001a\u00020$H\u0002J\u0006\u0010F\u001a\u00020$J\u001a\u0010G\u001a\u00020$2\u0006\u0010H\u001a\u00020\u00052\n\b\u0002\u0010+\u001a\u0004\u0018\u00010,J\u0016\u0010I\u001a\u00020$2\u0006\u0010%\u001a\u00020&2\u0006\u00102\u001a\u00020JJ\u001e\u0010I\u001a\u00020$2\u0006\u0010%\u001a\u00020&2\u0006\u00102\u001a\u00020J2\u0006\u0010K\u001a\u00020LJ\u000e\u0010M\u001a\u00020$2\u0006\u0010N\u001a\u00020\u0012J\u0010\u0010O\u001a\u00020$2\b\u0010P\u001a\u0004\u0018\u00010\u0001J\u001e\u0010Q\u001a\u00020$2\u0006\u00102\u001a\u00020\u00122\u0006\u00104\u001a\u00020\u00122\u0006\u0010R\u001a\u00020\u0012J\u000e\u0010S\u001a\u00020$2\u0006\u0010T\u001a\u00020\u0012J\u000e\u0010U\u001a\u00020$2\u0006\u0010T\u001a\u00020\u0012J\u0006\u0010V\u001a\u00020$J\b\u0010W\u001a\u00020$H\u0002J\b\u0010X\u001a\u00020$H\u0002J\b\u0010Y\u001a\u00020$H\u0002J\u0012\u0010Z\u001a\u00020$2\b\b\u0002\u0010[\u001a\u00020\fH\u0002J \u0010\\\u001a\u00020$2\u0006\u00104\u001a\u00020\u00122\u0006\u00102\u001a\u00020\u00122\u0006\u0010R\u001a\u00020\u0012H\u0002J\b\u0010]\u001a\u00020$H\u0002J\u0012\u0010^\u001a\u00020$2\b\b\u0002\u0010_\u001a\u00020\fH\u0002J\u0018\u0010`\u001a\u00020$2\u0006\u0010\u001e\u001a\u00020\u00122\u0006\u0010\u0011\u001a\u00020\u0012H\u0002J\u0006\u0010a\u001a\u00020$J\u0006\u0010b\u001a\u00020$J\u001e\u0010c\u001a\u00020$2\u0006\u0010<\u001a\u00020d2\u0006\u00100\u001a\u0002012\u0006\u0010e\u001a\u000203J\u000e\u0010f\u001a\u00020$2\u0006\u0010'\u001a\u00020gJ\u0006\u0010h\u001a\u00020$J\u0016\u0010i\u001a\u00020$2\u0006\u0010A\u001a\u00020\u00122\u0006\u0010R\u001a\u00020\u0012J\u0006\u0010j\u001a\u00020$J\u0006\u0010k\u001a\u00020$J\u0014\u0010l\u001a\u00020$2\f\u0010m\u001a\b\u0012\u0004\u0012\u00020$0nJ\u0006\u0010o\u001a\u00020$J\u000e\u0010p\u001a\u00020$2\u0006\u0010R\u001a\u00020\u0012J \u0010q\u001a\u00020$2\b\u0010'\u001a\u0004\u0018\u00010\u00012\u0006\u0010%\u001a\u00020&2\u0006\u0010r\u001a\u00020\u0012J\u0010\u0010s\u001a\u00020$2\b\u0010t\u001a\u0004\u0018\u00010\u0001J>\u0010u\u001a\u00020$\"\u0004\b\u0000\u0010v\"\u0004\b\u0001\u0010w2\u0006\u0010'\u001a\u0002Hw2\u001d\u0010x\u001a\u0019\u0012\u0004\u0012\u0002Hv\u0012\u0004\u0012\u0002Hw\u0012\u0004\u0012\u00020$0y¢\u0006\u0002\bz¢\u0006\u0002\u0010{J\u0018\u0010|\u001a\u00020$2\b\u0010'\u001a\u0004\u0018\u00010\u00012\u0006\u0010r\u001a\u00020\u0012J\u0010\u0010}\u001a\u00020$2\b\u0010P\u001a\u0004\u0018\u00010\u0001J\u001f\u0010~\u001a\u00020$2\u0006\u0010\u007f\u001a\u00020\u00052\f\u0010x\u001a\b\u0012\u0004\u0012\u00020$0nH\u0086\bJ\u0018\u0010\u0080\u0001\u001a\u00020$2\f\u0010x\u001a\b\u0012\u0004\u0012\u00020$0nH\u0086\bR\u001a\u0010\u0004\u001a\u00020\u0005X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0007\u0010\b\"\u0004\b\t\u0010\nR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u001a\u0010\u000b\u001a\u00020\fX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\r\u0010\u000e\"\u0004\b\u000f\u0010\u0010R\u000e\u0010\u0011\u001a\u00020\u0012X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0013\u001a\u00020\u0012X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0014\u001a\u00020\u0012X\u0082\u000e¢\u0006\u0002\n\u0000R\u0011\u0010\u0015\u001a\u00020\f8F¢\u0006\u0006\u001a\u0004\b\u0016\u0010\u000eR\u0016\u0010\u0017\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00010\u0018X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0019\u001a\u00020\u0012X\u0082\u000e¢\u0006\u0002\n\u0000R\u0014\u0010\u001a\u001a\u00020\u001b8BX\u0082\u0004¢\u0006\u0006\u001a\u0004\b\u001c\u0010\u001dR\u000e\u0010\u001e\u001a\u00020\u0012X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u001f\u001a\u00020\fX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010 \u001a\u00020!X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\"\u001a\u00020\u0012X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0082\u0001"}, d2 = {"Landroidx/compose/runtime/changelist/ComposerChangeListWriter;", "", "composer", "Landroidx/compose/runtime/ComposerImpl;", "changeList", "Landroidx/compose/runtime/changelist/ChangeList;", "(Landroidx/compose/runtime/ComposerImpl;Landroidx/compose/runtime/changelist/ChangeList;)V", "getChangeList", "()Landroidx/compose/runtime/changelist/ChangeList;", "setChangeList", "(Landroidx/compose/runtime/changelist/ChangeList;)V", "implicitRootStart", "", "getImplicitRootStart", "()Z", "setImplicitRootStart", "(Z)V", "moveCount", "", "moveFrom", "moveTo", "pastParent", "getPastParent", "pendingDownNodes", "Landroidx/compose/runtime/Stack;", "pendingUps", "reader", "Landroidx/compose/runtime/SlotReader;", "getReader", "()Landroidx/compose/runtime/SlotReader;", "removeFrom", "startedGroup", "startedGroups", "Landroidx/compose/runtime/IntStack;", "writersReaderDelta", "appendValue", "", "anchor", "Landroidx/compose/runtime/Anchor;", "value", "copyNodesToNewAnchorLocation", "nodes", "", "effectiveNodeIndex", "Landroidx/compose/runtime/internal/IntRef;", "copySlotTableToAnchorLocation", "resolvedState", "Landroidx/compose/runtime/MovableContentState;", "parentContext", "Landroidx/compose/runtime/CompositionContext;", "from", "Landroidx/compose/runtime/MovableContentStateReference;", "to", "deactivateCurrentGroup", "determineMovableContentNodeIndex", "effectiveNodeIndexOut", "endCompositionScope", "action", "Lkotlin/Function1;", "Landroidx/compose/runtime/Composition;", "composition", "endCurrentGroup", "endMovableContentPlacement", "endNodeMovement", "endNodeMovementAndDeleteNode", "nodeIndex", "group", "endRoot", "ensureGroupStarted", "ensureRootStarted", "finalizeComposition", "includeOperationsIn", "other", "insertSlots", "Landroidx/compose/runtime/SlotTable;", "fixups", "Landroidx/compose/runtime/changelist/FixupList;", "moveCurrentGroup", "offset", "moveDown", "node", "moveNode", "count", "moveReaderRelativeTo", "location", "moveReaderToAbsolute", "moveUp", "pushApplierOperationPreamble", "pushPendingUpsAndDowns", "pushSlotEditingOperationPreamble", "pushSlotTableOperationPreamble", "useParentSlot", "realizeMoveNode", "realizeNodeMovementOperations", "realizeOperationLocation", "forParent", "realizeRemoveNode", "recordSlotEditing", "releaseMovableContent", "releaseMovableGroupAtCurrent", "Landroidx/compose/runtime/ControlledComposition;", "reference", "remember", "Landroidx/compose/runtime/RememberObserver;", "removeCurrentGroup", "removeNode", "resetSlots", "resetTransientState", "sideEffect", "effect", "Lkotlin/Function0;", "skipToEndOfCurrentGroup", "trimValues", "updateAnchoredValue", "groupSlotIndex", "updateAuxData", "data", "updateNode", "T", "V", "block", "Lkotlin/Function2;", "Lkotlin/ExtensionFunctionType;", "(Ljava/lang/Object;Lkotlin/jvm/functions/Function2;)V", "updateValue", "useNode", "withChangeList", "newChangeList", "withoutImplicitRootStart", "Companion", "runtime_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class ComposerChangeListWriter {
    private static final int invalidGroupLocation = -2;
    private ChangeList changeList;
    private final ComposerImpl composer;
    private int moveCount;
    private int pendingUps;
    private boolean startedGroup;
    private int writersReaderDelta;
    public static final int $stable = 8;
    private final IntStack startedGroups = new IntStack();
    private boolean implicitRootStart = true;
    private Stack<Object> pendingDownNodes = new Stack<>();
    private int removeFrom = -1;
    private int moveFrom = -1;
    private int moveTo = -1;

    public ComposerChangeListWriter(ComposerImpl composerImpl, ChangeList changeList) {
        this.composer = composerImpl;
        this.changeList = changeList;
    }

    public final ChangeList getChangeList() {
        return this.changeList;
    }

    public final void setChangeList(ChangeList changeList) {
        this.changeList = changeList;
    }

    private final SlotReader getReader() {
        return this.composer.getReader();
    }

    public final boolean getImplicitRootStart() {
        return this.implicitRootStart;
    }

    public final void setImplicitRootStart(boolean z) {
        this.implicitRootStart = z;
    }

    private final void pushApplierOperationPreamble() {
        pushPendingUpsAndDowns();
    }

    private final void pushSlotEditingOperationPreamble() {
        realizeOperationLocation$default(this, false, 1, null);
        recordSlotEditing();
    }

    static void pushSlotTableOperationPreamble$default(ComposerChangeListWriter composerChangeListWriter, boolean z, int i, Object obj) {
        if ((i & 1) != 0) {
            z = false;
        }
        composerChangeListWriter.pushSlotTableOperationPreamble(z);
    }

    private final void pushSlotTableOperationPreamble(boolean useParentSlot) {
        realizeOperationLocation(useParentSlot);
    }

    public final void moveReaderRelativeTo(int location) {
        this.writersReaderDelta += location - getReader().getCurrentGroup();
    }

    public final void moveReaderToAbsolute(int location) {
        this.writersReaderDelta = location;
    }

    public final void recordSlotEditing() {
        SlotReader reader;
        int parent;
        if (getReader().getGroupsSize() <= 0 || this.startedGroups.peekOr(-2) == (parent = (reader = getReader()).getParent())) {
            return;
        }
        ensureRootStarted();
        if (parent > 0) {
            Anchor anchor = reader.anchor(parent);
            this.startedGroups.push(parent);
            ensureGroupStarted(anchor);
        }
    }

    private final void ensureRootStarted() {
        if (this.startedGroup || !this.implicitRootStart) {
            return;
        }
        pushSlotTableOperationPreamble$default(this, false, 1, null);
        this.changeList.pushEnsureRootStarted();
        this.startedGroup = true;
    }

    private final void ensureGroupStarted(Anchor anchor) {
        pushSlotTableOperationPreamble$default(this, false, 1, null);
        this.changeList.pushEnsureGroupStarted(anchor);
        this.startedGroup = true;
    }

    static void realizeOperationLocation$default(ComposerChangeListWriter composerChangeListWriter, boolean z, int i, Object obj) {
        if ((i & 1) != 0) {
            z = false;
        }
        composerChangeListWriter.realizeOperationLocation(z);
    }

    private final void realizeOperationLocation(boolean forParent) {
        int parent = forParent ? getReader().getParent() : getReader().getCurrentGroup();
        int i = parent - this.writersReaderDelta;
        if (!(i >= 0)) {
            ComposerKt.composeImmediateRuntimeError("Tried to seek backward");
        }
        if (i > 0) {
            this.changeList.pushAdvanceSlotsBy(i);
            this.writersReaderDelta = parent;
        }
    }

    public final boolean getPastParent() {
        return getReader().getParent() - this.writersReaderDelta < 0;
    }

    public final void withChangeList(ChangeList newChangeList, Function0<Unit> block) {
        ChangeList changeList = getChangeList();
        try {
            setChangeList(newChangeList);
            block.invoke();
        } finally {
            setChangeList(changeList);
        }
    }

    public final void withoutImplicitRootStart(Function0<Unit> block) {
        boolean implicitRootStart = getImplicitRootStart();
        try {
            setImplicitRootStart(false);
            block.invoke();
        } finally {
            setImplicitRootStart(implicitRootStart);
        }
    }

    public final void remember(RememberObserver value) {
        this.changeList.pushRemember(value);
    }

    public final void updateValue(Object value, int groupSlotIndex) {
        pushSlotTableOperationPreamble(true);
        this.changeList.pushUpdateValue(value, groupSlotIndex);
    }

    public final void updateAnchoredValue(Object value, Anchor anchor, int groupSlotIndex) {
        this.changeList.pushUpdateAnchoredValue(value, anchor, groupSlotIndex);
    }

    public final void appendValue(Anchor anchor, Object value) {
        this.changeList.pushAppendValue(anchor, value);
    }

    public final void trimValues(int count) {
        if (count > 0) {
            pushSlotEditingOperationPreamble();
            this.changeList.pushTrimValues(count);
        }
    }

    public final void resetSlots() {
        this.changeList.pushResetSlots();
    }

    public final void updateAuxData(Object data) {
        pushSlotTableOperationPreamble$default(this, false, 1, null);
        this.changeList.pushUpdateAuxData(data);
    }

    public final void endRoot() {
        if (this.startedGroup) {
            pushSlotTableOperationPreamble$default(this, false, 1, null);
            pushSlotTableOperationPreamble$default(this, false, 1, null);
            this.changeList.pushEndCurrentGroup();
            this.startedGroup = false;
        }
    }

    public final void endCurrentGroup() {
        int parent = getReader().getParent();
        if (!(this.startedGroups.peekOr(-1) <= parent)) {
            ComposerKt.composeImmediateRuntimeError("Missed recording an endGroup");
        }
        if (this.startedGroups.peekOr(-1) == parent) {
            pushSlotTableOperationPreamble$default(this, false, 1, null);
            this.startedGroups.pop();
            this.changeList.pushEndCurrentGroup();
        }
    }

    public final void skipToEndOfCurrentGroup() {
        this.changeList.pushSkipToEndOfCurrentGroup();
    }

    public final void removeCurrentGroup() {
        pushSlotEditingOperationPreamble();
        this.changeList.pushRemoveCurrentGroup();
        this.writersReaderDelta += getReader().getGroupSize();
    }

    public final void insertSlots(Anchor anchor, SlotTable from) {
        pushPendingUpsAndDowns();
        pushSlotEditingOperationPreamble();
        realizeNodeMovementOperations();
        this.changeList.pushInsertSlots(anchor, from);
    }

    public final void insertSlots(Anchor anchor, SlotTable from, FixupList fixups) {
        pushPendingUpsAndDowns();
        pushSlotEditingOperationPreamble();
        realizeNodeMovementOperations();
        this.changeList.pushInsertSlots(anchor, from, fixups);
    }

    public final void moveCurrentGroup(int offset) {
        pushSlotEditingOperationPreamble();
        this.changeList.pushMoveCurrentGroup(offset);
    }

    public final void endCompositionScope(Function1<? super Composition, Unit> action, Composition composition) {
        this.changeList.pushEndCompositionScope(action, composition);
    }

    public final void useNode(Object node) {
        pushApplierOperationPreamble();
        this.changeList.pushUseNode(node);
    }

    public final <T, V> void updateNode(V value, Function2<? super T, ? super V, Unit> block) {
        pushApplierOperationPreamble();
        this.changeList.pushUpdateNode(value, block);
    }

    public final void removeNode(int nodeIndex, int count) {
        if (count > 0) {
            if (!(nodeIndex >= 0)) {
                ComposerKt.composeImmediateRuntimeError("Invalid remove index " + nodeIndex);
            }
            if (this.removeFrom == nodeIndex) {
                this.moveCount += count;
                return;
            }
            realizeNodeMovementOperations();
            this.removeFrom = nodeIndex;
            this.moveCount = count;
        }
    }

    public final void moveNode(int from, int to, int count) {
        if (count > 0) {
            int i = this.moveCount;
            if (i > 0 && this.moveFrom == from - i && this.moveTo == to - i) {
                this.moveCount = i + count;
                return;
            }
            realizeNodeMovementOperations();
            this.moveFrom = from;
            this.moveTo = to;
            this.moveCount = count;
        }
    }

    public final void releaseMovableContent() {
        pushPendingUpsAndDowns();
        if (this.startedGroup) {
            skipToEndOfCurrentGroup();
            endRoot();
        }
    }

    public final void endNodeMovement() {
        realizeNodeMovementOperations();
    }

    public final void endNodeMovementAndDeleteNode(int nodeIndex, int group) {
        endNodeMovement();
        pushPendingUpsAndDowns();
        int iNodeCount = getReader().isNode(group) ? 1 : getReader().nodeCount(group);
        if (iNodeCount > 0) {
            removeNode(nodeIndex, iNodeCount);
        }
    }

    private final void realizeNodeMovementOperations() {
        int i = this.moveCount;
        if (i > 0) {
            int i2 = this.removeFrom;
            if (i2 >= 0) {
                realizeRemoveNode(i2, i);
                this.removeFrom = -1;
            } else {
                realizeMoveNode(this.moveTo, this.moveFrom, i);
                this.moveFrom = -1;
                this.moveTo = -1;
            }
            this.moveCount = 0;
        }
    }

    private final void realizeRemoveNode(int removeFrom, int moveCount) {
        pushApplierOperationPreamble();
        this.changeList.pushRemoveNode(removeFrom, moveCount);
    }

    private final void realizeMoveNode(int to, int from, int count) {
        pushApplierOperationPreamble();
        this.changeList.pushMoveNode(to, from, count);
    }

    public final void moveUp() {
        realizeNodeMovementOperations();
        if (this.pendingDownNodes.isNotEmpty()) {
            this.pendingDownNodes.pop();
        } else {
            this.pendingUps++;
        }
    }

    public final void moveDown(Object node) {
        realizeNodeMovementOperations();
        this.pendingDownNodes.push(node);
    }

    private final void pushPendingUpsAndDowns() {
        int i = this.pendingUps;
        if (i > 0) {
            this.changeList.pushUps(i);
            this.pendingUps = 0;
        }
        if (this.pendingDownNodes.isNotEmpty()) {
            this.changeList.pushDowns(this.pendingDownNodes.toArray());
            this.pendingDownNodes.clear();
        }
    }

    public final void sideEffect(Function0<Unit> effect) {
        this.changeList.pushSideEffect(effect);
    }

    public final void determineMovableContentNodeIndex(IntRef effectiveNodeIndexOut, Anchor anchor) {
        pushPendingUpsAndDowns();
        this.changeList.pushDetermineMovableContentNodeIndex(effectiveNodeIndexOut, anchor);
    }

    public final void copyNodesToNewAnchorLocation(List<? extends Object> nodes, IntRef effectiveNodeIndex) {
        this.changeList.pushCopyNodesToNewAnchorLocation(nodes, effectiveNodeIndex);
    }

    public final void copySlotTableToAnchorLocation(MovableContentState resolvedState, CompositionContext parentContext, MovableContentStateReference from, MovableContentStateReference to) {
        this.changeList.pushCopySlotTableToAnchorLocation(resolvedState, parentContext, from, to);
    }

    public final void releaseMovableGroupAtCurrent(ControlledComposition composition, CompositionContext parentContext, MovableContentStateReference reference) {
        this.changeList.pushReleaseMovableGroupAtCurrent(composition, parentContext, reference);
    }

    public final void endMovableContentPlacement() {
        this.changeList.pushEndMovableContentPlacement();
        this.writersReaderDelta = 0;
    }

    public static void includeOperationsIn$default(ComposerChangeListWriter composerChangeListWriter, ChangeList changeList, IntRef intRef, int i, Object obj) {
        if ((i & 2) != 0) {
            intRef = null;
        }
        composerChangeListWriter.includeOperationsIn(changeList, intRef);
    }

    public final void includeOperationsIn(ChangeList other, IntRef effectiveNodeIndex) {
        this.changeList.pushExecuteOperationsIn(other, effectiveNodeIndex);
    }

    public final void finalizeComposition() {
        pushPendingUpsAndDowns();
        if (this.startedGroups.isEmpty()) {
            return;
        }
        ComposerKt.composeImmediateRuntimeError("Missed recording an endGroup()");
    }

    public final void resetTransientState() {
        this.startedGroup = false;
        this.startedGroups.clear();
        this.writersReaderDelta = 0;
    }

    public final void deactivateCurrentGroup() {
        pushSlotTableOperationPreamble$default(this, false, 1, null);
        this.changeList.pushDeactivateCurrentGroup();
    }
}
