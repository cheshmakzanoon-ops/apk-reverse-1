package androidx.compose.runtime.changelist;

import androidx.compose.runtime.Anchor;
import androidx.compose.runtime.Applier;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.PreconditionsKt;
import androidx.compose.runtime.RememberManager;
import androidx.compose.runtime.SlotWriter;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.TypeIntrinsics;

@Metadata(d1 = {"\u0000f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0000\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J\u0006\u0010\n\u001a\u00020\u000bJ&\u0010\f\u001a\u00020\u000b2\u000e\u0010\r\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u000f0\u000e2\u0006\u0010\u0010\u001a\u00020\u00072\u0006\u0010\u0011\u001a\u00020\u0012J\u0006\u0010\u0013\u001a\u00020\u000bJ\"\u0010\u0014\u001a\u00020\u000b2\n\u0010\u0015\u001a\u0006\u0012\u0002\b\u00030\u00162\u0006\u0010\u0017\u001a\u00020\u00182\u0006\u0010\u0019\u001a\u00020\u001aJ\u0006\u0010\u001b\u001a\u00020\u001cJ\u0006\u0010\u001d\u001a\u00020\u001cJ\u0010\u0010\u001e\u001a\u00020\u001f2\u0006\u0010 \u001a\u00020\u001fH\u0016J>\u0010!\u001a\u00020\u000b\"\u0004\b\u0000\u0010\"\"\u0004\b\u0001\u0010#2\u0006\u0010$\u001a\u0002H\"2\u001d\u0010%\u001a\u0019\u0012\u0004\u0012\u0002H#\u0012\u0004\u0012\u0002H\"\u0012\u0004\u0012\u00020\u000b0&¢\u0006\u0002\b'¢\u0006\u0002\u0010(R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0004X\u0082\u0004¢\u0006\u0002\n\u0000R\u0011\u0010\u0006\u001a\u00020\u00078F¢\u0006\u0006\u001a\u0004\b\b\u0010\t¨\u0006)"}, d2 = {"Landroidx/compose/runtime/changelist/FixupList;", "Landroidx/compose/runtime/changelist/OperationsDebugStringFormattable;", "()V", "operations", "Landroidx/compose/runtime/changelist/Operations;", "pendingOperations", "size", "", "getSize", "()I", "clear", "", "createAndInsertNode", "factory", "Lkotlin/Function0;", "", "insertIndex", "groupAnchor", "Landroidx/compose/runtime/Anchor;", "endNodeInsert", "executeAndFlushAllPendingFixups", "applier", "Landroidx/compose/runtime/Applier;", "slots", "Landroidx/compose/runtime/SlotWriter;", "rememberManager", "Landroidx/compose/runtime/RememberManager;", "isEmpty", "", "isNotEmpty", "toDebugString", "", "linePrefix", "updateNode", "V", "T", "value", "block", "Lkotlin/Function2;", "Lkotlin/ExtensionFunctionType;", "(Ljava/lang/Object;Lkotlin/jvm/functions/Function2;)V", "runtime_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class FixupList extends OperationsDebugStringFormattable {
    public static final int $stable = 8;
    private final Operations operations = new Operations();
    private final Operations pendingOperations = new Operations();

    public final int getSize() {
        return this.operations.getOpCodesSize();
    }

    public final boolean isEmpty() {
        return this.operations.isEmpty();
    }

    public final boolean isNotEmpty() {
        return this.operations.isNotEmpty();
    }

    public final void clear() {
        this.pendingOperations.clear();
        this.operations.clear();
    }

    public final void executeAndFlushAllPendingFixups(Applier<?> applier, SlotWriter slots, RememberManager rememberManager) {
        if (!this.pendingOperations.isEmpty()) {
            ComposerKt.composeImmediateRuntimeError("FixupList has pending fixup operations that were not realized. Were there mismatched insertNode() and endNodeInsert() calls?");
        }
        this.operations.executeAndFlushAllPendingOperations(applier, slots, rememberManager);
    }

    public final void createAndInsertNode(Function0<? extends Object> factory, int insertIndex, Anchor groupAnchor) {
        Operations operations = this.operations;
        Operation.InsertNodeFixup insertNodeFixup = Operation.InsertNodeFixup.INSTANCE;
        operations.pushOp(insertNodeFixup);
        Operations operationsM4120constructorimpl = Operations.WriteScope.m4120constructorimpl(operations);
        Operation.InsertNodeFixup insertNodeFixup2 = Operation.InsertNodeFixup.INSTANCE;
        Operations.WriteScope.m4126setObjectDKhxnng(operationsM4120constructorimpl, Operation.ObjectParameter.m4088constructorimpl(0), factory);
        Operation.InsertNodeFixup insertNodeFixup3 = Operation.InsertNodeFixup.INSTANCE;
        Operations.WriteScope.m4125setIntA6tL2VI(operationsM4120constructorimpl, Operation.IntParameter.m4077constructorimpl(0), insertIndex);
        Operation.InsertNodeFixup insertNodeFixup4 = Operation.InsertNodeFixup.INSTANCE;
        int i = 1;
        Operations.WriteScope.m4126setObjectDKhxnng(operationsM4120constructorimpl, Operation.ObjectParameter.m4088constructorimpl(1), groupAnchor);
        if (!(operations.pushedIntMask == operations.createExpectedArgMask(insertNodeFixup.getInts()) && operations.pushedObjectMask == operations.createExpectedArgMask(insertNodeFixup.getObjects()))) {
            StringBuilder sb = new StringBuilder();
            int ints = insertNodeFixup.getInts();
            int i2 = 0;
            int i3 = 0;
            while (i3 < ints) {
                if (((i << i3) & operations.pushedIntMask) != 0) {
                    if (i2 > 0) {
                        sb.append(", ");
                    }
                    sb.append(insertNodeFixup.mo4049intParamNamew8GmfQM(Operation.IntParameter.m4077constructorimpl(i3)));
                    i2++;
                }
                i3++;
                i = 1;
            }
            String string = sb.toString();
            Intrinsics.checkNotNullExpressionValue(string, "StringBuilder().apply(builderAction).toString()");
            StringBuilder sb2 = new StringBuilder();
            int objects = insertNodeFixup.getObjects();
            int i4 = 0;
            int i5 = 0;
            while (i5 < objects) {
                if (((1 << i5) & operations.pushedObjectMask) != 0) {
                    if (i2 > 0) {
                        sb2.append(", ");
                    }
                    sb2.append(insertNodeFixup.mo4050objectParamName31yXWZQ(Operation.ObjectParameter.m4088constructorimpl(i5)));
                    i4++;
                }
                i5++;
                operations = operations;
            }
            String string2 = sb2.toString();
            Intrinsics.checkNotNullExpressionValue(string2, "StringBuilder().apply(builderAction).toString()");
            PreconditionsKt.throwIllegalStateException("Error while pushing " + insertNodeFixup + ". Not all arguments were provided. Missing " + i2 + " int arguments (" + string + ") and " + i4 + " object arguments (" + string2 + ").");
        }
        Operations operations2 = this.pendingOperations;
        Operation.PostInsertNodeFixup postInsertNodeFixup = Operation.PostInsertNodeFixup.INSTANCE;
        operations2.pushOp(postInsertNodeFixup);
        Operations operationsM4120constructorimpl2 = Operations.WriteScope.m4120constructorimpl(operations2);
        Operation.PostInsertNodeFixup postInsertNodeFixup2 = Operation.PostInsertNodeFixup.INSTANCE;
        Operations.WriteScope.m4125setIntA6tL2VI(operationsM4120constructorimpl2, Operation.IntParameter.m4077constructorimpl(0), insertIndex);
        Operation.PostInsertNodeFixup postInsertNodeFixup3 = Operation.PostInsertNodeFixup.INSTANCE;
        Operations.WriteScope.m4126setObjectDKhxnng(operationsM4120constructorimpl2, Operation.ObjectParameter.m4088constructorimpl(0), groupAnchor);
        if (operations2.pushedIntMask == operations2.createExpectedArgMask(postInsertNodeFixup.getInts()) && operations2.pushedObjectMask == operations2.createExpectedArgMask(postInsertNodeFixup.getObjects())) {
            return;
        }
        StringBuilder sb3 = new StringBuilder();
        int ints2 = postInsertNodeFixup.getInts();
        int i6 = 0;
        for (int i7 = 0; i7 < ints2; i7++) {
            if (((1 << i7) & operations2.pushedIntMask) != 0) {
                if (i6 > 0) {
                    sb3.append(", ");
                }
                sb3.append(postInsertNodeFixup.mo4049intParamNamew8GmfQM(Operation.IntParameter.m4077constructorimpl(i7)));
                i6++;
            }
        }
        String string3 = sb3.toString();
        Intrinsics.checkNotNullExpressionValue(string3, "StringBuilder().apply(builderAction).toString()");
        StringBuilder sb4 = new StringBuilder();
        int objects2 = postInsertNodeFixup.getObjects();
        int i8 = 0;
        int i9 = 0;
        while (i9 < objects2) {
            if (((1 << i9) & operations2.pushedObjectMask) != 0) {
                if (i6 > 0) {
                    sb4.append(", ");
                }
                sb4.append(postInsertNodeFixup.mo4050objectParamName31yXWZQ(Operation.ObjectParameter.m4088constructorimpl(i9)));
                i8++;
            }
            i9++;
            operations2 = operations2;
        }
        String string4 = sb4.toString();
        Intrinsics.checkNotNullExpressionValue(string4, "StringBuilder().apply(builderAction).toString()");
        PreconditionsKt.throwIllegalStateException("Error while pushing " + postInsertNodeFixup + ". Not all arguments were provided. Missing " + i6 + " int arguments (" + string3 + ") and " + i8 + " object arguments (" + string4 + ").");
    }

    public final void endNodeInsert() {
        if (!this.pendingOperations.isNotEmpty()) {
            ComposerKt.composeImmediateRuntimeError("Cannot end node insertion, there are no pending operations that can be realized.");
        }
        this.pendingOperations.popInto(this.operations);
    }

    public final <V, T> void updateNode(V value, Function2<? super T, ? super V, Unit> block) {
        Operations operations = this.operations;
        Operation.UpdateNode updateNode = Operation.UpdateNode.INSTANCE;
        operations.pushOp(updateNode);
        Operations operationsM4120constructorimpl = Operations.WriteScope.m4120constructorimpl(operations);
        Operation.UpdateNode updateNode2 = Operation.UpdateNode.INSTANCE;
        Operations.WriteScope.m4126setObjectDKhxnng(operationsM4120constructorimpl, Operation.ObjectParameter.m4088constructorimpl(0), value);
        Operation.UpdateNode updateNode3 = Operation.UpdateNode.INSTANCE;
        int iM4088constructorimpl = Operation.ObjectParameter.m4088constructorimpl(1);
        Intrinsics.checkNotNull(block, "null cannot be cast to non-null type @[ExtensionFunctionType] kotlin.Function2<kotlin.Any?, kotlin.Any?, kotlin.Unit>");
        Operations.WriteScope.m4126setObjectDKhxnng(operationsM4120constructorimpl, iM4088constructorimpl, (Function2) TypeIntrinsics.beforeCheckcastToFunctionOfArity(block, 2));
        if (operations.pushedIntMask == operations.createExpectedArgMask(updateNode.getInts()) && operations.pushedObjectMask == operations.createExpectedArgMask(updateNode.getObjects())) {
            return;
        }
        StringBuilder sb = new StringBuilder();
        int ints = updateNode.getInts();
        int i = 0;
        for (int i2 = 0; i2 < ints; i2++) {
            if (((1 << i2) & operations.pushedIntMask) != 0) {
                if (i > 0) {
                    sb.append(", ");
                }
                sb.append(updateNode.mo4049intParamNamew8GmfQM(Operation.IntParameter.m4077constructorimpl(i2)));
                i++;
            }
        }
        String string = sb.toString();
        Intrinsics.checkNotNullExpressionValue(string, "StringBuilder().apply(builderAction).toString()");
        StringBuilder sb2 = new StringBuilder();
        int objects = updateNode.getObjects();
        int i3 = 0;
        for (int i4 = 0; i4 < objects; i4++) {
            if (((1 << i4) & operations.pushedObjectMask) != 0) {
                if (i > 0) {
                    sb2.append(", ");
                }
                sb2.append(updateNode.mo4050objectParamName31yXWZQ(Operation.ObjectParameter.m4088constructorimpl(i4)));
                i3++;
            }
        }
        String string2 = sb2.toString();
        Intrinsics.checkNotNullExpressionValue(string2, "StringBuilder().apply(builderAction).toString()");
        PreconditionsKt.throwIllegalStateException("Error while pushing " + updateNode + ". Not all arguments were provided. Missing " + i + " int arguments (" + string + ") and " + i3 + " object arguments (" + string2 + ").");
    }

    @Override
    public String toDebugString(String linePrefix) {
        StringBuilder sb = new StringBuilder();
        sb.append("FixupList instance containing " + getSize() + " operations");
        if (sb.length() > 0) {
            sb.append(":\n" + this.operations.toDebugString(linePrefix));
        }
        String string = sb.toString();
        Intrinsics.checkNotNullExpressionValue(string, "StringBuilder().apply(builderAction).toString()");
        return string;
    }
}
